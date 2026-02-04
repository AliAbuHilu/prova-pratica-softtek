namespace BankMore.ContaCorrente.Domain.Interfaces
{
    public interface ITokenService
    {
        // Usando o nome completo para evitar conflito com o namespace
        string GerarToken(BankMore.ContaCorrente.Domain.Entities.ContaCorrente conta);
    }
}
