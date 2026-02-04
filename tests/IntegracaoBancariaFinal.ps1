$urlConta = "http://localhost:5111"
$urlTransf = "http://localhost:5047"

Write-Host "`n=== TESTE DE INTEGRAÇÃO BANCÁRIA ===" -ForegroundColor Cyan

try {
    # 1. LOGIN
    # Nota: Usando 'numero' conforme sua sugestão, batendo com o RegistrarMovimentoCommand
    $loginBody = @{ numero = "1234"; senha = "senha123" } | ConvertTo-Json
    Write-Host "[AÇÃO] Tentando login em $urlConta/api/Auth/login..." -ForegroundColor White
    
    $auth = Invoke-RestMethod -Method Post -Uri "$urlConta/api/Auth/login" -Body $loginBody -ContentType "application/json"
    
    # Captura flexível do token
    $token = $auth.token
    if (!$token) { $token = $auth.accessToken }
    
    $headers = @{ Authorization = "Bearer $token" }
    Write-Host "[OK] Login realizado com sucesso." -ForegroundColor Green

    # 2. SALDO INICIAL
    Write-Host "[DEBUG] Consultando saldo inicial na porta 5111..." -ForegroundColor Gray
    # Ajustado para /api/Movimentacao/saldo baseado no Raio-X que fizemos
    $saldoIni = Invoke-RestMethod -Method Get -Uri "$urlConta/api/Movimentacao/saldo" -Headers $headers
    $vSaldoIni = $saldoIni.valorSaldo
    Write-Host "[SALDO INICIAL] R$ $vSaldoIni" -ForegroundColor Yellow

    # 3. TRANSFERÊNCIA (Microserviço na porta 5047)
    Write-Host "[AÇÃO] Transferindo R$ 500,00 via porta 5047..." -ForegroundColor White
    $transfBody = @{ 
        contaOrigem = "1234"
        contaDestino = "9999"
        valor = 500.00 
    } | ConvertTo-Json

    $res = Invoke-RestMethod -Method Post -Uri "$urlTransf/api/Transferencia" -Body $transfBody -ContentType "application/json" -Headers $headers
    Write-Host "[OK] Transferência concluída no microserviço!" -ForegroundColor Green

    # 4. SALDO FINAL
    Write-Host "[DEBUG] Consultando saldo final para validar persistência..." -ForegroundColor Gray
    $saldoFim = Invoke-RestMethod -Method Get -Uri "$urlConta/api/Movimentacao/saldo" -Headers $headers
    $vSaldoFim = $saldoFim.valorSaldo
    Write-Host "[SALDO FINAL] R$ $vSaldoFim" -ForegroundColor Yellow

    # Validação lógica básica
    if ($vSaldoIni -ne $vSaldoFim) {
        Write-Host " Persistência confirmada no SQLite!" -ForegroundColor Green
    } else {
        Write-Host " O saldo não mudou. Verifique se o Commit foi realizado no banco." -ForegroundColor Yellow
    }

} catch {
    Write-Host "`n--- OCORREU UM ERRO NO TESTE ---" -ForegroundColor Red
    Write-Host "Mensagem: $($_.Exception.Message)" -ForegroundColor White
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        Write-Host "Detalhes do Servidor: $($reader.ReadToEnd())" -ForegroundColor Gray
    }
}
Write-Host "`n=== FIM DO TESTE ===" -ForegroundColor Cyan
