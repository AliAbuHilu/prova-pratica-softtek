$headers = @{
    'Authorization' = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IkFuYSBCYW5rTW9yZSIsIm51bWVybyI6IjEyMzQiLCJuYmYiOjE3NzAwODEwMzgsImV4cCI6MTc3MDA4ODIzOCwiaWF0IjoxNzcwMDgxMDM4fQ.BQn3aZ4MjcjCDnIZ27ATtDnIN4_Rs_S1ONXvGTFwk1Q'
    'Accept'        = 'application/json'
}

Write-Host "---  CONSULTANDO SALDO DA ANA ---" -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri 'http://localhost:5111/api/ContaCorrente/saldo' -Method Get -Headers $headers
    Write-Host "Saldo Atual: R$ $($response.saldo)" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host " Erro ao consultar saldo: $($_.Exception.Message)" -ForegroundColor Red
}
