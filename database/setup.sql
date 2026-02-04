CREATE TABLE contacorrente (idcontacorrente TEXT PRIMARY KEY, numero INTEGER, nome TEXT, ativo INTEGER);
CREATE TABLE movimento (idmovimento TEXT PRIMARY KEY, idcontacorrente TEXT, datamovimento TEXT, tipomovimento TEXT, valor REAL);
CREATE TABLE idempotencia (chave_idempotencia TEXT PRIMARY KEY, requisicao TEXT, resultado TEXT);

INSERT INTO contacorrente VALUES ('CC-ANA-001', 1234, 'Ana BankMore', 1);
INSERT INTO movimento VALUES ('MOV-INIT-001', 'CC-ANA-001', datetime('now'), 'C', 5000.00);
