using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using BankMore.ContaCorrente.Domain.Entities;
using Microsoft.IdentityModel.Tokens;

namespace BankMore.ContaCorrente.Infrastructure.Services
{
    public class TokenService
    {
        public string GerarToken(BankMore.ContaCorrente.Domain.Entities.ContaCorrente conta)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            
            // CHAVE SINCRONIZADA COM A API DE TRANSFERÊNCIA (5047)
            var key = Encoding.ASCII.GetBytes("SuaChaveSuperSecretaDePeloMenos32Caracteres");
            
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[]
                {
                    new Claim(ClaimTypes.Name, conta.Nome ?? "Usuario"),
                    new Claim("numero", conta.Numero.ToString())
                }),
                Expires = DateTime.UtcNow.AddHours(2),
                SigningCredentials = new SigningCredentials(
                    new SymmetricSecurityKey(key), 
                    SecurityAlgorithms.HmacSha256Signature)
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);
        }
    }
}