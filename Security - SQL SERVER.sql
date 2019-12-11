/*****************************************************************
LOGINS
******************************************************************/

USE AdventureWorks2016 
go
DROP USER USER1
go
DROP USER USER2

USE MASTER
go
DROP LOGIN LOGIN1;
DROP LOGIN LOGIN2;




/***************************************************************************
TRABALAHNDO COM LOGINS
****************************************************************************/

-- #1 Criando um Login simples

CREATE LOGIN LOGIN1 WITH PASSWORD = 'P@ssw0rd' MUST_CHANGE, CHECK_POLICY =ON,
CHECK_EXPIRATION =ON, DEFAULT_DATABASE = [AdventureWorks2016]
GO

CREATE LOGIN LOGIN2 WITH PASSWORD = 'P@ssw0rd' MUST_CHANGE, CHECK_POLICY =ON,
CHECK_EXPIRATION =ON, DEFAULT_DATABASE = [AdventureWorks2016], DEFAULT_LANGUAGE = [Portuguese]
GO



/* 
Ter um login criado com default_database não significa ter acesso ao banco
*/

---------------------------------------------------
-- 1.1 Adicionar o Login a Server Role Sysadmin
sp_addsrvrolemember 'LOGIN1', 'sysadmin'

ALTER SERVER ROLE SYSADMIN ADD MEMBER LOGIN1


---------------------------------------------------
-- Será que eu sou SYSADMIN ?
select IS_SRVROLEMEMBER ('sysadmin')


---------------------------------------------------
-- removendo um Login da Role SYSADMIN
sp_dropsrvrolemember 'LOGIN1', 'sysadmin'

ALTER SERVER ROLE SYSADMIN DROP MEMBER LOGIN1
--------------------------------------------------------------
-- Lista de Permissões que são possíveis através de comandos
Select * from sys.fn_builtin_permissions ('SERVER') 


----------------------------------------------
-- Desativando um login
ALTER LOGIN LOGIN2 DISABLE  -- ENABLE

select * from sys.sql_logins where is_disabled = 1


-- 2) Habilitar o user Guest no banco

Use AdventureWorks2016 
go

GRANT CONNECT TO guest

-- Como não é uma boa prática de segurança, devemos desabilitar
DENY CONNECT TO guest




-- =======================================
-- BEST PRACTICES - RENOMEAR A CONTA SA  
-- =======================================

ALTER LOGIN sa WITH NAME = VIP
GO

select * from sys.syslogins 


/*****************************************************************
USERS
******************************************************************/
Use AdventureWorks2016 
go

CREATE USER USER1 FOR LOGIN LOGIN1

CREATE USER USER2 FOR LOGIN LOGIN2

-- Verificar se tem acesso ao Servidor
SELECT HAS_DBACCESS ('AdventureWorks2016')

-- Lista de USERS e ROLEs no banco
SELECT * from sys.database_principals 



--=================================
-- IMPERSONATE
--=================================

SELECT SUSER_SNAME(), USER_NAME()
GO

USE AdventureWorks2016
GO
SELECT * FROM sys.sysobjects
GO

-- Alterando o Contexto

EXECUTE AS USER = 'USER1'
GO
-- ...
SELECT * FROM sys.objects
GO

REVERT
GO
SELECT SUSER_SNAME(), USER_NAME(), ORIGINAL_LOGIN()
GO


-- Grant SELECT em Production.Document para USER1

GRANT SELECT,INSERT ON Production.Document TO USER1
GO

EXECUTE AS USER = 'USER1'
GO
-- ...
SELECT * FROM sys.objects where type = 'U'
GO

SELECT * FROM Production.Document

REVERT
GO

/*
GRANT IMPERSONATE ON LOGIN::LOGIN2 TO [LOGIN1] ;
GO 

GRANT IMPERSONATE ON USER::USER2 TO [USER1] ;
GO 

SELECT HAS_PERMS_BY_NAME ('Production.Product','OBJECT','INSERT')
go


*/

-- =========================
-- Permissões em Schemas
-- =========================

-- Permissões no Schema Production 
GRANT SELECT ON SCHEMA::Production TO USER1
GO

EXECUTE AS USER = 'USER1'
GO

SELECT * FROM sys.objects
REVERT
GO

-- ============================
-- Permissões em todo DATABASE
-- ============================

GRANT SELECT ON DATABASE::AdventureWorks2016 TO USER1
GO

EXECUTE AS USER = 'USER1'
GO
SELECT * FROM sys.objects
REVERT
GO

-- =========================================
-- Retirando permissão de VIEW DEFINITION
-- =========================================

DENY VIEW DEFINITION TO USER1
GO

EXECUTE AS USER = 'USER1'
GO
SELECT * FROM Production.Document
REVERT
GO


-- ==========================================
-- Retirando permissão de VIEW ANY DATABASE
-- ==========================================
USE master 
go

DENY VIEW ANY DATABASE TO LOGIN1
go

-- ...

USE AdventureWorks2016 
go

EXECUTE AS USER = 'USER1'
GO

SELECT * FROM sys.objects  --Não vê os metadados, mas ainda vê a tabela
SELECT * FROM Production.Document
REVERT
GO


-- Revogando as permissões do VIEW DEFINITION
REVOKE VIEW DEFINITION FROM USER1
GO

-- Revogando as permissões do VIEW ANY DATABASE
USE master 
go

REVOKE VIEW ANY DATABASE TO LOGIN1
go

-- Executando no contexto de USER1

USE AdventureWorks2016
go

EXECUTE AS USER = 'USER1'
GO
SELECT * FROM sys.objects
go
SELECT * FROM Production.Document
go
REVERT
GO

-- Revogando a permissão no banco, mas o conteúdo do Schema ainda pode ser visto
REVOKE SELECT ON DATABASE::AdventureWorks2016 FROM USER1
GO
EXECUTE AS USER = 'USER1'
GO
SELECT * FROM sys.objects
GO
SELECT * FROM Production.Document
GO

REVERT
GO
SELECT SUSER_SNAME(), USER_NAME()
GO

-- Remove a permissão de SELECT do schema
-- Por ter acesso à tabela Production.Document, em view Definition aparecem os objetos
 
REVOKE SELECT ON SCHEMA::Production FROM USER1
GO
EXECUTE AS USER = 'USER1'
GO
SELECT * FROM sys.objects
REVERT
GO

-- Removendo o SELECT da tabela
REVOKE SELECT ON Production.Document FROM USER1
GO
EXECUTE AS USER = 'USER1'
GO
SELECT * FROM sys.objects
REVERT
GO

-- ======================================
-- Permissões em colunas
-- ======================================

Use AdventureWorks2016 
go

GRANT SELECT (City, PostalCode) on [Person].[Address] to USER1
go

EXECUTE AS USER = 'USER1'
GO


SELECT * FROM [Person].[Address] 
GO

SELECT City, PostalCode FROM [Person].[Address] 
GO

REVERT
GO

REVOKE SELECT (City, PostalCode) on [Person].[Address] to USER1
GO


-- ======================================
-- Trabalhando com Database Role
-- ======================================
Use AdventureWorks2016 
go

CREATE ROLE TESTERS
GO

sp_addrolemember 'TESTERS','USER1'

-- Sabendo se o User pertence a uma role
SELECT IS_MEMBER ('TESTERS')


-- ===========================================
-- CRIANDO APPLICATION ROLES
-- ===========================================

create application role App1
with password = 'P@ssw0rd'


use AdventureWorks2016
go

declare @context varbinary(8000)
exec sp_setapprole 'App1', 'P@ssw0rd',@fCreateCookie = true, @cookie = @context OUTPUT

select CURRENT_USER

exec sp_unsetapprole @context

select CURRENT_USER




-- ======================================
-- Trabalhando com DENY
-- ======================================


--#1 DENY na ROLE e GRANT na TABELA
GRANT SELECT ON  [Person].[Address] TO USER1
go

DENY SELECT ON [Person].[Address] TO TESTERS
go

EXECUTE as user = 'USER1'
go

select * from [Person].[Address] 
go

REVERT
go

--------------------------------------------
-- RESULTADO: O Deny vence !
--------------------------------------------

--#2 DENY na TABELA e GRANT na ROLE

REVOKE SELECT ON [Person].[Address] TO USER1
REVOKE SELECT ON [Person].[Address] TO TESTERS


DENY SELECT ON [Person].[Address] TO USER1 
GRANT SELECT ON [Person].[Address] TO TESTERS

EXECUTE as user = 'USER1'
go

select * from [Person].[Address] 
go
REVERT
go

--------------------------------------------
-- RESULTADO: O Deny vence !
--------------------------------------------

--#3 DENY na TABELA e GRANT nas COLUNAS

REVOKE SELECT ON [Person].[Address] TO USER1
REVOKE SELECT ON [Person].[Address] TO TESTERS

-- a)
DENY SELECT ON [Person].[Address] TO USER1 
GRANT SELECT (City, PostalCode) on [Person].[Address] to USER1

EXECUTE as user = 'USER1'
go

select * from [Person].[Address] 
go

select City, PostalCode from [Person].[Address] 
go

REVERT
go


--------------------------------------------
-- RESULTADO: GRANT das colunas ganham
--------------------------------------------

http://technet.microsoft.com/en-us/library/ms188338.aspx

/*
A table-level DENY does not take precedence over a column-level GRANT. 
This inconsistency in the permissions hierarchy has been preserved for t
he sake of backward compatibility. 

It will be removed in a future release.
*/


-- b)

REVOKE SELECT ON [Person].[Address] TO USER1 
REVOKE SELECT (City, PostalCode) on [Person].[Address] to USER1


GRANT SELECT (City, PostalCode) on [Person].[Address] to USER1
DENY SELECT ON [Person].[Address] TO USER1 




EXECUTE as user = 'USER1'
go

select * from [Person].[Address] 
go
select City,PostalCode  from [Person].[Address] 
go

REVERT
go


--------------------------------------------
-- RESULTADO: o DENY ganha.
--------------------------------------------

REVOKE SELECT ON [Person].[Address] TO USER1 
REVOKE SELECT (City, PostalCode) on [Person].[Address] to USER1


--**********************************************************************************
-- ADMINISTRAÇÃO DE SEGURANÇA
--**********************************************************************************

-- #1 Permissões na Instância
SELECT * FROM fn_my_permissions (null,'SERVER')

-- #2 Permissões em um BANCO
SELECT * FROM fn_my_permissions ('AdventureWorks2016','DATABASE')

-- #3 Permissões em um OBJETO
SELECT * FROM fn_my_permissions ('Production.Product','OBJECT')

-- #4 Permissões em um SCHEMA
SELECT * FROM fn_my_permissions ('Production','SCHEMA')

-- #5 Listar as permissões de um USER qualquer
Use AdventureWorks2016
go
EXECUTE as user = 'USER1';
go
SELECT * FROM fn_my_permissions ('Production.Document','OBJECT')
go

REVERT
go


--#6 Consultando usuários órfãos
sp_change_users_login @Action='Report'


--#7 Faz um LINK entre USER e LOGIN
-- sp_change_users_login 'Update_One', 'USER', 'LOGIN'
EXEC sp_change_users_login 'Update_One', 'USER2', 'LOGIN2'


--#8 Cria um LOGIN com os mesmo nome do USER.
EXEC sp_change_users_login 'Auto_Fix', 'USER2', NULL, 'P@ssw0rd'


--#9 Mudar proprietário do banco
ALTER AUTHORIZATION ON DATABASE::AdventureWorks2016 to sa


--#10 Criar USER WITHOUT LOGIN
USE AdventureWorks2016;

CREATE USER CustomApp WITHOUT LOGIN ;
go














----------------------------------------------

USE [AdventureWorks20162012]
 GO
-- Step 1 : Login using the SA
 -- Step 2 : Create Login Less User
CREATE USER [testguest] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
 GO
-- Step 3 : Checking access to Tables
SELECT *
FROM sys.tables;
-- Step 4 : Changing the execution context
EXECUTE AS USER   = 'testguest';
GO
-- Step 5 : Checking access to Tables
SELECT *
FROM sys.tables;
GO
-- Step 6 : Reverting Permissions
REVERT;
-- Step 7 : Giving more Permissions to testguest user
GRANT SELECT ON [dbo].[ErrorLog] TO [testguest];
GRANT SELECT ON [dbo].[DatabaseLog] TO [testguest];
GO
-- Step 8 : Changing the execution context
EXECUTE AS USER   = 'testguest';
GO
-- Step 9 : Checking access to Tables
SELECT *
FROM sys.tables;
GO
-- Step 10 : Reverting Permissions
REVERT;
GO
-- Step 11: Clean up
DROP USER [testguest]Step 3
 GO





/****************************************************************
C2
****************************************************************/

sp_configure 'C2 audit mode', 1
reconfigure with override

/****************************************************************
DDL Triggers
****************************************************************/

use AdventureWorks2016 
go

create table tab_a
(
id int
)

CREATE TRIGGER ProtegeTab
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
	PRINT 'Você não pode apagar ou alterar tabela AQUI !'
ROLLBACK;


DROP TABLE tab_a

DROP TRIGGER ProtegeTab

--

IF EXISTS (SELECT * FROM sys.server_triggers
    WHERE name = 'EvitarDROPDB')
DROP TRIGGER EvitarDROPDB
ON ALL SERVER
GO

CREATE TRIGGER EvitarDROPDB 
ON ALL SERVER 
FOR CREATE_DATABASE 
AS 
    PRINT 'Database Não pode ser criado.'
    ROLLBACK;
GO
DROP TRIGGER EvitarDROPDB
ON ALL SERVER
GO




-- ===================================================
-- TRANSPARENT DATA ENCRYPTION
-- ===================================================

-- Infraestrutura no MASTER

Use master 
go

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'P@ssw0rd'

CREATE CERTIFICATE LONDON_CERT WITH SUBJECT = 'London Certificate for TDE'


BACKUP CERTIFICATE LONDON_CERT TO FILE = 'C:\CERT\LONDON_CERT.CER'
WITH PRIVATE KEY (FILE = 'C:\CERT\LONDON_CERT.KEY', ENCRYPTION BY PASSWORD = 'P@ssw0rd')


-- Criptografia no banco
-- Criando a chave no banco
use AdventureWorks2016 
go

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE LONDON_CERT


ALTER DATABASE AdventureWorks2016
SET ENCRYPTION ON
GO


