using BankMore.ContaCorrente.Domain.Entities;

namespace BankMore.ContaCorrente.Domain.Interfaces
{
    public interface IIdempotenciaRepository
    {
        Task<Idempotencia?> ObterPorChave(string chave);
        Task Salvar(Idempotencia idempotencia);
    }
}
