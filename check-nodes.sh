#!/bin/bash

#####################################################################
# Mysterium Node Status Checker
#
# Checks status of both bare metal and Docker Mysterium nodes
# Usage: ./check-nodes.sh [command]
#
# Commands:
#   status       - Show health status (default)
#   identities   - List identities
#   services     - Show running services
#   location     - Show node locations
#   nat          - Check NAT type
#   full         - Full detailed status
#####################################################################

# ANSI colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Node configurations
BARE_METAL_NAME="Bare Metal"
BARE_METAL_URL="http://127.0.0.1:4050"
BARE_METAL_AUTH="myst:mystberry"

DOCKER_NAME="Docker (orion-alpha)"
DOCKER_URL="http://127.0.0.1:4450"
DOCKER_AUTH="myst:mystberry"

#####################################################################
# Helper Functions
#####################################################################

print_header() {
    echo -e "${BLUE}${BOLD}========================================${NC}"
    echo -e "${BLUE}${BOLD}$1${NC}"
    echo -e "${BLUE}${BOLD}========================================${NC}"
}

print_node_header() {
    echo -e "\n${CYAN}${BOLD}>>> $1${NC}"
    echo -e "${CYAN}────────────────────────────────────────${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

#####################################################################
# API Call Function
#####################################################################

call_api() {
    local url=$1
    local auth=$2
    local endpoint=$3

    curl -s -u "$auth" "${url}${endpoint}" 2>&1
}

#####################################################################
# Status Check Functions
#####################################################################

check_health() {
    local name=$1
    local url=$2
    local auth=$3

    print_node_header "$name"

    response=$(call_api "$url" "$auth" "/healthcheck")

    if echo "$response" | grep -q '"uptime"'; then
        print_success "Node is healthy"

        version=$(echo "$response" | grep -o '"version":"[^"]*"' | cut -d'"' -f4)
        uptime=$(echo "$response" | grep -o '"uptime":"[^"]*"' | cut -d'"' -f4)
        process=$(echo "$response" | grep -o '"process":[0-9]*' | cut -d':' -f2)

        echo -e "  ${BOLD}Version:${NC} $version"
        echo -e "  ${BOLD}Uptime:${NC} $uptime"
        echo -e "  ${BOLD}Process:${NC} $process"
    else
        print_error "Node not responding"
        echo "  Response: $response"
    fi
}

check_identities() {
    local name=$1
    local url=$2
    local auth=$3

    print_node_header "$name - Identities"

    response=$(call_api "$url" "$auth" "/identities")

    if echo "$response" | grep -q '"identities"'; then
        count=$(echo "$response" | grep -o '"id":"[^"]*"' | wc -l)
        print_success "Found $count identity/identities"

        echo "$response" | python3 -m json.tool 2>/dev/null | grep -E '"id"|"channel_address"|"registration_status"' | head -20
    else
        print_error "Could not retrieve identities"
    fi
}

check_services() {
    local name=$1
    local url=$2
    local auth=$3

    print_node_header "$name - Services"

    response=$(call_api "$url" "$auth" "/services")

    if echo "$response" | python3 -m json.tool >/dev/null 2>&1; then
        # Count services
        service_count=$(echo "$response" | grep -c '"id":"' 2>/dev/null || echo "0")

        if [ "$service_count" -gt 0 ]; then
            print_success "$service_count service(s) running"
            echo "$response" | python3 -m json.tool 2>/dev/null | grep -E '"id"|"provider_id"|"type"|"status"' | head -30
        else
            print_info "No services currently running"
        fi
    else
        print_error "Could not retrieve services"
    fi
}

check_location() {
    local name=$1
    local url=$2
    local auth=$3

    print_node_header "$name - Location"

    response=$(call_api "$url" "$auth" "/location")

    if echo "$response" | grep -q '"ip"'; then
        ip=$(echo "$response" | grep -o '"ip":"[^"]*"' | cut -d'"' -f4)
        country=$(echo "$response" | grep -o '"country":"[^"]*"' | cut -d'"' -f4)

        print_success "Location detected"
        echo -e "  ${BOLD}IP:${NC} $ip"
        echo -e "  ${BOLD}Country:${NC} $country"
    else
        print_error "Could not retrieve location"
    fi
}

check_nat() {
    local name=$1
    local url=$2
    local auth=$3

    print_node_header "$name - NAT Type"

    response=$(call_api "$url" "$auth" "/nat/type")

    if echo "$response" | grep -q '"type"'; then
        nat_type=$(echo "$response" | grep -o '"type":"[^"]*"' | cut -d'"' -f4)
        print_success "NAT Type: $nat_type"
    else
        print_info "NAT type not available"
    fi
}

#####################################################################
# Command Handlers
#####################################################################

cmd_status() {
    print_header "Mysterium Node Status Check"
    check_health "$BARE_METAL_NAME" "$BARE_METAL_URL" "$BARE_METAL_AUTH"
    check_health "$DOCKER_NAME" "$DOCKER_URL" "$DOCKER_AUTH"
}

cmd_identities() {
    print_header "Node Identities"
    check_identities "$BARE_METAL_NAME" "$BARE_METAL_URL" "$BARE_METAL_AUTH"
    check_identities "$DOCKER_NAME" "$DOCKER_URL" "$DOCKER_AUTH"
}

cmd_services() {
    print_header "Running Services"
    check_services "$BARE_METAL_NAME" "$BARE_METAL_URL" "$BARE_METAL_AUTH"
    check_services "$DOCKER_NAME" "$DOCKER_URL" "$DOCKER_AUTH"
}

cmd_location() {
    print_header "Node Locations"
    check_location "$BARE_METAL_NAME" "$BARE_METAL_URL" "$BARE_METAL_AUTH"
    check_location "$DOCKER_NAME" "$DOCKER_URL" "$DOCKER_AUTH"
}

cmd_nat() {
    print_header "NAT Type Check"
    check_nat "$BARE_METAL_NAME" "$BARE_METAL_URL" "$BARE_METAL_AUTH"
    check_nat "$DOCKER_NAME" "$DOCKER_URL" "$DOCKER_AUTH"
}

cmd_full() {
    print_header "Full Node Status Report"

    check_health "$BARE_METAL_NAME" "$BARE_METAL_URL" "$BARE_METAL_AUTH"
    check_identities "$BARE_METAL_NAME" "$BARE_METAL_URL" "$BARE_METAL_AUTH"
    check_services "$BARE_METAL_NAME" "$BARE_METAL_URL" "$BARE_METAL_AUTH"
    check_location "$BARE_METAL_NAME" "$BARE_METAL_URL" "$BARE_METAL_AUTH"
    check_nat "$BARE_METAL_NAME" "$BARE_METAL_URL" "$BARE_METAL_AUTH"

    echo ""

    check_health "$DOCKER_NAME" "$DOCKER_URL" "$DOCKER_AUTH"
    check_identities "$DOCKER_NAME" "$DOCKER_URL" "$DOCKER_AUTH"
    check_services "$DOCKER_NAME" "$DOCKER_URL" "$DOCKER_AUTH"
    check_location "$DOCKER_NAME" "$DOCKER_URL" "$DOCKER_AUTH"
    check_nat "$DOCKER_NAME" "$DOCKER_URL" "$DOCKER_AUTH"
}

show_help() {
    echo "Mysterium Node Status Checker"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  status       - Show health status (default)"
    echo "  identities   - List identities"
    echo "  services     - Show running services"
    echo "  location     - Show node locations"
    echo "  nat          - Check NAT type"
    echo "  full         - Full detailed status"
    echo "  help         - Show this help message"
    echo ""
    echo "Node Configuration:"
    echo "  Bare Metal:  $BARE_METAL_URL"
    echo "  Docker:      $DOCKER_URL"
}

#####################################################################
# Main Execution
#####################################################################

main() {
    local command=${1:-status}

    case "$command" in
        status)
            cmd_status
            ;;
        identities)
            cmd_identities
            ;;
        services)
            cmd_services
            ;;
        location)
            cmd_location
            ;;
        nat)
            cmd_nat
            ;;
        full)
            cmd_full
            ;;
        help|-h|--help)
            show_help
            ;;
        *)
            echo "Unknown command: $command"
            echo "Run '$0 help' for usage information"
            exit 1
            ;;
    esac

    echo ""
}

# Check dependencies
if ! command -v curl &> /dev/null; then
    echo "Error: curl is required but not installed"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "Warning: python3 not found, JSON formatting will be limited"
fi

# Run main function
main "$@"
