# SentinelForge — SOC Monitoring & Threat Investigation Lab

**Status:** Planning and host assessment
**Approach:** Established defensive tools, configuration, controlled validation, and documented investigations—not a large custom application.

SentinelForge is a hands-on SOC lab for practicing endpoint monitoring, SIEM triage, network alert analysis, and incident investigation. The goal is a reproducible, interview-ready portfolio with evidence for each implemented capability.

> **Current status:** Repository initialized; lab components are not yet claimed to be installed, connected, or tested. Each milestone will be marked complete only after its checks succeed.

## Objectives

- Collect and review endpoint telemetry.
- Centralize and investigate events in a SIEM.
- Validate authentication and file-integrity detections with controlled tests.
- Add network intrusion detection and analyze its alerts.
- Maintain an asset register and use context to prioritize investigations.
- Develop repeatable incident playbooks and detection-validation records.
- Document architecture, configuration choices, troubleshooting, and sanitized evidence.

## Planned tools

| Capability | Candidate tool | Purpose |
|---|---|---|
| SIEM and endpoint monitoring | Wazuh | Central events, endpoint agent, rules, dashboards and file-integrity monitoring |
| Windows endpoint | Windows 11 + Wazuh Agent | Endpoint telemetry |
| Network intrusion detection | Suricata | Alerts on traffic visible to the configured sensor |
| Asset discovery | NetAlertX (optional) | Discover devices visible to the lab network |
| Dashboards | Wazuh dashboard first; Grafana optional later | Review patterns and communicate findings |

Tools will be introduced incrementally, depending on hardware resources and compatibility.

## Planned architecture

1. **Parrot OS host:** administration workstation and possible Suricata sensor.
2. **Ubuntu Server VM:** planned home for Wazuh, pending the resource check.
3. **Windows 11 endpoint:** planned Wazuh Agent enrollment and controlled validation.
4. **Optional network visibility and dashboards:** only after the core SIEM workflow is verified.

Network layout and VM sizing will be documented after inspecting the actual environment. Management services must not be exposed directly to the public internet.

## Roadmap

- [ ] **Phase 0 — Readiness:** CPU, RAM, disk, virtualization and network assessment.
- [ ] **Phase 1 — Core SIEM:** Deploy Wazuh and verify service health.
- [ ] **Phase 2 — Endpoint telemetry:** Enroll Windows and verify events arrive.
- [ ] **Phase 3 — Detection validation:** Run controlled authentication and file-integrity tests.
- [ ] **Phase 4 — Network detection:** Add Suricata and validate authorized test alerts.
- [ ] **Phase 5 — Asset context:** Create an asset register; consider discovery tooling.
- [ ] **Phase 6 — Investigation workflows:** Cross-source triage, playbooks and detection coverage.
- [ ] **Phase 7 — Reporting:** Add sanitized evidence, case studies and optional dashboards.

## Documentation

- [Architecture](docs/architecture.md) — planned components, data flows, and trust boundaries.
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
| Public repository created | Complete |
| Initial documentation | Complete |
| Host capacity assessment | Complete |
| Wazuh deployment | Restart verified; indexer GREEN; dashboard accessible |
| Windows agent enrollment | Not started |
| Detection validation | Not started |

## Next step

Follow [Phase 0 — Readiness](docs/roadmap.md#phase-0--readiness). Record live system resources before allocating VM memory or CPU.
