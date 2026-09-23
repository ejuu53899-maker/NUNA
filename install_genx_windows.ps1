[CmdletBinding()]
param(
    [string]$Root = "C:\GENX_FX",
    [string]$DeviceId = "GENX-FX-NODE-01",
    [ValidateSet("controlled_trading_node", "development_controller")]
    [string]$Role = "controlled_trading_node",
    [ValidateSet("demo", "dev")]
    [string]$Environment = "demo",
    [switch]$AddToMachinePath
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Write-JsonFile {
    param(
        [Parameter(Mandatory)]
        [object]$Value,

        [Parameter(Mandatory)]
        [string]$Path
    )

    $parent = Split-Path -Parent $Path
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
    $Value | ConvertTo-Json -Depth 12 | Set-Content -Encoding UTF8 -Path $Path
}

function Get-FreeGb {
    param([object]$Value)

    if ($null -eq $Value) {
        return $null
    }

    return [math]::Round(([double]$Value / 1GB), 2)
}

function Get-DeviceId {
    param([string]$RequestedId)

    $identityPath = Join-Path $Root "identity\device.json"
    $devicePath = Join-Path $Root "device\device.json"

    foreach ($path in @($identityPath, $devicePath)) {
        if (Test-Path $path) {
            try {
                $existing = Get-Content $path -Raw | ConvertFrom-Json
                if ($existing.device_id) {
                    return [string]$existing.device_id
                }
            } catch {
                throw "Existing identity file is invalid: $path"
            }
        }
    }

    if ([string]::IsNullOrWhiteSpace($RequestedId)) {
        throw "No existing device identity found. Re-run with -DeviceId."
    }

    return $RequestedId
}

Write-Host "=== GENX_FX Windows Node Foundation Installer ==="

$folders = @(
    $Root,
    "$Root\identity",
    "$Root\apps",
    "$Root\bin",
    "$Root\config",
    "$Root\device",
    "$Root\logs\active",
    "$Root\logs\archive",
    "$Root\releases\incoming",
    "$Root\releases\verified",
    "$Root\releases\rejected",
    "$Root\runtime\current",
    "$Root\runtime\previous",
    "$Root\runtime\state",
    "$Root\vault\encrypted",
    "$Root\vault\templates",
    "$Root\backups"
)

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Force -Path $folder | Out-Null
    }
}

$resolvedDeviceId = Get-DeviceId -RequestedId $DeviceId

$computer = Get-CimInstance Win32_ComputerSystem
$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$gpu = Get-CimInstance Win32_VideoController
$volumes = Get-Volume | Where-Object {
    $_.DriveType -in @("Fixed", "Removable")
}

$hardware = [ordered]@{
    collected_utc = (Get-Date).ToUniversalTime().ToString("o")
    hostname = $env:COMPUTERNAME
    manufacturer = $computer.Manufacturer
    model = $computer.Model
    system_type = $computer.SystemType
    memory_gb = [math]::Round(([double]$computer.TotalPhysicalMemory / 1GB), 2)
    cpu = @($cpu | ForEach-Object {
        [ordered]@{
            name = $_.Name
            cores = $_.NumberOfCores
            logical_processors = $_.NumberOfLogicalProcessors
            max_clock_mhz = $_.MaxClockSpeed
        }
    })
    operating_system = [ordered]@{
        caption = $os.Caption
        version = $os.Version
        build = $os.BuildNumber
        architecture = $os.OSArchitecture
        last_boot_utc = ([DateTime]$os.LastBootUpTime).ToUniversalTime().ToString("o")
    }
    gpu = @($gpu | ForEach-Object {
        [ordered]@{
            name = $_.Name
            driver_version = $_.DriverVersion
            adapter_ram_gb = Get-FreeGb $_.AdapterRAM
        }
    })
    volumes = @($volumes | ForEach-Object {
        [ordered]@{
            drive = $_.DriveLetter
            label = $_.FileSystemLabel
            filesystem = $_.FileSystem
            size_gb = Get-FreeGb $_.Size
            free_gb = Get-FreeGb $_.SizeRemaining
            health = $_.HealthStatus
        }
    })
}

$identity = [ordered]@{
    schema_version = "genx.device/v1"
    device_id = $resolvedDeviceId
    hostname = $env:COMPUTERNAME
    role = $Role
    environment = $Environment
    platform = "windows"
    hardware_label = "$($computer.Manufacturer) $($computer.Model)"
    created_utc = (Get-Date).ToUniversalTime().ToString("o")
    identity_status = "pending_registration"
    secrets_present = $false
    live_orders = $false
}

$capabilities = [ordered]@{
    schema_version = "genx.capabilities/v1"
    device_id = $resolvedDeviceId
    capabilities = @(
        "device.inventory",
        "device.status",
        "device.health",
        "release.verify",
        "release.rollback"
    )
    forbidden_capabilities = @(
        "live_order_submit",
        "credential_export",
        "arbitrary_command_execution",
        "unapproved_delete",
        "security_policy_disable"
    )
}

Write-JsonFile -Value $identity -Path "$Root\identity\device.json"
Write-JsonFile -Value $identity -Path "$Root\device\device.json"
Write-JsonFile -Value $hardware -Path "$Root\identity\hardware.json"
Write-JsonFile -Value $capabilities -Path "$Root\device\capabilities.json"

$envExample = @"
GENX_ROOT=$Root
GENX_DEVICE_ID=$resolvedDeviceId
GENX_ROLE=$Role
GENX_ENVIRONMENT=$Environment
"@

$envExample | Set-Content -Encoding UTF8 -Path "$Root\config\local.env.example"

$cli = @'
@echo off
setlocal

set "GENX_ROOT=C:\GENX_FX"
set "GENX_DEVICE=%GENX_ROOT%\device\device.json"

if "%~1"=="" goto help
if /I "%~1"=="status" goto status
if /I "%~1"=="drives" goto drives
if /I "%~1"=="device" goto device
if /I "%~1"=="folders" goto folders
if /I "%~1"=="logs" goto logs
if /I "%~1"=="inventory" goto inventory
goto help

:help
echo GENX_FX CLI
echo.
echo   genx status     Show operating-system status
echo   genx drives     Show filesystem volumes
echo   genx device     Show device identity
echo   genx inventory  Show hardware inventory
echo   genx folders    Show GENX folders
echo   genx logs       Open GENX logs
exit /b 0

:status
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$os = Get-CimInstance Win32_OperatingSystem; Write-Output ('Device: ' + $env:COMPUTERNAME); Write-Output ('OS: ' + $os.Caption); Write-Output ('Version: ' + $os.Version); Write-Output ('Last boot: ' + $os.LastBootUpTime)"
exit /b %ERRORLEVEL%

:drives
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "Get-Volume | Where-Object { $_.DriveType -in @('Fixed','Removable') } | Select-Object DriveLetter,FileSystemLabel,FileSystem,@{N='SizeGB';E={[math]::Round($_.Size/1GB,2)}},@{N='FreeGB';E={[math]::Round($_.SizeRemaining/1GB,2)}},HealthStatus | Format-Table -AutoSize"
exit /b %ERRORLEVEL%

:device
type "%GENX_DEVICE%"
exit /b %ERRORLEVEL%

:inventory
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "Get-Content '%GENX_ROOT%\identity\hardware.json' -Raw"
exit /b %ERRORLEVEL%

:folders
tree "%GENX_ROOT%" /F
exit /b %ERRORLEVEL%

:logs
start "" "%GENX_ROOT%\logs"
exit /b 0
'@

$binDir = Join-Path $Root "bin"
$cliPath = Join-Path $binDir "genx.cmd"
$cli | Set-Content -Encoding ASCII -Path $cliPath

if ($AddToMachinePath) {
    $machinePath = [Environment]::GetEnvironmentVariable(
        "Path",
        [EnvironmentVariableTarget]::Machine
    )

    $entries = @($machinePath -split ";" | Where-Object {
        -not [string]::IsNullOrWhiteSpace($_)
    })

    $normalized = $entries | ForEach-Object {
        $_.TrimEnd("\").ToLowerInvariant()
    }

    if ($normalized -notcontains $binDir.ToLowerInvariant().TrimEnd("\")) {
        $newPath = (($entries + $binDir) -join ";")
        [Environment]::SetEnvironmentVariable(
            "Path",
            $newPath,
            [EnvironmentVariableTarget]::Machine
        )
        Write-Host "Added $binDir to machine PATH. Open a new terminal."
    }
}

$installRecord = [ordered]@{
    timestamp_utc = (Get-Date).ToUniversalTime().ToString("o")
    device_id = $resolvedDeviceId
    hostname = $env:COMPUTERNAME
    root = $Root
    role = $Role
    environment = $Environment
    secrets_written = $false
    security_controls_modified = $false
}

$installRecord |
    ConvertTo-Json -Depth 6 |
    Add-Content -Encoding UTF8 -Path "$Root\logs\install.log"

Write-Host ""
Write-Host "=== INSTALLATION COMPLETE ==="
Write-Host "Device ID: $resolvedDeviceId"
Write-Host "Root:      $Root"
Write-Host "CLI:       $cliPath"
Write-Host ""
Write-Host "Open a new terminal and run:"
Write-Host "  genx status"
Write-Host "  genx drives"
Write-Host "  genx device"
Write-Host "  genx inventory"
