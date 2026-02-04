using BankMore.ContaCorrente.Domain.Interfaces;
using BankMore.ContaCorrente.Domain.Entities;
using System.Text.Json;

namespace BankMore.ContaCorrente.API.Middleware
{
    public class IdempotencyMiddleware
    {
        private readonly RequestDelegate _next;

        public IdempotencyMiddleware(RequestDelegate next) => _next = next;

        public async Task Invoke(HttpContext context, IIdempotenciaRepository repository)
        {
            if (context.Request.Method == "POST" && context.Request.Headers.TryGetValue("X-Idempotency-Key", out var key))
            {
                var registro = await repository.ObterPorChave(key);
                if (registro != null)
                {
                    context.Response.StatusCode = 200;
                    context.Response.ContentType = "application/json";
                    await context.Response.WriteAsync(registro.Resultado);
                    return;
                }
            }
            await _next(context);
        }
    }
}
