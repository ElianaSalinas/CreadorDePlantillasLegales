# ============================================================
# SAVE Documentos - configurar el SMTP de Supabase por API
#
# El formulario del panel no esta persistiendo la contrasena.
# Esto la escribe por la Management API, que no pasa por el
# formulario, y despues LEE la configuracion de vuelta para
# comprobar que quedo guardada.
#
# Necesitas un token personal de Supabase:
#   https://supabase.com/dashboard/account/tokens
#   -> Generate new token. Copialo, solo se muestra una vez.
# ============================================================

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$proyecto = "fzuojuoopngcqrdozvpw"

$tokSeguro = Read-Host "Token personal de Supabase (sbp_...)" -AsSecureString
$token = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
           [Runtime.InteropServices.Marshal]::SecureStringToBSTR($tokSeguro))

$pwSeguro = Read-Host "App password del buzon info@savedocumentos.com" -AsSecureString
$clave = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
           [Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwSeguro))

$cabeceras = @{ Authorization = "Bearer $token" }
$uri = "https://api.supabase.com/v1/projects/$proyecto/config/auth"

$cuerpo = @{
  external_email_enabled = $true
  smtp_host              = "smtp.hostinger.com"
  smtp_port              = "587"
  smtp_user              = "info@savedocumentos.com"
  smtp_pass              = $clave
  smtp_sender_name       = "SAVE Documentos"
  smtp_admin_email       = "info@savedocumentos.com"
  smtp_max_frequency     = 60
  site_url               = "https://savedocumentos.com"
} | ConvertTo-Json

Write-Host ""
Write-Host "=== Escribiendo la configuracion ===" -ForegroundColor Cyan
try {
    Invoke-RestMethod -Method Patch -Uri $uri -Headers $cabeceras `
        -ContentType "application/json" -Body $cuerpo | Out-Null
    Write-Host "  PATCH aceptado" -ForegroundColor Green
} catch {
    Write-Host ("  FALLO el PATCH: " + $_.Exception.Message) -ForegroundColor Red
    $r = $_.Exception.Response
    if ($r) {
        $sr = New-Object IO.StreamReader($r.GetResponseStream())
        Write-Host ("  respuesta: " + $sr.ReadToEnd()) -ForegroundColor Red
    }
    return
}

Start-Sleep -Seconds 3

Write-Host ""
Write-Host "=== Leyendo de vuelta lo que quedo guardado ===" -ForegroundColor Cyan
try {
    $cfg = Invoke-RestMethod -Method Get -Uri $uri -Headers $cabeceras
} catch {
    Write-Host ("  FALLO el GET: " + $_.Exception.Message) -ForegroundColor Red
    return
}

"smtp_host","smtp_port","smtp_user","smtp_sender_name","smtp_admin_email","smtp_max_frequency","site_url" |
  ForEach-Object { Write-Host ("  {0,-20} {1}" -f $_, $cfg.$_) }

$guardada = $cfg.smtp_pass
if ([string]::IsNullOrEmpty($guardada)) {
    Write-Host "  smtp_pass            (no se devuelve por seguridad - normal)" -ForegroundColor DarkGray
} else {
    Write-Host ("  smtp_pass            " + $guardada) -ForegroundColor DarkGray
}

Write-Host ""
if ($cfg.smtp_host -eq "smtp.hostinger.com" -and $cfg.smtp_user -eq "info@savedocumentos.com") {
    Write-Host "La configuracion quedo escrita. Prueba el registro ahora." -ForegroundColor Green
} else {
    Write-Host "Algo no cuadra: lo leido no coincide con lo enviado." -ForegroundColor Red
}

$token = $null; $clave = $null
