$ErrorActionPreference = "Stop"

function Test-UsableValue {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $false
    }

    return $Value -notmatch '^\s*\{(?:config_parameter|gameserver|machine|container)\b'
}

function Get-Setting {
    param(
        [string]$Name,
        [string]$Default
    )

    $value = [Environment]::GetEnvironmentVariable($Name)
    if (-not (Test-UsableValue $value)) {
        return $Default
    }

    return $value.Trim()
}

function Get-BoolSetting {
    param(
        [string]$Name,
        [bool]$Default
    )

    $value = Get-Setting $Name ""
    if ([string]::IsNullOrWhiteSpace($value)) {
        return $Default
    }

    switch ($value.ToLowerInvariant()) {
        { $_ -in @("1", "true", "yes", "on") } { return $true }
        { $_ -in @("0", "false", "no", "off") } { return $false }
        default {
            Write-Warning "Could not parse boolean $Name value '$value'; using $Default."
            return $Default
        }
    }
}

function Quote-CommandArg {
    param([string]$Value)

    if ($null -eq $Value) {
        return '""'
    }

    if ($Value -notmatch '[\s"]') {
        return $Value
    }

    return '"' + ($Value -replace '"', '\"') + '"'
}

function Invoke-Tf2Update {
    param(
        [string]$SteamCmd,
        [string]$InstallRoot,
        [bool]$Validate
    )

    if (-not (Test-Path -LiteralPath $SteamCmd)) {
        throw "SteamCMD was not found at $SteamCmd"
    }

    New-Item -ItemType Directory -Force -Path $InstallRoot | Out-Null

    $steamArgs = @(
        "+force_install_dir", $InstallRoot,
        "+login", "anonymous",
        "+app_update", "232250"
    )

    if ($Validate) {
        $steamArgs += "validate"
    }

    $steamArgs += "+quit"

    Write-Host "Running SteamCMD for Team Fortress 2 Dedicated Server app 232250."
    if ($Validate) {
        Write-Host "SteamCMD validation is enabled for this run."
    }

    $exitCode = $null
    for ($attempt = 1; $attempt -le 2; $attempt++) {
        & $SteamCmd @steamArgs
        $exitCode = $LASTEXITCODE
        if ($exitCode -eq 0) {
            break
        }

        if ($exitCode -eq 7 -and $attempt -lt 2) {
            Write-Warning "SteamCMD returned exit code 7, likely after a self-update. Retrying once."
            Start-Sleep -Seconds 5
            continue
        }

        break
    }

    if ($exitCode -ne 0) {
        throw "SteamCMD app_update 232250 failed with exit code $exitCode."
    }
}

function Ensure-DefaultConfigFiles {
    param([string]$InstallRoot)

    $cfgDir = Join-Path $InstallRoot "tf\cfg"
    New-Item -ItemType Directory -Force -Path $cfgDir | Out-Null

    $serverCfg = Join-Path $cfgDir "server.cfg"
    if (-not (Test-Path -LiteralPath $serverCfg)) {
        @(
            'hostname "Team Fortress 2 Server"'
            'rcon_password ""'
            'sv_lan "0"'
            'sv_pure "1"'
            'log on'
            'sv_logfile 1'
            'sv_logecho 0'
        ) | Set-Content -LiteralPath $serverCfg -Encoding ASCII
    }

    $mapCycle = Join-Path $cfgDir "mapcycle.txt"
    if (-not (Test-Path -LiteralPath $mapCycle)) {
        @(
            "pl_upward"
            "pl_badwater"
            "cp_dustbowl"
            "koth_viaduct"
            "ctf_2fort"
        ) | Set-Content -LiteralPath $mapCycle -Encoding ASCII
    }
}

$steamCmd = Get-Setting "STEAMCMD_PATH" "C:/steamcmd/steamcmd.exe"
$installRoot = Get-Setting "TF2_ROOT" "C:/serverfiles"
$port = Get-Setting "TF2_PORT" "27015"
$maxPlayers = Get-Setting "TF2_MAXPLAYERS" "24"
$startMap = Get-Setting "TF2_START_MAP" "pl_upward"
$extraArgs = Get-Setting "TF2_EXTRA_ARGS" ""
$updateOnStart = Get-BoolSetting "TF2_UPDATE_ON_START" $true
$validateOnUpdate = Get-BoolSetting "TF2_VALIDATE_ON_UPDATE" $false

New-Item -ItemType Directory -Force -Path $installRoot | Out-Null

$srcds = Join-Path $installRoot "srcds.exe"
if ($updateOnStart -or -not (Test-Path -LiteralPath $srcds)) {
    Invoke-Tf2Update $steamCmd $installRoot $validateOnUpdate
}
else {
    Write-Host "TF2 server files already exist and TF2_UPDATE_ON_START is false; skipping SteamCMD update."
}

if (-not (Test-Path -LiteralPath $srcds)) {
    throw "TF2 srcds.exe was not found after install/update: $srcds"
}

Ensure-DefaultConfigFiles $installRoot

$launchArgs = @(
    "-game", "tf",
    "-console",
    "-norestart",
    "-usercon",
    "-strictportbind",
    "-condebug",
    "-port", $port,
    "+map", $startMap,
    "+maxplayers", $maxPlayers,
    "+exec", "server.cfg"
)

$argumentLine = ($launchArgs | ForEach-Object { Quote-CommandArg $_ }) -join " "
if (Test-UsableValue $extraArgs) {
    $argumentLine = "$argumentLine $extraArgs"
}

$commandLine = '"' + $srcds + '" ' + $argumentLine

Write-Host "Launching Team Fortress 2 Dedicated Server."
Write-Host "Install root: $installRoot"
Write-Host "Map: $startMap"
Write-Host "Max players: $maxPlayers"
Write-Host "Port: $port"
if (Test-UsableValue $extraArgs) {
    Write-Host "Extra args: $extraArgs"
}

Set-Location -LiteralPath $installRoot
& cmd.exe /s /c $commandLine
$serverExitCode = $LASTEXITCODE

Write-Host "TF2 server exited with code $serverExitCode."
exit $serverExitCode
