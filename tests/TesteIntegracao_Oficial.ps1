$urlLogin = "http://localhost:5111/api/Auth/login"
$urlTransfer = "http://localhost:5047/transferencia"

Write-Host "
---  BANKMORE: TESTE DE INTEGRAÇÃO OFICIAL ---" -ForegroundColor Cyan

# A. AUTENTICAÇÃO
$bodyLogin = @{ numero = 1234; senha = "1234" } | ConvertTo-Json
try {
    Write-Host "[1/2] Obtendo Token JWT..." -NoNewline
    $loginResponse = Invoke-RestMethod -Uri $urlLogin -Method Post -Body $bodyLogin -ContentType "application/json"
    $token = $loginResponse.token
    Write-Host "  OK!" -ForegroundColor Green
} catch {
    Write-Host "  ERRO!" -ForegroundColor Red; exit
}

# B. TRANSFERÊNCIA AUTORIZADA
$headers = @{ Authorization = "Bearer $token" }
$payload = @{
    numeroContaOrigem = "1234"
    numeroContaDestino = "9999"
    valor = 10.00
    chaveIdempotencia = [Guid]::NewGuid().ToString()
} | ConvertTo-Json

try {
    Write-Host "[2/2] Processando Transferência..." -NoNewline
    $resp = Invoke-RestMethod -Uri $urlTransfer -Method Post -Body $payload -Headers $headers -ContentType "application/json"
    Write-Host "  SUCESSO!" -ForegroundColor Green
    Write-Host "
Resultado: $($resp.mensagem)" -ForegroundColor Gray
} catch {
    $stream = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    Write-Host "  FALHA: $($stream.ReadToEnd())" -ForegroundColor Red
}
Write-Host "-------------------------------------------
"
