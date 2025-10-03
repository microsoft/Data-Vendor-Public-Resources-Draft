# MCS Agent Structure Creator

## Overview

The `create_agent_structure.ps1` script creates a standardized directory structure for Microsoft Copilot Studio (MCS) agent development. It automatically sets up all necessary folders and copies template files to help you get started quickly.

## Requirements

### Windows
- **PowerShell 5.1 or later** (included with Windows 10/11)
- No additional installations required

### WSL/Linux
- **PowerShell Core 7+** (install if not present)
  ```bash
  # Install PowerShell on Ubuntu/WSL
  sudo apt-get update
  sudo apt-get install -y powershell
  ```

### macOS
- **PowerShell Core 7+**
  ```bash
  # Install PowerShell on macOS
  brew install --cask powershell
  ```

## Usage

### Basic Syntax

```powershell
.\create_agent_structure.ps1 -RootDirectory <path> -SchemaName <name>
```

**Short form:**
```powershell
.\create_agent_structure.ps1 -d <path> -s <name>
```

### Parameters

| Parameter | Alias | Required | Description |
|-----------|-------|----------|-------------|
| `-RootDirectory` | `-d` | Yes | Root directory where the structure will be created |
| `-SchemaName` | `-s` | Yes | Agent schema name (e.g., `cr3bf_agentName`) |

## Examples

### Windows (PowerShell)

```powershell
# Basic usage
.\create_agent_structure.ps1 -RootDirectory "C:\Projects" -SchemaName "cr3bf_salesAssistant"

# Using short form
.\create_agent_structure.ps1 -d "C:\Projects" -s "cr3bf_customerSupport"

# From a SharePoint synced directory
.\create_agent_structure.ps1 -d "C:\Users\username\OneDrive\MCS-Agents" -s "cr3bf_salesAssistant"
```

### WSL/Linux

```bash
# Navigate to script directory
cd /home/user/projects/AI.MCS-Data-Tools/tools/xlsx_queries_template

# Run with pwsh command
pwsh ./create_agent_structure.ps1 -d "~/agents" -s "cr3bf_salesAssitstant"

# From WSL with Windows path
pwsh ./create_agent_structure.ps1 -d "/mnt/c/Projects" -s "cr3bf_customerSupport"
```

### macOS

```bash
# Navigate to script directory
cd ~/projects/AI.MCS-Data-Tools/tools/xlsx_queries_template

# Run with pwsh command
pwsh ./create_agent_structure.ps1 -d "~/agents" -s "cr3bf_salesAssistant"

# From WSL with Windows path
pwsh ./create_agent_structure.ps1 -d "/mnt/c/Projects" -s "cr3bf_customerSupport"
```

### macOS

```bash
# Navigate to script directory
cd ~/projects/AI.MCS-Data-Tools/tools/xlsx_queries_template

# Run with pwsh command
pwsh ./create_agent_structure.ps1 -d "~/agents" -s "cr3bf_salesAssistant"
```

## Created Structure

The script creates the following directory structure:

```
<schema_name>_resources/
├── README.txt                                      # Directory usage guidelines
├── TestQueries/
│   └── Excel_Queries_<schema_name>.xlsx          # Test queries template
├── Data/
│   ├── InAgent/                                   # In-agent knowledge base files
│   └── Other/                                     # Supplementary data files
├── DesignDocumentation/                           # Design documents and specs
└── ExportedSolutions/                             # Solution exports from Copilot Studio
```

### Example Output

For schema name `cr3bf_salesAssistant`, the created structure will be:
```
cr3bf_salesAssistant_resources/
├── README.txt
├── TestQueries/
│   └── Excel_Queries_cr3bf_salesAssistant.xlsx
├── Data/
│   ├── InAgent/
│   └── Other/
├── DesignDocumentation/
└── ExportedSolutions/
```

## Resource Files

The script copies files from the `resources/` subdirectory:

| Source File | Destination | Purpose |
|-------------|-------------|---------|
| `resources/README.txt` | Root directory | Directory usage guidelines |
| `resources/enhanced_template.xlsx` | `TestQueries/Excel_Queries_<schema>.xlsx` | Test queries template |

## Features

### ✅ Cross-Platform Compatibility
- Works on Windows (PowerShell 5.1+)
- Works on WSL/Linux (PowerShell Core 7+)
- Works on macOS (PowerShell Core 7+)

### ✅ Safety Features
- Validates root directory exists before creating structure
- Warns if target directory already exists
- Validates schema name format
- Provides clear error messages

### ✅ User-Friendly
- Colored console output for better readability
- Detailed progress messages
- Clear completion summary with next steps
- Short parameter aliases (`-d`, `-s`)

### ✅ SharePoint Compatible
- Works with OneDrive/SharePoint synced directories
- Handles long paths correctly
- No special characters in generated directory names

## Troubleshooting

### Issue: Script Execution Policy Error (Windows)

**Error:**
```
Cannot be loaded because running scripts is disabled on this system
```

**Solution:**
```powershell
# Open PowerShell as Administrator and run:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or run the script with bypass:
powershell -ExecutionPolicy Bypass -File .\create_agent_structure.ps1 -d "C:\Projects" -s "cr3bf_agentName"
```

### Issue: PowerShell Not Found (WSL/Linux)

**Error:**
```
pwsh: command not found
```

**Solution:**
```bash
# Install PowerShell on Ubuntu/WSL
sudo apt-get update
sudo apt-get install -y powershell

### Issue: Root Directory Not Found

**Error:**
```
ERROR: Root directory does not exist: /path/to/directory
```

**Solution:**
- Verify the path exists
- Create the directory first: `mkdir -p /path/to/directory`
- Check for typos in the path

### Issue: Resources Directory Missing

**Error:**
```
ERROR: Resources directory not found
```

**Solution:**
- Ensure you're running the script from the correct directory
- Verify the `resources/` subdirectory exists
- Check that `resources/README.txt` and `resources/enhanced_template.xlsx` exist

## Integration with MCS Workflow

This script is part of the MCS agent development workflow:

1. **Create Structure** (this script) → Initial setup with templates
2. **Fill Excel Template** → Add test queries and ground truth data
3. **Add Knowledge Files** → Place files in `Data/InAgent/`
4. **Export Solution** → Save to `ExportedSolutions/`
5. **Archive to Repository** → Use MCS archiving process tools

## Script Location

```
AI.MCS-Data-Tools/
└── tools/
    └── xlsx_queries_template/
        ├── create_agent_structure.ps1       ← This script
        ├── README_create_agent_structure.md ← This documentation
        └── resources/
            ├── README.txt                   ← Copied to target
            └── enhanced_template.xlsx       ← Copied to TestQueries/
```

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | October 2025 | Initial release with cross-platform support |

## Support

For questions or issues:
- Check the main repository README for tool documentation
