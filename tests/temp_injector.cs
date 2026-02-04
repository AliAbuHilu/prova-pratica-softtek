using System;
using Microsoft.Data.Sqlite;

try {
    using (var connection = new SqliteConnection("Data Source=C:/projetos/BankMoreSystem/BankMore_Conta.db")) {
        connection.Open();
        var command = connection.CreateCommand();
        command.CommandText = @"
            DROP TABLE IF EXISTS movimento;
            DROP TABLE IF EXISTS contacorrente;
            CREATE TABLE contacorrente (idcontacorrente TEXT PRIMARY KEY, numero INTEGER, nome TEXT, ativo INTEGER, senha TEXT, salt TEXT);
            CREATE TABLE movimento (idmovimento TEXT PRIMARY KEY, idcontacorrente TEXT, datamovimento TEXT, tipomovimento TEXT, valor REAL);
            INSERT INTO contacorrente VALUES ('ANA-123', 1234, 'Ana Silva', 1, 'senha123', 'salt');
            INSERT INTO contacorrente VALUES ('PEDRO-999', 9999, 'Pedro Santos', 1, 'senha123', 'salt');
            INSERT INTO movimento VALUES ('M-1', 'ANA-123', '01/02/2026', 'C', 7000.00);
        ";
        command.ExecuteNonQuery();
        Console.WriteLine("--- [SUCESSO] Banco de Dados populado com Ana e Pedro! ---");
    }
} catch (Exception ex) {
    Console.WriteLine("--- [ERRO] Falha ao popular banco: " + ex.Message);
}
