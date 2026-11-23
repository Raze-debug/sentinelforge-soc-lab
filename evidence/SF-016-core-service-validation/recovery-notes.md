# SF-016 — Core Service Validation & Recovery

Date: 2026-11-23

## Objective
Validate SentinelForge SOC lab service recovery after host reboot.

## Recovery findings
- VirtualBox host-only network interface was not operational immediately after reboot.
- Wazuh Manager initially failed because its configured host-only bind address was unavailable.
- Restored host-only interface configuration and operational state.
- Started the Wazuh Manager successfully.
- Started Suricata manually for this validation session.

## Wazuh validation
- Wazuh Manager, Indexer, and Dashboard containers were running.
- Local Dashboard endpoint returned HTTP 302 and redirected to its login page.

## Network validation
- Windows 11 VM successfully pinged the Parrot host-only interface.
- Test: 5 packets sent, 5 received, 0% packet loss.

## Suricata validation
- Suricata 8.0.8 running in SYSTEM mode using AF_PACKET.
- Packet capture and decoder counters were increasing.
- Custom SentinelForge test signature SID 1000001 generated 5 fresh alerts during the controlled ICMP test.
- EVE JSON contained the fresh alert timestamps from the test session.

## Evidence files
- docker-status.txt
- dashboard-response.txt
- suricata-status.txt
- fresh-detection.txt
- suricata-packet-stats.txt

## Limitations
- Suricata service is disabled at boot and was manually started.
- Host-only networking depends on the VirtualBox interface becoming operational.
- Packet-drop count was not verified; no zero-drop claim is made.
- Validation covers the local VirtualBox host-only lab only.
- No IPS blocking or automated response was tested.

## Outcome
Core services recovered and operational validation passed for this test session.
