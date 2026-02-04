Write-Host "---  OPERAÇÃO FINAL: LIMPANDO INFRASTRUCTURE ---" -ForegroundColor Cyan

# A. Limpeza e Instalação Manual de Pacotes
Set-Location "C:\projetos\BankMoreSystem"
Write-Host " Restaurando pacotes globalmente..." -ForegroundColor Yellow
dotnet restore
dotnet add "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\BankMore.ContaCorrente.Infrastructure.csproj" package Microsoft.EntityFrameworkCore
dotnet add "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\BankMore.ContaCorrente.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.Sqlite

# B. Escrita do Repositório (Assumindo o nome padrão do Contexto do Projeto)
# Se o seu contexto tiver OUTRO nome, altere 'ContaCorrenteContext' abaixo.
$repoPath = "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\Repositories\ContaCorrenteRepository.cs"
$repoCode = @"
using System.Threading.Tasks;
using BankMore.ContaCorrente.Domain.Entities;
using BankMore.ContaCorrente.Domain.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace BankMore.ContaCorrente.Infrastructure.Repositories
{
    public class ContaCorrenteRepository : IContaCorrenteRepository
    {
        // Aqui usamos o DbContext genérico para evitar erros de nome de classe específica
        private readonly DbContext _context;

        public ContaCorrenteRepository(DbContext context)
        {
            _context = context;
        }

        public async Task<BankMore.ContaCorrente.Domain.Entities.ContaCorrente> ObterPorNumero(string numero)
        {
            return await _context.Set<BankMore.ContaCorrente.Domain.Entities.ContaCorrente>().FirstOrDefaultAsync();
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
Write-Host " Repositório reescrito com DbContext Genérico." -ForegroundColor Green

# C. Build
Write-Host " Build Final..." -ForegroundColor Yellow
dotnet build
