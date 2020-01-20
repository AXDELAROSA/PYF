-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			
-- // OPERACION:		LIBERACION // STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EQUIVALENCIA]') AND type in (N'U'))
	DROP TABLE [dbo].[EQUIVALENCIA] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TABLA_SISTEMA]') AND type in (N'U'))
	DROP TABLE [dbo].[TABLA_SISTEMA]
GO

/*
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SISTEMA]') AND type in (N'U'))
	DROP TABLE [dbo].[SISTEMA]
GO
*/


/****************************************************************/
/*							SISTEMA 							*/
/****************************************************************/
/* #1-ICS | #2-ERM |											*/
/****************************************************************/
/*
CREATE TABLE [dbo].[SISTEMA] (
	[K_SISTEMA]	[INT] NOT NULL,
	[D_SISTEMA]	[VARCHAR] (100) NOT NULL,
	[S_SISTEMA]	[VARCHAR] (10) NOT NULL
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[SISTEMA]
	ADD CONSTRAINT [PK_SISTEMA]
		PRIMARY KEY CLUSTERED ([K_SISTEMA])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_SISTEMA_01_DESCRIPCION] 
	   ON [dbo].[SISTEMA] ( [D_SISTEMA] )
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CF_SISTEMA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CF_SISTEMA]
GO


CREATE PROCEDURE [dbo].[PG_CF_SISTEMA]
	@PP_L_DEBUG			INT,
	@PP_K_SISTEMA_EXE	INT,
	@PP_K_SISTEMA		INT,
	@PP_D_SISTEMA		VARCHAR(100),
	@PP_S_SISTEMA		VARCHAR(10)
AS

	INSERT INTO SISTEMA
		(	K_SISTEMA,			
			D_SISTEMA,		S_SISTEMA		)
	VALUES	
		(	@PP_K_SISTEMA,		
			@PP_D_SISTEMA,	@PP_S_SISTEMA	)	

	-- ==============================================
GO

EXECUTE [dbo].[PG_CF_SISTEMA]	0, 0,    0, 'DEFAULT',				'SYS/DEF'
EXECUTE [dbo].[PG_CF_SISTEMA]	0, 0,  100, 'ICS/GENERAL',			'ICS'
EXECUTE [dbo].[PG_CF_SISTEMA]	0, 0,  200, 'ERM/GENERAL',			'ERM'
EXECUTE [dbo].[PG_CF_SISTEMA]	0, 0, 1001, 'PRESTAMOS MAYORISTAS',	'PR3M4'
GO
*/


/****************************************************************/
/*							TABLA_SISTEMA 						*/
/****************************************************************/

CREATE TABLE [dbo].[TABLA_SISTEMA] (
	[K_TABLA_SISTEMA]			[INT] NOT NULL,
	[D_TABLA_SISTEMA]			[VARCHAR] (100) NOT NULL,
	[K_SISTEMA]					[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[TABLA_SISTEMA]
	ADD CONSTRAINT [PK_TABLA_SISTEMA]
		PRIMARY KEY CLUSTERED ([K_TABLA_SISTEMA])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TABLA_SISTEMA_01_DESCRIPCION] 
	   ON [dbo].[TABLA_SISTEMA] ( [D_TABLA_SISTEMA] )
GO


ALTER TABLE [dbo].[TABLA_SISTEMA] ADD 
	CONSTRAINT [FK_TABLA_SISTEMA_01] 
		FOREIGN KEY ([K_SISTEMA]) 
		REFERENCES [dbo].[SISTEMA] ([K_SISTEMA])
GO


-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CF_TABLA_SISTEMA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CF_TABLA_SISTEMA]
GO


CREATE PROCEDURE [dbo].[PG_CF_TABLA_SISTEMA]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_TABLA_SISTEMA			INT,
	@PP_D_TABLA_SISTEMA			VARCHAR(100),
	@PP_K_SISTEMA				INT
AS

	INSERT INTO TABLA_SISTEMA
		(	K_TABLA_SISTEMA,		D_TABLA_SISTEMA,
			K_SISTEMA				)
	VALUES	
		(	@PP_K_TABLA_SISTEMA,	@PP_D_TABLA_SISTEMA,
			@PP_K_SISTEMA			)

	-- ==============================================
GO


/****************************************************************/
/*						EQUIVALENCIA							*/
/****************************************************************/

CREATE TABLE [dbo].[EQUIVALENCIA] (
	[K_EQUIVALENCIA]				[INT] NOT NULL,
	[D_EQUIVALENCIA]				[VARCHAR] (100) NOT NULL,
	[K_TABLA_SISTEMA_LOCAL]			[INT] NOT NULL,
	[K_TABLA_SISTEMA_EXTERNO]		[INT] NOT NULL,
	-- =========================
	[K_IDENTIFICADOR_LOCAL_INT]		[INT] NOT NULL,
	[K_IDENTIFICADOR_LOCAL_TXT]		[VARCHAR] (100) NOT NULL,
	[K_IDENTIFICADOR_EXTERNO_INT]	[INT] NOT NULL,
	[K_IDENTIFICADOR_EXTERNO_TXT]	[VARCHAR] (100) NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[EQUIVALENCIA]
	ADD CONSTRAINT [PK_EQUIVALENCIA]
		PRIMARY KEY CLUSTERED ([K_EQUIVALENCIA])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_EQUIVALENCIA_01_DESCRIPCION] 
	   ON [dbo].[EQUIVALENCIA] ( [D_EQUIVALENCIA] )
GO


-- //////////////////////////////////////////////////////


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_EQUIVALENCIA_01] 
	   ON [dbo].[EQUIVALENCIA] ( [K_TABLA_SISTEMA_LOCAL], [K_TABLA_SISTEMA_EXTERNO] )
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[EQUIVALENCIA] ADD 
	CONSTRAINT [FK_EQUIVALENCIA_01] 
		FOREIGN KEY ([K_TABLA_SISTEMA_LOCAL]) 
		REFERENCES [dbo].[TABLA_SISTEMA] ([K_TABLA_SISTEMA]),
	CONSTRAINT [FK_EQUIVALENCIA_02] 
		FOREIGN KEY ([K_TABLA_SISTEMA_EXTERNO]) 
		REFERENCES [dbo].[TABLA_SISTEMA] ([K_TABLA_SISTEMA])
GO


-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CF_EQUIVALENCIA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CF_EQUIVALENCIA]
GO


CREATE PROCEDURE [dbo].[PG_CF_EQUIVALENCIA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_SISTEMA					INT,
	@PP_K_EQUIVALENCIA				INT,
	@PP_D_EQUIVALENCIA				VARCHAR(100),
	@PP_K_TABLA_SISTEMA_LOCAL		INT,
	@PP_K_TABLA_SISTEMA_EXTERNO		INT,
	-- =========================
	@PP_K_IDENTIFICADOR_LOCAL_INT		INT,
	@PP_K_IDENTIFICADOR_LOCAL_TXT		VARCHAR(100), 
	@PP_K_IDENTIFICADOR_EXTERNO_INT		INT,
	@PP_K_IDENTIFICADOR_EXTERNO_TXT		VARCHAR(100) 
AS

	INSERT INTO EQUIVALENCIA
		(	K_EQUIVALENCIA,						D_EQUIVALENCIA,
			K_TABLA_SISTEMA_LOCAL,				K_TABLA_SISTEMA_EXTERNO,
			-- =========================
			K_IDENTIFICADOR_LOCAL_INT,			K_IDENTIFICADOR_LOCAL_TXT,
			K_IDENTIFICADOR_EXTERNO_INT,		K_IDENTIFICADOR_EXTERNO_TXT			)

	VALUES	
		(	@PP_K_EQUIVALENCIA,					@PP_D_EQUIVALENCIA,
			@PP_K_TABLA_SISTEMA_LOCAL,			@PP_K_TABLA_SISTEMA_EXTERNO,
			-- =========================
			@PP_K_IDENTIFICADOR_LOCAL_INT,		@PP_K_IDENTIFICADOR_LOCAL_TXT,
			@PP_K_IDENTIFICADOR_EXTERNO_INT,	@PP_K_IDENTIFICADOR_EXTERNO_TXT		)
	
	-- ==============================================
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
