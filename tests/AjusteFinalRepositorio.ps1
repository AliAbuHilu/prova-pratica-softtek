Write-Host "---  FINALIZANDO IMPLEMENTAÇÃO DO REPOSITÓRIO ---" -ForegroundColor Cyan
$base = "C:\projetos\BankMoreSystem\src"

# 1. Ajuste da Entidade (Removendo Warnings de Nullable)
$entCode = @"
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BankMore.ContaCorrente.Domain.Entities
{
    [Table("movimento")]
    public class Movimento
    {
        [Key] [Column("idmovimento")] public string IdMovimento { get; set; } = string.Empty;
        [Column("idcontacorrente")] public string IdContaCorrente { get; set; } = string.Empty;
        [Column("datamovimento")] public string DataMovimento { get; set; } = string.Empty;
        [Column("tipomovimento")] public string TipoMovimento { get; set; } = string.Empty;
        [Column("valor")] public double Valor { get; set; }
    }
}
"@
$entCode | Set-Content "$base\BankMore.ContaCorrente.Domain\Entities\Movimento.cs" -Encoding UTF8

# 2. Ajuste da Implementação do Repositório (Resolvendo o erro CS0535)
# Note: Estou assumindo que seu DbContext se chama 'ContaCorrenteContext' ou similar.
# Se o nome do campo de contexto for diferente de _context, ajuste abaixo.
$repoPath = "$base\BankMore.ContaCorrente.Infrastructure\Repositories\ContaCorrenteRepository.cs"
$repoContent = Get-Content $repoPath -Raw

if ($repoContent -notmatch "SaveChangesAsync") {
    # Inserindo o método antes do último fechamento de chave
    $newRepoContent = $repoContent.TrimEnd().TrimEnd('}') + @"
        public async Task<int> SaveChangesAsync()
        {
            return await _context.SaveChangesAsync();
        }
    }
"@
    $newRepoContent | Set-Content $repoPath -Encoding UTF8
    Write-Host " Método SaveChangesAsync adicionado ao repositório." -ForegroundColor Green
}

Write-Host " Compilando para validar persistência..." -ForegroundColor Yellow
Set-Location "C:\projetos\BankMoreSystem"
dotnet build
