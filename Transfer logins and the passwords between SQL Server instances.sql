
/*******************************************************************************************
Transferir LOGINS e SENHAS de uma INSTANCIA a outra
********************************************************************************************/

-- ETAPAS:

-- ======================================================================================
-- #1 On PRIMEIRO servidor, inicie SQL Server Management Studio, 
-- e conecte à INSTANCIA.
-- ======================================================================================

-- ======================================================================================
-- #2 Criar a PROCEDURE sp_hexadecimal e sp_help_revlogin no banco MASTER
-- ======================================================================================
 USE master
 GO
 IF OBJECT_ID ('sp_hexadecimal') IS NOT NULL
   DROP PROCEDURE sp_hexadecimal
 GO
 CREATE PROCEDURE sp_hexadecimal
     @binvalue varbinary(256),
     @hexvalue varchar (514) OUTPUT
 AS
 DECLARE @charvalue varchar (514)
 DECLARE @i int
 DECLARE @length int
 DECLARE @hexstring char(16)
 SELECT @charvalue = '0x'
 SELECT @i = 1
 SELECT @length = DATALENGTH (@binvalue)
 SELECT @hexstring = '0123456789ABCDEF'
 WHILE (@i <= @length)
 BEGIN
   DECLARE @tempint int
   DECLARE @firstint int
   DECLARE @secondint int
   SELECT @tempint = CONVERT(int, SUBSTRING(@binvalue,@i,1))
   SELECT @firstint = FLOOR(@tempint/16)
   SELECT @secondint = @tempint - (@firstint*16)
   SELECT @charvalue = @charvalue +
     SUBSTRING(@hexstring, @firstint+1, 1) +
     SUBSTRING(@hexstring, @secondint+1, 1)
   SELECT @i = @i + 1
 END

SELECT @hexvalue = @charvalue
 GO

IF OBJECT_ID ('sp_help_revlogin') IS NOT NULL
   DROP PROCEDURE sp_help_revlogin
 GO
 CREATE PROCEDURE sp_help_revlogin @login_name sysname = NULL AS
 DECLARE @name sysname
 DECLARE @type varchar (1)
 DECLARE @hasaccess int
 DECLARE @denylogin int
 DECLARE @is_disabled int
 DECLARE @PWD_varbinary  varbinary (256)
 DECLARE @PWD_string  varchar (514)
 DECLARE @SID_varbinary varbinary (85)
 DECLARE @SID_string varchar (514)
 DECLARE @tmpstr  varchar (1024)
 DECLARE @is_policy_checked varchar (3)
 DECLARE @is_expiration_checked varchar (3)

DECLARE @defaultdb sysname

IF (@login_name IS NULL)
   DECLARE login_curs CURSOR FOR

      SELECT p.sid, p.name, p.type, p.is_disabled, p.default_database_name, l.hasaccess, l.denylogin FROM 
 sys.server_principals p LEFT JOIN sys.syslogins l
       ON ( l.name = p.name ) WHERE p.type IN ( 'S', 'G', 'U' ) AND p.name <> 'sa'
 ELSE
   DECLARE login_curs CURSOR FOR


       SELECT p.sid, p.name, p.type, p.is_disabled, p.default_database_name, l.hasaccess, l.denylogin FROM 
 sys.server_principals p LEFT JOIN sys.syslogins l
       ON ( l.name = p.name ) WHERE p.type IN ( 'S', 'G', 'U' ) AND p.name = @login_name
 OPEN login_curs

FETCH NEXT FROM login_curs INTO @SID_varbinary, @name, @type, @is_disabled, @defaultdb, @hasaccess, @denylogin
 IF (@@fetch_status = -1)
 BEGIN
   PRINT 'No login(s) found.'
   CLOSE login_curs
   DEALLOCATE login_curs
   RETURN -1
 END
 SET @tmpstr = '/* sp_help_revlogin script '
 PRINT @tmpstr
 SET @tmpstr = '** Generated ' + CONVERT (varchar, GETDATE()) + ' on ' + @@SERVERNAME + ' */'
 PRINT @tmpstr
 PRINT ''
 WHILE (@@fetch_status <> -1)
 BEGIN
   IF (@@fetch_status <> -2)
   BEGIN
     PRINT ''
     SET @tmpstr = '-- Login: ' + @name
     PRINT @tmpstr
     IF (@type IN ( 'G', 'U'))
     BEGIN -- NT authenticated account/group

      SET @tmpstr = 'CREATE LOGIN ' + QUOTENAME( @name ) + ' FROM WINDOWS WITH DEFAULT_DATABASE = [' + @defaultdb + ']'
     END
     ELSE BEGIN -- SQL Server authentication
         -- obtain password and sid
             SET @PWD_varbinary = CAST( LOGINPROPERTY( @name, 'PasswordHash' ) AS varbinary (256) )
         EXEC sp_hexadecimal @PWD_varbinary, @PWD_string OUT
         EXEC sp_hexadecimal @SID_varbinary,@SID_string OUT

        -- obtain password policy state
         SELECT @is_policy_checked = CASE is_policy_checked WHEN 1 THEN 'ON' WHEN 0 THEN 'OFF' ELSE NULL END FROM sys.sql_logins WHERE name = @name
         SELECT @is_expiration_checked = CASE is_expiration_checked WHEN 1 THEN 'ON' WHEN 0 THEN 'OFF' ELSE NULL END FROM sys.sql_logins WHERE name = @name

            SET @tmpstr = 'CREATE LOGIN ' + QUOTENAME( @name ) + ' WITH PASSWORD = ' + @PWD_string + ' HASHED, SID = ' + @SID_string + ', DEFAULT_DATABASE = [' + @defaultdb + ']'

        IF ( @is_policy_checked IS NOT NULL )
         BEGIN
           SET @tmpstr = @tmpstr + ', CHECK_POLICY = ' + @is_policy_checked
         END
         IF ( @is_expiration_checked IS NOT NULL )
         BEGIN
           SET @tmpstr = @tmpstr + ', CHECK_EXPIRATION = ' + @is_expiration_checked
         END
     END
     IF (@denylogin = 1)
     BEGIN -- login is denied access
       SET @tmpstr = @tmpstr + '; DENY CONNECT SQL TO ' + QUOTENAME( @name )
     END
     ELSE IF (@hasaccess = 0)
     BEGIN -- login exists but does not have access
       SET @tmpstr = @tmpstr + '; REVOKE CONNECT SQL TO ' + QUOTENAME( @name )
     END
     IF (@is_disabled = 1)
     BEGIN -- login is disabled
       SET @tmpstr = @tmpstr + '; ALTER LOGIN ' + QUOTENAME( @name ) + ' DISABLE'
     END
     PRINT @tmpstr
   END

  FETCH NEXT FROM login_curs INTO @SID_varbinary, @name, @type, @is_disabled, @defaultdb, @hasaccess, @denylogin
    END
 CLOSE login_curs
 DEALLOCATE login_curs
 RETURN 0
 GO

-- ======================================================================================
-- #3  Rodar a procedure sp_help_revlogin 

 /* 
 O resultado do script gerado pela sp_help_revlogin stored procedure é o login script. 
 Esse login script cria os logins que têm o Security Identifier (SID)  ORIGINAL
 e a senha ORIGINAL.

 */

 EXEC sp_help_revlogin

 -- ======================================================================================

 -- ======================================================================================
 -- #4 No servidor DESTINO, abrir o SQL Server Management Studio, 
 -- e conectar à INSTANCIA.
 -- ======================================================================================

 -- ======================================================================================
-- #5. Abrir o LOGIN SCRIPT e RODAR
-- ======================================================================================
 
 /* sp_help_revlogin script 
** Generated Aug 26 2013  3:57PM on LONDON */
 
 
-- Login: LOGIN1
CREATE LOGIN [LOGIN1] WITH PASSWORD = 0x02006A76B52A0CF1F4A64090016735875749A8B3793D22657CC4420F209924EA02BE1BDCEC7A8AAC5F9279D7E1C870ACFC5F89291891DAC5AE768F9E051C424DB4E26D2620C7 HASHED, SID = 0xC4DA71D452FE244594A8978218C4B446, DEFAULT_DATABASE = [AdventureWorks], CHECK_POLICY = ON, CHECK_EXPIRATION = ON
 
-- Login: LOGIN2
CREATE LOGIN [LOGIN2] WITH PASSWORD = 0x020076B6D1EAC014EC09BEC0887436B24A6CB0959F58B52106E394512BDD42561942FA33E278A2A55526EA60AA28AEE033D9521029EFB36506C59D706DF8EBD5BE0CF697D450 HASHED, SID = 0x9E0317036B9CF84E850FE421F60F91C0, DEFAULT_DATABASE = [AdventureWorks], CHECK_POLICY = ON, CHECK_EXPIRATION = ON



