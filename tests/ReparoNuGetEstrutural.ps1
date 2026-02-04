Write-Host "---  LIMPANDO E FORÇANDO REFERÊNCIAS NUGET ---" -ForegroundColor Cyan

# A. Limpar Cache do NuGet
Write-Host "Limpar caches locais..." -ForegroundColor Yellow
dotnet nuget locals all --clear

# B. Injetar Referências diretamente no XML do Projeto (Garantia de que o CS0234 suma)
$projContent = Get-Content "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\BankMore.ContaCorrente.Infrastructure.csproj" -Raw
if ($projContent -notmatch "Microsoft.EntityFrameworkCore.Sqlite") {
    Write-Host "Injetando referências no .csproj..." -ForegroundColor Yellow
    $newRef = @"
  <ItemGroup>
    <PackageReference Include="Microsoft.EntityFrameworkCore" Version="8.0.0" />
    <PackageReference Include="Microsoft.EntityFrameworkCore.Sqlite" Version="8.0.0" />
  </ItemGroup>
</Project>
"@
    $projContent = $projContent -replace "</Project>", $newRef
    $projContent | Set-Content "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.Infrastructure\BankMore.ContaCorrente.Infrastructure.csproj" -Encoding UTF8
}

# C. Restaurar e Build
Set-Location "C:\projetos\BankMoreSystem"
Write-Host "Restaurando dependências..." -ForegroundColor Yellow
dotnet restore
Write-Host "Executando build..." -ForegroundColor Yellow
dotnet build
