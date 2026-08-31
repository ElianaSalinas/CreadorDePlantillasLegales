# ============================================================
# SAVE Documentos - prueba de SMTP forzando IPv4
#
# Hipotesis: tus conexiones que funcionan salen por IPv6. Supabase
# sale por IPv4. Si Hostinger trata la IPv4 de otra forma, veriamos
# exactamente lo que vemos: tu autenticas, Supabase recibe 535, y
# ese rechazo no aparece en el log del buzon.
#
# Este script habla SMTP a mano contra la IPv4 de smtp.hostinger.com
# e imprime CADA linea que responde el servidor.
# ============================================================

$usuario = "info@savedocumentos.com"
$segura  = Read-Host "Contrasena (la del buzon o la app password)" -AsSecureString
$clave   = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
             [Runtime.InteropServices.Marshal]::SecureStringToBSTR($segura))

$nombre = "smtp.hostinger.com"
$puerto = 587

Write-Host ""
Write-Host "=== DNS de $nombre ===" -ForegroundColor Cyan
$a    = @(Resolve-DnsName $nombre -Type A    -ErrorAction SilentlyContinue | Where-Object IPAddress)
$aaaa = @(Resolve-DnsName $nombre -Type AAAA -ErrorAction SilentlyContinue | Where-Object IPAddress)
Write-Host ("  IPv4 (A):    " + (($a    | ForEach-Object IPAddress) -join ", "))
Write-Host ("  IPv6 (AAAA): " + (($aaaa | ForEach-Object IPAddress) -join ", "))

if ($a.Count -eq 0) { Write-Host "No hay registro A. Fin." -ForegroundColor Red; return }
$ip4 = $a[0].IPAddress
Write-Host ""
Write-Host "=== Conectando por IPv4 a $ip4 : $puerto ===" -ForegroundColor Cyan

$cliente = New-Object System.Net.Sockets.TcpClient
try   { $cliente.Connect($ip4, $puerto) }
catch { Write-Host ("NO CONECTA: " + $_.Exception.Message) -ForegroundColor Red; return }

$flujo  = $cliente.GetStream()
$lector = New-Object System.IO.StreamReader($flujo, [Text.Encoding]::ASCII)
$escrit = New-Object System.IO.StreamWriter($flujo, [Text.Encoding]::ASCII)
$escrit.AutoFlush = $true
$escrit.NewLine = "`r`n"

function Leer($lector) {
    $ultima = ""
    while ($true) {
        $linea = $lector.ReadLine()
        if ($null -eq $linea) { break }
        Write-Host "  S: $linea" -ForegroundColor DarkGray
        $ultima = $linea
        # una respuesta multilinea lleva guion en la 4a posicion
        if ($linea.Length -lt 4 -or $linea[3] -ne '-') { break }
    }
    return $ultima
}
function Enviar($escrit, $texto, $oculto) {
    if ($oculto) { Write-Host "  C: <oculto>" -ForegroundColor DarkCyan }
    else         { Write-Host "  C: $texto"   -ForegroundColor DarkCyan }
    $escrit.WriteLine($texto)
}

Leer $lector | Out-Null
Enviar $escrit "EHLO savedocumentos.com" $false
Leer $lector | Out-Null

Enviar $escrit "STARTTLS" $false
$r = Leer $lector
if ($r -notmatch "^220") { Write-Host "STARTTLS rechazado. Fin." -ForegroundColor Red; $cliente.Close(); return }

Write-Host ""
Write-Host "=== Levantando TLS (SNI = $nombre) ===" -ForegroundColor Cyan
$tls = New-Object System.Net.Security.SslStream($flujo, $false)
try   { $tls.AuthenticateAsClient($nombre) }
catch { Write-Host ("TLS fallo: " + $_.Exception.GetBaseException().Message) -ForegroundColor Red; $cliente.Close(); return }
Write-Host ("  TLS OK - protocolo " + $tls.SslProtocol) -ForegroundColor Green

$lector = New-Object System.IO.StreamReader($tls, [Text.Encoding]::ASCII)
$escrit = New-Object System.IO.StreamWriter($tls, [Text.Encoding]::ASCII)
$escrit.AutoFlush = $true
$escrit.NewLine = "`r`n"

Write-Host ""
Write-Host "=== Autenticando ===" -ForegroundColor Cyan
Enviar $escrit "EHLO savedocumentos.com" $false
Leer $lector | Out-Null

Enviar $escrit "AUTH LOGIN" $false
$r = Leer $lector
if ($r -notmatch "^334") { Write-Host "El servidor no ofrece AUTH LOGIN. Fin." -ForegroundColor Red; $cliente.Close(); return }

Enviar $escrit ([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($usuario))) $false
Leer $lector | Out-Null

Enviar $escrit ([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($clave))) $true
$r = Leer $lector

Write-Host ""
if ($r -match "^235") {
    Write-Host "RESULTADO: IPv4 AUTENTICA BIEN" -ForegroundColor Green
    Write-Host "  Entonces Hostinger no discrimina por IPv4. La causa es otra." -ForegroundColor Green
} else {
    Write-Host "RESULTADO: IPv4 RECHAZADA" -ForegroundColor Red
    Write-Host "  Respuesta exacta: $r" -ForegroundColor Red
    Write-Host "  Con las MISMAS credenciales que funcionan por IPv6." -ForegroundColor Red
    Write-Host "  Eso es lo que le pasa a Supabase, y es cosa de Hostinger." -ForegroundColor Red
}

Enviar $escrit "QUIT" $false
$cliente.Close()
$clave = $null
