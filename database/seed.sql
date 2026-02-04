-- Limpa dados antigos para evitar duplicidade no teste
DELETE FROM movimento;
DELETE FROM contacorrente;

-- Insere a conta de teste (Ana) como ATIVA (1)
INSERT INTO contacorrente (idcontacorrente, numero, nome, ativo) 
VALUES ('CC-ANA-001', 1234, 'Ana BankMore', 1);

-- Insere um saldo inicial (Depósito de R$ 5.000,00)
INSERT INTO movimento (idmovimento, idcontacorrente, datamovimento, tipomovimento, valor)
VALUES ('MOV-INIT-001', 'CC-ANA-001', '2026-02-01 10:51:16', 'C', 5000.00);
