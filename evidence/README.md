# Evidence Guide

Use this folder for sanitized screenshots or small evidence summaries that make project milestones reproducible.

## Capture checklist

- Show only the relevant dashboard panel, service status, or test result.
- Redact credentials, tokens, emails, usernames where unnecessary, public IPs, serial numbers, and unrelated personal information.
- Do not capture password dialogs or secret-bearing terminal output.
- Use synthetic/sample events in examples where practical.
- Include a short caption with the test ID, date, expected result, observed result, and any limitation.
- Keep original raw logs locally if they contain sensitive or identifying data.

## Recommended evidence

| Suggested file | Test/milestone | Caption |
|---|---|---|
| `wazuh-dashboard-login.png` | Phase 1 | Sanitized view proving local dashboard access; do not include credentials |
| `windows-authentication-alert.png` | SF-002 | Event ID 4624 / rule 60118, level 3 |
| `windows-fim-validation.png` | SF-003 to SF-005 | File create/modify/delete rules 554/550/553 |
| `suricata-wazuh-icmp-dashboard.png` | SF-006 to SF-008 | Threat Hunting query returned four rule 86601 hits for SID 1000001 on 2026-11-14; visibility limited to the tested host-only traffic |

## Current status

- `suricata-wazuh-icmp-dashboard.png` is a sanitized dashboard capture from 2026-11-14.
- Query: `rule.id:86601 AND data.alert.signature_id:1000001`.
- Observed result: four matching Wazuh alerts, rule 86601, level 3.
- The image excludes browser chrome, the local dashboard URL, and account/API selector details.
- The screenshot demonstrates only the tested Windows-to-Parrot host-only ICMP traffic; it does not imply network-wide visibility.
- No credentials or raw EVE/alerts logs are included.
