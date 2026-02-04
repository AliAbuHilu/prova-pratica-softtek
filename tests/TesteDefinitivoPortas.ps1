Write-Host "---  INICIANDO TESTE NAS PORTAS 5111 E 5047 ---" -ForegroundColor Cyan

$urlBaseLogin = "http://localhost:5111"
$urlBaseTransfer = "http://localhost:5047"

# Lista de rotas possíveis baseadas em convenções Clean Code e SOLID
$rotasLogin = @("/login", "/api/login", "/Login/login")
$rotasTransfer = @("/transferencia", "/api/transferencia", "/")

$token = $null
$urlLoginFinal = ""

# --- PASSO 1: DESCOBRIR LOGIN ---
foreach ($rota in $rotasLogin) {
    $url = "$urlBaseLogin$rota"
    try {
        $body = @{ numero = "1234"; senha = "1234" } | ConvertTo-Json
        $res = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json" -ErrorAction SilentlyContinue
        if ($res.token) {
            $token = $res.token
            $urlLoginFinal = $url
            Write-Host " Login encontrado em: $url" -ForegroundColor Green
            break
        }
    } catch {
        if ($_.Exception.Response.StatusCode -ne "NotFound") {
            Write-Host " Rota existe, mas erro de dados em: $url (Status: $($_.Exception.Response.StatusCode))" -ForegroundColor Yellow
            $urlLoginFinal = $url
            break
        }
    }
}

# --- PASSO 2: EXECUTAR TRANSFERÊNCIA SE TIVER TOKEN ---
if ($token) {
    foreach ($rota in $rotasTransfer) {
        $urlT = "$urlBaseTransfer$rota"
        try {
            $headers = @{ Authorization = "Bearer $token" }
            $payload = @{
                numeroContaOrigem = "1234"
                numeroContaDestino = "9999"
                valor = 10.00
                chaveIdempotencia = [Guid]::NewGuid().ToString()
            } | ConvertTo-Json
            
            $resp = Invoke-RestMethod -Uri $urlT -Method Post -Body $payload -Headers $headers -ContentType "application/json" -ErrorAction SilentlyContinue
            Write-Host " Transferência realizada com sucesso em: $urlT" -ForegroundColor Green
            Write-Host "Mensagem: $($resp.mensagem)" -ForegroundColor Gray
            return
        } catch {
             if ($_.Exception.Response.StatusCode -ne "NotFound") {
                Write-Host " Erro na Transferência em $urlT : $($_.Exception.Message)" -ForegroundColor Red
             }
        }
    }
} else {
    Write-Host " Não foi possível obter o token. Verifique se o microserviço na porta 5111 está rodando." -ForegroundColor Red
}
