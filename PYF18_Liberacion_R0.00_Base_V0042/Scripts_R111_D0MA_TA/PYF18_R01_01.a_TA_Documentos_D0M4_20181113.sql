-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATA_N3_X_ME_D0M4]') AND type in (N'U'))
	DROP TABLE [dbo].[DATA_N3_X_ME_D0M4] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATA_N1_X_DI_D0M4]') AND type in (N'U'))
	DROP TABLE [dbo].[DATA_N1_X_DI_D0M4] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PARAMETRO_DOCUMENTO_D0M4]') AND type in (N'U'))
	DROP TABLE [dbo].[PARAMETRO_DOCUMENTO_D0M4] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DOCUMENTO_D0M4]') AND type in (N'U'))
	DROP TABLE [dbo].[DOCUMENTO_D0M4] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_DOCUMENTO_D0M4]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_DOCUMENTO_D0M4] 
GO





-- ///////////////////////////////////////////////////////////////
-- // ESTATUS_DOCUMENTO_D0M4 						
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ESTATUS_DOCUMENTO_D0M4] (
	[K_ESTATUS_DOCUMENTO_D0M4]		[INT] 			NOT NULL,
	[D_ESTATUS_DOCUMENTO_D0M4]		[VARCHAR] (100) NOT NULL,
	[S_ESTATUS_DOCUMENTO_D0M4]		[VARCHAR] (10) 	NOT NULL,
	[O_ESTATUS_DOCUMENTO_D0M4]		[INT] 			NOT NULL,
	[C_ESTATUS_DOCUMENTO_D0M4]		[VARCHAR] (255) NOT NULL,
	[L_ESTATUS_DOCUMENTO_D0M4]		[INT] 			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[ESTATUS_DOCUMENTO_D0M4]
	ADD CONSTRAINT [PK_ESTATUS_DOCUMENTO_D0M4]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_DOCUMENTO_D0M4])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_DOCUMENTO_D0M4_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_DOCUMENTO_D0M4] ( [D_ESTATUS_DOCUMENTO_D0M4] )
GO

-- //////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_DOCUMENTO_D0M4]
GO



CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_DOCUMENTO_D0M4]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_ESTATUS_DOCUMENTO_D0M4		INT,
	@PP_D_ESTATUS_DOCUMENTO_D0M4		VARCHAR(100),
	@PP_S_ESTATUS_DOCUMENTO_D0M4		VARCHAR(10),
	@PP_O_ESTATUS_DOCUMENTO_D0M4		INT,
	@PP_C_ESTATUS_DOCUMENTO_D0M4		VARCHAR(255),
	@PP_L_ESTATUS_DOCUMENTO_D0M4		INT
AS

	INSERT INTO ESTATUS_DOCUMENTO_D0M4
		(	K_ESTATUS_DOCUMENTO_D0M4,			D_ESTATUS_DOCUMENTO_D0M4, 
			S_ESTATUS_DOCUMENTO_D0M4,			O_ESTATUS_DOCUMENTO_D0M4,
			C_ESTATUS_DOCUMENTO_D0M4,
			L_ESTATUS_DOCUMENTO_D0M4				)	
	VALUES	
		(	@PP_K_ESTATUS_DOCUMENTO_D0M4,		@PP_D_ESTATUS_DOCUMENTO_D0M4,	
			@PP_S_ESTATUS_DOCUMENTO_D0M4,		@PP_O_ESTATUS_DOCUMENTO_D0M4,
			@PP_C_ESTATUS_DOCUMENTO_D0M4,
			@PP_L_ESTATUS_DOCUMENTO_D0M4			)

	-- ==============================================
GO





-- ///////////////////////////////////////////////////////////////
-- // ESTATUS_DOCUMENTO_D0M4 						
-- ///////////////////////////////////////////////////////////////

EXECUTE [dbo].[PG_CI_ESTATUS_DOCUMENTO_D0M4]	0, 0, 1, 'ABIERTO',			'ABRT', 10, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_DOCUMENTO_D0M4]	0, 0, 2, 'EN PROCESO',		'PROC', 20, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_DOCUMENTO_D0M4]	0, 0, 3, 'PREVIO',			'PREV', 30, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_DOCUMENTO_D0M4]	0, 0, 4, 'CERRADO',			'CERR', 40, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_DOCUMENTO_D0M4]	0, 0, 5, 'AUTORIZADO',		'AUTR', 50, '', 1
GO





-- ///////////////////////////////////////////////////////////////
-- //						DOCUMENTO_D0M4 						
-- ///////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[DOCUMENTO_D0M4] (
	[K_DOCUMENTO_D0M4]				[INT] NOT NULL,
	[D_DOCUMENTO_D0M4]				[VARCHAR] (100) NOT NULL,
	[C_DOCUMENTO_D0M4]				[VARCHAR] (255) NOT NULL,
	[S_DOCUMENTO_D0M4]				[VARCHAR] (10) NOT NULL,
	[O_DOCUMENTO_D0M4]				[INT] NOT NULL,  
	[K_FORMATO_D0M4]				[INT] NOT NULL,
	[K_UNIDAD_OPERATIVA]			[INT] NOT NULL,
	[K_YYYY]						[INT] NOT NULL,
	[K_MM]							[INT] NOT NULL,
	[K_ESTATUS_DOCUMENTO_D0M4]		[INT] NOT NULL,
	[K_PRECIO_COSTO_PERFIL]			[INT] NULL,			
	[L_RECALCULAR]					[INT] NOT NULL DEFAULT  0
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[DOCUMENTO_D0M4]
	ADD CONSTRAINT [PK_DOCUMENTO_D0M4]
		PRIMARY KEY CLUSTERED ([K_DOCUMENTO_D0M4])
GO




-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[DOCUMENTO_D0M4] ADD 
	CONSTRAINT [FK_DOCUMENTO_D0M4_01] 
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA]),
	CONSTRAINT [FK_DOCUMENTO_D0M4_02] 
		FOREIGN KEY ([K_FORMATO_D0M4]) 
		REFERENCES [dbo].[FORMATO_D0M4] ([K_FORMATO_D0M4]),
	CONSTRAINT [FK_DOCUMENTO_D0M4_03] 
		FOREIGN KEY ([K_ESTATUS_DOCUMENTO_D0M4]) 
		REFERENCES [dbo].[ESTATUS_DOCUMENTO_D0M4] ([K_ESTATUS_DOCUMENTO_D0M4])
GO


-- //////////////////////////////////////////////////////




ALTER TABLE [dbo].[DOCUMENTO_D0M4] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[DOCUMENTO_D0M4] ADD 
	CONSTRAINT [FK_DOCUMENTO_D0M4_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_DOCUMENTO_D0M4_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_DOCUMENTO_D0M4_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
