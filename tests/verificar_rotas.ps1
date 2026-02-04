Write-Host "=== INSPEÇÃO DE ENDPOINT DE SALDO ===" -ForegroundColor Cyan

$url = "http://localhost:5111"

# 1. Obter Token (Necessário para acessar o saldo)
Write-Host "[1] Tentando obter Token..." -NoNewline
try {
    $loginBody = @{ numero = 1234; senha = "senha123" } | ConvertTo-Json
    $auth = Invoke-RestMethod -Method Post -Uri "$url/api/Auth/login" -Body $loginBody -ContentType "application/json"
    $token = $auth.token
    Write-Host " [OK]" -ForegroundColor Green
} catch {
    Write-Host " [FALHA NO LOGIN]" -ForegroundColor Red
    return
}

# 2. Testar variações da rota de Saldo (O 404 pode ser letra maiúscula ou caminho diferente)
$rotasParaTestar = @(
    "/api/ContaCorrente/saldo",
    "/api/contacorrente/saldo",
    "/api/ContaCorrente",
    "/saldo"
)

$headers = @{ Authorization = "Bearer $token" }

Write-Host "
[2] Testando variações de rota para encontrar o Saldo:"
foreach ($rota in $rotasParaTestar) {
    $fullUrl = $url + $rota
    Write-Host "    Testando: $fullUrl ... " -NoNewline
    try {
        $res = Invoke-WebRequest -Method Get -Uri $fullUrl -Headers $headers -ErrorAction Stop
        Write-Host " [ACHOU! Status: $(.StatusCode)]" -ForegroundColor Green
        Write-Host "    Conteúdo: $(.Content)" -ForegroundColor Gray
    } catch {
        Write-Host " [404 - Não encontrado]" -ForegroundColor Yellow
    }
}

Write-Host "
=== DICA DE OURO ===" -ForegroundColor Cyan
Write-Host "Se todas derem 404, abra o arquivo:" -ForegroundColor White
Write-Host "src/BankMore.ContaCorrente.API/Controllers/ContaCorrenteController.cs" -ForegroundColor Yellow
Write-Host "E verifique se o [Route("api/[controller]")] e o [HttpGet("saldo")] estão lá."
