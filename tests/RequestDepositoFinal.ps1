Write-Host "---  TESTE DE DEPÓSITO: ALVO ESPECÍFICO ---" -ForegroundColor Cyan

# A. Buscar o Controller correto (Movimentacao ou ContaCorrente)
$controllerFile = Get-ChildItem -Path "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API" -Filter "*Controller.cs" -Recurse | 
                  Where-Object { $_.Name -match "Movimentacao|ContaCorrente|Transferencia" -and $_.Name -notmatch "Auth" } | 
                  Select-Object -First 1

if ($controllerFile) {
    Write-Host " Controller identificado: $($controllerFile.Name)" -ForegroundColor Gray
    $content = Get-Content $controllerFile.FullName -Raw
    
    # Extração de Rota via Regex Robusto
    $routeBase = "api/" + $controllerFile.BaseName.Replace("Controller", "")
    if ($content -match '\[Route\("api/([^"]+)"\)\]') { $routeBase = "api/" + $matches[1] }

    # Montagem da URL (Garantindo o http:// correto)
    $finalUrl = "http://localhost:5111/$routeBase/deposito"
    Write-Host " URL de Destino: $finalUrl" -ForegroundColor Green
} else {
    Write-Host " Controller de negócio não encontrado!" -ForegroundColor Red
    exit
}

# B. JSON de Depósito para R$ 10,00
$body = @{
    numeroConta = "12345" # Ajuste o nome da propriedade se for idcontacorrente
    valor = 10.0
    tipoMovimento = 1 # Geralmente 1 para Crédito/Depósito em enums
} | ConvertTo-Json

try {
    Write-Host " Enviando POST..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri $finalUrl -Method Post -Body $body -ContentType "application/json"
    Write-Host " SUCESSO! Resposta da API recebida." -ForegroundColor Green
    $response | ConvertTo-Json | Write-Host
} catch {
    $msg = $_.Exception.Message
    Write-Host " Erro: $msg" -ForegroundColor Red
    if ($_.Exception.Response) {
        $stream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($stream)
        Write-Host "Detalhes: $($reader.ReadToEnd())" -ForegroundColor Gray
    }
}
