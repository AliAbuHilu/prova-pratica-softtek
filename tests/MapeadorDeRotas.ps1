Write-Host "---  INSPEÇÃO DE ENDPOINTS DISPONÍVEIS ---" -ForegroundColor Cyan

$projetos = @(
    "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API",
    "C:\projetos\BankMoreSystem\src\BankMore.Transferencia.API"
)

foreach ($proj in $projetos) {
    $nomeProj = Split-Path $proj -Leaf
    Write-Host "`n Projeto: $nomeProj" -ForegroundColor Yellow
    
    $controllers = Get-ChildItem -Path $proj -Filter "*Controller.cs" -Recurse
    
    foreach ($file in $controllers) {
        $content = Get-Content $file.FullName
        $controllerName = $file.BaseName.Replace("Controller", "")
        
        # Busca a Rota Base [Route(...)]
        $routeBase = ""
        if ($content -match '\[Route\("([^"]+)"\)\]') {
            $routeBase = $matches[1].Replace("[controller]", $controllerName)
        }

        # Busca Métodos HttpPost, HttpGet, etc.
        $methods = $content | Select-String '\[Http(Post|Get|Put|Delete)\("?([^" \)]*)"?\)\]'
        
        foreach ($m in $methods) {
            if ($m -match '\[Http(?<verb>Post|Get|Put|Delete)\("?(?<path>[^" \)]*)"?\)\]') {
                $verb = $Matches['verb'].ToUpper()
                $path = $Matches['path']
                $fullPath = "/$routeBase/$path".Replace("//", "/")
                Write-Host "  [$verb] $fullPath" -ForegroundColor Green
            }
        }
    }
}

Write-Host "`n Dica: Se a lista estiver vazia, verifique se os Controllers herdam de ControllerBase." -ForegroundColor Gray
