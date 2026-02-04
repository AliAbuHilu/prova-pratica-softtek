namespace BankMore.ContaCorrente.Domain.Dtos
{
    public class MovimentacaoResultadoDto
    {
        public bool Sucesso { get; set; }
        public string Mensagem { get; set; } = string.Empty;
    }
}
