using Microsoft.AspNetCore.Mvc;
using BankMore.ContaCorrente.Domain.Interfaces;
using System.Linq;

namespace BankMore.ContaCorrente.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ContaCorrenteController : ControllerBase
    {
        private readonly IContaCorrenteRepository _repository;

        public ContaCorrenteController(IContaCorrenteRepository repository)
        {
            _repository = repository;
        }

        [HttpGet("{numero}/saldo")]
        public async Task<IActionResult> ObterSaldo(string numero)
        {
            var conta = await _repository.ObterPorNumero(numero);
            if (conta == null) return NotFound(new { mensagem = "Conta nao encontrada" });

            // O sufixo M garante que o valor seja tratado como decimal
            decimal saldoCalculado = conta.Movimento?.Sum(m => (decimal)m.Valor) ?? 0.00M;

            return Ok(new { 
                titular = conta.Nome,
                numero = conta.Numero,
                saldo = saldoCalculado,
                movimentacoes = conta.Movimento?.Count ?? 0
            }); 
        }
    }
}
