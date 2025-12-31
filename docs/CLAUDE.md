# Documentation Directory - CLAUDE.md

This directory contains comprehensive documentation for the MystNodes UI project, including API references, troubleshooting guides, and access documentation.

## Purpose

This documentation was extracted and generated to support the development of MystNodes UI, a unified bash-based tool for managing and monitoring Mysterium Network nodes across multiple instances.

## File Overview

### API Documentation

#### TEQUILA_API_REFERENCE.md (76KB, 3,510 lines)
**Purpose:** Complete human-readable API reference for TequilAPI

**Contents:**
- 223 documented API endpoints organized by category
- Authentication, Identities, Services, Sessions, Connections, Payments
- Parameter specifications with types and requirements
- Response schemas and status codes
- 100+ data model definitions with property tables

**Categories Covered:**
- Authentication (`/auth/*`)
- Client health and system info (`/healthcheck`, `/stop`)
- Configuration (`/config/*`)
- Connections (`/connection/*`)
- Identities (`/identities/*`)
- Services (`/services/*`)
- Sessions (`/sessions/*`)
- Provider stats (`/node/provider/*`)
- Payments & Settlements (`/settle/*`, `/transactor/*`)
- Location & NAT (`/location`, `/nat/type`)

**Format:** Markdown with tables for parameters and responses

**Use Cases:**
- Reference when implementing API calls in mystnodes.sh
- Understanding request/response structures
- Discovering available endpoints and capabilities

---

#### tequila_api_baremetal_20251231_181338.json (225KB)
**Purpose:** Raw Swagger/OpenAPI specification from Mysterium Node v1.36.5

**Contents:**
- Complete JSON schema for all TequilAPI endpoints
- Extracted from bare metal installation on port 4050
- Includes all definitions, paths, parameters, and responses
- Machine-readable format for automated processing

**Format:** JSON (Swagger 2.0 specification)

**Use Cases:**
- Generating API client code
- Validating API requests/responses
- Automated testing and documentation generation
- Reference for exact API contract

---

#### TEQUILA_API_DOCS.md (4.3KB)
**Purpose:** Introductory guide to TequilAPI from Mysterium documentation

**Contents:**
- Overview of TequilAPI capabilities
- Default access URL and authentication
- Configuration options (bind address, port, credentials)
- Security best practices
- Example API calls with curl
- Quick reference table

**Source:** Mysterium Network official documentation (Adine, updated 3 months ago)

**Use Cases:**
- Quick reference for common operations
- Understanding default configuration
- Security considerations when exposing TequilAPI

---

### Setup & Access Documentation

#### NODE_ACCESS_GUIDE.md (5.9KB)
**Purpose:** Comprehensive guide for accessing both Mysterium node installations

**Contents:**
- Configuration details for bare metal (port 4050) and Docker (port 4450) nodes
- What was fixed (Docker TequilAPI binding issue)
- Quick status check commands
- Usage guide for check-nodes.sh utility
- Common TequilAPI endpoints reference
- Authentication details and security notes
- Troubleshooting section

**Node Details:**
- **Bare Metal:** `http://127.0.0.1:4050`, Identity: `0x6e74d97c...`
- **Docker:** `http://127.0.0.1:4450`, Identity: `0xb4da7958...`

**Use Cases:**
- Quick reference for node access
- Understanding current node configuration
- Troubleshooting connectivity issues

---

#### DOCKER_NODE_TROUBLESHOOTING.md (3.8KB)
**Purpose:** Analysis and solutions for Docker node TequilAPI access issues

**Contents:**
- Issue summary and investigation findings
- Root cause analysis (localhost-only binding)
- Port binding problem explanation
- Four recommended solution approaches
- Configuration examples
- Workaround options

**Problem Solved:**
Docker container's TequilAPI was binding to `127.0.0.1:4449` instead of `0.0.0.0:4449`, preventing Docker port forwarding from working.

**Solution Applied:**
Added TequilAPI binding configuration to container's config file and restarted.

**Use Cases:**
- Understanding Docker networking with TequilAPI
- Troubleshooting similar issues in future
- Reference for configuration changes

---

## How This Documentation Was Generated

### Extraction Process

1. **Health Check:** Validated both nodes were running
2. **Swagger Extraction:** Retrieved `/docs/swagger.json` from TequilAPI
3. **JSON Parsing:** Validated and pretty-printed JSON specification
4. **Markdown Generation:** Python script parsed Swagger spec and generated human-readable docs
5. **Categorization:** Endpoints organized by tags (Authentication, Identities, Services, etc.)

### Tools Used

- **extract-tequila-docs.sh:** Automated extraction script (parent directory)
- **curl:** HTTP requests to TequilAPI endpoints
- **Python 3:** JSON parsing and Markdown generation
- **jq:** JSON validation and formatting

### Documentation Coverage

- **90 API endpoints** discovered and documented
- **223 endpoint methods** (GET, POST, PUT, DELETE) detailed
- **100+ data models** with property specifications
- **2 node installations** analyzed (bare metal + Docker)

## Integration with MystNodes UI

This documentation supports the planned mystnodes.sh implementation:

### API Functions to Implement

Based on the extracted documentation, implement these function categories:

1. **Health & Status:**
   - `check_node_health()` → `/healthcheck`
   - `get_node_status()` → `/healthcheck`, `/location`, `/nat/type`

2. **Identity Management:**
   - `list_identities()` → `GET /identities`
   - `create_identity()` → `POST /identities`
   - `unlock_identity()` → `PUT /identities/{id}/unlock`
   - `get_identity_balance()` → `GET /identities/{id}/balance`

3. **Service Control:**
   - `list_services()` → `GET /services`
   - `start_service()` → `POST /services`
   - `stop_service()` → `DELETE /services/{id}`

4. **Session Monitoring:**
   - `list_sessions()` → `GET /sessions`
   - `get_session_stats()` → `GET /sessions/stats`

5. **Provider Stats:**
   - `get_provider_stats()` → `GET /node/provider/*`

### Authentication Pattern

All API calls require HTTP Basic Authentication:
```bash
curl -u "${USERNAME}:${PASSWORD}" "http://${HOST}:${PORT}/endpoint"
```

Default credentials: `myst:mystberry`

### Node Configuration Format

For `~/.mystnodes_nodes`:
```
NODE_NAME|HOST:PORT|USERNAME:PASSWORD
```

Example:
```
bare-metal|127.0.0.1:4050|myst:mystberry
docker|127.0.0.1:4450|myst:mystberry
```

## Maintenance Notes

### Keeping Documentation Current

- Re-run `extract-tequila-docs.sh` when nodes are upgraded
- Check for API version changes in `/healthcheck` response
- Compare generated JSON files to detect endpoint additions/removals
- Update NODE_ACCESS_GUIDE.md if node configurations change

### Version Information

**Current API Version:** 1.36.5 (both nodes)
**Documentation Generated:** 2025-12-31
**Swagger Spec Version:** 2.0 (Swagger format, not API version)

### Future Enhancements

1. **Automated Diff Checking:** Compare API versions between nodes
2. **Change Detection:** Track API endpoint additions/removals over time
3. **Example Requests:** Add example request/response pairs for common operations
4. **Interactive API Explorer:** Consider web-based API testing interface

## Security Considerations

### Credential Storage
- Documentation contains default credentials (myst:mystberry)
- These are safe for localhost-only binding
- Change credentials if exposing TequilAPI beyond 127.0.0.1

### API Exposure
- Current configuration: localhost-only (safe)
- If exposing on LAN/internet:
  - Change default credentials immediately
  - Use strong passwords
  - Implement firewall rules
  - Consider reverse proxy with HTTPS

### Sensitive Data
- Identities contain blockchain addresses (public information)
- API keys and tokens should never be committed to git
- Service configurations may contain sensitive routing information

## Contributing to Documentation

When adding new documentation to this directory:

1. **Use Descriptive Filenames:** Follow pattern `COMPONENT_TYPE.md`
2. **Include Headers:** Purpose, Contents, Use Cases sections
3. **Update This File:** Add entry to File Overview section
4. **Timestamp Changes:** Note when documentation was last updated
5. **Cross-Reference:** Link related documentation files

## Quick Reference

### Essential Documentation Files

For most development tasks, start with:

1. **NODE_ACCESS_GUIDE.md** - How to access nodes
2. **TEQUILA_API_REFERENCE.md** - What endpoints are available
3. **TEQUILA_API_DOCS.md** - Common patterns and examples

### File Sizes and Line Counts

- TEQUILA_API_REFERENCE.md: 76KB, 3,510 lines
- tequila_api_baremetal_*.json: 225KB, raw JSON
- NODE_ACCESS_GUIDE.md: 5.9KB
- DOCKER_NODE_TROUBLESHOOTING.md: 3.8KB
- TEQUILA_API_DOCS.md: 4.3KB

Total documentation: ~320KB
