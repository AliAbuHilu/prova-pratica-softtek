using Microsoft.AspNetCore.Authorization; // Essencial para o [Authorize]
using Microsoft.AspNetCore.Mvc;
using BankMore.Transferencia.API.Business;
using System;

namespace BankMore.Transferencia.API.Controllers;

[Authorize] // <--- ESTA LINHA BLOQUEIA O ACESSO ANÔNIMO
[ApiController]
[Route("[controller]")]public class TransferenciaController(TransferenciaService service) : ControllerBase
{
    [HttpPost]
    public async Task<IActionResult> Post([FromBody] TransferenciaRequest request)
    {
        try 
        {
            await service.Executar(
                request.NumeroContaOrigem, 
                request.NumeroContaDestino, 
                request.Valor, 
                request.ChaveIdempotencia
            );

            return Ok(new { 
                sucesso = true,
                mensagem = "Transferência realizada com sucesso!",
                data = DateTime.Now
            });
        }
        catch (ArgumentException ex)
        {
            // Erros de validação (ex: campos vazios, valor negativo)
            return BadRequest(new { erro = "Erro de Validação", detalhe = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            // Erros de regra de negócio (ex: conta não encontrada, saldo insuficiente)
            return UnprocessableEntity(new { erro = "Regra de Negócio", detalhe = ex.Message });
        }
        catch (Exception ex)
        {
            // Erros inesperados (ex: banco de dados fora do ar)
            return StatusCode(500, new { erro = "Erro Interno", detalhe = ex.Message, stackTrace = ex.StackTrace });
        }
    }
}

public class TransferenciaRequest
{
    public required string NumeroContaOrigem { get; set; }
    public required string NumeroContaDestino { get; set; }
    public decimal Valor { get; set; }
    public required string ChaveIdempotencia { get; set; }
}
