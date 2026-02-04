using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using BankMore.Transferencia.API.Business;
using BankMore.ContaCorrente.Domain.Interfaces;
using BankMore.ContaCorrente.Infrastructure.Repositories;
using BankMore.ContaCorrente.Infrastructure.Context;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// --- 1. CONFIGURAÇÃO DE SEGURANÇA ---
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
        ValidateAudience = false, 
        ValidateLifetime = true,
        ClockSkew = TimeSpan.Zero 
    };
});

builder.Services.AddAuthorization();

// --- 2. INFRA E BANCO ---
builder.Services.AddDbContext<BankMoreContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("ContaCorrenteDb")));

builder.Services.AddScoped<IContaCorrenteRepository, ContaCorrenteRepository>();
builder.Services.AddScoped<TransferenciaService>();

// --- 3. CORREÇÃO DO MAPEAMENTO (Onde estava o erro) ---
builder.Services.AddControllers()
    .AddApplicationPart(typeof(BankMore.Transferencia.API.Controllers.TransferenciaController).Assembly);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "BankMore Transferência API", Version = "v1" });
});

var app = builder.Build();

// --- 4. PIPELINE ---
app.UseSwagger();
app.UseSwaggerUI(c => 
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "BankMore Transferência V1");
    c.RoutePrefix = string.Empty; 
});

app.UseRouting();
app.UseAuthentication(); 
app.UseAuthorization();  

app.MapControllers();

app.Run();