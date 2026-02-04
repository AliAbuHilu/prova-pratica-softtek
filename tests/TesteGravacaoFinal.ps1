Write-Host "---  EXECUTANDO GRAVAÇÃO COM NOMES DO COMMAND ---" -ForegroundColor Cyan

# 1. Login (Token necessário mesmo com AllowAnonymous no Post, por segurança)
$loginBody = @{ numero = "1234"; senha = "1234" } | ConvertTo-Json
$auth = Invoke-RestMethod -Uri "http://localhost:5111/api/Auth/login" -Method Post -Body $loginBody -ContentType "application/json"

# 2. Montando o JSON exatamente como o RegistrarMovimentoCommand espera:
$movBody = @{ 
    NumeroConta   = 1234;         # Inteiro, conforme seu Handler
    Valor         = 50.0;         # Double/Real
    TipoMovimento = "Credito";    # String
    Descricao     = "Teste SOLID" # Propriedade extra se houver
} | ConvertTo-Json

try {
    $headers = @{ Authorization = "Bearer $(@{token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IkFuYSBCYW5rTW9yZSIsIm51bWVybyI6IjEyMzQiLCJuYmYiOjE3NzAwNTI5ODgsImV4cCI6MTc3MDA2MDE4OCwiaWF0IjoxNzcwMDUyOTg4fQ.h1DnWnizI8k6loOzaCene-uQ7AkfDQ9xGIQiLWizHYM}.token)" }
    $result = Invoke-RestMethod -Uri "http://localhost:5111/api/Movimentacao" -Method Post -Body $movBody -ContentType "application/json" -Headers $headers
    Write-Host " SUCESSO: $(System.Net.SyncMemoryStream.mensagem)" -ForegroundColor Green
    
    # Gravando o resultado
    $result | ConvertTo-Json | Out-File "C:\projetos\BankMoreSystem\tests\resultado_real.json"
} catch {
    $res = $_.Exception.Response.GetResponseStream()
    $err = (New-Object System.IO.StreamReader($res)).ReadToEnd()
    Write-Host " Erro 400 (Bad Request): Verifique se os nomes das propriedades no Command batem." -ForegroundColor Red
    Write-Host "Resposta da API: $err" -ForegroundColor Yellow
}
