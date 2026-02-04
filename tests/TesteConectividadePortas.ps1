Write-Host "---  TESTE DE CONECTIVIDADE: PORTAS 5111 E 5047 ---" -ForegroundColor Cyan

# 1. Função para testar se a porta está ativa
function Test-Port($port) {
    $check = Test-NetConnection -ComputerName localhost -Port $port -WarningAction SilentlyContinue
    return $check.TcpTestSucceeded
}

Write-Host " Verificando se as APIs estão rodando..." -ForegroundColor Yellow

$ccStatus = Test-Port 5111
$trStatus = Test-Port 5047

if ($ccStatus) { 
    Write-Host " ContaCorrente.API detectada na porta 5111" -ForegroundColor Green 
} else { 
    Write-Host " ContaCorrente.API (5111) não está respondendo. Certifique-se de dar 'dotnet run' nela." -ForegroundColor Red 
}

if ($trStatus) { 
    Write-Host " Transferencia.API detectada na porta 5047" -ForegroundColor Green 
} else { 
    Write-Host " Transferencia.API (5047) não está respondendo." -ForegroundColor Red 
}

# 2. Se a ContaCorrente estiver ativa, tentamos um GET básico de Saúde
if ($ccStatus) {
    try {
        Write-Host " Testando endpoint de Saúde/Swagger..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri "http://localhost:5111/swagger/index.html" -Method Get -ErrorAction Stop | Out-Null
        Write-Host " Endpoint acessível!" -ForegroundColor Green
    } catch {
        Write-Host " API ativa, mas Swagger não encontrado. Isso é normal se estiver em modo Production." -ForegroundColor Gray
    }
}
