$urlLogin = "http://localhost:5111/api/Auth/login"
# Testando a rota baseada no seu MovimentacaoController
$urlTransfer = "http://localhost:5047/api/Movimentacao" 

Write-Host "---  TESTE DE INTEGRAÇÃO (V2) ---" -ForegroundColor Cyan

# A. LOGIN
$bodyLogin = @{ numero = 1234; senha = "1234" } | ConvertTo-Json
try {
    $loginResponse = Invoke-RestMethod -Uri $urlLogin -Method Post -Body $bodyLogin -ContentType "application/json"
    $token = $loginResponse.token
    Write-Host " Login OK!" -ForegroundColor Green
} catch {
    Write-Host " Erro no Login" -ForegroundColor Red; exit
}

# B. TRANSFERÊNCIA
$headers = @{ Authorization = "Bearer $token" }
$payload = @{
    numeroContaOrigem = "1234"
    numeroContaDestino = "9999"
    valor = 10.00
    chaveIdempotencia = [Guid]::NewGuid().ToString()
} | ConvertTo-Json

try {
    Write-Host "[2/2] Tentando Transferência em $urlTransfer..." -NoNewline
    $resp = Invoke-RestMethod -Uri $urlTransfer -Method Post -Body $payload -Headers $headers -ContentType "application/json"
    Write-Host "  SUCESSO!" -ForegroundColor Green
    Write-Host "Mensagem: $($resp.mensagem)" -ForegroundColor Gray
} catch {
    $statusCode = $_.Exception.Response.StatusCode
    Write-Host "  FALHA ($statusCode)" -ForegroundColor Red
    
    # Se der 404, tenta a rota raiz (sem o /api/Movimentacao)
    if ($statusCode -eq "NotFound") {
        Write-Host " Tentando rota alternativa (raiz)..." -ForegroundColor Yellow
        try {
            $urlAlt = "http://localhost:5047/transferencia"
            $resp = Invoke-RestMethod -Uri $urlAlt -Method Post -Body $payload -Headers $headers -ContentType "application/json"
            Write-Host "  SUCESSO na rota alternativa!" -ForegroundColor Green
        } catch {
             Write-Host " Falha definitiva em todas as rotas de transferência." -ForegroundColor Red
        }
    }
}
