using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BankMore.ContaCorrente.Domain.Entities
{
    [Table("contacorrente")]
    public class ContaCorrente
    {
        [Key]
        [Column("idcontacorrente")]
        public string IdContaCorrente { get; set; } = Guid.NewGuid().ToString();

        [Column("numero")]
        public int Numero { get; set; }

        [Column("nome")]
        public string Nome { get; set; } = string.Empty;

        [Column("ativo")]
        public int Ativo { get; set; } = 0;

        [Column("senha")]
        public string Senha { get; set; } = string.Empty;

        [Column("salt")]
        public string Salt { get; set; } = string.Empty;

        // Ajustado para 'Movimento' no singular para manter a consistência
        public virtual ICollection<Movimento> Movimento { get; set; } = new List<Movimento>();
    }
}
