# SentinelForge Incident Playbooks

These are initial investigation procedures, not automated response scripts. Follow them only within systems and networks you are authorized to administer.

## Common triage checklist

1. Confirm alert source, timestamp, host, user, and event type.
2. Establish the time window and look for related events on the same host or account.
3. Preserve relevant event IDs, query details, and sanitized evidence.
4. Check expected administrative work, scheduled tasks, software updates, and other benign explanations.
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

## Playbook 3 — Suspicious network alert

**Objective:** Triage a Suricata alert without assuming the signature proves compromise.

### Collect
- Alert/signature, severity, timestamp, and sensor/interface.
- Source/destination address and port, protocol, direction, and available flow metadata.
- Whether the traffic belongs to a test, expected service, or authorized scan.
- Related endpoint/SIEM events and asset context.

### Investigate
1. Verify the sensor saw the relevant traffic and that clocks align.
2. Review alert metadata and rule documentation.
3. Determine whether the signature indicates a generic pattern, policy violation, or strong evidence of a threat.
4. Correlate with endpoint events in a defined time window.
5. Check for legitimate service behavior, test traffic, and possible false positives.
6. Document what could not be observed due to topology or capture scope.

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
