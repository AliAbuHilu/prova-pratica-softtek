Write-Host "---  MAPEANDO ENDPOINTS DIRETO DO CÓDIGO (C#) ---" -ForegroundColor Cyan

function Obter-Endpoints {
    param([string]$caminho, [string]$nomeServico, [string]$porta)
    
    Write-Host "
 Serviço: $nomeServico (Porta: $porta)" -ForegroundColor Yellow
    $files = Get-ChildItem -Path $caminho -Filter *Controller.cs -Recurse

    foreach ($file in $files) {
        $conteudo = Get-Content $file.FullName
        $routePrefix = ""
        
        # Busca o [Route("...")] da classe
        if ($conteudo -match '\[Route\(\"(.+)\"\)\]') {
            $routePrefix = $Matches[1].Replace("[controller]", $file.Name.Replace("Controller.cs", ""))
        }

        # Busca métodos HttpPost, HttpGet, etc.
        for ($i=0; $i -lt $conteudo.Count; $i++) {
            if ($conteudo[$i] -match '\[Http(Post|Get|Put|Delete)(\(\"(.+)\"\))?\]') {
                $metodo = $Matches[1].ToUpper()
                $subRota = $Matches[3]
                $urlFinal = "http://localhost:$porta/$routePrefix"
                if ($subRota) { $urlFinal += "/$subRota" }
                
                Write-Host "  [$metodo] -> $urlFinal" -ForegroundColor Green
            }
        }
    }
}

Obter-Endpoints -caminho "C:\projetos\BankMoreSystem\src\BankMore.ContaCorrente.API" -nomeServico "Conta Corrente" -porta "5111"
Obter-Endpoints -caminho "C:\projetos\BankMoreSystem\src\BankMore.Transferencia.API" -nomeServico "Transferência" -porta "5047"

Write-Host "
--- MAPEAMENTO CONCLUÍDO ---" -ForegroundColor Cyan
