-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			ORGANIZACION / RAZON_SOCIAL 
-- // OPERACION:		LIBERACION / TABLAS 
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIPO_RAZON_SOCIAL]') AND type in (N'U'))
	DROP TABLE [dbo].[TIPO_RAZON_SOCIAL]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLASE_RAZON_SOCIAL]') AND type in (N'U'))
	DROP TABLE [dbo].[CLASE_RAZON_SOCIAL]
GO



-- ///////////////////////////////////////////////////////////////
-- // CLASE_RAZON_SOCIAL
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[CLASE_RAZON_SOCIAL] (
	[K_CLASE_RAZON_SOCIAL]			INT NOT NULL,
	[D_CLASE_RAZON_SOCIAL]			VARCHAR (100) NOT NULL,
	[S_CLASE_RAZON_SOCIAL]			VARCHAR (10) NOT NULL,
	[O_CLASE_RAZON_SOCIAL]			INT NOT NULL,
	[C_CLASE_RAZON_SOCIAL]			VARCHAR (255) NOT NULL,
	[L_CLASE_RAZON_SOCIAL]			INT NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[CLASE_RAZON_SOCIAL]
	ADD CONSTRAINT [PK_CLASE_RAZON_SOCIAL]
		PRIMARY KEY CLUSTERED ([K_CLASE_RAZON_SOCIAL])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_CLASE_RAZON_SOCIAL_01_DESCRIPCION] 
	   ON [dbo].[CLASE_RAZON_SOCIAL] ( [D_CLASE_RAZON_SOCIAL] )
GO


ALTER TABLE [dbo].[CLASE_RAZON_SOCIAL] ADD 
	CONSTRAINT [FK_CLASE_RAZON_SOCIAL_01] 
		FOREIGN KEY ( [L_CLASE_RAZON_SOCIAL] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_CLASE_RAZON_SOCIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_CLASE_RAZON_SOCIAL]
GO


CREATE PROCEDURE [dbo].[PG_CI_CLASE_RAZON_SOCIAL]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ==================================
	@PP_K_CLASE_RAZON_SOCIAL		INT,
	@PP_D_CLASE_RAZON_SOCIAL		VARCHAR(100),
	@PP_S_CLASE_RAZON_SOCIAL		VARCHAR(10),
	@PP_O_CLASE_RAZON_SOCIAL		INT,
	@PP_C_CLASE_RAZON_SOCIAL		VARCHAR(255),
	@PP_L_CLASE_RAZON_SOCIAL		INT
AS
	
	INSERT INTO CLASE_RAZON_SOCIAL
		(	K_CLASE_RAZON_SOCIAL,			D_CLASE_RAZON_SOCIAL, 
			S_CLASE_RAZON_SOCIAL,			O_CLASE_RAZON_SOCIAL,
			C_CLASE_RAZON_SOCIAL,
			L_CLASE_RAZON_SOCIAL			)		
	VALUES	
		(	@PP_K_CLASE_RAZON_SOCIAL,		@PP_D_CLASE_RAZON_SOCIAL,	
			@PP_S_CLASE_RAZON_SOCIAL,		@PP_O_CLASE_RAZON_SOCIAL,
			@PP_C_CLASE_RAZON_SOCIAL,
			@PP_L_CLASE_RAZON_SOCIAL		)

	-- =========================================================
GO


-- ///////////////////////////////////////////////////////////////


-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_CLASE_RAZON_SOCIAL] 0,0,0,  00, 'SIN TIPO',		'SIN', 1, '', 1
EXECUTE [dbo].[PG_CI_CLASE_RAZON_SOCIAL] 0,0,0,  01, 'OPERACION',		'OPE', 1, '', 1
EXECUTE [dbo].[PG_CI_CLASE_RAZON_SOCIAL] 0,0,0,  02, 'NO OPERACION',	'NOP', 1, '', 1
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================



-- ///////////////////////////////////////////////////////////////
-- //					TIPO_RAZON_SOCIAL
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[TIPO_RAZON_SOCIAL] (
	[K_TIPO_RAZON_SOCIAL]			INT NOT NULL,
	[D_TIPO_RAZON_SOCIAL]			VARCHAR (100) NOT NULL,
	[S_TIPO_RAZON_SOCIAL]			VARCHAR (10) NOT NULL,
	[O_TIPO_RAZON_SOCIAL]			INT NOT NULL,
	[C_TIPO_RAZON_SOCIAL]			VARCHAR (255) NOT NULL,
	[L_TIPO_RAZON_SOCIAL]			INT NOT NULL,
	[K_CLASE_RAZON_SOCIAL]			INT NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[TIPO_RAZON_SOCIAL]
	ADD CONSTRAINT [PK_TIPO_RAZON_SOCIAL]
		PRIMARY KEY CLUSTERED ([K_TIPO_RAZON_SOCIAL])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TIPO_RAZON_SOCIAL_01_DESCRIPCION] 
	   ON [dbo].[TIPO_RAZON_SOCIAL] ( [D_TIPO_RAZON_SOCIAL] )
GO


ALTER TABLE [dbo].[TIPO_RAZON_SOCIAL] ADD 
	CONSTRAINT [FK_TIPO_RAZON_SOCIAL_01] 
		FOREIGN KEY ( [L_TIPO_RAZON_SOCIAL] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] ),
	CONSTRAINT [FK_TIPO_RAZON_SOCIAL_02] 
		FOREIGN KEY ( [K_CLASE_RAZON_SOCIAL] ) 
		REFERENCES [dbo].[CLASE_RAZON_SOCIAL] ( [K_CLASE_RAZON_SOCIAL] )
GO



-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIPO_RAZON_SOCIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIPO_RAZON_SOCIAL]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIPO_RAZON_SOCIAL]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ==================================
	@PP_K_TIPO_RAZON_SOCIAL			INT,
	@PP_D_TIPO_RAZON_SOCIAL			VARCHAR(100),
	@PP_S_TIPO_RAZON_SOCIAL			VARCHAR(10),
	@PP_O_TIPO_RAZON_SOCIAL			INT,
	@PP_C_TIPO_RAZON_SOCIAL			VARCHAR(255),
	@PP_L_TIPO_RAZON_SOCIAL			INT,
	@PP_K_CLASE_RAZON_SOCIAL		INT		
AS

	INSERT INTO TIPO_RAZON_SOCIAL
		(	K_TIPO_RAZON_SOCIAL,				D_TIPO_RAZON_SOCIAL, 
			S_TIPO_RAZON_SOCIAL,				O_TIPO_RAZON_SOCIAL,
			C_TIPO_RAZON_SOCIAL,
			L_TIPO_RAZON_SOCIAL,
			K_CLASE_RAZON_SOCIAL				)
	VALUES	
		(	@PP_K_TIPO_RAZON_SOCIAL,			@PP_D_TIPO_RAZON_SOCIAL,	
			@PP_S_TIPO_RAZON_SOCIAL,			@PP_O_TIPO_RAZON_SOCIAL,
			@PP_C_TIPO_RAZON_SOCIAL,
			@PP_L_TIPO_RAZON_SOCIAL,
			@PP_K_CLASE_RAZON_SOCIAL			)

	-- =========================================================
GO


-- ///////////////////////////////////////////////////////////////


-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_TIPO_RAZON_SOCIAL] 0,0,0,  00, 'SIN TIPO',			'SIN', 0, '', 1, 0
EXECUTE [dbo].[PG_CI_TIPO_RAZON_SOCIAL] 0,0,0,  01, 'GASERA',			'GAS', 1, '', 1, 1
EXECUTE [dbo].[PG_CI_TIPO_RAZON_SOCIAL] 0,0,0,  02, 'TRANSPORTADORAS',	'TRA', 2, '', 1, 1
EXECUTE [dbo].[PG_CI_TIPO_RAZON_SOCIAL] 0,0,0,  03, 'IMPORTADORA',		'IMP', 3, '', 1, 1
EXECUTE [dbo].[PG_CI_TIPO_RAZON_SOCIAL] 0,0,0,  04, 'INMOBILIARIAS',	'INM', 4, '', 1, 2
EXECUTE [dbo].[PG_CI_TIPO_RAZON_SOCIAL] 0,0,0,  05, 'PERSONAS',			'FIS', 5, '', 1, 2
EXECUTE [dbo].[PG_CI_TIPO_RAZON_SOCIAL] 0,0,0,  06, 'AEROS',			'AER', 6, '', 1, 1
EXECUTE [dbo].[PG_CI_TIPO_RAZON_SOCIAL] 0,0,0,  08, 'OPERATIVAS',		'OPE', 7, '', 1, 1
EXECUTE [dbo].[PG_CI_TIPO_RAZON_SOCIAL] 0,0,0,  99, 'VARIOS',			'VAR', 8, '', 1, 2
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================



