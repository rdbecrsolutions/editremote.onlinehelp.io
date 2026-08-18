param(
    [string]$DeviceSerial = "",
    [string]$OutputDir = "d:\App\editremote.onlinehelp.io\assets\img\editremote",
    [string[]]$Names = @("main", "reparti", "iva", "clienti", "abbonamento"),
    [switch]$UpdateHtmlReferences,
    [string]$SiteRoot = "d:\App\editremote.onlinehelp.io"
)

$ErrorActionPreference = 'Stop'

if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

$adb = "adb"
$adbCmd = Get-Command $adb -ErrorAction SilentlyContinue
if (-not $adbCmd) {
    throw "adb non trovato nel PATH. Installa Android platform-tools o aggiungi adb al PATH."
}

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