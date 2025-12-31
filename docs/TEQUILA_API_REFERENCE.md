# TequilAPI Reference

**Generated:** 2025-12-31 18:16:11

**Version:** dev

**Description:** The purpose of this documentation is to provide developers an insight of how to
interact with Mysterium Node via Tequila API.
This should demonstrate all the possible API calls with described parameters and responses.

**Host:** 127.0.0.1:4050

---

## Table of Contents

- [Authentication](#authentication)
- [Client](#client)
- [Configuration](#configuration)
- [Connection](#connection)
- [Countries](#countries)
- [Decrease](#decrease)
- [Entertainment](#entertainment)
- [Exchange](#exchange)
- [Feedback](#feedback)
- [Identities](#identities)
- [Identity](#identity)
- [Location](#location)
- [MMN](#mmn)
- [NAT](#nat)
- [Order](#order)
- [Proposal](#proposal)
- [SSO](#sso)
- [Service](#service)
- [Session](#session)
- [Terms](#terms)
- [UI](#ui)
- [Uncategorized](#uncategorized)
- [export](#export)
- [node](#node)
- [provider](#provider)

---

## Authentication

### POST /auth/authenticate

**Summary:** Authenticate

**Description:** Authenticates user and issues auth token

**Operation ID:** Authenticate

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | No description |

**Responses:**

- **200:** Authentication succeeded
- **400:** Failed to parse or request validation failed
- **401:** Authentication failed

---

### POST /auth/login

**Summary:** Login

**Description:** Authenticates user and sets cookie with issued auth token

**Operation ID:** Login

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | No description |

**Responses:**

- **200:** Authentication succeeded
- **400:** Failed to parse or request validation failed
- **401:** Authentication failed

---

### DELETE /auth/logout

**Summary:** Logout

**Description:** Clears authentication cookie

**Operation ID:** Logout

**Responses:**

- **200:** Logged out successfully

---

### PUT /auth/password

**Summary:** Change password

**Description:** Changes user password

**Operation ID:** changePassword

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | No description |

**Responses:**

- **200:** Password changed successfully
- **400:** Failed to parse or request validation failed
- **401:** Unauthorized

---

## Client

### GET /healthcheck

**Summary:** Returns information about client

**Description:** Returns health check information about client

**Operation ID:** healthCheck

**Responses:**

- **200:** Health check information

---

### POST /stop

**Summary:** Stops client

**Description:** Initiates client termination

**Operation ID:** applicationStop

**Responses:**

- **202:** Request accepted, stopping

---

## Configuration

### GET /config

**Summary:** Returns current configuration values

**Description:** Returns default configuration

**Operation ID:** getConfig

**Responses:**

- **200:** Currently active configuration

---

### GET /config/default

**Summary:** Returns default configuration

**Description:** Returns default configuration

**Operation ID:** getDefaultConfig

**Responses:**

- **200:** Default configuration values

---

### GET /config/user

**Summary:** Returns current user configuration

**Description:** Returns current user configuration

**Operation ID:** getUserConfig

**Responses:**

- **200:** User set configuration values

---

### POST /config/user

**Summary:** Sets and returns user configuration

**Description:** For keys present in the payload, it will set or remove the user config values (if the key is null). Changes are persisted to the config file.

**Operation ID:** serUserConfig

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | configuration keys/values |

**Responses:**

- **200:** User configuration
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

## Connection

### GET /connection

**Summary:** Returns connection status

**Description:** Returns status of current connection

**Operation ID:** connectionStatus

**Responses:**

- **200:** Status
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### PUT /connection

**Summary:** Starts new connection

**Description:** Consumer opens connection to provider

**Operation ID:** connectionCreate

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | Parameters in body (consumer_id, provider_id, service_type) required for creating new connection |

**Responses:**

- **201:** Connection started
- **400:** Failed to parse or request validation failed
- **422:** Unable to process the request at this point
- **500:** Internal server error

---

### DELETE /connection

**Summary:** Stops connection

**Description:** Stops current connection

**Operation ID:** connectionCancel

**Responses:**

- **202:** Connection stopped
- **400:** Failed to parse or request validation failed
- **422:** Unable to process the request at this point (e.g. no active connection exists)
- **500:** Internal server error

---

### GET /connection/ip

**Summary:** Returns IP address

**Description:** Returns current public IP address

**Operation ID:** getConnectionIP

**Responses:**

- **200:** Public IP address
- **503:** Service unavailable

---

### GET /connection/location

**Summary:** Returns connection location

**Description:** Returns connection locations

**Operation ID:** getConnectionLocation

**Responses:**

- **200:** Connection locations
- **503:** Service unavailable

---

### GET /connection/proxy/ip

**Summary:** Returns IP address

**Description:** Returns proxy public IP address

**Operation ID:** getProxyIP

**Responses:**

- **200:** Public IP address
- **503:** Service unavailable

---

### GET /connection/proxy/location

**Summary:** Returns proxy connection location

**Description:** Returns proxy connection locations

**Operation ID:** getProxyLocation

**Responses:**

- **200:** Proxy connection locations
- **503:** Service unavailable

---

### GET /connection/statistics

**Summary:** Returns connection statistics

**Description:** Returns statistics about current connection

**Operation ID:** connectionStatistics

**Responses:**

- **200:** Connection statistics

---

### GET /connection/traffic

**Summary:** Returns connection traffic information

**Description:** Returns traffic information about requested connection

**Operation ID:** connectionTraffic

**Responses:**

- **200:** Connection traffic
- **400:** Failed to parse or request validation failed

---

## Countries

### GET /proposals/countries

**Summary:** Returns number of proposals per country

**Description:** Returns a list of countries with a number of proposals

**Operation ID:** listCountries

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| provider_id | string | query | No | id of provider proposals |
| service_type | string | query | No | the service type of the proposal. Possible values are "openvpn", "wireguard" and "noop" |
| access_policy | string | query | No | the access policy id to filter the proposals by |
| access_policy_source | string | query | No | the access policy source to filter the proposals by |
| country | string | query | No | If given will filter proposals by node location country. |
| ip_type | string | query | No | IP Type (residential, datacenter, etc.). |
| compatibility_min | integer | query | No | Minimum compatibility level of the proposal. |
| compatibility_max | integer | query | No | Maximum compatibility level of the proposal. |
| quality_min | number | query | No | Minimum quality of the provider. |
| nat_compatibility | string | query | No | Pick nodes compatible with NAT of specified type. Specify "auto" to probe NAT. |

**Responses:**

- **200:** List of countries
- **500:** Internal server error

---

## Decrease

### POST /transactor/stake/decrease

**Summary:** Decreases stake

**Description:** Decreases stake on eth blockchain via the mysterium transactor.

**Operation ID:** Stake

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | decrease stake request |

**Responses:**

- **200:** Payout info registered
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

## Entertainment

### GET /entertainment

**Summary:** Estimate entertainment durations/data cap for the MYST amount specified.

**Description:** Estimate entertainment durations/data cap for the MYST amount specified.

**Operation ID:** Estimate

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| amount | integer | query | Yes | Amount of MYST to give entertainment estimates for. |

**Responses:**

- **200:** Entertainment estimates
- **500:** Internal server error

---

## Exchange

### GET /exchange/myst/{currency}

**Summary:** Returns the myst price in the given currency

**Description:** Returns the myst price in the given currency (dai is deprecated)

**Operation ID:** ExchangeMyst

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| currency | string | path | Yes | Currency to which MYST is converted |

**Responses:**

- **200:** MYST price in given currency
- **404:** Currency is not supported
- **500:** Internal server error

---

## Feedback

### POST /feedback/bug-report

**Summary:** Creates a bug report

**Description:** Creates a bug report with logs

**Operation ID:** bugReport

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | Report a bug |

**Responses:**

- **200:** Bug report response
- **400:** Failed to parse or request validation failed
- **429:** Too many requests (max. 1/minute)
- **500:** Internal server error
- **503:** Unavailable

---

### POST /feedback/issue

**Summary:** Reports user issue to github

**Description:** Reports user issue to github

**Operation ID:** reportIssueGithub

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | Bug report issue request |

**Responses:**

- **200:** Issue reported
- **400:** Failed to parse or request validation failed
- **429:** Too many requests (max. 1/minute)
- **500:** Internal server error
- **503:** Unavailable

---

### POST /feedback/issue/intercom

**Summary:** Reports user issue to intercom

**Description:** Reports user user to intercom

**Operation ID:** reportIssueIntercom

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | Report issue request |

**Responses:**

- **201:** Issue reported
- **400:** Failed to parse or request validation failed
- **429:** Too many requests (max. 1/minute)
- **500:** Internal server error
- **503:** Unavailable

---

## Identities

### POST /identities-import

**Summary:** Imports a given identity.

**Description:** Imports a given identity returning it is a blob of text which can later be used to import it back.

**Operation ID:** importIdentity

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | Parameter in body used to import an identity. |

**Responses:**

- **200:** Unlocked identity returned
- **400:** Failed to parse or request validation failed
- **422:** Unable to process the request at this point
- **500:** Internal server error

---

## Identity

### GET /identities

**Summary:** Returns identities

**Description:** Returns list of identities

**Operation ID:** listIdentities

**Responses:**

- **200:** List of identities

---

### POST /identities

**Summary:** Creates new identity

**Description:** Creates identity and stores in keystore encrypted with passphrase

**Operation ID:** createIdentity

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | Parameter in body (passphrase) required for creating new identity |

**Responses:**

- **200:** Identity created
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### PUT /identities/current

**Summary:** Returns my current identity

**Description:** Tries to retrieve the last used identity, the first identity, or creates and returns a new identity

**Operation ID:** currentIdentity

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | Parameter in body (passphrase) required for creating new identity |

**Responses:**

- **200:** Unlocked identity returned
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### GET /identities/{id}

**Summary:** Get identity

**Description:** Provide identity details

**Operation ID:** getIdentity

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| id | string | path | Yes | hex address of identity |

**Responses:**

- **200:** Identity retrieved
- **404:** ID not found
- **500:** Internal server error

---

### PUT /identities/{id}/balance/refresh

**Summary:** Refresh balance of given identity

**Description:** Refresh balance of given identity

**Operation ID:** balance

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| id | string | path | Yes | hex address of identity |

**Responses:**

- **200:** Updated balance
- **404:** ID not found

---

### GET /identities/{id}/beneficiary

**Summary:** Provide identity beneficiary address

**Description:** Provides beneficiary address for given identity

**Operation ID:** address

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| id | string | path | Yes | hex address of identity |

**Responses:**

- **200:** Beneficiary retrieved
- **500:** Internal server error

---

### POST /identities/{id}/register

**Summary:** Registers identity

**Description:** Registers identity on Mysterium Network smart contracts using Transactor

**Operation ID:** RegisterIdentity

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| id | string | path | Yes | Identity address to register |
| body | object | body | No | all body parameters a optional |

**Responses:**

- **200:** Identity registered.
- **202:** Identity registration accepted and will be processed.
- **400:** Failed to parse or request validation failed
- **422:** Unable to process the request at this point
- **500:** Internal server error

---

### GET /identities/{id}/registration

**Summary:** Provide identity registration status

**Description:** Provides registration status for given identity, if identity is not registered - provides additional data required for identity registration

**Operation ID:** identityRegistration

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| id | string | path | Yes | hex address of identity |

**Responses:**

- **200:** Status retrieved
- **404:** ID not found
- **500:** Internal server error

---

### PUT /identities/{id}/unlock

**Summary:** Unlocks identity

**Description:** Uses passphrase to decrypt identity stored in keystore

**Operation ID:** unlockIdentity

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| id | string | path | Yes | Identity stored in keystore |
| body | object | body | No | Parameter in body (passphrase) required for unlocking identity |

**Responses:**

- **202:** Identity unlocked
- **400:** Failed to parse or request validation failed
- **403:** Unlock failed
- **404:** ID not found

---

## Location

### GET /location

**Summary:** Returns original location

**Description:** Returns original locations

**Operation ID:** getOriginLocation

**Responses:**

- **200:** Original locations

---

## MMN

### POST /mmn/api-key

**Summary:** sets MMN's API key

**Description:** sets MMN's API key

**Operation ID:** setApiKey

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | api_key field |

**Responses:**

- **200:** API key has been set
- **400:** Failed to parse or request validation failed
- **422:** Unable to process the request at this point
- **500:** Internal server error

---

### DELETE /mmn/api-key

**Summary:** Clears MMN's API key from config

**Description:** Clears MMN's API key from config

**Operation ID:** clearApiKey

**Responses:**

- **200:** MMN API key removed
- **500:** Internal server error

---

### GET /mmn/claim-link

**Summary:** Generate claim link

**Description:** Generates claim link to claim Node on mystnodes.com with a click

**Operation ID:** getClaimLink

**Responses:**

- **200:** Link response
- **500:** Internal server error

---

### GET /mmn/onboarding

**Summary:** Generate onboarding link

**Description:** Generates onboarding link for one click onboarding

**Operation ID:** GetOnboardingLink

**Responses:**

- **200:** Link response
- **500:** Internal server error

---

### POST /mmn/onboarding

**Summary:** verify grant for onboarding

**Description:** verify grant for onboarding

**Operation ID:** VerifyGrant

**Responses:**

- **200:** Link response
- **500:** Internal server error

---

### GET /mmn/report

**Summary:** returns MMN's API key

**Description:** returns MMN's API key

**Operation ID:** getApiKey

**Responses:**

- **200:** MMN's API key

---

## NAT

### GET /nat/type

**Summary:** Shows NAT type in terms of traversal capabilities.

**Description:** Returns NAT type. May produce invalid result while VPN connection is established

**Operation ID:** NATTypeDTO

**Responses:**

- **200:** NAT type
- **500:** Internal server error

---

## Order

### GET /v2/identities/{id}/payment-order

**Summary:** Get all orders for identity

**Description:** Gets all orders for a given identity from the pilvytis service

**Operation ID:** getPaymentGatewayOrders

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| id | string | path | Yes | Identity for which to get orders |

**Responses:**

- **200:** List of payment orders
- **500:** Internal server error

---

### GET /v2/identities/{id}/payment-order/{order_id}

**Summary:** Get order

**Description:** Gets an order for a given identity and order id combo from the pilvytis service

**Operation ID:** getPaymentGatewayOrder

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| id | string | path | Yes | Identity for which to get an order |
| order_id | integer | path | Yes | Order id |

**Responses:**

- **200:** Order object
- **500:** Internal server error

---

### GET /v2/identities/{id}/payment-order/{order_id}/invoice

**Summary:** Get invoice

**Description:** Gets an invoice for payment order matching the given ID and identity

**Operation ID:** getPaymentGatewayOrderInvoice

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| id | string | path | Yes | Identity for which to get an order invoice |
| order_id | integer | path | Yes | Order id |

**Responses:**

- **200:** Invoice PDF (binary)
- **500:** Internal server error

---

### GET /v2/identities/{id}/registration-payment

**Summary:** Check for registration payment

**Description:** Checks if a registration payment order for an identity has been paid in pilvytis.

**Operation ID:** getRegistrationPaymentStatus

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| id | string | path | Yes | Identity for which to check |

**Responses:**

- **200:** Registration order status
- **500:** Internal server error

---

### POST /v2/identities/{id}/{gw}/payment-order

**Summary:** Create order

**Description:** Takes the given data and tries to create a new payment order in the pilvytis service.

**Operation ID:** createPaymentGatewayOrder

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| id | string | path | Yes | Identity for which to create an order |
| gw | string | path | Yes | Gateway for which a payment order is created |
| body | object | body | No | Required data to create a new order |

**Responses:**

- **200:** Payment order
- **500:** Internal server error

---

### GET /v2/payment-order-gateways

**Summary:** Get payment gateway configuration.

**Description:** Returns gateway configuration including supported currencies, minimum amounts, etc.

**Operation ID:** getPaymentGateways

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| options_currency | string | query | No | Currency for payment order options |

**Responses:**

- **200:** List of payment gateways
- **500:** Internal server error

---

## Proposal

### GET /proposals

**Summary:** Returns proposals

**Description:** Returns list of proposals filtered by provider id

**Operation ID:** listProposals

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| provider_id | string | query | No | id of provider proposals |
| service_type | string | query | No | the service type of the proposal. Possible values are "openvpn", "wireguard" and "noop" |
| access_policy | string | query | No | the access policy id to filter the proposals by |
| access_policy_source | string | query | No | the access policy source to filter the proposals by |
| country | string | query | No | If given will filter proposals by node location country. |
| ip_type | string | query | No | IP Type (residential, datacenter, etc.). |
| compatibility_min | integer | query | No | Minimum compatibility level of the proposal. |
| compatibility_max | integer | query | No | Maximum compatibility level of the proposal. |
| quality_min | number | query | No | Minimum quality of the provider. |
| nat_compatibility | string | query | No | Pick nodes compatible with NAT of specified type. Specify "auto" to probe NAT. |

**Responses:**

- **200:** List of proposals
- **500:** Internal server error

---

### GET /proposals/filter-presets

**Summary:** Returns proposal filter presets

**Description:** Returns proposal filter presets

**Operation ID:** proposalFilterPresets

**Responses:**

- **200:** List of proposal filter presets
- **500:** Internal server error

---

## SSO

### GET /auth/login-mystnodes

**Summary:** LoginMystnodesInit

**Description:** SSO init endpoint to auth via mystnodes

**Operation ID:** LoginMystnodesInit

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| redirect_url | string | query | No | a redirect to send authorization grant to |

**Responses:**

- **200:** link response

---

### POST /auth/login-mystnodes

**Summary:** LoginMystnodesWithGrant

**Description:** SSO login using grant provided by mystnodes.com

**Operation ID:** LoginMystnodesWithGrant

**Responses:**

- **200:** grant was verified against mystnodes using PKCE workflow. This will set access token cookie.
- **401:** grant failed to be verified

---

## Service

### GET /services

**Summary:** List of services

**Description:** ServiceList provides a list of running services on the node.

**Operation ID:** ServiceListResponse

**Responses:**

- **200:** List of running services
- **500:** Internal server error

---

### POST /services

**Summary:** Starts service

**Description:** Provider starts serving new service to consumers

**Operation ID:** serviceStart

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | Parameters in body (providerID) required for starting new service |

**Responses:**

- **201:** Initiated service start
- **400:** Failed to parse or request validation failed
- **422:** Unable to process the request at this point
- **500:** Internal server error

---

### GET /services/:id

**Summary:** Information about service

**Description:** ServiceGet provides info for requested service on the node.

**Operation ID:** serviceGet

**Responses:**

- **200:** Service detailed information
- **404:** Service not found
- **500:** Internal server error

---

### DELETE /services/:id

**Summary:** Stops service

**Description:** Initiates service stop

**Operation ID:** serviceStop

**Responses:**

- **202:** Service Stop initiated
- **404:** No service exists
- **500:** Internal server error

---

## Session

### GET /sessions

**Summary:** Returns sessions history

**Description:** Returns list of sessions history filtered by given query

**Operation ID:** sessionList

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| page_size | integer | query | No | Number of items per page. |
| page | integer | query | No | Page to filter the items by. |
| date_from | string | query | No | Filter the sessions from this date. Formatted in RFC3339 e.g. 2020-07-01. |
| date_to | string | query | No | Filter the sessions until this date. Formatted in RFC3339 e.g. 2020-07-30. |
| direction | string | query | No | Direction to filter the sessions by. Possible values are "Provided", "Consumed". |
| consumer_id | string | query | No | Consumer identity to filter the sessions by. |
| hermes_id | string | query | No | Hermes ID to filter the sessions by. |
| provider_id | string | query | No | Provider identity to filter the sessions by. |
| service_type | string | query | No | Service type to filter the sessions by. |
| status | string | query | No | Status to filter the sessions by. Possible values are "New", "Completed". |

**Responses:**

- **200:** List of sessions
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### GET /sessions/stats-aggregated

**Summary:** Returns sessions stats

**Description:** Returns aggregated statistics of sessions filtered by given query

**Operation ID:** sessionStatsAggregated

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| date_from | string | query | No | Filter the sessions from this date. Formatted in RFC3339 e.g. 2020-07-01. |
| date_to | string | query | No | Filter the sessions until this date. Formatted in RFC3339 e.g. 2020-07-30. |
| direction | string | query | No | Direction to filter the sessions by. Possible values are "Provided", "Consumed". |
| consumer_id | string | query | No | Consumer identity to filter the sessions by. |
| hermes_id | string | query | No | Hermes ID to filter the sessions by. |
| provider_id | string | query | No | Provider identity to filter the sessions by. |
| service_type | string | query | No | Service type to filter the sessions by. |
| status | string | query | No | Status to filter the sessions by. Possible values are "New", "Completed". |

**Responses:**

- **200:** Session statistics
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### GET /sessions/stats-daily

**Summary:** Returns sessions stats

**Description:** Returns aggregated daily statistics of sessions filtered by given query (date_from=<now -30d> and date_to=<now> by default)

**Operation ID:** sessionStatsDaily

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| date_from | string | query | No | Filter the sessions from this date. Formatted in RFC3339 e.g. 2020-07-01. |
| date_to | string | query | No | Filter the sessions until this date. Formatted in RFC3339 e.g. 2020-07-30. |
| direction | string | query | No | Direction to filter the sessions by. Possible values are "Provided", "Consumed". |
| consumer_id | string | query | No | Consumer identity to filter the sessions by. |
| hermes_id | string | query | No | Hermes ID to filter the sessions by. |
| provider_id | string | query | No | Provider identity to filter the sessions by. |
| service_type | string | query | No | Service type to filter the sessions by. |
| status | string | query | No | Status to filter the sessions by. Possible values are "New", "Completed". |

**Responses:**

- **200:** Daily session statistics
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

## Terms

### GET /terms

**Summary:** Get terms

**Description:** Return an object with the current terms config

**Operation ID:** getTerms

**Responses:**

- **200:** Terms object

---

### POST /terms

**Summary:** Update terms agreement

**Description:** Takes the given data and tries to update terms agreement config.

**Operation ID:** updateTerms

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | Required data to update terms |

**Responses:**

- **200:** Terms agreement updated
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

## UI

### GET /ui/download-status

**Summary:** Download status

**Description:** DownloadStatus can download one remote release at a time. This endpoint provides status of the download.

**Operation ID:** uiDownloadStatus

**Responses:**

- **200:** download status
- **500:** Internal server error

---

### POST /ui/download-version

**Summary:** Download

**Description:** download a remote node UI release

**Operation ID:** uiDownload

**Responses:**

- **200:** Download in progress
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### GET /ui/info

**Summary:** Node UI information

**Description:** Node UI information

**Operation ID:** ui

**Responses:**

- **200:** Node UI information
- **500:** Internal server error

---

### GET /ui/local-versions

**Summary:** List remote

**Description:** provides a list of node UI releases that have been downloaded or bundled with node

**Operation ID:** uiLocalVersions

**Responses:**

- **200:** Local version list
- **500:** Internal server error

---

### GET /ui/remote-versions

**Summary:** List local

**Description:** provides a list of node UI releases from github repository

**Operation ID:** uiRemoteVersions

**Responses:**

- **200:** Remote version list
- **500:** Internal server error

---

### POST /ui/switch-version

**Summary:** Switch Version

**Description:** switch node UI version to locally available one

**Operation ID:** uiSwitchVersion

**Responses:**

- **200:** version switched
- **400:** Failed to parse or request validation failed
- **422:** Unable to process the request at this point
- **500:** Internal server error

---

## Uncategorized

### GET /access-policies

**Summary:** Returns access policies

**Description:** Returns list of access policies

**Operation ID:** AccessPolicies

**Responses:**

- **200:** List of access policies
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### POST /affiliator/token/{token}/reward

**Summary:** Returns the amount of reward for a token (affiliator)

**Operation ID:** AffiliatorTokenReward

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| token | string | path | Yes | Token for which to lookup the reward |

**Responses:**

- **200:** Token Reward
- **500:** Internal server error

---

### GET /identities/provider/eligibility

**Summary:** Checks if provider is eligible for free registration

**Operation ID:** ProviderEligibility

**Responses:**

- **200:** Eligibility response
- **500:** Internal server error

---

### GET /sessions-connectivity-status

**Summary:** Returns session connectivity status

**Description:** Returns list of session connectivity status

**Operation ID:** ConnectivityStatus

**Responses:**

- **200:** List of connectivity statuses

---

### GET /settle/history

**Summary:** Returns settlement history

**Description:** Returns settlement history

**Operation ID:** settlementList

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| page_size | integer | query | No | Number of items per page. |
| page | integer | query | No | Page to filter the items by. |
| date_from | string | query | No | Filter the settlements from this date. Formatted in RFC3339 e.g. 2020-07-01. |
| date_to | string | query | No | Filter the settlements until this date Formatted in RFC3339 e.g. 2020-07-30. |
| provider_id | string | query | No | Provider identity to filter the sessions by. |
| hermes_id | string | query | No | Hermes ID to filter the sessions by. |
| types | array | query | No | Settlement type to filter the sessions by. "settlement" or "withdrawal" |

**Responses:**

- **200:** Returns settlement history
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### GET /transactor/chains-summary

**Summary:** Returns available chain map

**Operation ID:** Chains

**Responses:**

- **200:** Chain Summary

---

### GET /transactor/fees

**Summary:** Returns fees

**Description:** Returns fees applied by Transactor

**Operation ID:** FeesDTO

**Responses:**

- **200:** Fees applied by Transactor
- **500:** Internal server error

---

### GET /transactor/identities/{id}/eligibility

**Summary:** Checks if given id is eligible for free registration

**Operation ID:** Eligibility

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| id | string | path | Yes | Identity address to register |

**Responses:**

- **200:** Eligibility response
- **500:** Internal server error

---

### POST /transactor/settle/async

**Summary:** forces the settlement of promises for the given provider and hermes

**Description:** Forces a settlement for the hermes promises. Does not wait for completion.

**Operation ID:** SettleAsync

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | Settle request |

**Responses:**

- **202:** Settle request accepted
- **500:** Internal server error

---

### POST /transactor/settle/sync

**Summary:** Forces the settlement of promises for the given provider and hermes

**Description:** Forces a settlement for the hermes promises and blocks until the settlement is complete.

**Operation ID:** SettleSync

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | Settle request |

**Responses:**

- **202:** Settle request accepted
- **500:** Internal server error

---

### POST /transactor/settle/withdraw

**Summary:** Asks to perform withdrawal to l1.

**Description:** Asks to perform withdrawal to l1.

**Operation ID:** Withdraw

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | withdraw request body |

**Responses:**

- **202:** Withdraw request accepted
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### POST /transactor/stake/increase/async

**Summary:** forces the settlement with stake increase of promises for the given provider and hermes.

**Description:** Forces a settlement with stake increase for the hermes promises and does not block.

**Operation ID:** StakeIncreaseAsync

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | settle request body |

**Responses:**

- **202:** Settle request accepted
- **500:** Internal server error

---

### POST /transactor/stake/increase/sync

**Summary:** Forces the settlement with stake increase of promises for the given provider and hermes.

**Description:** Forces a settlement with stake increase for the hermes promises and blocks until the settlement is complete.

**Operation ID:** StakeIncreaseSync

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | Settle request |

**Responses:**

- **202:** Settle request accepted
- **500:** Internal server error

---

### POST /transactor/token/{token}/reward

**Summary:** Returns the amount of reward for a token

**Operation ID:** Reward

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| token | string | path | Yes | Token for which to lookup the reward |

**Responses:**

- **200:** Token Reward
- **500:** Internal server error

---

### GET /v2/transactor/fees

**Summary:** Returns fees

**Description:** Returns fees applied by Transactor

**Operation ID:** CombinedFeesResponse

**Responses:**

- **200:** Fees applied by Transactor
- **500:** Internal server error

---

## export

### POST /export

**Summary:** Exports a given identity

**Description:** Creates identity and stores in keystore encrypted with passphrase

**Operation ID:** Identity

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| body | object | body | No | Parameter in body (passphrase) required for creating new identity |

**Responses:**

- **200:** Identity created
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

## node

### GET /node/latest-release

**Summary:** Latest Node release information

**Description:** Checks for latest Node release package and retrieves its information

**Operation ID:** GetLatestRelease

**Responses:**

- **200:** Latest Node release information
- **500:** Failed to retrieve latest Node release information

---

## provider

### GET /node/monitoring-agent-statuses

**Summary:** Provides Node connectivity statuses from monitoring agent

**Description:** Node connectivity statuses as seen by monitoring agent

**Operation ID:** MonitoringAgentStatuses

**Responses:**

- **200:** Monitoring agent statuses ("success"/"cancelled"/"connect_drop/"connect_fail/"internet_fail)

---

### GET /node/monitoring-status

**Summary:** Provides Node proposal status

**Description:** Node Status as seen by monitoring agent

**Operation ID:** NodeStatus

**Responses:**

- **200:** Node status ("passed"/"failed"/"pending)

---

### GET /node/provider/activity-stats

**Summary:** Provides Node activity stats

**Description:** Node activity stats

**Operation ID:** GetProviderActivityStats

**Responses:**

- **200:** Provider activity stats
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### GET /node/provider/consumers-count

**Summary:** Provides Node consumers number served during a period of time

**Description:** Node unique consumers count served during a period of time.

**Operation ID:** GetProviderConsumersCount

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| range | string | query | No | period of time ("1d", "7d", "30d") |

**Responses:**

- **200:** Provider consumers count
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### GET /node/provider/quality

**Summary:** Provides Node quality

**Description:** Node connectivity quality

**Operation ID:** GetProviderQuality

**Responses:**

- **200:** Provider quality
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### GET /node/provider/series/data

**Summary:** Provides Node data series metrics of transferred bytes

**Description:** Node data series metrics of transferred bytes during a period of time.

**Operation ID:** GetProviderTransferredDataSeries

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| range | string | query | No | period of time ("1d", "7d", "30d") |

**Responses:**

- **200:** Provider time series metrics of transferred bytes
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### GET /node/provider/series/earnings

**Summary:** Provides Node  time series metrics of earnings during a period of time

**Description:** Node time series metrics of earnings during a period of time.

**Operation ID:** GetProviderEarningsSeries

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| range | string | query | No | period of time ("1d", "7d", "30d") |

**Responses:**

- **200:** Provider time series metrics of MYSTT earnings
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### GET /node/provider/series/sessions

**Summary:** Provides Node data series metrics of sessions started during a period of time

**Description:** Node time series metrics of sessions started during a period of time.

**Operation ID:** GetProviderSessionsSeries

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| range | string | query | No | period of time ("1d", "7d", "30d") |

**Responses:**

- **200:** Provider time series metrics of started sessions
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### GET /node/provider/service-earnings

**Summary:** Provides Node earnings per service and total earnings in the all network

**Description:** Node earnings per service and total earnings in the all network.

**Operation ID:** GetProviderServiceEarnings

**Responses:**

- **200:** earnings per service and total earnings
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### GET /node/provider/sessions

**Summary:** Provides Node sessions data during a period of time

**Description:** Node sessions metrics during a period of time

**Operation ID:** GetProviderSessions

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| range | string | query | No | period of time ("1d", "7d", "30d") |

**Responses:**

- **200:** Provider sessions list
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### GET /node/provider/sessions-count

**Summary:** Provides Node sessions number during a period of time

**Description:** Node sessions count during a period of time

**Operation ID:** GetProviderSessionsCount

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| range | string | query | No | period of time ("1d", "7d", "30d") |

**Responses:**

- **200:** Provider sessions count
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

### GET /node/provider/transferred-data

**Summary:** Provides total traffic served by the provider during a period of time

**Description:** Node transferred data during a period of time

**Operation ID:** GetProviderTransferredData

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| range | string | query | No | period of time ("1d", "7d", "30d") |

**Responses:**

- **200:** Provider transferred data
- **400:** Failed to parse or request validation failed
- **500:** Internal server error

---

## Data Models

### APIError

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| error | unknown | No description |
| path | string | No description |
| status | integer | No description |

---

### AccessPolicies

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| entries | array[unknown] | No description |

---

### AccessPolicy

AccessPolicy represents the access controls for proposal

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| id | string | No description |
| source | string | No description |

---

### ActivityStatsResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| active_percent | number | No description |
| online_percent | number | No description |

---

### AuthRequest

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| password | string | No description |
| username | string | No description |

---

### AuthResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| expires_at | string | No description |
| token | string | No description |

---

### BalanceDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| balance | string | No description |
| balance_tokens | unknown | No description |

---

### BeneficiaryAddressRequest

BeneficiaryAddressRequest address of the beneficiary

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| address | string | No description |

---

### BeneficiaryTxStatus

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| change_to | string | No description |
| error | string | No description |
| state | unknown | No description |

---

### BugReport

BugReport represents user input when submitting an issue report

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| description | string | No description |
| email | string | No description |

---

### BuildInfoDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| branch | string | No description |
| build_number | string | No description |
| commit | string | No description |

---

### ChainSummary

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| chains | unknown | No description |
| current_chain | integer | No description |

---

### ChangePasswordRequest

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| new_password | string | No description |
| old_password | string | No description |
| username | string | No description |

---

### CombinedFeesResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| current | unknown | No description |
| hermes_percent | string | No description |
| last | unknown | No description |
| server_time | string | No description |

---

### ConnectOptionsDTO

ConnectOptions holds tequilapi connect options

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| dns | unknown | No description |
| kill_switch | boolean | kill switch option restricting communication only through VPN |
| proxy_port | integer | No description |

---

### ConnectionCreateFilter

ConnectionCreateFilter describes filter for the connection request to lookup
for a requested proposals based on specified params.

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| country_code | string | No description |
| include_monitoring_failed | boolean | No description |
| ip_type | string | No description |
| providers | array[string] | No description |
| sort_by | string | No description |

---

### ConnectionCreateRequestDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| connect_options | unknown | No description |
| consumer_id | string | consumer identity |
| filter | unknown | No description |
| hermes_id | string | hermes identity |
| provider_id | string | provider identity |
| service_type | string | service type. Possible values are "openvpn", "wireguard" and "noop" |

---

### ConnectionDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| consumer_id | string | No description |
| hermes_id | string | No description |
| proposal | unknown | No description |
| session_id | string | No description |
| statistics | unknown | No description |
| status | string | No description |

---

### ConnectionInfoDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| consumer_id | string | No description |
| hermes_id | string | No description |
| proposal | unknown | No description |
| session_id | string | No description |
| status | string | No description |

---

### ConnectionStatisticsDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| bytes_received | integer | No description |
| bytes_sent | integer | No description |
| duration | integer | connection duration in seconds |
| spent_tokens | unknown | No description |
| throughput_received | integer | Download speed in bits per second |
| throughput_sent | integer | Upload speed in bits per second |
| tokens_spent | string | No description |

---

### ConnectionTrafficDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| bytes_received | integer | No description |
| bytes_sent | integer | No description |

---

### ConnectivityStatus

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| entries | array[unknown] | No description |

---

### CreateBugReportResponse

CreateBugReportResponse response for bug report creation

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| email | string | No description |
| identity | string | No description |
| ip | string | No description |
| ip_type | string | No description |
| message | string | No description |
| node_country | string | No description |

---

### CurrencyExchangeDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| amount | number | No description |
| currency | string | No description |

---

### CurrentPriceResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| price_per_gib | string | deprecated |
| price_per_gib_tokens | unknown | No description |
| price_per_hour | string | deprecated |
| price_per_hour_tokens | unknown | No description |
| service_type | string | No description |

---

### DNSOption

DNSOption defines DNS server selection strategy for consumer

---

### DecreaseStakeRequest

DecreaseStakeRequest represents the decrease stake request

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| amount | string | No description |
| id | string | No description |

---

### DownloadNodeUIRequest

DownloadNodeUIRequest request for downloading NodeUI version

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| version | string | No description |

---

### DownloadStatus

Status download status

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| error | string | No description |
| progress_percent | integer | No description |
| status | unknown | No description |
| tag | string | No description |

---

### EarningsDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| earnings | unknown | No description |
| earnings_total | unknown | No description |

---

### EarningsPerServiceResponse

EarningsPerServiceResponse contains information about earnings per service

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| data_transfer_tokens | unknown | No description |
| dvpn_tokens | unknown | No description |
| public_tokens | unknown | No description |
| scraping_tokens | unknown | No description |
| total_data_transfer_tokens | unknown | No description |
| total_dvpn_tokens | unknown | No description |
| total_public_tokens | unknown | No description |
| total_scraping_tokens | unknown | No description |
| total_tokens | unknown | No description |

---

### EligibilityResponse

EligibilityResponse represents the eligibility response

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| eligible | boolean | No description |

---

### EntertainmentEstimateResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| browsing_minutes | integer | No description |
| music_minutes | integer | No description |
| price_gib | number | No description |
| price_min | number | No description |
| traffic_mb | integer | No description |
| video_minutes | integer | No description |

---

### Err

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| code | string | No description |
| detail | string | No description |
| fields | object | No description |
| message | string | No description |

---

### FeesDTO

FeesDTO represents the transactor fees

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| decreaseStake | string | No description |
| decrease_stake_tokens | unknown | No description |
| hermes | integer | deprecated - confusing name |
| hermes_percent | string | No description |
| registration | string | No description |
| registration_tokens | unknown | No description |
| settlement | string | No description |
| settlement_tokens | unknown | No description |

---

### FieldError

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| code | string | No description |
| message | string | No description |

---

### FilterPreset

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| id | integer | No description |
| name | string | No description |

---

### GatewaysResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| currencies | array[string] | No description |
| name | string | No description |
| order_options | unknown | No description |

---

### HealthCheckDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| build_info | unknown | No description |
| process | integer | No description |
| uptime | string | No description |
| version | string | No description |

---

### HistoryType

HistoryType settlement history type

---

### IPDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| ip | string | public IP address |

---

### IdentityBeneficiaryResponseDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| beneficiary | string | No description |
| is_channel_address | boolean | No description |

---

### IdentityCreateRequestDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| passphrase | string | No description |

---

### IdentityCurrentRequestDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| id | string | No description |
| passphrase | string | No description |

---

### IdentityDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| balance | string | deprecated |
| balance_tokens | unknown | No description |
| channel_address | string | No description |
| earnings | string | No description |
| earnings_per_hermes | object | No description |
| earnings_tokens | unknown | No description |
| earnings_total | string | No description |
| earnings_total_tokens | unknown | No description |
| hermes_id | string | No description |
| id | string | identity in Ethereum address format |
| registration_status | string | No description |
| stake | string | No description |

---

### IdentityExportRequestDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| identity | string | No description |
| newpassphrase | string | No description |

---

### IdentityExportResponseDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| address | string | No description |
| crypto | unknown | No description |
| id | string | No description |
| version | integer | No description |

---

### IdentityImportRequest

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| current_passphrase | string | No description |
| data | array[integer] | No description |
| new_passphrase | string | No description |
| set_default | boolean | Optional. Default values are OK. |

---

### IdentityRefDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| id | string | identity in Ethereum address format |

---

### IdentityRegisterRequestDTO

IdentityRegisterRequest represents the identity registration user input parameters

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| beneficiary | string | Beneficiary: beneficiary to set during registration. Optional. |
| fee | string | Fee: an agreed amount to pay for registration |
| referral_token | string | Token: referral token, if the user has one |

---

### IdentityRegistrationResponseDTO

IdentityRegistrationResponse represents registration status and needed data for registering of given identity

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| registered | boolean | Returns true if identity is registered in payments smart contract |
| status | string | No description |

---

### IdentityUnlockRequestDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| passphrase | string | No description |

---

### LatestReleaseResponse

LatestReleaseResponse latest release info

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| version | string | No description |

---

### ListIdentitiesResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| identities | array[unknown] | No description |

---

### ListProposalFilterPresetsResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| items | array[unknown] | No description |

---

### ListProposalsCountiesResponse

---

### ListProposalsResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| proposals | array[unknown] | No description |

---

### LocalVersion

LocalVersion it's a local version with extra indicator if it is in use

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| name | string | No description |

---

### LocalVersionsResponse

LocalVersionsResponse local version response

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| versions | array[unknown] | No description |

---

### LocationDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| asn | integer | Autonomous system number |
| city | string | Node City |
| continent | string | Continent |
| country | string | Node Country |
| ip | string | IP address |
| ip_type | string | IP type (data_center, residential, etc.) |
| isp | string | Internet Service Provider name |
| region | string | Node Region |

---

### MMNApiKeyRequest

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| api_key | string | No description |

---

### MMNGrantVerificationResponse

MMNGrantVerificationResponse message received via redirect from mystnodes.com

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| api_key | string | No description |
| is_eligible_for_free_registration | boolean | No description |
| wallet_address | string | No description |

---

### MMNLinkRedirectResponse

MMNLinkRedirectResponse claim link response

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| link | string | No description |

---

### MigrationStatusResponse

MigrationStatusResponse represents status of the migration

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| status | string | No description |

---

### MonitoringAgentResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| error | string | No description |
| statuses | unknown | No description |

---

### MonitoringAgentStatuses

---

### MystnodesSSOLinkResponse

MystnodesSSOLinkResponse contains a link to initiate auth via mystnodes

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| link | string | No description |

---

### NATType

NATType represents nat type

---

### NATTypeDTO

NATTypeDTO gives information about NAT type in terms of traversal capabilities

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| error | string | No description |
| type | unknown | No description |

---

### NodeStatusResponse

NodeStatusResponse a node status reflects monitoring agent POV on node availability

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| status | unknown | No description |

---

### PageableDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| page | integer | The current page of the items. |
| page_size | integer | Number of items per page. |
| total_items | integer | The total items. |
| total_pages | integer | The last page of the items. |

---

### PaymentChannelDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| beneficiary | string | Beneficiary - eth wallet address |
| earnings | string | Current unsettled earnings |
| earnings_total | string | Earnings of all history |
| hermes_id | string | No description |
| id | string | Unique identifier of payment channel |
| owner_id | string | No description |

---

### PaymentOrderOptions

PaymentOrderOptions represents pilvytis payment order options

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| minimum | number | No description |
| suggested | array[number] | No description |

---

### PaymentOrderRequest

PaymentOrderRequest holds order request details

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| amount_usd | string | No description |
| country | string | No description |
| gateway_caller_data | object | No description |
| myst_amount | string | No description |
| pay_currency | string | No description |
| project_id | string | No description |
| state | string | No description |

---

### PaymentOrderResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| chain_id | integer | No description |
| channel_address | string | No description |
| country | string | No description |
| currency | string | No description |
| gateway_name | string | No description |
| id | string | No description |
| identity | string | No description |
| items_sub_total | string | No description |
| order_total | string | No description |
| pay_amount | string | No description |
| pay_currency | string | No description |
| public_gateway_data | object | No description |
| receive_myst | string | No description |
| state | string | No description |
| status | string | No description |
| tax_rate | string | No description |
| tax_sub_total | string | No description |

---

### Price

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| currency | string | No description |
| per_gib | integer | No description |
| per_gib_tokens | unknown | No description |
| per_hour | integer | No description |
| per_hour_tokens | unknown | No description |

---

### ProposalDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| access_policies | array[unknown] | AccessPolicies |
| compatibility | integer | Compatibility level. |
| format | string | Proposal format. |
| location | unknown | No description |
| price | unknown | No description |
| provider_id | string | provider who offers service |
| quality | unknown | No description |
| service_type | string | type of service provider offers |

---

### ProviderConsumersCountResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| count | integer | No description |

---

### ProviderEarningsSeriesResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| data | array[unknown] | No description |

---

### ProviderSeriesItem

ProviderSeriesItem represents a general data series item

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| timestamp | integer | No description |
| value | string | No description |

---

### ProviderSession

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| consumer_country | string | No description |
| duration_seconds | integer | No description |
| earnings | unknown | No description |
| id | string | No description |
| service_type | string | No description |
| started_at | string | No description |
| transferred_bytes | integer | No description |

---

### ProviderSessionsCountResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| count | integer | No description |

---

### ProviderSessionsResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| sessions | array[unknown] | No description |

---

### ProviderSessionsSeriesResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| data | array[unknown] | No description |

---

### ProviderTransferredDataResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| transferred_data_bytes | integer | No description |

---

### ProviderTransferredDataSeriesResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| data | array[unknown] | No description |

---

### Quality

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| bandwidth | number | No description |
| latency | number | No description |
| quality | number | No description |
| uptime | number | No description |

---

### QualityInfoResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| quality | number | No description |

---

### ReferralTokenResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| token | string | No description |

---

### RegistrationPaymentResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| paid | boolean | No description |

---

### RemoteVersion

RemoteVersion it's a version

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| compatibility_url | string | No description |
| is_pre_release | boolean | No description |
| name | string | No description |
| release_notes | string | No description |
| released_at | string | No description |

---

### RemoteVersionsResponse

RemoteVersionsResponse local version response

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| versions | array[unknown] | No description |

---

### ReportIssueGithubResponse

ReportIssueGithubResponse response for github issue creation

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| issue_id | string | No description |

---

### ServiceAccessPolicies

ServiceAccessPolicies represents the access controls for service start

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| ids | array[string] | No description |

---

### ServiceInfoDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| connection_statistics | unknown | No description |
| id | string | No description |
| options | unknown | options with which service was started. Every service has a unique list of allowed options. |
| proposal | unknown | No description |
| provider_id | string | provider identity |
| status | string | No description |
| type | string | service type. Possible values are "openvpn", "wireguard" and "noop" |

---

### ServiceListResponse

---

### ServiceLocationDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| asn | integer | Autonomous System Number |
| city | string | No description |
| continent | string | No description |
| country | string | No description |
| ip_type | string | No description |
| isp | string | No description |

---

### ServiceStartRequestDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| access_policies | unknown | No description |
| options | unknown | service options. Every service has a unique list of allowed options. |
| provider_id | string | provider identity |
| type | string | service type. Possible values are "openvpn", "wireguard" and "noop" |

---

### ServiceStatisticsDTO

ServiceStatisticsDTO shows the successful and attempted connection count

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| attempted | integer | No description |
| successful | integer | No description |

---

### SessionDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| bytes_received | integer | No description |
| bytes_sent | integer | No description |
| consumer_country | string | No description |
| consumer_id | string | No description |
| created_at | string | No description |
| direction | string | No description |
| duration | integer | duration in seconds |
| hermes_id | string | No description |
| id | string | No description |
| ip_type | string | No description |
| provider_country | string | No description |
| provider_id | string | No description |
| service_type | string | No description |
| status | string | No description |
| tokens | string | No description |

---

### SessionListResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| items | array[unknown] | No description |
| page | integer | The current page of the items. |
| page_size | integer | Number of items per page. |
| total_items | integer | The total items. |
| total_pages | integer | The last page of the items. |

---

### SessionStatsAggregatedResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| stats | unknown | No description |

---

### SessionStatsDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| count | integer | No description |
| count_consumers | integer | No description |
| sum_bytes_received | integer | No description |
| sum_bytes_sent | integer | No description |
| sum_duration | integer | No description |
| sum_tokens | string | No description |

---

### SessionStatsDailyResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| items | object | No description |
| stats | unknown | No description |

---

### SettleRequestDTO

SettleRequest represents the request to settle hermes promises

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| hermes_id | string | Deprecated |
| hermes_ids | array[string] | No description |
| provider_id | string | No description |

---

### SettleState

SettleState represents the state of settle with beneficiary transaction

---

### SettlementDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| amount | string | No description |
| beneficiary | string | No description |
| block_explorer_url | string | No description |
| channel_address | string | No description |
| error | string | No description |
| fees | string | No description |
| hermes_id | string | No description |
| is_withdrawal | boolean | No description |
| provider_id | string | No description |
| settled_at | string | No description |
| tx_hash | string | No description |

---

### SettlementListResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| items | array[unknown] | No description |
| page | integer | The current page of the items. |
| page_size | integer | Number of items per page. |
| total_items | integer | The total items. |
| total_pages | integer | The last page of the items. |
| withdrawal_total | string | No description |

---

### Status

Status enum

---

### SwitchNodeUIRequest

SwitchNodeUIRequest request for switching NodeUI version

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| version | string | No description |

---

### TermsRequest

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| agreed_consumer | boolean | No description |
| agreed_provider | boolean | No description |
| agreed_version | string | No description |

---

### TermsResponse

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| agreed_consumer | boolean | No description |
| agreed_provider | boolean | No description |
| agreed_version | string | No description |
| current_version | string | No description |

---

### TokenRewardAmount

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| amount | string | No description |

---

### Tokens

Tokens a common response for ethereum blockchain monetary amount

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| ether | string | No description |
| human | string | No description |
| wei | string | No description |

---

### TransactorFees

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| decrease_stake | unknown | No description |
| registration | unknown | No description |
| settlement | unknown | No description |
| valid_until | string | No description |

---

### UI

UI ui information

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| bundled_version | string | No description |
| used_version | string | No description |

---

### UserReport

UserReport represents user input when submitting an issue report

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| description | string | No description |
| email | string | No description |
| user_id | string | No description |
| user_type | string | No description |

---

### WithdrawRequestDTO

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| amount | string | No description |
| beneficiary | string | No description |
| from_chain_id | integer | No description |
| hermes_id | string | No description |
| provider_id | string | No description |
| to_chain_id | integer | No description |

---

### accessPolicy

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| allow | array[unknown] | No description |
| description | string | No description |
| id | string | No description |
| title | string | No description |

---

### accessRule

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| type | string | No description |
| value | string | No description |

---

### cipherparamsJSON

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| iv | string | No description |

---

### configPayload

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| data | object | No description |

---

### cryptoJSON

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| cipher | string | No description |
| cipherparams | unknown | No description |
| ciphertext | string | No description |
| kdf | string | No description |
| kdfparams | object | No description |
| mac | string | No description |

---

### dlStatus

---

### sessionConnectivityStatus

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| code | integer | No description |
| created_at_utc | string | No description |
| message | string | No description |
| peer_address | string | No description |
| session_id | string | No description |

---

