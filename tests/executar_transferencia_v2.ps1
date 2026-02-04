$headers = @{
    'Authorization' = 'Bearer COLE_SEU_TOKEN_AQUI'
    'Content-Type'  = 'application/json'
}

$body = @{
    numeroContaOrigem  = "1234"
    numeroContaDestino = "9999"
    valor              = 100.00
    chaveIdempotencia  = "3e79e8ab-b773-4a25-b33a-05ce411da57d"
} | ConvertTo-Json

Write-Host "---  DISPARANDO TRANSFERÊNCIA (ANA -> BETO) ---" -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri 'http://localhost:5047/Transferencia' -Method Post -Headers $headers -Body $body
    Write-Host " SUCESSO!" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host " ERRO: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        Write-Host "Detalhes do Erro: $errorBody" -ForegroundColor Yellow
    }
}

Write-Host "
---  VALIDANDO SALDO FINAL DA ANA ---" -ForegroundColor Gray
& "C:\projetos\BankMoreSystem\tests\teste_saldo_ana.ps1"
