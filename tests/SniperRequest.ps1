Write-Host "---  SNIPER DE ROTA: EXTRAINDO E TESTANDO ---" -ForegroundColor Cyan

$file = "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API\Controllers\MovimentacaoController.cs"
if (!(Test-Path $file)) { 
    $file = Get-ChildItem -Path "C:\projetos\BankMoreSystem\src" -Filter "MovimentacaoController.cs" -Recurse | Select-Object -First 1 -ExpandProperty FullName
}

$content = Get-Content $file -Raw

# Extração Cirúrgica
$routeBase = ""
if ($content -match '\[Route\("([^"]+)"\)\]') { $routeBase = $matches[1].Replace("[controller]", "Movimentacao") }

$actionPath = ""
if ($content -match '\[HttpPost\("([^"]+)"\)\]') { $actionPath = $matches[1] }

# Montagem da URL Real
$url = "http://localhost:5111/$routeBase/$actionPath".Replace("//", "/")
Write-Host " Rota Real Encontrada: $url" -ForegroundColor Green

# JSON de Depósito
$body = @{
    idcontacorrente = "12345"
    valor = 10.0
    tipomovimento = "Deposito"
} | ConvertTo-Json

try {
    Write-Host " Disparando R$ 10,00..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json"
    Write-Host " SUCESSO ABSOLUTO!" -ForegroundColor Green
    $response | ConvertTo-Json | Write-Host
} catch {
    Write-Host " Erro 404 persiste. Verifique se a API está rodando com 'dotnet run'." -ForegroundColor Red
    Write-Host "Dica: Se a rota exibida acima parecer correta, o problema pode ser o redirecionamento HTTPS (tente mudar para 5112 se for https)." -ForegroundColor Gray
}
