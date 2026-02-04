Write-Host "---  TESTE DE PERSISTÊNCIA REAL (SQLite) ---" -ForegroundColor Cyan

if (!(Test-Path "C:\projetos\BankMoreSystem\database\contacorrente.db")) {
    Write-Host " Banco de dados não encontrado em: C:\projetos\BankMoreSystem\database\contacorrente.db" -ForegroundColor Red
    exit
}

# Criando um ID Único para o teste
$id = [Guid]::NewGuid().ToString()
$data = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host " Inserindo movimento de R$ 10,00..." -ForegroundColor Yellow

# Executando o INSERT via linha de comando do SQLite (ou simulando via script)
# Nota: Como o sistema compila, poderíamos rodar a API, mas vamos validar o banco primeiro.
try {
    # Comando para inserir diretamente no arquivo DB para validar o Schema
    sqlite3 "C:\projetos\BankMoreSystem\database\contacorrente.db" "INSERT INTO movimento (idmovimento, idcontacorrente, datamovimento, tipomovimento, valor) VALUES ('$id', '12345', '$data', 'Deposito', 10.00);"
    Write-Host " Comando executado com sucesso." -ForegroundColor Green
} catch {
    Write-Host " Erro ao acessar o SQLite. Verifique se o sqlite3 está no PATH." -ForegroundColor Red
}

Write-Host " Consultando registros na tabela 'movimento'..." -ForegroundColor Yellow
sqlite3 "C:\projetos\BankMoreSystem\database\contacorrente.db" "SELECT * FROM movimento ORDER BY datamovimento DESC LIMIT 5;"
