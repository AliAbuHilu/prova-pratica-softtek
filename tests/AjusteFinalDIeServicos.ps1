Write-Host "---  CORRIGINDO DI E PROPRIEDADES DE SERVIÇO ---" -ForegroundColor Cyan

# A. Corrigindo TransferenciaService.cs (Propriedade Tipo -> TipoMovimento)
$servicePath = "C:\projetos\BankMoreSystem\src\BankMore.Transferencia.API\Business\TransferenciaService.cs"
if (Test-Path $servicePath) {
    $content = Get-Content $servicePath -Raw
    $content = $content -replace 'Tipo\s*=', 'TipoMovimento ='
    $content | Set-Content $servicePath -Encoding UTF8
    Write-Host " Propriedades em TransferenciaService corrigidas." -ForegroundColor Green
}

# B. Corrigindo Program.cs (Removendo Injeção Manual de String)
# Buscamos por padrões onde o Repositório é registrado passando string no construtor
$programs = @(
    "C:\projetos\BankMoreSystem\src\BankMore.Transferencia.API\Program.cs",
    "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API\Program.cs"
)

foreach ($path in $programs) {
    if (Test-Path $path) {
        $content = Get-Content $path -Raw
        # Remove a passagem manual de string/contexto no AddScoped do repositório
        # Transforma: AddScoped<IRepositorio, Repositorio>("string") em AddScoped<IRepositorio, Repositorio>()
        $content = $content -replace 'AddScoped<IContaCorrenteRepository,\s*ContaCorrenteRepository>\s*\([^)]+\)', 'AddScoped<IContaCorrenteRepository, ContaCorrenteRepository>()'
        $content | Set-Content $path -Encoding UTF8
        Write-Host " DI em $($path.Split('\')[-2]) corrigida." -ForegroundColor Green
    }
}

# 3. Build de Verificação
Write-Host " Executando build final..." -ForegroundColor Yellow
Set-Location "C:\projetos\BankMoreSystem"
dotnet build
