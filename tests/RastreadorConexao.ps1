Write-Host "---  INVESTIGANDO PORTAS 5111 E 5047 ---" -ForegroundColor Cyan

$portas = @(5111, 5047)

foreach ($porta in $portas) {
    Write-Host "Testando Porta $porta..." -NoNewline
    try {
        $connection = Test-NetConnection -ComputerName localhost -Port $porta -InformationLevel Quiet
        if ($connection) {
            Write-Host "  ABERTA (Ouvindo)" -ForegroundColor Green
            
            # Se a porta está aberta, vamos tentar um GET simples para ver se é HTTP
            try {
                $web = Invoke-WebRequest -Uri "http://localhost:$porta" -Method Get -TimeoutSec 2 -ErrorAction SilentlyContinue
                Write-Host "   -> Resposta HTTP Recebida!" -ForegroundColor Gray
            } catch {
                Write-Host "   -> Porta aberta, mas não respondeu GET (Normal para APIs)" -ForegroundColor Gray
            }
        } else {
            Write-Host "  FECHADA (API não está rodando ou Firewall bloqueando)" -ForegroundColor Red
        }
    } catch {
        Write-Host "  ERRO AO TESTAR: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "
--- DICA CLEAN CODE ---" -ForegroundColor Yellow
Write-Host "Se a porta aparecer como FECHADA, verifique se no terminal da API"
Write-Host "aparece 'Now listening on: http://localhost:5111'."
