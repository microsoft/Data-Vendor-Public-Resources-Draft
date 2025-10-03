===========================================
MCS Agent Resources Directory
===========================================

This directory contains all resources needed for the creation of an agent resources directory structure.

Directory Structure:
--------------------

TestQueries/
    Contains Excel templates to fill in testing queries for the agent - used to collect test evaluation data.
    - Excel_Queries_<schema_name>.xlsx: Template to collect test queries and ground truth data

Data/InAgent/
    Storage for in-agent knowledge base files (DV File Upload).
    Place PDF, DOCX, XLSX, and other knowledge files here that you used to directly load into the agent's knowledge (so not a pointer to a SharePoint directory or similar).

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

Getting Started:
----------------

1. Fill out the Excel template in TestQueries/ with your test queries and expected responses
2. Add knowledge base files to Data/InAgent/
3. Document your agent design in DesignDocumentation/
4. As soon as the agent development is in a stage that can be shared, export your solution from Copilot Studio to ExportedSolutions/

