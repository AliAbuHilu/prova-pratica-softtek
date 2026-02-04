Write-Host "---  BUSCANDO NAMESPACE REAL DO CONTEXTO ---" -ForegroundColor Cyan

# A. Encontra o arquivo de contexto real (ignorando interfaces)
$contextFile = Get-ChildItem -Path "C:\projetos\BankMoreSystem\src" -Filter "*Context.cs" -Recurse | Where-Object { $_.Name -ne "IUserContext.cs" } | Select-Object -First 1

if ($contextFile) {
    $realNamespace = Get-Content $contextFile.FullName | Select-String "namespace" | ForEach-Object { $_.ToString().Split(' ')[1].Trim(';') }
    $contextClassName = [System.IO.Path]::GetFileNameWithoutExtension($contextFile.Name)
    Write-Host " Encontrado: $contextClassName em $realNamespace" -ForegroundColor Green
} else {
    Write-Host " Erro crítico: Arquivo Context.cs não encontrado!" -ForegroundColor Red
    exit
}

# B. Template de Program.cs Corrigido
function Update-Program($path) {
    $code = @"
using Microsoft.EntityFrameworkCore;
using BankMore.ContaCorrente.Domain.Interfaces;
using BankMore.ContaCorrente.Infrastructure.Repositories;
using $realNamespace;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<$contextClassName>(options =>
    options.UseSqlite("Data Source=C:\\projetos\\BankMoreSystem\\database\\contacorrente.db"));

builder.Services.AddScoped<IContaCorrenteRepository, ContaCorrenteRepository>();
builder.Services.AddControllers();

var app = builder.Build();
app.MapControllers();
app.Run();
"@
    $code | Set-Content $path -Encoding UTF8
}

# C. Aplicar nas APIs
Update-Program "C:\projetos\BankMoreSystem\src\BankMore.Transferencia.API\Program.cs"
Update-Program "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API\Program.cs"
Write-Host " Arquivos Program.cs atualizados com o namespace correto." -ForegroundColor Green

# D. Build
Write-Host " Build de validação..." -ForegroundColor Yellow
Set-Location "C:\projetos\BankMoreSystem"
dotnet build
