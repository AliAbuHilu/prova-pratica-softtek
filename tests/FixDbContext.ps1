Write-Host "---  CORRIGINDO MAPEAMENTO DO DBSET ---" -ForegroundColor Cyan

$content = Get-Content "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\Context\BankMoreContext.cs" -Raw

# Verifica se a propriedade ContaCorrentes já existe, se não, adiciona.
if ($content -notmatch "public DbSet<ContaCorrente>") {
    Write-Host " Adicionando DbSet<ContaCorrente> ao contexto..." -ForegroundColor Yellow
    
    # Insere o novo DbSet logo após o DbSet de Movimento (ou no início da classe)
    $newDbSet = "`n        public DbSet<Movimento> Movimentos { get; set; }`n        public DbSet<ContaCorrente> ContaCorrentes { get; set; }"
    
    # Substitui o DbSet antigo (se houver) ou adiciona um novo
    if ($content -match "public DbSet<Movimento>.*{ get; set; }") {
        $content = $content -replace "public DbSet<Movimento>.*{ get; set; }", $newDbSet
    } else {
        # Se não achar nada, insere antes do primeiro fechamento de chave do construtor
        $content = $content.Replace("public class BankMoreContext : DbContext", "public class BankMoreContext : DbContext`n    {`n        public DbSet<Movimento> Movimentos { get; set; }`n        public DbSet<ContaCorrente> ContaCorrentes { get; set; }")
    }
    
    $content | Set-Content "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\Context\BankMoreContext.cs" -Encoding UTF8
    Write-Host " Contexto atualizado com sucesso." -ForegroundColor Green
} else {
    Write-Host " DbSet<ContaCorrente> já parece estar presente. Verifique se o namespace da entidade está correto." -ForegroundColor Gray
}

Write-Host " Recompilando para validar o modelo..." -ForegroundColor Yellow
dotnet build "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\BankMore.ContaCorrente.Infrastructure.csproj"
