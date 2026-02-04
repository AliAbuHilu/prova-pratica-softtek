using Microsoft.AspNetCore.Mvc;
using MediatR;
using BankMore.ContaCorrente.Domain.Commands;
using Microsoft.AspNetCore.Authorization;

namespace BankMore.ContaCorrente.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize] // Mantém a segurança por padrão
    public class MovimentacaoController : ControllerBase
    {
        private readonly IMediator _mediator;

        public MovimentacaoController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [AllowAnonymous] // Permite testes sem token por enquanto, conforme seu fluxo atual
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] RegistrarMovimentoCommand command)
        {
            if (command == null)
                return BadRequest(new { mensagem = "Dados de entrada inválidos." });

            try 
            {
                // Envia o comando para o RegistrarMovimentoHandler na Infrastructure
                var sucesso = await _mediator.Send(command);

                if (sucesso)
                    return Ok(new { mensagem = "Movimentação realizada com sucesso!" });
                
                return BadRequest(new { mensagem = "Não foi possível realizar a movimentação. Verifique se a conta existe e se o valor é positivo." });
            }
            catch (Exception ex)
            {
                // Mantém o Requisito 61 de retornar o tipo da falha
                return BadRequest(new { 
                    mensagem = "Ocorreu um erro ao processar a solicitação.", 
                    detalhe = ex.Message,
                    tipo = ex.GetType().Name 
                });
            }
        }
    }
}