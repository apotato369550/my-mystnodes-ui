# MystNodes UI - Gemini Context

A specialized management tool for Mysterium Network DVPN nodes. This document provides context for Gemini AI assistants working on the codebase.

## Project Overview

**MystNodes UI** interacts with Mysterium nodes via **TequilAPI** (an HTTP REST API), enabling unified management of both Bare Metal and Dockerized node installations. Unlike SSH-based homelab tools, it communicates exclusively through authenticated HTTP endpoints.

## Current Status: Phase 1 (Active Development - ~50% Complete)

The project has transitioned from standalone utilities to a unified `my_myst_nodes` interactive manager:
- **Foundation:** Complete (script structure, dual-mode operation)
- **Node Management:** Complete (add, remove, configure)
- **Transaction Export:** Complete (CSV/JSON with date filtering)
- **Earnings Tracking:** In Progress (functions stubbed, integration pending)

## Core Architecture

### Communication Pattern
- **Protocol:** HTTP with Basic Authentication (`curl -u "user:pass"`)
- **No SSH:** Designed for safe operation with containerized nodes
- **Config Detection:** Automatic fallback to defaults if `~/.mystnodes_nodes` missing
- **Hostname Resolution:** Converts `.local` hostnames to IPs to bypass TequilAPI restrictions

### Configuration Files
- **`~/.mystnodes_nodes`**: Node registry in format `NAME|HOST:PORT|USER:PASS`
- **`~/.mystnodes/exports/`**: Default output directory for transaction exports
- **Optional:** `./.mystnodes_nodes` in project root (development/testing)

### Port Conventions
- `4050`: Bare metal node (localhost)
- `4100-4199`: Docker container range
- `4200-4299`: Remote bare metal nodes
- `4449`: LAN access for bare metal

## Implementation Details

### Key Functions in `my_myst_nodes`

**Hostname Resolution** (`resolve_host`):
- Converts `.local` addresses to IP using `getent` or `ping`
- Enables connectivity through TequilAPI hostname validation
- Fallback returns original hostname if resolution fails

**Node Management**:
- `add_node()` - Interactive prompts + connectivity validation
- `check_node_status()` - Health, identity, location, NAT type
- `onboard_node()` - Configures MMN API key via POST to `/mmn/api-key`
- `remove_node()` - Removes from config file

**Transaction Export** (Complete):
- `download_transactions()` - Orchestrates CSV/JSON export
- `get_settlement_history()` - Paginated fetch from `/settle/history`
- `export_transactions_csv()` / `export_transactions_json()` - Formatting
- `wei_to_myst()` - Precision conversion using `bc -l` (scale=18)

**Earnings** (In Progress):
- `calculate_earnings()` - Time-range based calculation
- `get_earnings_stats()` - Provider stats aggregation

### Menu Structure (Interactive Mode)
1. List Nodes
2. Add Node
3. Remove Node
4. Check Node Status
5. Onboard Node
6. Download Transaction Records
7. Exit

### CLI Commands
- `add-node` - Add node with validation
- `check-node NODE` - Check single node
- `onboard-node NODE API_KEY` - Set MMN key
- `download-transactions NODE [--format csv|json|both] [--from DATE] [--to DATE] [--output PATH]`
- `help` - Show usage

## Development Patterns

### HTTP Error Handling
```bash
response=$(curl -s -w "\n%{http_code}" -u "$auth" "$url/endpoint" 2>/dev/null)
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')
[ "$http_code" != "200" ] && { print_error "Failed: $http_code"; return 1; }
```

### Date Validation (RFC3339)
All transaction date filters must conform to: `YYYY-MM-DDTHH:MM:SSZ`
- Validation function: `validate_rfc3339_date(date)`
- Enforced in `download_transactions()` command

### Output Formatting
- **ANSI Colors:** Green (✓ success), Red (✗ error), Yellow (⚠ warning), Cyan (info)
- **Headers:** Styled with borders (`═══════════════`)
- **Lists:** Tabular format with aligned columns
- **JSON:** Pretty-printed with `jq` where applicable

## TequilAPI Endpoints Used

**Health & System:**
- `GET /healthcheck` - Version, uptime, process ID
- `GET /location` - IP address and location
- `GET /nat/type` - NAT traversal status

**Identities & Accounts:**
- `GET /identities` - List all identities
- `POST /identities` - Create new (planned)
- `GET /identities/{id}/balance` - Token balance (planned)

**Settlements & Payments:**
- `GET /settle/history?page=N&pageSize=50` - Settlement records
- `GET /v2/transactor/fees` or `/transactor/fees` - Fee structure
- `GET /beneficiary` - Beneficiary address

**Management:**
- `POST /mmn/api-key` - Configure MMN registration

**Services (Phase 2+):**
- `GET /services` - List running services
- `POST /services` - Start service
- `DELETE /services/{id}` - Stop service
- `GET /node/provider/earnings` - Provider earnings

## Dependencies

**Required:**
- bash (script execution)
- curl (HTTP requests)
- bc (MYST precision math)

**Optional:**
- jq (JSON parsing - used where available)
- getent/ping (hostname resolution)

**Auto-Installed:**
None currently - rely on standard system utilities.

## Important Notes for Development

1. **Configuration Format:** Each line in `~/.mystnodes_nodes` is `PIPE`-delimited, no spaces
2. **Credential Storage:** Currently plaintext (home directory protected by OS permissions)
3. **Error Suppression:** stderr redirected to /dev/null in most API calls to hide warnings
4. **Testing:** Use `check-nodes.sh` with explicit node config to validate API changes
5. **Backward Compatibility:** Maintain support for `.mystnodes_nodes` config file format

## Roadmap

**Phase 2:** Identity & Service Management
- Create identities
- Start/stop provider services
- Session history

**Phase 3:** Dashboard & Monitoring
- Real-time status view
- Aggregated earnings
- Alert thresholds

**Phase 4+:** Web UI, automation, advanced analytics
