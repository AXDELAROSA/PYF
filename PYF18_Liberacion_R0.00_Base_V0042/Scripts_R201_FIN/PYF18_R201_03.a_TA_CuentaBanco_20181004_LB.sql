-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			FINANZAS
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CUENTA_BANCO]') AND type in (N'U'))
	DROP TABLE [dbo].[CUENTA_BANCO]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_CUENTA_BANCO]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_CUENTA_BANCO]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIPO_CUENTA_BANCO]') AND type in (N'U'))
	DROP TABLE [dbo].[TIPO_CUENTA_BANCO]
GO





-- //////////////////////////////////////////////////////
-- // TIPO_CUENTA_BANCO 
-- //////////////////////////////////////////////////////

CREATE TABLE [dbo].[TIPO_CUENTA_BANCO] (
	[K_TIPO_CUENTA_BANCO]	[INT]			NOT NULL,
	[D_TIPO_CUENTA_BANCO]	[VARCHAR] (100) NOT NULL,
	[S_TIPO_CUENTA_BANCO]	[VARCHAR] (10)	NOT NULL,
	[O_TIPO_CUENTA_BANCO]	[INT]			NOT NULL,
	[C_TIPO_CUENTA_BANCO]	[VARCHAR] (255) NOT NULL,
	[L_TIPO_CUENTA_BANCO]	[INT]			NOT NULL	
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[TIPO_CUENTA_BANCO]
	ADD CONSTRAINT [PK_TIPO_CUENTA_BANCO]
		PRIMARY KEY CLUSTERED ([K_TIPO_CUENTA_BANCO])
GO

-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIPO_CUENTA_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIPO_CUENTA_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIPO_CUENTA_BANCO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_TIPO_CUENTA_BANCO		INT,
	@PP_D_TIPO_CUENTA_BANCO		VARCHAR(100),
	@PP_S_TIPO_CUENTA_BANCO		VARCHAR(10),
	@PP_O_TIPO_CUENTA_BANCO		INT,
	@PP_C_TIPO_CUENTA_BANCO		VARCHAR(255),
	@PP_L_TIPO_CUENTA_BANCO		INT
AS

	INSERT INTO TIPO_CUENTA_BANCO
		(	K_TIPO_CUENTA_BANCO,			D_TIPO_CUENTA_BANCO, 
			S_TIPO_CUENTA_BANCO,			O_TIPO_CUENTA_BANCO,
			C_TIPO_CUENTA_BANCO,
			L_TIPO_CUENTA_BANCO				)
	VALUES	
		(	@PP_K_TIPO_CUENTA_BANCO,		@PP_D_TIPO_CUENTA_BANCO,	
			@PP_S_TIPO_CUENTA_BANCO,		@PP_O_TIPO_CUENTA_BANCO,
			@PP_C_TIPO_CUENTA_BANCO,
			@PP_L_TIPO_CUENTA_BANCO			)

	-- ==============================================
GO


EXECUTE [dbo].[PG_CI_TIPO_CUENTA_BANCO] 0, 0, 0, 'SIN DEFINIR',		'XXX', 0, '', 1
EXECUTE [dbo].[PG_CI_TIPO_CUENTA_BANCO] 0, 0, 1, 'INGRESO',			'ING', 10, '', 1
EXECUTE [dbo].[PG_CI_TIPO_CUENTA_BANCO] 0, 0, 2, 'CONCENTRADORA',	'CON', 20, '', 1
EXECUTE [dbo].[PG_CI_TIPO_CUENTA_BANCO] 0, 0, 3, 'EGRESO',			'EGR', 30, '', 1
--S�lo se agreg� 3 TIPOS_CUENTA_BANCO adicionales ADR
EXECUTE [dbo].[PG_CI_TIPO_CUENTA_BANCO] 0, 0, 4, 'CREDITO',			'CRE', 40, '', 1
EXECUTE [dbo].[PG_CI_TIPO_CUENTA_BANCO] 0, 0, 5, 'INVERSION',		'INV', 50, '', 1
EXECUTE [dbo].[PG_CI_TIPO_CUENTA_BANCO] 0, 0, 6, 'OTROS',			'OTR', 60, '', 1
GO




-- //////////////////////////////////////////////////////
-- // ESTATUS_CUENTA_BANCO 
-- //////////////////////////////////////////////////////


CREATE TABLE [dbo].[ESTATUS_CUENTA_BANCO] (
	[K_ESTATUS_CUENTA_BANCO]	[INT]			NOT NULL,
	[D_ESTATUS_CUENTA_BANCO]	[VARCHAR] (100)	NOT NULL,
	[S_ESTATUS_CUENTA_BANCO]	[VARCHAR] (10)	NOT NULL,
	[O_ESTATUS_CUENTA_BANCO]	[INT]			NOT NULL,
	[C_ESTATUS_CUENTA_BANCO]	[VARCHAR] (255)	NOT NULL,
	[L_ESTATUS_CUENTA_BANCO]	[INT]			NOT NULL	
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[ESTATUS_CUENTA_BANCO]
	ADD CONSTRAINT [PK_ESTATUS_CUENTA_BANCO]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_CUENTA_BANCO])
GO

-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_CUENTA_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_CUENTA_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_CUENTA_BANCO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_ESTATUS_CUENTA_BANCO		INT,
	@PP_D_ESTATUS_CUENTA_BANCO		VARCHAR(100),
	@PP_S_ESTATUS_CUENTA_BANCO		VARCHAR(10),
	@PP_O_ESTATUS_CUENTA_BANCO		INT,
	@PP_C_ESTATUS_CUENTA_BANCO		VARCHAR(255),
	@PP_L_ESTATUS_CUENTA_BANCO		INT
AS

	INSERT INTO ESTATUS_CUENTA_BANCO
		(	K_ESTATUS_CUENTA_BANCO,			D_ESTATUS_CUENTA_BANCO, 
			S_ESTATUS_CUENTA_BANCO,			O_ESTATUS_CUENTA_BANCO,
			C_ESTATUS_CUENTA_BANCO,
			L_ESTATUS_CUENTA_BANCO				)
	VALUES	
		(	@PP_K_ESTATUS_CUENTA_BANCO,		@PP_D_ESTATUS_CUENTA_BANCO,	
			@PP_S_ESTATUS_CUENTA_BANCO,		@PP_O_ESTATUS_CUENTA_BANCO,
			@PP_C_ESTATUS_CUENTA_BANCO,
			@PP_L_ESTATUS_CUENTA_BANCO			)

	-- ==============================================
GO

EXECUTE [dbo].[PG_CI_ESTATUS_CUENTA_BANCO] 0, 0, 0, 'SIN DEFINIR',	'SINDF', 0, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CUENTA_BANCO] 0, 0, 1, 'ACTIVA',	'ACTIV', 10, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CUENTA_BANCO] 0, 0, 2, 'INACTIVA',	'INACT', 20, '', 1
GO



-- /////////////////////////////////////////////////////////////
-- // CUENTA_BANCO 						
-- /////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[CUENTA_BANCO] (
	[K_CUENTA_BANCO]			[INT]			NOT NULL,
	[D_CUENTA_BANCO]			[VARCHAR] (200) NOT NULL,
	[S_CUENTA_BANCO]			[VARCHAR] (10)	NOT NULL,
	[O_CUENTA_BANCO]			[INT]			NOT NULL,
	[C_CUENTA_BANCO]			[VARCHAR] (255) NOT NULL,
	-- ============================
	[K_RAZON_SOCIAL]			[INT]			NOT NULL,	-- WIWI/HGF // CAMPO NUEVO 20180917
	[K_BANCO]					[INT]			NOT NULL,
	[K_MONEDA]					[INT]			NOT NULL,	-- WIWI/HGF // CAMPO NUEVO 20180917
	[NUMERO_PLAZA]				[VARCHAR] (10)	NOT NULL,	-- WIWI/HGF // CAMPO NUEVO 20180917
	[NUMERO_SUCURSAL]			[VARCHAR] (10)	NOT NULL,	-- WIWI/HGF // CAMPO NUEVO 20180917
	[CUENTA]					[VARCHAR] (100) NOT NULL,
	[CLABE]						[VARCHAR] (100) NOT NULL,
	[K_ESTATUS_CUENTA_BANCO]	[INT]			NOT NULL,	
	[K_TIPO_CUENTA_BANCO]		[INT]			NOT NULL,
	[F_APERTURA]				[DATE]				NULL,
	[F_CANCELACION]				[DATE]				NULL,
	-- ============================
	[EJECUTIVO]					[VARCHAR] (200) NOT NULL,	-- WIWI/HGF // CAMPO NUEVO 20180917
	-- ============================
	-- WIWI/HGF // CAMPO NUEVO 20180917
	[TELEFONO]					[VARCHAR](100)	NOT NULL,
	[CALLE]						[VARCHAR](100)	NOT NULL,
	[NUMERO_EXTERIOR]			[VARCHAR](100)	NOT NULL,
	[NUMERO_INTERIOR]			[VARCHAR](100)	NOT NULL,
	[COLONIA]					[VARCHAR](100)	NOT NULL,
	[CP]						[VARCHAR](100)	NOT NULL,
	[POBLACION]					[VARCHAR](100)	NOT NULL,
	[MUNICIPIO]					[VARCHAR](100)	NOT NULL,
	[APODERADO]					[VARCHAR](100)	NOT NULL,
	[K_ESTADO]					[INT]			NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[CUENTA_BANCO]
	ADD CONSTRAINT [PK_CUENTA_BANCO]
		PRIMARY KEY CLUSTERED ([K_CUENTA_BANCO])
GO
/*
CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_CUENTA_BANCO_01_CUENTA] 
	   ON [dbo].[CUENTA_BANCO] ( [BANCO], [CUENTA] )
GO

CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_CUENTA_BANCO_02_CLABE] 
	   ON [dbo].[CUENTA_BANCO] ( [CLABE] )
GO
*/
-- //////////////////////////////////////////////////////

/*
-- WIWI // HGF
ALTER TABLE [dbo].[CUENTA_BANCO] ADD 
	CONSTRAINT [FK_CUENTA_BANCO_01] 
		FOREIGN KEY ([K_RAZON_SOCIAL]) 
		REFERENCES [dbo].[RAZON_SOCIAL] ([K_RAZON_SOCIAL]),
	CONSTRAINT [FK_CUENTA_BANCO_03] 
		FOREIGN KEY ([K_BANCO]) 
		REFERENCES [dbo].[BANCO] ([K_BANCO])
GO
*/

ALTER TABLE [dbo].[CUENTA_BANCO] ADD 
	CONSTRAINT [FK_CUENTA_BANCO_02] 
		FOREIGN KEY ([K_ESTATUS_CUENTA_BANCO]) 
		REFERENCES [dbo].[ESTATUS_CUENTA_BANCO] ([K_ESTATUS_CUENTA_BANCO]),
	CONSTRAINT [FK_CUENTA_BANCO_04] 
		FOREIGN KEY ([K_TIPO_CUENTA_BANCO]) 
		REFERENCES [dbo].[TIPO_CUENTA_BANCO] ([K_TIPO_CUENTA_BANCO]),
	CONSTRAINT [FK_CUENTA_BANCO_05] 
		FOREIGN KEY ([K_MONEDA]) 
		REFERENCES [dbo].[MONEDA] ([K_MONEDA])
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[CUENTA_BANCO] 
	ADD		[K_USUARIO_ALTA]				[INT]		NOT NULL,
			[F_ALTA]						[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]				[INT]		NOT NULL,
			[F_CAMBIO]						[DATETIME]	NOT NULL,
			[L_BORRADO]						[INT]		NOT NULL,
			[K_USUARIO_BAJA]				[INT]		NULL,
			[F_BAJA]						[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[CUENTA_BANCO] ADD 
	CONSTRAINT [FK_CUENTA_BANCO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_CUENTA_BANCO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_CUENTA_BANCO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////