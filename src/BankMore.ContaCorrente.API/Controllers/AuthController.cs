using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using BankMore.ContaCorrente.Domain.Interfaces;
using BankMore.ContaCorrente.Infrastructure.Services;
using BankMore.ContaCorrente.API.DTOs;

namespace BankMore.ContaCorrente.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IContaCorrenteRepository _repository;
        private readonly TokenService _tokenService;

        public AuthController(IContaCorrenteRepository repository, TokenService tokenService)
        {
            _repository = repository;
            _tokenService = tokenService;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            // Busca a conta de forma limpa pelo repositório
            var conta = await _repository.ObterPorNumero(request.Identificador);

            // Validação Única e Segura usando BCrypt
            if (conta == null || !BCrypt.Net.BCrypt.Verify(request.Senha, conta.Senha))
                return Unauthorized(new { message = "Usuário ou senha inválidos" });

            if (conta.Ativo == 0)
                return BadRequest(new { message = "Esta conta está inativa." });

            var token = _tokenService.GerarToken(conta);

            return Ok(new { 
                token = token,
                usuario = conta.Nome,
                idContaCorrente = conta.IdContaCorrente 
            });
        }
    }
}