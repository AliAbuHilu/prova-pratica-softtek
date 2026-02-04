Write-Host "
>>> TESTANDO ACESSO COM CONTA REAL: ANA (1234) <<<" -ForegroundColor Cyan

# Dados extraídos do seu banco
$payload = @{
    identificador = "1234" 
    senha = "1234"
} | ConvertTo-Json

try {
    Write-Host " Passo 1: Login... " -NoNewline
    $response = Invoke-RestMethod -Uri "http://localhost:5111/api/auth/login" -Method Post -Body $payload -ContentType "application/json"
    Write-Host "SUCESSO!" -ForegroundColor Green
    
    $token = $response.token
    $headers = @{ "Authorization" = "Bearer $token" }

    Write-Host " Passo 2: Saldo... " -NoNewline
    $saldoResult = Invoke-RestMethod -Uri "http://localhost:5111/api/contacorrente/saldo" -Method Get -Headers $headers
    Write-Host "SUCESSO!" -ForegroundColor Green

    Write-Host "
--- RESUMO DO TESTE ---" -ForegroundColor Yellow
    Write-Host "ID Conta: $($response.idContaCorrente)"
    Write-Host "Titular : $($response.usuario)"
    Write-Host "Saldo   : R$ $($saldoResult.saldo)" -ForegroundColor Green
}
catch {
    Write-Host "FALHA" -ForegroundColor Red
    $msg = $_.Exception.Message
    if ($_.Exception.Response) {
        $details = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($details)
        $msg = $reader.ReadToEnd()
    }
    Write-Host "Erro: $msg" -ForegroundColor Gray
}
