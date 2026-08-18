param(
    [string]$DeviceSerial = "",
    [string]$OutputDir = "d:\App\editremote.onlinehelp.io\assets\img\editremote",
    [string[]]$Names = @("main", "reparti", "iva", "clienti", "abbonamento"),
    [switch]$UpdateHtmlReferences,
    [string]$SiteRoot = "d:\App\editremote.onlinehelp.io"
)

$ErrorActionPreference = 'Stop'

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

if (!(Test-Path $OutputDir)) {
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

Write-Host "Acquisizione screenshot EditRemote" -ForegroundColor Cyan
Write-Host "Apri ogni schermata dell'app sul telefono e premi INVIO per catturare." -ForegroundColor Yellow

foreach ($name in $Names) {
    Read-Host "Pronto per schermata '$name'? Premi INVIO"

    $remote = "/sdcard/${name}.png"
    $local = Join-Path $OutputDir ("$name.png")

    & $adb @deviceArg shell screencap -p $remote | Out-Null
    & $adb @deviceArg pull $remote $local | Out-Null
    & $adb @deviceArg shell rm $remote | Out-Null

    if (Test-Path $local) {
        Write-Host "Salvata: $local" -ForegroundColor Green
    } else {
        Write-Host "Errore acquisizione: $name" -ForegroundColor Red
    }
}

Write-Host "Completato. Screenshot salvati in: $OutputDir" -ForegroundColor Cyan

if ($UpdateHtmlReferences) {
    if (!(Test-Path $SiteRoot)) {
        throw "SiteRoot non trovato: $SiteRoot"
    }

    $htmlFiles = Get-ChildItem -Path $SiteRoot -Filter "*.html" -File -Recurse
    $updated = 0

    foreach ($file in $htmlFiles) {
        $text = Get-Content -Path $file.FullName -Raw
        $original = $text

        foreach ($name in $Names) {
            $text = $text -replace ("assets/img/editremote/{0}\\.jpeg" -f [regex]::Escape($name)), ("assets/img/editremote/{0}.png" -f $name)
            $text = $text -replace ("assets/img/editremote/{0}\\.jpg" -f [regex]::Escape($name)), ("assets/img/editremote/{0}.png" -f $name)
        }

        if ($text -ne $original) {
            Set-Content -Path $file.FullName -Value $text -Encoding UTF8
            $updated++
        }
    }

    Write-Host ("Riferimenti HTML aggiornati in {0} file." -f $updated) -ForegroundColor Cyan
}