using MediatR;

namespace BankMore.ContaCorrente.Domain.Commands
{
    // Adicionamos o : IRequest<bool> para o MediatR reconhecer o retorno
    public class RegistrarMovimentoCommand : IRequest<bool>
    {
        public int NumeroConta { get; set; }
        public decimal Valor { get; set; }
        public string TipoMovimento { get; set; } = string.Empty; // 'C' ou 'D'
    }
}
