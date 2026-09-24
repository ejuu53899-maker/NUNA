# GitHub Enterprise lenga6-9v-5g Setup Script for PowerShell
# Configures and verifies GitHub Enterprise Cloud integration on Windows

param (
    [switch]$Verify
)

$EnterpriseSlug = "lenga6-9v-5g"
$EnterpriseUrl  = "https://github.com/enterprises/lenga6-9v-5g"

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "   GitHub Enterprise ($EnterpriseSlug) Setup Helper  " -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

if ($Verify) {
    Write-Host "Verifying GitHub Enterprise configuration..." -ForegroundColor Cyan
    if (Test-Path "system-info.json") {
        $sysJson = Get-Content "system-info.json" -Raw
        if ($sysJson -like "*$EnterpriseUrl*") {
            Write-Host "[✓] system-info.json contains Enterprise URL: $EnterpriseUrl" -ForegroundColor Green
        }
    }
    $remotes = git remote -v
    if ($remotes -like "*$EnterpriseSlug*") {
        Write-Host "[✓] Git remote contains enterprise endpoint." -ForegroundColor Green
    } else {
        Write-Host "[!] Enterprise remote not added yet to git remotes." -ForegroundColor Yellow
    }
} else {
    Write-Host "Configuring GitHub Enterprise endpoint: $EnterpriseUrl" -ForegroundColor Cyan

    $existingRemotes = git remote
    if ($existingRemotes -contains "enterprise") {
        Write-Host "Remote 'enterprise' already exists. Updating URL..." -ForegroundColor Yellow
        git remote set-url enterprise "$EnterpriseUrl/NUNA.git"
    } else {
        Write-Host "Adding remote 'enterprise'..." -ForegroundColor Cyan
        git remote add enterprise "$EnterpriseUrl/NUNA.git"
    }

    Write-Host "[✓] Enterprise remote configured:" -ForegroundColor Green
    Write-Host "  Enterprise URL:  $EnterpriseUrl"
    Write-Host "  Enterprise Slug: $EnterpriseSlug"
    Write-Host "Setup completed successfully!" -ForegroundColor Green
}
