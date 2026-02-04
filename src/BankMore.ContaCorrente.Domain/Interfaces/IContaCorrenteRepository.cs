using System.Threading.Tasks;
using BankMore.ContaCorrente.Domain.Entities;
using ContaCorrenteEntity = BankMore.ContaCorrente.Domain.Entities.ContaCorrente;

namespace BankMore.ContaCorrente.Domain.Interfaces
{
    public interface IContaCorrenteRepository
    {
        Task<ContaCorrenteEntity?> ObterPorNumero(string numero);
        Task<ContaCorrenteEntity?> ObterPorNumeroOuCpf(string identificador);
        Task Atualizar(ContaCorrenteEntity conta);
        Task InativarConta(string numero); // Adicionado para compatibilidade
        Task<double> ObterSaldo(string idContaCorrente);
        Task AdicionarMovimento(Movimento movimento);
        Task<int> SaveChangesAsync(); // Alterado para retornar int (número de linhas afetadas)
    }
}
