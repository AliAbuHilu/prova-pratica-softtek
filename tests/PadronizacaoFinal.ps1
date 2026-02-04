Write-Host "---  PADRONIZAÇÃO FINAL DE INFRAESTRUTURA E APIS ---" -ForegroundColor Cyan

# A. Criar/Sobrescrever o Contexto de Banco Real
$contextPath = "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\Context\BankMoreContext.cs"
$contextDir = [System.IO.Path]::GetDirectoryName($contextPath)
if (!(Test-Path $contextDir)) { New-Item -ItemType Directory -Path $contextDir }

$contextCode = @"
using Microsoft.EntityFrameworkCore;
using BankMore.ContaCorrente.Domain.Entities;

namespace BankMore.ContaCorrente.Infrastructure.Context
{
    public class BankMoreContext : DbContext
    {
        public BankMoreContext(DbContextOptions<BankMoreContext> options) : base(options) { }
        public DbSet<Movimento> Movimentos { get; set; }
        
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Movimento>().ToTable("movimento");
        }
    }
}
"@
$contextCode | Set-Content $contextPath -Encoding UTF8
Write-Host " BankMoreContext criado em Infrastructure." -ForegroundColor Green

# B. Atualizar o Repositório para usar o BankMoreContext
$repoPath = "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\Repositories\ContaCorrenteRepository.cs"
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

        public async Task<ContaCorrente> ObterPorNumero(string numero) => await _context.Set<ContaCorrente>().FirstOrDefaultAsync();
        public async Task AdicionarMovimento(Movimento movimento) => await _context.Movimentos.AddAsync(movimento);
        public async Task<decimal> ObterSaldo(string numero) => await Task.FromResult(0m);
        public async Task InativarConta(string numero) => await Task.CompletedTask;
        public async Task<int> SaveChangesAsync() => await _context.SaveChangesAsync();
    }
}
"@
$repoCode | Set-Content $repoPath -Encoding UTF8

# C. Atualizar Program.cs das APIs (Limpando referências a 'API' e UserContext)
function Update-Program($path) {
    $code = @"
using Microsoft.EntityFrameworkCore;
using BankMore.ContaCorrente.Domain.Interfaces;
using BankMore.ContaCorrente.Infrastructure.Repositories;
using BankMore.ContaCorrente.Infrastructure.Context;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<BankMoreContext>(options =>
    options.UseSqlite("Data Source=C:\\projetos\\BankMoreSystem\\database\\contacorrente.db"));

builder.Services.AddScoped<IContaCorrenteRepository, ContaCorrenteRepository>();
builder.Services.AddControllers();

var app = builder.Build();
app.MapControllers();
app.Run();
"@
    $code | Set-Content $path -Encoding UTF8
}

Update-Program "C:\projetos\BankMoreSystem\src\BankMore.Transferencia.API\Program.cs"
Update-Program "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API\Program.cs"

# D. Build Final
Write-Host " Build de validação..." -ForegroundColor Yellow
Set-Location "C:\projetos\BankMoreSystem"
dotnet build
