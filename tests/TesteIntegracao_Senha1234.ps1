$urlLogin = "http://localhost:5111/login"
$urlTransfer = "http://localhost:5047/transferencia"

Write-Host "---  TESTE DE INTEGRAÇÃO (SENHA: 1234) ---" -ForegroundColor Cyan

# 1. LOGIN
$bodyLogin = @{ numero = "1234"; senha = "1234" } | ConvertTo-Json
try {
    $loginResponse = Invoke-RestMethod -Uri $urlLogin -Method Post -Body $bodyLogin -ContentType "application/json"
    $token = $loginResponse.token
    Write-Host " Login realizado!" -ForegroundColor Green
} catch {
    Write-Host " Erro no Login: $($_.Exception.Message)" -ForegroundColor Red; exit
}

# 2. TRANSFERÊNCIA
$headers = @{ Authorization = "Bearer $token" }
$payload = @{
    numeroContaOrigem = "1234"
    numeroContaDestino = "9999"
    valor = 10.00
    chaveIdempotencia = [Guid]::NewGuid().ToString()
} | ConvertTo-Json

try {
    $resp = Invoke-RestMethod -Uri $urlTransfer -Method Post -Body $payload -Headers $headers -ContentType "application/json"
    Write-Host " Transferência OK! Mensagem: $($resp.mensagem)" -ForegroundColor Green
} catch {
    $stream = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    Write-Host " Erro na Transferência: $($stream.ReadToEnd())" -ForegroundColor Red
}
