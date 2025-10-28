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

.PARAMETER TemplateType
    The template type to use: 'f'/'full' for full template (49 columns),
    'a'/'abridged' for abridged template (15 columns).

.EXAMPLE
    .\create_agent_structure.ps1 -RootDirectory "C:\Projects" -SchemaName "cr3bf_technoMarketingCampaignAnalysis" -TemplateType "f"

    Creates directory with full template: C:\Projects\cr3bf_technoMarketingCampaignAnalysis_resources

.EXAMPLE
    .\create_agent_structure.ps1 -d "~/agents" -s "cr3bf_customerSupport" -t "a"

    Creates directory with abridged template: ~/agents/cr3bf_customerSupport_resources

.NOTES
    Version: 1.1
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
    [string]$SchemaName,

    [Parameter(Mandatory=$true, Position=2, HelpMessage="Enter template type: 'f' or 'full' for full template, 'a' or 'abridged' for abridged template")]
    [Alias("t")]
    [ValidateSet("f", "full", "a", "abridged", IgnoreCase=$true)]
    [string]$TemplateType
)

# Set strict mode for better error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Strip quotes from parameters if they were included (common user error)
$RootDirectory = $RootDirectory.Trim('"').Trim("'")
$SchemaName = $SchemaName.Trim('"').Trim("'")
$TemplateType = $TemplateType.Trim('"').Trim("'").ToLower()

# Normalize template type to full names
$templateTypeDisplay = ""
$templateFileName = ""
if ($TemplateType -eq "f" -or $TemplateType -eq "full") {
    $templateTypeDisplay = "Full"
    $templateFileName = "enhanced_template.xlsm"
} elseif ($TemplateType -eq "a" -or $TemplateType -eq "abridged") {
    $templateTypeDisplay = "Abridged"
    $templateFileName = "abridged_enhanced_template.xlsm"
}

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
Write-ColorOutput "Template Type: $templateTypeDisplay" -ForegroundColor Magenta
Write-Output ""

# Create root directory if it doesn't exist
if (-not (Test-Path -Path $RootDirectory -PathType Container)) {
    Write-ColorOutput "Root directory does not exist: $RootDirectory" -ForegroundColor Yellow
    Write-ColorOutput "Creating root directory..." -ForegroundColor Green
    try {
        New-Item -Path $RootDirectory -ItemType Directory -Force | Out-Null
        Write-ColorOutput "[OK] Created root directory: $RootDirectory`n" -ForegroundColor White
    } catch {
        Write-ColorOutput "`nERROR: Failed to create root directory: $RootDirectory" -ForegroundColor Red
        Write-ColorOutput "Error details: $_" -ForegroundColor Red
        Write-ColorOutput "`nPlease check the path and permissions." -ForegroundColor Yellow
        exit 1
    }
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
    Write-ColorOutput "  [OK] Created: $subdir" -ForegroundColor White
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
    Write-ColorOutput "  [OK] Copied: README.txt" -ForegroundColor White
} else {
    Write-ColorOutput "  [WARNING]: README.txt not found in resources directory" -ForegroundColor Yellow
}

# Copy enhanced_template.xlsm or abridged_enhanced_template.xlsm to TestQueries with renamed filename
$templateSrc = Join-Path -Path $resourcesDir -ChildPath $templateFileName
if (Test-Path -Path $templateSrc) {
    $templateDst = Join-Path -Path $targetPath -ChildPath "TestQueries\Excel_Queries_${SchemaName}.xlsm"
    Copy-Item -Path $templateSrc -Destination $templateDst -Force
    Write-ColorOutput "  [OK] Copied: Excel_Queries_${SchemaName}.xlsm ($templateTypeDisplay template) to TestQueries/" -ForegroundColor White
} else {
    Write-ColorOutput "  [WARNING]: $templateFileName not found in resources directory" -ForegroundColor Yellow
}

# Display completion summary
Write-ColorOutput "`n========================================" -ForegroundColor Cyan
Write-ColorOutput "Structure Creation Complete!" -ForegroundColor Green
Write-ColorOutput "========================================`n" -ForegroundColor Cyan

Write-ColorOutput "Target Directory: $targetPath`n" -ForegroundColor White

Write-ColorOutput "Directory Structure:" -ForegroundColor White
Write-ColorOutput "  $targetDirName/" -ForegroundColor White
Write-ColorOutput "  |-- README.txt" -ForegroundColor White
Write-ColorOutput "  |-- TestQueries/" -ForegroundColor White
Write-ColorOutput "  |   +-- Excel_Queries_${SchemaName}.xlsm ($templateTypeDisplay)" -ForegroundColor White
Write-ColorOutput "  |-- Data/" -ForegroundColor White
Write-ColorOutput "  |   |-- InAgent/" -ForegroundColor White
Write-ColorOutput "  |   +-- Other/" -ForegroundColor White
Write-ColorOutput "  |-- DesignDocumentation/" -ForegroundColor White
Write-ColorOutput "  +-- ExportedSolutions/" -ForegroundColor White

Write-ColorOutput "`nNext Steps:" -ForegroundColor Cyan
Write-ColorOutput "  1. Review README.txt for directory usage guidelines" -ForegroundColor White
Write-ColorOutput "  2. Fill out Excel_Queries_${SchemaName}.xlsm with test queries" -ForegroundColor White
Write-ColorOutput "  3. Add knowledge base files to Data/InAgent/" -ForegroundColor White
Write-ColorOutput "  4. Document agent design in DesignDocumentation/" -ForegroundColor White
Write-ColorOutput "  5. Export solution from Copilot Studio to ExportedSolutions/`n" -ForegroundColor White

Write-ColorOutput "For more information, see the MCS Agent Archiving Process Documentation." -ForegroundColor White
Write-ColorOutput "========================================`n" -ForegroundColor Cyan
