# MystNodes UI

A unified bash-based tool for managing and monitoring Mysterium Network nodes across multiple instances.

## Overview

MystNodes UI provides both an interactive menu-driven interface and CLI mode for tracking node status, managing identities, monitoring earnings, and controlling node operations via the TequilAPI REST interface.

Unlike traditional homelab managers that use SSH for remote execution, MystNodes UI communicates with nodes through their TequilAPI HTTP endpoints, supporting both bare-metal and Docker-based Mysterium node installations.

## Project Status

**Current Phase:** Foundation & Documentation (Phase 1)

### ✅ Completed

- [x] TequilAPI documentation extracted from live nodes
- [x] Complete API reference generated (223 endpoints)
- [x] Both node installations configured and accessible
- [x] Docker node TequilAPI binding fixed
- [x] Node status checker utility created
- [x] Documentation extraction script implemented
- [x] Comprehensive troubleshooting guides written

### 🚧 In Progress

- [ ] Core node management script (mystnodes.sh)
- [ ] Configuration storage system
- [ ] Interactive menu interface
- [ ] CLI command parsing

### 📋 Planned

See [Development Roadmap](#development-roadmap) for complete feature timeline.

## Features (Planned)

- **Dual-Mode Operation:** Interactive menu + CLI commands
- **Multi-Node Management:** Monitor multiple Mysterium nodes from one interface
- **Health Monitoring:** Real-time status checks and health reports
- **Identity Management:** Create, unlock, and manage node identities
- **Service Control:** Start/stop provider services
- **Earnings Tracking:** Monitor and aggregate earnings across nodes
- **Session History:** View connection sessions and statistics
- **Live Dashboard:** Real-time monitoring with tmux integration

## Current Utilities

### check-nodes.sh

Interactive status checker for both Mysterium node installations.

**Usage:**
```bash
./check-nodes.sh [command]

Commands:
  status       - Show health status (default)
  identities   - List identities
  services     - Show running services
  location     - Show node locations
  nat          - Check NAT type
  full         - Full detailed status report
```

**Example Output:**
```
>>> Bare Metal
────────────────────────────────────────
✓ Node is healthy
  Version: 1.36.5
  Uptime: 68h48m43s
  Process: 10095

>>> Docker (orion-alpha)
────────────────────────────────────────
✓ Node is healthy
  Version: 1.36.5
  Uptime: 1m0s
  Process: 1
```

### extract-tequila-docs.sh

Automated TequilAPI documentation extractor.

**Features:**
- Extracts Swagger JSON from live nodes
- Generates human-readable Markdown reference
- Compares API versions across nodes
- Non-destructive (read-only operations)

**Usage:**
```bash
./extract-tequila-docs.sh
```

## Node Configuration

### Bare Metal Node (orion)
- **Localhost Port:** 4050
- **LAN Port:** 4449
- **Localhost URL:** http://127.0.0.1:4050
- **LAN URL:** http://192.168.254.101:4449
- **Identity:** 0x6e74d97c16a16caa6e4c3164b40ccc36670b4af8
- **Services:** wireguard, dvpn, monitoring, data_transfer, scraping

### Docker Node (orion-alpha)
- **Port:** 4100
- **URL:** http://127.0.0.1:4100
- **Identity:** 0xb4da7958fb612c71495c72ab646c9da6c8b108fe
- **Services:** quic_scraping, wireguard, dvpn, monitoring, data_transfer

### Authentication
- **Username:** myst
- **Password:** mystberry
- **Method:** HTTP Basic Auth

**Security Note:** Default credentials are safe for localhost-only binding. Change them if exposing TequilAPI beyond 127.0.0.1.

## Port Mapping Conventions

To maintain consistency and avoid port conflicts across your Mysterium node infrastructure, follow these port allocation guidelines:

### Port Range Allocation

| Range | Purpose | Capacity | Notes |
|-------|---------|----------|-------|
| 4050-4099 | Bare metal installations (localhost) | 50 slots | Primary TequilAPI access |
| 4449 | Bare metal installations (LAN) | 1 slot | LAN-accessible port for local bare metal |
| 4100-4199 | Docker containers | 100 slots | Mapped from internal 4449 |
| 4200-4299 | Remote bare metal nodes | 100 slots | Network-accessible nodes |

### Rationale

- **Clear separation by installation type:** Each deployment method has its own dedicated port range
- **Sequential numbering within categories:** Easier to track and manage which nodes use which ports
- **Room for expansion:** Docker range supports up to 100 containers; remote range supports up to 100 remote nodes
- **No port conflicts:** Non-overlapping ranges prevent accidental port collisions

### Current Configuration

| Node | Type | Port(s) | URL |
|------|------|---------|-----|
| orion | Bare metal | 4050 (localhost)<br>4449 (LAN) | http://127.0.0.1:4050<br>http://192.168.254.101:4449 |
| orion-alpha | Docker | 4100 | http://127.0.0.1:4100 |

### Examples for Future Nodes

When adding new nodes to your infrastructure, assign ports as follows:

**Docker Containers:**
- docker-node-2: Port 4101
- docker-node-3: Port 4102
- docker-node-4: Port 4103

**Remote Bare Metal Nodes:**
- hill.local: Port 4200
- server1.local: Port 4201
- server2.local: Port 4202

**Adding a New Node**

When using `mystnodes.sh node add`, follow this pattern:
```bash
# Docker node (next available in 4100-4199 range)
./mystnodes.sh node add docker-node-2 127.0.0.1 4101 myst mystberry

# Remote bare metal node (next available in 4200-4299 range)
./mystnodes.sh node add hill.local 192.168.1.100 4200 myst custompass
```

## Quick Start

### Check Node Status
```bash
# Quick health check
./check-nodes.sh status

# Full report
./check-nodes.sh full
```

### Access TequilAPI Directly
```bash
# Bare metal node (localhost)
curl -u myst:mystberry http://127.0.0.1:4050/healthcheck

# Bare metal node (LAN)
curl -u myst:mystberry http://192.168.254.101:4449/healthcheck

# Docker node
curl -u myst:mystberry http://127.0.0.1:4100/healthcheck
```

### Extract Latest API Documentation
```bash
./extract-tequila-docs.sh
```

## Documentation

Comprehensive documentation is available in the [`docs/`](docs/) directory:

- **[TEQUILA_API_REFERENCE.md](docs/TEQUILA_API_REFERENCE.md)** - Complete API reference (223 endpoints)
- **[NODE_ACCESS_GUIDE.md](docs/NODE_ACCESS_GUIDE.md)** - Node access and configuration guide
- **[DOCKER_NODE_TROUBLESHOOTING.md](docs/DOCKER_NODE_TROUBLESHOOTING.md)** - Docker setup troubleshooting
- **[TEQUILA_API_DOCS.md](docs/TEQUILA_API_DOCS.md)** - TequilAPI introduction and examples
- **[tequila_api_baremetal_*.json](docs/)** - Raw Swagger specification

See [docs/CLAUDE.md](docs/CLAUDE.md) for detailed documentation overview.

## Architecture

### Core Design Patterns

**Dual-Mode Operation:**
- Interactive mode: Arrow-key navigation with menu state tracking
- CLI mode: Command-line argument parsing and execution

**Communication:**
- HTTP API calls to TequilAPI (not SSH)
- JSON response parsing with jq
- HTTP Basic Authentication

**Configuration Storage:**
- `~/.mystnodes_nodes` - Node entries
- `~/.mystnodes_identities` - Cached identity information
- `~/.mystnodes_config` - Global configuration

### TequilAPI Integration

All node operations use authenticated HTTP requests:
```bash
curl -u "$USERNAME:$PASSWORD" "http://$HOST:$PORT/endpoint"
```

**Key Endpoints:**
- `/healthcheck` - Node health and version
- `/identities` - Identity management
- `/services` - Service control
- `/sessions` - Session history
- `/location` - IP and location
- `/nat/type` - NAT traversal status

## Development Roadmap

### Phase 1: Core Node Management (Current)
- ✅ Basic project structure
- ✅ Node configuration and access
- ✅ Health check and status monitoring
- 🚧 Configuration storage system
- 🚧 Simple identity listing

### Phase 2: Identity & Service Management
- [ ] Full identity management (create, unlock, balance)
- [ ] Provider service controls (start, stop, monitor)
- [ ] Session history and statistics
- [ ] Earnings tracking and reporting

### Phase 3: Dashboard & Monitoring
- [ ] Real-time dashboard (tmux-based or terminal UI)
- [ ] Aggregated statistics across all nodes
- [ ] Alert system for node failures
- [ ] Export functionality for reports

### Phase 4: Console UI Enhancement
- [ ] Enhanced terminal UI (dialog/whiptail)
- [ ] Interactive charts and graphs (ASCII art)
- [ ] Configuration wizard for first-time setup

### Phase 5: Web UI (Future)
- [ ] Web-based dashboard
- [ ] WebSocket support for real-time updates
- [ ] Multi-user support with authentication

## Dependencies

### Required
- **bash** - Core shell functionality
- **curl** - HTTP API communication
- **jq** - JSON parsing (auto-installs if missing)

### Optional
- **tmux** - Live dashboard view (auto-installs)
- **bc** - Floating-point calculations for earnings
- **python3** - JSON processing and formatting

### Standard Utilities
- grep, sed, awk, date

## Installation

**Currently:** Clone and use utilities directly
```bash
git clone https://github.com/apotato369550/my-mystnodes-ui.git
cd my-mystnodes-ui
chmod +x *.sh
./check-nodes.sh status
```

**Future:** Installation script will handle dependencies and configuration

## Configuration

### Node Configuration Format

`~/.mystnodes_nodes` (future):
```
NODE_NAME|HOST:PORT|USERNAME:PASSWORD
```

Example:
```
bare-metal|127.0.0.1:4050|myst:mystberry
docker|127.0.0.1:4450|myst:mystberry
remote-node|192.168.1.100:4050|admin:custompass
```

### Global Configuration

`~/.mystnodes_config` (future):
```bash
DEFAULT_USERNAME=myst
DEFAULT_PASSWORD=mystberry
REFRESH_INTERVAL=30
ENABLE_ALERTS=true
```

## Integration with Homelab Manager

MystNodes UI shares architectural patterns with [homelab-manager](../homelab-manager/):

**Shared Patterns:**
- Dual-mode operation (interactive + CLI)
- Home directory configuration
- Arrow-key navigation menus
- Color-coded output
- Auto-dependency installation

**Key Differences:**
- Communication: HTTP API vs SSH
- Authentication: Basic Auth vs SSH keys
- Data format: JSON vs command output
- Node types: Mysterium nodes vs generic systems

## Security Considerations

### Current Setup
- Nodes bound to localhost only (127.0.0.1)
- Default credentials acceptable for local development
- No external API exposure

### Production Recommendations
1. Change default credentials
2. Use strong passwords
3. Implement firewall rules
4. Consider reverse proxy with HTTPS
5. Enable read-only mode for monitoring

### Sensitive Data
- Never commit credentials to git
- API keys stored in config files (home directory protected)
- Identities contain public blockchain addresses

## Contributing

This project is in active development. Contributions welcome!

### Development Setup
1. Clone the repository
2. Ensure Mysterium nodes are running and accessible
3. Test utilities with `./check-nodes.sh`
4. Follow patterns in `CLAUDE.md`

### Code Style
- Follow existing bash patterns
- Use ANSI colors for output
- Implement error handling
- Add comments for complex logic
- Test with both node types

## Testing

### Current Testing
- Manual testing with `check-nodes.sh`
- API endpoint verification with curl
- JSON parsing validation

### Future Testing (Planned)
- `test-mystnodes.sh` - Comprehensive test suite
- Automated API testing
- Error handling verification
- Multi-node scenario testing

## Troubleshooting

### Node Not Responding
```bash
# Check if node is running
systemctl status mysterium-node  # bare metal
docker ps | grep myst            # Docker

# Test API directly
curl -u myst:mystberry http://127.0.0.1:4050/healthcheck
```

### Docker Node Issues
See [docs/DOCKER_NODE_TROUBLESHOOTING.md](docs/DOCKER_NODE_TROUBLESHOOTING.md) for:
- TequilAPI binding configuration
- Port forwarding issues
- Container restart procedures

### Permission Errors
```bash
chmod +x *.sh  # Make scripts executable
```

## Version History

### v0.1.0 - Foundation (Current)
- Initial project structure
- TequilAPI documentation extraction
- Node status checker utility
- Docker node configuration fix
- Comprehensive documentation

## License

This project is part of the "Homelab Shennanigans" collection. License TBD.

## Acknowledgments

- Mysterium Network for TequilAPI
- Inspired by homelab-manager architecture
- Documentation generation based on Swagger spec

## Contact

**Developer:** John Andre Yap
**Email:** johnandresyap510@gmail.com
**GitHub:** https://github.com/apotato369550/my-mystnodes-ui

## Related Projects

- **[homelab-manager](../homelab-manager/)** - SSH-based homelab node management
- **[mistral-sysadmin-script](../mistral-sysadmin-script/)** - AI-powered SRE copilot

---

**Status:** 🚧 Active Development | **Phase:** 1 of 5 | **Completion:** ~20%

For detailed technical documentation, see [CLAUDE.md](CLAUDE.md) and [docs/](docs/).
