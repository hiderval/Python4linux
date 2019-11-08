-- Atualiza banco

-- Passo 0: Acessar o banco de dados

use 4linux;


DELETE FROM pessoa
WHERE nacionalidade_pessoa = "Espanha";
