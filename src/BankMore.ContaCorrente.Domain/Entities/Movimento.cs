using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BankMore.ContaCorrente.Domain.Entities
{
    [Table("movimento")]
    public class Movimento
    {
        [Key]
        [Column("idmovimento")]
        public string IdMovimento { get; set; } = Guid.NewGuid().ToString();

        [Column("idcontacorrente")]
        public required string IdContaCorrente { get; set; }

        [Column("datamovimento")]
        public string DataMovimento { get; set; } = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

        [Column("tipomovimento")]
        public required string TipoMovimento { get; set; }

        [Column("valor")]
        public double Valor { get; set; }

        
        [ForeignKey("IdContaCorrente")]
        public virtual ContaCorrente? ContaCorrente { get; set; }
    }
}