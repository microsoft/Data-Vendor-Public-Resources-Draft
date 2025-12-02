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
.\create_agent_structure.ps1 -RootDirectory <path> -SchemaName <name> -TemplateType <type>
```

**Short form:**
```powershell
.\create_agent_structure.ps1 -d <path> -s <name> -t <type>
```

### Parameters

| Parameter | Alias | Required | Description |
|-----------|-------|----------|-------------|
| `-RootDirectory` | `-d` | Yes | Root directory where the structure will be created |
| `-SchemaName` | `-s` | Yes | Agent schema name (e.g., `cr3bf_agentName`) |
| `-TemplateType` | `-t` | Yes | Template type: `f`/`full` for full template (49 columns), `a`/`abridged` for abridged template (15 columns) |
| `-UpdateTemplateOnly` | `-u` | No | Copy only the updated template to existing directory without overwriting data |

## Examples

### Windows (PowerShell)

```powershell
# Basic usage with full template
.\create_agent_structure.ps1 -RootDirectory "C:\Projects" -SchemaName "cr3bf_salesAssistant" -TemplateType "f"

# Using short form with abridged template
.\create_agent_structure.ps1 -d "C:\Projects" -s "cr3bf_customerSupport" -t "a"

# With full template (expanded option)
.\create_agent_structure.ps1 -d "C:\Projects" -s "cr3bf_dataAnalysis" -t "full"

# With abridged template (expanded option)
.\create_agent_structure.ps1 -d "C:\Projects" -s "cr3bf_salesAssistant" -t "abridged"

# From a SharePoint synced directory
.\create_agent_structure.ps1 -d "C:\Users\username\OneDrive\MCS-Agents" -s "cr3bf_salesAssistant" -t "f"

# Update template only (preserves existing data)
.\create_agent_structure.ps1 -d "C:\Projects" -s "cr3bf_salesAssistant" -t "f" -UpdateTemplateOnly
```

### WSL/Linux

```bash
# Navigate to script directory
cd /home/user/projects/AI.MCS-Data-Tools/tools/xlsx_queries_template/create_agent_directory

# Run with pwsh command - full template
pwsh ./create_agent_structure.ps1 -d "~/agents" -s "cr3bf_salesAssistant" -t "f"

# Run with abridged template
pwsh ./create_agent_structure.ps1 -d "~/agents" -s "cr3bf_salesAssistant" -t "a"

# From WSL with Windows path
pwsh ./create_agent_structure.ps1 -d "/mnt/c/Projects" -s "cr3bf_customerSupport" -t "full"

# Update template only (preserves existing data)
pwsh ./create_agent_structure.ps1 -d "~/agents" -s "cr3bf_salesAssistant" -t "f" -u
```

### macOS

```bash
# Navigate to script directory
cd ~/projects/AI.MCS-Data-Tools/tools/xlsx_queries_template/create_agent_directory

# Run with pwsh command - full template
pwsh ./create_agent_structure.ps1 -d "~/agents" -s "cr3bf_salesAssistant" -t "f"

# Run with abridged template
pwsh ./create_agent_structure.ps1 -d "~/agents" -s "cr3bf_salesAssistant" -t "abridged"

# Update template only (preserves existing data)
pwsh ./create_agent_structure.ps1 -d "~/agents" -s "cr3bf_salesAssistant" -t "f" -UpdateTemplateOnly
```

## Re-Running on Existing Directory

If you run the script on a directory that already exists, you'll be prompted with three options:

**`[o] Overwrite`** - Move existing directory to backup and create fresh structure
- Existing directory is renamed to `<directory>_DELETED_<timestamp>` (e.g., `cr3bf_salesAssistant_resources_DELETED_20251119_1430`)
- All files are preserved in the backup
- Completely new structure is created from scratch
- Requires typing "yes" to confirm

**`[u] Update`** - Copy updated template only (preserves existing data)
- Creates new template file with timestamp: `Excel_Queries_<schema>_updated_<timestamp>.xlsm`
- Original data file remains untouched
- You can manually copy data from old to new file
- Recommended when template structure has changed

**`[c] Cancel`** - Exit without making any changes

### Update Template Workflow

When using the update option (either `-UpdateTemplateOnly` flag or choosing `[u]` when prompted):

1. Script creates: `Excel_Queries_<schema>_updated_20251119_143022.xlsm`
2. Open the new template file: `Excel_Queries_<schema>_updated_20251119_143022.xlsm`
3. **Use built-in import feature** to transfer data:
   - Double-click cell **A2** ("Import data from other Excel *.xlsm template")
   - Select your old file: `Excel_Queries_<schema>.xlsm`
   - Confirm the import when prompted
   - The template will validate column headers and copy all data automatically
4. Verify data transferred correctly (especially check if the number and naming of columns changed!)
5. Rename old file to `Excel_Queries_<schema>_backup.xlsm`
6. Rename new file to `Excel_Queries_<schema>.xlsm`
7. Continue working with the updated template

**Alternative Manual Method** (if import feature is not available):
1. Open both files side-by-side:
   - OLD: `Excel_Queries_<schema>.xlsm` (your existing data)
   - NEW: `Excel_Queries_<schema>_updated_20251119_143022.xlsm` (updated template)
2. Manually copy all data from old to new file
3. Follow steps 4-7 above

## Created Structure

The script creates the following directory structure:

```
<schema_name>_resources/
├── README.md                                      # Directory usage guidelines
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
├── README.md
├── TestQueries/
│   └── Excel_Queries_cr3bf_salesAssistant.xlsx
├── Data/
│   ├── InAgent/
│   └── Other/
├── DesignDocumentation/
└── ExportedSolutions/
```

## Resource Files

The script copies files from the `resources/` subdirectory based on the template type selected:

| Source File | Destination | Purpose | Template Type |
|-------------|-------------|---------|---------------|
| `resources/README.md` | Root directory | Directory usage guidelines | Both |
| `resources/enhanced_template.xlsx` | `TestQueries/Excel_Queries_<schema>.xlsx` | Full test queries template (all columns) | Full (`-t f`) |
| `resources/abridged_enhanced_template.xlsx` | `TestQueries/Excel_Queries_<schema>.xlsx` | Abridged test queries template (reduced number of columns - used for ThinkingBox) | Abridged (`-t a`) |

### Template Type Comparison

| Feature | Full Template (`f`/`full`) | Abridged Template (`a`/`abridged`) |
|---------|---------------------------|-----------------------------------|
| **Columns** | All columns | Reduced number of columns |
| **Use Case** | MCS testing and analysis | ThinkingBox evaluation |
| **Includes** | All fields: agent config, knowledge corpus details, query analysis, content structure, response evaluation, custom rubrics | Core fields: identification, custom rubrics, pass/fail scores, justifications |

## 📥📤 Template Import/Export Features

Both template types include built-in import/export functionality:

### Import Data (Cell A2)

**Double-click cell A2** to import data from another `.xlsm` template:
- Opens file picker to select source template
- Validates column headers match between source and destination
- Shows confirmation dialog with import summary
- Automatically transfers all data while preserving formatting
- Use this when updating to a new template version

### Export Data (Cell A3)

**Double-click cell A3** to create timestamped backups:
- Creates two files: `.xlsx` (Excel) and `.tsv` (tab-separated)
- Timestamp format: `YYYYMMDD_HHMM`
- Excel export preserves column widths and wrap text settings
- TSV export uses UTF-8 encoding with proper quoting for special characters
- Use this to create backups or export data for analysis

**Example Files Created:**
```
Excel_Queries_cr3bf_salesAssistant_20251202_1430.xlsx
Excel_Queries_cr3bf_salesAssistant_20251202_1430.tsv
```

For more details on import/export functionality, see the main [README.md](../README.md#-importexport-features).

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
- Check that both template files exist:
  - `resources/README.md`
  - `resources/enhanced_template.xlsx`
  - `resources/abridged_enhanced_template.xlsx`

### Issue: Invalid Template Type

**Error:**
```
Cannot validate argument on parameter 'TemplateType'
```

**Solution:**
- Use one of the valid template type values:
  - `f` or `full` for the full template
  - `a` or `abridged` for the abridged template
- Example: `-t f` or `-TemplateType "abridged"`

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
        ├── create_agent_directory/
        │   ├── create_agent_structure.ps1       ← This script
        │   ├── README_create_agent_structure.md ← This documentation
        │   └── resources/
        │       ├── README.md                    ← Copied to target
        │       ├── enhanced_template.xlsm       ← Full template (all columns)
        │       └── abridged_enhanced_template.xlsm ← Abridged template (reduced number of columns)
        └── create_enhanced_template.py          ← Generates both templates
```

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | October 2025 | Initial release with cross-platform support |
| 1.1 | November 2025 | Added `-UpdateTemplateOnly` parameter, improved overwrite handling with backup rename |

## Support

For questions or issues:
- Check the main repository README for the Excel template and agent resources directory generation tool documentation
