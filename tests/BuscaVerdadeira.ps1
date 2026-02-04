Write-Host "---  ANALISANDO ROTA DETECTADA NO CÓDIGO ---" -ForegroundColor Cyan

$urlDetectada = "http://localhost:5111/"
Write-Host "Tentando a rota extraída do seu Controller: $urlDetectada" -ForegroundColor Yellow

# Tenta com HTTP e HTTPS por precaução
$urlsParaTestar = @("$urlDetectada", "https://localhost:7111/")

foreach ($url in $urlsParaTestar) {
    try {
        Write-Host "Testando $url ..." -NoNewline
        $body = @{ numero = "1234"; senha = "1234" } | ConvertTo-Json
        $res = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json" -TimeoutSec 5
        
        if ($res.token) {
            Write-Host "  SUCESSO!" -ForegroundColor Green
            Write-Host "Token: $($res.token.Substring(0, 15))..." -ForegroundColor Gray
            return
        }
    } catch {
        $status = $_.Exception.Response.StatusCode
        Write-Host "  Falhou (Status: $status)" -ForegroundColor Red
    }
}

Write-Host "
 DICA FINAL:" -ForegroundColor White -BackgroundColor Red
Write-Host "Se todas falharam, abra o seu arquivo 'LoginController.cs' e me mande"
Write-Host "apenas as primeiras 20 linhas dele. Vou matar o problema na hora."
