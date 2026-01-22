<#
.SYNOPSIS
    Claude Code RPI Plus Installer (Windows)

.DESCRIPTION
    Installs the RPI Plus pack to a target project directory.

.PARAMETER TargetDir
    Target directory to install to. Defaults to current directory.

.EXAMPLE
    .\install.ps1
    .\install.ps1 -TargetDir C:\Projects\MyProject
#>

param(
    [string]$TargetDir = "."
)

$ErrorActionPreference = "Stop"

$PackDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TargetDir = Resolve-Path $TargetDir -ErrorAction SilentlyContinue

if (-not $TargetDir) {
    Write-Host "Error: Target directory does not exist" -ForegroundColor Red
    exit 1
}

Write-Host "Claude Code RPI Plus Installer"
Write-Host "==============================="
Write-Host ""
Write-Host "Pack source: $PackDir"
Write-Host "Target: $TargetDir"
Write-Host ""

# Check if .claude already exists
if (Test-Path "$TargetDir\.claude") {
    Write-Host "WARNING: .claude\ directory already exists" -ForegroundColor Yellow
    $confirm = Read-Host "Merge with existing? (y/N)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "Aborted."
        exit 1
    }
    Write-Host ""
}

# Copy core files
Write-Host "Installing core configuration..."
Copy-Item -Path "$PackDir\.claude" -Destination "$TargetDir\" -Recurse -Force
Write-Host "  - .claude\ directory"

# Copy scripts
Write-Host "Installing scripts..."
if (-not (Test-Path "$TargetDir\scripts")) {
    New-Item -ItemType Directory -Path "$TargetDir\scripts" -Force | Out-Null
}
Copy-Item -Path "$PackDir\scripts\validate-artefacts.py" -Destination "$TargetDir\scripts\" -Force
Copy-Item -Path "$PackDir\scripts\cc-transcript.sh" -Destination "$TargetDir\scripts\" -Force
Copy-Item -Path "$PackDir\scripts\cc-transcript.ps1" -Destination "$TargetDir\scripts\" -Force
Write-Host "  - scripts\validate-artefacts.py"
Write-Host "  - scripts\cc-transcript.sh"
Write-Host "  - scripts\cc-transcript.ps1"

# Create artefact directories
Write-Host "Creating artefact directories..."
$dirs = @(
    "docs\plans",
    "docs\research",
    "docs\state",
    "docs\verification"
)
foreach ($dir in $dirs) {
    $path = Join-Path $TargetDir $dir
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
    Write-Host "  - $dir\"
}

# Copy templates
Write-Host "Copying templates..."
$templatesDir = Join-Path $PackDir "templates"
if (Test-Path $templatesDir) {
    $templateFile = Join-Path $templatesDir "CLAUDE.md.template"
    if (Test-Path $templateFile) {
        Copy-Item -Path $templateFile -Destination "$TargetDir\" -Force
    }
    $gitignoreFile = Join-Path $templatesDir "gitignore.additions"
    if (Test-Path $gitignoreFile) {
        Copy-Item -Path $gitignoreFile -Destination "$TargetDir\" -Force
    }
}

# Create local config from example
$localConfig = Join-Path $TargetDir ".claude\portable_config.local.yaml"
if (-not (Test-Path $localConfig)) {
    $exampleConfig = Join-Path $TargetDir ".claude\portable_config.local.example.yaml"
    Copy-Item -Path $exampleConfig -Destination $localConfig
    Write-Host "  - Created portable_config.local.yaml from example"
}

# Append to .gitignore if it exists
$gitignore = Join-Path $TargetDir ".gitignore"
$gitignoreAdditions = Join-Path $TargetDir "gitignore.additions"
if ((Test-Path $gitignore) -and (Test-Path $gitignoreAdditions)) {
    Add-Content -Path $gitignore -Value ""
    Get-Content $gitignoreAdditions | Add-Content -Path $gitignore
    Remove-Item $gitignoreAdditions
    Write-Host "  - Updated .gitignore"
} elseif (Test-Path $gitignoreAdditions) {
    Rename-Item -Path $gitignoreAdditions -NewName ".gitignore"
    Write-Host "  - Created .gitignore"
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "PREREQUISITE: Run /init first (if not already done)"
Write-Host "===================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "If you haven't run /init yet:"
Write-Host "  cd $TargetDir"
Write-Host "  claude"
Write-Host "  > /init"
Write-Host ""
Write-Host "NEXT STEP - use this prompt in Claude Code:"
Write-Host "============================================"
Write-Host ""
Write-Host "Merge the workflow section from CLAUDE.md.template into the existing CLAUDE.md."
Write-Host "Then configure .claude/portable_config.local.yaml with the project name and test command."
Write-Host "Finally, run /phase_complete to verify setup and delete CLAUDE.md.template."
Write-Host ""
