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
-- // DROPs 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ACTIVO_FILTRO]') AND type in (N'U'))
	DROP TABLE [dbo].[ACTIVO_FILTRO] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_ACTIVO]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_ACTIVO] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FILTRO_SI_NO]') AND type in (N'U'))
	DROP TABLE [dbo].[FILTRO_SI_NO] 
GO



/****************************************************************/
/*						ESTATUS_ACTIVO 							*/
/****************************************************************/

CREATE TABLE [dbo].[ESTATUS_ACTIVO] (
	[K_ESTATUS_ACTIVO]	[INT] NOT NULL,
	[D_ESTATUS_ACTIVO]	[VARCHAR] (100) NOT NULL,
	[S_ESTATUS_ACTIVO]	[VARCHAR] (10) NOT NULL,
	[O_ESTATUS_ACTIVO]	[INT] NOT NULL,
	[C_ESTATUS_ACTIVO]	[VARCHAR] (255) NOT NULL
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[ESTATUS_ACTIVO]
	ADD CONSTRAINT [PK_ESTATUS_ACTIVO]
	PRIMARY KEY CLUSTERED (K_ESTATUS_ACTIVO)
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_ACTIVO_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_ACTIVO] ( [D_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CF_ESTATUS_ACTIVO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CF_ESTATUS_ACTIVO]
GO


CREATE PROCEDURE [dbo].[PG_CF_ESTATUS_ACTIVO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_ESTATUS_ACTIVO	INT,
	@PP_D_ESTATUS_ACTIVO	VARCHAR(100),
	@PP_S_ESTATUS_ACTIVO	VARCHAR(10),
	@PP_O_ESTATUS_ACTIVO	INT,
	@PP_C_ESTATUS_ACTIVO	VARCHAR(255)
AS

	INSERT INTO ESTATUS_ACTIVO
		(	K_ESTATUS_ACTIVO,		D_ESTATUS_ACTIVO, 
			S_ESTATUS_ACTIVO,		O_ESTATUS_ACTIVO,
			C_ESTATUS_ACTIVO		)
	VALUES	
		(	@PP_K_ESTATUS_ACTIVO,	@PP_D_ESTATUS_ACTIVO,	
			@PP_S_ESTATUS_ACTIVO,	@PP_O_ESTATUS_ACTIVO,
			@PP_C_ESTATUS_ACTIVO	)

	-- ================================================
GO


EXECUTE [dbo].[PG_CF_ESTATUS_ACTIVO]  0, 0, 1, 'ACTIVO',		'ACTVO', 10, ''
EXECUTE [dbo].[PG_CF_ESTATUS_ACTIVO]  0, 0, 0, 'INACTIVO',		'INACT', 20, ''
GO



/****************************************************************/
/*							ACTIVO_FILTRO 						*/
/****************************************************************/

CREATE TABLE [dbo].[ACTIVO_FILTRO] (
	[K_ACTIVO_FILTRO]	[INT] NOT NULL,
	[D_ACTIVO_FILTRO]	[VARCHAR] (100) NOT NULL,
	[S_ACTIVO_FILTRO]	[VARCHAR] (10) NOT NULL,
	[O_ACTIVO_FILTRO]	[INT] NOT NULL,
	[C_ACTIVO_FILTRO]	[VARCHAR] (255) NOT NULL,
	[L_ACTIVO_FILTRO]	[INT] NOT NULL
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[ACTIVO_FILTRO]
	ADD CONSTRAINT [PK_ACTIVO_FILTRO]
		PRIMARY KEY CLUSTERED ([K_ACTIVO_FILTRO])
GO

CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ACTIVO_FILTRO_01_DESCRIPCION] 
	   ON [dbo].[ACTIVO_FILTRO] ( [D_ACTIVO_FILTRO] )
GO


-- //////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CF_ACTIVO_FILTRO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CF_ACTIVO_FILTRO]
GO


CREATE PROCEDURE [dbo].[PG_CF_ACTIVO_FILTRO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_ACTIVO_FILTRO		INT,
	@PP_D_ACTIVO_FILTRO		VARCHAR(100),
	@PP_S_ACTIVO_FILTRO		VARCHAR(10),
	@PP_O_ACTIVO_FILTRO		INT,
	@PP_C_ACTIVO_FILTRO		VARCHAR(255),
	@PP_L_ACTIVO_FILTRO		INT
AS

	INSERT INTO ACTIVO_FILTRO
		(	K_ACTIVO_FILTRO,		D_ACTIVO_FILTRO, 
			S_ACTIVO_FILTRO,		O_ACTIVO_FILTRO,
			C_ACTIVO_FILTRO,
			L_ACTIVO_FILTRO			)
	VALUES	
		(	@PP_K_ACTIVO_FILTRO,	@PP_D_ACTIVO_FILTRO,	
			@PP_S_ACTIVO_FILTRO,	@PP_O_ACTIVO_FILTRO,
			@PP_C_ACTIVO_FILTRO,
			@PP_L_ACTIVO_FILTRO		)

	-- ================================================
GO


EXECUTE [dbo].[PG_CF_ACTIVO_FILTRO]		0, 0, -1, 'VER TODOS',		'TODOS', 10, '', 1
EXECUTE [dbo].[PG_CF_ACTIVO_FILTRO]		0, 0,  1, 'SOLO ACTIVOS',		'ACTVS', 20, '', 1
EXECUTE [dbo].[PG_CF_ACTIVO_FILTRO]		0, 0,  0, 'SOLO INACTIVOS',	'INACT', 30, '', 1
GO



/****************************************************************/
/*							FILTRO_SI_NO 						*/
/****************************************************************/

CREATE TABLE [dbo].[FILTRO_SI_NO] (
	[K_FILTRO_SI_NO]	[INT] NOT NULL,
	[D_FILTRO_SI_NO]	[VARCHAR] (100) NOT NULL,
	[S_FILTRO_SI_NO]	[VARCHAR] (10) NOT NULL,
	[O_FILTRO_SI_NO]	[INT] NOT NULL,
	[C_FILTRO_SI_NO]	[VARCHAR] (255) NOT NULL,
	[L_FILTRO_SI_NO]	[INT] NOT NULL
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[FILTRO_SI_NO]
	ADD CONSTRAINT [PK_FILTRO_SI_NO]
		PRIMARY KEY CLUSTERED ([K_FILTRO_SI_NO])
GO

CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_FILTRO_SI_NO_01_DESCRIPCION] 
	   ON [dbo].[FILTRO_SI_NO] ( [D_FILTRO_SI_NO] )
GO


-- //////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CF_FILTRO_SI_NO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CF_FILTRO_SI_NO]
GO


CREATE PROCEDURE [dbo].[PG_CF_FILTRO_SI_NO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_FILTRO_SI_NO		INT,
	@PP_D_FILTRO_SI_NO		VARCHAR(100),
	@PP_S_FILTRO_SI_NO		VARCHAR(10),
	@PP_O_FILTRO_SI_NO		INT,
	@PP_C_FILTRO_SI_NO		VARCHAR(255),
	@PP_L_FILTRO_SI_NO		INT
AS

	INSERT INTO FILTRO_SI_NO
		(	K_FILTRO_SI_NO,			D_FILTRO_SI_NO, 
			S_FILTRO_SI_NO,			O_FILTRO_SI_NO,
			C_FILTRO_SI_NO,
			L_FILTRO_SI_NO			)	
	VALUES	
		(	@PP_K_FILTRO_SI_NO,		@PP_D_FILTRO_SI_NO,	
			@PP_S_FILTRO_SI_NO,		@PP_O_FILTRO_SI_NO,
			@PP_C_FILTRO_SI_NO,
			@PP_L_FILTRO_SI_NO		)

	-- =========================================================
GO


--EXECUTE PG_CF_FILTRO_SI_NO -1, '(VER TODOS)',	'TODOS', 10, '', 1
EXECUTE [dbo].[PG_CF_FILTRO_SI_NO]  0, 0, 1, 'SI',			'SISI',  20, '', 1
EXECUTE [dbo].[PG_CF_FILTRO_SI_NO]  0, 0, 0, 'NO',			'NONO',  30, '', 1
GO



-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////

