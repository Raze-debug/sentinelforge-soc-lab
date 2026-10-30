# SentinelForge Lab Notes

Use one entry per meaningful setup session. Keep the log factual and concise. Do not paste secrets, access tokens, raw sensitive logs, or unredacted private network details.

## Session template

### YYYY-MM-DD — Short title

**Phase:**  
**Goal:**  
**Environment:**

**Actions**
- Command/action:
- Reason:

**Expected result**
- 

**Observed result**
- 

**Verification**
- What exact output, dashboard view, or event confirmed the result?

**Troubleshooting**
- Symptom:
- Cause (only when established):
- Fix:
- Verification after the fix:

**Security/privacy notes**
- Redactions applied:
- Any ports/interfaces exposed:
- Cleanup performed:

**Status:** PASS / FAIL / BLOCKED / NOT TESTED

## Initial repository session

**Date:** 2026-10-29  
**Phase:** Documentation setup  
**Goal:** Create a project plan before changing the system.

- Verified the public GitHub repository and its default branch.
- Prepared the initial architecture and phased roadmap documents for the repository.
- No local system commands have been run as part of this documentation session.
- No SOC services are claimed to be installed or verified.
- Next action: collect live Parrot OS resource and virtualization information.

**Status:** Documentation baseline drafted; host assessment pending.

### 2026-10-29 — Host readiness assessment

**Phase:** 0 — Readiness

**Operating system:** Parrot Security 7.4 (echo)

**Observed host resources**
- CPU: Intel Core i5-4310U, 4 logical CPUs; virtualization support reports VT-x.
- RAM: 11 GiB total; 8.6 GiB available at the time of measurement.
- Swap: None configured.
- Root filesystem: 348 GB available.
- Docker Engine: 29.9.2.
- Docker Compose: 2.26.1-4.
- Docker service: Active.
- Running containers: None.
- vm.max_map_count: 1048576.

**Assessment**

The machine meets the published Wazuh Docker single-node requirements on paper, but CPU and memory are constrained. A native Docker deployment avoids the additional overhead of a separate Ubuntu VM.

**Plan**
- Inspect the official Wazuh Docker configuration before deployment.
- Review port bindings and restrict management access.
- Deploy only the core SIEM initially.
- Monitor RAM, CPU, and container health during startup.
- Add an endpoint only after the core services are healthy.

**Status:** Host assessment recorded; deployment not yet started.

### 2026-10-29 — Wazuh core deployment verified

**Phase:** 1 — Core SIEM

- Deployed the official Wazuh Docker Compose single-node stack, version 4.14.9.
- Wazuh manager, indexer and dashboard containers reported as running.
- Indexer cluster reported GREEN.
- Applied the updated indexer security configuration successfully.
- Verified browser login to https://127.0.0.1:8443.
- Dashboard is bound to loopback only.
- Indexer and agent/API ports are not published to the host for external access.
- Credential file is outside the repository and has permissions 600.
- Certificate generation reported a missing `find` utility, but all nine required certificate/key files were verified as non-empty.

**Resource observations**
- RAM: 11 GiB total; approximately 6.4 GiB available after startup.
- Swap: not configured.
- CPU: four logical CPUs.

**Not yet tested**
- Windows endpoint enrollment.
- Windows security-event collection.
- File-integrity monitoring.
- Suricata network alert ingestion.

**Status:** Core stack running; dashboard login verified.

### 2026-10-30 — Wazuh restart verification

**Phase:** 1 — Core SIEM

- Started Docker and Containerd successfully.
- Restarted the Wazuh single-node stack using existing persistent volumes.
- Confirmed manager, indexer and dashboard containers are running.
- Queried the indexer cluster health API; status returned GREEN.
- Confirmed essential manager services are running, including analysisd, remoted, logcollector, syscheckd and apid.
- Verified dashboard access again at https://127.0.0.1:8443.
- Available memory after startup: approximately 7.5 GiB.
- Swap remains unconfigured.
- Windows endpoint enrollment remains pending.

**Status:** Wazuh restart and dashboard verification passed.
