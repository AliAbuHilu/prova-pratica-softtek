Write-Host "
>>> INICIANDO TESTE NA PORTA 5111 <<<" -ForegroundColor Cyan
$uriLogin = "http://localhost:5111/api/auth/login"
$uriSaldo = "http://localhost:5111/api/contacorrente/saldo"

$body = @{
    identificador = "123456" 
    senha = "1234"
} | ConvertTo-Json

try {
    Write-Host " Passo 1: Autenticando... " -NoNewline
    $response = Invoke-RestMethod -Uri $uriLogin -Method Post -Body $body -ContentType "application/json"
    Write-Host "OK!" -ForegroundColor Green
    
    $token = $response.token
    $headers = @{ "Authorization" = "Bearer $token" }

    Write-Host " Passo 2: Consultando Saldo... " -NoNewline
    $saldoResult = Invoke-RestMethod -Uri $uriSaldo -Method Get -Headers $headers
    Write-Host "OK!" -ForegroundColor Green

    Write-Host "
--- DADOS RECEBIDOS ---" -ForegroundColor Yellow
    Write-Host "Usuário: $($response.usuario)"
    Write-Host "Saldo: R$ $($saldoResult.saldo)" -ForegroundColor Green
}
catch {
    Write-Host "FALHA" -ForegroundColor Red
    Write-Host "Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Gray
    Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Gray
}
