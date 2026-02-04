Write-Host "---  INICIANDO TESTE DE INTEGRAÇÃO BANKMORE ---" -ForegroundColor Cyan

$baseUrl = "http://localhost:5000/api" # Ajuste a porta se necessário
$loginData = @{
    identificador = "123456" # Substitua por um número de conta real no seu SQLite
    senha = "1234"
} | ConvertTo-Json

try {
    Write-Host " Tentando Login..." -NoNewline
    $loginResponse = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method Post -Body $loginData -ContentType "application/json"
    Write-Host " OK!" -ForegroundColor Green
    
    $token = $loginResponse.token
    $headers = @{ Authorization = "Bearer $token" }

    Write-Host " Consultando Saldo..." -NoNewline
    $saldoResponse = Invoke-RestMethod -Uri "$baseUrl/contacorrente/saldo" -Method Get -Headers $headers
    Write-Host " OK!" -ForegroundColor Green
    
    Write-Host "
--- RESULTADOS ---" -ForegroundColor Yellow
    Write-Host "Usuário: $($loginResponse.usuario)"
    Write-Host "Saldo Atual: R$ $($saldoResponse.saldo)" -ForegroundColor Green

} catch {
    Write-Host "  FALHA" -ForegroundColor Red
    Write-Host "$($_.Exception.Message)" -ForegroundColor Gray
}
