Write-Host "---  TESTANDO GRAVAÇÃO DE MOVIMENTAÇÃO ---" -ForegroundColor Cyan

# 1. Login para obter o Token
$loginBody = @{ numero = "12345"; senha = "123" } | ConvertTo-Json
try {
    $authResponse = Invoke-RestMethod -Uri "http://localhost:5111/api/Auth/login" -Method Post -Body $loginBody -ContentType "application/json"
    $token = $authResponse.token
    Write-Host " Autenticado com sucesso!" -ForegroundColor Green
} catch {
    Write-Host " Erro na Autenticação. Verifique se o usuário 12345 existe." -ForegroundColor Red
    return
}

# 2. Gravar Movimentação (Usando o Schema: RegistrarMovimentoCommand)
# Ajustei os nomes das propriedades para o padrão comum de Commands
$movBody = @{ 
    numeroConta = "12345"; 
    valor = 50.00; 
    tipo = "Credito"; 
    descricao = "Teste de Gravacao" 
} | ConvertTo-Json

try {
    $headers = @{ Authorization = "Bearer $token" }
    $result = Invoke-RestMethod -Uri "http://localhost:5111/api/Movimentacao" -Method Post -Body $movBody -ContentType "application/json" -Headers $headers
    Write-Host " SUCESSO: Movimentação gravada no banco!" -ForegroundColor Green
    $result | ConvertTo-Json | Out-File "C:\projetos\BankMoreSystem\tests\resultado_movimentacao.json"
} catch {
    Write-Host " FALHA ao gravar: $($_.Exception.Message)" -ForegroundColor Red
    $_.ErrorDetails.Message | Out-File "C:\projetos\BankMoreSystem\tests\erro_detalhado.txt"
}
