-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			ALMACEN-GAS
-- // OPERACION:		LIBERACION / TABLAS
-- //////////////////////////////////////////////////////////////
-- // Autor:			DANIEL PORTILLO	ROMERO
-- // Fecha creación:	18/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ALMACEN]') AND type in (N'U'))
	DROP TABLE [dbo].[ALMACEN] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_ALMACEN]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_ALMACEN]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIPO_ALMACEN]') AND type in (N'U'))
	DROP TABLE [dbo].[TIPO_ALMACEN]
GO




-- //////////////////////////////////////////////////////////////
-- // TIPO_ALMACEN
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[TIPO_ALMACEN] (
	[K_TIPO_ALMACEN]	[INT] NOT NULL,
	[D_TIPO_ALMACEN]	[VARCHAR] (100) NOT NULL,
	[S_TIPO_ALMACEN]	[VARCHAR] (10) NOT NULL,
	[O_TIPO_ALMACEN]	[INT] NOT NULL,
	[C_TIPO_ALMACEN]	[VARCHAR] (255) NOT NULL,
	[L_TIPO_ALMACEN]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[TIPO_ALMACEN]
	ADD CONSTRAINT [PK_TIPO_ALMACEN]
		PRIMARY KEY CLUSTERED ([K_TIPO_ALMACEN])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TIPO_ALMACEN_01_DESCRIPCION] 
	   ON [dbo].[TIPO_ALMACEN] ( [D_TIPO_ALMACEN] )
GO


ALTER TABLE [dbo].[TIPO_ALMACEN] ADD 
	CONSTRAINT [FK_TIPO_ALMACEN_01] 
		FOREIGN KEY ( [L_TIPO_ALMACEN] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO



-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIPO_ALMACEN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIPO_ALMACEN]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIPO_ALMACEN]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	-- ========================================
	@PP_K_TIPO_ALMACEN			INT,
	@PP_D_TIPO_ALMACEN			VARCHAR(100),
	@PP_S_TIPO_ALMACEN			VARCHAR(10),
	@PP_O_TIPO_ALMACEN			INT,
	@PP_C_TIPO_ALMACEN			VARCHAR(255),
	@PP_L_TIPO_ALMACEN			INT		
AS

	INSERT INTO TIPO_ALMACEN
		(	K_TIPO_ALMACEN,				D_TIPO_ALMACEN, 
			S_TIPO_ALMACEN,				O_TIPO_ALMACEN,
			C_TIPO_ALMACEN,
			L_TIPO_ALMACEN				)
	VALUES	
		(	@PP_K_TIPO_ALMACEN,			@PP_D_TIPO_ALMACEN,	
			@PP_S_TIPO_ALMACEN,			@PP_O_TIPO_ALMACEN,
			@PP_C_TIPO_ALMACEN,
			@PP_L_TIPO_ALMACEN			)

	-- =========================================================
GO


-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_TIPO_ALMACEN] 0, 0,  1, 'ALMACEN GRANDE',		'ALMGDE',  100, '', 1
EXECUTE [dbo].[PG_CI_TIPO_ALMACEN] 0, 0,  2, 'ALMACEN MEDIANO',		'ALMMED',  101, '', 1
EXECUTE [dbo].[PG_CI_TIPO_ALMACEN] 0, 0,  3, 'ALMACEN CHICO',		'ALMCHI',  102, '', 1
EXECUTE [dbo].[PG_CI_TIPO_ALMACEN] 0, 0,  4, 'ESFERA',				'ESFERA',  203, '', 1
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================




-- //////////////////////////////////////////////////////////////
-- // ESTATUS_ALMACEN
-- //////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[ESTATUS_ALMACEN] (
	[K_ESTATUS_ALMACEN]	[INT] NOT NULL,
	[D_ESTATUS_ALMACEN]	[VARCHAR] (100) NOT NULL,
	[S_ESTATUS_ALMACEN]	[VARCHAR] (10) NOT NULL,
	[O_ESTATUS_ALMACEN]	[INT] NOT NULL,
	[C_ESTATUS_ALMACEN]	[VARCHAR] (255) NOT NULL,
	[L_ESTATUS_ALMACEN]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[ESTATUS_ALMACEN]
	ADD CONSTRAINT [PK_ESTATUS_ALMACEN]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_ALMACEN])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_ALMACEN_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_ALMACEN] ( [D_ESTATUS_ALMACEN] )
GO


ALTER TABLE [dbo].[ESTATUS_ALMACEN] ADD 
	CONSTRAINT [FK_ESTATUS_ALMACEN_01] 
		FOREIGN KEY ( [L_ESTATUS_ALMACEN] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_ALMACEN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_ALMACEN]
GO


CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_ALMACEN]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	-- ========================================
	@PP_K_ESTATUS_ALMACEN		INT,
	@PP_D_ESTATUS_ALMACEN		VARCHAR(100),
	@PP_S_ESTATUS_ALMACEN		VARCHAR(10),
	@PP_O_ESTATUS_ALMACEN		INT,
	@PP_C_ESTATUS_ALMACEN		VARCHAR(255),
	@PP_L_ESTATUS_ALMACEN		INT
AS
	
	INSERT INTO ESTATUS_ALMACEN	
		(	K_ESTATUS_ALMACEN,				D_ESTATUS_ALMACEN, 
			S_ESTATUS_ALMACEN,				O_ESTATUS_ALMACEN,
			C_ESTATUS_ALMACEN,
			L_ESTATUS_ALMACEN				)		
	VALUES	
		(	@PP_K_ESTATUS_ALMACEN,			@PP_D_ESTATUS_ALMACEN,	
			@PP_S_ESTATUS_ALMACEN,			@PP_O_ESTATUS_ALMACEN,
			@PP_C_ESTATUS_ALMACEN,
			@PP_L_ESTATUS_ALMACEN			)

	-- =========================================================
GO



-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_ESTATUS_ALMACEN] 0, 0, 1, 'ACTIVO',				'ACTVO', 1, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_ALMACEN] 0, 0, 2, 'MANTENIMIENTO',			'MANTO', 1, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_ALMACEN] 0, 0, 3, 'SUSPENDIDO',			'SUSPN', 1, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_ALMACEN] 0, 0, 4, 'CLAUSURADO',			'CLAUS', 1, '', 1
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================





-- //////////////////////////////////////////////////////////////
-- // ALMACEN
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ALMACEN] (
	-- =============================== CONTROL
	[K_ALMACEN]					[INT] NOT NULL,
	[D_ALMACEN]					[VARCHAR] (100) NOT NULL,
	[K_TIPO_ALMACEN]			[INT] NOT NULL,
	[K_ESTATUS_ALMACEN]			[INT] NOT NULL,
	-- =============================== 
	[F_OPERACION]					[DATE] NOT NULL,	
	[K_UNIDAD_OPERATIVA]			[INT] NOT NULL,
	[C_ALMACEN]						[VARCHAR] (255) NOT NULL,
	[CAPACIDAD_ALMACEN_LITROS]		DECIMAL(19,4) NOT NULL,
	[NIVEL_ALMACEN_LITROS]			DECIMAL(19,4) NOT NULL,
	[UTILIZACION_ALMACEN]			[FLOAT]
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[ALMACEN]
	ADD CONSTRAINT [PK_ALMACEN]
		PRIMARY KEY CLUSTERED ([K_ALMACEN])
GO


ALTER TABLE [dbo].[ALMACEN] ADD 
	CONSTRAINT [FK_ALMACEN_02] 
		FOREIGN KEY ([K_ESTATUS_ALMACEN]) 
		REFERENCES [dbo].[ESTATUS_ALMACEN] ([K_ESTATUS_ALMACEN]),
	CONSTRAINT [FK_ALMACEN_03] 
		FOREIGN KEY ([K_TIPO_ALMACEN]) 
		REFERENCES [dbo].[TIPO_ALMACEN] ([K_TIPO_ALMACEN]),
	CONSTRAINT [FK_ALMACEN_04] 
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA])
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[ALMACEN] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO


ALTER TABLE [dbo].[ALMACEN] ADD 
	CONSTRAINT [FK_ALMACEN_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_ALMACEN_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_ALMACEN_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO


-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ALMACEN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ALMACEN]
GO


CREATE PROCEDURE [dbo].[PG_CI_ALMACEN]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_ALMACEN			INT,
	@PP_D_ALMACEN			VARCHAR(100),
	@PP_K_ESTATUS_ALMACEN	INT,
	@PP_K_TIPO_ALMACEN		INT
AS

	INSERT INTO ALMACEN
		(	K_ALMACEN,				
			K_ESTATUS_ALMACEN,		
			K_TIPO_ALMACEN			)
	VALUES	
		(	@PP_K_ALMACEN,			
			@PP_K_ESTATUS_ALMACEN,
			@PP_K_TIPO_ALMACEN		)
	
	-- ==============================================
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
