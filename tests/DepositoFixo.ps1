Write-Host "---  EXECUTANDO DEPÓSITO NA ROTA REAL ---" -ForegroundColor Cyan

# Rota corrigida baseada no seu Controller
$url = "http://localhost:5111/api/Movimentacao/deposito"
Write-Host " URL: $url" -ForegroundColor Gray

# JSON formatado para bater com a entidade Movimento/ContaCorrente
$body = @{
    idcontacorrente = "12345" # Altere para um número de conta existente se necessário
    valor = 10.0
    tipomovimento = "Deposito"
} | ConvertTo-Json

try {
    Write-Host " Enviando R$ 10,00..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json"
    Write-Host " SUCESSO! Registro enviado para o banco." -ForegroundColor Green
    $response | ConvertTo-Json | Write-Host
} catch {
    Write-Host " Erro: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        Write-Host "Detalhes do Servidor: $($reader.ReadToEnd())" -ForegroundColor Gray
    }
}
