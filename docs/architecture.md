# SentinelForge Architecture

**Status:** Proposed design; not deployed or validated yet.

## Design goals

- Keep the initial lab small enough to run on a laptop.
- Establish an observable endpoint-to-SIEM path before adding more tools.
- Separate management access from monitored/test traffic where practical.
- Keep tests authorized and reproducible.
- Record assumptions and validate each connection instead of assuming it works.

## Logical components

```text
Windows 11 endpoint
  └─ Wazuh Agent
       └─ endpoint events / configured file-integrity events
            └─ Wazuh Manager
                 └─ Wazuh Indexer
                      └─ Wazuh Dashboard

Authorized lab/test traffic
  └─ Suricata sensor (planned)
       └─ EVE JSON alerts
            └─ integration/forwarding path to be configured and verified

Asset register (manual first; discovery tool optional)
  └─ owner, purpose, criticality, expected services, known limitations
       └─ investigation context and prioritization
```

The diagram represents the intended logical flow only. It is not evidence that the components are installed, connected, or producing events.

## Planned placement

| Component | Candidate placement | Decision criteria |
|---|---|---|
| Wazuh all-in-one | Ubuntu Server VM | Actual memory/disk headroom, official requirements, stable operation |
| Windows agent | Windows 11 endpoint/VM | Network reachability to manager and compatibility |
| Suricata | Parrot OS host or dedicated lab VM | Which interface sees the traffic and whether capture is practical |
| Asset register | Repository Markdown/CSV template | Start manually; avoid unnecessary services |
| NetAlertX | Optional container/service | Add only after core SIEM works and discovery requirements are understood |
| Grafana | Optional later | Add only when a concrete dashboard use case justifies added resources |

## Network and trust boundaries

- Prefer an isolated host-only/internal network for lab-only traffic when feasible.
- If the Windows endpoint must reach a VM on NAT or bridged networking, document the route and limit access to required ports.
- Bridged networking can expose lab services to the physical LAN; do not assume it is isolated.
- Do not expose Wazuh, indexer, Grafana, or NetAlertX management ports directly to the public internet.
- Use unique strong credentials and store generated credentials outside the repository.
- Keep sensor capture scope to owned or explicitly authorized traffic. A switched network usually does not provide visibility into every other device's unicast traffic.

## Event flow to verify

1. Windows agent is running and enrolled.
2. The manager reports that the agent is connected.
3. A benign endpoint event is generated.
4. The event is visible in the appropriate Wazuh view/index.
5. For file-integrity monitoring, a test file in a dedicated lab directory is created, modified, and deleted.
6. Expected events are observed and recorded, including timestamp and limitations.
7. Only then should the milestone be marked complete.

## Resource planning

Do not assign VM resources based on old measurements. First record live output from `free -h`, `nproc`, `df -h /`, and `lscpu`. Keep sufficient memory for the Parrot host and desktop. If official recommended Wazuh resources do not fit safely, reduce scope or use a separate machine rather than forcing an unstable deployment.

## Known limitations to record

- A laptop lab is not a production SOC and does not provide enterprise-scale resilience.
- Detection coverage depends on collection settings, rules, versions, network visibility, and test cases.
- A missing alert does not prove a threat would be undetected in all circumstances.
- Cross-source correlation must document the time window, matching fields, assumptions, and false-positive considerations.
