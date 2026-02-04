$url = "http://localhost:5011/api/Movimentacao"
$payload = @{
    NumeroConta = 1234
    Valor = 100.00
    TipoMovimento = "C"
} | ConvertTo-Json

Write-Host "Enviando comando de crédito para a conta 1234 na porta 5011..." -ForegroundColor Cyan

try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $payload -ContentType "application/json"
    $logFile = "./tests/log_movimento_1522.json"
    $response | ConvertTo-Json | Out-File $logFile
    Write-Host "SUCESSO: Resposta salva em $logFile" -ForegroundColor Green
} catch {
    Write-Host "ERRO NA PORTA 5011: $(.Exception.Message)" -ForegroundColor Red
}
