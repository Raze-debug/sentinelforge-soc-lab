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

| SF-010 | Vulnerability finding validation | Compare Wazuh package inventory, vendor affected-version data, installed source, and a safe regression test | Determine whether the reported CVE applies to the installed package | CVE-2026-3087 on Python 3.13.15: vendor range excludes 3.13.15; installed ZIP extraction guard and harmless regression test passed; Wazuh NVD CPE condition was broader (<= 3.14.4); documented as false positive in `docs/vulnerability-investigations.md` | PASS (false positive identified) |
| SF-011 | Windows failed interactive logon | Make one controlled incorrect-password attempt on the Windows 11 lab VM | Security Event ID 4625 reaches Wazuh and matches an authentication-failure rule | SF-WIN11-01 (agent 001): Event ID 4625 collected; Wazuh rule 60122, "Logon Failure - Unknown user or bad password", level 5; one alert observed | PASS |

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

## Validated Windows failed-authentication details

- Test ID: SF-011.
- Endpoint: SF-WIN11-01, agent ID 001.
- Environment: Windows 11 VirtualBox endpoint; Wazuh 4.14.9 single-node deployment.
- Controlled test: one intentionally incorrect password during a local interactive sign-in.
- Windows Security event: Event ID 4625, provider `Microsoft-Windows-Security-Auditing`.
- Event time: 2026-11-17 21:35:06 IST.
- Failed account: `windows11_vm`.
- Logon type: 2 (Interactive).
- Status: `0xc000006d`; substatus: `0xc000006a` (incorrect password).
- Wazuh decoder: `windows_eventchannel`.
- Wazuh location: `EventChannel`.
- Wazuh rule: 60122, "Logon Failure - Unknown user or bad password".
- Rule level: 5; observed fired-times value: 1.
- Rule groups: `windows`, `windows_security`, `authentication_failed`.
- Threat Hunting query: `agent.id: "001" AND data.win.system.eventID: "4625"`.
- Dashboard result: one matching alert for SF-WIN11-01.
- The event's source address was loopback (`127.0.0.1`); this was a local interactive logon failure, not a remote network login.
- Rule metadata includes MITRE technique T1531. This is rule metadata and does not establish that account removal occurred.
- Status: PASS — Windows event generation, agent collection, Wazuh rule matching and dashboard visibility verified.

## Validated Windows repeated failed-authentication detection

- Test ID: SF-012.
- Test date: 2026-11-18 (IST).
- Endpoint: SF-WIN11-01, agent ID 001, IP 192.168.56.101.
- Environment: Windows 11 VirtualBox endpoint; Wazuh 4.14.9 single-node deployment.
- Test account: `SFLockoutTest`, dedicated non-administrator local account.
- Controlled test: repeated incorrect-password attempts using local interactive logon (logon type 2).
- Windows Security event: Event ID 4625, provider `Microsoft-Windows-Security-Auditing`.
- Failure status: `0xc000006d`; substatus: `0xc000006a` (incorrect password).
- Failed account: `SFLockoutTest`.
- Source address: `::1` (localhost IPv6).
- Wazuh decoder: `windows_eventchannel`.
- Wazuh location: `EventChannel`.
- Individual Wazuh rule: 60122, "Logon Failure - Unknown user or bad password", level 5.
- Correlation Wazuh rule: 60204, "Multiple Windows Logon Failures", level 10.
- Correlation frequency: 8 failed events.
- Correlation fired-times value: 1.
- Correlation groups: `windows`, `windows_security`, `authentication_failures`.
- MITRE mapping: T1110 (Brute Force), Credential Access.
- Threat Hunting query used to filter test activity by agent, Event ID 4625, and target account `SFLockoutTest`.
- Dashboard result: 9 matching alerts — 8 individual failed-logon alerts and 1 multiple-failure correlation alert.
- Evidence: `evidence/SF-012-windows-failed-login/`.
- Evidence files: `wazuh-alert-overview.png`, `wazuh-alert-details.png`, `wazuh-correlation-60204.json`.
- Account-lockout verification: Event ID 4740 was not observed in the queried Security log period; actual account lockout was not confirmed.
- Limitations: validation used local interactive authentication failures against a dedicated test account; it does not establish detection coverage for remote authentication, other logon types, or all brute-force scenarios.
- Status: PASS — Windows Event 4625 generation, Wazuh collection, individual failed-logon alerting, and Level 10 repeated-failure correlation verified. Actual account lockout remains unverified.

## Validated Windows local user account creation detection

- Test ID: SF-013.
- Test date: 2026-11-21.
- Environment: Windows 11 VirtualBox endpoint; Wazuh 4.14.9 single-node deployment.
- Controlled test: created a local test account named `SF013_TestUser`.
- Windows Security event: Event ID 4720, "A user account was created."
- Event provider: `Microsoft-Windows-Security-Auditing`.
- Audit result: `AUDIT_SUCCESS`.
- Creator account: `windows11_vm`.
- Target account: `SF013_TestUser`.
- Wazuh decoder: `windows_eventchannel`.
- Wazuh rule: 60109, "User account enabled or created."
- Alert level: 8.
- Observed fired-times value: 1.
- Rule groups: `windows`, `windows_security`, `adduser`, `account_changed`.
- Account attributes reported: Account Disabled; Password Not Required - Enabled; Normal Account - Enabled.
- MITRE mapping: T1098 (Account Manipulation), Persistence.
- Validation result: Wazuh successfully collected Windows Event ID 4720 and generated the corresponding level 8 alert for the controlled account creation.
- Limitation: the event reported the target account as disabled. This validation confirms account creation detection, not account activation or subsequent use.
- Evidence directory: `evidence/SF-013-windows-account-creation/`.
- Evidence files: `sf013-alert-overview.png`, `sf013-event-summary.json`.
- Status: PASS — Windows account-creation event generation, Wazuh collection, rule matching, and dashboard visibility verified.
