-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			FACTURA_CXP 
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			Alex de la Rosa
-- // Fecha creación:	15/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

/*
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACTURA_CXP_XML]') AND type in (N'U'))
	DROP TABLE [dbo].[FACTURA_CXP_XML]
GO
*/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACTURA_CXP]') AND type in (N'U'))
	DROP TABLE [dbo].[FACTURA_CXP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FORMA_PAGO_FACTURA_CXP]') AND type in (N'U'))
	DROP TABLE [dbo].[FORMA_PAGO_FACTURA_CXP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[METODO_PAGO_FACTURA_CXP]') AND type in (N'U'))
	DROP TABLE [dbo].[METODO_PAGO_FACTURA_CXP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIPO_COMPROBANTE]') AND type in (N'U'))
	DROP TABLE [dbo].[TIPO_COMPROBANTE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_FACTURA_CXP]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_FACTURA_CXP]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CAPTURA_FACTURA_CXP]') AND type in (N'U'))
	DROP TABLE [dbo].[CAPTURA_FACTURA_CXP]
GO



-- ////////////////////////////////////////////////////////////////
-- //					ESTATUS_FACTURA_CXP				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ESTATUS_FACTURA_CXP] (
	[K_ESTATUS_FACTURA_CXP]		[INT]			NOT NULL,
	[D_ESTATUS_FACTURA_CXP]		[VARCHAR](100)	NOT NULL,
	[C_ESTATUS_FACTURA_CXP]		[VARCHAR](255)	NOT NULL,
	[S_ESTATUS_FACTURA_CXP]		[VARCHAR](10)	NOT NULL,
	[O_ESTATUS_FACTURA_CXP]		[INT]			NOT NULL,
	[L_ESTATUS_FACTURA_CXP]		[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[ESTATUS_FACTURA_CXP]
	ADD CONSTRAINT [PK_ESTATUS_FACTURA_CXP]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_FACTURA_CXP])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_FACTURA_CXP_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_FACTURA_CXP] ( [D_ESTATUS_FACTURA_CXP] )
GO


-- //////////////////////////////////////////////////////////////
-- //				CI - ESTATUS_FACTURA_CXP
-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_FACTURA_CXP]
GO


CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_FACTURA_CXP]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_ESTATUS_FACTURA_CXP		INT,
	@PP_D_ESTATUS_FACTURA_CXP		VARCHAR(100),
	@PP_C_ESTATUS_FACTURA_CXP		VARCHAR(255),
	@PP_S_ESTATUS_FACTURA_CXP		VARCHAR(10),
	@PP_O_ESTATUS_FACTURA_CXP		INT,
	@PP_L_ESTATUS_FACTURA_CXP		INT
AS			
	-- ===========================
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_ESTATUS_FACTURA_CXP
							FROM	ESTATUS_FACTURA_CXP
							WHERE	K_ESTATUS_FACTURA_CXP=@PP_K_ESTATUS_FACTURA_CXP

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO ESTATUS_FACTURA_CXP
				(	[K_ESTATUS_FACTURA_CXP],	[D_ESTATUS_FACTURA_CXP], 
					[C_ESTATUS_FACTURA_CXP],	[S_ESTATUS_FACTURA_CXP], 
					[O_ESTATUS_FACTURA_CXP],	[L_ESTATUS_FACTURA_CXP]			)
		VALUES	
				(	@PP_K_ESTATUS_FACTURA_CXP,	@PP_D_ESTATUS_FACTURA_CXP, 
					@PP_C_ESTATUS_FACTURA_CXP,	@PP_S_ESTATUS_FACTURA_CXP,
					@PP_O_ESTATUS_FACTURA_CXP,	@PP_L_ESTATUS_FACTURA_CXP		)
	ELSE
		UPDATE	ESTATUS_FACTURA_CXP
		SET		D_ESTATUS_FACTURA_CXP	= @PP_D_ESTATUS_FACTURA_CXP,	
				C_ESTATUS_FACTURA_CXP	= @PP_C_ESTATUS_FACTURA_CXP,
				S_ESTATUS_FACTURA_CXP	= @PP_S_ESTATUS_FACTURA_CXP,			
				O_ESTATUS_FACTURA_CXP	= @PP_O_ESTATUS_FACTURA_CXP,
				L_ESTATUS_FACTURA_CXP	= @PP_L_ESTATUS_FACTURA_CXP	
		WHERE	K_ESTATUS_FACTURA_CXP=@PP_K_ESTATUS_FACTURA_CXP

	-- =========================================================



	-- ===========================
GO


-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_ESTATUS_FACTURA_CXP] 0, 0, 69, 1, 'RECIBIDA' ,		'' , 'RECBD', 10 , 1
EXECUTE [dbo].[PG_CI_ESTATUS_FACTURA_CXP] 0, 0, 69, 2, 'ACLARACION' ,	'' , 'ACLRN', 20 , 1
EXECUTE [dbo].[PG_CI_ESTATUS_FACTURA_CXP] 0, 0, 69, 3, 'AUTORIZADA',	'' , 'AUTRZ', 30 , 1
EXECUTE [dbo].[PG_CI_ESTATUS_FACTURA_CXP] 0, 0, 69, 4, 'PROGRAMADA',	'' , 'PRGMD', 40 , 1
EXECUTE [dbo].[PG_CI_ESTATUS_FACTURA_CXP] 0, 0, 69, 5, 'PAGOS',			'' , 'PAGOS', 50 , 1
EXECUTE [dbo].[PG_CI_ESTATUS_FACTURA_CXP] 0, 0, 69, 6, 'LIQUIDADA',		'' , 'LIQUD', 60 , 1
EXECUTE [dbo].[PG_CI_ESTATUS_FACTURA_CXP] 0, 0, 69, 7, 'CANCELADA',		'' , 'CANCL', 70 , 1
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================


-- ////////////////////////////////////////////////////////////////
-- // TIPO_COMPROBANTE
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[TIPO_COMPROBANTE] (
	[K_TIPO_COMPROBANTE]		[INT]			NOT NULL,
	[D_TIPO_COMPROBANTE]		[VARCHAR](100)	NOT NULL,
	[C_TIPO_COMPROBANTE]		[VARCHAR](255)	NOT NULL,
	[S_TIPO_COMPROBANTE]		[VARCHAR](10)	NOT NULL,
	[O_TIPO_COMPROBANTE]		[INT]			NOT NULL,
	[L_TIPO_COMPROBANTE]		[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[TIPO_COMPROBANTE]
	ADD CONSTRAINT [PK_TIPO_COMPROBANTE]
		PRIMARY KEY CLUSTERED ([K_TIPO_COMPROBANTE])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TIPO_COMPROBANTE_01_DESCRIPCION] 
	   ON [dbo].[TIPO_COMPROBANTE] ( [D_TIPO_COMPROBANTE] )
GO


-- //////////////////////////////////////////////////////////////
-- // TIPO_COMPROBANTE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIPO_COMPROBANTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIPO_COMPROBANTE]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIPO_COMPROBANTE]
	@PP_L_DEBUG								INT,
	@PP_K_SISTEMA_EXE						INT,
	@PP_K_USUARIO_ACCION					INT,
	-- ===========================
	@PP_K_TIPO_COMPROBANTE		INT,
	@PP_D_TIPO_COMPROBANTE		VARCHAR(100),
	@PP_C_TIPO_COMPROBANTE		VARCHAR(255),
	@PP_S_TIPO_COMPROBANTE		VARCHAR(10),
	@PP_O_TIPO_COMPROBANTE		INT,
	@PP_L_TIPO_COMPROBANTE		INT
AS			
	
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_TIPO_COMPROBANTE
							FROM	TIPO_COMPROBANTE
							WHERE	K_TIPO_COMPROBANTE=@PP_K_TIPO_COMPROBANTE

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO TIPO_COMPROBANTE
				(	[K_TIPO_COMPROBANTE], [D_TIPO_COMPROBANTE], 
					[C_TIPO_COMPROBANTE], [S_TIPO_COMPROBANTE], 
					[O_TIPO_COMPROBANTE], [L_TIPO_COMPROBANTE]		)
		VALUES	
				(	@PP_K_TIPO_COMPROBANTE, @PP_D_TIPO_COMPROBANTE, 
					@PP_C_TIPO_COMPROBANTE, @PP_S_TIPO_COMPROBANTE,
					@PP_O_TIPO_COMPROBANTE, @PP_L_TIPO_COMPROBANTE	 )
	ELSE
		UPDATE	TIPO_COMPROBANTE
		SET		D_TIPO_COMPROBANTE	= @PP_D_TIPO_COMPROBANTE,	
				C_TIPO_COMPROBANTE	= @PP_C_TIPO_COMPROBANTE,
				S_TIPO_COMPROBANTE	= @PP_S_TIPO_COMPROBANTE,			
				O_TIPO_COMPROBANTE	= @PP_O_TIPO_COMPROBANTE,
				L_TIPO_COMPROBANTE	= @PP_L_TIPO_COMPROBANTE	
		WHERE	K_TIPO_COMPROBANTE=@PP_K_TIPO_COMPROBANTE

	-- =========================================================
GO


-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_TIPO_COMPROBANTE] 0,0,0, 0, 'SIN DOCUMENTO',	'', 'N/A', 10,1
EXECUTE [dbo].[PG_CI_TIPO_COMPROBANTE] 0,0,0, 1, 'FACTURA/PDF',		'', 'PDF', 10,1
EXECUTE [dbo].[PG_CI_TIPO_COMPROBANTE] 0,0,0, 2, 'FACTURA/XML',		'', 'XML', 20,1
EXECUTE [dbo].[PG_CI_TIPO_COMPROBANTE] 0,0,0, 3, 'REMISION',		'', 'REM', 30,1
EXECUTE [dbo].[PG_CI_TIPO_COMPROBANTE] 0,0,0, 4, 'CARTA',			'', 'CTA', 30,1
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================


-- ////////////////////////////////////////////////////////////////
-- //					METODO_PAGO_FACTURA_CXP				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[METODO_PAGO_FACTURA_CXP] (
	[K_METODO_PAGO_FACTURA_CXP]		[INT]			NOT NULL,
	[D_METODO_PAGO_FACTURA_CXP]		[VARCHAR](100)	NOT NULL,
	[C_METODO_PAGO_FACTURA_CXP]		[VARCHAR](255)	NOT NULL,
	[S_METODO_PAGO_FACTURA_CXP]		[VARCHAR](10)	NOT NULL,
	[O_METODO_PAGO_FACTURA_CXP]		[INT]			NOT NULL,
	[L_METODO_PAGO_FACTURA_CXP]		[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[METODO_PAGO_FACTURA_CXP]
	ADD CONSTRAINT [PK_METODO_PAGO_FACTURA_CXP]
		PRIMARY KEY CLUSTERED ([K_METODO_PAGO_FACTURA_CXP])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_METODO_PAGO_FACTURA_CXP_01_DESCRIPCION] 
	   ON [dbo].[METODO_PAGO_FACTURA_CXP] ( [D_METODO_PAGO_FACTURA_CXP] )
GO



-- //////////////////////////////////////////////////////////////
-- //				CI - METODO_PAGO_FACTURA_CXP
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_METODO_PAGO_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP]
GO


CREATE PROCEDURE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_METODO_PAGO_FACTURA_CXP		INT,
	@PP_D_METODO_PAGO_FACTURA_CXP		VARCHAR(100),
	@PP_C_METODO_PAGO_FACTURA_CXP		VARCHAR(255),
	@PP_S_METODO_PAGO_FACTURA_CXP		VARCHAR(10),
	@PP_O_METODO_PAGO_FACTURA_CXP		INT,
	@PP_L_METODO_PAGO_FACTURA_CXP		INT
AS			
	
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_METODO_PAGO_FACTURA_CXP
							FROM	METODO_PAGO_FACTURA_CXP
							WHERE	K_METODO_PAGO_FACTURA_CXP=@PP_K_METODO_PAGO_FACTURA_CXP

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO METODO_PAGO_FACTURA_CXP
				(	[K_METODO_PAGO_FACTURA_CXP], [D_METODO_PAGO_FACTURA_CXP], 
					[C_METODO_PAGO_FACTURA_CXP], [S_METODO_PAGO_FACTURA_CXP], 
					[O_METODO_PAGO_FACTURA_CXP], [L_METODO_PAGO_FACTURA_CXP]		)
		VALUES	
				(	@PP_K_METODO_PAGO_FACTURA_CXP, @PP_D_METODO_PAGO_FACTURA_CXP, 
					@PP_C_METODO_PAGO_FACTURA_CXP, @PP_S_METODO_PAGO_FACTURA_CXP,
					@PP_O_METODO_PAGO_FACTURA_CXP, @PP_L_METODO_PAGO_FACTURA_CXP	 )
	ELSE
		UPDATE	METODO_PAGO_FACTURA_CXP
		SET		D_METODO_PAGO_FACTURA_CXP	= @PP_D_METODO_PAGO_FACTURA_CXP,	
				C_METODO_PAGO_FACTURA_CXP	= @PP_C_METODO_PAGO_FACTURA_CXP,
				S_METODO_PAGO_FACTURA_CXP	= @PP_S_METODO_PAGO_FACTURA_CXP,			
				O_METODO_PAGO_FACTURA_CXP	= @PP_O_METODO_PAGO_FACTURA_CXP,
				L_METODO_PAGO_FACTURA_CXP	= @PP_L_METODO_PAGO_FACTURA_CXP	
		WHERE	K_METODO_PAGO_FACTURA_CXP=@PP_K_METODO_PAGO_FACTURA_CXP

	-- =========================================================
GO


-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 1,  'EFECTIVO' ,							'' , 'EFTVO' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 2,  'CHEQUE NOMINATIVO' ,					'' , 'CHQUE' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 3,  'TRANSFERENCIA ELECTRÓNICA DE FONDOS' , '' , 'TFONE' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 4,  'TARJETA DE CRÉDITO' ,					'' , 'TCRED' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 5,  'MONEDERO ELECTRÓNICO' ,				'' , 'MELCT' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 6,  'DINERO ELECTRÓNICO' ,					'' , 'DELCT' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 8,  'VALES DE DESPENSA' ,					'' , 'VDSPN' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 12, 'DACIÓN EN PAGO' ,						'' , 'DPAGO' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 13, 'PAGO POR SUBROGACIÓN' ,				'' , 'XSUBR' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 14, 'PAGO POR CONSIGNACIÓN' ,				'' , 'XCONS' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 15, 'CONDONACIÓN' ,							'' , 'CONDO' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 17, 'COMPENSACIÓN' ,						'' , 'COMPE' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 23, 'NOVACIÓN' ,							'' , 'NVACI' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 24, 'CONFUSIÓN' ,							'' , 'CFUSI' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 25, 'REMISIÓN DE DEUDA' ,					'' , 'REDEU' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 26, 'PRESCRIPCIÓN O CADUCIDAD' ,			'' , 'PRESC' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 27, 'A SATISFACCIÓN DEL ACREEDOR' ,			'' , 'SATAC' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 28, 'TARJETA DE DÉBITO' ,					'' , 'TDEBI' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 29, 'TARJETA DE SERVICIOS' ,				'' , 'TSERV' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 30, 'APLICACIÓN DE ANTICIPOS',				'' , 'AANTI' , 10 , 1
EXECUTE [dbo].[PG_CI_METODO_PAGO_FACTURA_CXP] 0, 0, 69, 99, 'POR DEFINIR' ,							'' , 'XDFNR' , 10 , 1
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================



-- ////////////////////////////////////////////////////////////////
-- //					FORMA_PAGO_FACTURA_CXP				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[FORMA_PAGO_FACTURA_CXP] (
	[K_FORMA_PAGO_FACTURA_CXP]		[INT]			NOT NULL,
	[D_FORMA_PAGO_FACTURA_CXP]		[VARCHAR](100)	NOT NULL,
	[C_FORMA_PAGO_FACTURA_CXP]		[VARCHAR](255)	NOT NULL,
	[S_FORMA_PAGO_FACTURA_CXP]		[VARCHAR](10)	NOT NULL,
	[O_FORMA_PAGO_FACTURA_CXP]		[INT]			NOT NULL,
	[L_FORMA_PAGO_FACTURA_CXP]		[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[FORMA_PAGO_FACTURA_CXP]
	ADD CONSTRAINT [PK_FORMA_PAGO_FACTURA_CXP]
		PRIMARY KEY CLUSTERED ([K_FORMA_PAGO_FACTURA_CXP])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_FORMA_PAGO_FACTURA_CXP_01_DESCRIPCION] 
	   ON [dbo].[FORMA_PAGO_FACTURA_CXP] ( [D_FORMA_PAGO_FACTURA_CXP] )
GO



-- //////////////////////////////////////////////////////////////
-- //				CI - FORMA_PAGO_FACTURA_CXP
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_FORMA_PAGO_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_FORMA_PAGO_FACTURA_CXP]
GO


CREATE PROCEDURE [dbo].[PG_CI_FORMA_PAGO_FACTURA_CXP]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_FORMA_PAGO_FACTURA_CXP	INT,
	@PP_D_FORMA_PAGO_FACTURA_CXP	VARCHAR(100),
	@PP_C_FORMA_PAGO_FACTURA_CXP	VARCHAR(255),
	@PP_S_FORMA_PAGO_FACTURA_CXP	VARCHAR(10),
	@PP_O_FORMA_PAGO_FACTURA_CXP	INT,
	@PP_L_FORMA_PAGO_FACTURA_CXP	INT
AS			
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_FORMA_PAGO_FACTURA_CXP
							FROM	FORMA_PAGO_FACTURA_CXP
							WHERE	K_FORMA_PAGO_FACTURA_CXP=@PP_K_FORMA_PAGO_FACTURA_CXP

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO FORMA_PAGO_FACTURA_CXP
				(	[K_FORMA_PAGO_FACTURA_CXP], [D_FORMA_PAGO_FACTURA_CXP], 
					[C_FORMA_PAGO_FACTURA_CXP], [S_FORMA_PAGO_FACTURA_CXP], 
					[O_FORMA_PAGO_FACTURA_CXP], [L_FORMA_PAGO_FACTURA_CXP]		)
		VALUES	
				(	@PP_K_FORMA_PAGO_FACTURA_CXP, @PP_D_FORMA_PAGO_FACTURA_CXP, 
					@PP_C_FORMA_PAGO_FACTURA_CXP, @PP_S_FORMA_PAGO_FACTURA_CXP,
					@PP_O_FORMA_PAGO_FACTURA_CXP, @PP_L_FORMA_PAGO_FACTURA_CXP	)
	ELSE
		UPDATE	FORMA_PAGO_FACTURA_CXP
		SET		D_FORMA_PAGO_FACTURA_CXP	= @PP_D_FORMA_PAGO_FACTURA_CXP,	
				C_FORMA_PAGO_FACTURA_CXP	= @PP_C_FORMA_PAGO_FACTURA_CXP,
				S_FORMA_PAGO_FACTURA_CXP	= @PP_S_FORMA_PAGO_FACTURA_CXP,			
				O_FORMA_PAGO_FACTURA_CXP	= @PP_O_FORMA_PAGO_FACTURA_CXP,
				L_FORMA_PAGO_FACTURA_CXP	= @PP_L_FORMA_PAGO_FACTURA_CXP	
		WHERE	K_FORMA_PAGO_FACTURA_CXP=@PP_K_FORMA_PAGO_FACTURA_CXP

	-- =========================================================
		
	-- ===========================

		
	-- //////////////////////////////////////////////////////////////
GO



-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_FORMA_PAGO_FACTURA_CXP] 0, 0, 69, 1, 'PAGO EN UNA SOLA EXHIBICION',		'' , 'PUE' , 10 , 1
EXECUTE [dbo].[PG_CI_FORMA_PAGO_FACTURA_CXP] 0, 0, 69, 2, 'PAGO INICIAL Y PARCIALIDADES',		'' , 'PIP' , 20 , 1
EXECUTE [dbo].[PG_CI_FORMA_PAGO_FACTURA_CXP] 0, 0, 69, 3, 'PAGO EN PARCIALIDADES O DIFERIDO',	'' , 'PPD' , 30 , 1
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================



-- ////////////////////////////////////////////////////////////////
-- //					CAPTURA_FACTURA_CXP				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[CAPTURA_FACTURA_CXP] (
	[K_CAPTURA_FACTURA_CXP]		[INT]			NOT NULL,
	[D_CAPTURA_FACTURA_CXP]		[VARCHAR](100)	NOT NULL,
	[C_CAPTURA_FACTURA_CXP]		[VARCHAR](255)	NOT NULL,
	[S_CAPTURA_FACTURA_CXP]		[VARCHAR](10)	NOT NULL,
	[O_CAPTURA_FACTURA_CXP]		[INT]			NOT NULL,
	[L_CAPTURA_FACTURA_CXP]		[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[CAPTURA_FACTURA_CXP]
	ADD CONSTRAINT [PK_CAPTURA_FACTURA_CXP]
		PRIMARY KEY CLUSTERED ([K_CAPTURA_FACTURA_CXP])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_CAPTURA_FACTURA_CXP_01_DESCRIPCION] 
	   ON [dbo].[CAPTURA_FACTURA_CXP] ( [D_CAPTURA_FACTURA_CXP] )
GO



-- //////////////////////////////////////////////////////////////
-- //				CI - CAPTURA_FACTURA_CXP
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_CAPTURA_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_CAPTURA_FACTURA_CXP]
GO


CREATE PROCEDURE [dbo].[PG_CI_CAPTURA_FACTURA_CXP]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_CAPTURA_FACTURA_CXP	INT,
	@PP_D_CAPTURA_FACTURA_CXP	VARCHAR(100),
	@PP_C_CAPTURA_FACTURA_CXP	VARCHAR(255),
	@PP_S_CAPTURA_FACTURA_CXP	VARCHAR(10),
	@PP_O_CAPTURA_FACTURA_CXP	INT,
	@PP_L_CAPTURA_FACTURA_CXP	INT
AS			
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_CAPTURA_FACTURA_CXP
							FROM	CAPTURA_FACTURA_CXP
							WHERE	K_CAPTURA_FACTURA_CXP=@PP_K_CAPTURA_FACTURA_CXP

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO CAPTURA_FACTURA_CXP
				(	[K_CAPTURA_FACTURA_CXP], [D_CAPTURA_FACTURA_CXP], 
					[C_CAPTURA_FACTURA_CXP], [S_CAPTURA_FACTURA_CXP], 
					[O_CAPTURA_FACTURA_CXP], [L_CAPTURA_FACTURA_CXP]		)
		VALUES	
				(	@PP_K_CAPTURA_FACTURA_CXP, @PP_D_CAPTURA_FACTURA_CXP, 
					@PP_C_CAPTURA_FACTURA_CXP, @PP_S_CAPTURA_FACTURA_CXP,
					@PP_O_CAPTURA_FACTURA_CXP, @PP_L_CAPTURA_FACTURA_CXP	)
	ELSE
		UPDATE	CAPTURA_FACTURA_CXP
		SET		D_CAPTURA_FACTURA_CXP	= @PP_D_CAPTURA_FACTURA_CXP,	
				S_CAPTURA_FACTURA_CXP	= @PP_S_CAPTURA_FACTURA_CXP,			
				O_CAPTURA_FACTURA_CXP	= @PP_O_CAPTURA_FACTURA_CXP,
				C_CAPTURA_FACTURA_CXP	= @PP_C_CAPTURA_FACTURA_CXP,
				L_CAPTURA_FACTURA_CXP	= @PP_L_CAPTURA_FACTURA_CXP	
		WHERE	K_CAPTURA_FACTURA_CXP=@PP_K_CAPTURA_FACTURA_CXP

	-- =========================================================
		
	-- ===========================

		
	-- //////////////////////////////////////////////////////////////
GO


-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_CAPTURA_FACTURA_CXP] 0,0,69,1, 'MANUAL',		'', 'KEY', 10,1
EXECUTE [dbo].[PG_CI_CAPTURA_FACTURA_CXP] 0,0,69,2, 'XML',			'', 'XML', 20,1
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================


-- ////////////////////////////////////////////////////////////////
-- //					FACTURA_CXP				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[FACTURA_CXP] (
	[K_FACTURA_CXP]				[INT] NOT NULL,
	[C_FACTURA_CXP]				[VARCHAR](255) NOT NULL,
	-- ============================
	[K_TIPO_COMPROBANTE]		[INT] NULL,				
	[RFC_EMISOR]				[VARCHAR] (100) NOT NULL,
	[RFC_RECEPTOR]				[VARCHAR] (100) NOT NULL,
	[K_PROVEEDOR]				[INT] NULL,				
	[K_RAZON_SOCIAL]			[INT] NULL,
	[K_UNIDAD_OPERATIVA]		[INT] NULL,
	[F_EMISION]					[DATE]	NULL,
	[SERIE]						[VARCHAR](100) NOT NULL, 
	[FOLIO]						[VARCHAR](100) NOT NULL,
	[F_VENCIMIENTO]				[DATE]	NOT NULL,
	-- ============================
	[SUBTOTAL]					[DECIMAL] (19,4) NOT NULL,
	[IVA]						[DECIMAL] (19,4) NOT NULL,
	[OTROS_IMPUESTOS]			[DECIMAL] (19,4) NOT NULL,	-- [OTROS_IMPUESTOS] = TOTAL - SUBTOTAL - IVA
	[TOTAL]						[DECIMAL] (19,4) NOT NULL,
	-- ============================
	[ABONOS]					[DECIMAL] (19,4) NOT NULL,
	[SALDO]						[DECIMAL] (19,4) NOT NULL,
	-- ============================
	[K_CAPTURA_FACTURA_CXP]		[INT] NOT NULL,
	[K_ESTATUS_FACTURA_CXP]		[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[FACTURA_CXP]
	ADD CONSTRAINT [PK_FACTURA_CXP]
		PRIMARY KEY CLUSTERED ([K_FACTURA_CXP])
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[FACTURA_CXP] ADD 
	CONSTRAINT [FK_FACTURA_CXP_01]  
		FOREIGN KEY ([K_TIPO_COMPROBANTE]) 
		REFERENCES [dbo].[TIPO_COMPROBANTE] ([K_TIPO_COMPROBANTE]),
	CONSTRAINT [FK_FACTURA_CXP_02]  
		FOREIGN KEY ([K_ESTATUS_FACTURA_CXP]) 
		REFERENCES [dbo].[ESTATUS_FACTURA_CXP] ([K_ESTATUS_FACTURA_CXP]),
	CONSTRAINT [FK_FACTURA_CXP_03]  
		FOREIGN KEY ([K_CAPTURA_FACTURA_CXP]) 
		REFERENCES [dbo].[CAPTURA_FACTURA_CXP] ([K_CAPTURA_FACTURA_CXP])
GO


-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[FACTURA_CXP] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO


ALTER TABLE [dbo].[FACTURA_CXP] ADD 
	CONSTRAINT [FK_FACTURA_CXP_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_FACTURA_CXP_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_FACTURA_CXP_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
