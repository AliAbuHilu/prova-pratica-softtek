Write-Host "---  AJUSTANDO CHAMADA DO TOKEN NO AUTHCONTROLLER ---" -ForegroundColor Cyan

$content = Get-Content "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API\Controllers\AuthController.cs" -Raw

# Ajusta a chamada do método GerarToken para passar o objeto 'conta' em vez de strings separadas
# De: _tokenService.GerarToken(conta.Numero, conta.Nome)
# Para: _tokenService.GerarToken(conta)
if ($content -match "_tokenService.GerarToken\(.*?\)") {
    $content = $content -replace "_tokenService.GerarToken\(.*?\)", "_tokenService.GerarToken(conta)"
    $content | Set-Content "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API\Controllers\AuthController.cs" -Encoding UTF8
    Write-Host " Chamada do TokenService atualizada!" -ForegroundColor Green
}

Write-Host " Build final da API..." -ForegroundColor Yellow
Set-Location "C:\projetos\BankMoreSystem"
dotnet build src\BankMore.ContaCorrente.API\BankMore.ContaCorrente.API.csproj
