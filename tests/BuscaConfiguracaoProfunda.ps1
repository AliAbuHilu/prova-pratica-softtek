Write-Host "---  BUSCA PROFUNDA DE CONFIGURAÇÃO DE BANCO ---" -ForegroundColor Cyan

# Procura em todos os arquivos .cs por termos de banco de dados
$arquivos = Get-ChildItem -Path "C:\Projetos\BankMoreSystem\src" -Filter "*.cs" -Recurse

foreach ($file in $arquivos) {
    $match = Get-Content $file.FullName | Select-String "UseSqlite", "UseInMemoryDatabase", "AddDbContext"
    if ($match) {
        Write-Host "
 Encontrado em: $(.FullName)" -ForegroundColor Yellow
        $match | ForEach-Object { Write-Host "   -> $(.ToString().Trim())" -ForegroundColor White }
    }
}

Write-Host "
--- FIM DA BUSCA ---" -ForegroundColor Cyan
