# ============================================================
# SAVE Documentos - ver y ajustar el limite de correos por hora
#
# El "email rate limit exceeded" lo pone SUPABASE, no Hostinger,
# y es por PROYECTO y por hora, no por IP ni por usuario.
#
#   .\limite-correos.ps1              -> muestra los limites
#   .\limite-correos.ps1 -Correos 100 -> sube el de correos a 100
#
# Ojo con no pasarse: el tope real lo pone tu buzon de Hostinger,
# que admite 1000 o 3000 al dia segun el plan. Poner aqui un
# numero mayor no crea capacidad, solo mueve donde falla.
# ============================================================

param([int]$Correos = 0)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$proyecto = "fzuojuoopngcqrdozvpw"
$tokSeguro = Read-Host "Token personal de Supabase (sbp_...)" -AsSecureString
$token = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
           [Runtime.InteropServices.Marshal]::SecureStringToBSTR($tokSeguro))

$cabeceras = @{ Authorization = "Bearer $token" }
$uri = "https://api.supabase.com/v1/projects/$proyecto/config/auth"

function Mostrar($cabeceras, $uri) {
    $c = Invoke-RestMethod -Method Get -Uri $uri -Headers $cabeceras
    Write-Host ""
    Write-Host "=== Limites actuales ===" -ForegroundColor Cyan
    $c.PSObject.Properties |
      Where-Object { $_.Name -like "rate_limit*" -or $_.Name -eq "smtp_max_frequency" } |
      Sort-Object Name |
      ForEach-Object { Write-Host ("  {0,-34} {1}" -f $_.Name, $_.Value) }
    return $c
}

$antes = Mostrar $cabeceras $uri

if ($Correos -le 0) {
    Write-Host ""
    Write-Host "Solo consulta. Para subirlo:  .\limite-correos.ps1 -Correos 100" -ForegroundColor DarkGray
    Write-Host "rate_limit_email_sent es el de correos por hora en todo el proyecto." -ForegroundColor DarkGray
    Write-Host "smtp_max_frequency es la espera minima, en segundos, entre dos" -ForegroundColor DarkGray
    Write-Host "correos AL MISMO usuario. Si estas probando con alias seguidos," -ForegroundColor DarkGray
    Write-Host "ese no te afecta; el que te frena es el primero." -ForegroundColor DarkGray
    $token = $null
    return
}

Write-Host ""
Write-Host ("=== Poniendo rate_limit_email_sent = $Correos ===") -ForegroundColor Cyan
$cuerpo = @{ rate_limit_email_sent = $Correos } | ConvertTo-Json
try {
    Invoke-RestMethod -Method Patch -Uri $uri -Headers $cabeceras `
        -ContentType "application/json" -Body $cuerpo | Out-Null
    Write-Host "  PATCH aceptado" -ForegroundColor Green
} catch {
    Write-Host ("  FALLO: " + $_.Exception.Message) -ForegroundColor Red
    $r = $_.Exception.Response
    if ($r) { $sr = New-Object IO.StreamReader($r.GetResponseStream()); Write-Host ("  " + $sr.ReadToEnd()) -ForegroundColor Red }
    $token = $null; return
}

Start-Sleep -Seconds 3
$despues = Mostrar $cabeceras $uri

Write-Host ""
if ($despues.rate_limit_email_sent -eq $Correos) {
    Write-Host "Limite actualizado. El contador de la hora en curso no se borra:" -ForegroundColor Green
    Write-Host "si ya lo agotaste, tendras hueco en cuanto suba el tope." -ForegroundColor Green
} else {
    Write-Host "No cambio. Revisa los permisos del token." -ForegroundColor Red
}
$token = $null
