using Microsoft.AspNetCore.Mvc;
using BankMore.ContaCorrente.Infrastructure.Business;
using System.Threading.Tasks;

namespace BankMore.ContaCorrente.API.Controllers
{
    [ApiController]
    [Route("api/ContaCorrente")]
    public class ContaController : ControllerBase
    {
        private readonly ObterSaldoHandler _handler;
        public ContaController(ObterSaldoHandler handler) => _handler = handler;

        [HttpGet("saldo")]
        public async Task<IActionResult> ObterSaldo()
        {
            var resultado = await _handler.Handle("1234");
            // Retorna um objeto que o PowerShell consegue ler como .saldo
            return Ok(resultado); 
        }
    }
}
