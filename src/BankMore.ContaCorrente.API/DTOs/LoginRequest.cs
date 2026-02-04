namespace BankMore.ContaCorrente.API.DTOs
{
    public class LoginRequest
    {
        // O identificador será o número da conta (conforme seu SQL)
        public string Identificador { get; set; } = string.Empty;
        public string Senha { get; set; } = string.Empty;
    }
}
