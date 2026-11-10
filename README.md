# SentinelForge — SOC Monitoring & Threat Investigation Lab

**Status:** Wazuh core and Windows endpoint deployed; Windows authentication and file-integrity detections validated.
**Approach:** Established defensive tools, controlled validation, investigation workflows, and documented evidence—not a large custom application.

SentinelForge is a hands-on SOC lab for practicing endpoint monitoring, SIEM triage, file-integrity monitoring, network alert analysis, and incident investigation. The goal is a reproducible, interview-ready portfolio with evidence for each implemented capability.

> **Current status:** Wazuh 4.14.9 is deployed as a single-node Docker stack on the Parrot OS host. A Windows 11 VirtualBox endpoint is enrolled as SF-WIN11-01 (agent 001). Interactive Windows logon and all three tested file-integrity operations have produced matching Wazuh alerts. Network detection is the next implementation phase.

## Objectives

- Collect and review endpoint telemetry.
- Centralize and investigate events in a SIEM.
- Validate authentication and file-integrity detections with controlled tests.
- Add network intrusion detection and analyze its alerts.
- Maintain an asset register and use context to prioritize investigations.
- Develop repeatable incident playbooks and detection-validation records.
- Document architecture, configuration choices, troubleshooting, and sanitized evidence.

## Implemented tools and planned additions

| Capability | Tool | Status / purpose |
|---|---|---|
| SIEM and endpoint monitoring | Wazuh 4.14.9 | Deployed; manager, indexer and dashboard verified |
| Windows endpoint | Windows 11 + Wazuh Agent 4.14.9 | Enrolled; agent SF-WIN11-01 (001) Active |
| Authentication detection | Wazuh Windows rules | Interactive successful-logon alerts validated |
| File integrity monitoring | Wazuh Syscheck/FIM | Real-time monitoring and create/modify/delete tests passed |
| Network intrusion detection | Suricata | Planned for Phase 4 |
| Asset discovery | NetAlertX (optional) | Consider only after core network detection |
| Additional dashboards | Grafana (optional) | Deferred until there is a clear use case |

## Current lab architecture

1. **Parrot OS host:** administration workstation and Docker host for the Wazuh single-node deployment.
2. **Wazuh stack:** manager, indexer and dashboard using the official 4.14.9 Docker deployment.
3. **Windows 11 endpoint:** VirtualBox VM with the Wazuh 4.14.9 agent.
4. **Lab network:** Windows VM uses NAT and a host-only interface for controlled communication with the Parrot host.
5. **Next component:** Suricata sensor, after its interface visibility and resource impact are assessed.

Management services must not be exposed directly to the public internet. The Wazuh dashboard is bound to host loopback.

## Roadmap

- [x] **Phase 0 — Readiness:** CPU, RAM, disk, virtualization and network assessment.
- [x] **Phase 1 — Core SIEM:** Deploy Wazuh and verify service health.
- [x] **Phase 2 — Endpoint telemetry:** Enroll Windows and verify security events arrive.
- [x] **Phase 3 — Detection validation:** Validate interactive authentication and file creation, modification and deletion.
- [ ] **Phase 4 — Network detection:** Add Suricata and validate authorized test alerts.
- [ ] **Phase 5 — Asset context:** Create an asset register; consider discovery tooling.
- [ ] **Phase 6 — Investigation workflows:** Cross-source triage, playbooks and detection coverage.
- [ ] **Phase 7 — Reporting:** Add sanitized evidence, case studies and optional dashboards.

## Documentation

- [Architecture](docs/architecture.md) — components, data flows, and trust boundaries.
- [Roadmap](docs/roadmap.md) — phased work and acceptance criteria.
- [Lab notes](docs/lab-notes.md) — commands, observations, errors, and fixes.
- [Detection validation](docs/detection-validation.md) — expected versus observed outcomes.
- [Incident playbooks](docs/incident-playbooks.md) — repeatable investigation steps.
- [Asset register template](docs/asset-register-template.md) — lab asset context.
- [Evidence guide](evidence/README.md) — safe screenshots and redaction.

## Principles

- **Evidence over claims:** a capability is complete only after verification.
- **Small steps:** change one component at a time.
- **Explainability:** understand every tool and configuration choice.
- **Safety:** test only on owned or explicitly authorized systems and traffic.
- **Privacy:** never commit credentials, tokens, or unredacted sensitive logs.
- **Resource awareness:** preserve host headroom and add components only when needed.

## Safety scope

This project is for defensive learning and authorized testing. Use sanitized screenshots and synthetic examples in public documentation. Keep credentials, secrets, sensitive host identifiers, and raw sensitive logs out of Git history.

## Current status

| Milestone | Status |
|---|---|
| Public repository and initial documentation | Complete |
| Host capacity assessment | Complete |
| Wazuh core deployment | Complete — indexer GREEN; manager and dashboard verified |
| Windows agent installation and enrollment | Complete — SF-WIN11-01, ID 001, Active |
| Windows Security-event ingestion | Complete — Security-channel events visible in Wazuh |
| Interactive Windows authentication detection | Complete — Event ID 4624, logon type 2, rule 60118, level 3 |
| File creation detection | Complete — rule 554, level 5 |
| File modification detection | Complete — rule 550, level 7 |
| File deletion detection | Complete — rule 553, level 7 |
| Network detection with Suricata | Not started |

## Next step

Begin Phase 4: assess the available network interfaces and choose a safe, useful Suricata sensor location. Document what traffic the sensor can and cannot see before validating alerts.
