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

The Suricata-to-Wazuh dashboard screenshot was reviewed locally on 2026-11-14 and showed four matching hits. It has not yet been committed to this repository. Before adding it, crop unrelated browser UI and redact any unnecessary account/API selector details. No raw credentials or raw EVE/alerts logs should be committed.
