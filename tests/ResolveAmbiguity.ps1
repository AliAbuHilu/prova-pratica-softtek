Write-Host "---  RESOLVENDO AMBIGUIDADE DE NAMESPACE ---" -ForegroundColor Cyan

# A. Tenta descobrir o namespace real da Entidade ContaCorrente
$entityFile = Get-ChildItem -Path "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Domain" -Filter "ContaCorrente.cs" -Recurse | Select-Object -First 1
$entityNamespace = "BankMore.ContaCorrente.Domain.Entities" # Valor padrão comum

if ($entityFile) {
    $namespaceLine = Get-Content $entityFile.FullName | Select-String "namespace"
    if ($namespaceLine -match "namespace\s+([\w\.]+)") {
        $entityNamespace = $matches[1]
    }
}

Write-Host " Namespace da entidade identificado: $entityNamespace" -ForegroundColor Gray

# B. Atualiza o BankMoreContext usando o nome completo para evitar o erro CS0118
$content = Get-Content "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\Context\BankMoreContext.cs" -Raw

# Substitui o DbSet problemático pelo nome qualificado
# Ex: DbSet<ContaCorrente> -> DbSet<BankMore.ContaCorrente.Domain.Entities.ContaCorrente>
$oldText = "public DbSet<ContaCorrente>"
$newText = "public DbSet<$entityNamespace.ContaCorrente>"

if ($content -contains $oldText) {
    $content = $content.Replace($oldText, $newText)
} else {
    # Caso o script anterior tenha falhado ou esteja diferente
    $content = $content -replace "DbSet<ContaCorrente>", "DbSet<$entityNamespace.ContaCorrente>"
}

$content | Set-Content "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\Context\BankMoreContext.cs" -Encoding UTF8
Write-Host " Ambiguidade resolvida com Nome Qualificado." -ForegroundColor Green

Write-Host " Recompilando..." -ForegroundColor Yellow
dotnet build "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\BankMore.ContaCorrente.Infrastructure.csproj"
