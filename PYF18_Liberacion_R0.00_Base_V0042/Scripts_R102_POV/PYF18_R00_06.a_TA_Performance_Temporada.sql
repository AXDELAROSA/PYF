-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			Performance_Temporada
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


-- USE [D4C3_Datamart_XLS_V0012_R0]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PERFORMANCE_N3_X_TEMP]') AND type in (N'U'))
	DROP TABLE [dbo].[PERFORMANCE_N3_X_TEMP]
GO


CREATE TABLE [dbo].[PERFORMANCE_N3_X_TEMP](
	[K_YYYY]				[INT]				NOT NULL,
	[XLS_UO]				[INT]				NOT NULL,
	[XLS_UNIDAD_OPERATIVA]	[VARCHAR](100)		NOT NULL,
	[K_UNIDAD_OPERATIVA]	[INT]				NOT NULL,
	[K_TEMPORADA]			[INT]				NOT NULL,
	[K_METRICA]				[INT]				NOT NULL,
	[VALOR_ACUMULADO]		[DECIMAL](19, 4)	NOT NULL,
	[V00_VALOR]				[DECIMAL](19, 4)	NOT NULL,
	[V01_VALOR]				[DECIMAL](19, 4)	NOT NULL,
	[V02_VALOR]				[DECIMAL](19, 4)	NOT NULL,
	[P01_VALOR]				[DECIMAL](19,2)		NOT NULL,
	[P02_VALOR]				[DECIMAL](19,2)		NOT NULL,

 ) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PERFORMANCE_N3_X_TEMP]
	ADD CONSTRAINT [PK_PERFORMANCE_N3_X_TEMP]
		PRIMARY KEY CLUSTERED ( [K_YYYY],[K_UNIDAD_OPERATIVA],[K_TEMPORADA],[K_METRICA]	)
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PERFORMANCE_N3_X_TEMP] ADD 
	CONSTRAINT [FK_PERFORMANCE_N3_X_TEMP_TEMPORADA] 
		FOREIGN KEY ([K_TEMPORADA]) 
		REFERENCES [dbo].[TEMPORADA] ([K_TEMPORADA])
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PERFORMANCE_N3_X_TEMP] ADD 
	CONSTRAINT [FK_PERFORMANCE_N3_X_TEMP_UO] 
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA])
GO

-- //////////////////////////////////////////////////////
