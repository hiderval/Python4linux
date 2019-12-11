/*
Como uma opera��o de Shrink causa MASSIVA FRAGMENTA��O DOS INDICES.

O motivo � que o shrink no arquivo inicia uma mudan�a dos dados do final do aquivo para o come�o
Com isso, a ordem das p�ginas no leaf node s�o alteradas causando fragmenta��o

*/


USE MASTER;
GO
 

IF DATABASEPROPERTYEX ('shrinktest', 'Version') > 0
      DROP DATABASE shrinktest;
 

CREATE DATABASE shrinktest;
GO
USE shrinktest;
GO
 

SET NOCOUNT ON;
GO
 

--#1 Criar e preencher uma tabela s� para ocupar espa�o no banco de dados
CREATE TABLE filler (c1 INT IDENTITY, c2 VARCHAR(8000))
GO
DECLARE @a INT;
SELECT @a = 1;
WHILE (@a < 1280) -- insert 10MB
BEGIN
      INSERT INTO filler VALUES (REPLICATE ('a', 5000));
      SELECT @a = @a + 1;
END;
GO



--#2 Criar e preencher uma tabela de produ��o (USO)
CREATE TABLE production (c1 INT IDENTITY, c2 VARCHAR (8000));
CREATE CLUSTERED INDEX prod_cl ON production (c1);
GO
DECLARE @a INT;
SELECT @a = 1;
WHILE (@a < 1280) -- insert 10MB
BEGIN
      INSERT INTO production VALUES (REPLICATE ('a', 5000));
      SELECT @a = @a + 1;
END;
GO 

--#3 Verificar o n�vel de fragmenta��o da tabela de produ��o
SELECT avg_fragmentation_in_percent, fragment_count FROM sys.dm_db_index_physical_stats (
      DB_ID ('shrinktest'), OBJECT_ID ('production'), 1, NULL, 'LIMITED');
GO

--#4 DROP da Primeira tabela
DROP TABLE filler;
GO
 

--#5 shrink the database
DBCC SHRINKDATABASE (shrinktest);
GO
 
--#6 Verificar novamente o n�vel de fragmenta�ao
SELECT avg_fragmentation_in_percent, fragment_count FROM sys.dm_db_index_physical_stats (
      DB_ID ('shrinktest'), OBJECT_ID ('production'), 1, NULL, 'LIMITED');
GO


