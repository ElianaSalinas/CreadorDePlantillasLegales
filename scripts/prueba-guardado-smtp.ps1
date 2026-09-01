# ============================================================
# SAVE Documentos - ¿guarda Supabase la contrasena SMTP?
#
# Sospecha: el PATCH se acepta pero smtp_pass no cambia nunca.
# La pista es que la API devuelve SIEMPRE el mismo hash,
# 4d4d44ee..., aunque se hayan escrito contrasenas distintas.
#
# Este script lo prueba sin ambiguedad:
#   1. lee el hash actual
#   2. escribe una contrasena BASURA y vuelve a leer
#   3. restaura la tuya y vuelve a leer
#
# Si el hash NO cambia en el paso 2, Supabase esta ignorando el
# campo. Eso seria su fallo, no tuyo, y explicaria los meses de
# 535 con credenciales que funcionan a mano.
#
# La contrasena basura queda solo unos segundos, y el paso 3
# deja la tuya puesta.
# ============================================================

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$proyecto = "fzuojuoopngcqrdozvpw"

$tokSeguro = Read-Host "Token personal de Supabase (sbp_...)" -AsSecureString
$token = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
           [Runtime.InteropServices.Marshal]::SecureStringToBSTR($tokSeguro))

$pwSeguro = Read-Host "Tu app password REAL (se restaura al final)" -AsSecureString
$real = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
          [Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwSeguro))

$cabeceras = @{ Authorization = "Bearer $token" }
$uri = "https://api.supabase.com/v1/projects/$proyecto/config/auth"

function LeerHash($cabeceras, $uri) {
    $c = Invoke-RestMethod -Method Get -Uri $uri -Headers $cabeceras
    if ([string]::IsNullOrEmpty($c.smtp_pass)) { return "(vacio)" }
    return $c.smtp_pass
}

function Escribir($cabeceras, $uri, $clave) {
    $cuerpo = @{ smtp_pass = $clave } | ConvertTo-Json
    try {
        Invoke-RestMethod -Method Patch -Uri $uri -Headers $cabeceras `
            -ContentType "application/json" -Body $cuerpo | Out-Null
        return $true
    } catch {
        Write-Host ("  PATCH fallo: " + $_.Exception.Message) -ForegroundColor Red
        return $false
    }
}

Write-Host ""
$h0 = LeerHash $cabeceras $uri
Write-Host "1. hash ANTES de tocar nada" -ForegroundColor Cyan
Write-Host "   $h0"

$basura = "BASURA-" + [Guid]::NewGuid().ToString("N")
Write-Host ""
Write-Host "2. escribiendo una contrasena BASURA distinta..." -ForegroundColor Cyan
if (-not (Escribir $cabeceras $uri $basura)) { return }
Start-Sleep -Seconds 4
$h1 = LeerHash $cabeceras $uri
Write-Host "   $h1"

Write-Host ""
Write-Host "3. restaurando la tuya..." -ForegroundColor Cyan
if (-not (Escribir $cabeceras $uri $real)) {
    Write-Host "   OJO: no se pudo restaurar. Vuelve a correr configurar-smtp-supabase.ps1" -ForegroundColor Red
    return
}
Start-Sleep -Seconds 4
$h2 = LeerHash $cabeceras $uri
Write-Host "   $h2"

Write-Host ""
Write-Host "=== VEREDICTO ===" -ForegroundColor Cyan
if ($h0 -eq $h1 -and $h1 -eq $h2) {
    Write-Host "  El hash NO cambio ni con una contrasena basura." -ForegroundColor Red
    Write-Host "  Supabase acepta el PATCH pero NO guarda smtp_pass." -ForegroundColor Red
    Write-Host "  Ese es el fallo, y es suyo. Ya tienes la prueba para el ticket." -ForegroundColor Red
} elseif ($h1 -ne $h0 -and $h2 -eq $h0) {
    Write-Host "  El hash cambio con la basura y volvio al restaurar." -ForegroundColor Green
    Write-Host "  Supabase SI guarda la contrasena. El problema es otro." -ForegroundColor Green
} else {
    Write-Host "  Resultado mixto. Pasale los tres hashes a Claude." -ForegroundColor Yellow
}

$token = $null; $real = $null; $basura = $null
