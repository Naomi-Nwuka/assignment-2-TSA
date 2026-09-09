#!/bin/bash


# Find the directory where this health-check script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Create the full path to diagnostic.sh
DIAGNOSTIC="$SCRIPT_DIR/diagnostic.sh"


# Check that diagnostic.sh exists
if [[ ! -f "$DIAGNOSTIC" ]]; then
    echo "Health check failed: diagnostic.sh not found."
    exit 1
fi


# Check that diagnostic.sh is executable
if [[ ! -x "$DIAGNOSTIC" ]]; then
    echo "Health check failed: diagnostic.sh is not executable."
    exit 1
fi


# Run the system diagnostic to make sure the application is working
# Hide the normal output and error messages because this is only a health check
if "$DIAGNOSTIC" system >/dev/null 2>&1; then
    echo "Diagnostic Tool Health Check"
    echo "Status: OK"
    exit 0
else
    echo "Diagnostic Tool Health Check"
    echo "Status: FAILED"
    exit 1
fi
