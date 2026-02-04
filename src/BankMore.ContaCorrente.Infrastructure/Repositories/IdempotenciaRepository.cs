using BankMore.ContaCorrente.Domain.Entities;
using BankMore.ContaCorrente.Domain.Interfaces;
using Dapper;
using Microsoft.Data.Sqlite;
using System.Data;

namespace BankMore.ContaCorrente.Infrastructure.Repositories
{
    public class IdempotenciaRepository : IIdempotenciaRepository
    {
        private readonly string _connectionString;

        public IdempotenciaRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<Idempotencia?> ObterPorChave(string chave)
        {
            using IDbConnection db = new SqliteConnection(_connectionString);
            return await db.QueryFirstOrDefaultAsync<Idempotencia>(
                "SELECT chave_idempotencia as Chave, requisicao as Requisicao, resultado as Resultado FROM idempotencia WHERE chave_idempotencia = @chave", 
                new { chave });
        }

        public async Task Salvar(Idempotencia idempotencia)
        {
            using IDbConnection db = new SqliteConnection(_connectionString);
            await db.ExecuteAsync(
                "INSERT INTO idempotencia (chave_idempotencia, requisicao, resultado) VALUES (@Chave, @Requisicao, @Resultado)", 
                idempotencia);
        }
    }
}
