Write-Host "---  DESCOBRINDO ROTAS DO CONTROLLER ---" -ForegroundColor Cyan

# A. Localizar o Controller de Movimentação/ContaCorrente
$controllerFile = Get-ChildItem -Path "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API" -Filter "*Controller.cs" -Recurse | Select-Object -First 1

if ($controllerFile) {
    $content = Get-Content $controllerFile.FullName
    
    # Tenta extrair a rota base e o método
    $routeBase = $content | Select-String '\[Route\("([^"]+)"\)\]' | ForEach-Object { $_.Matches.Groups[1].Value }
    $methodPath = $content | Select-String '\[HttpPost\("([^"]+)"\)\]' | ForEach-Object { $_.Matches.Groups[1].Value }
    
    # Limpa as variáveis se vierem com tokens de substituição do ASP.NET
    $routeBase = $routeBase.Replace("[controller]", $controllerFile.BaseName.Replace("Controller", ""))
    
    $finalUrl = "http://localhost:5111/$routeBase/$methodPath".Replace("//", "/")
    Write-Host " Rota detectada: $finalUrl" -ForegroundColor Green
} else {
    Write-Host " Controller não encontrado!" -ForegroundColor Red
    exit
}

# B. Executar o POST Real
$body = @{
    idcontacorrente = "12345"
    valor = 10.0
    tipomovimento = "Deposito"
    datamovimento = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
} | ConvertTo-Json

try {
    Write-Host " Enviando R$ 10,00 para a rota real..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri $finalUrl -Method Post -Body $body -ContentType "application/json"
    Write-Host " SUCESSO! O banco deve ter gravado o registro." -ForegroundColor Green
    $response | ConvertTo-Json | Write-Host
} catch {
    Write-Host " Falha ao enviar: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Gray
}
