

/***********************************************************************
CREATE A BASELINE DATABASE
***********************************************************************/

CREATE DATABASE [BaselineData]
go


USE [BaselineData];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [dbo].[PerfMonData] (
	[Counter] NVARCHAR(770),
	[Value] DECIMAL(38,2),
	[CaptureDate] DATETIME,
	) ON [PRIMARY];
GO


CREATE CLUSTERED INDEX CI_PerfMonData ON [dbo].[PerfMonData] ([CaptureDate],[Counter]);
CREATE NONCLUSTERED INDEX IX_PerfMonData ON [dbo].[PerfMonData] ([Counter], [CaptureDate]) INCLUDE ([Value]);


/***********************************************************************
CAPTURAR O BASELINE
***********************************************************************/

USE [BaselineData];
GO

SET NOCOUNT ON;

DECLARE @PerfCounters TABLE (
	[Counter] NVARCHAR(770),
	[CounterType] INT,
	[FirstValue] DECIMAL(38,2),
	[FirstDateTime] DATETIME,
	[SecondValue] DECIMAL(38,2),
	[SecondDateTime] DATETIME,
	[ValueDiff] AS ([SecondValue] - [FirstValue]),
	[TimeDiff] AS (DATEDIFF(SS, FirstDateTime, SecondDateTime)),
	[CounterValue] DECIMAL(38,2)
	);

INSERT INTO @PerfCounters (
	[Counter], 
	[CounterType], 
	[FirstValue], 
	[FirstDateTime]
	)
SELECT 
	RTRIM([object_name]) + N':' + RTRIM([counter_name]) + N':' + RTRIM([instance_name]), 
	[cntr_type],
	[cntr_value], 
	GETDATE()
FROM sys.dm_os_performance_counters
WHERE [counter_name] IN (
	'Page life expectancy', 'Lazy writes/sec', 'Page reads/sec', 'Page writes/sec','Free Pages',
	'Free list stalls/sec','User Connections', 'Lock Waits/sec', 'Number of Deadlocks/sec',
	'Transactions/sec', 'Forwarded Records/sec', 'Index Searches/sec', 'Full Scans/sec',
	'Batch Requests/sec','SQL Compilations/sec', 'SQL Re-Compilations/sec', 'Total Server Memory (KB)',
	'Target Server Memory (KB)', 'Latch Waits/sec'
	)
ORDER BY [object_name] + N':' + [counter_name] + N':' + [instance_name];

WAITFOR DELAY '00:00:10';

UPDATE @PerfCounters 
SET [SecondValue] = [cntr_value],
	[SecondDateTime] = GETDATE()
FROM sys.dm_os_performance_counters  
WHERE [Counter] =  RTRIM([object_name]) + N':' + RTRIM([counter_name]) + N':' + RTRIM([instance_name])
AND [counter_name] IN (
	'Page life expectancy', 'Lazy writes/sec', 'Page reads/sec', 'Page writes/sec','Free Pages',
	'Free list stalls/sec','User Connections', 'Lock Waits/sec', 'Number of Deadlocks/sec',
	'Transactions/sec', 'Forwarded Records/sec', 'Index Searches/sec', 'Full Scans/sec',
	'Batch Requests/sec','SQL Compilations/sec', 'SQL Re-Compilations/sec', 'Total Server Memory (KB)',
	'Target Server Memory (KB)', 'Latch Waits/sec'
	);

UPDATE @PerfCounters 
SET [CounterValue] = [ValueDiff]/[TimeDiff]
WHERE [CounterType] = 272696576 ;

UPDATE @PerfCounters
SET [CounterValue] = [SecondValue]
WHERE [CounterType] <> 272696576;

INSERT INTO [dbo].[PerfMonData] (
	[Counter],
	[Value],
	[CaptureDate])
SELECT
	[Counter], 
	[CounterValue],
	[SecondDateTime]
FROM @PerfCounters;


/***********************************************************************
CRIAR UMA PROCEDURE PARA PESQUISAR OS CONTADORES
***********************************************************************/


USE [BaselineData];
GO

IF OBJECTPROPERTY(OBJECT_ID('usp_PerfMonReport'), 'IsProcedure') = 1
	DROP PROCEDURE usp_PerfMonReport;
GO

CREATE PROCEDURE dbo.usp_PerfMonReport 
(
	@Counter NVARCHAR(128) = '%'
)
AS

BEGIN;

	SELECT [Counter], [Value], [CaptureDate]
	FROM [dbo].[PerfMonData] 
	WHERE [Counter] like @Counter
	ORDER BY [Counter], [CaptureDate]

END;


/*
exec dbo.usp_PerfMonReport '%Page life expectancy%'
exec dbo.usp_PerfMonReport '%Batch Requests/sec%'
exec dbo.usp_PerfMonReport '%Page writes/sec%'
*/

