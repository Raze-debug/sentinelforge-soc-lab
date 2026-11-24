# SF-017 — Manual Recovery Helper Validation

## Objective

Develop and validate a manually executed recovery helper for the
SentinelForge Wazuh and Suricata lab.

The helper is designed to restore the existing monitoring stack after
the operator manually starts the Windows lab VM.

## Environment

- Host OS: Parrot Security 7.4.
- Wazuh: 4.14.9, single-node Docker deployment.
- Suricata: 8.0.8.
- Docker: 29.9.2.
- Compose: 2.26.1-4.
- Host-only interface: vboxnet0.
- Host-only IPv4: 192.168.56.1/24.
- Dashboard endpoint: local HTTPS, port 8443.

## Recovery helper

Location:

`scripts/sf-recovery.sh`

Execution:

`sudo ./scripts/sf-recovery.sh`

The helper performs the following operations:

1. Checks that vboxnet0 exists.
2. Verifies the expected host-only IPv4 address.
3. Checks Docker and starts it if inactive.
4. Verifies the existing Wazuh Compose file.
5. Starts the existing Wazuh Compose services.
6. Checks that the Indexer, Manager and Dashboard containers are running.
7. Starts Suricata and verifies its active state.
8. Checks the Dashboard HTTP response.

The helper does not start the Windows VM, remove containers,
delete volumes, or configure automatic boot-time execution.

## Validation results

Test date: 2026-11-25
Timezone: IST (UTC+05:30)

| Test | Observed result | Status |
|---|---|---|
| Host-only interface check | vboxnet0 verified | PASS |
| Host-only address check | 192.168.56.1/24 | PASS |
| Docker check | Docker active | PASS |
| Wazuh Indexer | Container running | PASS |
| Wazuh Manager | Container running | PASS |
| Wazuh Dashboard | Container running | PASS |
| Suricata | Service active | PASS |
| Dashboard response | HTTP 302 | PASS |
| Windows connectivity | 5 replies, 0% packet loss | PASS |
| Suricata detection | Five SID 1000001 alerts | PASS |
| Wazuh ingestion | Five rule 86601 alerts | PASS |

## Detection validation

Controlled test:

- Source: Windows 11 lab VM.
- Destination: Parrot host, 192.168.56.1.
- Traffic: five ICMP echo requests.
- Windows ping result: 5 sent, 5 received, 0% loss.

Suricata:

- Interface: vboxnet0.
- Custom SID: 1000001.
- Signature: SentinelForge TEST Windows ICMP echo request.
- Observed events: five.
- Action: allowed.

Wazuh:

- Decoder: json.
- Rule ID: 86601.
- Description: Suricata: Alert - SentinelForge TEST Windows ICMP echo request.
- Rule level: 3.
- Groups: ids, suricata.
- Observed alerts: five.
- Alert source: /var/log/suricata/eve.json.

The five fresh Suricata events were also observed in the Wazuh
manager alerts file.

## Limitations

- This validation tested manual execution of the recovery helper.
- A fresh reboot followed by recovery has not yet been validated.
- Windows VM autostart remains disabled by design.
- The operator must start the Windows VM manually.
- Host-only interface readiness after reboot remains an outstanding
  startup investigation.
- Dashboard HTTP 302 confirms an HTTP redirect, not authenticated
  dashboard functionality.
- The test validates only the controlled Windows-to-Parrot
  host-only traffic path.
- No IPS blocking or automated containment was tested.

## Result

**PASS — Manual recovery-helper validation.**

The helper completed successfully and the controlled five-packet
test traversed the complete detection path:

Windows VM -> VirtualBox host-only network -> Suricata ->
Wazuh Manager.

## Next actions

1. Perform a controlled reboot-based recovery test.
2. Investigate host-only interface initialization after boot.
3. Review and improve service-readiness checks.
4. Rotate previously exposed Wazuh credentials before public release.
5. Add sanitized evidence to the SF-017 evidence directory.
