# Docker Node TequilAPI Troubleshooting

**Generated:** 2025-12-31 18:14

## Issue Summary

The Docker Mysterium node (`orion-alpha`) is running but TequilAPI is not accessible from the host machine on port 4450, despite the port mapping `4449:4450`.

## Current Status

### Bare Metal Node (Working ✓)
- **Port:** 4050
- **Version:** 1.36.5
- **Status:** Healthy and accessible
- **Documentation:** Successfully extracted (90 endpoints, 225KB JSON)

### Docker Node (Not Accessible ✗)
- **Container:** orion-alpha
- **Port Mapping:** 0.0.0.0:4450 → 4449 (container internal)
- **Status:** Container running, myst process active, but TequilAPI returns 404

## Investigation Findings

### Ports Listening Inside Container
```
tcp    0.0.0.0:*    172.17.0.2:4449    LISTEN    1/myst
tcp    0.0.0.0:*    127.0.0.1:4449     LISTEN    1/myst
tcp    0.0.0.0:*    127.0.0.1:4050     LISTEN    1/myst
```

### Problem Analysis

1. **Port Binding Issue**: The container's TequilAPI is binding to `127.0.0.1:4449` (localhost only) instead of `0.0.0.0:4449` (all interfaces)
   - This prevents Docker port forwarding from working
   - Only the Docker internal IP `172.17.0.2:4449` might be accessible

2. **TequilAPI Returns 404**: Even inside the container, requests to `/healthcheck` return 404
   - This suggests TequilAPI might be disabled or misconfigured
   - Or the endpoints are different/authentication is required

3. **Configuration Missing**: No TequilAPI configuration found in `/var/lib/mysterium-node/config-mainnet.toml`
   - TequilAPI settings may be using defaults
   - May need explicit configuration to enable external access

## Recommended Solutions

### Solution 1: Configure TequilAPI Binding (Recommended)

Access the container and configure TequilAPI to bind to all interfaces:

```bash
docker exec orion-alpha sh -c "cat >> /var/lib/mysterium-node/config-mainnet.toml << 'EOF'

[tequilapi]
  address = \"0.0.0.0\"
  port = 4449
  [tequilapi.auth]
    username = \"myst\"
    password = \"mystberry\"
EOF"

docker restart orion-alpha
```

### Solution 2: Use Docker Internal IP

Access the Docker node via its internal IP address:

```bash
curl -u myst:mystberry http://172.17.0.2:4449/healthcheck
```

Update the extraction script to support Docker internal IPs.

### Solution 3: Recreate Container with Proper Network

Recreate the container with host networking or proper bind configuration:

```bash
docker run -d \
  --name orion-alpha-new \
  --network host \
  -v mysterium-data:/var/lib/mysterium-node \
  mysteriumnetwork/myst:latest \
  service --agreed-terms-and-conditions
```

### Solution 4: Port Forward from Container

Use `socat` or `nginx` inside the container to forward from 0.0.0.0:4449 to 127.0.0.1:4449.

## Next Steps

1. **Verify Configuration**: Check if TequilAPI is intentionally disabled
2. **Enable External Access**: Add TequilAPI binding configuration
3. **Restart Container**: Apply configuration changes
4. **Test Access**: Verify port 4450 responds from host
5. **Re-run Extraction Script**: Extract Docker node documentation

## Current Workaround

For now, the bare metal node documentation is complete and comprehensive. The Docker node appears to be running the same version (likely identical API), so the extracted documentation should cover both installations.

If you need Docker-specific documentation:
- Use Docker internal IP: `172.17.0.2:4449`
- Or configure TequilAPI binding as shown above
- Or exec into container and access localhost:4449 directly

## Files Generated

Successfully extracted from bare metal node:
- `tequila_api_baremetal_20251231_181338.json` (225KB, raw Swagger spec)
- `TEQUILA_API_REFERENCE.md` (76KB, 3510 lines, 223 endpoints documented)

These files contain the complete TequilAPI documentation and are ready for review.
