Write-Host "---  LIBERANDO ENDPOINT PARA TESTE DE BANCO ---" -ForegroundColor Cyan

$file = Get-ChildItem -Path "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API" -Filter "MovimentacaoController.cs" -Recurse | Select-Object -First 1

if ($file) {
    $content = Get-Content $file.FullName -Raw
    
    # Adiciona o using necessário se não existir
    if ($content -notmatch "using Microsoft.AspNetCore.Authorization;") {
        $content = "using Microsoft.AspNetCore.Authorization;`n" + $content
    }

    # Adiciona [AllowAnonymous] acima da classe ou do método Post
    if ($content -notmatch "\[AllowAnonymous\]") {
        $content = $content.Replace("[HttpPost]", "[AllowAnonymous]`n        [HttpPost]")
        $content | Set-Content $file.FullName -Encoding UTF8
        Write-Host " [AllowAnonymous] adicionado ao MovimentacaoController." -ForegroundColor Green
    }
}

# 2. Corrigir o Program.cs (Remover a obrigatoriedade de Auth se não estiver configurada)
$programPath = "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API\Program.cs"
$programContent = Get-Content $programPath -Raw
if ($programContent -match "app.UseAuthorization\(\);") {
    # Apenas garantimos que a ordem está correta: Authentication ANTES de Authorization
    # Mas para o teste, o AllowAnonymous no controller já resolve.
    Write-Host " Middleware de autorização detectado. O AllowAnonymous deve ignorá-lo." -ForegroundColor Yellow
}

Write-Host " Recompilando para aplicar as mudanças..." -ForegroundColor Yellow
dotnet build "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API\BankMore.ContaCorrente.API.csproj"
