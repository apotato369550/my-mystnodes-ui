# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MystNodes UI is a unified bash-based tool for managing and monitoring Mysterium Network nodes across multiple instances. Inspired by homelab-manager, this tool provides both an interactive menu-driven interface and a CLI mode for tracking node status, managing identities, monitoring earnings, and controlling node operations via the TequilAPI REST interface.

Unlike homelab-manager which uses SSH for remote execution, MystNodes UI communicates with nodes through their TequilAPI HTTP endpoints, supporting both bare-metal and Docker-based Mysterium node installations.

## Key Commands (Planned)

### Running the Application

**Interactive Mode (Default)**:
```bash
./mystnodes.sh
```

**CLI Mode**:
```bash
./mystnodes.sh help                         # Show help
./mystnodes.sh status all                   # Check all node statuses
./mystnodes.sh earnings all                 # View earnings across all nodes
./mystnodes.sh node add NAME HOST PORT      # Add a new node
./mystnodes.sh identities NODE              # List identities for a node
```

### Running Tests
```bash
./test-mystnodes.sh
```

## Architecture

### Core Data Storage

The application will store its configuration in the user's home directory:

- **`~/.mystnodes_nodes`**: Stores node entries in format `NODE_NAME|HOST:PORT|USERNAME:PASSWORD`
- **`~/.mystnodes_identities`**: Cached identity information for quick access
- **`~/.mystnodes_config`**: Global configuration (default credentials, refresh intervals, etc.)

### Main Script Structure (Planned: `mystnodes.sh`)

The script will follow homelab-manager's dual-mode architecture:

**Mode Selection** (Entry Point):
- Checks if CLI arguments provided: if yes, runs `run_cli_mode()`, if no, enters interactive menu loop

**Interactive Mode**:
1. **Menu System**: Arrow-key navigation with menu state tracking
2. **Node Dashboard**: Real-time status of all configured nodes
3. **Identity Management**: View, create, and unlock identities
4. **Earnings Tracking**: Aggregate earnings across all nodes
5. **Service Control**: Start/stop provider services
6. **Session Monitoring**: View active sessions and statistics

**CLI Mode**:
- Parses command arguments and dispatches to appropriate handlers
- Supports commands: `status`, `earnings`, `identities`, `services`, `sessions`, `node`, `config`, `help`
- Returns exit codes and formatted output suitable for scripts

### TequilAPI Integration

**Communication Layer**:
All node operations use HTTP Basic Authentication with curl:
```bash
curl -u "$USERNAME:$PASSWORD" "http://$HOST:$PORT/endpoint"
```

**Default Configuration**:
- Default Host: `127.0.0.1`
- Default Port: `4050`
- Default Username: `myst`
- Default Password: `mystberry`

**Security Considerations**:
- Credentials stored in plaintext in config files (home directory protected by user permissions)
- Support for custom credentials per node
- Warning system when nodes exposed beyond localhost
- Future: encrypted credential storage

### Implemented Functions

**Transaction Download Functions** (Phase 1 - Complete):
- **`wei_to_myst(wei)`**: Converts wei to MYST tokens using bc for precision (scale=18)
- **`validate_rfc3339_date(date)`**: Validates RFC3339 date format (YYYY-MM-DDTHH:MM:SSZ)
- **`get_node_identity(node_name)`**: Fetches first identity ID for a node via `/identities` endpoint
- **`get_settlement_history(node_name, date_from, date_to)`**: Fetches all settlement records with pagination support (page_size=50)
- **`get_transactor_fees(node_name)`**: Fetches current fee structure from `/v2/transactor/fees` with fallback to `/transactor/fees`
- **`get_identity_beneficiary(node_name, identity_id)`**: Fetches beneficiary address for an identity
- **`export_transactions_csv(node_name, output_file, settlements_json, fees_json, beneficiary)`**: Formats settlement data as CSV with summary footer
- **`export_transactions_json(node_name, output_file, settlements_json, fees_json, beneficiary, date_from, date_to)`**: Formats data as structured JSON with metadata
- **`download_transactions(node_name, format, date_from, date_to, output_path)`**: Main orchestration function for transaction export

**CLI Commands** (Phase 1 - Complete):
- **`download-transactions NODE [OPTIONS]`**: Download transaction records
  - `--format csv|json|both` - Export format (default: both)
  - `--from DATE` - Filter from date (RFC3339 format)
  - `--to DATE` - Filter to date (RFC3339 format)
  - `--output PATH` - Custom output directory (default: ~/.mystnodes/exports/)

**Menu Items** (Phase 1 - Complete):
- **`Download Transaction Records`** - Menu item at index 4 in interactive mode

### Critical Functions (To Be Implemented)

**Node Health & Status Functions**:
- **`check_node_health(node_name, api_url, auth)`**: Queries `/healthcheck` endpoint
- **`get_node_status(node_name)`**: Retrieves uptime, version, build info
- **`check_all_nodes()`**: Iterates through configured nodes and reports health
- **`get_nat_type(node_name)`**: Queries `/nat/type` for NAT traversal status

**Identity Management Functions**:
- **`list_identities(node_name)`**: Queries `/identities` endpoint
- **`create_identity(node_name)`**: Creates new identity via POST `/identities`
- **`unlock_identity(node_name, identity_id)`**: Unlocks identity for use
- **`get_identity_balance(node_name, identity_id)`**: Retrieves MYST token balance

**Provider & Service Functions**:
- **`list_services(node_name)`**: Queries `/services` for running services
- **`start_service(node_name, provider_id, service_type)`**: Starts provider service
- **`stop_service(node_name, service_id)`**: Stops running service
- **`get_provider_stats(node_name)`**: Queries `/node/provider/*` for earnings, uptime, quality

**Session & Connection Functions**:
- **`list_sessions(node_name)`**: Queries `/sessions` for session history
- **`get_active_connections(node_name)`**: Shows current active connections
- **`get_session_stats(node_name)`**: Aggregates data transfer statistics

**Node Management Functions**:
- **`add_node(name, host, port, username, password)`**: Adds new node to configuration with connectivity validation
- **`remove_node(name)`**: Removes node from configuration
- **`test_node_connection(host, port, username, password)`**: Validates API accessibility
- **`update_node_credentials(node_name, new_username, new_password)`**: Updates stored credentials

**Dashboard Functions**:
- **`view_dashboard()`**: Creates real-time dashboard with node status, earnings, sessions
- **`export_stats(output_file)`**: Exports comprehensive stats to file
- **`view_live_earnings()`**: Real-time earnings monitor (similar to homelab-manager's tmux stats)

### API Endpoint Mapping

The script will interact with these TequilAPI endpoints:

**Health & System**:
- `GET /healthcheck` - Node health and version info
- `GET /location` - IP and location information
- `GET /nat/type` - NAT type detection

**Identities**:
- `GET /identities` - List all identities
- `POST /identities` - Create new identity
- `PUT /identities/{id}/unlock` - Unlock identity
- `GET /identities/{id}/balance` - Get balance

**Services (Provider Mode)**:
- `GET /services` - List running services
- `POST /services` - Start service
- `DELETE /services/{id}` - Stop service
- `GET /node/provider/*` - Provider statistics

**Sessions & Connections**:
- `GET /sessions` - Session history
- `GET /connection` - Current connection status
- `PUT /connection` - Start connection
- `DELETE /connection` - Stop connection

**Payments & Settlements**:
- `GET /settle/history` - Settlement history
- `GET /transactor/fees` - Current fees
- `GET /beneficiary` - Beneficiary address

**Configuration**:
- `GET /config` - View node configuration
- `POST /config` - Update configuration

## Important Patterns

### HTTP Request Error Handling
All API calls should include:
- Connection timeout handling
- HTTP status code validation
- JSON response parsing (using `jq` or manual parsing)
- Retry logic for transient failures
- User-friendly error messages

Example pattern:
```bash
response=$(curl -s -w "\n%{http_code}" -u "$auth" "$api_url/endpoint" 2>/dev/null)
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

if [ "$http_code" != "200" ]; then
    print_error "API request failed with status $http_code"
    return 1
fi
```

### Configuration File Format
Node configuration stored in `~/.mystnodes_nodes`:
```
node1|192.168.1.100:4050|myst:mystberry
node2|192.168.1.101:4050|admin:custompass
local|127.0.0.1:4050|myst:mystberry
```

### Output Formatting
Following homelab-manager pattern:
- Use ANSI colors for status indicators (green=healthy, red=error, yellow=warning)
- Timestamp all exports
- JSON responses formatted for readability
- Tabular output for lists (identities, sessions, services)

### Credential Management
- Store credentials in format `USERNAME:PASSWORD`
- Support per-node credential override
- Warn when default credentials detected on non-localhost nodes
- Future: Consider encrypted credential storage using `gpg` or similar

## Dependencies

**Required**:
- bash (core functionality)
- curl (HTTP API communication)
- jq (JSON parsing - will auto-install if missing)

**Optional**:
- tmux (live dashboard view - auto-install pattern from homelab-manager)
- bc (floating-point calculations for earnings)

**Standard utilities**: grep, sed, awk, date

## Testing Framework (Planned: `test-mystnodes.sh`)

The test suite will provide interactive verification of all components:

**Test Categories**:
- **Core Tests**: Dependency checking (bash, curl, jq)
- **API Tests**: TequilAPI endpoint accessibility and authentication
- **Node Management Tests**: Add/remove/update node operations
- **Identity Tests**: Identity listing, creation, balance retrieval
- **Service Tests**: Service start/stop/status operations
- **Session Tests**: Session history and statistics
- **Dashboard Tests**: Real-time monitoring functionality
- **CLI Mode Tests**: All CLI commands and argument parsing
- **Error Handling Tests**: API failures, network issues, authentication errors

## Development Roadmap

### Phase 1: Core Node Management & Transaction Downloads (Current)
- ✅ Basic script structure with dual-mode support (interactive + CLI)
- ✅ Node configuration storage and management
- ✅ Health check and status monitoring
- ✅ Simple identity listing
- ✅ **Transaction Downloads** - CSV and JSON export with date filtering

### Phase 2: Identity & Service Management
- Full identity management (create, unlock, balance)
- Provider service controls (start, stop, monitor)
- Session history and statistics
- Earnings tracking and reporting

### Phase 3: Dashboard & Monitoring
- Real-time dashboard (tmux-based or terminal UI)
- Aggregated statistics across all nodes
- Alert system for node failures
- Export functionality for reports

### Phase 4: Console UI Enhancement
- Enhanced terminal UI (potentially using `dialog` or `whiptail`)
- Interactive charts and graphs (using ASCII art or terminal graphics)
- Configuration wizard for first-time setup

### Phase 5: Web UI (Future)
- Web-based dashboard (separate from bash script)
- Technology stack TBD (Flask/FastAPI + JavaScript, or Go-based)
- WebSocket support for real-time updates
- Multi-user support with authentication

## Integration with Homelab Manager

While MystNodes UI is a standalone tool, it shares architectural patterns with homelab-manager:

**Shared Patterns**:
1. **Dual-mode operation**: Interactive menu + CLI
2. **Home directory config**: Persistent state in `~/.mystnodes_*`
3. **Arrow-key navigation**: Same menu system
4. **Color-coded output**: Consistent ANSI color scheme
5. **Export functionality**: Timestamped report generation
6. **Auto-dependency installation**: Silent installation of missing tools

**Key Differences**:
1. **Communication method**: HTTP API vs SSH
2. **Authentication**: HTTP Basic Auth vs SSH keys
3. **Data format**: JSON responses vs command output
4. **Node types**: Mysterium nodes vs generic homelab systems

**Potential Integration**:
- Could be invoked as a homelab-manager module
- Share node configuration format where applicable
- Unified dashboard showing both homelab nodes and Myst nodes

## Security Considerations

1. **Credential Storage**: Currently plaintext in home directory (protected by user permissions)
2. **API Exposure**: Warn users when adding nodes with non-localhost addresses
3. **Default Credentials**: Alert when default `myst:mystberry` detected on exposed nodes
4. **HTTPS Support**: Future enhancement for encrypted API communication
5. **Read-Only Mode**: Consider implementing a read-only mode that prevents service control operations

## API Reference

For detailed API documentation, see `TEQUILA_API_DOCS.md`.

Quick reference for common endpoints:
- Health: `GET /healthcheck`
- Identities: `GET /identities`
- Services: `GET /services`
- Sessions: `GET /sessions`
- Provider Stats: `GET /node/provider/*`

All endpoints require HTTP Basic Authentication.
Default base URL: `http://127.0.0.1:4050`

## Future Enhancements

1. **Multi-node Operations**: Bulk operations across all nodes (start all services, update all configs)
2. **Earning Aggregation**: Calculate total earnings across node fleet
3. **Historical Tracking**: Store historical data for trend analysis
4. **Alert System**: Email/webhook notifications for node failures or earning thresholds
5. **Auto-configuration**: Discovery and auto-add of nodes on local network
6. **Docker Integration**: Direct Docker container management for containerized nodes
7. **Config Templates**: Pre-defined node configurations for common setups
8. **Backup/Restore**: Identity and configuration backup/restore functionality
