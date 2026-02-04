# Configurações da Connection String (Ajuste se o seu banco tiver outro nome)
$connectionString = "Server=(localdb)\MSSQLLocalDB;Database=BankMoreDB;Trusted_Connection=True;"

Write-Host "---  AUDITORIA DE PERSISTÊNCIA (TABELA MOVIMENTO) ---" -ForegroundColor Cyan

$query = "SELECT TOP 1 Id, ContaId, Valor, DataMovimentacao, Tipo FROM Movimentos WHERE ContaId = (SELECT Id FROM Contas WHERE Numero = '1234') ORDER BY DataMovimentacao DESC"

try {
    Write-Host "Conectando ao banco para verificar o registro..." -NoNewline
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    
    $connection.Open()
    $reader = $command.ExecuteReader()

    if ($reader.Read()) {
        Write-Host "  REGISTRO ENCONTRADO!" -ForegroundColor Green
        Write-Host "
Detalhes da Última Movimentação:" -ForegroundColor Yellow
        Write-Host "ID: $($reader["Id"])"
        Write-Host "Valor: R$ $($reader["Valor"])"
        Write-Host "Data: $($reader["DataMovimentacao"])"
        Write-Host "Tipo: $($reader["Tipo"])"
    } else {
        Write-Host "  NENHUM REGISTRO ENCONTRADO!" -ForegroundColor Red
        Write-Host "O comando retornou sucesso, mas o dado não chegou na tabela 'Movimentos'." -ForegroundColor Yellow
    }
    $connection.Close()
} catch {
    Write-Host "  Erro ao acessar o SQL Server: $($_.Exception.Message)" -ForegroundColor Red
}
