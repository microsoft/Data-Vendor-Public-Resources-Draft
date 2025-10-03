#!/bin/bash
#
# MCS Agent Structure Creator - Bash Wrapper
#
# This script is a bash wrapper that calls the PowerShell script.
# Use this if you're on WSL/Linux and have PowerShell installed.
#
# Usage:
#   ./create_agent_structure.sh -d <root_directory> -s <schema_name>
#
# If PowerShell is not installed, it will provide installation instructions.
#

# Check if PowerShell is installed
if ! command -v pwsh &> /dev/null; then
    echo ""
    echo "========================================="
    echo "PowerShell Not Found"
    echo "========================================="
    echo ""
    echo "This script requires PowerShell Core."
    echo ""
    echo "Installation instructions:"
    echo ""
    echo "Ubuntu/Debian:"
    echo "  sudo apt-get update"
    echo "  sudo apt-get install -y powershell"
    echo ""
    echo "Or use Snap:"
    echo "  sudo snap install powershell --classic"
    echo ""
    echo "After installation, run this script again."
    echo ""
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Call the PowerShell script with all arguments
pwsh "$SCRIPT_DIR/create_agent_structure.ps1" "$@"
