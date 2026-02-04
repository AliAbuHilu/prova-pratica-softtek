using BankMore.ContaCorrente.Domain.Entities;
using BankMore.ContaCorrente.Domain.Interfaces;
using BankMore.ContaCorrente.Domain.Commands;
using MediatR;

namespace BankMore.ContaCorrente.Infrastructure.Business
{
    public class RegistrarMovimentoHandler : IRequestHandler<RegistrarMovimentoCommand, bool>
    {
        private readonly IContaCorrenteRepository _repository;

        public RegistrarMovimentoHandler(IContaCorrenteRepository repository) { _repository = repository; }

        public async Task<bool> Handle(RegistrarMovimentoCommand request, CancellationToken cancellationToken)
        {
            if (request.Valor <= 0) return false;

            var conta = await _repository.ObterPorNumero(request.NumeroConta.ToString());
            if (conta == null || string.IsNullOrEmpty(conta.IdContaCorrente)) return false;

            var movimento = new Movimento {
                IdMovimento = Guid.NewGuid().ToString(),
                IdContaCorrente = conta.IdContaCorrente,
                DataMovimento = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                TipoMovimento = request.TipoMovimento ?? "C",
                Valor = (double)request.Valor
            };

            await _repository.AdicionarMovimento(movimento);
            return await _repository.SaveChangesAsync() > 0;
        }
    }
}
