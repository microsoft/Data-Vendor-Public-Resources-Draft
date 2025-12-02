# MCS Agent Resources Directory

This directory contains all resources needed for the creation of an agent resources directory structure.

---

## 📁 Directory Structure

### `TestQueries/`
Contains Excel templates with embedded validation macros for test query collection.

- **Excel_Queries_<schema_name>.xlsm**: Macro-enabled template to collect test queries and ground truth data with automatic validation and error checking.

### `Data/InAgent/`
Storage for in-agent knowledge base files (DV File Upload).

Place PDF, DOCX, XLSX, and other knowledge files here that you used to directly load into the agent's knowledge (so not a pointer to a SharePoint directory or similar).

### `Data/Other/`
Storage for supplementary data files and resources.

> Use this for data files that don't go into the agent directly.
You can create sub-directories with sets of data - and use these sub-directories as SharePoint pointers in your agent.

> Keep directory names short, ideally without spaces or special characters like ampersand.

### `DesignDocumentation/`
Documentation for agent design, architecture, and requirements.

Store design documents, flow diagrams, and technical specifications here.

### `ExportedSolutions/`
Storage for exported MCS solution files.

Save solution exports (.zip files) from Copilot Studio here.


---


## 🔧 Excel Template Macro Functionality

The `Excel_Queries_<schema_name>.xlsm` file contains VBA macros that provide automatic validation and quality checking as you enter data.

### 🔓 Enabling Macros

When you first open the file, Excel may show a security warning:
> **SECURITY WARNING: Macros have been disabled.**

**⚠️ It is advised to click "Enable Content" to activate the validation functionality.**

**To enable the validation functionality:**

1. Click the **"Enable Content"** button in the yellow banner at the top
2. Or go to: **File → Options → Trust Center → Trust Center Settings → Macro Settings**
   - Select "Enable all macros" (or "Disable all macros with notification")

**💡 Recommended Workflow:**
By default, validation starts in OFF mode. Enable it after entering some or all of your data to validate it. For continuous data entry, you can toggle validation OFF for bulk edits, then back ON to check your work.

---

## ✨ What the Macros Do

### Real-time Validation
As you type in cells, the macro checks your entries against the rules defined in the Documentation sheet.

### Visual Feedback
Invalid entries are highlighted in **YELLOW** with comments explaining what's wrong.

### 🎚️ Validation Toggle (Cell A1)
Control when validation runs by **double-clicking cell A1**:

- **Cell A1** shows the current validation state: `[ON] Validation` or `[OFF] Validation`
- **Double-click cell A1** to toggle validation ON or OFF
- **🟢 GREEN background** = Validation is ON (automatic checking)
- **🟠 ORANGE background** = Validation is OFF (normal Excel behavior)

#### When Validation is **ON** 🟢
- ✅ When you switch to ON, **ALL existing data is validated immediately**
- ✅ Any cell changes are validated automatically as you type
- ✅ Invalid entries are highlighted in yellow with error comments
- ⚠️ **Note:** CTRL+Z (undo) may not work as expected due to validation processing

#### When Validation is **OFF** 🟠
- ✅ All yellow highlighting and error comments are **cleared immediately**
- ✅ Excel behaves normally - no automatic validation
- ✅ CTRL+Z (undo) works normally
- ✅ **Recommended for:** bulk data entry, copy/paste operations, or initial data setup

---

## 📥📤 Import/Export Functionality

The template includes built-in import/export features accessible from column A:

### 📥 Import Data (Cell A2)
**Double-click cell A2** (light blue) to import data from another `.xlsm` template:

- **File Picker**: Opens a dialog to select source template file
- **Column Validation**: Verifies that source and target have matching column headers
- **Confirmation Dialog**: Shows import summary and asks for confirmation
  - Displays number of rows to import
  - Shows column headers that will be imported
  - Warns that existing data will be deleted
- **Data Transfer**: Automatically copies all data from source (starting at B2)
  - Preserves all formatting and values
  - Clears existing data before import
  - Maintains header row and column A controls

**Use Cases:**
- Transfer data from old template to new template after updates
- Consolidate data from multiple sources
- Migrate data when template structure changes (if headers match)

### 📤 Export Data (Cell A3)
**Double-click cell A3** (light green) to create timestamped backups:

Creates **two files** with timestamp format `YYYYMMDD_HHMM`:
1. **Excel format**: `<filename>_YYYYMMDD_HHMM.xlsx` (standard Excel workbook)
2. **TSV format**: `<filename>_YYYYMMDD_HHMM.tsv` (tab-separated values, UTF-8 encoded)

**Excel Export Features:**
- Copies all data starting from B1 (headers + data)
- Preserves column widths from original template
- Maintains wrap text settings
- Saves as standard `.xlsx` file (no macros)

**TSV Export Features:**
- RFC 4180 compliant formatting
- Properly quotes fields containing line breaks, tabs, or special characters
- UTF-8 encoding for international characters
- Compatible with Python pandas, R, and other data tools

**Use Cases:**
- Create timestamped backups before major edits
- Export data for analysis in Python/R
- Share data in plain text format (TSV)
- Archive versions at project milestones

### Visual Indicators

| Cell | Color | Action | Description |
|------|-------|--------|-------------|
| **A1** | Orange/Green | Toggle validation | Turn validation ON/OFF |
| **A2** | Light Blue | Import data | Load data from another template |
| **A3** | Light Green | Export data | Create timestamped backup (Excel + TSV) |

---

## 📋 Validation Rules

The macros enforce the following validation rules:

| Rule Type | Description |
|-----------|-------------|
| **Required Fields** | Ensures mandatory fields aren't left empty |
| **Data Type Validation** | Checks for correct format (number, text, date, GUID) |
| **Dropdown Values** | Ensures entries match allowed values from dropdown lists |
| **Regex Patterns** | Validates against custom patterns (e.g., email formats) |
| **Entry Type** | Enforces single vs. multiple entries per cell |
| **Cross-row Validation** | Checks for duplicate/sequential QueryID + Turn number pairs |

---

## 📝 How to Use

1. **Start with validation OFF**: Double-click cell **A1** to turn validation OFF for initial data entry
2. **Fill in data**: Start entering data from row 2 onwards in the "Data Entry" sheet (columns B and onwards)
3. **Review field requirements**: Hover over column headers to see detailed field descriptions and requirements
4. **Use dropdowns**: For dropdown fields, look for the small arrow ▼ on the right side of cells
5. **Validate your data**: When ready to check, double-click cell **A1** to turn validation ON
6. **Check for errors**: All data will be checked - invalid cells turn yellow with explanatory comments
7. **Fix issues**: Correct invalid entries to remove the yellow highlighting
8. **Bulk editing**: Toggle validation OFF again if you need to do bulk edits or copy/paste operations
9. **Reference documentation**: Refer to the "Documentation" sheet for complete field specifications

---

## 🔧 Troubleshooting

### Validation doesn't work
- ✅ **Check that macros are enabled** (see "Enabling Macros" section above)

### License error appears
- ✅ The file may have been opened in an incompatible Excel version
- ✅ Try opening in a different Excel installation

### Toggle validation manually
- ✅ **Double-click cell A1** (the validation toggle button) to switch between ON and OFF

### Validation is too slow
- ✅ Toggle validation **OFF** for bulk operations, then **ON** when done

---

## 🚀 Getting Started

1. **Fill out the Excel template** in `TestQueries/` with your test queries and expected responses
   *(Remember to enable macros for validation functionality!)*

2. **Add knowledge base files** to `Data/InAgent/`

3. **Document your agent design** in `DesignDocumentation/`

4. **Export your solution**: As soon as the agent development is in a stage that can be shared, export your solution from Copilot Studio to `ExportedSolutions/`

---

**Happy Agent Building! 🤖**