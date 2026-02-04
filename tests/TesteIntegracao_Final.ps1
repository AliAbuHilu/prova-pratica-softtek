$urlLogin = "http://localhost:5111/api/Auth/login"
$urlTransfer = "http://localhost:5047/api/Movimentacao"

Write-Host "---  TESTE DE INTEGRAÇÃO (ROTAS REAIS DETECTADAS) ---" -ForegroundColor Cyan

# A. LOGIN (AuthController)
$bodyLogin = @{ numero = 1234; senha = "1234" } | ConvertTo-Json
try {
    Write-Host "[1/2] Autenticando em $urlLogin..." -NoNewline
    $loginResponse = Invoke-RestMethod -Uri $urlLogin -Method Post -Body $bodyLogin -ContentType "application/json"
    $token = $loginResponse.token
    Write-Host "  OK!" -ForegroundColor Green
} catch {
    Write-Host "  ERRO!" -ForegroundColor Red
    $msg = $_.Exception.Message
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $msg = $reader.ReadToEnd()
    }
    Write-Host "Detalhe: $msg" -ForegroundColor Yellow; exit
}

# B. TRANSFERÊNCIA (MovimentacaoController)
$headers = @{ Authorization = "Bearer $token" }
$payload = @{
    numeroContaOrigem = "1234"
    numeroContaDestino = "9999"
    valor = 10.00
    chaveIdempotencia = [Guid]::NewGuid().ToString()
} | ConvertTo-Json

try {
    Write-Host "[2/2] Transferindo em $urlTransfer..." -NoNewline
    $resp = Invoke-RestMethod -Uri $urlTransfer -Method Post -Body $payload -Headers $headers -ContentType "application/json"
    Write-Host "  OK!" -ForegroundColor Green
    Write-Host "Mensagem: $($resp.mensagem)" -ForegroundColor Gray
} catch {
    $stream = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    Write-Host "  FALHA: $($stream.ReadToEnd())" -ForegroundColor Red
}
