-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			FINANCIAMIENTO / BANCO
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BANCO]') AND type in (N'U'))
	DROP TABLE [dbo].[BANCO]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_BANCO]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_BANCO]
GO



-- ===============================================================
-- == ESTATUS_BANCO 	
-- ===============================================================

CREATE TABLE [dbo].[ESTATUS_BANCO] (
	[K_ESTATUS_BANCO]	[INT]			NOT NULL,
	[D_ESTATUS_BANCO]	[VARCHAR] (100) NOT NULL,
	[S_ESTATUS_BANCO]	[VARCHAR] (10)	NOT NULL,
	[O_ESTATUS_BANCO]	[INT]			NOT NULL,
	[C_ESTATUS_BANCO]	[VARCHAR] (255) NOT NULL,
	[L_ESTATUS_BANCO]	[INT]			NOT NULL	
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[ESTATUS_BANCO]
	ADD CONSTRAINT [PK_ESTATUS_BANCO]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_BANCO])
GO

-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_BANCO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_ESTATUS_BANCO		INT,
	@PP_D_ESTATUS_BANCO		VARCHAR(100),
	@PP_S_ESTATUS_BANCO		VARCHAR(10),
	@PP_O_ESTATUS_BANCO		INT,
	@PP_C_ESTATUS_BANCO		VARCHAR(255),
	@PP_L_ESTATUS_BANCO		INT
AS

	INSERT INTO ESTATUS_BANCO
		(	K_ESTATUS_BANCO,			D_ESTATUS_BANCO, 
			S_ESTATUS_BANCO,			O_ESTATUS_BANCO,
			C_ESTATUS_BANCO,
			L_ESTATUS_BANCO				)
	VALUES	
		(	@PP_K_ESTATUS_BANCO,		@PP_D_ESTATUS_BANCO,	
			@PP_S_ESTATUS_BANCO,		@PP_O_ESTATUS_BANCO,
			@PP_C_ESTATUS_BANCO,
			@PP_L_ESTATUS_BANCO			)

	-- ==============================================
GO

EXECUTE [dbo].[PG_CI_ESTATUS_BANCO] 0, 0, 1, 'ACTIVA',	'ACTIV', 10, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_BANCO] 0, 0, 2, 'INACTIVA','INACT', 20, '', 1
GO



-- ===============================================================
-- == BANCO 	
-- ===============================================================

CREATE TABLE [dbo].[BANCO] (
	[K_BANCO]			[INT]			NOT NULL,
	[D_BANCO]			[VARCHAR] (100) NOT NULL,
	[C_BANCO]			[VARCHAR] (255) NOT NULL,
	[S_BANCO]			[VARCHAR] (10)	NOT NULL,
	[O_BANCO]			[INT]			NOT NULL,
	[L_BANCO]			[INT]			NOT NULL,
	[K_ESTATUS_BANCO]	[INT]			NOT NULL,
	[K_PAIS]			[INT]			NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[BANCO]
	ADD CONSTRAINT [PK_BANCO]
		PRIMARY KEY CLUSTERED ([K_BANCO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_BANCO_01_DESCRIPCION] 
	   ON [dbo].[BANCO] ( [D_BANCO] )
GO



-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[BANCO] ADD 
	CONSTRAINT [FK_BANCO_01] 
		FOREIGN KEY ([K_ESTATUS_BANCO]) 
		REFERENCES [dbo].[ESTATUS_BANCO] ([K_ESTATUS_BANCO])
GO


ALTER TABLE [dbo].[BANCO] ADD 
	CONSTRAINT [FK_BANCO_02] 
		FOREIGN KEY ([K_PAIS]) 
		REFERENCES [dbo].[PAIS] ([K_PAIS])
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[BANCO] 
	ADD		[K_USUARIO_ALTA]		[INT]		NOT NULL,
			[F_ALTA]				[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]		[INT]		NOT NULL,
			[F_CAMBIO]				[DATETIME]	NOT NULL,
			[L_BORRADO]				[INT]		NOT NULL,
			[K_USUARIO_BAJA]		[INT]		NULL,
			[F_BAJA]				[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[BANCO] ADD 
	CONSTRAINT [FK_BANCO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_BANCO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_BANCO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_BANCO]
GO

CREATE PROCEDURE [dbo].[PG_CI_BANCO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	@PP_K_BANCO				INT,
	@PP_D_BANCO				VARCHAR(100),
	@PP_C_BANCO				VARCHAR(255),
	@PP_S_BANCO				VARCHAR(10),	
	@PP_K_ESTATUS_BANCO		INT,
	@PP_K_PAIS				INT
AS

	INSERT INTO BANCO
		(	K_BANCO,			D_BANCO,
			C_BANCO,			S_BANCO,
			O_BANCO,			L_BANCO,
			K_ESTATUS_BANCO,	K_PAIS,
			K_USUARIO_ALTA,		F_ALTA,
			K_USUARIO_CAMBIO,	F_CAMBIO,
			L_BORRADO,
			K_USUARIO_BAJA,		F_BAJA
		)

	VALUES	
		(	@PP_K_BANCO,			@PP_D_BANCO,
			@PP_C_BANCO,			@PP_S_BANCO,
			0,						1,			
			@PP_K_ESTATUS_BANCO,	@PP_K_PAIS,
			@PP_K_USUARIO_ACCION,	GETDATE(),
			@PP_K_USUARIO_ACCION,	GETDATE(),
			0,
			NULL, NULL
										 )

	-- ==============================================
GO



-- ===============================================
SET NOCOUNT ON
-- ===============================================


-- CARGA INICIAL
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 0, '( SIN ASIGNAR )', '( SIN ASIGNAR )', 'XXXX', 2, 0
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 1, 'BANAMEX', 'BANAMEX', 'BNMX', 1, 1
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 2, 'BANCO DEL BAJIO', 'BANCO DEL BAJIO', 'BJIO', 1, 1
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 3, 'BANCRECER S.A.', 'BANCRECER S.A.', 'BNCR', 1, 1
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 4, 'BANK OF AMERICA', 'BANK OF AMERICA', 'BAMR', 1, 2
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 5, 'BANORTE', 'BANORTE', 'BNTE', 1, 1
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 7, 'BBVA BANCOMER', 'BBVA BANCOMER', 'BBVA', 1, 1
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 8, 'HSBC', 'HSBC', 'HSBC', 1, 1
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 9, 'JP MORGAN CHASE BANK', 'JP MORGAN CHASE BANK', 'MRGN', 1, 2
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 10, 'SANTANDER', 'SANTANDER', 'STDR', 1, 1
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 11, 'SCOTIABANK', 'SCOTIABANK', 'SBNK', 1, 1
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 13, 'BANK OF THE WEST', 'BANK OF THE WEST', 'BWST', 1, 2
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 14, 'UBS INTERNATIONAL', 'UBS INTERNATIONAL', 'UBS', 1, 2
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 15, 'SMITHBARNEY', 'SMITHBARNEY', 'SMTH', 1, 2
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 16, 'UNITED BANK OF EL PASO', 'UNITED BANK OF EL PASO', 'BPSO', 1, 2
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 17, 'MERRILL LYNCHN', 'MERRILL LYNCHN', 'MLYN', 1, 2
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 20, 'COMPASS', 'COMPASS', 'CPSS', 1, 2
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 21, 'INBURSA', 'INBURSA', 'INBU', 1, 1
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 22, 'UNION PROGRESO', 'UNION PROGRESO', 'UPRG', 1, 1
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 23, 'BANREGIO', 'BANREGIO', 'BNRG', 1, 1
EXECUTE [dbo].[PG_CI_BANCO] 0, 0, 0, 24, 'INTERNATIONAL BANK', 'INTERNATIONAL BANK', 'IBNK', 1, 2


-- ===============================================
SET NOCOUNT OFF
-- ===============================================



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
