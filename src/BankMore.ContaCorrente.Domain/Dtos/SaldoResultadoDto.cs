using System;

namespace BankMore.ContaCorrente.Domain.Dtos
{
    public class SaldoResultadoDto
    {
        public int NumeroConta { get; set; }
        public string NomeTitular { get; set; } = string.Empty;
        public DateTime DataHoraConsulta { get; set; }
        public decimal SaldoAtual { get; set; }
    }
}
