CREATE TABLE IF NOT EXISTS contacorrente (
    idcontacorrente TEXT PRIMARY KEY,
    numero INTEGER NOT NULL,
    nome TEXT NOT NULL,
    ativo INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS movimento (
    idmovimento TEXT PRIMARY KEY,
    idcontacorrente TEXT NOT NULL,
    datamovimento TEXT NOT NULL,
    tipomovimento TEXT NOT NULL,
    valor REAL NOT NULL,
    FOREIGN KEY(idcontacorrente) REFERENCES contacorrente(idcontacorrente)
);

CREATE TABLE IF NOT EXISTS idempotencia (
    chave_idempotencia TEXT PRIMARY KEY,
    requisicao TEXT,
    resultado TEXT
);

-- Inserir conta de teste (Ana)
INSERT OR IGNORE INTO contacorrente (idcontacorrente, numero, nome, ativo) 
VALUES ('CC-ANA-001', 1234, 'Ana BankMore', 1);

-- Saldo inicial de R$ 5.000,00
INSERT OR IGNORE INTO movimento (idmovimento, idcontacorrente, datamovimento, tipomovimento, valor)
VALUES ('MOV-INIT-001', 'CC-ANA-001', datetime('now'), 'C', 5000.00);
