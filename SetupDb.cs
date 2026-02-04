using Microsoft.Data.Sqlite;
using var connection = new SqliteConnection("Data Source=C:/projetos/BankMoreSystem/contacorrente.db");
connection.Open();
var command = connection.CreateCommand();
command.CommandText = \"CREATE TABLE IF NOT EXISTS ContaCorrente (numero TEXT PRIMARY KEY, nome TEXT, cpf TEXT, saldo DECIMAL, ativa BOOLEAN); CREATE TABLE IF NOT EXISTS Movimento (id INTEGER PRIMARY KEY AUTOINCREMENT, numeroConta TEXT, tipo TEXT, valor DECIMAL, data DATETIME); DELETE FROM ContaCorrente; INSERT INTO ContaCorrente VALUES ('12345', 'Ana Silva', '12345678901', 7000.00, 1); INSERT INTO ContaCorrente VALUES ('54321', 'Bruno Costa', '98765432100', 1000.00, 1);\";
command.ExecuteNonQuery();
System.Console.WriteLine(\" Banco de dados configurado com sucesso!\");

