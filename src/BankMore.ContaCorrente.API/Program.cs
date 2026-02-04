using Microsoft.OpenApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using BankMore.ContaCorrente.Domain.Interfaces;
using BankMore.ContaCorrente.Infrastructure.Repositories;
using BankMore.ContaCorrente.Infrastructure.Context;
using BankMore.ContaCorrente.Infrastructure.Services;

var builder = WebApplication.CreateBuilder(args);

// --- 1. CONFIGURAÇÃO DE SEGURANÇA (JWT) ---
// Deve ser idêntica à chave da API de Transferência (5047)
var chaveMestra = "SuaChaveSuperSecretaDePeloMenos32Caracteres";
var key = Encoding.ASCII.GetBytes(chaveMestra);

builder.Services.AddAuthentication(x =>
{
    x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(x =>
{
    x.RequireHttpsMetadata = false;
    x.SaveToken = true;
    x.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(key),
        ValidateIssuer = false,
        ValidateAudience = false
    };
});

// --- 2. BANCO DE DADOS ---
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") 
    ?? "Data Source=C:\\Projetos\\BankMoreSystem\\database\\contacorrente.db";

builder.Services.AddDbContext<BankMoreContext>(options => 
    options.UseSqlite(connectionString));

// --- 3. DEPENDÊNCIAS (SOLID) ---
builder.Services.AddMediatR(cfg => {
    cfg.RegisterServicesFromAssembly(typeof(BankMoreContext).Assembly);
});

// Registro dos serviços essenciais para o novo AuthController
builder.Services.AddScoped<IContaCorrenteRepository, ContaCorrenteRepository>();
builder.Services.AddScoped<IIdempotenciaRepository, IdempotenciaRepository>();
builder.Services.AddScoped<TokenService>();
builder.Services.AddScoped<CriptografiaService>(); // ADICIONADO: Necessário para o login seguro

builder.Services.AddControllers();
builder.Services.AddScoped<BankMore.ContaCorrente.Infrastructure.Business.ObterSaldoHandler>();
builder.Services.AddEndpointsApiExplorer();

// Configuração do Swagger com suporte a cadeado (JWT)
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "BankMore API v1", Version = "v1" });
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement {
        {
            new OpenApiSecurityScheme {
                Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "Bearer" }
            },
            new string[] { }
        }
    });
});

var app = builder.Build();

// --- 4. PIPELINE ---
app.UseSwagger();
app.UseSwaggerUI(c => {
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "BankMore API v1");
    c.RoutePrefix = string.Empty; 
});

app.UseAuthentication(); // ADICIONADO: Essencial para JWT
app.UseAuthorization();
app.MapControllers();

app.Run();
