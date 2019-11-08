
-- Atualiza banco

-- Passo 0: Acessar o banco de dados

use 4linux;

UPDATE pessoa
SET nome_pessoa = "Florinda"
WHERE nacionalidade_pessoa = "Argentina";


UPDATE pessoa
SET nacionalidade_pessoa = "México"
WHERE nome_pessoa = "Florinda";
