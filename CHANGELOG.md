# Changelog

All notable changes to the MystNodes UI project are documented in this file. This project follows [Semantic Versioning](https://semver.org/).

## [0.2.0] - 2026-01-04

### Added
- Hostname resolution feature in `my_myst_nodes` to convert `.local` addresses to IP addresses, bypassing TequilAPI hostname restrictions
- Hostname resolution feature in `check-nodes.sh` to support `.local` hostname connectivity
- LAN access configuration guide in README.md with step-by-step instructions for exposing TequilAPI beyond localhost
- Troubleshooting section for HTTP 403 Forbidden errors on `.local` hostnames
- Earnings calculation function stubs in `my_myst_nodes` (`calculate_earnings()` and `get_earnings_stats()`)

### Changed
- `check-nodes.sh` now loads node configuration from dynamic file sources (`~/.mystnodes_nodes` or `./.mystnodes_nodes`) instead of hardcoded node definitions
- `check-nodes.sh` refactored to use `process_nodes()` function for iterating through configured nodes
- README.md updated to reflect core management script completion and list `my_myst_nodes` as primary entry point
- Phase 1 completion status updated to reflect current 50% progress (~50% of planned features implemented)
- Documentation references updated throughout to guide users to use `my_myst_nodes` instead of `check-nodes.sh`

### Fixed
- Fixed TequilAPI hostname validation issue by implementing automatic resolution of `.local` hostnames to IP addresses in both `my_myst_nodes` and `check-nodes.sh`

## [0.1.0] - 2025-12-31

### Added
- Initial project structure with dual-mode operation (interactive menu + CLI)
- Core `my_myst_nodes` script with 1911 lines of functionality
  - Interactive menu system with arrow-key navigation
  - Node management (add, remove, list, check status)
  - Onboarding workflow with MMN API key configuration
  - Transaction export with CSV and JSON formats
  - Date filtering with RFC3339 format validation
  - Earnings calculation functions (in progress)
- `check-nodes.sh` utility for quick node status verification
- Configuration file support (`~/.mystnodes_nodes` format: `NAME|HOST|PORT|USER|PASS`)
- Transaction export features:
  - CSV export with settlement history and summary footer
  - JSON export with metadata and structured data
  - Wei to MYST token conversion with `bc` precision
  - Paginated settlement history retrieval from TequilAPI
  - Fee structure fetching with fallback endpoints
  - Date range filtering for exports
- `extract-tequila-docs.sh` script for automatic API documentation extraction
- Comprehensive documentation:
  - README.md with features, quick start, configuration, and troubleshooting
  - CLAUDE.md with implementation architecture and development guidelines
  - GEMINI.md with AI-focused context and development patterns
  - docs/TEQUILA_API_REFERENCE.md with 223 endpoints documented
  - docs/NODE_ACCESS_GUIDE.md with node configuration instructions
  - docs/DOCKER_NODE_TROUBLESHOOTING.md with Docker-specific guides
  - docs/TEQUILA_API_DOCS.md with API introduction and examples
- Port mapping conventions for organizing infrastructure:
  - 4050-4099: Bare metal installations (localhost)
  - 4100-4199: Docker containers
  - 4200-4299: Remote bare metal nodes
  - 4449: LAN access for bare metal
- Two Mysterium node installations:
  - Bare metal node (orion) on port 4050/4449
  - Docker node (orion-alpha) on port 4100

### Technical Details
- HTTP-based communication with TequilAPI (no SSH)
- HTTP Basic Authentication for all API calls
- JSON response parsing and formatting
- ANSI color-coded output for interactive mode
- Automatic fallback to default credentials if config file missing
- Error handling with user-friendly messages
- Support for both `.mystnodes_nodes` and fallback configuration

---

**Current Status:** Phase 1 of 5, approximately 50% complete
**Next Phase:** Identity & Service Management (Phase 2)
