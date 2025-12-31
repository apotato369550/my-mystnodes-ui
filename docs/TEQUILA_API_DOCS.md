TequilAPI
A
Written by Adine
Updated over 3 months ago
TequilAPI is the REST API exposed by Mysterium Node.
It provides programmatic access to node operations, including:

Managing identities

Starting/stopping connections

Checking node and provider stats

Configuring node behavior

Accessing settlement and payment information

Submitting feedback, bug reports, and more

The API includes an interactive Swagger UI for exploring and testing requests.

🔗 Accessing TequilAPI
By default, TequilAPI is available locally only:

http://127.0.0.1:4050/docs
/docs → Swagger UI (interactive documentation)

Other endpoints follow the same base URL, e.g. /healthcheck, /connection, /identities

You can run requests with any HTTP client (curl, Postman, Python requests, etc.).

🔒 Authentication
TequilAPI uses HTTP Basic Authentication.
Default credentials are:

username: myst 
password: mystberry
⚠️ These are built-in defaults. If you bind TequilAPI beyond 127.0.0.1, you must set your own username/password.

Set custom credentials:

myst config set tequilapi.auth.username myuser
myst config set tequilapi.auth.password supersecurepass
⚙️ Configuration Options
TequilAPI can be configured through:

myst config set <key> <value>
Bind Address
Controls which interfaces TequilAPI listens on:

myst config set tequilapi.address 127.0.0.1 # default (safe) myst config set tequilapi.address 0.0.0.0 # expose on all interfaces
Port
Change the listening port (default: 4050):

myst config set tequilapi.port 14050
Authentication
Change credentials (default: myst / mystberry):

myst config set tequilapi.auth.username admin 
myst config set tequilapi.auth.password strongpass123
Allowed Hostnames
Limit which hostnames can reach TequilAPI:

myst config set tequilapi.allowed-hostnames .localhost,localhost,.example.com
🔄 Applying Config Changes
After updating configuration, restart the node service so changes take effect.

Now TequilAPI will be running with your new settings.

📚 Example API Calls
Check if the node is healthy:

curl -u myst:mystberry http://127.0.0.1:4050/healthcheck
Response:

{"uptime":"9h43m30.17653267s","process":1,"version":"1.35.4","build_info":{"commit":"5baa18a2","branch":"1.35.4","build_number":"16167610008"}}%             
List identities:

curl -u myst:mystberry http://127.0.0.1:4050/identities
Create a new connection:

curl -u myst:mystberry -X PUT http://127.0.0.1:4050/connection \ -H "Content-Type: application/json" \ -d '{"consumer_id":"0x123","provider_id":"0x456","service_type":"wireguard"}'
Stop the current connection:

curl -u myst:mystberry -X DELETE http://127.0.0.1:4050/connection
📂 API Categories (Overview)
Swagger UI lists all endpoints, but here’s a human-readable overview:

Authentication (/auth/*) – login/logout, node credentials, SSO

Identities (/identities/*) – create, import, unlock, register, balances

Connections (/connection/*) – start/stop VPN connections, status, IP info

Services (/services/*) – run and manage services in provider mode

Proposals (/proposals/*) – query available providers, filter by country/service

Sessions (/sessions/*) – session history, stats, usage, connectivity

Payments & Settlements (/settle/*, /transactor/*) – balances, invoices, fees

Provider Stats (/node/provider/*) – uptime, quality, earnings, transferred data

Configuration (/config/*) – view and set node configuration

Location & NAT (/location, /nat/type) – original IP, NAT type

Utilities – /healthcheck, /stop, /feedback/*, /terms

⚠️ Security Best Practices
Keep TequilAPI bound to 127.0.0.1 unless you really need remote access.

If you expose it on LAN or internet:

Change default credentials immediately.

Use a strong password.

Restrict access with a firewall (only your IP).

Prefer a reverse proxy (Nginx/Apache) with HTTPS + auth.

Remember: TequilAPI grants full control of your node (identities, sessions, payments). Treat it as highly sensitive.

✅ Quick Reference
Default URL: http://127.0.0.1:4050/docs

Default user/pass: myst / mystberry

Change bind address:

myst config set tequilapi.address 0.0.0.0
Change port:

myst config set tequilapi.port 14050
Change auth:

myst config set tequilapi.auth.username myuser myst config set tequilapi.auth.password supersecurepass