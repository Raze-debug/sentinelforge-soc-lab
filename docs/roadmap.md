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
- [ ] Capture a sanitized core-deployment verification screenshot (reporting/evidence task).

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
- [x] Generate a benign Windows interactive sign-in/unlock and locate the resulting event in the SIEM.
- [x] Record the observed Event ID, Wazuh rule, and result.

Acceptance criteria:
- [x] Agent connection confirmed for SF-WIN11-01 (ID 001).
- [x] Windows Security-channel events are visible in Wazuh.
- [x] Interactive successful-logon Event ID 4624 was observed as Wazuh rule 60118, level 3.

## Phase 3 — File integrity and validation

**Goal:** Verify real-time file-integrity detection on a dedicated Windows test directory.

Tasks:
- [x] Create `C:\SentinelForge-FIM-Test` and add it to the existing syscheck configuration with `realtime="yes"`.
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
- [x] Identify the network interface to monitor and the traffic visible on it (`vboxnet0`, the VirtualBox host-only segment).
- [x] Install Suricata 8.0.8 and `suricata-update`.
- [x] Validate its configuration before starting capture.
- [x] Confirm service health and inspect EVE output.
- [x] Generate benign, authorized ICMP test traffic from Windows to the Parrot host.
- [x] Forward EVE JSON to Wazuh through a read-only bind mount and JSON `localfile` collector.
- [x] Verify the event end to end in Wazuh alerts and Threat Hunting.

Acceptance criteria:
- [x] Sensor interface and visibility limitations are documented.
- [x] A supported test alert/event is observed and recorded.
- [x] No claim of full network visibility is made without evidence.
- [x] Wazuh rule 86601 generated four alerts for the controlled test; dashboard search returned four hits.

## Phase 5 — Asset context

Tasks:
- [x] Populate the asset register with the lab host, Windows endpoint, and logical Suricata sensor component.
- [x] Record purpose, responsible role, expected services, and relative criticality.
- [x] Defer optional NetAlertX; the lab remains a manual, scoped inventory.
- [x] Document that no network-wide discovery or unknown-device classification is claimed.

Acceptance criteria:
- [x] Known assets/components and lab-relative criticality rationale are recorded.
- [x] Unknown devices are treated as investigation leads, not automatically malicious.

## Phase 6 — Incident investigation workflows

Tasks:
- [x] Document triage workflow for repeated failed logins.
- [x] Document file-integrity change investigation.
- [x] Document suspicious network alert investigation.
- [x] Define how to correlate timestamps, host, user, source/destination, and evidence.
- [x] Include false-positive checks and evidence preservation.
- [x] Follow one controlled scenario from event to documented conclusion (benign ICMP alert case SF-CASE-001).

Acceptance criteria:
- [x] Playbooks include scope, steps, evidence, decision points, escalation, and closure notes.
- [x] At least one controlled scenario is followed from event to documented conclusion.

## Phase 7 — Reporting and polish

Tasks:
- [x] Summarize tested coverage and visibility limitations.
- [x] Add a concise controlled network-alert case study to the incident playbooks.
- [ ] Add sanitized screenshots of dashboard and service validation.
- [ ] Review README and repository history for secret leakage and unnecessary identifying data.
- [ ] Record final lessons learned and reproducibility notes.

Acceptance criteria:
- [ ] A reviewer can understand the architecture, reproduce documented tests, and distinguish verified facts from plans.
- [ ] Public evidence is sanitized and does not disclose secrets or unnecessary host/user identifiers.

## Current milestone

**Phases 0–6 complete; Phase 7 — Reporting and polish remains.** Wazuh 4.14.9 is deployed, Windows endpoint SF-WIN11-01 (ID 001) is Active, authentication and FIM detections are validated, and Suricata 8.0.8 alerts are successfully collected, decoded, matched by Wazuh rule 86601, and visible in Threat Hunting. The manual asset register and investigation playbooks are populated. Remaining work is sanitized evidence, final repository/security review, and reproducibility polish.
