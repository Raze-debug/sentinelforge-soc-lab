# Detection Validation Register

This register tracks what the lab actually detects. Observed fields are populated only after running the test and inspecting telemetry.

## Status definitions

- **NOT TESTED** — test has not been run.
- **PASS** — expected evidence was observed and recorded.
- **FAIL** — test ran but expected evidence was not observed.
- **BLOCKED** — the test could not be completed due to a prerequisite or environmental issue.
- **INCONCLUSIVE** — evidence is insufficient to decide.

## Test cases

| ID | Scenario | Safe test method | Expected evidence | Observed result | Status |
|---|---|---|---|---|---|
| SF-001 | Windows agent connectivity | Check agent status in Wazuh manager/dashboard | Agent shown active/connected | SF-WIN11-01 (agent 001), Wazuh 4.14.9, reported Active in manager and dashboard | PASS |
| SF-002 | Windows authentication telemetry | Generate a benign interactive sign-in/unlock on the lab Windows VM | Windows successful-logon event reaches Wazuh and matches an authentication rule | Windows Security Event ID 4624, logon type 2 (Interactive); six matching alerts in Wazuh under rule 60118, “Windows Workstation Logon Success”, level 3 | PASS |
| SF-003 | File created in test folder | Create a harmless file in C:\SentinelForge-FIM-Test | File-integrity event with path and action | One alert: rule 554, “File added to the system”, level 5, for the test-file creation | PASS |
| SF-004 | File modified in test folder | Modify the same test file | Change event appears | One alert: rule 550, “Integrity checksum changed”, level 7 | PASS |
| SF-005 | File deleted in test folder | Delete the same test file | Deletion event appears | One alert: rule 553, “File deleted”, level 7 | PASS |
| SF-006 | Suricata service health | Validate configuration, service status, interface and EVE output | Configuration valid; service active; EVE events recorded | Suricata 8.0.8 configuration test passed; service active; AF_PACKET capture configured on host-only interface `vboxnet0`; EVE JSON written to `/var/log/suricata/eve.json` | PASS |
| SF-007 | Suricata event generation | Send four authorized ICMP echo requests from the Windows lab endpoint to the Parrot host | Matching custom rule appears in EVE JSON | Four alert events matched local SID 1000001, “SentinelForge TEST Windows ICMP echo request”; source Windows lab endpoint, destination Parrot host; event times 2026-11-14 11:26:58–11:27:01 IST | PASS |
| SF-008 | Suricata-to-SIEM forwarding | Configure Wazuh JSON localfile collection and search for the test event | Event decoded, matched by Wazuh and visible in Threat Hunting | Read-only bind mount of EVE JSON was readable by the manager; logcollector reported analyzing the file; JSON decoder extracted event fields; Wazuh rule 86601 (level 3, groups `ids` and `suricata`) generated four alerts; dashboard query returned 4 hits | PASS |
| SF-009 | Asset register review | Inventory the lab-owned host, endpoint and logical sensor component | Known assets, purpose, responsibility and lab-relative criticality recorded | Manual register populated for the Parrot/Wazuh host, Windows endpoint and Suricata sensor service hosted on the Parrot system; no network-wide discovery claim | PASS |

## Validated Windows authentication details

- Endpoint: SF-WIN11-01, agent ID 001.
- Agent version: Wazuh 4.14.9.
- Windows event: Security Event ID 4624 (successful logon).
- Interactive logon type observed: 2.
- Wazuh rule: 60118 — Windows Workstation Logon Success.
- Rule level: 3.
- The query for rule 60106 returned no rows during this test, while the Event ID 4624 search returned six matching alerts under rule 60118. Record the observed child rule rather than reporting the test as failed.

## Validated file-integrity details

- Endpoint: SF-WIN11-01, agent ID 001.
- Test directory: `C:\SentinelForge-FIM-Test`.
- Configuration: a real-time directories entry was added to the existing Windows agent syscheck configuration.
- File used: `fim-create-test.txt`.
- Create: rule 554, “File added to the system”, level 5; one matching alert.
- Modify: rule 550, “Integrity checksum changed”, level 7; one matching alert.
- Delete: rule 553, “File deleted”, level 7; one matching alert.
- The test directory was dedicated to this validation and the same test file was used for the three operations.
- The agent service was confirmed Running after the configuration was validated and the service was started.

## Validated network-detection and SIEM-integration details

**Environment**
- Sensor host: Parrot Security 7.4.
- Suricata: 8.0.8.
- Wazuh: 4.14.9 single-node Docker deployment.
- Capture interface: `vboxnet0`, the VirtualBox host-only lab segment.
- Capture method: AF_PACKET.
- Suricata EVE output: `/var/log/suricata/eve.json`.
- The EVE file is mounted read-only into the Wazuh manager and collected using a JSON `localfile` entry.
- Wazuh manager's logcollector reported: `Analyzing file: '/var/log/suricata/eve.json'`.

**Controlled test**
- Date/time: 2026-11-14, 11:26:58–11:27:01 IST (UTC+05:30).
- Source: Windows lab endpoint SF-WIN11-01.
- Destination: Parrot/Wazuh host.
- Traffic: four ICMP echo requests; Windows ping reported four replies and 0% packet loss.
- Local Suricata rule: SID 1000001, revision 1, “SentinelForge TEST Windows ICMP echo request”.
- Suricata EVE: four matching `event_type: alert` records, with source/destination, protocol, interface and signature metadata.
- Suricata action field: `allowed`. This is expected because Suricata is operating as a passive IDS sensor; the test did not block traffic.
- Wazuh decoder: `json`.
- Wazuh rule: 86601, “Suricata: Alert - SentinelForge TEST Windows ICMP echo request”, level 3, groups `ids` and `suricata`.
- Wazuh manager identity in alerts: agent ID 000 (`wazuh.manager`), because this is a manager-side log collection source rather than a Windows-agent event.
- Dashboard validation: Threat Hunting query `rule.id:86601 AND data.alert.signature_id:1000001` returned **4 hits**.

**Visibility limitation**
- This test proves visibility of the tested Windows-to-Parrot traffic on the host-only interface only.
- It does not prove visibility into all traffic on the physical LAN, NAT interface, internet, other VLANs, or other endpoints.
- Suricata in this lab is a passive IDS; no IPS blocking or automated containment was validated.

## Detailed result template

For each test, record:

- Test ID and date/time (include timezone).
- Exact environment/component version.
- Preconditions and test steps.
- Expected behavior.
- Actual behavior and evidence location.
- Whether the test was repeated.
- Relevant rule/configuration.
- Likely false positives or limitations.
- Final status and next action.

Use sanitized screenshots or synthetic examples in the public repository. Keep raw logs locally if they contain sensitive information. Screenshots reviewed during the November 10, 2026 validation session should be added to the evidence folder only after checking for usernames, private addresses, tokens, and other sensitive details.

## Interpretation caution

A passing test demonstrates only that the specific tested path worked under the recorded conditions. It does not prove complete detection coverage. A failed test may indicate collection, network visibility, rule, timing, or test-design issues; investigate the full path before concluding why it failed.
