using Microsoft.Data.Sqlite;
using (var conn = new SqliteConnection("Data Source=C:\projetos\BankMoreSystem\BankMore_Conta.db")) {
    conn.Open();
    using (var cmd = conn.CreateCommand()) {
        cmd.CommandText = @"DELETE FROM movimento;
DELETE FROM contacorrente;
INSERT INTO contacorrente (idcontacorrente, numero, nome, ativo, senha, salt) 
VALUES ('550e8400-e29b-41d4-a716-446655440000', 1234, 'Ana Silva', 1, 'senha123', 'salt');
INSERT INTO movimento (idmovimento, idcontacorrente, datamovimento, tipomovimento, valor) 
VALUES ('m1', '550e8400-e29b-41d4-a716-446655440000', '01/02/2026', 'C', 7000.00);
INSERT INTO contacorrente (idcontacorrente, numero, nome, ativo, senha, salt) 
VALUES ('678e8400-e29b-41d4-a716-446655441111', 9999, 'Pedro Santos', 1, 'senha123', 'salt');";
        cmd.ExecuteNonQuery();
    }
}
