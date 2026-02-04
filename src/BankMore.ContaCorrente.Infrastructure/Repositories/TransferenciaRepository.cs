using Dapper;
using Microsoft.Data.Sqlite;

namespace BankMore.Transferencia.Infrastructure.Repositories
{
    public class TransferenciaRepository
    {
        private readonly string _connectionString;
        public TransferenciaRepository(string connectionString) => _connectionString = connectionString;

        public async Task SalvarTransferencia(string origemId, string destinoId, double valor)
        {
            using var db = new SqliteConnection(_connectionString);
            var sql = @"INSERT INTO transferencia 
                        (idtransferencia, idcontacorrente_origem, idcontacorrente_destino, datamovimento, valor) 
                        VALUES (@id, @origem, @destino, @data, @valor)";
            
            await db.ExecuteAsync(sql, new { 
                id = Guid.NewGuid().ToString(),
                origem = origemId,
                destino = destinoId,
                data = DateTime.Now.ToString("dd/MM/yyyy"),
                valor = valor
            });
        }
    }
}
