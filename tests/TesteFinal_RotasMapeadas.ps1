Write-Host "---  TENTANDO DESCOBRIR A ROTA DE LOGIN (SEM 404) ---" -ForegroundColor Cyan

$portas = @("5111", "5000")
$tentativas = @("/login", "/api/login", "/Login/login", "/auth/login")

$token = $null
$urlSucesso = ""

foreach ($porta in $portas) {
    foreach ($rota in $tentativas) {
        $url = "http://localhost:$porta$rota"
        try {
            $body = @{ numero = "1234"; senha = "1234" } | ConvertTo-Json
            $res = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json" -ErrorAction SilentlyContinue
            if ($res.token) {
                $token = $res.token
                $urlSucesso = $url
                break
            }
        } catch {
            # Se der 401 ou 400, a rota EXISTE (só erramos os dados)
            if ($_.Exception.Response.StatusCode -ne "NotFound") {
                Write-Host " Rota encontrada: $url (Mas retornou $($_.Exception.Response.StatusCode))" -ForegroundColor Yellow
                $urlSucesso = $url
                break
            }
        }
    }
    if ($urlSucesso) { break }
}

if ($token) {
    Write-Host " SUCESSO! Logado via: $urlSucesso" -ForegroundColor Green
    # Agora tenta a transferência usando a mesma lógica de porta
    $urlTransfer = "http://localhost:5047/transferencia" # Rota padrão SOLID
    $headers = @{ Authorization = "Bearer $token" }
    $payload = @{
        numeroContaOrigem = "1234"
        numeroContaDestino = "9999"
        valor = 10.00
        chaveIdempotencia = [Guid]::NewGuid().ToString()
    } | ConvertTo-Json

    try {
        $resp = Invoke-RestMethod -Uri $urlTransfer -Method Post -Body $payload -Headers $headers -ContentType "application/json"
        Write-Host " Transferência Concluída!" -ForegroundColor Green
    } catch {
        Write-Host " Token obtido, mas erro na transferência. Verifique a API de Transferência." -ForegroundColor Yellow
    }
} else {
    Write-Host " Nenhuma das rotas funcionou. Verifique se o projeto ContaCorrente está RODANDO e veja o log no console da API." -ForegroundColor Red
}
