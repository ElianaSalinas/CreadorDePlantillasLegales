# ============================================================
# SAVE Documentos - plantillas de correo en espanol
#
# Escribe asuntos y cuerpos por la Management API, y los lee de
# vuelta para comprobar que quedaron. Manda TODOS los campos de
# una vez: un PATCH parcial en esta API borra en vez de
# actualizar, ya nos paso con smtp_pass.
#
# Los enlaces usan {{ .ConfirmationURL }}, que construye Supabase.
# Antes los armabamos a mano con {{ .TokenHash }} y eso dependia de
# que el cliente de correo decodificara bien el &amp; del href.
# Con ConfirmationURL, Supabase verifica en su servidor y manda al
# usuario a /auth/confirm con un codigo. La ruta acepta las dos
# formas, asi que los correos viejos que sigan en un buzon tambien
# funcionan.
# ============================================================

param(
  # PropioDominio  el enlace va a savedocumentos.com/auth/confirm?token_hash=...
  #                El usuario solo toca tu dominio; quien habla con Supabase
  #                es tu servidor. Es lo recomendable aqui: hay proveedores
  #                dominicanos que no resuelven *.supabase.co.
  # Supabase       el enlace va a supabase.co/auth/v1/verify y de ahi rebota.
  #                Mas estandar, pero obliga al navegador del usuario a
  #                resolver supabase.co.
  [ValidateSet("PropioDominio","Supabase")]
  [string]$Enlace = "PropioDominio"
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$proyecto = "fzuojuoopngcqrdozvpw"
$tokSeguro = Read-Host "Token personal de Supabase (sbp_...)" -AsSecureString
$token = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
           [Runtime.InteropServices.Marshal]::SecureStringToBSTR($tokSeguro))

$cabeceras = @{ Authorization = "Bearer $token" }
$uri = "https://api.supabase.com/v1/projects/$proyecto/config/auth"

$pie = @"
<p style="color:#6b7280;font-size:13px;margin-top:28px">
SAVE Documentos &middot; SA&amp;VE Comercial, S.R.L. &middot; Punta Cana, Rep&uacute;blica Dominicana
</p>
"@

$hrefConfirmar = if ($Enlace -eq "PropioDominio") {
  '{{ .SiteURL }}/auth/confirm?token_hash={{ .TokenHash }}&amp;type=signup'
} else { '{{ .ConfirmationURL }}' }

$hrefRecuperar = if ($Enlace -eq "PropioDominio") {
  '{{ .SiteURL }}/auth/confirm?token_hash={{ .TokenHash }}&amp;type=recovery'
} else { '{{ .ConfirmationURL }}' }

# La invitacion lleva ademas next=/definir-password: es donde la persona
# elige su contrasena. La membresia en el despacho ya se la dio el trigger
# al crearse la cuenta, asi que ahi solo falta eso.
$hrefInvitar = if ($Enlace -eq "PropioDominio") {
  '{{ .SiteURL }}/auth/confirm?token_hash={{ .TokenHash }}&amp;type=invite&amp;next=/definir-password'
} else { '{{ .ConfirmationURL }}' }

Write-Host ""
Write-Host ("Modo de enlace: $Enlace") -ForegroundColor Cyan
if ($Enlace -eq "PropioDominio") {
  Write-Host "  Los enlaces apuntaran a savedocumentos.com" -ForegroundColor DarkGray
} else {
  Write-Host "  Los enlaces pasaran por supabase.co" -ForegroundColor DarkGray
}

$confirmacion = @"
<h2>Confirma tu cuenta en SAVE Documentos</h2>
<p>Ya casi est&aacute;. Haz clic para verificar tu correo y entrar:</p>
<p><a href="$hrefConfirmar"
   style="display:inline-block;background:#059669;color:#ffffff;padding:11px 22px;border-radius:6px;text-decoration:none;font-weight:600">Verificar mi cuenta</a></p>
<p style="color:#6b7280;font-size:13px">Si no creaste esta cuenta, ignora este mensaje.</p>
$pie
"@

$recuperacion = @"
<h2>Restablece tu contrase&ntilde;a</h2>
<p>Haz clic para elegir una nueva contrase&ntilde;a:</p>
<p><a href="$hrefRecuperar"
   style="display:inline-block;background:#059669;color:#ffffff;padding:11px 22px;border-radius:6px;text-decoration:none;font-weight:600">Cambiar mi contrase&ntilde;a</a></p>
<p style="color:#6b7280;font-size:13px">Si no lo pediste t&uacute;, ignora este mensaje: tu contrase&ntilde;a no cambiar&aacute;.</p>
$pie
"@

$invitacion = @"
<h2>Te han invitado a un despacho en SAVE Documentos</h2>
<p>Haz clic para elegir tu contrase&ntilde;a y entrar. Tu cuenta es tuya:
si alg&uacute;n d&iacute;a sales del despacho, la conservas.</p>
<p><a href="$hrefInvitar"
   style="display:inline-block;background:#059669;color:#ffffff;padding:11px 22px;border-radius:6px;text-decoration:none;font-weight:600">Aceptar la invitaci&oacute;n</a></p>
<p style="color:#6b7280;font-size:13px">Si no esperabas esta invitaci&oacute;n, ignora este mensaje.</p>
$pie
"@

$enlaceMagico = @"
<h2>Tu enlace de acceso</h2>
<p>Haz clic para entrar. El enlace caduca pronto y solo sirve una vez.</p>
<p><a href="{{ .ConfirmationURL }}"
   style="display:inline-block;background:#059669;color:#ffffff;padding:11px 22px;border-radius:6px;text-decoration:none;font-weight:600">Entrar</a></p>
$pie
"@

$cambioCorreo = @"
<h2>Confirma tu nuevo correo</h2>
<p>Haz clic para confirmar {{ .NewEmail }} como tu nueva direcci&oacute;n.</p>
<p><a href="{{ .ConfirmationURL }}"
   style="display:inline-block;background:#059669;color:#ffffff;padding:11px 22px;border-radius:6px;text-decoration:none;font-weight:600">Confirmar el nuevo correo</a></p>
<p style="color:#6b7280;font-size:13px">Si no pediste este cambio, ignora este mensaje.</p>
$pie
"@

$cuerpo = @{
  mailer_subjects_confirmation   = "Confirma tu cuenta en SAVE Documentos"
  mailer_subjects_recovery       = "Restablece tu contrasena de SAVE Documentos"
  mailer_subjects_invite         = "Te han invitado a un despacho en SAVE Documentos"
  mailer_subjects_magic_link     = "Tu enlace de acceso a SAVE Documentos"
  mailer_subjects_email_change   = "Confirma tu nuevo correo en SAVE Documentos"

  mailer_templates_confirmation_content = $confirmacion
  mailer_templates_recovery_content     = $recuperacion
  mailer_templates_invite_content       = $invitacion
  mailer_templates_magic_link_content   = $enlaceMagico
  mailer_templates_email_change_content = $cambioCorreo
} | ConvertTo-Json -Depth 4

Write-Host ""
Write-Host "=== Escribiendo plantillas y asuntos ===" -ForegroundColor Cyan
try {
    Invoke-RestMethod -Method Patch -Uri $uri -Headers $cabeceras `
        -ContentType "application/json; charset=utf-8" -Body ([Text.Encoding]::UTF8.GetBytes($cuerpo)) | Out-Null
    Write-Host "  PATCH aceptado" -ForegroundColor Green
} catch {
    Write-Host ("  FALLO: " + $_.Exception.Message) -ForegroundColor Red
    $r = $_.Exception.Response
    if ($r) { $sr = New-Object IO.StreamReader($r.GetResponseStream()); Write-Host ("  " + $sr.ReadToEnd()) -ForegroundColor Red }
    $token = $null; return
}

Start-Sleep -Seconds 3

Write-Host ""
Write-Host "=== Leyendo de vuelta ===" -ForegroundColor Cyan
$cfg = Invoke-RestMethod -Method Get -Uri $uri -Headers $cabeceras

"mailer_subjects_confirmation","mailer_subjects_recovery","mailer_subjects_invite" |
  ForEach-Object { Write-Host ("  {0,-32} {1}" -f $_, $cfg.$_) }

Write-Host ""
$ok = $true
foreach ($par in @(
    @("confirmacion", $cfg.mailer_templates_confirmation_content),
    @("recuperacion", $cfg.mailer_templates_recovery_content),
    @("invitacion",   $cfg.mailer_templates_invite_content))) {
  $esperado = if ($Enlace -eq "PropioDominio") { "auth/confirm" } else { "ConfirmationURL" }
  if ($par[1] -like "*$esperado*" -and $par[1] -like "*SAVE Documentos*") {
    Write-Host ("  {0,-14} en espanol, enlace via $esperado" -f $par[0]) -ForegroundColor Green
  } else {
    Write-Host ("  {0,-14} NO quedo bien" -f $par[0]) -ForegroundColor Red
    $ok = $false
  }
}

Write-Host ""
if ($ok) {
  Write-Host "Listo. Registra otra cuenta y el correo debe llegar en espanol." -ForegroundColor Green
} else {
  Write-Host "Algo no cuajo. Pasale la salida a Claude." -ForegroundColor Yellow
}
$token = $null
