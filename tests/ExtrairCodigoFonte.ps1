Write-Host "---  EXTRAÇÃO DE CÓDIGO PARA ANÁLISE ---" -ForegroundColor Cyan

$arquivos = @(
    "RegistrarMovimentoCommand.cs",
    "IContaCorrenteRepository.cs",
    "RegistrarMovimentoHandler.cs"
)

foreach ($nome in $arquivos) {
    $file = Get-ChildItem -Path "C:\Projetos\BankMoreSystem\src" -Filter $nome -Recurse | Select-Object -First 1
    if ($file) {
        Write-Host "
>>> ARQUIVO: $(.FullName)" -ForegroundColor Yellow
        Write-Host "--------------------------------------------------"
        Get-Content $file.FullName
        Write-Host "--------------------------------------------------"
    } else {
        Write-Host " Arquivo $nome não encontrado!" -ForegroundColor Red
    }
}
