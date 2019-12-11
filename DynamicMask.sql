


-- Criação da tabela de vendas
CREATE TABLE TB_VENDA_COMISS (
ID INT IDENTITY PRIMARY KEY,
NUM_PEDIDO INT,
COD_PRODUTO VARCHAR(10),
VALOR DECIMAL(10,2),
QUANTIDADE INT
)
GO
-- Insere registros na tabela
INSERT INTO TB_VENDA_COMISS VALUES
( 1, 'ABC452', 150.00,2),
( 2, 'A584452', 758.00,1),
( 3, 'BC8452', 10.00,1),
( 4, 'DUO985', 1650.00,2),
( 5, '98751', 1050.00,4),
( 6, 'PPP980', 870.00,7),
( 7, 'CCI989', 753.00,8),
( 8, 'LIU90', 258.00,9),
( 9, 'NHY98', 951.00,10),
( 10, 'SOIU0', 25.00,11)
GO
--Cria uma nova coluna para valores de comissão
ALTER TABLE TB_VENDA_COMISS ADD COMISSAO DECIMAL(10,2)
GO
-- Atualiza a coluna de comissão
UPDATE TB_VENDA_COMISS SET Comissao=VALOR*.02
-- Verifica as informações
SELECT * FROM TB_VENDA_COMISS

-- Altera a coluna comissão para mascarar o campo
GO
ALTER TABLE TB_VENDA_COMISS
ALTER COLUMN Comissao ADD MASKED WITH (FUNCTION = 'DEFAULT()');
GO
-- Verifica as informações
SELECT * FROM TB_VENDA_COMISS
-- Atribui permissão para visualizar as informações
GRANT SELECT ON TB_VENDA_COMISS TO GESTOR
-- Ao efetuar a consulta na tabela o campo comissão está sem valor.
EXECUTE AS USER = 'GESTOR';
SELECT * FROM TB_VENDA_COMISS
REVERT
GO


-- Atribui permissão de leitura de campos mascarados
GRANT UNMASK TO GESTOR


-- Ao executar a consulta novamente é possível verificar o campo
EXECUTE AS USER = 'GESTOR';
SELECT * FROM TB_VENDA_COMISS
REVERT
GO



