Write-Host "---  VALIDANDO LOGIN E GRAVAÇÃO (1234/1234) ---" -ForegroundColor Cyan

# 1. Login
$loginBody = @{ numero = "1234"; senha = "1234" } | ConvertTo-Json
try {
    $auth = Invoke-RestMethod -Uri "http://localhost:5111/api/Auth/login" -Method Post -Body $loginBody -ContentType "application/json"
    $token = $auth.token
    Write-Host " Autenticado com sucesso! Token gerado." -ForegroundColor Green
} catch {
    Write-Host " Erro no Login: $($_.Exception.Message)" -ForegroundColor Red
    return
}

# 2. Gravar Movimentação
# Nota: Se o campo no seu C# for diferente (ex: 'Valor' em vez de 'valor'), o erro será 400.
$movBody = @{ 
    numeroConta = "1234"; 
    valor = 25.00; 
    tipo = "Deposito"; 
    descricao = "Gravacao via Script Corrigido" 
} | ConvertTo-Json

try {
    $headers = @{ Authorization = "Bearer $token" }
    $result = Invoke-RestMethod -Uri "http://localhost:5111/api/Movimentacao" -Method Post -Body $movBody -ContentType "application/json" -Headers $headers
    Write-Host " SUCESSO: Movimentação gravada!" -ForegroundColor Green
    $result | ConvertTo-Json | Out-File "C:\projetos\BankMoreSystem\tests\resultado_final.json"
} catch {
    Write-Host " Erro na Gravação: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails) { Write-Host "Detalhe: $($_.ErrorDetails)" -ForegroundColor Yellow }
}
