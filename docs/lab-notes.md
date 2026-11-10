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

### 2026-11-04 — Windows 11 endpoint enrollment verified

**Phase:** 2 — Windows endpoint telemetry

**Environment**
- Endpoint: Windows 11 Home, VirtualBox VM.
- Agent: Wazuh 4.14.9.
- Agent name: SF-WIN11-01.
- Agent ID: 001.
- Parrot OS kernel: 7.1.13+parrot7-amd64.
- Network: NAT + Host-only (`vboxnet0`).
- Private lab addresses are intentionally not repeated here.

**Verified results**
- Windows MSI digital signature verified as valid.
- Agent installed successfully; MSI exit code 0.
- Windows Wazuh service is Running and configured for Automatic startup.
- Enrollment key received successfully.
- TCP connectivity to manager ports 1514 and 1515 verified from Windows.
- Windows agent connected to the manager over TCP 1514.
- Manager reports SF-WIN11-01 (ID 001) as Active.
- `agent_control -i 001` and `agent_control -lc` both confirmed Active.
- Windows Security, System and Application event collection initialized.
- Initial FIM scan and real-time FIM initialization reported by the agent.
- Initial Windows SCA assessment completed.

**Outstanding follow-ups**
- Investigate the SCA integration checksum retry warning seen in the Windows agent log.
- Confirm sustained endpoint connectivity over a longer observation period.

**Status:** Agent enrollment and active connection verified.

### 2026-11-10 — Windows authentication and FIM validation

**Phase:** 2 — Windows endpoint telemetry; Phase 3 — Detection validation

**Environment**
- SIEM: Wazuh 4.14.9 single-node Docker deployment on Parrot OS.
- Endpoint: Windows 11 Home VirtualBox VM.
- Agent: SF-WIN11-01, ID 001, Wazuh 4.14.9.
- Dashboard: local Wazuh dashboard at `https://127.0.0.1:8443`.

**Windows authentication validation**
- Confirmed the agent was Active in the manager.
- A Threat Hunting search for agent 001 returned 1,337 matching events over the selected seven-day window.
- A Security-channel search returned 16 matching events.
- Windows local Security log showed successful-logon Event ID 4624 entries.
- The controlled lock/unlock test produced Event ID 4624 with logon type 2 (Interactive).
- Searching for agent 001 and Event ID 4624 returned six Wazuh alerts.
- Observed rule: 60118, “Windows Workstation Logon Success”, level 3.
- A search specifically for rule 60106 returned no rows; the more specific rule 60118 was observed and used as the passing result.

**FIM configuration**
- Existing Windows agent configuration was inspected at `C:\Program Files (x86)\ossec-agent\ossec.conf`.
- Existing syscheck directories included Windows system paths and the Startup folder.
- Created the dedicated test directory `C:\SentinelForge-FIM-Test`.
- Backed up ossec.conf before editing.
- Added the following entry inside the existing syscheck section: `<directories realtime="yes">C:\SentinelForge-FIM-Test</directories>`.
- Parsed the configuration as XML and verified the test directory entry and realtime="yes" attribute.
- Restart-Service initially failed while stopping WazuhSvc and left it Stopped. The configuration was rechecked and validated; Start-Service then succeeded, and Get-Service confirmed WazuhSvc Running.

**FIM test results**
- Created fim-create-test.txt in the test directory. Wazuh returned one rule 554 alert: “File added to the system”, level 5.
- Appended a benign test line to the same file. Wazuh returned one rule 550 alert: “Integrity checksum changed”, level 7.
- Deleted the same test file. Wazuh returned one rule 553 alert: “File deleted”, level 7.
- All three alerts were visible in Threat Hunting for agent 001 during the November 10 validation session.

**Outcome**
- Windows authentication telemetry: PASS.
- File creation detection: PASS.
- File modification detection: PASS.
- File deletion detection: PASS.
- The test file was deleted as part of the controlled test.

**Security/privacy notes**
- Tests were confined to the dedicated lab folder on the Windows VM.
- No real user documents or Windows system files were modified.
- Do not commit credentials, certificate keys, raw sensitive logs, or unredacted screenshots.
- Add only sanitized screenshots to the repository evidence folder after review.

**Status:** Phase 2 endpoint telemetry and Phase 3 authentication/FIM validation checks passed. Next: Phase 4 network detection with Suricata.

### 2026-11-11 — Updated host resource snapshot

**Phase:** 0 — Readiness

**Assessment time:** 2026-11-11 00:10 IST

**Observed host resources**
- CPU: Intel Core i5-4310U, 4 logical CPUs.
- RAM: 11 GiB total; 10 GiB used; approximately 1.4 GiB available.
- Swap: 0 B configured.
- Root filesystem: 448 GB total; 130 GB used; 317 GB available.
- CPU virtualization extensions: Available.
- Docker Engine: 29.9.3.
- Docker Compose: 2.26.1-4.
- vm.max_map_count: 1048576.

**Assessment**
- The host has sufficient disk capacity for the planned lab work.
- Available memory was limited at the time of measurement.
- No swap was configured.
- Additional services, including Suricata, must be introduced cautiously.
- Monitor memory usage before expanding the running SOC stack.

**Privacy**
- No hostname, serial number, MAC address, machine ID or private IP address recorded.

**Status:** Updated resource assessment recorded.
