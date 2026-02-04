Write-Host "---  1. OBTENDO NOVO TOKEN PARA ANA ---" -ForegroundColor Cyan
$loginBody = @{
    numero = "1234"
    senha  = "valor_de_teste_abc"
} | ConvertTo-Json

try {
    $loginRes = Invoke-RestMethod -Uri 'http://localhost:5045/api/Autenticacao/login' -Method Post -Body $loginBody -ContentType "application/json"
    $token = $loginRes.token
    Write-Host " Token obtido com sucesso!" -ForegroundColor Green
} catch {
    Write-Host " Erro no Login: $($_.Exception.Message)" -ForegroundColor Red
    return
}

Write-Host "
---  2. DISPARANDO TRANSFERÊNCIA ---" -ForegroundColor Cyan
$headers = @{ 'Authorization' = "Bearer $token"; 'Content-Type' = 'application/json' }
$transBody = @{
    numeroContaOrigem  = "1234"
    numeroContaDestino = "9999"
    valor              = 100.00
    chaveIdempotencia  = [guid]::NewGuid().ToString()
} | ConvertTo-Json

try {
    $res = Invoke-RestMethod -Uri 'http://localhost:5047/Transferencia' -Method Post -Headers $headers -Body $transBody
    Write-Host " SUCESSO NA TRANSFERÊNCIA!" -ForegroundColor Green
    $res | ConvertTo-Json
} catch {
    Write-Host " ERRO 401: O token ainda não foi aceito ou a rota mudou." -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        Write-Host "Detalhe: $($reader.ReadToEnd())" -ForegroundColor Yellow
    }
}

Write-Host "
---  3. CONFERINDO SALDO FINAL ---" -ForegroundColor Gray
& "C:\projetos\BankMoreSystem\tests\teste_saldo_ana.ps1"
