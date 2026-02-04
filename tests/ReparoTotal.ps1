Write-Host "---  INICIANDO REPARO DO SISTEMA ---" -ForegroundColor Cyan
$base = "C:\projetos\BankMoreSystem\src"

# 1. Ajuste da Entidade (Mapping do Banco)
$entCode = @"
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BankMore.ContaCorrente.Domain.Entities
{
    [Table("movimento")]
    public class Movimento
    {
        [Key] [Column("idmovimento")] public string IdMovimento { get; set; }
        [Column("idcontacorrente")] public string IdContaCorrente { get; set; }
        [Column("datamovimento")] public string DataMovimento { get; set; }
        [Column("tipomovimento")] public string TipoMovimento { get; set; }
        [Column("valor")] public double Valor { get; set; }
    }
}
"@
$entCode | Set-Content "$base\BankMore.ContaCorrente.Domain\Entities\Movimento.cs" -Encoding UTF8

# 2. Ajuste da Interface
$intCode = @"
using System.Threading.Tasks;
using BankMore.ContaCorrente.Domain.Entities;

namespace BankMore.ContaCorrente.Domain.Interfaces
{
    public interface IContaCorrenteRepository
    {
        Task<decimal> ObterSaldo(string numero);
        Task<BankMore.ContaCorrente.Domain.Entities.ContaCorrente> ObterPorNumero(string numero);
        Task AdicionarMovimento(Movimento movimento);
        Task InativarConta(string numero);
        Task<int> SaveChangesAsync(); 
    }
}
"@
$intCode | Set-Content "$base\BankMore.ContaCorrente.Domain\Interfaces\IContaCorrenteRepository.cs" -Encoding UTF8

# 3. Ajuste do Handler (Nomes de Propriedades Corretos)
$handCode = @"
using BankMore.ContaCorrente.Domain.Entities;
using BankMore.ContaCorrente.Domain.Interfaces;
using BankMore.ContaCorrente.Domain.Commands;
using MediatR;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace BankMore.ContaCorrente.Infrastructure.Business
{
    public class RegistrarMovimentoHandler : IRequestHandler<RegistrarMovimentoCommand, bool>
    {
        private readonly IContaCorrenteRepository _repository;
        public RegistrarMovimentoHandler(IContaCorrenteRepository repository) { _repository = repository; }

        public async Task<bool> Handle(RegistrarMovimentoCommand request, CancellationToken cancellationToken)
        {
            if (request.Valor <= 0) throw new Exception("INVALID_VALUE");
            
            // Usando NumeroConta (int) conforme seu arquivo Command
            var conta = await _repository.ObterPorNumero(request.NumeroConta.ToString());
            if (conta == null) throw new Exception("INVALID_ACCOUNT");

            var movimento = new Movimento {
                IdMovimento = Guid.NewGuid().ToString(),
                IdContaCorrente = conta.IdContaCorrente,
                DataMovimento = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                TipoMovimento = request.TipoMovimento,
                Valor = (double)request.Valor
            };

            await _repository.AdicionarMovimento(movimento);
            return await _repository.SaveChangesAsync() > 0;
        }
    }
}
"@
$handCode | Set-Content "$base\BankMore.ContaCorrente.Infrastructure\Business\RegistrarMovimentoHandler.cs" -Encoding UTF8

Write-Host " Arquivos atualizados. Compilando..." -ForegroundColor Green
Set-Location "C:\projetos\BankMoreSystem"
dotnet build
