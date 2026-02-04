Write-Host "---  INICIANDO VARREDURA DE ROTAS (PORTAS 5111/5047) ---" -ForegroundColor Cyan

$rotasLogin = @("/login", "/api/login", "/api/conta/login", "/auth/login", "/Login/login")
$rotasTransf = @("/transferencia", "/api/transferencia", "/", "/api/transferencias")

$token = $null
$urlLoginFinal = ""

# --- PASSO 1: BUSCAR ENDPOINT DE LOGIN ---
foreach ($rota in $rotasLogin) {
    $url = "http://localhost:5111$rota"
    try {
        $body = @{ numero = "1234"; senha = "1234" } | ConvertTo-Json
        $res = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json" -TimeoutSec 2 -ErrorAction SilentlyContinue
        
        if ($res.token) {
            $token = $res.token
            $urlLoginFinal = $url
            Write-Host " Login encontrado e autenticado: $url" -ForegroundColor Green
            break
        }
    } catch {
        # Se retornar 400 ou 401, a rota existe, mas os dados falharam
        if ($_.Exception.Response.StatusCode -match "BadRequest|Unauthorized") {
            Write-Host " Rota encontrada em $url, mas houve erro de validação." -ForegroundColor Yellow
            $urlLoginFinal = $url
            break
        }
    }
}

# --- PASSO 2: TESTAR TRANSFERÊNCIA SE TIVER TOKEN ---
if ($token) {
    $headers = @{ Authorization = "Bearer $token" }
    $payload = @{
        numeroContaOrigem = "1234"
        numeroContaDestino = "9999"
        valor = 10.00
        chaveIdempotencia = [Guid]::NewGuid().ToString()
    } | ConvertTo-Json

    foreach ($rotaT in $rotasTransf) {
        $urlT = "http://localhost:5047$rotaT"
        try {
            $resp = Invoke-RestMethod -Uri $urlT -Method Post -Body $payload -Headers $headers -ContentType "application/json" -TimeoutSec 3 -ErrorAction SilentlyContinue
            Write-Host " SUCESSO! Transferência realizada em: $urlT" -ForegroundColor Green
            Write-Host "   Mensagem da API: $($resp.mensagem)" -ForegroundColor Gray
            return
        } catch {
            if ($_.Exception.Response.StatusCode -ne "NotFound") {
                $stream = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
                Write-Host " Erro na Rota $urlT : $($stream.ReadToEnd())" -ForegroundColor Red
            }
        }
    }
} else {
    Write-Host " Nenhuma rota de login válida foi encontrada na porta 5111." -ForegroundColor Red
    Write-Host "Dica: Verifique se o LoginController tem o atributo [HttpPost] corretamente." -ForegroundColor Yellow
}
