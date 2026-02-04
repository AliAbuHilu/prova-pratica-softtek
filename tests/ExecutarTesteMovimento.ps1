$url = "http://localhost:5000/api/Movimentacao"
$json = @{ NumeroConta = 1234; Valor = 100.0; TipoMovimento = "C" } | ConvertTo-Json
try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $json -ContentType "application/json"
    $response | Out-File "./tests/ultimo_resultado_teste.json"
    Write-Host "SUCESSO: Resposta salva em ./tests/ultimo_resultado_teste.json" -ForegroundColor Green
} catch {
    $_.Exception.Message | Out-File "./tests/erro_teste.txt"
    Write-Host "ERRO: Verifique ./tests/erro_teste.txt" -ForegroundColor Red
}
