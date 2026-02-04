Write-Host "---  INSPEÇÃO DE CONFIGURAÇÃO DE PERSISTÊNCIA ---" -ForegroundColor Cyan

$appSettings = "C:\Projetos\BankMoreSystem\src\BankMore.ContaCorrente.API\appsettings.json"
$programCs = "C:\Projetos\BankMoreSystem\src\BankMore.ContaCorrente.API\Program.cs"

if (Test-Path $appSettings) {
    Write-Host "
 Verificando Connection String no appsettings.json..." -ForegroundColor Yellow
    $json = Get-Content $appSettings | ConvertFrom-Json
    Write-Host "Valor encontrado: $($json.ConnectionStrings.DefaultConnection)" -ForegroundColor White
}

if (Test-Path $programCs) {
    Write-Host "
 Verificando injeção do DbContext no Program.cs..." -ForegroundColor Yellow
    $content = Get-Content $programCs
    $configLine = $content | Select-String "UseSqlite" , "UseInMemoryDatabase"
    
    if ($configLine) {
        Write-Host "Configuração detectada: $($configLine.ToString().Trim())" -ForegroundColor Green
    } else {
        Write-Host " Não foi possível localizar a linha de configuração do banco no Program.cs." -ForegroundColor Red
    }
}

Write-Host "
--- FIM DA INSPEÇÃO ---" -ForegroundColor Cyan
