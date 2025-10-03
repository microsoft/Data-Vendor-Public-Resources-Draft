<#
.SYNOPSIS
    Creates a standardized MCS agent resource directory structure.

.DESCRIPTION
    This script creates a complete directory structure for MCS agent development,
    including subdirectories for test queries, data files, documentation, and solutions.
    It also copies template files from the resources directory.

.PARAMETER RootDirectory
    The root directory where the agent structure will be created.
    Must be an existing directory.

.PARAMETER SchemaName
    The agent schema name (e.g., cr3bf_technoMarketingCampaignAnalysis).
    This will be used as part of the directory name and file naming.

.EXAMPLE
    .\create_agent_structure.ps1 -RootDirectory "C:\Projects" -SchemaName "cr3bf_technoMarketingCampaignAnalysis"

    Creates directory: C:\Projects\cr3bf_technoMarketingCampaignAnalysis_resources

.EXAMPLE
    .\create_agent_structure.ps1 -d "~/agents" -s "cr3bf_customerSupport"

    Creates directory: ~/agents/cr3bf_customerSupport_resources

.NOTES
    Version: 1.0
    Author: MCS AI Team
    Last Updated: October 2025

    Compatible with:
    - Windows PowerShell 5.1+
    - PowerShell Core 7+ (cross-platform)
    - Works in WSL with PowerShell installed
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0, HelpMessage="Enter the root directory path (without quotes if prompted interactively)")]
    [Alias("d")]
    [string]$RootDirectory,

    [Parameter(Mandatory=$true, Position=1, HelpMessage="Enter the agent schema name (alphanumeric and underscores only, no quotes)")]
    [Alias("s")]
    [string]$SchemaName
)

# Set strict mode for better error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Strip quotes from parameters if they were included (common user error)
$RootDirectory = $RootDirectory.Trim('"').Trim("'")
$SchemaName = $SchemaName.Trim('"').Trim("'")

# Function to write colored output
function Write-ColorOutput {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [ConsoleColor]$ForegroundColor = [ConsoleColor]::White
    )

    $originalColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $ForegroundColor
    Write-Output $Message
    $Host.UI.RawUI.ForegroundColor = $originalColor
}

# Display header
Write-ColorOutput "`n========================================" -ForegroundColor Cyan
Write-ColorOutput "MCS Agent Structure Creator" -ForegroundColor Cyan
Write-ColorOutput "========================================`n" -ForegroundColor Cyan

# Validate root directory exists
if (-not (Test-Path -Path $RootDirectory -PathType Container)) {
    Write-ColorOutput "ERROR: Root directory does not exist: $RootDirectory" -ForegroundColor Red
    Write-ColorOutput "Please create the directory first or provide a valid path." -ForegroundColor Yellow
    Write-ColorOutput "`nNote: When prompted interactively, enter paths WITHOUT quotes." -ForegroundColor Cyan
    Write-ColorOutput "Example: C:\Users\username\Documents (not `"C:\Users\username\Documents`")" -ForegroundColor White
    exit 1
}

# Validate schema name format - must be alphanumeric and underscores only
if ($SchemaName -notmatch '^[a-zA-Z0-9_]+$') {
    Write-ColorOutput "`nERROR: Invalid schema name: $SchemaName" -ForegroundColor Red
    Write-ColorOutput "Schema name must contain only:" -ForegroundColor Yellow
    Write-ColorOutput "  - Letters (a-z, A-Z)" -ForegroundColor White
    Write-ColorOutput "  - Numbers (0-9)" -ForegroundColor White
    Write-ColorOutput "  - Underscores (_)" -ForegroundColor White
    Write-ColorOutput "`nNo spaces or special characters are allowed." -ForegroundColor Yellow
    Write-ColorOutput "`nValid examples:" -ForegroundColor Cyan
    Write-ColorOutput "  - cr3bf_agentName" -ForegroundColor White
    Write-ColorOutput "  - cr3bf_technoMarketingCampaignAnalysis" -ForegroundColor White
    Write-ColorOutput "  - myAgent_v1" -ForegroundColor White
    Write-ColorOutput "`nInvalid examples:" -ForegroundColor Cyan
    Write-ColorOutput "  - my-agent (contains dash)" -ForegroundColor Red
    Write-ColorOutput "  - my agent (contains space)" -ForegroundColor Red
    Write-ColorOutput "  - my@agent (contains special character)" -ForegroundColor Red
    Write-ColorOutput "`nOperation cancelled." -ForegroundColor Yellow
    exit 1
}

# Construct target directory name
$targetDirName = "${SchemaName}_resources"
$targetPath = Join-Path -Path $RootDirectory -ChildPath $targetDirName

# Check if target directory already exists
if (Test-Path -Path $targetPath) {
    Write-ColorOutput "WARNING: Target directory already exists: $targetPath" -ForegroundColor Yellow
    $overwrite = Read-Host "Overwrite existing directory? (y/n)"
    if ($overwrite -ne 'y') {
        Write-ColorOutput "Operation cancelled." -ForegroundColor Yellow
        exit 0
    }
    Write-ColorOutput "Removing existing directory..." -ForegroundColor Yellow
    Remove-Item -Path $targetPath -Recurse -Force
}

# Define directory structure
$subdirectories = @(
    "TestQueries",
    "Data\InAgent",
    "Data\Other",
    "DesignDocumentation",
    "ExportedSolutions"
)

# Create main directory
Write-ColorOutput "Creating agent resource directory: $targetPath" -ForegroundColor Green
New-Item -Path $targetPath -ItemType Directory -Force | Out-Null

# Create subdirectories
Write-ColorOutput "`nCreating subdirectories:" -ForegroundColor Green
foreach ($subdir in $subdirectories) {
    $subdirPath = Join-Path -Path $targetPath -ChildPath $subdir
    New-Item -Path $subdirPath -ItemType Directory -Force | Out-Null
    Write-ColorOutput "  ✓ Created: $subdir" -ForegroundColor White
}

# Get script directory and resources path
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$resourcesDir = Join-Path -Path $scriptDir -ChildPath "resources"

# Validate resources directory exists
if (-not (Test-Path -Path $resourcesDir -PathType Container)) {
    Write-ColorOutput "`nERROR: Resources directory not found: $resourcesDir" -ForegroundColor Red
    Write-ColorOutput "Please ensure the 'resources' subdirectory exists in the script directory." -ForegroundColor Yellow
    exit 1
}

# Copy README.txt to root of target directory
Write-ColorOutput "`nCopying resource files:" -ForegroundColor Green
$readmeSrc = Join-Path -Path $resourcesDir -ChildPath "README.txt"
if (Test-Path -Path $readmeSrc) {
    $readmeDst = Join-Path -Path $targetPath -ChildPath "README.txt"
    Copy-Item -Path $readmeSrc -Destination $readmeDst -Force
    Write-ColorOutput "  ✓ Copied: README.txt" -ForegroundColor White
} else {
    Write-ColorOutput "  ⚠ WARNING: README.txt not found in resources directory" -ForegroundColor Yellow
}

# Copy enhanced_template.xlsx to TestQueries with renamed filename
$templateSrc = Join-Path -Path $resourcesDir -ChildPath "enhanced_template.xlsx"
if (Test-Path -Path $templateSrc) {
    $templateDst = Join-Path -Path $targetPath -ChildPath "TestQueries\Excel_Queries_${SchemaName}.xlsx"
    Copy-Item -Path $templateSrc -Destination $templateDst -Force
    Write-ColorOutput "  ✓ Copied: Excel_Queries_${SchemaName}.xlsx to TestQueries/" -ForegroundColor White
} else {
    Write-ColorOutput "  ⚠ WARNING: enhanced_template.xlsx not found in resources directory" -ForegroundColor Yellow
}

# Display completion summary
Write-ColorOutput "`n========================================" -ForegroundColor Cyan
Write-ColorOutput "Structure Creation Complete!" -ForegroundColor Green
Write-ColorOutput "========================================`n" -ForegroundColor Cyan

Write-ColorOutput "Target Directory: $targetPath`n" -ForegroundColor White

Write-ColorOutput "Directory Structure:" -ForegroundColor White
Write-ColorOutput "  $targetDirName/" -ForegroundColor White
Write-ColorOutput "  ├── README.txt" -ForegroundColor White
Write-ColorOutput "  ├── TestQueries/" -ForegroundColor White
Write-ColorOutput "  │   └── Excel_Queries_${SchemaName}.xlsx" -ForegroundColor White
Write-ColorOutput "  ├── Data/" -ForegroundColor White
Write-ColorOutput "  │   ├── InAgent/" -ForegroundColor White
Write-ColorOutput "  │   └── Other/" -ForegroundColor White
Write-ColorOutput "  ├── DesignDocumentation/" -ForegroundColor White
Write-ColorOutput "  └── ExportedSolutions/" -ForegroundColor White

Write-ColorOutput "`nNext Steps:" -ForegroundColor Cyan
Write-ColorOutput "  1. Review README.txt for directory usage guidelines" -ForegroundColor White
Write-ColorOutput "  2. Fill out Excel_Queries_${SchemaName}.xlsx with test queries" -ForegroundColor White
Write-ColorOutput "  3. Add knowledge base files to Data/InAgent/" -ForegroundColor White
Write-ColorOutput "  4. Document agent design in DesignDocumentation/" -ForegroundColor White
Write-ColorOutput "  5. Export solution from Copilot Studio to ExportedSolutions/`n" -ForegroundColor White

Write-ColorOutput "For more information, see the MCS Agent Archiving Process Documentation." -ForegroundColor White
Write-ColorOutput "========================================`n" -ForegroundColor Cyan
