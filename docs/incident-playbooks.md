# SentinelForge Incident Playbooks

These are investigation procedures, not automated response scripts. Follow them only within systems and networks you are authorized to administer.

## Common triage checklist

1. Confirm alert source, timestamp, host, user, and event type.
2. Establish the time window and look for related events on the same host or account.
3. Preserve relevant event IDs, query details, and sanitized evidence.
4. Check expected administrative work, scheduled tasks, software updates, controlled lab tests, and other benign explanations.
5. Assess affected asset importance using the asset register.
6. Decide whether evidence is sufficient, needs further collection, or should be escalated.
7. Record the conclusion, confidence, limitations, and follow-up actions.

Do not automatically isolate systems, disable accounts, or delete files just because a single alert appears. Response actions should be authorized and proportionate.

## Playbook 1 — Repeated failed logins

**Objective:** Determine whether repeated authentication failures are explainable or suspicious.

### Collect
- Account/user and endpoint name.
- Event timestamps and time zone.
- Failure reason/status where available.
- Logon type and source workstation/IP where available.
- Nearby successful logins and related account events.
- Asset importance and whether activity matches expected behavior.

### Investigate
1. Check whether failures are concentrated on one account, host, or source.
2. Check whether a successful login follows the failures.
3. Compare against approved test activity, mistyped-password patterns, service accounts, and scheduled jobs.
4. Look for related endpoint or network evidence in the same time window.
5. Document why the activity is normal, suspicious, or inconclusive.

### Decision and response
- **Likely benign:** document the supporting explanation.
- **Suspicious or repeated with corroborating evidence:** escalate according to the lab response plan and preserve evidence.
- **Inconclusive:** record missing evidence and the next collection step.

## Playbook 2 — Unexpected file-integrity change

**Objective:** Investigate a file creation, modification, or deletion in a monitored path.

### Collect
- Full path (redact sensitive directory names in public evidence).
- Host, timestamp, file action, and event identifier.
- File owner/permissions and hash, if available.
- Relevant user/process context, if collected.
- Whether the change aligns with a known lab test or authorized update.

### Investigate
1. Confirm that the path is in the intended monitoring scope.
2. Check whether the event was caused by a controlled test, software update, or known user action.
3. Look for related events around the same timestamp.
4. Determine whether the file is expected and whether recovery or escalation is needed.
5. Record limitations if process attribution was not collected.

### Decision and response
- **Expected/authorized change:** document the change and close with the event evidence.
- **Unexpected change with corroborating indicators:** preserve the file metadata and relevant logs, then escalate for authorized review.
- **Insufficient context:** collect additional owner, process, or change-window information before deciding.

## Playbook 3 — Suspicious network alert

**Objective:** Triage a Suricata alert without assuming the signature proves compromise.

### Collect
- Alert/signature, severity, timestamp, and sensor/interface.
- Source/destination address and port, protocol, direction, and available flow metadata.
- Whether the traffic belongs to a test, expected service, or authorized scan.
- Related endpoint/SIEM events and asset context.

### Investigate
1. Verify the sensor saw the relevant traffic and that clocks align.
2. Review alert metadata and rule documentation; distinguish a local test signature from a threat-intelligence or ET Open signature.
3. Determine whether the signature indicates a generic pattern, policy violation, or strong evidence of a threat.
4. Correlate with endpoint events in a defined time window using timestamp, endpoint, source/destination, protocol, and user/process data where available.
5. Check for legitimate service behavior, test traffic, and possible false positives.
6. Document what could not be observed due to topology or capture scope.

### Decision and response
- **Known controlled/benign traffic:** record the test context and close as benign; do not block solely on the alert.
- **Suspicious with corroborating evidence:** preserve relevant EVE/Wazuh records and escalate for an authorized response decision.
- **Inconclusive:** document the missing visibility or metadata and specify the next safe collection step.

## Completed controlled investigation — SF-CASE-001

**Scenario:** Benign Windows-to-Parrot ICMP connectivity test generated a Suricata alert and a Wazuh SIEM event.

**Date/time:** 2026-11-14, approximately 11:26:58–11:27:01 IST (UTC+05:30).

**Environment:** Windows 11 endpoint SF-WIN11-01 (Wazuh agent 001), Parrot OS host SF-PARROT-01, Suricata 8.0.8, Wazuh 4.14.9.

**Initial hypothesis:** The network alert was expected test traffic from the lab Windows VM, not evidence of compromise.

**Evidence collected**
- Windows Wazuh service was Running.
- Windows host-only address was the expected lab endpoint address; the Parrot host-only interface was active.
- The operator ran a bounded four-request ICMP ping from Windows to the Parrot host.
- Ping output showed four replies and 0% packet loss.
- Suricata EVE JSON contained four matching alert records for local SID 1000001, revision 1, `SentinelForge TEST Windows ICMP echo request`.
- The EVE records identified ICMP, interface `vboxnet0`, source Windows lab endpoint, destination Parrot host, and `alert.action: allowed`.
- Wazuh JSON decoding succeeded; rule 86601 generated four level-3 alerts in groups `ids` and `suricata`.
- Threat Hunting query `rule.id:86601 AND data.alert.signature_id:1000001` returned **4 hits**.

**Benign explanations considered**
- The traffic was generated intentionally by the operator using the lab Windows VM.
- The source/destination pair matched the controlled host-only test path.
- The alert signature was a custom SentinelForge test rule, not an assertion that the traffic was malicious.

**Findings and decision**
- The observed alert was consistent with the planned connectivity test.
- Suricata was operating as a passive IDS; `allowed` is expected and no blocking was attempted.
- No incident containment or host isolation was warranted for this controlled test.
- **Closure:** closed as a successful detection-pipeline validation, not a security incident.

**Limitations**
- This case validates only the observed traffic on `vboxnet0`; it does not prove visibility into all LAN, NAT, VLAN, or internet traffic.
- Process-level attribution for the ICMP packet was not collected by this test.
- A level-3 IDS alert is a triage signal, not proof of compromise.

**Evidence references:** `docs/detection-validation.md` (SF-006 to SF-008); local Suricata EVE output; Wazuh manager `alerts.json`; Wazuh Threat Hunting screenshot to be added after sanitization.

## Investigation record template

- Case ID:
- Date/time opened (timezone):
- Alert/source:
- Affected asset and criticality rationale:
- Initial hypothesis:
- Evidence and event IDs:
- Correlation window and fields:
- Benign explanations considered:
- Findings:
- Confidence and limitations:
- Decision/escalation:
- Authorized response taken:
- Closure rationale:
- Follow-up detection improvement:
