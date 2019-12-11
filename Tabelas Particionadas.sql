
XP_create_subdir 'c:\partition'

-- Criação do banco de dados para o Particionamento de Tabelas

xp_create_subdir 'c:\partition'

CREATE DATABASE partition_table
on Primary
(
name = 'db_data',
filename = 'c:\partition\db_data.mdf',
size = 3,
filegrowth = 10%,
maxsize = 10
),
filegroup FG1
(
name = 'FG1_data',
filename = 'c:\partition\FG1Data.ndf',
size = 3,
filegrowth = 10%,
maxsize = 10
),
filegroup FG2
(
name = 'FG2_data',
filename = 'c:\partition\FG2Data.ndf',
size = 3,
filegrowth = 10%,
maxsize = 10
),
filegroup FG3
(
name = 'FG3_data',
filename = 'c:\partition\FG3Data.ndf',
size = 3,
filegrowth = 10%,
maxsize = 10
),
filegroup FG4
(
name = 'FG4_data',
filename = 'c:\partition\FG4Data.ndf',
size = 3,
filegrowth = 10%,
maxsize = 10
),
filegroup FG5
(
name = 'FG5_data',
filename = 'c:\partition\FG5Data.ndf',
size = 3,
filegrowth = 10%,
maxsize = 10
),
filegroup FG6
(
name = 'FG6_data',
filename = 'c:\partition\FG6Data.ndf',
size = 3,
filegrowth = 10%,
maxsize = 10
)

LOG ON 
(
name = 'db_log',
filename = 'c:\partition\dblog.ldf',
size = 3,
filegrowth = 10%,
maxsize = 10
)

Use partition_table
go

-- Criar a function da partição

CREATE PARTITION FUNCTION fn_partition (int)
AS RANGE LEFT FOR VALUES (10,20,30,40)
GO

/*

LEFT
------ 10
11 -20
21-30
31-40
>40

RIGHT
------9
10-19
20-29
30-39
>=40

*/


-- Criar o scheme

-- #1 Colocando uma range em cada filegroup
CREATE PARTITION SCHEME sch_partition 
AS PARTITION fn_partition
TO ([FG1],[FG2],[FG3],[FG4],[FG5])
GO

-- #2 Colocando todas as ranges em um único filegroup



-- Criando uma tabela usando o Particionamento

CREATE TABLE TAB_1
(
id int primary key clustered,
descricao char(5) default 'teste'
) 
ON sch_partition (id)


select * from sys.partitions
where object_id = OBJECT_ID('TAB_1')



-- Popular a tabela

declare @var int
set @var = 1
while @var <=40
begin
	insert into TAB_1(id) SELECT @var
	SET @var = @var+1
END
GO 


select * from TAB_1

select * from sys.partitions
where object_id = OBJECT_ID('TAB_1')



-- Pesquisando as partições


-- Em qual partição está certo registro
SELECT $partition.fn_partition (35) as NumeroParticao


-- Retorna os registros de uma partição
SELECT * from TAB_1
WHERE $partition.fn_partition (id) = 2





-- Acrescentar uma nova partição

ALTER PARTITION SCHEME sch_partition
NEXT USED [FG6]


ALTER PARTITION FUNCTION fn_partition ()
SPLIT RANGE (60)

INSERT INTO TAB_1 (ID) VALUES (46)

INSERT INTO TAB_1 (ID) VALUES (55)

INSERT INTO TAB_1 (ID) VALUES (70)

select * from sys.partitions
where object_id = OBJECT_ID('TAB_1')

-- Removendo uma partição

ALTER PARTITION FUNCTION fn_partition ()
MERGE RANGE (60)



-- Em qual partição está certo registro
SELECT $partition.fn_partition (70) as NumeroParticao


-- Retorna os registros de uma partição
SELECT * from TAB_1
WHERE $partition.fn_partition (id) = 3


-- ************************************************************


-- Criar a function da partição

CREATE PARTITION FUNCTION fn_partition2 (int)
AS RANGE LEFT FOR VALUES (10,20,30,40)
GO

-- Criar o scheme

-- #1 Colocando uma range em cada filegroup
CREATE PARTITION SCHEME sch_partition2 
AS PARTITION fn_partition2
TO ([FG1],[FG2],[FG3],[FG4],[FG5])
GO



-- CRAINDO UMA NOVA TABELA

CREATE TABLE TAB_2
(
ID int primary key clustered,
descricao char(5) default 'test2'
) 
ON sch_partition2 (id)


INSERT INTO TAB_2 (ID) VALUES (12)

INSERT INTO TAB_2 (ID) VALUES (29)

INSERT INTO TAB_2 (ID) VALUES (42)



ALTER TABLE TAB_1
SWITCH PARTITION 1 TO TAB_2 PARTITION 1



select * from sys.partitions
where object_id = OBJECT_ID('TAB_1')



select * from sys.partitions
where object_id = OBJECT_ID('TAB_2')


-- migrar para uma tabela nova
CREATE TABLE TAB_3
(
ID int primary key clustered,
descricao char(5) default 'test3'
) on [FG1]



ALTER TABLE TAB_1
SWITCH PARTITION 1
TO dbo.TAB_3


select * from TAB_1

select * from TAB_4


