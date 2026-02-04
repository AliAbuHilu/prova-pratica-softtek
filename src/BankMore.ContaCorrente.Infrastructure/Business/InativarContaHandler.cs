using BankMore.ContaCorrente.Domain.Interfaces;

namespace BankMore.ContaCorrente.Infrastructure.Business
{
    public class InativarContaHandler
    {
        private readonly IContaCorrenteRepository _repo;
        public InativarContaHandler(IContaCorrenteRepository repo) => _repo = repo;

        public async Task Handle(int numero)
        {
            // Adicionado .ToString() para compatibilidade com a Interface
            await _repo.InativarConta(numero.ToString());
        }
    }
}
