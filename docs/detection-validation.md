# Detection Validation Register

This register tracks what the lab actually detects. Observed fields are populated only after running the test and inspecting telemetry.

## Status definitions

- **NOT TESTED** — test has not been run.
- **PASS** — expected evidence was observed and recorded.
- **FAIL** — test ran but expected evidence was not observed.
- **BLOCKED** — the test could not be completed due to a prerequisite or environmental issue.
- **INCONCLUSIVE** — evidence is insufficient to decide.

## Test cases

| ID | Scenario | Safe test method | Expected evidence | Observed result | Status |
|---|---|---|---|---|---|
| SF-001 | Windows agent connectivity | Check agent status in Wazuh manager/dashboard | Agent shown active/connected | SF-WIN11-01 (agent 001), Wazuh 4.14.9, reported Active in manager and dashboard | PASS |
| SF-002 | Windows authentication telemetry | Generate a benign interactive sign-in/unlock on the lab Windows VM | Windows successful-logon event reaches Wazuh and matches an authentication rule | Windows Security Event ID 4624, logon type 2 (Interactive); six matching alerts in Wazuh under rule 60118, “Windows Workstation Logon Success”, level 3 | PASS |
| SF-003 | File created in test folder | Create a harmless file in C:\SentinelForge-FIM-Test | File-integrity event with path and action | One alert: rule 554, “File added to the system”, level 5, for the test-file creation | PASS |
| SF-004 | File modified in test folder | Modify the same test file | Change event appears | One alert: rule 550, “Integrity checksum changed”, level 7 | PASS |
| SF-005 | File deleted in test folder | Delete the same test file | Deletion event appears | One alert: rule 553, “File deleted”, level 7 | PASS |
| SF-006 | Suricata service health | Use documented service/configuration validation checks | Service active and configuration valid | Suricata not yet deployed | NOT TESTED |
| SF-007 | Suricata event generation | Run a benign test matched by an enabled rule in the authorized lab | Expected alert appears in EVE output | Suricata not yet deployed | NOT TESTED |
| SF-008 | Suricata-to-SIEM forwarding | After integration is configured, emit a test event | Event visible in intended Wazuh view | Integration not configured | NOT TESTED |
| SF-009 | Asset register review | Compare lab-owned devices with the manually maintained inventory | Differences recorded for review | Asset review not yet performed | NOT TESTED |

## Validated Windows authentication details

- Endpoint: SF-WIN11-01, agent ID 001.
- Agent version: Wazuh 4.14.9.
- Windows event: Security Event ID 4624 (successful logon).
- Interactive logon type observed: 2.
- Wazuh rule: 60118 — Windows Workstation Logon Success.
- Rule level: 3.
- The query for rule 60106 returned no rows during this test, while the Event ID 4624 search returned six matching alerts under rule 60118. Record the observed child rule rather than reporting the test as failed.

## Validated file-integrity details

- Endpoint: SF-WIN11-01, agent ID 001.
- Test directory: C:\SentinelForge-FIM-Test.
- Configuration: a real-time directories entry was added to the existing Windows agent syscheck configuration.
- File used: fim-create-test.txt.
- Create: rule 554, “File added to the system”, level 5; one matching alert.
- Modify: rule 550, “Integrity checksum changed”, level 7; one matching alert.
- Delete: rule 553, “File deleted”, level 7; one matching alert.
- The test directory was dedicated to this validation and the same test file was used for the three operations.
- The agent service was confirmed Running after the configuration was validated and the service was started.

## Detailed result template

For each test, record:

- Test ID and date/time (include timezone).
- Exact environment/component version.
- Preconditions and test steps.
- Expected behavior.
- Actual behavior and evidence location.
- Whether the test was repeated.
- Relevant rule/configuration.
- Likely false positives or limitations.
- Final status and next action.

Use sanitized screenshots or synthetic examples in the public repository. Keep raw logs locally if they contain sensitive information. Screenshots reviewed during the November 10, 2026 validation session should be added to the evidence folder only after checking for usernames, private addresses, tokens, and other sensitive details.

## Interpretation caution

A passing test demonstrates only that the specific tested path worked under the recorded conditions. It does not prove complete detection coverage. A failed test may indicate collection, network visibility, rule, timing, or test-design issues; investigate the full path before concluding why it failed.
