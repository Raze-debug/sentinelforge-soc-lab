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
- [ ] Resource output saved locally or summarized without unique identifiers.
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

Tasks:
- [x] Install the Wazuh 4.14.9 Windows Agent package.
- [x] Enroll the endpoint using the Wazuh enrollment service.
- [x] Verify the agent is Active in the manager and dashboard.
- [ ] Generate a benign event and locate it in the SIEM.
- [ ] Record timestamps, expected outcome, and observed result.

Acceptance criteria:
- [ ] Agent connection confirmed.
- [ ] At least one expected endpoint event is visible and documented.

## Phase 3 — File integrity and validation

Tasks:
- [ ] Configure monitoring for a dedicated test directory, for example `C:\SOC-Lab`.
- [ ] Create, modify, and delete a harmless test file.
- [ ] Confirm corresponding events are received.
- [ ] Record configuration changes and restart/reload steps.
- [ ] Do not monitor personal folders unnecessarily.

Acceptance criteria:
- [ ] Test cases have documented expected and observed results.
- [ ] Validation table distinguishes PASS, FAIL, and NOT TESTED.

## Phase 4 — Network detection

Tasks:
- [ ] Identify the network interface to monitor.
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

**Phase 2 — Windows endpoint telemetry: in progress.** The Windows 11 agent `SF-WIN11-01` (ID 001, Wazuh 4.14.9) is enrolled and Active. Next, verify a benign Windows security event in the Wazuh dashboard before marking this phase complete.
