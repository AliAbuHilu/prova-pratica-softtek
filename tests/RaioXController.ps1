Write-Host "---  ANALISANDO MÉTODOS DO CONTROLLER ---" -ForegroundColor Cyan

$file = Get-ChildItem -Path "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API" -Filter "*Controller.cs" -Recurse | 
        Where-Object { $_.Name -match "Movimentacao|ContaCorrente" } | Select-Object -First 1

if ($file) {
    Write-Host "Arquivo encontrado: $($file.FullName)" -ForegroundColor Yellow
    $lines = Get-Content $file.FullName
    
    Write-Host "`nBusca por definições de métodos POST:" -ForegroundColor Cyan
    $lines | Select-String "public.*Task.*\(|\[HttpPost" | ForEach-Object { Write-Host "  >> $($_.ToString().Trim())" -ForegroundColor Green }
} else {
    Write-Host " Controller de movimentação não encontrado!" -ForegroundColor Red
}
