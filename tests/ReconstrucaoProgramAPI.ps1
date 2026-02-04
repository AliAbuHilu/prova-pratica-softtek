Write-Host "---  RECONSTRUINDO PROGRAM.CS (TRANSFERENCIA E CONTA CORRENTE) ---" -ForegroundColor Cyan

# Função para gerar o conteúdo padrão do Program.cs
function Get-ProgramContent($namespace, $dbName) {
    return @"
using Microsoft.EntityFrameworkCore;
using BankMore.ContaCorrente.Domain.Interfaces;
using BankMore.ContaCorrente.Infrastructure.Repositories;
using BankMore.ContaCorrente.Infrastructure.Context;

var builder = WebApplication.CreateBuilder(args);

// Configuração do SQLite
builder.Services.AddDbContext<ContaCorrenteContext>(options =>
    options.UseSqlite("Data Source=C:\\projetos\\BankMoreSystem\\database\\contacorrente.db"));

// Injeção de Dependência (SOLID)
builder.Services.AddScoped<IContaCorrenteRepository, ContaCorrenteRepository>();

builder.Services.AddControllers();
var app = builder.Build();

app.MapControllers();
app.Run();
"@
}

# A. Atualizando ContaCorrente.API
$ccProgram = "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API\Program.cs"
(Get-ProgramContent "BankMore.ContaCorrente.API" "contacorrente") | Set-Content $ccProgram -Encoding UTF8
Write-Host " Program.cs da ContaCorrente.API restaurado." -ForegroundColor Green

# B. Atualizando Transferencia.API
$trProgram = "C:\projetos\BankMoreSystem\src\BankMore.Transferencia.API\Program.cs"
(Get-ProgramContent "BankMore.Transferencia.API" "contacorrente") | Set-Content $trProgram -Encoding UTF8
Write-Host " Program.cs da Transferencia.API restaurado." -ForegroundColor Green

# C. Build Final de Validação
Write-Host " Executando build de validação..." -ForegroundColor Yellow
Set-Location "C:\projetos\BankMoreSystem"
dotnet build
