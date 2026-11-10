# SentinelForge Roadmap

Move forward only when the current phase meets its acceptance criteria. Do not mark work complete solely because an installer exited successfully.

## Phase 0 — Readiness

**Goal:** Determine whether the laptop can host planned components safely.

Tasks:
- [x] Record Parrot OS version, kernel, CPU, RAM, free disk space, and virtualization support.
- [x] Confirm the hypervisor in use: VirtualBox.
- [x] Record Windows 11 as a VirtualBox VM.
- [x] Document NAT + Host-only networking and the Parrot/Windows lab connection.
- [x] Check official Wazuh installation and resource requirements.
- [x] Allocate 4 GiB RAM and 2 CPU cores to Windows; monitor host memory during combined operation.

Acceptance criteria:
- [x] Resource output saved locally or summarized without unique identifiers.
- [x] Host/guest and network layout documented.
- [x] Core Wazuh + Windows Agent workload tested; memory headroom remains limited and is monitored.

## Phase 1 — Core SIEM

**Goal:** Establish a functioning Wazuh all-in-one deployment, if resources permit.

Tasks:
- [x] Review official Wazuh documentation and prerequisites.
- [x] Deploy the official Wazuh 4.14.9 single-node Docker stack on the Parrot OS host.
- [x] Save generated credentials securely outside Git.
- [x] Confirm manager/indexer health and dashboard access; dashboard is bound to localhost.
- [ ] Capture a sanitized verification screenshot.

Acceptance criteria:
- [x] Dashboard login works.
- [x] Manager/indexer services are healthy according to official checks.
- [x] No credentials or unredacted private details are committed.

## Phase 2 — Windows endpoint telemetry

**Goal:** Enroll a Windows endpoint and verify its telemetry reaches Wazuh.

Tasks:
- [x] Install the Wazuh 4.14.9 Windows Agent package.
- [x] Enroll the endpoint using the Wazuh enrollment service.
- [x] Verify the agent is Active in the manager and dashboard.
- [x] Generate a benign Windows interactive logon and locate the resulting event in the SIEM.
- [x] Record the observed Event ID, Wazuh rule, and result.

Acceptance criteria:
- [x] Agent connection confirmed for SF-WIN11-01 (ID 001).
- [x] Windows Security-channel events are visible in Wazuh.
- [x] Interactive successful-logon Event ID 4624 was observed as Wazuh rule 60118, level 3.

## Phase 3 — File integrity and validation

**Goal:** Verify real-time file-integrity detection on a dedicated Windows test directory.

Tasks:
- [x] Create C:\SentinelForge-FIM-Test and add it to the existing syscheck configuration with realtime="yes".
- [x] Validate the Windows agent configuration as XML.
- [x] Create a harmless test file and verify the corresponding alert.
- [x] Modify the same test file and verify the corresponding alert.
- [x] Delete the same test file and verify the corresponding alert.
- [x] Record the rule IDs and observed outcomes in the detection-validation register.

Acceptance criteria:
- [x] File creation detected: rule 554, level 5.
- [x] File modification detected: rule 550, level 7.
- [x] File deletion detected: rule 553, level 7.
- [x] Tests used a dedicated folder and did not modify personal or Windows system files.

## Phase 4 — Network detection

**Goal:** Add a network sensor and document the limits of its traffic visibility.

Tasks:
- [ ] Identify the network interface to monitor and the traffic visible on it.
- [ ] Install Suricata using the current supported package/docs.
- [ ] Validate its configuration before starting capture.
- [ ] Confirm service health and inspect EVE output.
- [ ] Generate only benign/authorized test traffic suitable for the enabled rules.
- [ ] If forwarding logs to Wazuh, verify integration end to end.

Acceptance criteria:
- [ ] Sensor interface and visibility limitations are documented.
- [ ] A supported test alert or event is observed and recorded.
- [ ] No claim of full network visibility is made without evidence.

## Phase 5 — Asset context

Tasks:
- [ ] Populate the asset register with lab devices only.
- [ ] Record purpose, responsible role, expected services, and relative criticality.
- [ ] Optionally deploy NetAlertX if resources and network conditions justify it.
- [ ] Compare discovery observations with the manually maintained register.

Acceptance criteria:
- [ ] Known assets and criticality rationale are documented.
- [ ] Unknown devices are treated as investigation leads, not automatically malicious.

## Phase 6 — Incident investigation workflows

Tasks:
- [ ] Document triage workflow for repeated failed logins.
- [ ] Document file-integrity change investigation.
- [ ] Document suspicious network alert investigation.
- [ ] Define how to correlate timestamps, host, user, source/destination, and evidence.
- [ ] Include false-positive checks and evidence preservation.

Acceptance criteria:
- [ ] Playbooks include scope, steps, evidence, decision points, escalation, and closure notes.
- [ ] At least one controlled scenario is followed from event to documented conclusion.

## Phase 7 — Reporting and polish

Tasks:
- [ ] Add sanitized screenshots and short case-study write-ups.
- [ ] Summarize coverage tested and limitations.
- [ ] Optionally add Grafana only for a clear use case.
- [ ] Review README for reproducibility and secret leakage.
- [ ] Record lessons learned and next improvements.

Acceptance criteria:
- [ ] A reviewer can understand the architecture, reproduce documented tests, and distinguish verified facts from plans.

## Current milestone

**Phase 4 — Network detection: next.** Wazuh 4.14.9 is deployed, Windows endpoint SF-WIN11-01 (ID 001) is Active, interactive authentication detection is validated, and file creation/modification/deletion detection passed in C:\SentinelForge-FIM-Test. Next, assess interface visibility and resource impact before deploying Suricata.
