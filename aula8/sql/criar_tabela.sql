
-- Passo 0: Ver banco de dados

show databases;

-- Passo 1: Selecionar o Banco

use 4linux;

-- Passo 2: Criar a tabela

CREATE TABLE pessoa(
   id_pessoa int not null auto_increment,
   nome_pessoa varchar(50) not null,
   nacionalidade_pessoa varchar(50) not null,
   idade_pessoa int not null,    
   PRIMARY KEY(id_pessoa)
);
