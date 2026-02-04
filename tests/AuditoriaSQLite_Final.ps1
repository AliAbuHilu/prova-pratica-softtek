Write-Host "---  AUDITORIA DE PERSISTÊNCIA SQLITE (.NET MODE) ---" -ForegroundColor Cyan

# Localiza o arquivo de banco
$dbFile = Get-ChildItem -Path "C:\Projetos\BankMoreSystem\database" -Filter "*.db" | Select-Object -First 1

if (-not $dbFile) {
    Write-Host " Arquivo .db não encontrado em C:\Projetos\BankMoreSystem\database" -ForegroundColor Red
    exit
}

Write-Host "Arquivo detectado: $($dbFile.Name)" -ForegroundColor Yellow

# MÉTODO: Busca binária por string (Rápido e não depende de drivers instalados)
# Procuramos pelo valor '10' que enviamos na transferência
Write-Host "Verificando se o valor '10' foi persistido no arquivo..." -NoNewline

$content = Get-Content $dbFile.FullName -Raw -ErrorAction SilentlyContinue
if ($content -match "10\.00" -or $content -match "10,00") {
    Write-Host "  REGISTRO ENCONTRADO NO DISCO!" -ForegroundColor Green
    Write-Host "O valor da transferência consta dentro do arquivo $($dbFile.Name)." -ForegroundColor Gray
} else {
    Write-Host "  VALOR NÃO ENCONTRADO." -ForegroundColor Red
    Write-Host "Dica: Se a API retornou OK mas o valor não está no arquivo, a API está salvando em MEMÓRIA." -ForegroundColor Yellow
}

Write-Host "
--- FIM DA AUDITORIA ---" -ForegroundColor Cyan
