Write-Host "---  ALINHANDO TRANSFERENCIA SERVICE COM NOVO SCHEMA ---" -ForegroundColor Cyan

$content = Get-Content "C:\projetos\BankMoreSystem\src\BankMore.Transferencia.API\Business\TransferenciaService.cs" -Raw

# Correção de Propriedades e Tipagem (Decimal -> Double e DateTime -> String)
# Substitui o mapeamento antigo pelo novo
$content = $content -replace '\.Tipo\s*=', '.TipoMovimento ='
$content = $content -replace 'Valor\s*=\s*([^,;]+)', 'Valor = (double)$1'
$content = $content -replace 'DataMovimento\s*=\s*DateTime\.Now', 'DataMovimento = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")'

$content | Set-Content "C:\projetos\BankMoreSystem\src\BankMore.Transferencia.API\Business\TransferenciaService.cs" -Encoding UTF8
Write-Host " TransferenciaService.cs alinhado." -ForegroundColor Green

#  Build para verificar os erros remanescentes no Program.cs
Write-Host " Executando build..." -ForegroundColor Yellow
Set-Location "C:\projetos\BankMoreSystem"
dotnet build
