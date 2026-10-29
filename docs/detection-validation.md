# Detection Validation Register

This register tracks what the lab actually detects. Populate observed fields only after running the test and inspecting telemetry.

## Status definitions

- **NOT TESTED** — test has not been run.
- **PASS** — expected evidence was observed and recorded.
- **FAIL** — test ran but expected evidence was not observed.
- **BLOCKED** — the test could not be completed due to a prerequisite or environmental issue.
- **INCONCLUSIVE** — evidence is insufficient to decide.

## Test cases

| ID | Scenario | Safe test method | Expected evidence | Observed result | Status |
|---|---|---|---|---|---|
| SF-001 | Windows agent connectivity | Use official Wazuh agent status and dashboard checks | Agent shown active/connected | Pending | NOT TESTED |
| SF-002 | Windows authentication telemetry | Generate a benign, authorized authentication test where appropriate | Relevant Windows event reaches Wazuh | Pending | NOT TESTED |
| SF-003 | File created in test folder | Create a harmless file in the configured lab directory | File-integrity event with path and action | Pending | NOT TESTED |
| SF-004 | File modified in test folder | Modify contents of the same test file | Change event appears | Pending | NOT TESTED |
| SF-005 | File deleted in test folder | Delete the same test file | Deletion event appears | Pending | NOT TESTED |
| SF-006 | Suricata service health | Use documented service/configuration validation checks | Service active and configuration valid | Pending | NOT TESTED |
| SF-007 | Suricata event generation | Run a benign test matched by an enabled rule in the authorized lab | Expected alert appears in EVE output | Pending | NOT TESTED |
| SF-008 | Suricata-to-SIEM forwarding | After integration is configured, emit a test event | Event visible in intended Wazuh view | Pending | NOT TESTED |
| SF-009 | Asset register review | Compare lab-owned devices with the manually maintained inventory | Differences recorded for review | Pending | NOT TESTED |

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

Use sanitized screenshots or synthetic examples in the public repository. Keep raw logs locally if they contain sensitive information.

## Interpretation caution

A passing test demonstrates only that the specific tested path worked under the recorded conditions. It does not prove complete detection coverage. A failed test may indicate collection, network visibility, rule, timing, or test-design issues; investigate the full path before concluding why it failed.
