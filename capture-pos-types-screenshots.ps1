[CmdletBinding(PositionalBinding = $false)]
param(
    [string]$DeviceSerial = "",
    [string]$OutputDir = "d:\App\editremote.onlinehelp.io\assets\img\editremote",
    [string[]]$PosTypes = @("mypos", "prot17", "dojo"),
    [string[]]$ScreensPerType = @("pos", "pagamenti")
)

$ErrorActionPreference = "Stop"

function Get-PathConfig {
    $configPath = "d:\App\EditRemote\android-paths.txt"
    $map = @{}

    if (-not (Test-Path $configPath)) {
        return $map
    }

    foreach ($line in Get-Content -Path $configPath) {
        $trimmed = $line.Trim()
        if (-not $trimmed -or $trimmed.StartsWith("#")) { continue }
        $parts = $trimmed -split "=", 2
        if ($parts.Count -ne 2) { continue }
        $key = $parts[0].Trim()
        $value = $parts[1].Trim()
        if ($key) { $map[$key] = $value }
    }

    return $map
}

function Resolve-AdbPath {
    $pathConfig = Get-PathConfig
    if ($pathConfig.ContainsKey("SDK_ROOT")) {
        $candidate = Join-Path $pathConfig["SDK_ROOT"] "platform-tools\adb.exe"
        if (Test-Path $candidate) {
            return $candidate
        }
    }

    $adbCmd = Get-Command adb -ErrorAction SilentlyContinue
    if ($adbCmd -and $adbCmd.Source) {
        return $adbCmd.Source
    }

    throw "adb non trovato: imposta SDK_ROOT in android-paths.txt oppure aggiungi adb al PATH."
}

function Capture-OneScreenshot {
    param(
        [string]$Adb,
        [string[]]$DeviceArg,
        [string]$OutputDirectory,
        [string]$Name,
        [string]$Prompt
    )

    Read-Host $Prompt | Out-Null

    $remote = "/sdcard/$Name.png"
    $local = Join-Path $OutputDirectory ("$Name.png")

    & $Adb @DeviceArg shell screencap -p $remote | Out-Null
    & $Adb @DeviceArg pull $remote $local | Out-Null
    & $Adb @DeviceArg shell rm $remote | Out-Null

    if (Test-Path $local) {
        Write-Host "Salvata: $local" -ForegroundColor Green
    } else {
        throw "Errore acquisizione screenshot: $Name"
    }
}

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

$adb = Resolve-AdbPath

$deviceArg = @()
if ($DeviceSerial.Trim().Length -gt 0) {
    $deviceArg = @("-s", $DeviceSerial)
}

& $adb @deviceArg get-state | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw "Dispositivo adb non disponibile. Collega il device e abilita debug USB."
}

Write-Host "Acquisizione screenshot POS per tipi terminale" -ForegroundColor Cyan
Write-Host "Tipi POS: $($PosTypes -join ', ')" -ForegroundColor Gray
Write-Host "Schermate per tipo: $($ScreensPerType -join ', ')" -ForegroundColor Gray
Write-Host "Apri la schermata richiesta nell'app EditRemote e premi INVIO." -ForegroundColor Yellow

foreach ($type in $PosTypes) {
    $normalizedType = $type.Trim().ToLower()
    if ($normalizedType.Length -eq 0) { continue }

    Write-Host "" 
    Write-Host "=== Tipo POS: $normalizedType ===" -ForegroundColor Magenta

    if ($normalizedType -eq "mypos") {
        Write-Host "Imposta TIPO POS = MYPOS (connessione USB)." -ForegroundColor DarkCyan
    } elseif ($normalizedType -eq "prot17") {
        Write-Host "Imposta TIPO POS = PROT.17 (Ingenico)." -ForegroundColor DarkCyan
    } elseif ($normalizedType -eq "dojo") {
        Write-Host "Imposta TIPO POS = DOJO (API KEY / RESELLER ID / TERMINAL ID)." -ForegroundColor DarkCyan
    } else {
        Write-Host "Tipo personalizzato: $normalizedType" -ForegroundColor DarkCyan
    }

    foreach ($screen in $ScreensPerType) {
        $normalizedScreen = $screen.Trim().ToLower()
        if ($normalizedScreen.Length -eq 0) { continue }

        $shotName = "{0}_{1}" -f $normalizedScreen, $normalizedType
        $prompt = "Pronto per '$shotName'? Premi INVIO"

        Capture-OneScreenshot -Adb $adb -DeviceArg $deviceArg -OutputDirectory $OutputDir -Name $shotName -Prompt $prompt
    }
}

Write-Host "" 
Write-Host "Completato." -ForegroundColor Cyan
Write-Host "File attesi (esempio):" -ForegroundColor Gray
Write-Host "- pos_mypos.png" -ForegroundColor Gray
Write-Host "- pos_prot17.png" -ForegroundColor Gray
Write-Host "- pos_dojo.png" -ForegroundColor Gray
Write-Host "- pagamenti_mypos.png" -ForegroundColor Gray
Write-Host "- pagamenti_prot17.png" -ForegroundColor Gray
Write-Host "- pagamenti_dojo.png" -ForegroundColor Gray
