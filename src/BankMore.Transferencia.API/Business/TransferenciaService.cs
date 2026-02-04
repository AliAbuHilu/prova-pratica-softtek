using BankMore.ContaCorrente.Domain.Entities;
using BankMore.ContaCorrente.Domain.Interfaces;
using Microsoft.Data.Sqlite;
using System;
using System.Threading.Tasks;

namespace BankMore.Transferencia.API.Business
{
    public class TransferenciaService
    {
        private readonly IContaCorrenteRepository _repository;
        private readonly string _connectionString = "Data Source=C:\\Projetos\\BankMoreSystem\\database\\transferencia.db";

        public TransferenciaService(IContaCorrenteRepository repository)
        {
            _repository = repository;
        }

        public async Task Executar(string origem, string destino, decimal valor, string chaveIdempotencia)
        {
            // 1. Validar se a transferência já foi processada (Idempotência)
            if (await JaProcessado(chaveIdempotencia)) return;

            // 2. Buscar contas no banco de Conta Corrente
            var contaOrigem = await _repository.ObterPorNumero(origem);
            var contaDestino = await _repository.ObterPorNumero(destino);

            if (contaOrigem == null || contaOrigem.Ativo == 0) throw new Exception("INACTIVE_ACCOUNT");
            if (contaDestino == null || contaDestino.Ativo == 0) throw new Exception("DESTINO_INACTIVE_ACCOUNT");

            // 3. Gravar no banco de Transferência (Auditoria)
            await RegistrarTransferencia(origem, destino, valor, chaveIdempotencia);

            // 4. Executar Movimentação (Débito e Crédito)
            await _repository.AdicionarMovimento(new Movimento { 
                IdMovimento = Guid.NewGuid().ToString(), 
                IdContaCorrente = contaOrigem.IdContaCorrente, 
                TipoMovimento = "D", 
                Valor = (double)valor, 
                DataMovimento = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") 
            });

            await _repository.AdicionarMovimento(new Movimento { 
                IdMovimento = Guid.NewGuid().ToString(), 
                IdContaCorrente = contaDestino.IdContaCorrente, 
                TipoMovimento = "C", 
                Valor = (double)valor, 
                DataMovimento = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") 
            });
        }

        private async Task<bool> JaProcessado(string chave)
        {
            using var conn = new SqliteConnection(_connectionString);
            await conn.OpenAsync();
            var cmd = conn.CreateCommand();
            cmd.CommandText = "SELECT COUNT(1) FROM idempotencia WHERE chave_idempotencia = @chave";
            cmd.Parameters.AddWithValue("@chave", chave);
            return Convert.ToInt32(await cmd.ExecuteScalarAsync()) > 0;
        }

        private async Task RegistrarTransferencia(string o, string d, decimal v, string chave)
        {
            using var conn = new SqliteConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = conn.CreateCommand();
            
            // Grava a transferência
            cmd.CommandText = "INSERT INTO transferencia (idtransferencia, idcontacorrente_origem, idcontacorrente_destino, datamovimento, valor) VALUES (@id, @o, @d, @dt, @v)";
            cmd.Parameters.AddWithValue("@id", Guid.NewGuid().ToString());
            cmd.Parameters.AddWithValue("@o", o);
            cmd.Parameters.AddWithValue("@d", d);
            cmd.Parameters.AddWithValue("@dt", DateTime.Now.ToString("dd/MM/yyyy"));
            cmd.Parameters.AddWithValue("@v", v);
            await cmd.ExecuteNonQueryAsync();

            // Grava a idempotência
            cmd.CommandText = "INSERT INTO idempotencia (chave_idempotencia, resultado) VALUES (@chave, 'Sucesso')";
            cmd.Parameters.AddWithValue("@chave", chave);
            await cmd.ExecuteNonQueryAsync();
        }
    }
}


