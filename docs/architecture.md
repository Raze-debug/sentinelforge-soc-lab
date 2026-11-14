# SentinelForge Architecture

**Status:** Core architecture deployed and the tested endpoint, FIM, and network-alert paths validated in the documented lab scope.

## Design goals

- Keep the lab small enough to run on a laptop with constrained resources.
- Establish observable endpoint-to-SIEM and network-sensor-to-SIEM paths.
- Separate management access from monitored/test traffic where practical.
- Keep tests authorized and reproducible.
- Record assumptions and validate each connection instead of assuming it works.

## Deployed logical components

```text
Windows 11 VirtualBox endpoint (SF-WIN11-01)
  └─ Wazuh Agent 4.14.9
       ├─ Windows Security / System / Application telemetry
       └─ Real-time FIM events for the dedicated test directory
                         │
                         ▼
Parrot OS host ── Docker Compose: Wazuh 4.14.9 single node
  ├─ Wazuh Manager
  │    └─ Wazuh Indexer
  │          └─ Wazuh Dashboard (host-loopback binding)
  │
  └─ Suricata 8.0.8 sensor (AF_PACKET on vboxnet0)
       └─ /var/log/suricata/eve.json
            └─ read-only bind mount into Wazuh Manager
                 └─ JSON localfile collector / JSON decoder
                      └─ Wazuh Suricata rule 86601
                           └─ Indexer / Threat Hunting dashboard

Manual asset register ──► investigation context and prioritization
```

The diagram represents the implemented logical flow. The Windows authentication and FIM tests, plus one controlled ICMP network-alert test, were observed in Wazuh. It does not imply complete enterprise or physical-LAN traffic visibility.

## Component placement

| Component | Placement | Verified role |
|---|---|---|
| Wazuh manager, indexer, dashboard | Docker single-node stack on Parrot OS host | Endpoint event analysis, indexing, and dashboard access |
| Windows endpoint | Windows 11 VirtualBox VM | Wazuh agent telemetry, authentication events, FIM test events, authorized ICMP test source |
| Suricata | Native Parrot OS service | AF_PACKET capture on host-only interface `vboxnet0`; EVE JSON output |
| Suricata-to-Wazuh bridge | Read-only host-file bind mount into manager container | JSON log collection and Wazuh rule matching |
| Asset register | Repository Markdown | Manual inventory and lab-relative criticality |
| NetAlertX / Grafana | Not deployed | Optional; deferred to avoid unnecessary resource use |

## Network and trust boundaries

- The Windows VM has NAT and VirtualBox host-only networking. The host-only lab segment is `192.168.56.0/24`.
- Suricata is configured to capture on `vboxnet0`; its `HOME_NET` scope is the lab subnet.
- The validated test was Windows-to-Parrot ICMP traffic across this host-only segment.
- This sensor placement does not provide automatic visibility into unrelated physical-LAN unicast traffic, other VLANs, the NAT interface, or arbitrary internet traffic. A production network sensor would need a deliberately provisioned TAP/SPAN/mirror feed or another appropriate traffic source.
- Do not expose Wazuh, indexer, or dashboard management ports directly to the public internet. The dashboard is bound to host loopback.
- The Suricata EVE file is mounted read-only into the manager container. No active-response or IPS blocking behavior was enabled or validated.
- Use unique strong credentials and store generated credentials outside the repository.

## Verified event flows

### Windows endpoint telemetry

1. Windows Wazuh Agent 4.14.9 is enrolled as SF-WIN11-01 (agent 001).
2. Windows Security Event ID 4624 with logon type 2 was observed and matched Wazuh rule 60118.
3. A dedicated `C:\SentinelForge-FIM-Test` directory was monitored in real time; create, modify, and delete operations matched rules 554, 550, and 553.

### Network telemetry

1. Suricata 8.0.8 captures on `vboxnet0` using AF_PACKET.
2. A local rule (SID 1000001) matches the authorized Windows-to-Parrot ICMP echo requests.
3. Suricata writes JSON alert records to `/var/log/suricata/eve.json`.
4. The file is bind-mounted read-only into the Wazuh manager container and collected with a JSON `localfile` entry.
5. Wazuh's JSON decoder extracts the event fields; rule 86601 generates an IDS/Suricata alert.
6. The controlled test produced four matching records in the Wazuh alert log and four hits in Threat Hunting.

## Resource planning

The deployment runs on a laptop with 11 GiB RAM and no configured swap. Wazuh indexer and the Windows VM have meaningful memory costs. Check live memory before starting the Windows VM with the full stack, avoid adding optional services without a concrete need, and shut down components cleanly when finished.

## Known limitations

- This is a learning lab, not a production SOC or high-availability deployment.
- A single Parrot host runs both Wazuh and the Suricata sensor; failure of that host affects both services.
- Network visibility is limited to the interface and traffic source configured for capture.
- Detection coverage depends on collection settings, rules, versions, network visibility, and test cases.
- A passing test demonstrates only that the specific tested path worked under the recorded conditions.
- The ICMP rule is a controlled lab signature, not a general malicious-traffic detection claim.
- Wazuh rule 86601 generated a level-3 alert; the Suricata `action: allowed` field is expected for this passive IDS setup.
- Cross-source correlation must document the time window, matching fields, assumptions, and false-positive considerations.
