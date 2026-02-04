using BankMore.ContaCorrente.Domain.Interfaces;
using System;
using System.Threading.Tasks;

namespace BankMore.ContaCorrente.Infrastructure.Business
{
    public class ObterSaldoHandler
    {
        private readonly IContaCorrenteRepository _repository;

        public ObterSaldoHandler(IContaCorrenteRepository repository)
        {
            _repository = repository;
        }

        public async Task<object> Handle(string numero)
        {
            var conta = await _repository.ObterPorNumero(numero);
            if (conta == null) throw new Exception("INVALID_ACCOUNT");
            if (conta.Ativo == 0) throw new Exception("INACTIVE_ACCOUNT");

            // CORREÇÃO: Usando IdContaCorrente em vez de numero
            var saldoTotal = await _repository.ObterSaldo(conta.IdContaCorrente);

            return new { 
                numeroContaCorrente = conta.Numero, 
                nomeTitular = conta.Nome, 
                dataHoraConsulta = DateTime.Now, 
                valorSaldo = saldoTotal 
            };
        }
    }
}
