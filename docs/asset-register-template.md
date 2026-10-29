# Asset Context Register

Start with only lab-owned or explicitly authorized assets. Use aliases in the public repository where possible.

| Asset ID | Alias/hostname | Role | Responsible role | Criticality | Expected services/behavior | Telemetry source | Notes/last verified |
|---|---|---|---|---|---|---|---|
| ASSET-001 | SOC-SIEM-01 | Planned SIEM VM | Lab administrator | High for lab operations | Wazuh management and data services | Wazuh (planned) | Not deployed |
| ASSET-002 | SOC-WIN-01 | Planned Windows endpoint | Lab administrator | Medium for lab operations | Normal endpoint activity and test directory | Wazuh Agent (planned) | Not enrolled |
| ASSET-003 | SOC-SENSOR-01 | Planned network sensor | Lab administrator | Medium for lab operations | Authorized lab traffic visibility | Suricata (planned) | Placement pending |

## Criticality guidance

- **High:** the asset supports core lab control/monitoring; its loss interrupts the investigation workflow.
- **Medium:** an endpoint or sensor used for learning and testing; compromise matters but does not control external production systems.
- **Low:** a disposable test asset or nonessential component.

These labels are lab-relative, not enterprise risk ratings. Reassess criticality when roles change.

## Safe inventory practice

- Avoid publishing home/public IP addresses, MAC addresses, serial numbers, exact physical locations, or personal usernames.
- Keep sensitive asset mappings in a local file outside the public repository.
- Record when an asset was last verified and distinguish discovered devices from confirmed authorized assets.
- An unknown device is an investigation lead, not proof of malicious activity.
