$headers = @{
    'Authorization' = 'Bearer COLE_SEU_TOKEN_AQUI'
    'Content-Type'  = 'application/json'
}

$body = @{
    contaOrigem  = "1234"
    contaDestino = "9999"
    valor        = 100.00
} | ConvertTo-Json

Write-Host "---  INICIANDO TRANSFERÊNCIA ---" -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri 'http://localhost:5047/api/Transferencia' -Method Post -Headers $headers -Body $body
    Write-Host " SUCESSO: $($response.mensagem)" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host " ERRO NA TRANSFERÊNCIA: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "
---  CONFERINDO NOVO SALDO DA ANA ---" -ForegroundColor Gray
& "C:\projetos\BankMoreSystem\tests\teste_saldo_ana.ps1"
