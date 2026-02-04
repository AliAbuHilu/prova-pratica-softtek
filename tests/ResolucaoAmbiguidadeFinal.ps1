Write-Host "---  RESOLVENDO AMBIGUIDADE DE NOMES (SOLID FIX) ---" -ForegroundColor Cyan

$repoPath = "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\Repositories\ContaCorrenteRepository.cs"

# Reescrita com nomes completos para evitar conflito com namespaces
$repoCode = @"
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using BankMore.ContaCorrente.Domain.Entities;
using BankMore.ContaCorrente.Domain.Interfaces;
using BankMore.ContaCorrente.Infrastructure.Context;

namespace BankMore.ContaCorrente.Infrastructure.Repositories
{
    public class ContaCorrenteRepository : IContaCorrenteRepository
    {
        private readonly BankMoreContext _context;
        public ContaCorrenteRepository(BankMoreContext context) { _context = context; }

        // Usando o nome completo da classe para evitar erro CS0118
        public async Task<BankMore.ContaCorrente.Domain.Entities.ContaCorrente> ObterPorNumero(string numero) 
        {
            return await _context.Set<BankMore.ContaCorrente.Domain.Entities.ContaCorrente>()
                                 .FirstOrDefaultAsync(x => x.Numero == numero);
        }

        public async Task AdicionarMovimento(Movimento movimento) => await _context.Movimentos.AddAsync(movimento);
        public async Task<decimal> ObterSaldo(string numero) => await Task.FromResult(0m);
        public async Task InativarConta(string numero) => await Task.CompletedTask;
        public async Task<int> SaveChangesAsync() => await _context.SaveChangesAsync();
    }
}
"@

$repoCode | Set-Content $repoPath -Encoding UTF8
Write-Host " Repositório atualizado com referências explícitas." -ForegroundColor Green

# 3. Build de Validação
Write-Host " Build de validação..." -ForegroundColor Yellow
Set-Location "C:\projetos\BankMoreSystem"
dotnet build
