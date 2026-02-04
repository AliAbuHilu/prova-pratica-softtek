Write-Host "=== DIAGNÓSTICO DO SISTEMA BANKMORE ===" -ForegroundColor Cyan

# 1. Verificar Arquivos de Banco
Write-Host "
[1] Verificando arquivos .db..."
$bancos = @("BankMore_Conta.db", "BankMore_Transferencia.db")
foreach ($db in $bancos) {
    if (Test-Path "C:\projetos\BankMoreSystem\$db") {
        Write-Host "   [OK] $db encontrado." -ForegroundColor Green
    } else {
        Write-Host "   [ERRO] $db NÃO ENCONTRADO!" -ForegroundColor Red
    }
}

# 2. Testar Portas das APIs
Write-Host "
[2] Verificando se as APIs estão ouvindo..."
$portas = @{ "ContaCorrente" = 5111; "Transferencia" = 5047 }
foreach ($key in $portas.Keys) {
    $p = $portas[$key]
    $check = Test-NetConnection -ComputerName localhost -Port $p -InformationLevel Quiet
    if ($check) {
        Write-Host "   [OK] API $key está online na porta $p." -ForegroundColor Green
    } else {
        Write-Host "   [ERRO] API $key está OFFLINE na porta $p!" -ForegroundColor Red
    }
}

# 3. Testar Conexão com Banco de Dados (SQLite)
Write-Host "
[3] Verificando dados dentro do banco de Contas..."
try {
    # Tenta ler a conta da Ana diretamente via SQLite
    $query = "SELECT numero, nome, senha FROM contacorrente WHERE numero = 1234;"
    # Usando o próprio dotnet para testar a conexão se possível
    Write-Host "   (Dica: Se o Teste 1 deu 401, certifique-se que o arquivo .db não está vazio)" -ForegroundColor Gray
} catch { }

# 4. Teste de Login com Erro Detalhado
Write-Host "
[4] Tentando Login (Endpoint Test)..."
try {
    $body = @{ numero = 1234; senha = "senha123" } | ConvertTo-Json
    $res = Invoke-WebRequest -Method Post -Uri "http://localhost:5111/api/Auth/login" -Body $body -ContentType "application/json" -ErrorAction Stop
    Write-Host "   [OK] Login respondeu 200 OK!" -ForegroundColor Green
} catch {
    Write-Host "   [FALHA] Status: $(_.Exception.Response.StatusCode)" -ForegroundColor Red
    $stream = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($stream)
    $text = $reader.ReadToEnd()
    Write-Host "   RESPOSTA DA API: $text" -ForegroundColor Yellow
}
Write-Host "
=== FIM DO DIAGNÓSTICO ===" -ForegroundColor Cyan
