# ============================================================
# SAVE Documentos - probar AUTH PLAIN y AUTH LOGIN por separado
#
# Hostinger anuncia "250-AUTH PLAIN LOGIN": admite los dos.
# Nosotros solo probamos LOGIN a mano, y funciono.
#
# Pero Supabase usa Go, y la libreria estandar de Go (net/smtp)
# prefiere PLAIN. Si la implementacion de PLAIN de Hostinger
# fuera quisquillosa con algo -por ejemplo con ciertos caracteres
# de la contrasena- veriamos exactamente lo que vemos: nosotros
# autenticamos y Supabase no.
#
# Este script prueba LOS DOS con las mismas credenciales.
# ============================================================

$usuario = "info@savedocumentos.com"
$segura  = Read-Host "Contrasena o app password ACTUAL de $usuario" -AsSecureString
$clave   = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
             [Runtime.InteropServices.Marshal]::SecureStringToBSTR($segura))

$nombre = "smtp.hostinger.com"

function Probar($puerto, $mecanismo, $usuario, $clave, $nombre) {
    Write-Host ""
    Write-Host ("=== puerto $puerto  ·  AUTH $mecanismo ===") -ForegroundColor Cyan

    $cliente = New-Object System.Net.Sockets.TcpClient
    try { $cliente.Connect($nombre, $puerto) }
    catch { Write-Host ("  no conecta: " + $_.Exception.Message) -ForegroundColor Red; return }

    $flujo = $cliente.GetStream()
    $implicito = ($puerto -eq 465)

    if ($implicito) {
        $tls = New-Object System.Net.Security.SslStream($flujo, $false)
        try { $tls.AuthenticateAsClient($nombre) }
        catch { Write-Host ("  TLS fallo: " + $_.Exception.GetBaseException().Message) -ForegroundColor Red; $cliente.Close(); return }
        $canal = $tls
    } else {
        $canal = $flujo
    }

    $lector = New-Object System.IO.StreamReader($canal, [Text.Encoding]::ASCII)
    $escrit = New-Object System.IO.StreamWriter($canal, [Text.Encoding]::ASCII)
    $escrit.AutoFlush = $true; $escrit.NewLine = "`r`n"

    function Leer($l) {
        $u = ""
        while ($true) {
            $x = $l.ReadLine()
            if ($null -eq $x) { break }
            $u = $x
            if ($x.Length -lt 4 -or $x[3] -ne '-') { break }
        }
        return $u
    }

    Leer $lector | Out-Null
    $escrit.WriteLine("EHLO savedocumentos.com"); Leer $lector | Out-Null

    if (-not $implicito) {
        $escrit.WriteLine("STARTTLS")
        $r = Leer $lector
        if ($r -notmatch "^220") { Write-Host "  STARTTLS rechazado" -ForegroundColor Red; $cliente.Close(); return }
        $tls = New-Object System.Net.Security.SslStream($flujo, $false)
        try { $tls.AuthenticateAsClient($nombre) }
        catch { Write-Host ("  TLS fallo: " + $_.Exception.GetBaseException().Message) -ForegroundColor Red; $cliente.Close(); return }
        $lector = New-Object System.IO.StreamReader($tls, [Text.Encoding]::ASCII)
        $escrit = New-Object System.IO.StreamWriter($tls, [Text.Encoding]::ASCII)
        $escrit.AutoFlush = $true; $escrit.NewLine = "`r`n"
        $escrit.WriteLine("EHLO savedocumentos.com"); Leer $lector | Out-Null
    }

    if ($mecanismo -eq "PLAIN") {
        # PLAIN manda   \0usuario\0clave   en una sola linea
        $bytes = [Text.Encoding]::UTF8.GetBytes("`0$usuario`0$clave")
        $escrit.WriteLine("AUTH PLAIN " + [Convert]::ToBase64String($bytes))
        $r = Leer $lector
    } else {
        $escrit.WriteLine("AUTH LOGIN")
        $r = Leer $lector
        if ($r -match "^334") {
            $escrit.WriteLine([Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($usuario)))
            Leer $lector | Out-Null
            $escrit.WriteLine([Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($clave)))
            $r = Leer $lector
        }
    }

    if ($r -match "^235") {
        Write-Host ("  OK    " + $r) -ForegroundColor Green
    } else {
        Write-Host ("  FALLA " + $r) -ForegroundColor Red
    }

    try { $escrit.WriteLine("QUIT") } catch {}
    $cliente.Close()
}

Probar 587 "LOGIN" $usuario $clave $nombre
Probar 587 "PLAIN" $usuario $clave $nombre
Probar 465 "LOGIN" $usuario $clave $nombre
Probar 465 "PLAIN" $usuario $clave $nombre

Write-Host ""
Write-Host "Si PLAIN falla donde LOGIN funciona, esa es la causa:" -ForegroundColor Yellow
Write-Host "Supabase usa Go, y Go prefiere PLAIN." -ForegroundColor Yellow
$clave = $null
