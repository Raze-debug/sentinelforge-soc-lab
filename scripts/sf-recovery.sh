#!/usr/bin/env bash
set -Eeuo pipefail

COMPOSE_DIR="/home/parrot/Desktop/Projects/wazuh-docker-v4.14.9/single-node"
IFACE="vboxnet0"
EXPECTED_CIDR="192.168.56.1/24"
DASHBOARD_URL="https://127.0.0.1:8443"

log() { echo "[SentinelForge] $*"; }
fail() { echo "[ERROR] $*" >&2; exit 1; }

if [[ "$EUID" -ne 0 ]]; then
    fail "Run with sudo: sudo $0"
fi

log "Checking host-only interface..."
ip link show "$IFACE" >/dev/null 2>&1 ||
    fail "$IFACE does not exist. Start the Windows VM manually and retry."

ip -o -4 addr show dev "$IFACE" |
    awk '{print $4}' | grep -Fxq "$EXPECTED_CIDR" ||
    fail "$IFACE does not have $EXPECTED_CIDR. Recovery stopped."

log "Host-only interface verified."

log "Checking Docker..."
if ! systemctl is-active --quiet docker; then
    log "Starting Docker..."
    systemctl start docker
fi

systemctl is-active --quiet docker ||
    fail "Docker did not become active."

[[ -f "$COMPOSE_DIR/docker-compose.yml" ]] ||
    fail "Wazuh Compose file not found: $COMPOSE_DIR"

log "Starting Wazuh services..."
cd "$COMPOSE_DIR"
docker compose up -d

for service in wazuh.indexer wazuh.manager wazuh.dashboard; do
    container_id="$(docker compose ps -q "$service")"
    [[ -n "$container_id" ]] ||
        fail "No container found for $service."

    state="$(docker inspect -f '{{.State.Status}}' "$container_id")"
    [[ "$state" == "running" ]] ||
        fail "$service is not running (state: $state)."

    log "$service: running"
done

log "Starting Suricata..."
systemctl start suricata
systemctl is-active --quiet suricata ||
    fail "Suricata did not become active."

log "Checking Dashboard response..."
http_code=""
for attempt in {1..30}; do
    http_code="$(curl -k -sS -o /dev/null -w '%{http_code}' --connect-timeout 2 "$DASHBOARD_URL" 2>/dev/null || true)"

    if [[ "$http_code" == "200" || "$http_code" == "302" ]]; then
        break
    fi
    sleep 2
done

[[ "$http_code" == "200" || "$http_code" == "302" ]] ||
    fail "Dashboard did not return HTTP 200 or 302 (last: ${http_code:-none})."

log "Dashboard responded with HTTP $http_code."
log "Recovery sequence completed. Validate detection with a controlled lab test."
