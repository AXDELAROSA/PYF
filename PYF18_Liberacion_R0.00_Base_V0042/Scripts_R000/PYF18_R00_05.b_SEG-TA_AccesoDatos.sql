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
-- // DROPS
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATA_PERFIL]') AND type in (N'U'))
	DROP TABLE [dbo].[USUARIO_DATA_PERFIL]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATA_ACCESO]') AND type in (N'U'))
	DROP TABLE [dbo].[DATA_ACCESO] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATA_PERFIL]') AND type in (N'U'))
	DROP TABLE [dbo].[DATA_PERFIL]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATA_OPERACION]') AND type in (N'U'))
	DROP TABLE [dbo].[DATA_OPERACION]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATA_SISTEMA]') AND type in (N'U'))
	DROP TABLE [dbo].[DATA_SISTEMA]
GO




/****************************************************************/
/*						DATA_SISTEMA 							*/
/****************************************************************/

CREATE TABLE [dbo].[DATA_SISTEMA] (
	[K_DATA_SISTEMA]		[INT] NOT NULL,
	[D_DATA_SISTEMA]		[VARCHAR] (100) NOT NULL,
	[S_DATA_SISTEMA]		[VARCHAR] (10) NOT NULL,
	[O_DATA_SISTEMA]		[INT] NOT NULL,  
	[C_DATA_SISTEMA]		[VARCHAR] (255) NOT NULL,
	[L_DATA_SISTEMA]		[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[DATA_SISTEMA]
	ADD CONSTRAINT [PK_DATA_SISTEMA]
		PRIMARY KEY CLUSTERED ([K_DATA_SISTEMA])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_DATA_SISTEMA_01_DESCRIPCION] 
	   ON [dbo].[DATA_SISTEMA] ( [D_DATA_SISTEMA] )
GO




-- //////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_DATA_SISTEMA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_DATA_SISTEMA]
GO



CREATE PROCEDURE [dbo].[PG_CI_DATA_SISTEMA]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_DATA_SISTEMA		INT,
	@PP_D_DATA_SISTEMA		VARCHAR(100),
	@PP_S_DATA_SISTEMA		VARCHAR(10),
	@PP_O_DATA_SISTEMA		INT,
	@PP_C_DATA_SISTEMA		VARCHAR(255),
	@PP_L_DATA_SISTEMA		INT
AS

	INSERT INTO DATA_SISTEMA
		(	K_DATA_SISTEMA,			D_DATA_SISTEMA, 
			S_DATA_SISTEMA,			O_DATA_SISTEMA,
			C_DATA_SISTEMA,
			L_DATA_SISTEMA				)	
	VALUES	
		(	@PP_K_DATA_SISTEMA,		@PP_D_DATA_SISTEMA,	
			@PP_S_DATA_SISTEMA,		@PP_O_DATA_SISTEMA,
			@PP_C_DATA_SISTEMA,
			@PP_L_DATA_SISTEMA			)

	-- ==============================================
GO



EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 01, 'EMPRESA',				'', 10, '', 1
EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 02, 'PLANTA',					'', 20, '', 1
EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 03, 'CLIENTE',				'', 30, '', 1
EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 04, 'SOLICITUD',				'', 10, '', 1
EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 05, 'SIMULACION',				'', 20, '', 1
EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 06, 'TABLA_AMORTIZACION',		'', 10, '', 1
EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 07, 'DOCUMENTO_SOLICITUD',	'', 30, '', 1
EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 08, 'MOVIMIENTO_BANCO',		'', 20, '', 1
EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 09, 'MOVIMIENTO_PRESTAMO',	'', 30, '', 1
EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 10, 'DOCUMENTOS',				'', 10, '', 1 
EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 11, 'CUENTA_BANCO',			'', 20, '', 1 
EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 12, 'CONTRATO',				'', 30, '', 1 
EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 13, 'SECCION_REDACCION',		'', 10, '', 1 
EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 14, 'CONTRATO_SOLICITUD',		'', 20, '', 1 
EXECUTE [dbo].[PG_CI_DATA_SISTEMA]	0, 0, 15, 'ENTREGA_RECURSO',		'', 30, '', 1 

GO


/****************************************************************/
/*						DATA_OPERACION 							*/
/****************************************************************/

CREATE TABLE [dbo].[DATA_OPERACION] (
	[K_DATA_OPERACION]		[INT] NOT NULL,
	[D_DATA_OPERACION]		[VARCHAR] (100) NOT NULL,
	[S_DATA_OPERACION]		[VARCHAR] (10) NOT NULL,
	[O_DATA_OPERACION]		[INT] NOT NULL,
	[C_DATA_OPERACION]		[VARCHAR] (255) NOT NULL,
	[L_DATA_OPERACION]		[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[DATA_OPERACION]
	ADD CONSTRAINT [PK_DATA_OPERACION]
		PRIMARY KEY CLUSTERED ([K_DATA_OPERACION])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_DATA_OPERACION_01_DESCRIPCION] 
	   ON [dbo].[DATA_OPERACION] ( [D_DATA_OPERACION] )
GO

-- //////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_DATA_OPERACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_DATA_OPERACION]
GO



CREATE PROCEDURE [dbo].[PG_CI_DATA_OPERACION]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_DATA_OPERACION		INT,
	@PP_D_DATA_OPERACION		VARCHAR(100),
	@PP_S_DATA_OPERACION		VARCHAR(10),
	@PP_O_DATA_OPERACION		INT,
	@PP_C_DATA_OPERACION		VARCHAR(255),
	@PP_L_DATA_OPERACION		INT
AS

	INSERT INTO DATA_OPERACION
		(	K_DATA_OPERACION,			D_DATA_OPERACION, 
			S_DATA_OPERACION,			O_DATA_OPERACION,
			C_DATA_OPERACION,
			L_DATA_OPERACION			)	
	VALUES	
		(	@PP_K_DATA_OPERACION,		@PP_D_DATA_OPERACION,	
			@PP_S_DATA_OPERACION,		@PP_O_DATA_OPERACION,
			@PP_C_DATA_OPERACION,
			@PP_L_DATA_OPERACION		)

	-- ==============================================
GO


-- //////////////////////////////////////////////////////


EXECUTE [dbo].[PG_CI_DATA_OPERACION]	0, 0, 01, 'LISTADO',		'LI', 10, '', 1
EXECUTE [dbo].[PG_CI_DATA_OPERACION]	0, 0, 02, 'FICHA',			'SK', 20, '', 1
EXECUTE [dbo].[PG_CI_DATA_OPERACION]	0, 0, 03, 'INSERTAR',		'IN', 30, '', 1
EXECUTE [dbo].[PG_CI_DATA_OPERACION]	0, 0, 04, 'ACTUALIZAR',		'UP', 30, '', 1
EXECUTE [dbo].[PG_CI_DATA_OPERACION]	0, 0, 05, 'BORRAR',			'DL', 30, '', 1
GO




/****************************************************************/
/*							DATA_PERFIL 						*/
/****************************************************************/

CREATE TABLE [dbo].[DATA_PERFIL] (
	[K_DATA_PERFIL]		[INT] NOT NULL,
	[D_DATA_PERFIL]		[VARCHAR] (100) NOT NULL,
	[S_DATA_PERFIL]		[VARCHAR] (10) NOT NULL,
	[O_DATA_PERFIL]		[INT] NOT NULL,
	[C_DATA_PERFIL]		[VARCHAR] (255) NOT NULL,
	[L_DATA_PERFIL]		[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[DATA_PERFIL]
	ADD CONSTRAINT [PK_DATA_PERFIL]
		PRIMARY KEY CLUSTERED ([K_DATA_PERFIL])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_DATA_PERFIL_01_DESCRIPCION] 
	   ON [dbo].[DATA_PERFIL] ( [D_DATA_PERFIL] )
GO

-- //////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_DATA_PERFIL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_DATA_PERFIL]
GO



CREATE PROCEDURE [dbo].[PG_CI_DATA_PERFIL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_DATA_PERFIL		INT,
	@PP_D_DATA_PERFIL		VARCHAR(100),
	@PP_S_DATA_PERFIL		VARCHAR(10),
	@PP_O_DATA_PERFIL		INT,
	@PP_C_DATA_PERFIL		VARCHAR(255),
	@PP_L_DATA_PERFIL		INT
AS

	INSERT INTO DATA_PERFIL
		(	K_DATA_PERFIL,			D_DATA_PERFIL, 
			S_DATA_PERFIL,			O_DATA_PERFIL,
			C_DATA_PERFIL,
			L_DATA_PERFIL				)	
	VALUES	
		(	@PP_K_DATA_PERFIL,		@PP_D_DATA_PERFIL,	
			@PP_S_DATA_PERFIL,		@PP_O_DATA_PERFIL,
			@PP_C_DATA_PERFIL,
			@PP_L_DATA_PERFIL			)

	-- ==============================================
GO


-- //////////////////////////////////////////////////////


EXECUTE [dbo].[PG_CI_DATA_PERFIL]	0, 0, 00, 'TI/MASTER',		'TI', 99, 'FULL', 1
EXECUTE [dbo].[PG_CI_DATA_PERFIL]	0, 0, 01, 'CONSULTA',		'CONS', 10, 'LI/SK', 1
EXECUTE [dbo].[PG_CI_DATA_PERFIL]	0, 0, 02, 'OPERACION',		'OPER', 20, 'LI/SK/IN/UP', 1
EXECUTE [dbo].[PG_CI_DATA_PERFIL]	0, 0, 03, 'ADMINISTRACION',	'ADMN', 30, 'LI/SK/IN/UP/DL', 1
GO




/****************************************************************/
/*						DATA_ACCESO								*/
/****************************************************************/

CREATE TABLE [dbo].[DATA_ACCESO] (
	[K_USUARIO]					[INT] NULL,
	[K_DATA_PERFIL]				[INT] NULL,
	-- ============================
	[K_DATA_SISTEMA]			[INT] NOT NULL,
	[K_DATA_OPERACION]			[INT] NOT NULL,
	-- ============================
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_DATA_ACCESO_01_X_K_DATA_PERFIL] 
	   ON [dbo].[DATA_ACCESO] ( [K_USUARIO], [K_DATA_PERFIL], [K_DATA_SISTEMA], [K_DATA_OPERACION] )
GO


-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[DATA_ACCESO] ADD 
	CONSTRAINT [FK_DATA_ACCESO_01] 
		FOREIGN KEY ([K_USUARIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_DATA_ACCESO_02] 
		FOREIGN KEY ([K_DATA_PERFIL]) 
		REFERENCES [dbo].[DATA_PERFIL] ([K_DATA_PERFIL]),
	CONSTRAINT [FK_DATA_ACCESO_03] 
		FOREIGN KEY ([K_DATA_SISTEMA]) 
		REFERENCES [dbo].[DATA_SISTEMA] ([K_DATA_SISTEMA]),
	CONSTRAINT [FK_DATA_ACCESO_04] 
		FOREIGN KEY ([K_DATA_OPERACION]) 
		REFERENCES [dbo].[DATA_OPERACION] ([K_DATA_OPERACION])
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[DATA_ACCESO] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO


ALTER TABLE [dbo].[DATA_ACCESO] ADD 
	CONSTRAINT [FK_DATA_ACCESO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_DATA_ACCESO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_DATA_ACCESO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO




/****************************************************************/
/*						USUARIO_DATA_PERFIL						*/
/****************************************************************/

CREATE TABLE [dbo].[USUARIO_DATA_PERFIL] (
	[K_USUARIO]					[INT] NOT NULL,
	[K_DATA_PERFIL]				[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[USUARIO_DATA_PERFIL]
	ADD CONSTRAINT [PK_USUARIO_DATA_PERFIL]
		PRIMARY KEY CLUSTERED ( [K_USUARIO], [K_DATA_PERFIL] )
GO


-- //////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_USUARIO_DATA_PERFIL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_USUARIO_DATA_PERFIL]
GO



CREATE PROCEDURE [dbo].[PG_CI_USUARIO_DATA_PERFIL]
	@PP_K_USUARIO			INT,
	@PP_K_DATA_PERFIL		INT	
AS

	INSERT INTO USUARIO_DATA_PERFIL
		(	K_USUARIO,			K_DATA_PERFIL			)	
	VALUES	
		(	@PP_K_USUARIO,		@PP_K_DATA_PERFIL		)

	-- ==============================================
GO


-- //////////////////////////////////////////////////////



EXECUTE [dbo].[PG_CI_USUARIO_DATA_PERFIL]	169, 0

GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
