-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_R900_10.a_TA_Control_Viaje_20181120_ADR.sql
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CONTROL DE VIAJE 
-- // OPERACION:		LIBERACION / TABLAS
-- //////////////////////////////////////////////////////////////
-- // Autor:			Daniel Portillo Romero
-- // Fecha creación:	16/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VIATICO_XML]') AND type in (N'U'))
	DROP TABLE [dbo].[VIATICO_XML]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GASTO_VIAJE]') AND type in (N'U'))
	DROP TABLE [dbo].[GASTO_VIAJE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROVEEDOR_VIATICO]') AND type in (N'U'))
	DROP TABLE [dbo].[PROVEEDOR_VIATICO]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_PROVEEDOR_VIATICO]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_PROVEEDOR_VIATICO]
GO

-- ====================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RECURSO_VIAJE]') AND type in (N'U'))
	DROP TABLE [dbo].[RECURSO_VIAJE]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIPO_RECURSO_VIAJE]') AND type in (N'U'))
	DROP TABLE [dbo].[TIPO_RECURSO_VIAJE]
GO

-- ====================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRESUPUESTO_VIAJE]') AND type in (N'U'))
	DROP TABLE [dbo].[PRESUPUESTO_VIAJE] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RUBRO_VIATICO]') AND type in (N'U'))
	DROP TABLE [dbo].[RUBRO_VIATICO]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PASAJERO]') AND type in (N'U'))
	DROP TABLE [dbo].[PASAJERO]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PERSONA]') AND type in (N'U'))
	DROP TABLE [dbo].[PERSONA]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VIAJE]') AND type in (N'U'))
	DROP TABLE [dbo].[VIAJE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_VIAJE]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_VIAJE]
GO



-- ====================================





-- ///////////////////////////////////////////////////////////////
-- //						ESTATUS_VIAJE
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ESTATUS_VIAJE] (
	[K_ESTATUS_VIAJE]			INT NOT NULL,
	[D_ESTATUS_VIAJE]			VARCHAR (100) NOT NULL,
	[C_ESTATUS_VIAJE]			VARCHAR (255) NOT NULL,
	[S_ESTATUS_VIAJE]			VARCHAR (10) NOT NULL,
	[O_ESTATUS_VIAJE]			INT NOT NULL,
	[L_ESTATUS_VIAJE]			INT NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////

ALTER TABLE [dbo].[ESTATUS_VIAJE]
	ADD CONSTRAINT [PK_ESTATUS_VIAJE]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_VIAJE])
GO

CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_VIAJE_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_VIAJE] ( [D_ESTATUS_VIAJE] )
GO

ALTER TABLE [dbo].[ESTATUS_VIAJE] ADD 
	CONSTRAINT [FK_ESTATUS_VIAJE_01] 
		FOREIGN KEY ( [L_ESTATUS_VIAJE] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO

-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_VIAJE]
GO

-- //////////////////////////////////////////////////////////////
-- //					CI - ESTATUS_VIAJE
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_VIAJE]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_ESTATUS_VIAJE			INT,
	@PP_D_ESTATUS_VIAJE			VARCHAR(100),
	@PP_S_ESTATUS_VIAJE			VARCHAR(10),
	@PP_O_ESTATUS_VIAJE			INT,
	@PP_C_ESTATUS_VIAJE			VARCHAR(255),
	@PP_L_ESTATUS_VIAJE			INT
AS
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_ESTATUS_VIAJE
							FROM	ESTATUS_VIAJE
							WHERE	K_ESTATUS_VIAJE=@PP_K_ESTATUS_VIAJE

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO ESTATUS_VIAJE
		(	K_ESTATUS_VIAJE,			D_ESTATUS_VIAJE, 
			S_ESTATUS_VIAJE,			O_ESTATUS_VIAJE,
			C_ESTATUS_VIAJE,
			L_ESTATUS_VIAJE			)		
		VALUES	
		(	@PP_K_ESTATUS_VIAJE,		@PP_D_ESTATUS_VIAJE,	
			@PP_S_ESTATUS_VIAJE,		@PP_O_ESTATUS_VIAJE,
			@PP_C_ESTATUS_VIAJE,
			@PP_L_ESTATUS_VIAJE		)
	ELSE
		UPDATE	ESTATUS_VIAJE
		SET		D_ESTATUS_VIAJE	= @PP_D_ESTATUS_VIAJE,	
				S_ESTATUS_VIAJE	= @PP_S_ESTATUS_VIAJE,			
				O_ESTATUS_VIAJE	= @PP_O_ESTATUS_VIAJE,
				C_ESTATUS_VIAJE	= @PP_C_ESTATUS_VIAJE,
				L_ESTATUS_VIAJE	= @PP_L_ESTATUS_VIAJE	
		WHERE	K_ESTATUS_VIAJE=@PP_K_ESTATUS_VIAJE

	-- =========================================================
GO


-- ///////////////////////////////////////////////////////////////


-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_ESTATUS_VIAJE] 0, 0,  1, 'PROGRAMADO',	'PROGR', 10, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_VIAJE] 0, 0,  2, 'AUTORIZADO',	'AUTRZ', 20, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_VIAJE] 0, 0,  3, 'EN PROCESO',	'ENPRC', 30, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_VIAJE] 0, 0,  4, 'TERMINADO',	'TRMND', 40, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_VIAJE] 0, 0,  5, 'CANCELADO',	'CANCL', 50, '', 1  --AX   //   SE AGREGÓ ESTATUS
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================





-- ///////////////////////////////////////////////////////////////
-- //					PERSONA
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[PERSONA] (
	[K_PERSONA]			INT NOT NULL,
	[K_BANCO]			INT NOT NULL,
	[D_PERSONA]			VARCHAR (100) NOT NULL,
	[PUESTO]			VARCHAR (100) NOT NULL,
	[DEPARTAMENTO]		VARCHAR (100) NOT NULL,
	[JEFE_INMEDIATO]	VARCHAR (100) NOT NULL,
	[NUMERO_CUENTA]		VARCHAR (100) NOT NULL,
	[NUMERO_TARJETA]	VARCHAR (100) NOT NULL,
	[CLABE]				VARCHAR (100) NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////

ALTER TABLE [dbo].[PERSONA]
	ADD CONSTRAINT [PK_PERSONA]
		PRIMARY KEY CLUSTERED ([K_PERSONA])
GO

ALTER TABLE [dbo].[PERSONA] ADD 
	CONSTRAINT [FK_PERSONA_01]  
		FOREIGN KEY ([K_BANCO]) 
		REFERENCES [dbo].[BANCO] ([K_BANCO])
GO

ALTER TABLE [dbo].[PERSONA] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO

ALTER TABLE [dbo].[PERSONA] ADD 
	CONSTRAINT [FK_PERSONA_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PERSONA_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PERSONA_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO

-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PERSONA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PERSONA]
GO

-- //////////////////////////////////////////////////////////////
-- //					CI - PERSONA
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_PERSONA]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===============================
	@PP_K_PERSONA			INT,
	@PP_K_BANCO				INT,
	@PP_D_PERSONA			VARCHAR(100),
	@PP_PUESTO				VARCHAR(100),
	@PP_DEPARTAMENTO		VARCHAR(100),
	@PP_JEFE_INMEDIATO		VARCHAR(100),
	@PP_NUMERO_CUENTA		VARCHAR(100),
	@PP_NUMERO_TARJETA		VARCHAR(100),
	@PP_CLABE				VARCHAR(100)		
AS

	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_PERSONA
							FROM	PERSONA
							WHERE	K_PERSONA=@PP_K_PERSONA

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO PERSONA
		(	K_PERSONA,			K_BANCO,
			D_PERSONA,			PUESTO,
			DEPARTAMENTO,		JEFE_INMEDIATO,		
			NUMERO_CUENTA,		NUMERO_TARJETA, 
			CLABE,								
			-- ============================================
			[K_USUARIO_ALTA], [F_ALTA], 
			[K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
		(	@PP_K_PERSONA,		@PP_K_BANCO,
			@PP_D_PERSONA,			@PP_PUESTO,
			@PP_DEPARTAMENTO,	@PP_JEFE_INMEDIATO,	
			@PP_NUMERO_CUENTA,	@PP_NUMERO_TARJETA, 	
			@PP_CLABE,					
			-- ============================================
			@PP_K_USUARIO_ACCION, GETDATE(), 
			@PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL )	
	ELSE
		UPDATE	PERSONA
		SET		K_BANCO =			@PP_K_BANCO,
				D_PERSONA =			@PP_D_PERSONA,	
				PUESTO	=			@PP_PUESTO,			
				DEPARTAMENTO =		@PP_DEPARTAMENTO,
				JEFE_INMEDIATO =	@PP_JEFE_INMEDIATO,
				NUMERO_CUENTA =		@PP_NUMERO_CUENTA,
				NUMERO_TARJETA =	@PP_NUMERO_TARJETA,
				CLABE =				@PP_CLABE
		WHERE	K_PERSONA=@PP_K_PERSONA

	-- =========================================================
GO

-- ///////////////////////////////////////////////////////////////


-- ===============================================
SET NOCOUNT ON
-- ===============================================
EXECUTE [dbo].[PG_CI_PERSONA] 0, 0, 0,  1, 7,	'FEDERICO ROBLES',	'CONTADOR',			'FINANZAS',				'EZI',					'0999999999', '4152313399999999', '110101777799999999'
EXECUTE [dbo].[PG_CI_PERSONA] 0, 0, 0,  2, 7,	'JUAN PÉREZ',		'CONTADOR',			'CRÉDITO Y COBRANZA',	'FRANCISCO GONZÁLEZ',	'0123456789', '1029384756102938', '102938475610293847'
EXECUTE [dbo].[PG_CI_PERSONA] 0, 0, 0,  3, 1,	'CARLOS ROSALES',	'GERENTE',			'TESORERÍA',			'MARCO MORENO',			'1234567890', '5647382910102938', '112233445566778899'
EXECUTE [dbo].[PG_CI_PERSONA] 0, 0, 0,  4, 5,	'MANUEL RUÍZ',		'ADMINISTRADOR',	'TESORERÍA',			'AURORA ROJAS',			'1122334455', '1100229933884477', '123123345654678769'
EXECUTE [dbo].[PG_CI_PERSONA] 0, 0, 0,  5, 10,	'MARCELA MOLINA',	'CAJERA',			'LIQUIDACIONES',		'MÓNICA FLORES',		'6677889900', '5566447733882299', '998877665544332211'
EXECUTE [dbo].[PG_CI_PERSONA] 0, 0, 0,  6, 11,	'LORENA REZA',		'CONTADORA',		'IMPORTADORA',			'ERNESTO CORTÉS',		'9876543210', '1526374859605948', '665757744830033330'
EXECUTE [dbo].[PG_CI_PERSONA] 0, 0, 0,  7, 8,	'LIZETH LOMAS',		'ADMINISTRADORA',	'VENTAS',				'PATRICIO PULIDO',		'9087234157', '1234567890123456', '110029386475875390'
EXECUTE [dbo].[PG_CI_PERSONA] 0, 0, 0,  8, 23,	'MARIO CARRANZA',	'GERENTE',			'TRANSPORTADORA',		'TERESA VALLE',			'5644729901', '2910836474839201', '234532246788876561'
GO
-- ===============================================
SET NOCOUNT OFF
-- ===============================================




-- ///////////////////////////////////////////////////////////////
-- //				VIAJE				
-- ///////////////////////////////////////////////////////////////
		
CREATE TABLE [dbo].[VIAJE] (
	[K_VIAJE]				INT NOT NULL,
	-- ===================================
	[K_AUTORIZACION]		INT NOT NULL,
	[K_RAZON_SOCIAL]		INT NOT NULL,
	[K_UNIDAD_OPERATIVA]	INT NOT NULL,
	[K_ESTATUS_VIAJE]		INT NOT NULL,
	[K_PERSONA_RESPONSABLE]	INT NOT NULL,
	-- ===================================
	[D_VIAJE]				VARCHAR (255) NOT NULL,
	[ORIGEN]				VARCHAR (100) NOT NULL,
	[DESTINO]				VARCHAR (100) NOT NULL,
	[MOTIVO]				VARCHAR (255) NOT NULL,
	-- ===================================
	[F_INICIO_TENTATIVO]	DATE NOT NULL,
	[F_INICIO_REAL]			DATE NOT NULL,
	[F_FINAL_TENTATIVO]		DATE NOT NULL,
	[F_FINAL_REAL]			DATE NOT NULL,
	-- ===================================
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////

ALTER TABLE [dbo].[VIAJE]
	ADD CONSTRAINT [PK_VIAJE]
		PRIMARY KEY CLUSTERED ([K_VIAJE])
GO

/*
CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_VIAJE_01_DESCRIPCION] 
	   ON [dbo].[VIAJE] ( [D_VIAJE] )
GO
*/

ALTER TABLE [dbo].[VIAJE] ADD 
	CONSTRAINT [FK_VIAJE_01] 
		FOREIGN KEY ( [K_ESTATUS_VIAJE] ) 
		REFERENCES [dbo].[ESTATUS_VIAJE] ( [K_ESTATUS_VIAJE] ),
	CONSTRAINT [FK_VIAJE_02] 
		FOREIGN KEY ( [K_AUTORIZACION] ) 
		REFERENCES [dbo].[AUTORIZACION] ( [K_AUTORIZACION] ),
	CONSTRAINT [FK_VIAJE_03] 
		FOREIGN KEY ( [K_RAZON_SOCIAL] ) 
		REFERENCES [dbo].[RAZON_SOCIAL] ( [K_RAZON_SOCIAL] ),
	CONSTRAINT [FK_VIAJE_04] 
		FOREIGN KEY ( [K_UNIDAD_OPERATIVA] ) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ( [K_UNIDAD_OPERATIVA] )
GO

ALTER TABLE [dbo].[VIAJE] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO

ALTER TABLE [dbo].[VIAJE] ADD 
	CONSTRAINT [FK_VIAJE_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_VIAJE_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_VIAJE_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO

-- //////////////////////////////////////////////////////////////




-- ///////////////////////////////////////////////////////////////
-- //					PASAJERO
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[PASAJERO] (
	[K_VIAJE]				INT NOT NULL,
	[K_PERSONA]				INT NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////

ALTER TABLE [dbo].[PASAJERO]
	ADD CONSTRAINT [PK_PASAJERO]
		PRIMARY KEY CLUSTERED ( [K_VIAJE], [K_PERSONA] )
GO

ALTER TABLE [dbo].[PASAJERO] ADD 
	CONSTRAINT [FK_PASAJERO_01] 
		FOREIGN KEY ( [K_PERSONA] ) 
		REFERENCES [dbo].[PERSONA] ( [K_PERSONA] ),
	CONSTRAINT [FK_PASAJERO_02] 
		FOREIGN KEY ( [K_VIAJE] ) 
		REFERENCES [dbo].[VIAJE] ( [K_VIAJE] )
GO

ALTER TABLE [dbo].[PASAJERO] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO

ALTER TABLE [dbo].[PASAJERO] ADD 
	CONSTRAINT [FK_PASAJERO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PASAJERO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PASAJERO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO

-- //////////////////////////////////////////////////////////////




-- ////////////////////////////////////////////////////////////////
-- //					RUBRO_VIATICO				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[RUBRO_VIATICO] (
	[K_RUBRO_VIATICO]			[INT]			NOT NULL,
	[D_RUBRO_VIATICO]			[VARCHAR](100)	NOT NULL,
	[C_RUBRO_VIATICO]			[VARCHAR](255)	NOT NULL,
	[S_RUBRO_VIATICO]			[VARCHAR](10)	NOT NULL,
	[O_RUBRO_VIATICO]			[INT]			NOT NULL,
	[L_RUBRO_VIATICO]			[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[RUBRO_VIATICO]
	ADD CONSTRAINT [PK_RUBRO_VIATICO]
		PRIMARY KEY CLUSTERED ([K_RUBRO_VIATICO])
GO

CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_RUBRO_VIATICO_01_DESCRIPCION] 
	   ON [dbo].[RUBRO_VIATICO] ( [D_RUBRO_VIATICO] )
GO

-- ////////////////////////////////////////////////////// 

ALTER TABLE [dbo].[RUBRO_VIATICO] 
	ADD		[L_BORRADO]					[INT] NOT NULL,
			[K_USUARIO_BAJA]			[INT] NULL,
			[F_BAJA]					[DATETIME] NULL;
GO

-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_RUBRO_VIATICO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_RUBRO_VIATICO]
GO

-- //////////////////////////////////////////////////////////////
-- //				CI - RUBRO_VIATICO
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_RUBRO_VIATICO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_RUBRO_VIATICO				INT,
	@PP_D_RUBRO_VIATICO				VARCHAR(100),
	@PP_C_RUBRO_VIATICO				VARCHAR(255),
	@PP_S_RUBRO_VIATICO				VARCHAR(10),
	@PP_O_RUBRO_VIATICO				INT,
	@PP_L_RUBRO_VIATICO				INT
AS			
	
	-- ===========================

	INSERT INTO RUBRO_VIATICO
			(	[K_RUBRO_VIATICO], [D_RUBRO_VIATICO], 
				[C_RUBRO_VIATICO], [S_RUBRO_VIATICO], 
				[O_RUBRO_VIATICO], [L_RUBRO_VIATICO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
	VALUES	
			(	@PP_K_RUBRO_VIATICO, @PP_D_RUBRO_VIATICO, 
				@PP_C_RUBRO_VIATICO, @PP_S_RUBRO_VIATICO,
				@PP_O_RUBRO_VIATICO, @PP_L_RUBRO_VIATICO,
				0, NULL, NULL )
GO

-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_RUBRO_VIATICO] 0,0,0,1,  'AVIÓN',				'', 'AVIÓN',  10,1
EXECUTE [dbo].[PG_CI_RUBRO_VIATICO] 0,0,0,2,  'HOTEL',				'', 'HOTEL',  20,1
EXECUTE [dbo].[PG_CI_RUBRO_VIATICO] 0,0,0,3,  'COMBUSTIBLE',		'', 'CMBST',  30,1
EXECUTE [dbo].[PG_CI_RUBRO_VIATICO] 0,0,0,4,  'ALIMENTOS',			'', 'ALIM',   40,1
EXECUTE [dbo].[PG_CI_RUBRO_VIATICO] 0,0,0,5,  'TAXI',				'', 'TAXI',	  50,1
EXECUTE [dbo].[PG_CI_RUBRO_VIATICO] 0,0,0,6,  'AUTOBUS',			'', 'ATBUS',  60,1
EXECUTE [dbo].[PG_CI_RUBRO_VIATICO] 0,0,0,7,  'CASETAS',			'', 'CASTS',  70,1
EXECUTE [dbo].[PG_CI_RUBRO_VIATICO] 0,0,0,8,  'RENTA DE AUTO',		'', 'RNTAU',  80,1
EXECUTE [dbo].[PG_CI_RUBRO_VIATICO] 0,0,0,9,  'SOBRE EQUIPAJE',		'', 'SBREQ',  90,1
EXECUTE [dbo].[PG_CI_RUBRO_VIATICO] 0,0,0,10, 'LAVANDERÍA',			'', 'LVNDR',  100,1
EXECUTE [dbo].[PG_CI_RUBRO_VIATICO] 0,0,0,11, 'ESTACIONAMIENTO',	'', 'ESTCM',  110,1
EXECUTE [dbo].[PG_CI_RUBRO_VIATICO] 0,0,0,12, 'OTROS',				'', 'OTROS',  120,1
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================




-- ///////////////////////////////////////////////////////////////
-- //					PRESUPUESTO_VIAJE					
-- ///////////////////////////////////////////////////////////////
	
CREATE TABLE [dbo].[PRESUPUESTO_VIAJE] (
	-- =============================== CONTROL
	[K_VIAJE]								INT NOT NULL, 
	[K_PRESUPUESTO_VIAJE]					INT NOT NULL,
	[K_RUBRO_VIATICO]						INT NOT NULL,
	-- ============================== 
	[F_PRESUPUESTO_VIAJE]					DATE NOT NULL,
	[MONTO_PROPUESTO]						DECIMAL(19,4) NOT NULL,
	[MONTO_AUTORIZADO]						DECIMAL(19,4) NOT NULL,
	[C_PRESUPUESTO_VIAJE]					VARCHAR(500) NOT NULL,
	-- ============================== 
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PRESUPUESTO_VIAJE]
	ADD CONSTRAINT [PK_PRESUPUESTO_VIAJE]
		PRIMARY KEY CLUSTERED ( [K_VIAJE], [K_PRESUPUESTO_VIAJE])
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PRESUPUESTO_VIAJE] ADD 
	CONSTRAINT [FK_PRESUPUESTO_VIAJE_01]
		FOREIGN KEY ([K_VIAJE]) 
		REFERENCES [dbo].[VIAJE] ([K_VIAJE]),
	CONSTRAINT [FK_PRESUPUESTO_VIAJE_02]			
		FOREIGN KEY ([K_RUBRO_VIATICO]) 
		REFERENCES [dbo].[RUBRO_VIATICO] ([K_RUBRO_VIATICO])
GO


ALTER TABLE [dbo].[PRESUPUESTO_VIAJE] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO



ALTER TABLE [dbo].[PRESUPUESTO_VIAJE] ADD 
	CONSTRAINT [FK_PRESUPUESTO_VIAJE_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PRESUPUESTO_VIAJE_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PRESUPUESTO_VIAJE_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO

-- //////////////////////////////////////////////////////////////



-- ///////////////////////////////////////////////////////////////
-- //					TIPO_RECURSO_VIAJE
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[TIPO_RECURSO_VIAJE] (
	[K_TIPO_RECURSO_VIAJE]			INT NOT NULL,
	[D_TIPO_RECURSO_VIAJE]			VARCHAR (100) NOT NULL,
	[C_TIPO_RECURSO_VIAJE]			VARCHAR (255) NOT NULL,
	[S_TIPO_RECURSO_VIAJE]			VARCHAR (10) NOT NULL,
	[O_TIPO_RECURSO_VIAJE]			INT NOT NULL,
	[L_TIPO_RECURSO_VIAJE]			INT NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////

ALTER TABLE [dbo].[TIPO_RECURSO_VIAJE]
	ADD CONSTRAINT [PK_TIPO_RECURSO_VIAJE]
		PRIMARY KEY CLUSTERED ([K_TIPO_RECURSO_VIAJE])
GO

CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TIPO_RECURSO_VIAJE_01_DESCRIPCION] 
	   ON [dbo].[TIPO_RECURSO_VIAJE] ( [D_TIPO_RECURSO_VIAJE] )
GO

ALTER TABLE [dbo].[TIPO_RECURSO_VIAJE] ADD 
	CONSTRAINT [FK_TIPO_RECURSO_VIAJE_01] 
		FOREIGN KEY ( [L_TIPO_RECURSO_VIAJE] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO

-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIPO_RECURSO_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIPO_RECURSO_VIAJE]
GO

-- //////////////////////////////////////////////////////////////
-- //					CI - TIPO_RECURSO_VIAJE
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_TIPO_RECURSO_VIAJE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_TIPO_RECURSO_VIAJE		INT,
	@PP_D_TIPO_RECURSO_VIAJE		VARCHAR(100),
	@PP_S_TIPO_RECURSO_VIAJE		VARCHAR(10),
	@PP_O_TIPO_RECURSO_VIAJE		INT,
	@PP_C_TIPO_RECURSO_VIAJE		VARCHAR(255),
	@PP_L_TIPO_RECURSO_VIAJE		INT
AS
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_TIPO_RECURSO_VIAJE
							FROM	TIPO_RECURSO_VIAJE
							WHERE	K_TIPO_RECURSO_VIAJE=@PP_K_TIPO_RECURSO_VIAJE

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO TIPO_RECURSO_VIAJE
		(	K_TIPO_RECURSO_VIAJE,			D_TIPO_RECURSO_VIAJE, 
			S_TIPO_RECURSO_VIAJE,			O_TIPO_RECURSO_VIAJE,
			C_TIPO_RECURSO_VIAJE,
			L_TIPO_RECURSO_VIAJE			)		
		VALUES	
		(	@PP_K_TIPO_RECURSO_VIAJE,		@PP_D_TIPO_RECURSO_VIAJE,	
			@PP_S_TIPO_RECURSO_VIAJE,		@PP_O_TIPO_RECURSO_VIAJE,
			@PP_C_TIPO_RECURSO_VIAJE,
			@PP_L_TIPO_RECURSO_VIAJE		)
	ELSE
		UPDATE	TIPO_RECURSO_VIAJE
		SET		D_TIPO_RECURSO_VIAJE	= @PP_D_TIPO_RECURSO_VIAJE,	
				S_TIPO_RECURSO_VIAJE	= @PP_S_TIPO_RECURSO_VIAJE,			
				O_TIPO_RECURSO_VIAJE	= @PP_O_TIPO_RECURSO_VIAJE,
				C_TIPO_RECURSO_VIAJE	= @PP_C_TIPO_RECURSO_VIAJE,
				L_TIPO_RECURSO_VIAJE	= @PP_L_TIPO_RECURSO_VIAJE	
		WHERE	K_TIPO_RECURSO_VIAJE=@PP_K_TIPO_RECURSO_VIAJE

	-- =========================================================
GO


-- ///////////////////////////////////////////////////////////////


-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_TIPO_RECURSO_VIAJE] 0, 0,  1, 'PAGO',			'PAGO',  10, '', 1
EXECUTE [dbo].[PG_CI_TIPO_RECURSO_VIAJE] 0, 0,  2, 'DOTACIÓN',		'DOTCN', 20, '', 1
EXECUTE [dbo].[PG_CI_TIPO_RECURSO_VIAJE] 0, 0,  3, 'DEVOLUCIÓN',	'DEVLC', 30, '', 1
EXECUTE [dbo].[PG_CI_TIPO_RECURSO_VIAJE] 0, 0,  4, 'REEMBOLSO',		'REMBL', 40, '', 1
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================




-- ///////////////////////////////////////////////////////////////
-- //					RECURSO_VIAJE					
-- ///////////////////////////////////////////////////////////////
	
CREATE TABLE [dbo].[RECURSO_VIAJE] (
	-- =============================== CONTROL
	[K_RECURSO_VIAJE]			INT NOT NULL,
	[D_RECURSO_VIAJE]			VARCHAR(255) NOT NULL,
	[C_RECURSO_VIAJE]			VARCHAR(500) NOT NULL,
	-- ============================== 
	[MONTO]						DECIMAL(19,4) NOT NULL,
	[F_RECURSO_VIAJE]			DATE NOT NULL,
	-- ============================== 
	[K_TIPO_RECURSO_VIAJE]		INT NOT NULL,
	[K_VIAJE]					INT NOT NULL, 
	-- ============================== 
	[K_RAZON_SOCIAL]			INT NOT NULL,
	[K_UNIDAD_OPERATIVA]		INT NOT NULL,
	[K_CUENTA_BANCO]			INT NOT NULL,
	-- =============================== 
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[RECURSO_VIAJE]
	ADD CONSTRAINT [PK_RECURSO_VIAJE]
		PRIMARY KEY CLUSTERED ([K_RECURSO_VIAJE])
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[RECURSO_VIAJE] ADD 
	CONSTRAINT [FK_RECURSO_VIAJE_01] 
		FOREIGN KEY ([K_TIPO_RECURSO_VIAJE]) 
		REFERENCES [dbo].[TIPO_RECURSO_VIAJE] ([K_TIPO_RECURSO_VIAJE]),
	CONSTRAINT [FK_RECURSO_VIAJE_02] 
		FOREIGN KEY ([K_VIAJE]) 
		REFERENCES [dbo].[VIAJE] ([K_VIAJE]),
	CONSTRAINT [FK_RECURSO_VIAJE_03] 
		FOREIGN KEY ([K_RAZON_SOCIAL]) 
		REFERENCES [dbo].[RAZON_SOCIAL] ([K_RAZON_SOCIAL]),
	CONSTRAINT [FK_RECURSO_VIAJE_04] 
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA]),
	CONSTRAINT [FK_RECURSO_VIAJE_05] 
		FOREIGN KEY ([K_CUENTA_BANCO]) 
		REFERENCES [dbo].[CUENTA_BANCO] ([K_CUENTA_BANCO])
GO


ALTER TABLE [dbo].[RECURSO_VIAJE] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO

ALTER TABLE [dbo].[RECURSO_VIAJE] ADD 
	CONSTRAINT [FK_RECURSO_VIAJE_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_RECURSO_VIAJE_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_RECURSO_VIAJE_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO

-- //////////////////////////////////////////////////////////////






-- ///////////////////////////////////////////////////////////////
-- //					GASTO_VIAJE					
-- ///////////////////////////////////////////////////////////////
	
CREATE TABLE [dbo].[GASTO_VIAJE] (
	-- =============================== CONTROL
	[K_VIAJE]						INT NOT NULL, 
	[K_GASTO_VIAJE]					INT NOT NULL,
	[K_RUBRO_VIATICO]				INT NOT NULL,
	-- ============================== 
	[F_GASTO_VIAJE]					DATE NOT NULL,
	[MONTO]							DECIMAL(19,4) NOT NULL,
	[MONTO_AUTORIZADO]				DECIMAL(19,4) NOT NULL,
	[C_GASTO_VIAJE]					VARCHAR(500) NOT NULL
	-- =============================== 
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[GASTO_VIAJE]
	ADD CONSTRAINT [PK_GASTO_VIAJE]
		PRIMARY KEY CLUSTERED ([K_GASTO_VIAJE])
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[GASTO_VIAJE] ADD 
	--CONSTRAINT [FK_GASTO_VIAJE_01]									--AX   //   SE QUITAN, AL ELIMINARSE DE LA TABLA
	--	FOREIGN KEY ([K_RUBRO_GASTO_VIAJE]) 
	--	REFERENCES [dbo].[RUBRO_GASTO_VIAJE] ([K_RUBRO_GASTO_VIAJE]),
	CONSTRAINT [FK_GASTO_VIAJE_02] 
		FOREIGN KEY ([K_VIAJE]) 
		REFERENCES [dbo].[VIAJE] ([K_VIAJE])
GO

ALTER TABLE [dbo].[GASTO_VIAJE] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO

ALTER TABLE [dbo].[GASTO_VIAJE] ADD 
	CONSTRAINT [FK_GASTO_VIAJE_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_GASTO_VIAJE_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_GASTO_VIAJE_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO

-- //////////////////////////////////////////////////////////////





-- ////////////////////////////////////////////////////////////////
-- //					ESTATUS_PROVEEDOR_VIATICO				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ESTATUS_PROVEEDOR_VIATICO] (
	[K_ESTATUS_PROVEEDOR_VIATICO]				[INT]			NOT NULL,
	[D_ESTATUS_PROVEEDOR_VIATICO]				[VARCHAR](100)	NOT NULL,
	[C_ESTATUS_PROVEEDOR_VIATICO]				[VARCHAR](255)	NOT NULL,
	[S_ESTATUS_PROVEEDOR_VIATICO]				[VARCHAR](10)	NOT NULL,
	[O_ESTATUS_PROVEEDOR_VIATICO]				[INT]			NOT NULL,
	[L_ESTATUS_PROVEEDOR_VIATICO]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[ESTATUS_PROVEEDOR_VIATICO]
	ADD CONSTRAINT [PK_ESTATUS_PROVEEDOR_VIATICO]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_PROVEEDOR_VIATICO])
GO

CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_PROVEEDOR_VIATICO_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_PROVEEDOR_VIATICO] ( [D_ESTATUS_PROVEEDOR_VIATICO] )
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_PROVEEDOR_VIATICO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_PROVEEDOR_VIATICO]
GO

-- //////////////////////////////////////////////////////////////

-- //////////////////////////////////////////////////////////////
-- //				CI - ESTATUS_PROVEEDOR_VIATICO
-- //////////////////////////////////////////////////////////////

CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_PROVEEDOR_VIATICO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_ESTATUS_PROVEEDOR_VIATICO				INT,
	@PP_D_ESTATUS_PROVEEDOR_VIATICO				VARCHAR(100),
	@PP_C_ESTATUS_PROVEEDOR_VIATICO				VARCHAR(255),
	@PP_S_ESTATUS_PROVEEDOR_VIATICO				VARCHAR(10),
	@PP_O_ESTATUS_PROVEEDOR_VIATICO				INT,
	@PP_L_ESTATUS_PROVEEDOR_VIATICO				INT
AS			
	
	-- ===========================

	INSERT INTO ESTATUS_PROVEEDOR_VIATICO
			(	[K_ESTATUS_PROVEEDOR_VIATICO], [D_ESTATUS_PROVEEDOR_VIATICO], 
				[C_ESTATUS_PROVEEDOR_VIATICO], [S_ESTATUS_PROVEEDOR_VIATICO], 
				[O_ESTATUS_PROVEEDOR_VIATICO], [L_ESTATUS_PROVEEDOR_VIATICO]		)
	VALUES	
			(	@PP_K_ESTATUS_PROVEEDOR_VIATICO, @PP_D_ESTATUS_PROVEEDOR_VIATICO, 
				@PP_C_ESTATUS_PROVEEDOR_VIATICO, @PP_S_ESTATUS_PROVEEDOR_VIATICO,
				@PP_O_ESTATUS_PROVEEDOR_VIATICO, @PP_L_ESTATUS_PROVEEDOR_VIATICO	 )
GO

-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_ESTATUS_PROVEEDOR_VIATICO] 0,0,0,1, 'PREREGISTRO',	'', 'PREGT', 10,1
EXECUTE [dbo].[PG_CI_ESTATUS_PROVEEDOR_VIATICO] 0,0,0,2, 'ACTIVO',		'', 'ACTVO', 20,1
EXECUTE [dbo].[PG_CI_ESTATUS_PROVEEDOR_VIATICO] 0,0,0,3, 'SUSPENDIDO',	'', 'SUPND', 30,1
EXECUTE [dbo].[PG_CI_ESTATUS_PROVEEDOR_VIATICO] 0,0,0,4, 'BAJA',		'', 'BAJA',  40,1
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================








-- ////////////////////////////////////////////////////////////////
-- //					PROVEEDOR_VIATICO				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[PROVEEDOR_VIATICO] (
	[K_PROVEEDOR_VIATICO]				[INT] NOT NULL,
	[D_PROVEEDOR_VIATICO]				[VARCHAR](100) NOT NULL,
	[C_PROVEEDOR_VIATICO]				[VARCHAR](255) NOT NULL,
	[S_PROVEEDOR_VIATICO]				[VARCHAR](10) NOT NULL,
	[O_PROVEEDOR_VIATICO]				[INT] NOT NULL,
	-- ============================
	[RAZON_SOCIAL_PROVEEDOR_VIATICO]	[VARCHAR](100) NOT NULL, 
	[RFC_PROVEEDOR_VIATICO]				[VARCHAR](100)  NOT NULL,
	-- ============================
	[K_ESTATUS_PROVEEDOR_VIATICO]		[INT] NOT NULL,
	[K_RUBRO_VIATICO]					[INT] NOT NULL,
	-- ============================
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PROVEEDOR_VIATICO]
	ADD CONSTRAINT [PK_PROVEEDOR_VIATICO]
		PRIMARY KEY CLUSTERED ([K_PROVEEDOR_VIATICO])
GO

/*

CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_PROVEEDOR_VIATICO_01_RFC] 
	   ON [dbo].[PROVEEDOR_VIATICO] ( [RFC] )
GO

*/

ALTER TABLE [dbo].[PROVEEDOR_VIATICO] ADD 
	CONSTRAINT [FK_PROVEEDOR_VIATICO_01]  
		FOREIGN KEY ([K_ESTATUS_PROVEEDOR_VIATICO]) 
		REFERENCES [dbo].[ESTATUS_PROVEEDOR_VIATICO] ([K_ESTATUS_PROVEEDOR_VIATICO]),
	CONSTRAINT [FK_PROVEEDOR_VIATICO_02]  
		FOREIGN KEY ([K_RUBRO_VIATICO]) 
		REFERENCES [dbo].[RUBRO_VIATICO] ([K_RUBRO_VIATICO])
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PROVEEDOR_VIATICO] 
	ADD		[K_USUARIO_ALTA]			[INT] NOT NULL,
			[F_ALTA]					[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]			[INT] NOT NULL,
			[F_CAMBIO]					[DATETIME] NOT NULL,
			[L_BORRADO]					[INT] NOT NULL,
			[K_USUARIO_BAJA]			[INT] NULL,
			[F_BAJA]					[DATETIME] NULL;
GO


ALTER TABLE [dbo].[PROVEEDOR_VIATICO] ADD 
	CONSTRAINT [FK_PROVEEDOR_VIATICO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PROVEEDOR_VIATICO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PROVEEDOR_VIATICO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO

-- //////////////////////////////////////////////////////




-- ////////////////////////////////////////////////////////////////
-- //					VIATICO_XML				 
-- ////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[VIATICO_XML] (
	[K_VIATICO_XML]							[INT] NOT NULL,
	[C_VIATICO_XML]							[VARCHAR](255) NOT NULL,
	-- ============================
	[K_VIAJE]								[INT] NOT NULL,
	[K_PROVEEDOR_VIATICO]					[INT] NOT NULL,
	-- ============================
	[VIATICO_XML_Fecha]						[DATETIME]	NOT NULL,
	[VIATICO_XML_Folio]						[VARCHAR] (100) NOT NULL,
	[VIATICO_XML_FormaPago]					[VARCHAR] (100) NOT NULL,
	[VIATICO_XML_LugarExpedicion]			[VARCHAR] (100) NOT NULL,
	[VIATICO_XML_MetodoPago]				[VARCHAR] (100) NOT NULL, 
	[VIATICO_XML_Moneda]					[VARCHAR] (100) NOT NULL,
	[VIATICO_XML_NoCertificado]				[VARCHAR] (100) NOT NULL,
	[VIATICO_XML_Serie]						[VARCHAR] (100) NOT NULL, 
	[VIATICO_XML_SubTotal]					[DECIMAL] (19,4) NOT NULL,
	[VIATICO_XML_TipoCambio]				[VARCHAR] (100) NOT NULL, 
	[VIATICO_XML_TipoDeComprobante]			[VARCHAR] (100) NOT NULL,
	[VIATICO_XML_Total]						[DECIMAL] (19,4) NOT NULL,
	[VIATICO_XML_Version]					[VARCHAR] (100) NOT NULL,
	-- ============================
	[VIATICO_XML_EMI_Nombre]				[VARCHAR] (100) NOT NULL,
	[VIATICO_XML_EMI_RegimenFiscal]			[VARCHAR] (100) NOT NULL,
	[VIATICO_XML_EMI_Rfc]					[VARCHAR] (100) NOT NULL,
	-- ===========================
	[VIATICO_XML_REC_Nombre]				[VARCHAR] (100) NOT NULL,
	[VIATICO_XML_REC_Rfc]					[VARCHAR] (100) NOT NULL,
	[VIATICO_XML_REC_UsoCFDI]				[VARCHAR] (100) NOT NULL,
	-- ============================
 	[VIATICO_XML_TotalImpuestosTrasladados] [DECIMAL] (19,4) NOT NULL,
	[VIATICO_XML_Importe]					[DECIMAL] (19,4) NOT NULL,
	[VIATICO_XML_Impuesto]					[VARCHAR] (100) NOT NULL,
	[VIATICO_XML_TasaOCuota]				[VARCHAR] (100) NOT NULL,
	[VIATICO_XML_TipoFactor]				[VARCHAR] (100) NOT NULL,
	-- ============================
	[VIATICO_XML_FechaTimbrado]				[DATETIME] NOT NULL, 
	[VIATICO_XML_NoCertificadoSAT]			[VARCHAR] (100) NOT NULL, 
	[VIATICO_XML_UUID]						[VARCHAR] (100) NOT NULL, 
	-- ============================
	[VIATICO_XML_ARCHIVO]					[NVARCHAR](MAX)		-- ARCHIVO
	-- ============================
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[VIATICO_XML]
	ADD CONSTRAINT [PK_VIATICO_XML]
		PRIMARY KEY CLUSTERED ([K_VIATICO_XML])
GO

/*

CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_VIATICO_XML_01_RFC] 
	   ON [dbo].[VIATICO_XML] ( [RFC] )
GO

*/

ALTER TABLE [dbo].[VIATICO_XML] ADD 
	CONSTRAINT [FK_VIATICO_XML_01]  
		FOREIGN KEY ([K_PROVEEDOR_VIATICO]) 
		REFERENCES [dbo].[PROVEEDOR_VIATICO] ([K_PROVEEDOR_VIATICO]),
	CONSTRAINT [FK_VIATICO_XML_02]  
		FOREIGN KEY ([K_VIAJE]) 
		REFERENCES [dbo].[VIAJE] ([K_VIAJE])
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[VIATICO_XML] 
	ADD		[K_USUARIO_ALTA]			[INT] NOT NULL,
			[F_ALTA]					[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]			[INT] NOT NULL,
			[F_CAMBIO]					[DATETIME] NOT NULL,
			[L_BORRADO]					[INT] NOT NULL,
			[K_USUARIO_BAJA]			[INT] NULL,
			[F_BAJA]					[DATETIME] NULL;
GO

ALTER TABLE [dbo].[VIATICO_XML] ADD 
	CONSTRAINT [FK_VIATICO_XML_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_VIATICO_XML_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_VIATICO_XML_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO

-- //////////////////////////////////////////////////////////////















-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
