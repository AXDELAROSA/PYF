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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TABLA_AMORTIZACION]') AND type in (N'U'))
	DROP TABLE [dbo].[TABLA_AMORTIZACION] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CREDITO_BANCARIO]') AND type in (N'U'))
	DROP TABLE [dbo].[CREDITO_BANCARIO] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIPO_CREDITO_BANCARIO]') AND type in (N'U'))
	DROP TABLE [dbo].[TIPO_CREDITO_BANCARIO]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_CREDITO_BANCARIO]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_CREDITO_BANCARIO]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIPO_CALCULO_CREDITO]') AND type in (N'U'))
	DROP TABLE [dbo].[MOTIVO_CREDITO_BANCARIO]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GRUPO_CREDITO]') AND type in (N'U'))
	DROP TABLE [dbo].[GRUPO_CREDITO]
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIPO_CALCULO_CREDITO]') AND type in (N'U'))
	DROP TABLE [dbo].[TIPO_CALCULO_CREDITO]
GO



/****************************************************************/
/*						TIPO_CALCULO_CREDITO					*/
/****************************************************************/

CREATE TABLE [dbo].[TIPO_CALCULO_CREDITO] (
	[K_TIPO_CALCULO_CREDITO]	[INT] NOT NULL,
	[D_TIPO_CALCULO_CREDITO]	[VARCHAR] (100) NOT NULL,
	[S_TIPO_CALCULO_CREDITO]	[VARCHAR] (10) NOT NULL,
	[O_TIPO_CALCULO_CREDITO]	[INT] NOT NULL,
	[C_TIPO_CALCULO_CREDITO]	[VARCHAR] (255) NOT NULL,
	[L_TIPO_CALCULO_CREDITO]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[TIPO_CALCULO_CREDITO]
	ADD CONSTRAINT [PK_TIPO_CALCULO_CREDITO]
		PRIMARY KEY CLUSTERED ([K_TIPO_CALCULO_CREDITO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TIPO_CALCULO_CREDITO_01_DESCRIPCION] 
	   ON [dbo].[TIPO_CALCULO_CREDITO] ( [D_TIPO_CALCULO_CREDITO] )
GO


ALTER TABLE [dbo].[TIPO_CALCULO_CREDITO] ADD 
	CONSTRAINT [FK_TIPO_CALCULO_CREDITO_01] 
		FOREIGN KEY ( [L_TIPO_CALCULO_CREDITO] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIPO_CALCULO_CREDITO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIPO_CALCULO_CREDITO]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIPO_CALCULO_CREDITO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_TIPO_CALCULO_CREDITO		INT,
	@PP_D_TIPO_CALCULO_CREDITO		VARCHAR(100),
	@PP_S_TIPO_CALCULO_CREDITO		VARCHAR(10),
	@PP_O_TIPO_CALCULO_CREDITO		INT,
	@PP_C_TIPO_CALCULO_CREDITO		VARCHAR(255),
	@PP_L_TIPO_CALCULO_CREDITO		INT
AS
	
	INSERT INTO TIPO_CALCULO_CREDITO
		(	K_TIPO_CALCULO_CREDITO,			D_TIPO_CALCULO_CREDITO, 
			S_TIPO_CALCULO_CREDITO,			O_TIPO_CALCULO_CREDITO,
			C_TIPO_CALCULO_CREDITO,
			L_TIPO_CALCULO_CREDITO			)		
	VALUES	
		(	@PP_K_TIPO_CALCULO_CREDITO,		@PP_D_TIPO_CALCULO_CREDITO,	
			@PP_S_TIPO_CALCULO_CREDITO,		@PP_O_TIPO_CALCULO_CREDITO,
			@PP_C_TIPO_CALCULO_CREDITO,
			@PP_L_TIPO_CALCULO_CREDITO		)

	-- =========================================================
GO



EXECUTE [dbo].[PG_CI_TIPO_CALCULO_CREDITO] 0, 0,  1, 'AMORT=K | D=30',			'D30',  8, '', 1
EXECUTE [dbo].[PG_CI_TIPO_CALCULO_CREDITO] 0, 0,  2, 'AMORT=K | D=VARIABLE',	'DVA',  7, '', 1
EXECUTE [dbo].[PG_CI_TIPO_CALCULO_CREDITO] 0, 0,  3, 'AMORT=K | D=31',			'D31',  9, '', 1
EXECUTE [dbo].[PG_CI_TIPO_CALCULO_CREDITO] 0, 0,  4, 'AMORT=K | D=32',			'D32', 10, '', 1
GO







/****************************************************************/
/*						GRUPO_CREDITO							*/
/****************************************************************/

CREATE TABLE [dbo].[GRUPO_CREDITO] (
	[K_GRUPO_CREDITO]	[INT] NOT NULL,
	[D_GRUPO_CREDITO]	[VARCHAR] (100) NOT NULL,
	[S_GRUPO_CREDITO]	[VARCHAR] (10) NOT NULL,
	[O_GRUPO_CREDITO]	[INT] NOT NULL,
	[C_GRUPO_CREDITO]	[VARCHAR] (255) NOT NULL,
	[L_GRUPO_CREDITO]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[GRUPO_CREDITO]
	ADD CONSTRAINT [PK_GRUPO_CREDITO]
		PRIMARY KEY CLUSTERED ([K_GRUPO_CREDITO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_GRUPO_CREDITO_01_DESCRIPCION] 
	   ON [dbo].[GRUPO_CREDITO] ( [D_GRUPO_CREDITO] )
GO


ALTER TABLE [dbo].[GRUPO_CREDITO] ADD 
	CONSTRAINT [FK_GRUPO_CREDITO_01] 
		FOREIGN KEY ( [L_GRUPO_CREDITO] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_GRUPO_CREDITO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_GRUPO_CREDITO]
GO


CREATE PROCEDURE [dbo].[PG_CI_GRUPO_CREDITO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_GRUPO_CREDITO		INT,
	@PP_D_GRUPO_CREDITO		VARCHAR(100),
	@PP_S_GRUPO_CREDITO		VARCHAR(10),
	@PP_O_GRUPO_CREDITO		INT,
	@PP_C_GRUPO_CREDITO		VARCHAR(255),
	@PP_L_GRUPO_CREDITO		INT
AS
	
	INSERT INTO GRUPO_CREDITO
		(	K_GRUPO_CREDITO,			D_GRUPO_CREDITO, 
			S_GRUPO_CREDITO,			O_GRUPO_CREDITO,
			C_GRUPO_CREDITO,
			L_GRUPO_CREDITO				)		
	VALUES	
		(	@PP_K_GRUPO_CREDITO,		@PP_D_GRUPO_CREDITO,	
			@PP_S_GRUPO_CREDITO,		@PP_O_GRUPO_CREDITO,
			@PP_C_GRUPO_CREDITO,
			@PP_L_GRUPO_CREDITO			)

	-- =========================================================
GO



EXECUTE [dbo].[PG_CI_GRUPO_CREDITO] 0, 0,  3, 'MP03 SANTANDER',		'MP#3',  8, '', 1
EXECUTE [dbo].[PG_CI_GRUPO_CREDITO] 0, 0,  4, 'MP04 BANORTE',		'MP#4',  7, '', 1
EXECUTE [dbo].[PG_CI_GRUPO_CREDITO] 0, 0,  5, 'MP05 BANCOMER',		'MP#5',  6, '', 1
EXECUTE [dbo].[PG_CI_GRUPO_CREDITO] 0, 0,  6, 'MP06 INBURSA',		'MP#6',  5, '', 1
EXECUTE [dbo].[PG_CI_GRUPO_CREDITO] 0, 0,  7, 'MP07 BANAMEX',		'MP#7',  4, '', 1
EXECUTE [dbo].[PG_CI_GRUPO_CREDITO] 0, 0,  8, 'MP08 BANCOMER',		'MP#8',  3, '', 1
EXECUTE [dbo].[PG_CI_GRUPO_CREDITO] 0, 0,  9, 'MP09 BANAMEX',		'MP#9',  2, '', 1
EXECUTE [dbo].[PG_CI_GRUPO_CREDITO] 0, 0, 10, 'MP10 SANTANDER',		'MP#10', 1, '', 1
GO



/****************************************************************/
/*					MOTIVO_CREDITO_BANCARIO						*/
/****************************************************************/

CREATE TABLE [dbo].[MOTIVO_CREDITO_BANCARIO] (
	[K_MOTIVO_CREDITO_BANCARIO]	[INT] NOT NULL,
	[D_MOTIVO_CREDITO_BANCARIO]	[VARCHAR] (100) NOT NULL,
	[S_MOTIVO_CREDITO_BANCARIO]	[VARCHAR] (10) NOT NULL,
	[O_MOTIVO_CREDITO_BANCARIO]	[INT] NOT NULL,
	[C_MOTIVO_CREDITO_BANCARIO]	[VARCHAR] (255) NOT NULL,
	[L_MOTIVO_CREDITO_BANCARIO]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[MOTIVO_CREDITO_BANCARIO]
	ADD CONSTRAINT [PK_MOTIVO_CREDITO_BANCARIO]
		PRIMARY KEY CLUSTERED ([K_MOTIVO_CREDITO_BANCARIO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_MOTIVO_CREDITO_BANCARIO_01_DESCRIPCION] 
	   ON [dbo].[MOTIVO_CREDITO_BANCARIO] ( [D_MOTIVO_CREDITO_BANCARIO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_MOTIVO_CREDITO_BANCARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_MOTIVO_CREDITO_BANCARIO]
GO


CREATE PROCEDURE [dbo].[PG_CI_MOTIVO_CREDITO_BANCARIO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_MOTIVO_CREDITO_BANCARIO		INT,
	@PP_D_MOTIVO_CREDITO_BANCARIO		VARCHAR(100),
	@PP_S_MOTIVO_CREDITO_BANCARIO		VARCHAR(10),
	@PP_O_MOTIVO_CREDITO_BANCARIO		INT,
	@PP_C_MOTIVO_CREDITO_BANCARIO		VARCHAR(255),
	@PP_L_MOTIVO_CREDITO_BANCARIO		INT
AS
	
	INSERT INTO MOTIVO_CREDITO_BANCARIO
		(	K_MOTIVO_CREDITO_BANCARIO,			D_MOTIVO_CREDITO_BANCARIO, 
			S_MOTIVO_CREDITO_BANCARIO,			O_MOTIVO_CREDITO_BANCARIO,
			C_MOTIVO_CREDITO_BANCARIO,
			L_MOTIVO_CREDITO_BANCARIO			)		
	VALUES	
		(	@PP_K_MOTIVO_CREDITO_BANCARIO,		@PP_D_MOTIVO_CREDITO_BANCARIO,	
			@PP_S_MOTIVO_CREDITO_BANCARIO,		@PP_O_MOTIVO_CREDITO_BANCARIO,
			@PP_C_MOTIVO_CREDITO_BANCARIO,
			@PP_L_MOTIVO_CREDITO_BANCARIO		)

	-- =========================================================
GO



EXECUTE [dbo].[PG_CI_MOTIVO_CREDITO_BANCARIO] 0, 0, 0, 'MOTIVO 0',			'MOTI0', 10, '', 1
EXECUTE [dbo].[PG_CI_MOTIVO_CREDITO_BANCARIO] 0, 0, 1, 'MOTIVO 1',			'MOTI1', 10, '', 1
EXECUTE [dbo].[PG_CI_MOTIVO_CREDITO_BANCARIO] 0, 0, 2, 'MOTIVO 2',			'MOTI2', 20, '', 1
EXECUTE [dbo].[PG_CI_MOTIVO_CREDITO_BANCARIO] 0, 0, 3, 'MOTIVO 3',			'MOTI3', 20, '', 1
GO



/****************************************************************/
/*					ESTATUS_CREDITO_BANCARIO					*/
/****************************************************************/

CREATE TABLE [dbo].[ESTATUS_CREDITO_BANCARIO] (
	[K_ESTATUS_CREDITO_BANCARIO]	[INT] NOT NULL,
	[D_ESTATUS_CREDITO_BANCARIO]	[VARCHAR] (100) NOT NULL,
	[S_ESTATUS_CREDITO_BANCARIO]	[VARCHAR] (10) NOT NULL,
	[O_ESTATUS_CREDITO_BANCARIO]	[INT] NOT NULL,
	[C_ESTATUS_CREDITO_BANCARIO]	[VARCHAR] (255) NOT NULL,
	[L_ESTATUS_CREDITO_BANCARIO]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[ESTATUS_CREDITO_BANCARIO]
	ADD CONSTRAINT [PK_ESTATUS_CREDITO_BANCARIO]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_CREDITO_BANCARIO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_CREDITO_BANCARIO_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_CREDITO_BANCARIO] ( [D_ESTATUS_CREDITO_BANCARIO] )
GO


ALTER TABLE [dbo].[ESTATUS_CREDITO_BANCARIO] ADD 
	CONSTRAINT [FK_ESTATUS_CREDITO_BANCARIO_01] 
		FOREIGN KEY ( [L_ESTATUS_CREDITO_BANCARIO] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_CREDITO_BANCARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_CREDITO_BANCARIO]
GO


CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_CREDITO_BANCARIO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_ESTATUS_CREDITO_BANCARIO		INT,
	@PP_D_ESTATUS_CREDITO_BANCARIO		VARCHAR(100),
	@PP_S_ESTATUS_CREDITO_BANCARIO		VARCHAR(10),
	@PP_O_ESTATUS_CREDITO_BANCARIO		INT,
	@PP_C_ESTATUS_CREDITO_BANCARIO		VARCHAR(255),
	@PP_L_ESTATUS_CREDITO_BANCARIO		INT
AS
	
	INSERT INTO ESTATUS_CREDITO_BANCARIO
		(	K_ESTATUS_CREDITO_BANCARIO,			D_ESTATUS_CREDITO_BANCARIO, 
			S_ESTATUS_CREDITO_BANCARIO,			O_ESTATUS_CREDITO_BANCARIO,
			C_ESTATUS_CREDITO_BANCARIO,
			L_ESTATUS_CREDITO_BANCARIO				)		
	VALUES	
		(	@PP_K_ESTATUS_CREDITO_BANCARIO,		@PP_D_ESTATUS_CREDITO_BANCARIO,	
			@PP_S_ESTATUS_CREDITO_BANCARIO,		@PP_O_ESTATUS_CREDITO_BANCARIO,
			@PP_C_ESTATUS_CREDITO_BANCARIO,
			@PP_L_ESTATUS_CREDITO_BANCARIO			)

	-- =========================================================
GO



EXECUTE [dbo].[PG_CI_ESTATUS_CREDITO_BANCARIO] 0, 0, 1, 'ABIERTO',			'ABIER', 10, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CREDITO_BANCARIO] 0, 0, 2, 'REVISION',			'REVSN', 20, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CREDITO_BANCARIO] 0, 0, 3, 'AUTORIZADO',		'AUTRZ', 20, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CREDITO_BANCARIO] 0, 0, 4, 'RECHAZADO',		'RECHZ', 30, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CREDITO_BANCARIO] 0, 0, 5, 'EN PAGOS',			'PAGOS', 30, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CREDITO_BANCARIO] 0, 0, 6, 'LIQUIDADO',		'LIQDD', 50, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CREDITO_BANCARIO] 0, 0, 7, 'REESTRUCTURADO',	'RSTRC', 40, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CREDITO_BANCARIO] 0, 0, 8, 'CANCELADO',		'CANCL', 40, '', 1
GO




/****************************************************************/
/*						TIPO_CREDITO_BANCARIO					*/
/****************************************************************/

CREATE TABLE [dbo].[TIPO_CREDITO_BANCARIO] (
	[K_TIPO_CREDITO_BANCARIO]	[INT] NOT NULL,
	[D_TIPO_CREDITO_BANCARIO]	[VARCHAR] (100) NOT NULL,
	[S_TIPO_CREDITO_BANCARIO]	[VARCHAR] (10) NOT NULL,
	[O_TIPO_CREDITO_BANCARIO]	[INT] NOT NULL,
	[C_TIPO_CREDITO_BANCARIO]	[VARCHAR] (255) NOT NULL,
	[L_TIPO_CREDITO_BANCARIO]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[TIPO_CREDITO_BANCARIO]
	ADD CONSTRAINT [PK_TIPO_CREDITO_BANCARIO]
		PRIMARY KEY CLUSTERED ([K_TIPO_CREDITO_BANCARIO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TIPO_CREDITO_BANCARIO_01_DESCRIPCION] 
	   ON [dbo].[TIPO_CREDITO_BANCARIO] ( [D_TIPO_CREDITO_BANCARIO] )
GO


ALTER TABLE [dbo].[TIPO_CREDITO_BANCARIO] ADD 
	CONSTRAINT [FK_TIPO_CREDITO_BANCARIO_01] 
		FOREIGN KEY ( [L_TIPO_CREDITO_BANCARIO] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIPO_CREDITO_BANCARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIPO_CREDITO_BANCARIO]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIPO_CREDITO_BANCARIO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_TIPO_CREDITO_BANCARIO		INT,
	@PP_D_TIPO_CREDITO_BANCARIO		VARCHAR(100),
	@PP_S_TIPO_CREDITO_BANCARIO		VARCHAR(10),
	@PP_O_TIPO_CREDITO_BANCARIO		INT,
	@PP_C_TIPO_CREDITO_BANCARIO		VARCHAR(255),
	@PP_L_TIPO_CREDITO_BANCARIO		INT
AS
	
	INSERT INTO TIPO_CREDITO_BANCARIO
		(	K_TIPO_CREDITO_BANCARIO,			D_TIPO_CREDITO_BANCARIO, 
			S_TIPO_CREDITO_BANCARIO,			O_TIPO_CREDITO_BANCARIO,
			C_TIPO_CREDITO_BANCARIO,
			L_TIPO_CREDITO_BANCARIO				)		
	VALUES	
		(	@PP_K_TIPO_CREDITO_BANCARIO,		@PP_D_TIPO_CREDITO_BANCARIO,	
			@PP_S_TIPO_CREDITO_BANCARIO,		@PP_O_TIPO_CREDITO_BANCARIO,
			@PP_C_TIPO_CREDITO_BANCARIO,
			@PP_L_TIPO_CREDITO_BANCARIO			)

	-- =========================================================
GO



EXECUTE [dbo].[PG_CI_TIPO_CREDITO_BANCARIO]	0, 0, 0, '( PENDIENTE )',	'??',	10, '', 1
EXECUTE [dbo].[PG_CI_TIPO_CREDITO_BANCARIO]	0, 0, 1, 'CORTO PLAZO',		'PQ',	10, '', 1
EXECUTE [dbo].[PG_CI_TIPO_CREDITO_BANCARIO]	0, 0, 2, 'MEDIANO PLAZO',	'MP',	10, '', 1
EXECUTE [dbo].[PG_CI_TIPO_CREDITO_BANCARIO]	0, 0, 3, 'LARGO PLAZO',		'LP',	10, '', 1
GO




-- ///////////////////////////////////////////////////////////////
-- //						CREDITO_BANCARIO					
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[CREDITO_BANCARIO] (
	[K_CREDITO_BANCARIO]				[INT] NOT NULL,
	[D_CREDITO_BANCARIO]				[VARCHAR] (100) NOT NULL,
	[C_CREDITO_BANCARIO]				[VARCHAR] (255) NOT NULL,
	[K_RAZON_SOCIAL_ACREDITADA]         [INT] NOT NULL,				-- WIWI // SE AGREGARON 20180918/HGF
    [K_RAZON_SOCIAL_BENEFICIADA]        [INT] NOT NULL,				-- WIWI // SE AGREGARON 20180918/HGF
	[K_GRUPO_CREDITO]					[INT] NOT NULL,
	-- ============================================
	[K_MOTIVO_CREDITO_BANCARIO]			[INT] NOT NULL,				-- WIWI // SE AGREGARON 20180917/HGF
	[JUSTIFICACION]						[VARCHAR] (500) NOT NULL,	-- WIWI // SE AGREGARON 20180917/HGF
	[K_TIPO_CREDITO_BANCARIO]			[INT] NOT NULL,
	[K_BANCO]							[INT] NOT NULL,
	[K_MONEDA]							[INT] NOT NULL,
	[K_CUENTA_BANCO_PAGO]				[INT] NOT NULL,				-- WIWI // SE MODIFICO 20180918/HGF
	-- ============================================
	[K_ESTATUS_CREDITO_BANCARIO]		[INT] NOT NULL,
	[NUMERO_CREDITO]					[VARCHAR] (100) NOT NULL,
	[F_AUTORIZACION]					[DATE] NULL,
	-- ============================================
	[K_TIPO_CALCULO_CREDITO]			[INT] NOT NULL,			
	[MONTO_PRESTAMO]					DECIMAL(19,4) NOT NULL,
	[TASA_INTERES_ANUAL]				[FLOAT] NOT NULL,  -- LA TASA SE GUARDA COMO NUMERO ENTRE CERO Y UNO (EJEMPLO 45.5%=0.455)
	[CANTIDAD_PERIODOS]					[INT] NOT NULL,
	[F_INICIO]							[DATE] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[CREDITO_BANCARIO]
	ADD CONSTRAINT [PK_CREDITO_BANCARIO]
		PRIMARY KEY CLUSTERED ([K_CREDITO_BANCARIO])
GO


-- //////////////////////////////////////////////////////


-- WIWI // HGF-20180917 // REACTIVAR PARA VINCULAR CON RAZON SOCIAL
/*
ALTER TABLE [dbo].[CREDITO_BANCARIO] ADD 
	CONSTRAINT [FK_CREDITO_BANCARIO_01] 
		FOREIGN KEY ([K_RAZON_SOCIAL_ACREDITADA]) 
		REFERENCES [dbo].[RAZON_SOCIAL] ([K_RAZON_SOCIAL]),
	CONSTRAINT [FK_CREDITO_BANCARIO_02] 
		FOREIGN KEY ([K_RAZON_SOCIAL_BENEFICIADA]) 
		REFERENCES [dbo].[RAZON_SOCIAL] ([K_RAZON_SOCIAL])
GO
*/


ALTER TABLE [dbo].[CREDITO_BANCARIO] ADD 
	CONSTRAINT [FK_CREDITO_BANCARIO_03] 
		FOREIGN KEY ([K_ESTATUS_CREDITO_BANCARIO]) 
		REFERENCES [dbo].[ESTATUS_CREDITO_BANCARIO] ([K_ESTATUS_CREDITO_BANCARIO]),
	CONSTRAINT [FK_CREDITO_BANCARIO_04] 
		FOREIGN KEY ([K_TIPO_CREDITO_BANCARIO]) 
		REFERENCES [dbo].[TIPO_CREDITO_BANCARIO] ([K_TIPO_CREDITO_BANCARIO]),
	CONSTRAINT [FK_CREDITO_BANCARIO_05] 
		FOREIGN KEY ([K_GRUPO_CREDITO]) 
		REFERENCES [dbo].[GRUPO_CREDITO] ([K_GRUPO_CREDITO]),
	CONSTRAINT [FK_CREDITO_BANCARIO_06] 
		FOREIGN KEY ([K_BANCO]) 
		REFERENCES [dbo].[BANCO] ([K_BANCO]),
	CONSTRAINT [FK_CREDITO_BANCARIO_07] 
		FOREIGN KEY ([K_MONEDA]) 
		REFERENCES [dbo].[MONEDA] ([K_MONEDA]),
	CONSTRAINT [FK_CREDITO_BANCARIO_08] 
		FOREIGN KEY ([K_TIPO_CALCULO_CREDITO]) 
		REFERENCES [dbo].[TIPO_CALCULO_CREDITO] ([K_TIPO_CALCULO_CREDITO])
GO



-- WIWI // HGF-20180917 // REACTIVAR PARA VINCULAR CON CUENTA BANCO
/*
ALTER TABLE [dbo].[CREDITO_BANCARIO] ADD 
	CONSTRAINT [FK_CREDITO_BANCARIO_09] 
		FOREIGN KEY ([K_CUENTA_BANCO_PAGO]) 
		REFERENCES [dbo].[CUENTA_BANCO] ([K_CUENTA_BANCO])
GO
*/


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[CREDITO_BANCARIO] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO



ALTER TABLE [dbo].[CREDITO_BANCARIO] ADD 
	CONSTRAINT [FK_CREDITO_BANCARIO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_CREDITO_BANCARIO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_CREDITO_BANCARIO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO


ALTER TABLE [dbo].[CREDITO_BANCARIO] 
	ADD		[O_CREDITO_BANCARIO]				[INT] NOT NULL
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////