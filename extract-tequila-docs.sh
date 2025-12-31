#!/bin/bash

#####################################################################
# TequilAPI Documentation Extractor
#
# Extracts API documentation from Mysterium Node instances
# without disturbing running services (read-only operations)
#
# Supports:
# - Bare metal installation (default: port 4050)
# - Docker installation (default: port 4450)
#####################################################################

# ANSI colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default configuration
BARE_METAL_PORT=4050
DOCKER_PORT=4450
DEFAULT_USER="myst"
DEFAULT_PASS="mystberry"
OUTPUT_DIR="."
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Output files
BARE_METAL_JSON="tequila_api_baremetal_${TIMESTAMP}.json"
DOCKER_JSON="tequila_api_docker_${TIMESTAMP}.json"
PARSED_MARKDOWN="TEQUILA_API_REFERENCE.md"
COMPARISON_FILE="api_comparison_${TIMESTAMP}.txt"

#####################################################################
# Helper Functions
#####################################################################

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

#####################################################################
# API Health Check Function
#####################################################################

check_node_health() {
    local port=$1
    local node_type=$2

    print_info "Checking ${node_type} node on port ${port}..."

    # Try with authentication
    response=$(curl -s -w "\n%{http_code}" -u "${DEFAULT_USER}:${DEFAULT_PASS}" \
        "http://127.0.0.1:${port}/healthcheck" 2>&1)

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" = "200" ]; then
        print_success "${node_type} node is healthy"
        echo "$body" | python3 -m json.tool 2>/dev/null || echo "$body"
        return 0
    else
        print_error "${node_type} node is not responding (HTTP $http_code)"
        return 1
    fi
}

#####################################################################
# Swagger Documentation Extraction
#####################################################################

extract_swagger_json() {
    local port=$1
    local output_file=$2
    local node_type=$3

    print_info "Extracting Swagger JSON from ${node_type} (port ${port})..."

    # Extract swagger.json
    response=$(curl -s -w "\n%{http_code}" -u "${DEFAULT_USER}:${DEFAULT_PASS}" \
        "http://127.0.0.1:${port}/docs/swagger.json" 2>&1)

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" = "200" ]; then
        # Validate JSON and pretty-print
        if echo "$body" | python3 -m json.tool > "${output_file}" 2>/dev/null; then
            print_success "Swagger JSON saved to ${output_file}"

            # Extract some stats
            local endpoint_count=$(grep -c '"/' "${output_file}" | head -1)
            local version=$(grep -A 2 '"info"' "${output_file}" | grep '"version"' | cut -d'"' -f4)

            print_info "API Version: ${version:-unknown}"
            print_info "Endpoints found: ${endpoint_count:-unknown}"
            return 0
        else
            print_error "Failed to parse JSON response"
            echo "$body" > "${output_file}.raw"
            print_warning "Raw response saved to ${output_file}.raw"
            return 1
        fi
    else
        print_error "Failed to retrieve Swagger JSON (HTTP $http_code)"
        print_warning "Response: $body"
        return 1
    fi
}

#####################################################################
# Parse Swagger JSON to Markdown
#####################################################################

parse_swagger_to_markdown() {
    local json_file=$1
    local output_md=$2

    print_info "Parsing Swagger JSON to Markdown..."

    if [ ! -f "$json_file" ]; then
        print_error "JSON file not found: $json_file"
        return 1
    fi

    # Use Python to parse the Swagger JSON and generate Markdown
    python3 - <<EOF
import json
import sys
from datetime import datetime

try:
    with open('${json_file}', 'r') as f:
        swagger = json.load(f)

    with open('${output_md}', 'w') as out:
        # Header
        out.write("# TequilAPI Reference\n\n")
        out.write(f"**Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")

        # API Info
        info = swagger.get('info', {})
        out.write(f"**Version:** {info.get('version', 'unknown')}\n\n")
        out.write(f"**Description:** {info.get('description', 'No description')}\n\n")
        out.write(f"**Host:** {swagger.get('host', 'unknown')}\n\n")

        out.write("---\n\n")

        # Table of Contents
        out.write("## Table of Contents\n\n")
        paths = swagger.get('paths', {})

        # Group endpoints by category
        categories = {}
        for path, methods in paths.items():
            for method, details in methods.items():
                if method in ['get', 'post', 'put', 'delete', 'patch']:
                    tags = details.get('tags', ['Uncategorized'])
                    category = tags[0] if tags else 'Uncategorized'
                    if category not in categories:
                        categories[category] = []
                    categories[category].append({
                        'path': path,
                        'method': method.upper(),
                        'summary': details.get('summary', 'No summary'),
                        'details': details
                    })

        # Write TOC
        for category in sorted(categories.keys()):
            out.write(f"- [{category}](#{category.lower().replace(' ', '-')})\n")

        out.write("\n---\n\n")

        # Write endpoint details by category
        for category in sorted(categories.keys()):
            out.write(f"## {category}\n\n")

            for endpoint in categories[category]:
                out.write(f"### {endpoint['method']} {endpoint['path']}\n\n")
                out.write(f"**Summary:** {endpoint['summary']}\n\n")

                details = endpoint['details']

                # Description
                if 'description' in details:
                    out.write(f"**Description:** {details['description']}\n\n")

                # Operation ID
                if 'operationId' in details:
                    out.write(f"**Operation ID:** {details['operationId']}\n\n")

                # Parameters
                params = details.get('parameters', [])
                if params:
                    out.write("**Parameters:**\n\n")
                    out.write("| Name | Type | In | Required | Description |\n")
                    out.write("|------|------|-----|----------|-------------|\n")
                    for param in params:
                        name = param.get('name', 'unknown')
                        param_type = param.get('type', param.get('schema', {}).get('$ref', 'object'))
                        in_location = param.get('in', 'unknown')
                        required = 'Yes' if param.get('required', False) else 'No'
                        description = param.get('description', 'No description')
                        out.write(f"| {name} | {param_type} | {in_location} | {required} | {description} |\n")
                    out.write("\n")

                # Responses
                responses = details.get('responses', {})
                if responses:
                    out.write("**Responses:**\n\n")
                    for status_code, response_detail in responses.items():
                        description = response_detail.get('description', 'No description')
                        out.write(f"- **{status_code}:** {description}\n")
                        if 'schema' in response_detail:
                            schema = response_detail['schema']
                            if '$ref' in schema:
                                model = schema['$ref'].split('/')[-1]
                                out.write(f"  - Schema: {model}\n")
                    out.write("\n")

                out.write("---\n\n")

        # Definitions
        definitions = swagger.get('definitions', {})
        if definitions:
            out.write("## Data Models\n\n")
            for model_name, model_def in sorted(definitions.items()):
                out.write(f"### {model_name}\n\n")

                if 'description' in model_def:
                    out.write(f"{model_def['description']}\n\n")

                properties = model_def.get('properties', {})
                if properties:
                    out.write("**Properties:**\n\n")
                    out.write("| Property | Type | Description |\n")
                    out.write("|----------|------|-------------|\n")
                    for prop_name, prop_def in properties.items():
                        prop_type = prop_def.get('type', prop_def.get('$ref', 'unknown'))
                        if '$ref' in prop_def:
                            prop_type = prop_def['$ref'].split('/')[-1]
                        elif 'type' in prop_def and prop_def['type'] == 'array':
                            items = prop_def.get('items', {})
                            if '$ref' in items:
                                item_type = items['$ref'].split('/')[-1]
                                prop_type = f"array[{item_type}]"
                            else:
                                prop_type = f"array[{items.get('type', 'unknown')}]"
                        prop_desc = prop_def.get('description', 'No description')
                        out.write(f"| {prop_name} | {prop_type} | {prop_desc} |\n")
                    out.write("\n")

                out.write("---\n\n")

    print("SUCCESS")
    sys.exit(0)

except Exception as e:
    print(f"ERROR: {str(e)}", file=sys.stderr)
    sys.exit(1)
EOF

    if [ $? -eq 0 ]; then
        print_success "Markdown documentation generated: ${output_md}"
        return 0
    else
        print_error "Failed to generate Markdown documentation"
        return 1
    fi
}

#####################################################################
# Compare Two API Versions
#####################################################################

compare_api_versions() {
    local file1=$1
    local file2=$2
    local output_file=$3

    print_info "Comparing API versions..."

    if [ ! -f "$file1" ] || [ ! -f "$file2" ]; then
        print_warning "Cannot compare - one or both files missing"
        return 1
    fi

    {
        echo "TequilAPI Version Comparison"
        echo "Generated: $(date)"
        echo "========================================"
        echo ""
        echo "File 1: $file1"
        echo "File 2: $file2"
        echo ""

        echo "Endpoint Count:"
        echo "  File 1: $(grep -c '"/' "$file1")"
        echo "  File 2: $(grep -c '"/' "$file2")"
        echo ""

        echo "API Versions:"
        echo "  File 1: $(grep '"version"' "$file1" | head -1 | cut -d'"' -f4)"
        echo "  File 2: $(grep '"version"' "$file2" | head -1 | cut -d'"' -f4)"
        echo ""

        echo "Differences (if any):"
        diff -u "$file1" "$file2" | head -100

    } > "$output_file"

    print_success "Comparison saved to ${output_file}"
}

#####################################################################
# Main Execution
#####################################################################

main() {
    print_header "TequilAPI Documentation Extractor"
    echo ""

    # Check for required tools
    print_info "Checking dependencies..."

    if ! command -v curl &> /dev/null; then
        print_error "curl is required but not installed"
        exit 1
    fi

    if ! command -v python3 &> /dev/null; then
        print_error "python3 is required but not installed"
        exit 1
    fi

    print_success "All dependencies found"
    echo ""

    # Check bare metal node
    print_header "Bare Metal Node (Port ${BARE_METAL_PORT})"
    echo ""

    if check_node_health "$BARE_METAL_PORT" "Bare Metal"; then
        echo ""
        extract_swagger_json "$BARE_METAL_PORT" "$BARE_METAL_JSON" "Bare Metal"
        BARE_METAL_SUCCESS=true
    else
        print_warning "Skipping bare metal node extraction"
        BARE_METAL_SUCCESS=false
    fi

    echo ""

    # Check Docker node
    print_header "Docker Node (Port ${DOCKER_PORT})"
    echo ""

    if check_node_health "$DOCKER_PORT" "Docker"; then
        echo ""
        extract_swagger_json "$DOCKER_PORT" "$DOCKER_JSON" "Docker"
        DOCKER_SUCCESS=true
    else
        print_warning "Skipping Docker node extraction"
        print_info "Note: Docker container may need TequilAPI configuration check"
        DOCKER_SUCCESS=false
    fi

    echo ""

    # Generate Markdown documentation from the primary source
    if [ "$BARE_METAL_SUCCESS" = true ]; then
        print_header "Generating Markdown Documentation"
        echo ""
        parse_swagger_to_markdown "$BARE_METAL_JSON" "$PARSED_MARKDOWN"
    elif [ "$DOCKER_SUCCESS" = true ]; then
        print_header "Generating Markdown Documentation"
        echo ""
        parse_swagger_to_markdown "$DOCKER_JSON" "$PARSED_MARKDOWN"
    else
        print_error "No API documentation could be extracted"
        exit 1
    fi

    echo ""

    # Compare versions if both are available
    if [ "$BARE_METAL_SUCCESS" = true ] && [ "$DOCKER_SUCCESS" = true ]; then
        print_header "Comparing API Versions"
        echo ""
        compare_api_versions "$BARE_METAL_JSON" "$DOCKER_JSON" "$COMPARISON_FILE"
    fi

    echo ""
    print_header "Summary"
    echo ""

    if [ "$BARE_METAL_SUCCESS" = true ]; then
        print_success "Bare Metal API: ${BARE_METAL_JSON}"
    fi

    if [ "$DOCKER_SUCCESS" = true ]; then
        print_success "Docker API: ${DOCKER_JSON}"
    fi

    if [ -f "$PARSED_MARKDOWN" ]; then
        print_success "Markdown Reference: ${PARSED_MARKDOWN}"
    fi

    if [ -f "$COMPARISON_FILE" ]; then
        print_success "Version Comparison: ${COMPARISON_FILE}"
    fi

    echo ""
    print_success "Documentation extraction complete!"
}

# Run main function
main
