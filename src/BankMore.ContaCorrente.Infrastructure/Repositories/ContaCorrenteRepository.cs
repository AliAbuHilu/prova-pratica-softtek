using System.Threading.Tasks;
using System.Linq;
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

        public async Task<BankMore.ContaCorrente.Domain.Entities.ContaCorrente?> ObterPorNumero(string numero) 
        {
            if (!int.TryParse(numero, out int numInt)) return null;
            return await _context.ContaCorrente.FirstOrDefaultAsync(c => c.Numero == numInt);
        }

        public async Task<BankMore.ContaCorrente.Domain.Entities.ContaCorrente?> ObterPorNumeroOuCpf(string identificador)
        {
            // Como sua tabela NÃO tem CPF, buscamos apenas por Número conforme seu CREATE TABLE
            if (!int.TryParse(identificador, out int numInt)) return null;
            return await _context.ContaCorrente.FirstOrDefaultAsync(c => c.Numero == numInt);
        }

        public async Task Atualizar(BankMore.ContaCorrente.Domain.Entities.ContaCorrente conta) {
            _context.Entry(conta).State = EntityState.Modified;
            await SaveChangesAsync();
        }

		public async Task<double> ObterSaldo(string idContaCorrente) 
		{
			// 1. Limpamos o ID que chega (Remover espaços)
			var idLimpo = idContaCorrente?.Trim();

			return await _context.MOVIMENTACAO
				.Where(m => m.IdContaCorrente.Trim() == idLimpo)
				.SumAsync(m => m.TipoMovimento.Trim().ToUpper() == "C" 
					? m.Valor 
					: -m.Valor);
		}

        public async Task AdicionarMovimento(Movimento movimento) => await _context.MOVIMENTACAO.AddAsync(movimento);
        public async Task<int> SaveChangesAsync() => await _context.SaveChangesAsync();
        public async Task InativarConta(string numero) { /* Lógica de ativo = 0 */ }
    }
}
