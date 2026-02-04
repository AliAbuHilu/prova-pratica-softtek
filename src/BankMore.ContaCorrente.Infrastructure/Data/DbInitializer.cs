using Dapper;
using Microsoft.Data.Sqlite;
using BCrypt.Net;

namespace BankMore.ContaCorrente.Infrastructure.Data
{
    public static class DbInitializer
    {
        public static void Initialize(string connectionString)
        {
            using var db = new SqliteConnection(connectionString);
            db.Open();

            // Criar tabelas com a coluna 'senha'
            db.Execute("CREATE TABLE IF NOT EXISTS contacorrente (idcontacorrente TEXT PRIMARY KEY, numero INTEGER, nome TEXT, ativo INTEGER, senha TEXT);");
            db.Execute("CREATE TABLE IF NOT EXISTS movimento (idmovimento TEXT PRIMARY KEY, idcontacorrente TEXT, datamovimento TEXT, tipomovimento TEXT, valor REAL);");
            db.Execute("CREATE TABLE IF NOT EXISTS idempotencia (chave_idempotencia TEXT PRIMARY KEY, requisicao TEXT, resultado TEXT);");

            var count = db.ExecuteScalar<int>("SELECT COUNT(*) FROM contacorrente");
            if (count == 0)
            {
                // CRIPTOGRAFIA: Gerando o Hash da senha "ana"
                string hash = BCrypt.Net.BCrypt.HashPassword("ana");
                
                db.Execute("INSERT INTO contacorrente VALUES ('CC-ANA-001', 1234, 'Ana BankMore', 1, @hash)", new { hash });
                db.Execute("INSERT INTO movimento VALUES ('MOV-INIT-001', 'CC-ANA-001', datetime('now'), 'C', 5000.00)");
            }
        }
    }
}
