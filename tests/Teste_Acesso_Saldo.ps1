Write-Host "
>>> VALIDANDO ACESSO AO SISTEMA <<<" -ForegroundColor Cyan
$baseUrl = "http://localhost:5000/api" # Verifique se a porta da sua API é 5000 ou 5001

# Dados para o teste (Ajuste o identificador se necessário)
$payload = @{
    identificador = "123456" 
    senha = "1234"
} | ConvertTo-Json

try {
    Write-Host "1. Solicitando Token JWT... " -NoNewline
    $auth = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method Post -Body $payload -ContentType "application/json"
    Write-Host "SUCESSO" -ForegroundColor Green
    
    $token = $auth.token
    $headers = @{ "Authorization" = "Bearer $token" }

    Write-Host "2. Consultando Saldo com Token... " -NoNewline
    $saldo = Invoke-RestMethod -Uri "$baseUrl/contacorrente/saldo" -Method Get -Headers $headers
    Write-Host "SUCESSO" -ForegroundColor Green

    Write-Host "
--- DADOS DA CONTA ---" -ForegroundColor Yellow
    Write-Host "Titular: $($auth.usuario)"
    Write-Host "Saldo Atual: R$ $($saldo.saldo)" -ForegroundColor Green
}
catch {
    Write-Host "FALHA" -ForegroundColor Red
    Write-Host "Erro detalhado: $($_.Exception.Message)" -ForegroundColor Gray
}
