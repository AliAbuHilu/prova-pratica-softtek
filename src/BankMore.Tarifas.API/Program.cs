using BankMore.Transferencia.API.Business; // Certifique-se que o namespace está correto

var builder = WebApplication.CreateBuilder(args);

// 1. Adiciona suporte aos Controllers (essencial para Web API)
builder.Services.AddControllers();

// 2. Registro do Serviço (Resolve o erro 'Unable to resolve service')
// Seguindo SOLID, registramos para que o Controller possa recebê-lo via construtor
builder.Services.AddScoped<TransferenciaService>();

// 3. Configuração do HttpClient para falar com a Conta Corrente
// Isso permite que o Service consuma a URL que colocamos no appsettings.json
builder.Services.AddHttpClient<TransferenciaService>(client =>
{
    var url = builder.Configuration["ServiceSettings:ContaCorrenteUrl"] ?? "http://localhost:5111";
    client.BaseAddress = new Uri(url);
});

builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    // Ativa o Swagger se estiver usando o pacote padrão
    app.UseSwaggerUI(options => options.SwaggerEndpoint("/openapi/v1.json", "v1"));
}

// 4. Mapeia os controllers para as rotas
app.MapControllers();

app.Run();