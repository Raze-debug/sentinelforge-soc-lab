# Asset Context Register

This is a manual inventory of lab-owned or explicitly authorized assets/components only. Public aliases are used instead of personal usernames, MAC addresses, serial numbers, or physical locations. The Suricata sensor is a logical service hosted on the Parrot/Wazuh machine, not a separate physical or virtual device.

| Asset ID | Alias/hostname | Role | Responsible role | Criticality | Expected services/behavior | Telemetry source | Notes/last verified |
|---|---|---|---|---|---|---|---|
| ASSET-001 | SF-PARROT-01 | Parrot OS administration host; Docker host for Wazuh; host for Suricata service | Lab administrator | High for lab operations | Wazuh manager/indexer/dashboard; Docker Engine; Suricata sensor on host-only interface; local dashboard access | Wazuh manager; Suricata EVE JSON | Verified 2026-11-14; dashboard bound to loopback; host has constrained RAM and no swap |
| ASSET-002 | SF-WIN11-01 | Windows 11 VirtualBox endpoint; Wazuh Agent ID 001 | Lab administrator | Medium for lab operations | Windows Security/System/Application events; Wazuh Agent 4.14.9; dedicated FIM test directory; authorized lab network traffic | Wazuh Agent | Verified 2026-11-14; agent Active; authentication, FIM, and controlled ICMP tests passed |
| ASSET-003 | SF-NET-SENSOR-01 | Logical Suricata 8.0.8 sensor service hosted on SF-PARROT-01; not a separate machine | Lab administrator | Medium for lab operations | AF_PACKET capture on `vboxnet0`; EVE JSON output; local custom ICMP test rule; read-only forwarding to Wazuh manager | Suricata EVE JSON; Wazuh manager rule 86601 | Verified 2026-11-14; visibility validated for host-only Windows-to-Parrot traffic only |

## Criticality guidance

- **High:** the asset supports core lab control/monitoring; its loss interrupts the investigation workflow.
- **Medium:** an endpoint or sensor used for learning and testing; compromise matters but does not control external production systems.
- **Low:** a disposable test asset or nonessential component.

These labels are lab-relative, not enterprise risk ratings. Reassess criticality when roles change.

## Safe inventory practice

- Avoid publishing home/public IP addresses, MAC addresses, serial numbers, exact physical locations, or personal usernames.
- Keep sensitive asset mappings in a local file outside the public repository.
- Record when an asset was last verified and distinguish discovered devices from confirmed authorized assets.
- No automated network-wide discovery tool is deployed as part of the current scope. Do not infer that the register contains every device on a physical network.
- An unknown device is an investigation lead, not proof of malicious activity.
