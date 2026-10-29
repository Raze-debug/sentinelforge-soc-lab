# SentinelForge Roadmap

Move forward only when the current phase meets its acceptance criteria. Do not mark work complete solely because an installer exited successfully.

## Phase 0 — Readiness

**Goal:** Determine whether the laptop can host planned components safely.

Tasks:
- [ ] Record Parrot OS version, kernel, CPU, RAM, free disk space, and virtualization support.
- [ ] Confirm whether VMware is installed and identify its version if available.
- [ ] Record whether Windows 11 is a physical endpoint or a VM.
- [ ] Sketch the proposed network mode and identify which endpoints must communicate.
- [ ] Check current official installation and resource requirements before deployment.
- [ ] Choose VM resources based on live capacity, leaving room for the host.

Acceptance criteria:
- [ ] Resource output saved locally or summarized without unique identifiers.
- [ ] Host/guest and network layout documented.
- [ ] Deployment plan fits available capacity without starving the host.

## Phase 1 — Core SIEM

**Goal:** Establish a functioning Wazuh all-in-one deployment, if resources permit.

Tasks:
- [ ] Review the official Wazuh quickstart and prerequisites.
- [ ] Install on a supported Ubuntu Server environment.
- [ ] Save generated credentials securely outside Git.
- [ ] Confirm services are healthy and the dashboard is reachable from the intended management network.
- [ ] Capture a sanitized verification screenshot.

Acceptance criteria:
- [ ] Dashboard login works.
- [ ] Manager/indexer services are healthy according to official checks.
- [ ] No credentials or unredacted private details are committed.

## Phase 2 — Windows endpoint telemetry

Tasks:
- [ ] Install the supported Wazuh Agent package on Windows.
- [ ] Enroll the endpoint using the current official procedure.
- [ ] Verify the agent is active in the dashboard.
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

**Phase 0 — Readiness: not started.** Collect local host metrics before deployment.
