===========================================
MCS Agent Resources Directory
===========================================

This directory contains all resources needed for the creation of an agent resources directory structure.

Directory Structure:
--------------------

TestQueries/
    Contains Excel templates with embedded validation macros for test query collection.
    - Excel_Queries_<schema_name>.xlsm: Macro-enabled template to collect test queries
      and ground truth data with automatic validation and error checking.

Data/InAgent/
    Storage for in-agent knowledge base files (DV File Upload).
    Place PDF, DOCX, XLSX, and other knowledge files here that you used to directly
    load into the agent's knowledge (so not a pointer to a SharePoint directory or similar).

Data/Other/
    Storage for supplementary data files and resources.
    Use this for data files that don't go into the agent directly.
    You can create sub-directories with sets of data.
    Keep directory names short, ideally without spaces or special characters like ampersand.

DesignDocumentation/
    Documentation for agent design, architecture, and requirements.
    Store design documents, flow diagrams, and technical specifications here.

ExportedSolutions/
    Storage for exported MCS solution files.
    Save solution exports (.zip files) from Copilot Studio here.


Excel Template Macro Functionality:
------------------------------------

The Excel_Queries_<schema_name>.xlsm file contains VBA macros that provide automatic
validation and quality checking as you enter data.

ENABLING MACROS:
When you first open the file, Excel may show a security warning:
  "SECURITY WARNING: Macros have been disabled."

To enable the validation functionality:
  1. Click the "Enable Content" button in the yellow banner at the top
  2. Or go to File → Options → Trust Center → Trust Center Settings → Macro Settings
     and select "Enable all macros" (or "Disable all macros with notification")

WHAT THE MACROS DO:
- Real-time validation: As you type in cells, the macro checks your entries against
  the rules defined in the Documentation sheet

- Visual feedback: Invalid entries are highlighted in YELLOW with comments explaining
  what's wrong

- Validation rules include:
  * Required field checking (ensures mandatory fields aren't left empty)
  * Data type validation (number, text, date, GUID format checking)
  * Dropdown value checking (ensures entries match allowed values)
  * Regex pattern matching (validates against custom patterns like email formats)
  * Entry type validation (single vs. multiple entries per cell)
  * Cross-row validation (checks for duplicate/sequential QueryID + Turn number pairs)

HOW TO USE:
  1. Start filling in data from row 2 onwards in the "Data Entry" sheet
  2. Hover over column headers to see detailed field descriptions and requirements
  3. For dropdown fields, look for the small arrow on the right side of cells
  4. If a cell turns yellow, hover over it to see the comment explaining the issue
  5. Fix invalid entries to remove the yellow highlighting
  6. Refer to the "Documentation" sheet for complete field specifications

TROUBLESHOOTING:
- If validation doesn't work: Check that macros are enabled (see above)
- If you see a license error: The file may have been opened in an incompatible
  Excel version. Try opening in a different Excel installation.
- To temporarily disable validation: Press Alt+F11, find the Sheet1 module,
  and comment out the Worksheet_Change event handler


Getting Started:
----------------

1. Fill out the Excel template in TestQueries/ with your test queries and expected responses
   (Remember to enable macros for validation functionality!)
2. Add knowledge base files to Data/InAgent/
3. Document your agent design in DesignDocumentation/
4. As soon as the agent development is in a stage that can be shared, export your
   solution from Copilot Studio to ExportedSolutions/

