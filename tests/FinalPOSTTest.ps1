Write-Host "---  EXECUTANDO DEPÓSITO DE TESTE (R$ 10,00) ---" -ForegroundColor Cyan

$url = "http://localhost:5111/api/movimentacao/deposito" # Ajuste o path se o seu controller for diferente
$body = @{
    idcontacorrente = "12345"
    valor = 10.0
    tipomovimento = "Deposito"
    datamovimento = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
} | ConvertTo-Json

try {
    Write-Host " Enviando dados para ContaCorrente.API (Porta 5111)..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json"
    Write-Host " Sucesso! Resposta recebida." -ForegroundColor Green
    $response | ConvertTo-Json | Write-Host
} catch {
    Write-Host " Erro na chamada: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Dica: Verifique no terminal da API se o endpoint é realmente /api/movimentacao/deposito" -ForegroundColor Gray
}
