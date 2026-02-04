Write-Host "---  BUSCA PROFUNDA DE CONFIGURAÇÃO DE BANCO (CORRIGIDA) ---" -ForegroundColor Cyan

# Procura em todos os arquivos .cs por termos de configuração de banco
$arquivos = Get-ChildItem -Path "C:\Projetos\BankMoreSystem\src" -Filter "*.cs" -Recurse

foreach ($file in $arquivos) {
    $match = Get-Content $file.FullName | Select-String "UseSqlite", "UseInMemoryDatabase", "AddDbContext"
    if ($match) {
        Write-Host "
 Encontrado em: $(.FullName)" -ForegroundColor Yellow
        $match | ForEach-Object { 
            # Usando $_.Line para pegar o texto da linha encontrada
            Write-Host "   -> $($_.Line.Trim())" -ForegroundColor White 
        }
    }
}

Write-Host "
--- FIM DA BUSCA ---" -ForegroundColor Cyan
