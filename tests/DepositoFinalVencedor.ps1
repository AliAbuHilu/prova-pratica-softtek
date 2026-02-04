Write-Host "---  EXECUTANDO DEPÓSITO NO ENDPOINT CORRETO ---" -ForegroundColor Cyan

# A rota é o nome do Controller, sem o sufixo /deposito
$url = "http://localhost:5111/api/Movimentacao" 

# JSON baseado no RegistrarMovimentoCommand
$body = @{
    idcontacorrente = "12345"
    valor = 10.0
    tipomovimento = "Deposito"
} | ConvertTo-Json

try {
    Write-Host " Enviando POST para $url..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json"
    Write-Host " SUCESSO TOTAL! O comando foi processado." -ForegroundColor Green
    $response | ConvertTo-Json | Write-Host
} catch {
    # Se der 404, tentamos sem o prefixo /api
    try {
        $altUrl = "http://localhost:5111/Movimentacao"
        Write-Host " 404 na primeira tentativa. Tentando rota alternativa: $altUrl" -ForegroundColor Gray
        $response = Invoke-RestMethod -Uri $altUrl -Method Post -Body $body -ContentType "application/json"
        Write-Host " SUCESSO na rota alternativa!" -ForegroundColor Green
        $response | ConvertTo-Json | Write-Host
    } catch {
        Write-Host " Erro persistente: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            Write-Host "Detalhes do Erro: $($reader.ReadToEnd())" -ForegroundColor Gray
        }
    }
}
