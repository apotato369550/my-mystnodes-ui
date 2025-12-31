# Mysterium Node Access Guide

## What You Need to Access Both Nodes

### ✅ Configuration Complete

Both your Mysterium nodes are now accessible and configured:

### 1. Bare Metal Installation
- **Port:** 4050
- **URL:** `http://127.0.0.1:4050`
- **Authentication:** `myst:mystberry`
- **Status:** ✓ Working (uptime: ~68+ hours)
- **Identity:** `0x6e74d97c16a16caa6e4c3164b40ccc36670b4af8`

### 2. Docker Installation (orion-alpha)
- **Port:** 4450
- **URL:** `http://127.0.0.1:4450`
- **Authentication:** `myst:mystberry`
- **Status:** ✓ Working (after configuration fix)
- **Identity:** `0xb4da7958fb612c71495c72ab646c9da6c8b108fe`
- **Container IP:** `172.17.0.2:4449` (internal)

## What Was Fixed

### Docker Node Configuration Issue
The Docker container's TequilAPI was only listening on `127.0.0.1` (localhost) inside the container, preventing Docker port forwarding from working.

**Solution Applied:**
Added TequilAPI binding configuration to `/var/lib/mysterium-node/config-mainnet.toml`:
```toml
[tequilapi]
  address = "0.0.0.0"
  port = 4449
  [tequilapi.auth]
    username = "myst"
    password = "mystberry"
```

Container was restarted to apply changes.

## How to Check Node Status

### Quick Status Check (CLI)

**Bare Metal:**
```bash
curl -u myst:mystberry http://127.0.0.1:4050/healthcheck
```

**Docker:**
```bash
curl -u myst:mystberry http://127.0.0.1:4450/healthcheck
```

### Using the Node Status Checker Script

I've created `check-nodes.sh` for easy monitoring:

```bash
# Check health status of both nodes
./check-nodes.sh status

# List identities
./check-nodes.sh identities

# Show running services
./check-nodes.sh services

# Check node locations
./check-nodes.sh location

# Check NAT type
./check-nodes.sh nat

# Full detailed report
./check-nodes.sh full

# Show help
./check-nodes.sh help
```

### Example Output
```
========================================
Mysterium Node Status Check
========================================

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

## Common TequilAPI Endpoints

Both nodes support the same endpoints:

### Health & System
- `GET /healthcheck` - Node health and version
- `GET /location` - IP and location information
- `GET /nat/type` - NAT type detection

### Identities
- `GET /identities` - List all identities
- `POST /identities` - Create new identity
- `PUT /identities/{id}/unlock` - Unlock identity
- `GET /identities/{id}/balance` - Get MYST token balance

### Services (Provider Mode)
- `GET /services` - List running services
- `POST /services` - Start a service
- `DELETE /services/{id}` - Stop a service

### Sessions & Connections
- `GET /sessions` - Session history
- `GET /connection` - Current connection status
- `PUT /connection` - Start VPN connection
- `DELETE /connection` - Stop connection

### Payments
- `GET /settle/history` - Settlement history
- `GET /transactor/fees` - Current transaction fees

## Files Created

1. **`check-nodes.sh`** - Status checker utility
2. **`TEQUILA_API_REFERENCE.md`** - Complete API documentation (223 endpoints)
3. **`tequila_api_baremetal_20251231_181338.json`** - Swagger spec (225KB)
4. **`DOCKER_NODE_TROUBLESHOOTING.md`** - Docker configuration details

## Authentication

Both nodes use HTTP Basic Authentication:
- **Username:** `myst`
- **Password:** `mystberry`

⚠️ **Security Note:** These are default credentials. Since both nodes are bound to `127.0.0.1` (localhost only), they're only accessible from your local machine, which is safe for development.

If you expose TequilAPI beyond localhost, change these credentials:
```bash
# For bare metal
myst config set tequilapi.auth.username newuser
myst config set tequilapi.auth.password newpass

# For Docker (add to config file and restart)
docker exec orion-alpha sh -c 'echo "[tequilapi.auth]" >> /var/lib/mysterium-node/config-mainnet.toml'
docker exec orion-alpha sh -c 'echo "  username = \"newuser\"" >> /var/lib/mysterium-node/config-mainnet.toml'
docker exec orion-alpha sh -c 'echo "  password = \"newpass\"" >> /var/lib/mysterium-node/config-mainnet.toml'
docker restart orion-alpha
```

## Next Steps for MystNodes UI

Now that both nodes are accessible, you can:

1. **Test the API endpoints** using the extracted documentation
2. **Start building the MystNodes UI** bash script
3. **Implement node management functions** as outlined in `CLAUDE.md`
4. **Add both nodes to configuration** when you create `~/.mystnodes_nodes`

Example configuration entry:
```
bare-metal|127.0.0.1:4050|myst:mystberry
docker|127.0.0.1:4450|myst:mystberry
```

## Troubleshooting

### Docker Node Stops Responding
If the Docker node becomes inaccessible after restart:
1. Check if container is running: `docker ps | grep orion-alpha`
2. Verify configuration persisted: `docker exec orion-alpha cat /var/lib/mysterium-node/config-mainnet.toml`
3. Check container logs: `docker logs orion-alpha --tail 50`
4. Restart container: `docker restart orion-alpha`

### Testing Individual Endpoints
```bash
# Health check
curl -u myst:mystberry http://127.0.0.1:4050/healthcheck | python3 -m json.tool

# List identities
curl -u myst:mystberry http://127.0.0.1:4050/identities | python3 -m json.tool

# Get location
curl -u myst:mystberry http://127.0.0.1:4050/location | python3 -m json.tool
```

## Summary

✅ Both nodes are healthy and accessible
✅ TequilAPI configured and working
✅ Documentation extracted and parsed
✅ Status checker utility created
✅ Ready for MystNodes UI development

All requirements for accessing both Mysterium node installations are now in place!
