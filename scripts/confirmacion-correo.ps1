# ============================================================
# SAVE Documentos - activar o desactivar la confirmacion por correo
#
#   .\confirmacion-correo.ps1 -Estado off   -> las cuentas se crean ya confirmadas
#   .\confirmacion-correo.ps1 -Estado on    -> vuelve a exigir el correo
#   .\confirmacion-correo.ps1               -> solo muestra como esta
#
# Desactivarla NO borra el SMTP: la configuracion sigue guardada
# y se retoma en cuanto vuelvas a activarla.
# ============================================================

param(
  [ValidateSet("on","off","ver")]
  [string]$Estado = "ver"
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$proyecto = "fzuojuoopngcqrdozvpw"
$tokSeguro = Read-Host "Token personal de Supabase (sbp_...)" -AsSecureString
$token = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
           [Runtime.InteropServices.Marshal]::SecureStringToBSTR($tokSeguro))

$cabeceras = @{ Authorization = "Bearer $token" }
$uri = "https://api.supabase.com/v1/projects/$proyecto/config/auth"

function MostrarEstado($cabeceras, $uri) {
    $cfg = Invoke-RestMethod -Method Get -Uri $uri -Headers $cabeceras
    Write-Host ""
    Write-Host "=== Estado actual ===" -ForegroundColor Cyan
    $cfg.PSObject.Properties |
      Where-Object { $_.Name -like "mailer*" -or $_.Name -like "*email_enabled*" -or $_.Name -eq "smtp_host" } |
      Sort-Object Name |
      ForEach-Object { Write-Host ("  {0,-34} {1}" -f $_.Name, $_.Value) }
    return $cfg
}

$antes = MostrarEstado $cabeceras $uri

if ($Estado -eq "ver") {
    Write-Host ""
    Write-Host "Solo consulta. Usa -Estado off para desactivar la confirmacion." -ForegroundColor DarkGray
    $token = $null
    return
}

# autoconfirm en true = no se exige confirmar el correo
$auto = ($Estado -eq "off")

Write-Host ""
Write-Host ("=== Poniendo mailer_autoconfirm = $auto ===") -ForegroundColor Cyan
$cuerpo = @{ mailer_autoconfirm = $auto } | ConvertTo-Json

try {
    Invoke-RestMethod -Method Patch -Uri $uri -Headers $cabeceras `
        -ContentType "application/json" -Body $cuerpo | Out-Null
    Write-Host "  PATCH aceptado" -ForegroundColor Green
} catch {
    Write-Host ("  FALLO: " + $_.Exception.Message) -ForegroundColor Red
    $r = $_.Exception.Response
    if ($r) {
        $sr = New-Object IO.StreamReader($r.GetResponseStream())
        Write-Host ("  respuesta: " + $sr.ReadToEnd()) -ForegroundColor Red
    }
    $token = $null
    return
}

Start-Sleep -Seconds 3
$despues = MostrarEstado $cabeceras $uri

Write-Host ""
if ($despues.mailer_autoconfirm -eq $auto) {
    if ($auto) {
        Write-Host "Confirmacion por correo DESACTIVADA." -ForegroundColor Green
        Write-Host "  El registro ya no intenta enviar correo. Puedes crear cuentas." -ForegroundColor Green
        Write-Host "  Acuerdate de volver a activarla: -Estado on" -ForegroundColor Yellow
    } else {
        Write-Host "Confirmacion por correo ACTIVADA de nuevo." -ForegroundColor Green
    }
} else {
    Write-Host "El valor no cambio. Revisa los permisos del token." -ForegroundColor Red
}

$token = $null
