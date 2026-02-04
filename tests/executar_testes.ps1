$urlConta = "http://localhost:5111"
$urlTransf = "http://localhost:5047"

Write-Host "`n=== TESTE DE INTEGRAÇÃO BANCÁRIA ===" -ForegroundColor Cyan

try {
    # 1. LOGIN
    $loginBody = @{ numero = "1234"; senha = "senha123" } | ConvertTo-Json
    $auth = Invoke-RestMethod -Method Post -Uri "$urlConta/api/Auth/login" -Body $loginBody -ContentType "application/json"
    $token = $auth.token
    $headers = @{ Authorization = "Bearer $token" }
    Write-Host "[OK] Login realizado com sucesso." -ForegroundColor Green

    # 2. SALDO INICIAL
    Write-Host "[DEBUG] Consultando saldo inicial..." -ForegroundColor Gray
    $saldoIni = Invoke-RestMethod -Method Get -Uri "$urlConta/api/ContaCorrente/saldo" -Headers $headers
    $vSaldoIni = $saldoIni.valorSaldo
    Write-Host "[SALDO INICIAL] R$ $vSaldoIni" -ForegroundColor Yellow

    # 3. TRANSFERÊNCIA
    Write-Host "[AÇÃO] Transferindo R$ 500,00..." -ForegroundColor White
    $transfBody = @{ 
        contaOrigem = "1234"
        contaDestino = "9999"
        valor = 500.00 
    } | ConvertTo-Json

    $res = Invoke-RestMethod -Method Post -Uri "$urlTransf/api/Transferencia" -Body $transfBody -ContentType "application/json" -Headers $headers
    Write-Host "[OK] Transferência concluída no microserviço!" -ForegroundColor Green

    # 4. SALDO FINAL
    $saldoFim = Invoke-RestMethod -Method Get -Uri "$urlConta/api/ContaCorrente/saldo" -Headers $headers
    $vSaldoFim = $saldoFim.valorSaldo
    Write-Host "[SALDO FINAL] R$ $vSaldoFim" -ForegroundColor Yellow

} catch {
    Write-Host "`n--- OCORREU UM ERRO NO TESTE ---" -ForegroundColor Red
    Write-Host "Mensagem: $($_.Exception.Message)" -ForegroundColor White
}
Write-Host "`n=== FIM DO TESTE ===" -ForegroundColor Cyan
