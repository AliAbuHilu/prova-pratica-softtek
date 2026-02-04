Write-Host "--- 🔍 LOCALIZANDO CONTEXTO E NAMESPACES ---" -ForegroundColor Cyan

# A. Descobrir o nome e namespace do DbContext
$contextFile = Get-ChildItem -Path "C:\projetos\BankMoreSystem\src" -Filter "*Context.cs" -Recurse | Select-Object -First 1

if ($contextFile) {
    $contextName = [System.IO.Path]::GetFileNameWithoutExtension($contextFile.Name)
    $contextNamespace = Get-Content $contextFile.FullName | Select-String "namespace" | ForEach-Object { $_.ToString().Split(' ')[1].Trim(';') }
    Write-Host "✅ Contexto encontrado: $contextName em $contextNamespace" -ForegroundColor Green
} else {
    Write-Host "❌ DbContext não encontrado!" -ForegroundColor Red
    exit
}

# B. Reconstruir o Repositório com os dados REAIS
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

        public async Task InativarConta(string numero) { }

        public async Task<int> SaveChangesAsync()
        {
            return await _context.SaveChangesAsync();
        }
    }
}
"@

$repoCode | Set-Content $repoPath -Encoding UTF8
Write-Host "✅ Repositório reconstruído com namespaces dinâmicos." -ForegroundColor Green

# C. Tentar Build
Write-Host "🔨 Rodando dotnet build..." -ForegroundColor Yellow
Set-Location "C:\projetos\BankMoreSystem"
dotnet build
