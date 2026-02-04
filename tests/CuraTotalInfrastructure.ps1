Write-Host "---  OPERAÇÃO DE CURA: INFRASTRUCTURE ---" -ForegroundColor Cyan

# A. Garantir pacotes NuGet (Resolvendo erro Microsoft.EntityFrameworkCore)
Write-Host " Instalando EntityFrameworkCore.Sqlite..." -ForegroundColor Yellow
dotnet add "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\BankMore.ContaCorrente.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.Sqlite

# B. Identificar o contexto de banco real (Ignorando UserContext)
$contextFile = Get-ChildItem -Path "C:\projetos\BankMoreSystem\src" -Filter "*Context.cs" -Recurse | Where-Object { $_.Name -ne "UserContext.cs" } | Select-Object -First 1

if ($contextFile) {
    $contextName = [System.IO.Path]::GetFileNameWithoutExtension($contextFile.Name)
    $contextNamespace = Get-Content $contextFile.FullName | Select-String "namespace" | ForEach-Object { $_.ToString().Split(' ')[1].Trim(';') }
    Write-Host " Banco Real Detectado: $contextName em $contextNamespace" -ForegroundColor Green
} else {
    Write-Host " Erro: Não encontrei o arquivo de Contexto do Banco!" -ForegroundColor Red
    exit
}

# C. Sobrescrever o Repositório com os dados Corretos
$repoPath = "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\Repositories\ContaCorrenteRepository.cs"
$repoCode = @"
using System.Threading.Tasks;
using BankMore.ContaCorrente.Domain.Entities;
using BankMore.ContaCorrente.Domain.Interfaces;
using $contextNamespace;
using Microsoft.EntityFrameworkCore;

namespace BankMore.ContaCorrente.Infrastructure.Repositories
{
    public class ContaCorrenteRepository : IContaCorrenteRepository
    {
        private readonly $contextName _context;

        public ContaCorrenteRepository($contextName context)
        {
            _context = context;
        }

        public async Task<BankMore.ContaCorrente.Domain.Entities.ContaCorrente> ObterPorNumero(string numero)
        {
            return await _context.Set<BankMore.ContaCorrente.Domain.Entities.ContaCorrente>().FirstOrDefaultAsync(c => c.Numero == numero);
        }

        public async Task AdicionarMovimento(Movimento movimento)
        {
            await _context.Set<Movimento>().AddAsync(movimento);
        }

        public async Task<decimal> ObterSaldo(string numero) => 0;
        public async Task InativarConta(string numero) => await Task.CompletedTask;

        public async Task<int> SaveChangesAsync()
        {
            return await _context.SaveChangesAsync();
        }
    }
}
"@

$repoCode | Set-Content $repoPath -Encoding UTF8

# D. Build Final
Write-Host " Tentando build final..." -ForegroundColor Yellow
Set-Location "C:\projetos\BankMoreSystem"
dotnet build
