-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PROVEEDOR / CXP
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			Alex de la Rosa
-- // Fecha creación:	24/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROVEEDOR]') AND type in (N'U'))
	DROP TABLE [dbo].[PROVEEDOR]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CATEGORIA_PROVEEDOR]') AND type in (N'U'))
	DROP TABLE [dbo].[CATEGORIA_PROVEEDOR]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_PROVEEDOR]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_PROVEEDOR]
GO




-- ////////////////////////////////////////////////////////////////
-- //					ESTATUS_PROVEEDOR				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ESTATUS_PROVEEDOR] (
	[K_ESTATUS_PROVEEDOR]				[INT]			NOT NULL,
	[D_ESTATUS_PROVEEDOR]				[VARCHAR](100)	NOT NULL,
	[C_ESTATUS_PROVEEDOR]				[VARCHAR](255)	NOT NULL,
	[S_ESTATUS_PROVEEDOR]				[VARCHAR](10)	NOT NULL,
	[O_ESTATUS_PROVEEDOR]				[INT]			NOT NULL,
	[L_ESTATUS_PROVEEDOR]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[ESTATUS_PROVEEDOR]
	ADD CONSTRAINT [PK_ESTATUS_PROVEEDOR]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_PROVEEDOR])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_PROVEEDOR_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_PROVEEDOR] ( [D_ESTATUS_PROVEEDOR] )
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_PROVEEDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_PROVEEDOR]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - ESTATUS_PROVEEDOR
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_PROVEEDOR]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_ESTATUS_PROVEEDOR				INT,
	@PP_D_ESTATUS_PROVEEDOR				VARCHAR(100),
	@PP_C_ESTATUS_PROVEEDOR				VARCHAR(255),
	@PP_S_ESTATUS_PROVEEDOR				VARCHAR(10),
	@PP_O_ESTATUS_PROVEEDOR				INT,
	@PP_L_ESTATUS_PROVEEDOR				INT
AS			
	
	-- ===========================

	INSERT INTO ESTATUS_PROVEEDOR
			(	[K_ESTATUS_PROVEEDOR], [D_ESTATUS_PROVEEDOR], 
				[C_ESTATUS_PROVEEDOR], [S_ESTATUS_PROVEEDOR], 
				[O_ESTATUS_PROVEEDOR], [L_ESTATUS_PROVEEDOR]		)
	VALUES	
			(	@PP_K_ESTATUS_PROVEEDOR, @PP_D_ESTATUS_PROVEEDOR, 
				@PP_C_ESTATUS_PROVEEDOR, @PP_S_ESTATUS_PROVEEDOR,
				@PP_O_ESTATUS_PROVEEDOR, @PP_L_ESTATUS_PROVEEDOR	 )
GO


EXECUTE [dbo].[PG_CI_ESTATUS_PROVEEDOR] 0,0,0,1, 'PREREGISTRO',	'', 'PREGT', 10,1
EXECUTE [dbo].[PG_CI_ESTATUS_PROVEEDOR] 0,0,0,2, 'ACTIVO',		'', 'ACTVO', 20,1
EXECUTE [dbo].[PG_CI_ESTATUS_PROVEEDOR] 0,0,0,3, 'SUSPENDIDO',	'', 'SUPND', 30,1
EXECUTE [dbo].[PG_CI_ESTATUS_PROVEEDOR] 0,0,0,4, 'BAJA',		'', 'BAJA', 40,1
GO





-- ////////////////////////////////////////////////////////////////
-- //					CATEGORIA_PROVEEDOR				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[CATEGORIA_PROVEEDOR] (
	[K_CATEGORIA_PROVEEDOR]				[INT]			NOT NULL,
	[D_CATEGORIA_PROVEEDOR]				[VARCHAR](100)	NOT NULL,
	[C_CATEGORIA_PROVEEDOR]				[VARCHAR](255)	NOT NULL,
	[S_CATEGORIA_PROVEEDOR]				[VARCHAR](10)	NOT NULL,
	[O_CATEGORIA_PROVEEDOR]				[INT]			NOT NULL,
	[L_CATEGORIA_PROVEEDOR]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[CATEGORIA_PROVEEDOR]
	ADD CONSTRAINT [PK_CATEGORIA_PROVEEDOR]
		PRIMARY KEY CLUSTERED ([K_CATEGORIA_PROVEEDOR])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_CATEGORIA_PROVEEDOR_01_DESCRIPCION] 
	   ON [dbo].[CATEGORIA_PROVEEDOR] ( [D_CATEGORIA_PROVEEDOR] )
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_CATEGORIA_PROVEEDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_CATEGORIA_PROVEEDOR]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - CATEGORIA_PROVEEDOR
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_CATEGORIA_PROVEEDOR]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_CATEGORIA_PROVEEDOR			INT,
	@PP_D_CATEGORIA_PROVEEDOR			VARCHAR(100),
	@PP_C_CATEGORIA_PROVEEDOR			VARCHAR(255),
	@PP_S_CATEGORIA_PROVEEDOR			VARCHAR(10),
	@PP_O_CATEGORIA_PROVEEDOR			INT,
	@PP_L_CATEGORIA_PROVEEDOR			INT
AS			
	
	-- ===========================

	INSERT INTO CATEGORIA_PROVEEDOR
			(	[K_CATEGORIA_PROVEEDOR], [D_CATEGORIA_PROVEEDOR], 
				[C_CATEGORIA_PROVEEDOR], [S_CATEGORIA_PROVEEDOR], 
				[O_CATEGORIA_PROVEEDOR], [L_CATEGORIA_PROVEEDOR]		)
	VALUES	
			(	@PP_K_CATEGORIA_PROVEEDOR, @PP_D_CATEGORIA_PROVEEDOR, 
				@PP_C_CATEGORIA_PROVEEDOR, @PP_S_CATEGORIA_PROVEEDOR,
				@PP_O_CATEGORIA_PROVEEDOR, @PP_L_CATEGORIA_PROVEEDOR	)
		
	-- //////////////////////////////////////////////////////////////
GO


EXECUTE [dbo].[PG_CI_CATEGORIA_PROVEEDOR] 0, 0, 69,  0, '(POR DEFINIR)',	'' , 'XDFNR', 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORIA_PROVEEDOR] 0, 0, 69,  1, 'GAS' ,				'' , 'GAS'	, 10 , 1
EXECUTE [dbo].[PG_CI_CATEGORIA_PROVEEDOR] 0, 0, 69,  2, 'FLETE' ,			'' , 'FLETE', 20 , 1
EXECUTE [dbo].[PG_CI_CATEGORIA_PROVEEDOR] 0, 0, 69,  3, 'COMUNICACIONES' ,	'' , 'COMM', 30 , 1
EXECUTE [dbo].[PG_CI_CATEGORIA_PROVEEDOR] 0, 0, 69,  4, 'MENSAJERIA' ,		'' , 'MNSJE', 40 , 1
EXECUTE [dbo].[PG_CI_CATEGORIA_PROVEEDOR] 0, 0, 69,  5, 'COMPUTO' ,			'' , 'COMPT', 50 , 1
EXECUTE [dbo].[PG_CI_CATEGORIA_PROVEEDOR] 0, 0, 69,  6, 'PAPELERIA' ,		'' , 'PAPEL', 60 , 1
EXECUTE [dbo].[PG_CI_CATEGORIA_PROVEEDOR] 0, 0, 69,  7, 'AVION' ,			'' , 'AVION', 70 , 1
EXECUTE [dbo].[PG_CI_CATEGORIA_PROVEEDOR] 0, 0, 69,  8, 'HOTELES' ,			'' , 'HOTLS', 80 , 1
EXECUTE [dbo].[PG_CI_CATEGORIA_PROVEEDOR] 0, 0, 69,  9, 'ALIMENTOS' ,		'' , 'ALIMT', 90 , 1
EXECUTE [dbo].[PG_CI_CATEGORIA_PROVEEDOR] 0, 0, 69, 10, 'TRANSPORTE' ,		'' , 'TRANS', 100 , 1
EXECUTE [dbo].[PG_CI_CATEGORIA_PROVEEDOR] 0, 0, 69, 11, 'SUPERMERCADO' ,	'' , 'SMCDO', 110 , 1
GO


-- ////////////////////////////////////////////////////////////////
-- //					PROVEEDOR				 
-- ////////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[PROVEEDOR] (
	[K_PROVEEDOR]						[INT] NOT NULL,
	[D_PROVEEDOR]						[VARCHAR](100) NOT NULL,
	[C_PROVEEDOR]						[VARCHAR](255) NOT NULL,
	[S_PROVEEDOR]						[VARCHAR](10) NOT NULL,
	[O_PROVEEDOR]						[INT] NOT NULL,
	-- ============================
	[RAZON_SOCIAL]						[VARCHAR](100) NOT NULL, 
	[RFC_PROVEEDOR]						[VARCHAR](100)  NOT NULL,
	[CURP]								[VARCHAR](100) NOT NULL,
	[CORREO]							[VARCHAR](100) NOT NULL,
	[TELEFONO]							[VARCHAR](100) NOT NULL,
	[N_DIAS_CREDITO]					[INT] NOT NULL,
	-- ============================
	[FISCAL_CALLE]						[VARCHAR](100) NOT NULL,
	[FISCAL_NUMERO_EXTERIOR]			[VARCHAR](100) NOT NULL,
	[FISCAL_NUMERO_INTERIOR]			[VARCHAR](100) NOT NULL,
	[FISCAL_COLONIA]					[VARCHAR](100) NOT NULL ,
	[FISCAL_POBLACION]					[VARCHAR](100) NOT NULL,
	[FISCAL_CP]							[VARCHAR](100) NOT NULL,
	[FISCAL_MUNICIPIO]					[VARCHAR](100) NOT NULL,
	[FISCAL_K_ESTADO]					[INT] NOT NULL,
	-- ============================
	[OFICINA_CALLE]						[VARCHAR](100) NOT NULL,
	[OFICINA_NUMERO_EXTERIOR]			[VARCHAR](100) NOT NULL,
	[OFICINA_NUMERO_INTERIOR]			[VARCHAR](100) NOT NULL,
	[OFICINA_COLONIA]					[VARCHAR](100) NOT NULL ,
	[OFICINA_POBLACION]					[VARCHAR](100) NOT NULL,
	[OFICINA_CP]						[VARCHAR](100) NOT NULL,
	[OFICINA_MUNICIPIO]					[VARCHAR](100) NOT NULL,
	[OFICINA_K_ESTADO]					[INT] NOT NULL,
	-- ============================
	[K_ESTATUS_PROVEEDOR]				[INT] NOT NULL,
	[K_CATEGORIA_PROVEEDOR]				[INT] NOT NULL,
	-- ============================
	[CONTACTO_VENTA]					[VARCHAR](100) NOT NULL, 
	[CONTACTO_VENTA_TELEFONO]			[VARCHAR](100) NOT NULL,
	[CONTACTO_VENTA_CORREO]				[VARCHAR](100) NOT NULL,
	-- ============================
	[CONTACTO_PAGO]						[VARCHAR](100) NOT NULL,
	[CONTACTO_PAGO_TELEFONO]			[VARCHAR](100) NOT NULL,
	[CONTACTO_PAGO_CORREO]				[VARCHAR](100) NOT NULL,
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PROVEEDOR]
	ADD CONSTRAINT [PK_PROVEEDOR]
		PRIMARY KEY CLUSTERED ([K_PROVEEDOR])
GO

/*

CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_PROVEEDOR_01_RFC] 
	   ON [dbo].[PROVEEDOR] ( [RFC] )
GO

*/


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PROVEEDOR] 
	ADD		[K_USUARIO_ALTA]			[INT] NOT NULL,
			[F_ALTA]					[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]			[INT] NOT NULL,
			[F_CAMBIO]					[DATETIME] NOT NULL,
			[L_BORRADO]					[INT] NOT NULL,
			[K_USUARIO_BAJA]			[INT] NULL,
			[F_BAJA]					[DATETIME] NULL;
GO


ALTER TABLE [dbo].[PROVEEDOR] ADD 
	CONSTRAINT [FK_PROVEEDOR_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PROVEEDOR_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PROVEEDOR_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
