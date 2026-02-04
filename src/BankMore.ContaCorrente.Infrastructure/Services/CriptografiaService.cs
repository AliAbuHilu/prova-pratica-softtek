using System.Security.Cryptography;
using System.Text;

namespace BankMore.ContaCorrente.Infrastructure.Services
{
    public class CriptografiaService
    {
        // Verifica se a senha digitada coincide com o hash do banco (REQ 36)
        public bool VerificarSenha(string senhaDigitada, string senhaHash, string salt)
        {
            var hashDigitado = GerarHash(senhaDigitada, salt);
            return senhaHash == hashDigitado;
        }

        public string GerarHash(string senha, string salt)
        {
            using var sha256 = SHA256.Create();
            var combinedPassword = string.Concat(senha, salt);
            var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(combinedPassword));
            return Convert.ToBase64String(bytes);
        }
    }
}
