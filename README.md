# SentinelForge — SOC Monitoring & Threat Investigation Lab

**Status:** Wazuh core, Windows endpoint telemetry, file-integrity detection, and Suricata-to-Wazuh network-alert ingestion are deployed and validated. Asset context and incident-investigation workflows are documented; final evidence and repository polish remain.

**Approach:** Established defensive tools, controlled validation, investigation workflows, and documented evidence—not a large custom application.

SentinelForge is a hands-on SOC lab for practicing endpoint monitoring, SIEM triage, file-integrity monitoring, network alert analysis, asset context, and incident investigation. The goal is a reproducible, interview-ready portfolio with evidence for each implemented capability.

> **Current status:** Wazuh 4.14.9 runs as a single-node Docker stack on the Parrot OS host. The Windows 11 VirtualBox endpoint SF-WIN11-01 (agent 001) is enrolled. Windows authentication, file creation/modification/deletion, and a controlled Suricata-to-Wazuh ICMP alert path have produced matching Wazuh alerts.

## Objectives

- Collect and review endpoint telemetry.
- Centralize and investigate events in a SIEM.
- Validate authentication and file-integrity detections with controlled tests.
- Collect network telemetry with Suricata and analyze its alerts in Wazuh.
- Maintain an asset register and use context to prioritize investigations.
- Develop repeatable incident playbooks and detection-validation records.
- Document architecture, configuration choices, troubleshooting, and sanitized evidence.

## Implemented tools and planned additions

| Capability | Tool | Status / purpose |
|---|---|---|
| SIEM and endpoint monitoring | Wazuh 4.14.9 | Deployed as a single-node Docker stack; manager, indexer, and dashboard verified |
| Windows endpoint | Windows 11 + Wazuh Agent 4.14.9 | Enrolled; SF-WIN11-01 (agent 001) Active |
| Authentication detection | Wazuh Windows rules | Interactive successful-logon Event ID 4624 / rule 60118 validated |
| File integrity monitoring | Wazuh Syscheck/FIM | Real-time monitoring; create/modify/delete tests passed (rules 554/550/553) |
| Network intrusion detection | Suricata 8.0.8 | AF_PACKET sensor on the VirtualBox host-only interface; custom ICMP alert validated |
| Network alert forwarding | Suricata EVE JSON + Wazuh JSON localfile | Read-only log mount, JSON decoding, rule 86601, and dashboard search validated |
| Asset context | Manual Markdown register | Lab host, Windows endpoint, and logical sensor component recorded |
| Asset discovery | NetAlertX (optional) | Deferred; no automatic network-wide discovery claim |
| Additional dashboards | Grafana (optional) | Deferred until there is a clear use case |

## Current lab architecture

1. **Parrot OS host:** administration workstation and Docker host for Wazuh; also hosts the Suricata sensor process.
2. **Wazuh stack:** manager, indexer, and dashboard using the official 4.14.9 single-node Docker deployment.
3. **Windows 11 endpoint:** VirtualBox VM with the Wazuh 4.14.9 agent, Windows event collection, and a dedicated FIM test directory.
4. **Lab network:** Windows VM uses NAT and a host-only interface for controlled communication with the Parrot host.
5. **Network sensor:** Suricata 8.0.8 captures on the host-only interface `vboxnet0` and writes EVE JSON to `/var/log/suricata/eve.json`.
6. **SIEM forwarding:** the EVE file is mounted read-only into the Wazuh manager and collected using a JSON `localfile` entry. Wazuh rule 86601 generated four alerts for the controlled ICMP test; the dashboard search returned four hits.

Management services must not be exposed directly to the public internet. The Wazuh dashboard is bound to host loopback.

**Visibility boundary:** this setup validates only traffic visible on the VirtualBox host-only interface. It does not provide visibility into every physical-LAN device, NAT flow, internet connection, VLAN, or endpoint. Suricata is operating as a passive IDS; blocking was not tested.

## Roadmap

- [x] **Phase 0 — Readiness:** CPU, RAM, disk, virtualization, resource constraints, and lab network assessment.
- [x] **Phase 1 — Core SIEM:** Deploy Wazuh and verify service health and dashboard access.
- [x] **Phase 2 — Endpoint telemetry:** Enroll Windows and verify security events arrive.
- [x] **Phase 3 — Detection validation:** Validate interactive authentication and file creation, modification, and deletion.
- [x] **Phase 4 — Network detection:** Deploy Suricata and validate EVE JSON ingestion through Wazuh to the dashboard.
- [x] **Phase 5 — Asset context:** Populate a manual lab asset register and record component roles and limitations.
- [x] **Phase 6 — Investigation workflows:** Document authentication, FIM, and network-alert triage; complete one controlled network-alert investigation record.
- [ ] **Phase 7 — Reporting:** Add sanitized screenshots, finalize case-study presentation, and perform the final repository/security review.

## Documentation

- [Architecture](docs/architecture.md) — deployed components, data flows, and trust boundaries.
- [Roadmap](docs/roadmap.md) — phased work and acceptance criteria.
- [Lab notes](docs/lab-notes.md) — commands, observations, errors, and fixes.
- [Detection validation](docs/detection-validation.md) — expected versus observed outcomes.
- [Incident playbooks](docs/incident-playbooks.md) — repeatable investigation steps and a completed controlled case.
- [Asset register](docs/asset-register-template.md) — lab asset context.
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

## Current validation status

| Milestone | Status |
|---|---|
| Public repository and initial documentation | Complete |
| Host capacity assessment | Complete; constrained laptop resources are documented |
| Wazuh core deployment | Complete — indexer GREEN; manager and dashboard verified |
| Windows agent installation and enrollment | Complete — SF-WIN11-01, ID 001, Active |
| Windows Security-event ingestion | Complete — Security-channel events visible in Wazuh |
| Interactive Windows authentication detection | Complete — Event ID 4624, logon type 2, rule 60118, level 3 |
| File creation detection | Complete — rule 554, level 5 |
| File modification detection | Complete — rule 550, level 7 |
| File deletion detection | Complete — rule 553, level 7 |
| Suricata service and EVE event generation | Complete — Suricata 8.0.8, custom SID 1000001 |
| Suricata-to-Wazuh ingestion | Complete — JSON decoder and rule 86601, level 3 |
| Dashboard verification | Complete — four matching hits for the controlled ICMP test |
| Asset register | Complete — manual inventory of lab-owned assets/components |
| Incident workflows | Complete — authentication, FIM, network triage; one controlled case documented |
| Sanitized screenshots and final repository review | Remaining |

## Next step

Complete Phase 7: add sanitized dashboard and service-validation evidence, review the repository for secrets and unnecessary identifying data, verify the README and reproduction instructions, then commit and push the final documentation.
