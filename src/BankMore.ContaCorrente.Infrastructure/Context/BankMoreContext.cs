using Microsoft.EntityFrameworkCore;
using BankMore.ContaCorrente.Domain.Entities;

namespace BankMore.ContaCorrente.Infrastructure.Context
{
    public class BankMoreContext : DbContext
    {
        public BankMoreContext(DbContextOptions<BankMoreContext> options) : base(options) { }

        // Mapeando a classe 'ContaCorrente' (Alias preventivo no Repositório lida com o conflito de nome)
        public DbSet<BankMore.ContaCorrente.Domain.Entities.ContaCorrente> ContaCorrente { get; set; }

        // CORREÇÃO: Usando a classe 'Movimento' que localizamos
        public DbSet<Movimento> MOVIMENTACAO { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Caso sua tabela no SQLite tenha nome diferente da classe, o atributo [Table] na entidade resolve,
            // mas aqui garantimos a configuração via Fluent API se necessário.
            base.OnModelCreating(modelBuilder);
        }
    }
}
