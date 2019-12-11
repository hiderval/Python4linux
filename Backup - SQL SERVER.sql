

/*************************************************************************
==========================================================================
TRABALHANDO COM BACKUPS E RESTORES
==========================================================================

--PRELIMINARES:

-- Verificar se uma pasta existe
xp_fileexist 'c:\SQLMOC'
xp_fileexist 'c:\SQLBACK'

-- Verificar as subpastas 
xp_subdirs 'c:\SQLMOC' 

-- Criar uma pasta
xp_create_subdir 'c:\SQLMOC'
xp_create_subdir 'c:\SQLBACK'
****************************************************************************/

--==============================================================================
-- PARTE 1 - PREPARANDO O AMBIENTE 1
--==============================================================================

-- OBJETIVO: Conceituar Backups, Devices, Restore

--#1 Etapa 1 - Criar um banco para teste
IF EXISTS (Select name from master.dbo.Sysdatabases where name = 'DB')
DROP DATABASE DB
GO

CREATE DATABASE DB
ON PRIMARY
(
NAME = 'DB_DATA',
FILENAME = 'C:\SQLMOC\DB_DATA.MDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
),
FILEGROUP FG2
(
NAME = 'DB_DATA2',
FILENAME = 'C:\SQLMOC\DB_DATA2.NDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
LOG ON
(
NAME = 'DB_LOG',
FILENAME = 'C:\SQLMOC\DB_LOG.LDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER DATABASE DB SET RECOVERY FULL
GO


--==============================================================================
-- PARTE 2- BACKUP INTRODUÇÃO
--==============================================================================

-- #2.1 Backup simples
BACKUP DATABASE DB TO DISK = 'C:\SQLBACK\DB_backup.bak'



BACKUP DATABASE DB TO DISK = 'C:\SQLBACK\DB_backup.bak'
WITH INIT

-- Copia intercalando blocos de arquivos em "N" discos
-- Semelhante RAID 0
BACKUP DATABASE DB TO DISK = 'C:\SQLBACK\DB_backup.bak',
DISK = 'C:\SQLBACK\DB_backup2.bak'
with init, checksum, stats = 1


--#2.2 Restore simples
Use master 
go

RESTORE DATABASE DB FROM DISK = 'C:\SQLBACK\DB_backup.bak'
-- Tail log --

-- With Replace ignora o Tail log
RESTORE DATABASE DB FROM DISK = 'C:\SQLBACK\DB_backup.bak'
with replace

-------------------------------------------------------------------------------

--#3 Conceito de DEVICE

EXEC sp_addumpdevice 'DISK', 'DISCO_1', 'C:\SQLBACK\DB_BACKUP.DAT'

EXEC sp_helpdevice 'DISCO_1' -- Informações sobre o Device
EXEC sp_dropdevice 'DISCO_1' -- Apaga o device

BACKUP DATABASE DB TO DISK = 'C:\SQLBACK\DB_backup.DAT'
BACKUP DATABASE DB TO DISCO_1 



-- #3.1 Retorna informações sobre o Device

RESTORE VERIFYONLY FROM DISCO_1   -- Verificar se o device é válido

RESTORE HEADERONLY FROM DISCO_1   -- Mostrar Backups dentro do Device

RESTORE FILELISTONLY FROM DISCO_1 -- Mostrar os arquivos dentro do Backup


-- #3.2 Melhorando a visualização do Backup dentro do Device

BACKUP DATABASE DB TO DISCO_1 
with name = 'Backup DB - F1' ,
description = 'Backup DB - FULL',
init

RESTORE HEADERONLY FROM DISCO_1 

BACKUP DATABASE DB TO DISCO_1 
with name = 'Backup DB - F2' ,
description = 'Backup DB - FULL'

RESTORE HEADERONLY FROM DISCO_1 


-------------------------------------------------------------------------------

-- #4 - Backup do LOG - Básico

BACKUP LOG DB TO DISCO_1 
with name = 'Backup DB - L1' ,
description = 'Backup DB - LOG'

RESTORE HEADERONLY FROM DISCO_1 


-------------------------------------------------------------------------------
--#5 - Backup Diferencial

BACKUP DATABASE DB TO DISCO_1 
with name = 'Backup DB - D2' ,
description = 'Backup DB - Differential',
Differential

RESTORE HEADERONLY FROM DISCO_1 


-- Verificar os backups já feitos.
select * from msdb.dbo.backupset 

-------------------------------------------------------------------------------
--#6 - Trabalhando com MEDIA

BACKUP DATABASE DB TO DISCO_1 
with 
medianame = 'Segunda',
Mediadescription = 'Backup de Segunda',
name = 'Backup DB - F1' ,
description = 'Backup DB - FULL',
init

--ERROR 4037 - MEDIA Não EXISTE !!!

BACKUP DATABASE DB TO DISCO_1 
with 
medianame = 'Segunda',
Mediadescription = 'Backup de Segunda',
name = 'Backup DB - F1' ,
description = 'Backup DB - FULL',
FORMAT,
RETAINDAYS = 7

RESTORE HEADERONLY FROM DISCO_1 

--==============================================================================
-- PARTE 3 - RESTORE DE DATABASES - BÁSICO
--==============================================================================

--#1 - Criando o Banco

IF EXISTS (Select name from master.dbo.Sysdatabases where name = 'DB2')
DROP DATABASE DB2 
GO

CREATE DATABASE DB2
ON PRIMARY
(
NAME = 'DB2_DATA',
FILENAME = 'C:\SQLMOC\DB2_DATA.MDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
),
FILEGROUP FG2
(
NAME = 'DB2_DATA2',
FILENAME = 'C:\SQLMOC\DB2_DATA2.NDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
LOG ON
(
NAME = 'DB2_LOG',
FILENAME = 'C:\SQLMOC\DB2_LOG.LDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER DATABASE DB2 SET RECOVERY FULL
GO

---------------------------------------------------------------------------------

-- #2 Criando o Device 

EXEC sp_addumpdevice 'DISK', 'DISCO_2', 'C:\SQLBACK\DB_BACKUP2.DAT'

-- #3 Gerando Transações

USE DB2
GO

CREATE TABLE TAB_A
(
id int identity,
nome char(10)
)
go

INSERT TAB_A VALUES ('Afranio'),('Atadolfa'),('Neoclesina'),('Carabino')
go

-- #4 Backups

BACKUP DATABASE DB2 TO DISCO_2 
with name = 'Backup DB2 - F1' ,
description = 'Backup DB2 - FULL',
init

RESTORE HEADERONLY FROM DISCO_2

-- #5 - Restore após "Acidente"

-- #5.1 - Drop da Tabela
USE DB2
go

DROP TABLE TAB_A 
go

select * from TAB_A

--#5.2 - Restore

RESTORE HEADERONLY FROM DISCO_2

USE MASTER
go

RESTORE DATABASE DB2 FROM DISCO_2
go

RESTORE DATABASE DB2 FROM DISCO_2
with replace
go

Use DB2
go

select * from TAB_A

-- #6 - Novas Transações
USE DB2
go

CREATE TABLE TAB_B
(
id int identity,
nome varchar(10)
)

INSERT TAB_B VALUES ('Prod 1'), ('Prod 2'),('Prod 3'),('Prod 4')
go


-- #6.1 Backup FULL

BACKUP DATABASE DB2 TO DISCO_2 
with name = 'Backup DB2 - F1' ,
description = 'Backup DB2 - FULL',
init

RESTORE HEADERONLY FROM DISCO_2


BACKUP DATABASE DB2 TO DISCO_2 
with name = 'Backup DB2 - F2' ,
description = 'Backup DB2 - FULL'

RESTORE HEADERONLY FROM DISCO_2

-- #6.2 Novas transações 
 
INSERT TAB_B VALUES ('Prod 5'), ('Prod 6'),('Prod 7'),('Prod 8')
go

-- #6.3 Backup LOG 

BACKUP LOG DB2 TO DISCO_2 
with name = 'Backup DB2 - L1' ,
description = 'Backup DB2 - LOG'

RESTORE HEADERONLY FROM DISCO_2

-- #6.4 Novas transações 
 
INSERT TAB_B VALUES ('Prod 9'), ('Prod 10')
go

-- #6.5 Backup LOG 

BACKUP LOG DB2 TO DISCO_2 
with name = 'Backup DB2 - L2' ,
description = 'Backup DB2 - LOG'

RESTORE HEADERONLY FROM DISCO_2



-- #6.6 Novas transações 
 
INSERT TAB_B VALUES ('Prod 11'), ('Prod 12')
go

-- #6.7 Backup LOG 

BACKUP LOG DB2 TO DISCO_2 
with name = 'Backup DB2 - L3' ,
description = 'Backup DB2 - LOG'

RESTORE HEADERONLY FROM DISCO_2

-- #6.8 Backup DIFFERENTIAL

BACKUP DATABASE DB2 TO DISCO_2 
with name = 'Backup DB2 - D1' ,
description = 'Backup DB2 - DIFFERENTIAL',
DIFFERENTIAL

RESTORE HEADERONLY FROM DISCO_2


-- #6.9 Novas transações 
 
INSERT TAB_B VALUES ('Prod 13'), ('Prod 14')
go

-- #6.10 Backup LOG 

BACKUP LOG DB2 TO DISCO_2 
with name = 'Backup DB2 - L4' ,
description = 'Backup DB2 - LOG'

RESTORE HEADERONLY FROM DISCO_2


-- #6.11 Novas transações 
 
INSERT TAB_B VALUES ('Prod 15')
go


SELECT * FROM TAB_B 

select * from sys.sysdatabases

xp_readerrorlog 


--==============================================================================
-- ARQUIVO DE DADOS CORROMPIDO
-- BACKUP do TAIL LOG
--==============================================================================


-- Queries para ver o Status do banco
select * from sys.sysdatabases
go
select * from sys.databases
go


-- #7 - Estratégia de Restore

RESTORE HEADERONLY FROM DISCO_2  -- Garantido até o registro 14...

-- #7.1 Fazer o TAIL LOG

BACKUP LOG DB2 TO DISCO_2 
with name = 'Backup DB2 - L5' ,
description = 'Backup DB2 - TAIL LOG',
NO_TRUNCATE


RESTORE HEADERONLY FROM DISCO_2

-- #7.2 Definir a ordem de RESTORE

RESTORE DATABASE DB2 FROM DISCO_2
WITH FILE = 2,
NORECOVERY

RESTORE DATABASE DB2 FROM DISCO_2
WITH FILE = 6,
NORECOVERY

RESTORE LOG DB2 FROM DISCO_2
WITH FILE = 7,
NORECOVERY


RESTORE LOG DB2 FROM DISCO_2
WITH FILE = 8,
RECOVERY

RESTORE DATABASE DB2 WITH RECOVERY

USE DB2
go

select * from tab_b

--==============================================================================
-- RECOVERY DO LOG
-- Nesse cenário, vamos simular a perda do arquivo de log 
-- e o uso do banco em Mode de Emergência
--==============================================================================

--#1 Criar um banco para testes
create database DB_TESTE
ON
(
NAME = 'DB_TESTE_Data',
FILENAME = 'C:\SQLMOC\DB_TESTE.MDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
LOG ON
(
NAME = 'DB_TESTE_LOG',
FILENAME = 'C:\SQLMOC\DB_TESTE_LOG.LDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
go

--#2 Entrar no banco, criar e popular uma tabela
use DB_TESTE
go

create table TAB1
(
id int,
col1 varchar(30)
)

insert into TAB1 (id , col1 ) values 
(1,'dasdasd'), (2,'dsadas') 

-- ==========================================================
-- ****** APAGAR O ARQUIVO DE LOG ****** ---
-- Pare o serviço do SQL Server e apague o arquivo de log
-- ==========================================================

-- #3 Colocar o banco em modo de Emergência quando ele subir
use master 
go

alter database DB_TESTE set emergency


--#4 Para gerar um novo log

--#4.1 Colocar o banco em single_user
alter database DB_TESTE set single_user

--#4.2 Rodar o DBCC CHECKDB
dbcc checkdb ('DB_TESTE', REPAIR_ALLOW_DATA_LOSS)

--#4.3 Colocar o banco em Multi_user
alter database BF2 set multi_user

-- #4.4 Testat o uso do banco
use DB_TESTE
go

select * from TAB1 

--==============================================================================
-- PARTE 4 - RESTORE DE DATABASES - POINT IN TIME
--==============================================================================
Use master
go

--#1 - Criando o Banco

IF EXISTS (Select name from master.dbo.Sysdatabases where name = 'DB3')
DROP DATABASE DB3 
GO

CREATE DATABASE DB3
ON PRIMARY
(
NAME = 'DB3_DATA',
FILENAME = 'C:\SQLMOC\DB3_DATA.MDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
),
FILEGROUP FG2
(
NAME = 'DB3_DATA2',
FILENAME = 'C:\SQLMOC\DB3_DATA2.NDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
LOG ON
(
NAME = 'DB3_LOG',
FILENAME = 'C:\SQLMOC\DB3_LOG.LDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER DATABASE DB3 SET RECOVERY FULL
GO

-- #2 Gerando Transações

USE DB3
go

CREATE TABLE TAB_C
(
ID INT IDENTITY,
NOME CHAR(10)
)

INSERT TAB_C VALUES ('NOME 1'), ('NOME 2'), ('NOME 3'),('NOME 4'), ('NOME 5') 


-- #3 Criando o Device 

EXEC sp_addumpdevice 'DISK', 'DISCO_3', 'C:\SQLBACK\DB_BACKUP3.DAT'

-- #4 Backups

BACKUP DATABASE DB3 TO DISCO_3 
with name = 'Backup DB3 - F1' ,
description = 'Backup DB3 - FULL',
init

RESTORE HEADERONLY FROM DISCO_3


BACKUP LOG DB3 TO DISCO_3 
with name = 'Backup DB3 - L1' ,
description = 'Backup DB3 - LOG'

RESTORE HEADERONLY FROM DISCO_3


-- #5 Gerando Transações

INSERT TAB_C VALUES ('NOME 6'), ('NOME 7'), ('NOME 8'),('NOME 9'), ('NOME 10') 

-- #6 Backups

BACKUP LOG DB3 TO DISCO_3 
with name = 'Backup DB3 - L2' ,
description = 'Backup DB3 - LOG'


RESTORE HEADERONLY FROM DISCO_3


-- #7 Gerando Transações

INSERT TAB_C VALUES ('NOME 11'), ('NOME 12'), ('NOME 13'),('NOME 14'), ('NOME 15')

select * from TAB_C
-- ==============================================================================
---************************ ACIDENTE: APAGARAM A TABELA *************************
-- ==============================================================================

SELECT GETDATE()
DROP TABLE TAB_C 




-- 2016-04-30 11:17:36.760

-- #8 Consultar o TRANSACTION LOG

USE DB3 
go

CHECKPOINT

--#8.1 Função ::fn_dblog

SELECT * FROM ::fn_dblog(null,null)
where [Transaction Name] = 'DROPOBJ'

--#8.2 Trazer as ações da Transação que fez um 'DROPOBJ'

SELECT
	[Current LSN],
	[Operation],
	[Context],
	[Transaction ID],
	[Description],
	[Begin Time],
	[Transaction SID]
FROM
	fn_dblog (NULL, NULL),
	(SELECT
		[Transaction ID] AS [tid]
	FROM
		fn_dblog (NULL, NULL)
	WHERE
		[Transaction Name] LIKE '%DROPOBJ%') [fd]
WHERE
	[Transaction ID] = [fd].[tid];
GO

--#8.3
-- Salvar a LSN do LOP_BEGIN_XACT
-- log record:00000031:00000170:0001
-- 00000037:00000168:0001


-- Quem fez isso?
SELECT SUSER_SNAME (XX);
GO


--Número do [Transaction ID]
SELECT SUSER_SNAME(0x0105000000000005150000006D8CBB890F830AF10FE9AEDEF4010000)
go

---  Tudo que o User fez ?

SELECT
    [Current LSN],
    [Operation],
    [Transaction ID],
    [Begin Time],
    LEFT ([Description], 40) AS [Description]
FROM
    fn_dblog (NULL, NULL)
WHERE
    [Transaction SID] = SUSER_SID ('LONDON\Administrator')
AND ([Begin Time] > '2015/06/03 11:18:15' AND [Begin Time] < '2015/06/03 11:18:25');
GO

-- #9 Backups

BACKUP LOG DB3 TO DISCO_3 
with name = 'Backup DB3 - L3' ,
description = 'Backup DB3 - LOG'

RESTORE HEADERONLY FROM DISCO_3

--#10 Começar o RESTORE POINT IN TIME

USE MASTER
go

RESTORE DATABASE DB3 FROM DISCO_3
with file = 1, replace,
NORECOVERY


RESTORE LOG DB3 FROM DISCO_3
with file = 2,
NORECOVERY


RESTORE LOG DB3 FROM DISCO_3
with file = 3,
NORECOVERY

RESTORE LOG DB3 FROM DISCO_3
with file = 4,
RECOVERY,
STOPAT = '2016-04-30 11:17:36.759'




--#11 Testar
USE DB3
go

select * from TAB_C 
go



--==============================================================================
-- PARTE 5 - RESTORE DE FILE/FILEGROUP CORROMPIDO
--==============================================================================

--#1 - Criando o Banco
IF EXISTS (Select name from master.dbo.Sysdatabases where name = 'DB4')
DROP DATABASE DB4
GO

CREATE DATABASE DB4
ON PRIMARY
(
NAME = 'DB4_DATA',
FILENAME = 'C:\SQLMOC\DB4_DATA.MDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
),
FILEGROUP FG2
(
NAME = 'DB4_DATA2',
FILENAME = 'C:\SQLMOC\DB4_DATA2.NDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
LOG ON
(
NAME = 'DB4_LOG',
FILENAME = 'C:\SQLMOC\DB4_LOG.LDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER DATABASE DB4 SET RECOVERY FULL
GO

--#2 Criar o Device
EXEC sp_addumpdevice 'DISK', 'DISCO_4', 'C:\SQLBACK\DB_BACKUP4.DAT'

--#3 Criar a tabela
Use DB4 
go

CREATE TABLE TAB_D
(
ID int identity,
nome char(10)
) on FG2

INSERT TAB_D values ('Hypotenusa'), ('Malvina'), ('Mercedes')
go


-- #4 Backups

BACKUP DATABASE DB4 TO DISCO_4 
with name = 'Backup DB4 - F1' ,
description = 'Backup DB4 - FULL',
init

RESTORE HEADERONLY FROM DISCO_4

-- *********************************************************************************
-- PARAR O AMBIENTE --
-- apagar o arquivo DB4_data2 --
-- O banco fica INACESSÍVEL --
-- *********************************************************************************

EXEC sp_detach_db @dbname = N'DB4';
GO


BACKUP LOG DB4 TO DISCO_4 
with name = 'Backup DB4 - L1' ,
description = 'Backup DB4 - LOG',
NO_TRUNCATE


RESTORE HEADERONLY FROM DISCO_4

-- #5 Restore do arquivo

USE master 
go


RESTORE DATABASE DB4
file = 'DB4_DATA2',
FILEGROUP = 'FG2'
FROM DISCO_4
WITH NORECOVERY, REPLACE
go

restore log DB4
FROM DISCO_4
WITH file = 2, RECOVERY
GO

--#6 Testando a tabela

Use DB4
go

select * from TAB_D
go

--==============================================================================
-- PARTE 6 - RESTORE PARTIAL
--==============================================================================

/*
CENÁRIO DE ESTUDO:

O banco de dados DB5 tem 4 filegroups:
PRIMARY
FG2 - ReadWrite - High Priority
FG3 - ReadOnly
FG4 - ReadOnly - High Priority

O Filgroup Primary e FG2 parecem estar destruidos.

*/


--#1 - Criando o Banco
IF EXISTS (Select name from master.dbo.Sysdatabases where name = 'DB5')
DROP DATABASE DB5
GO

CREATE DATABASE DB5
ON PRIMARY
(
NAME = 'DB5_DATA',
FILENAME = 'C:\SQLMOC\DB5_DATA.MDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
),
FILEGROUP FG2
(
NAME = 'DB5_DATA2',
FILENAME = 'C:\SQLMOC\DB5_DATA2.NDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
,
FILEGROUP FG3
(
NAME = 'DB5_DATA3',
FILENAME = 'C:\SQLMOC\DB5_DATA3.NDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
,
FILEGROUP FG4
(
NAME = 'DB5_DATA4',
FILENAME = 'C:\SQLMOC\DB5_DATA4.NDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
LOG ON
(
NAME = 'DB5_LOG',
FILENAME = 'C:\SQLMOC\DB5_LOG.LDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER DATABASE DB5 SET RECOVERY FULL
GO

ALTER DATABASE DB5 MODIFY FILEGROUP FG3 READONLY
ALTER DATABASE DB5 MODIFY FILEGROUP FG4 READONLY

--#2 Criar o Device
EXEC sp_addumpdevice 'DISK', 'DISCO_5', 'C:\SQLBACK\DB_BACKUP5.DAT'


--#3 Gerar transações
USE DB5 
go


CREATE TABLE TAB_E
(
ID int identity,
Nome char(15)
) on FG2


INSERT TAB_E values ('Shakespere'), ('Van Gogh'), ('Beethoven'), ('Meryl Streep')


-- #4 Backups

BACKUP DATABASE DB5 TO DISCO_5 
with name = 'Backup DB5 - F1' ,
description = 'Backup DB5 - FULL',
init

RESTORE HEADERONLY FROM DISCO_5

BACKUP LOG DB5 TO DISCO_5 
with name = 'Backup DB5 - L1' ,
description = 'Backup DB5 - LOG'


-- *********************************************************************************
-- PARAR O AMBIENTE -- Modificar o arquivo do PRIMARY e FG2
-- *********************************************************************************

-- #5 Fazer o Tail Log após o serviço subir.
BACKUP LOG DB5 TO DISCO_5 
with name = 'Backup DB5 - L2' ,
description = 'Backup DB5 - TAILLOG',
NO_TRUNCATE

RESTORE HEADERONLY FROM DISCO_5


-- #6 Restore PARTIAL
USE MASTER 
go

RESTORE DATABASE DB5 FILEGROUP = 'Primary' FROM DISCO_5
WITH FILE = 1, PARTIAL, NORECOVERY, REPLACE

RESTORE LOG DB5 FROM DISCO_5
with FILE = 2, NORECOVERY

RESTORE LOG DB5 FROM DISCO_5
with FILE = 3, RECOVERY

-- Observe que a TABELA existe no banco, mas não está acessível, pois está em outro filegroup
USE DB5
go

select * from TAB_E 

select * from sys.database_files  -- Alguns arquivos ainda estão em Recovery_Pending)


--#7 Criar uma nova tabela no Primary para testá-lo.

CREATE TABLE TAB_F
(
ID int identity,
Nome char(15)
) 

INSERT TAB_F values ('Camões'), ('Salvador Dali'), ('Bach'), ('Susan Sarandon')

-- #6 Restore dos outros Filegroups 

select * from sys.database_files  -- Alguns arquivos ainda estão em Recovery_Pending)

USE MASTER
go

RESTORE DATABASE DB5 FILEGROUP = 'FG2', FILEGROUP = 'FG4' FROM DISCO_5
WITH NORECOVERY

RESTORE LOG DB5 FROM DISCO_5
with FILE = 2, NORECOVERY

RESTORE LOG DB5 FROM DISCO_5
with FILE = 3, RECOVERY

--#6.1 Testando o procedimento.

Use DB5
go

select * from sys.database_files

select * from TAB_E 
select * from TAB_F -- Não influenciou no restore feito no Filegroup PRIMARY

--#7 Restore dos FILEGROUPS menos relevantes

USE MASTER
go

RESTORE DATABASE DB5 FILEGROUP = 'FG3' FROM DISCO_5
WITH RECOVERY

-- #7.1 Verificando...

Use DB5
go

select * from sys.database_files


--==============================================================================
-- PARTE 7 - STAND_BY
--==============================================================================


--#1 - Criando o Banco

IF EXISTS (Select name from master.dbo.Sysdatabases where name = 'DB6')
DROP DATABASE DB6 
GO

CREATE DATABASE DB6
ON PRIMARY
(
NAME = 'DB6_DATA',
FILENAME = 'C:\SQLMOC\DB6_DATA.MDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
),
FILEGROUP FG2
(
NAME = 'DB6_DATA2',
FILENAME = 'C:\SQLMOC\DB6_DATA2.NDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
LOG ON
(
NAME = 'DB6_LOG',
FILENAME = 'C:\SQLMOC\DB6_LOG.LDF',
SIZE = 10MB,
FILEGROWTH = 70%,
MAXSIZE = 150MB
)
COLLATE SQL_Latin1_General_CP1_CI_AS
GO

ALTER DATABASE DB6 SET RECOVERY FULL
GO

-- #2 Gerando Transações

USE DB6
go

CREATE TABLE TAB_F
(
ID INT IDENTITY,
NOME CHAR(20)
)

INSERT TAB_F VALUES ('Clarice Lispector'), ('Portinari'), ('Chopin'),('Chaplin')


-- #3 Criando o Device 

EXEC sp_addumpdevice 'DISK', 'DISCO_6', 'C:\SQLBACK\DB_BACKUP6.DAT'

-- #4 Backups

BACKUP DATABASE DB6 TO DISCO_6 
with name = 'Backup DB6 - F1' ,
description = 'Backup DB6 - FULL',
init

RESTORE HEADERONLY FROM DISCO_6

BACKUP LOG DB6 TO DISCO_6
with name = 'Backup DB6 - L1' ,
description = 'Backup DB6 - LOG'


--#5 Transações
Use DB6
go

INSERT TAB_F VALUES ('Saramago'), ('Renoir'), ('Mozart'),('De Niro')

BACKUP LOG DB6 TO DISCO_6
with name = 'Backup DB6 - L2' ,
description = 'Backup DB6 - LOG'

INSERT TAB_F VALUES ('Drummond'), ('Cézzanne'), ('Strauss'),('Sean Connery')

BACKUP LOG DB6 TO DISCO_6
with name = 'Backup DB6 - L3' ,
description = 'Backup DB6 - LOG'

INSERT TAB_F VALUES ('Alexandre Dumas'), ('Rembrandt'), ('Tchaikovsky'),('Morgan Freeman')

BACKUP LOG DB6 TO DISCO_6
with name = 'Backup DB6 - L4' ,
description = 'Backup DB6 - LOG'


--#6 RESTORE WITH STANDBY

RESTORE HEADERONLY FROM DISCO_6

-- Primeira parte 
USE MASTER
go

RESTORE DATABASE DB6 FROM DISCO_6
with FILE = 1, STANDBY = 'C:\SQLBACK\undo.ldf', REPLACE
go

USE DB6
GO

SELECT * FROM TAB_F

-- Segunda parte 

RESTORE HEADERONLY FROM DISCO_6

USE MASTER
go

RESTORE LOG DB6 FROM DISCO_6
with FILE = 2, STANDBY = 'C:\SQLBACK\undo.ldf'
go

USE DB6
GO

SELECT * FROM TAB_F

-- Terceira parte 

RESTORE HEADERONLY FROM DISCO_6

USE MASTER
go

RESTORE LOG DB6 FROM DISCO_6
with FILE = 3, STANDBY = 'C:\SQLBACK\undo.ldf'
go

USE DB6
GO

SELECT * FROM TAB_F

-- Quarta parte 

RESTORE HEADERONLY FROM DISCO_6

USE MASTER
go

RESTORE LOG DB6 FROM DISCO_6
with FILE = 4, STANDBY = 'C:\SQLBACK\undo.ldf'
go

USE DB6
GO

SELECT * FROM TAB_F

-- Quinta parte 

RESTORE HEADERONLY FROM DISCO_6

USE MASTER
go

RESTORE LOG DB6 FROM DISCO_6
with FILE = 5, STANDBY = 'C:\SQLBACK\undo.ldf'
go

USE DB6
GO

SELECT * FROM TAB_F


--#7 RETIRAR DO STANDBY

Use MASTER
go

RESTORE DATABASE DB6 WITH RECOVERY


-- *****************************************************************************************
-- *****************************************************************************************
--									LIMPANDO O SERVIDOR
-- *****************************************************************************************
-- *****************************************************************************************
USE MASTER
GO

IF EXISTS (Select name from master.dbo.Sysdatabases where name = 'DB')
DROP DATABASE DB
GO


IF EXISTS (Select name from master.dbo.Sysdatabases where name = 'DB2')
DROP DATABASE DB2
GO


IF EXISTS (Select name from master.dbo.Sysdatabases where name = 'DB3')
DROP DATABASE DB3
GO


IF EXISTS (Select name from master.dbo.Sysdatabases where name = 'DB4')
DROP DATABASE DB4
GO


IF EXISTS (Select name from master.dbo.Sysdatabases where name = 'DB5')
DROP DATABASE DB5 
GO


IF EXISTS (Select name from master.dbo.Sysdatabases where name = 'DB6')
DROP DATABASE DB6 
GO

IF EXISTS (Select name from master.dbo.Sysdatabases where name = 'DB7')
DROP DATABASE DB7 
GO


EXEC sp_dropdevice 'DISCO_1' 
EXEC sp_dropdevice 'DISCO_2' 
EXEC sp_dropdevice 'DISCO_3' 
EXEC sp_dropdevice 'DISCO_4' 
EXEC sp_dropdevice 'DISCO_5' 
EXEC sp_dropdevice 'DISCO_6' 

/****************************************
MASTER
*******************************************/

-- Demo script for Restoring Master demo.

-- Ensure the Company database does not exist
USE [master];
GO

	DROP DATABASE [Company];


-- Create a backup of the master database
BACKUP DATABASE [master]
TO DISK = N'c:\TTT\Master.bck'
WITH INIT;

-- Create another database
CREATE DATABASE [Company] ON PRIMARY (
    NAME = N'Company',
    FILENAME = N'c:\TTT\Company.mdf')
LOG ON (
    NAME = N'Company_log',
    FILENAME = N'c:\TTT\Company_log.ldf',
    SIZE = 5MB,
    FILEGROWTH = 1MB);
GO

USE [Company];
GO

CREATE TABLE [RandomData] (
	[c1]  INT IDENTITY,
	[c2]  CHAR (8000) DEFAULT 'a');
GO

INSERT INTO [RandomData] DEFAULT VALUES;
GO 100

-- Now imagine that master is corrupt in some way

-- Save as much system information as possible
-- For example:
SELECT * FROM sys.configurations;
GO

-- Now in configuration manager restart the server
-- with the -m flag

-- Restore master using the following
-- If you cannot connect, make sure SSMS is not
-- connected through Object Explorer
RESTORE DATABASE [master]
FROM DISK = N'c:\TTT\Master.bck'
WITH REPLACE;
GO




-- When the server shuts down, remove -m and restart

-- Try to access Company database
USE [Company];
GO

-- We need to re-attach or restore it
CREATE DATABASE [Company] ON
    (NAME = N'Company',
	FILENAME = N'c:\TTT\Company.mdf'),
	(NAME = N'Company_log',
	FILENAME = N'c:\TTT\Company_log.ldf')
FOR ATTACH;
GO

