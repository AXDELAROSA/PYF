-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PERSONAL
-- // OPERACION:		LIBERACION / TABLAS
-- //////////////////////////////////////////////////////////////
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	29/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////








-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PERSONAL_ACCESO_ORGANIZACION]') AND type in (N'U'))
	DROP TABLE [dbo].[PERSONAL_ACCESO_ORGANIZACION]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PERSONAL]') AND type in (N'U'))
	DROP TABLE [dbo].[PERSONAL]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_PERSONAL]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_PERSONAL]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIPO_PERSONAL]') AND type in (N'U'))
	DROP TABLE [dbo].[TIPO_PERSONAL]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLASE_PERSONAL]') AND type in (N'U'))
	DROP TABLE [dbo].[CLASE_PERSONAL]
GO





-- //////////////////////////////////////////////////////////////
-- // CLASE_PERSONAL
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[CLASE_PERSONAL] (
	[K_CLASE_PERSONAL]	[INT] NOT NULL,
	[D_CLASE_PERSONAL]	[VARCHAR] (100) NOT NULL,
	[S_CLASE_PERSONAL]	[VARCHAR] (10) NOT NULL,
	[O_CLASE_PERSONAL]	[INT] NOT NULL,
	[C_CLASE_PERSONAL]	[VARCHAR] (255) NOT NULL,
	[L_CLASE_PERSONAL]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[CLASE_PERSONAL]
	ADD CONSTRAINT [PK_CLASE_PERSONAL]
		PRIMARY KEY CLUSTERED ([K_CLASE_PERSONAL])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_CLASE_PERSONAL_01_DESCRIPCION] 
	   ON [dbo].[CLASE_PERSONAL] ( [D_CLASE_PERSONAL] )
GO

-- //////////////////////////////////////////////////////////////

ALTER TABLE [dbo].[CLASE_PERSONAL] ADD 
	CONSTRAINT [FK_CLASE_PERSONAL_01] 
		FOREIGN KEY ( [L_CLASE_PERSONAL] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_CLASE_PERSONAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_CLASE_PERSONAL]
GO


CREATE PROCEDURE [dbo].[PG_CI_CLASE_PERSONAL]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	-- ========================================
	@PP_K_CLASE_PERSONAL		INT,
	@PP_D_CLASE_PERSONAL		VARCHAR(100),
	@PP_S_CLASE_PERSONAL		VARCHAR(10),
	@PP_O_CLASE_PERSONAL		INT,
	@PP_C_CLASE_PERSONAL		VARCHAR(255),
	@PP_L_CLASE_PERSONAL		INT
AS
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_CLASE_PERSONAL
							FROM	CLASE_PERSONAL
							WHERE	K_CLASE_PERSONAL=@PP_K_CLASE_PERSONAL

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO CLASE_PERSONAL
			(	K_CLASE_PERSONAL,			D_CLASE_PERSONAL, 
				S_CLASE_PERSONAL,			O_CLASE_PERSONAL,
				C_CLASE_PERSONAL,
				L_CLASE_PERSONAL			)		
		VALUES	
			(	@PP_K_CLASE_PERSONAL,		@PP_D_CLASE_PERSONAL,	
				@PP_S_CLASE_PERSONAL,		@PP_O_CLASE_PERSONAL,
				@PP_C_CLASE_PERSONAL,
				@PP_L_CLASE_PERSONAL		)
	ELSE
		UPDATE	CLASE_PERSONAL
		SET		D_CLASE_PERSONAL	= @PP_D_CLASE_PERSONAL,	
				S_CLASE_PERSONAL	= @PP_S_CLASE_PERSONAL,			
				O_CLASE_PERSONAL	= @PP_O_CLASE_PERSONAL,
				C_CLASE_PERSONAL	= @PP_C_CLASE_PERSONAL,
				L_CLASE_PERSONAL	= @PP_L_CLASE_PERSONAL	
		WHERE	K_CLASE_PERSONAL=@PP_K_CLASE_PERSONAL

	-- =========================================================
GO

-- //////////////////////////////////////////////////////////////





-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_CLASE_PERSONAL] 0, 0,  1, 'CLASE 1',		'CL1', 10, '', 1
EXECUTE [dbo].[PG_CI_CLASE_PERSONAL] 0, 0,  2, 'CLASE 2',		'CL2', 20, '', 1
EXECUTE [dbo].[PG_CI_CLASE_PERSONAL] 0, 0,  3, 'CLASE 3',		'CL3', 30, '', 1
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================




-- //////////////////////////////////////////////////////////////
-- // TIPO_PERSONAL
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[TIPO_PERSONAL] (
	[K_TIPO_PERSONAL]	[INT] NOT NULL,
	[D_TIPO_PERSONAL]	[VARCHAR] (100) NOT NULL,
	[S_TIPO_PERSONAL]	[VARCHAR] (10) NOT NULL,
	[O_TIPO_PERSONAL]	[INT] NOT NULL,
	[C_TIPO_PERSONAL]	[VARCHAR] (255) NOT NULL,
	[L_TIPO_PERSONAL]	[INT] NOT NULL,
	[K_CLASE_PERSONAL]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[TIPO_PERSONAL]
	ADD CONSTRAINT [PK_TIPO_PERSONAL]
		PRIMARY KEY CLUSTERED ([K_TIPO_PERSONAL])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TIPO_PERSONAL_01_DESCRIPCION] 
	   ON [dbo].[TIPO_PERSONAL] ( [D_TIPO_PERSONAL] )
GO

-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[TIPO_PERSONAL] ADD 
	CONSTRAINT [FK_TIPO_PERSONAL_01] 
		FOREIGN KEY ( [L_TIPO_PERSONAL] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] ),
	CONSTRAINT [FK_TIPO_PERSONAL_02] 
		FOREIGN KEY ( [K_CLASE_PERSONAL] ) 
		REFERENCES [dbo].[CLASE_PERSONAL] ( [K_CLASE_PERSONAL] )
GO



-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIPO_PERSONAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIPO_PERSONAL]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIPO_PERSONAL]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	-- ========================================
	@PP_K_TIPO_PERSONAL			INT,
	@PP_D_TIPO_PERSONAL			VARCHAR(100),
	@PP_S_TIPO_PERSONAL			VARCHAR(10),
	@PP_O_TIPO_PERSONAL			INT,
	@PP_C_TIPO_PERSONAL			VARCHAR(255),
	@PP_L_TIPO_PERSONAL			INT,
	@PP_K_CLASE_PERSONAL			INT		
AS
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_TIPO_PERSONAL
							FROM	TIPO_PERSONAL
							WHERE	K_TIPO_PERSONAL=@PP_K_TIPO_PERSONAL

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO TIPO_PERSONAL
			(	K_TIPO_PERSONAL,				D_TIPO_PERSONAL, 
				S_TIPO_PERSONAL,				O_TIPO_PERSONAL,
				C_TIPO_PERSONAL,
				L_TIPO_PERSONAL,
				K_CLASE_PERSONAL				)
		VALUES	
			(	@PP_K_TIPO_PERSONAL,			@PP_D_TIPO_PERSONAL,	
				@PP_S_TIPO_PERSONAL,			@PP_O_TIPO_PERSONAL,
				@PP_C_TIPO_PERSONAL,
				@PP_L_TIPO_PERSONAL,
				@PP_K_CLASE_PERSONAL			)
	ELSE
		UPDATE	TIPO_PERSONAL
		SET		D_TIPO_PERSONAL	= @PP_D_TIPO_PERSONAL,	
				S_TIPO_PERSONAL	= @PP_S_TIPO_PERSONAL,			
				O_TIPO_PERSONAL	= @PP_O_TIPO_PERSONAL,
				C_TIPO_PERSONAL	= @PP_C_TIPO_PERSONAL,
				L_TIPO_PERSONAL	= @PP_L_TIPO_PERSONAL,
				K_CLASE_PERSONAL	= @PP_K_CLASE_PERSONAL	
		WHERE	K_TIPO_PERSONAL=@PP_K_TIPO_PERSONAL

	-- =========================================================
GO

-- //////////////////////////////////////////////////////////////


-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_TIPO_PERSONAL] 0, 0,  1, 'TIPO 1',		'TI1', 10, '', 1, 1
EXECUTE [dbo].[PG_CI_TIPO_PERSONAL] 0, 0,  2, 'TIPO 2',		'TI2', 20, '', 1, 2
EXECUTE [dbo].[PG_CI_TIPO_PERSONAL] 0, 0,  3, 'TIPO 3',		'TI3', 30, '', 1, 1
GO


-- ===============================================
SET NOCOUNT OFF
-- ===============================================



-- //////////////////////////////////////////////////////////////
-- // ESTATUS_PERSONAL
-- //////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[ESTATUS_PERSONAL] (
	[K_ESTATUS_PERSONAL]	[INT] NOT NULL,
	[D_ESTATUS_PERSONAL]	[VARCHAR] (100) NOT NULL,
	[S_ESTATUS_PERSONAL]	[VARCHAR] (10) NOT NULL,
	[O_ESTATUS_PERSONAL]	[INT] NOT NULL,
	[C_ESTATUS_PERSONAL]	[VARCHAR] (255) NOT NULL,
	[L_ESTATUS_PERSONAL]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[ESTATUS_PERSONAL]
	ADD CONSTRAINT [PK_ESTATUS_PERSONAL]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_PERSONAL])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_PERSONAL_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_PERSONAL] ( [D_ESTATUS_PERSONAL] )
GO

-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[ESTATUS_PERSONAL] ADD 
	CONSTRAINT [FK_ESTATUS_PERSONAL_01] 
		FOREIGN KEY ( [L_ESTATUS_PERSONAL] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_PERSONAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_PERSONAL]
GO


CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_PERSONAL]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	-- ========================================
	@PP_K_ESTATUS_PERSONAL		INT,
	@PP_D_ESTATUS_PERSONAL		VARCHAR(100),
	@PP_S_ESTATUS_PERSONAL		VARCHAR(10),
	@PP_O_ESTATUS_PERSONAL		INT,
	@PP_C_ESTATUS_PERSONAL		VARCHAR(255),
	@PP_L_ESTATUS_PERSONAL		INT
AS
	
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_ESTATUS_PERSONAL
							FROM	ESTATUS_PERSONAL
							WHERE	K_ESTATUS_PERSONAL=@PP_K_ESTATUS_PERSONAL

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO ESTATUS_PERSONAL	
			(	K_ESTATUS_PERSONAL,				D_ESTATUS_PERSONAL, 
				S_ESTATUS_PERSONAL,				O_ESTATUS_PERSONAL,
				C_ESTATUS_PERSONAL,
				L_ESTATUS_PERSONAL				)		
		VALUES	
			(	@PP_K_ESTATUS_PERSONAL,			@PP_D_ESTATUS_PERSONAL,	
				@PP_S_ESTATUS_PERSONAL,			@PP_O_ESTATUS_PERSONAL,
				@PP_C_ESTATUS_PERSONAL,
				@PP_L_ESTATUS_PERSONAL			)
	ELSE
		UPDATE	ESTATUS_PERSONAL
		SET		D_ESTATUS_PERSONAL	= @PP_D_ESTATUS_PERSONAL,	
				S_ESTATUS_PERSONAL	= @PP_S_ESTATUS_PERSONAL,			
				O_ESTATUS_PERSONAL	= @PP_O_ESTATUS_PERSONAL,
				C_ESTATUS_PERSONAL	= @PP_C_ESTATUS_PERSONAL,
				L_ESTATUS_PERSONAL	= @PP_L_ESTATUS_PERSONAL	
		WHERE	K_ESTATUS_PERSONAL=@PP_K_ESTATUS_PERSONAL

	-- =========================================================
GO

-- //////////////////////////////////////////////////////////////




-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_ESTATUS_PERSONAL] 0, 0, 0, 'INACTIVO',		'INACT', 1, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PERSONAL] 0, 0, 1, 'ACTIVO',		'ACTVO', 1, '', 1
GO
-- ===============================================
SET NOCOUNT OFF
-- ===============================================







-- //////////////////////////////////////////////////////////////
-- // PERSONAL
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[PERSONAL] (
	[K_PERSONAL]				[INT]			NOT NULL,
	[D_PERSONAL]				[VARCHAR](100)	NOT NULL,
	[S_PERSONAL]				[VARCHAR](10)	NOT NULL,
	[O_PERSONAL]				[INT]			NOT NULL,
	[C_PERSONAL]				[VARCHAR](500)	NOT NULL DEFAULT '',
	-- ============================	
	[K_ESTATUS_PERSONAL]		[INT]			NOT NULL DEFAULT 1,
	[K_TIPO_PERSONAL]			[INT]			NOT NULL DEFAULT 1
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PERSONAL]
	ADD CONSTRAINT [PK_PERSONAL]
		PRIMARY KEY CLUSTERED ([K_PERSONAL])
GO

-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[PERSONAL] ADD 
	CONSTRAINT [FK_PERSONAL_01]  
		FOREIGN KEY ([K_ESTATUS_PERSONAL]) 
		REFERENCES [dbo].[ESTATUS_PERSONAL] ([K_ESTATUS_PERSONAL]),
	CONSTRAINT [FK_PERSONAL_02]  
		FOREIGN KEY ([K_TIPO_PERSONAL]) 
		REFERENCES [dbo].[TIPO_PERSONAL] ([K_TIPO_PERSONAL])
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PERSONAL] 
	ADD		[K_USUARIO_ALTA]				[INT]		NOT NULL,
			[F_ALTA]						[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]				[INT]		NOT NULL,
			[F_CAMBIO]						[DATETIME]	NOT NULL,
			[L_BORRADO]						[INT]		NOT NULL,
			[K_USUARIO_BAJA]				[INT]		NULL,
			[F_BAJA]						[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[PERSONAL] ADD 
	CONSTRAINT [FK_PERSONAL_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PERSONAL_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PERSONAL_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO





-- //////////////////////////////////////////////////////////////
-- // PERSONAL
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[PERSONAL_ACCESO_ORGANIZACION] (
	[K_PERSONAL_ACCESO_ORGANIZACION]	[INT]	NOT NULL,
	[K_PERSONAL]				[INT]			NOT NULL,
	[K_RAZON_SOCIAL]			[INT]			NOT NULL DEFAULT -1,
	[K_ZONA_UO]					[INT]			NOT NULL DEFAULT -1,
	[K_UNIDAD_OPERATIVA]		[INT]			NOT NULL DEFAULT -1
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PERSONAL_ACCESO_ORGANIZACION]
	ADD CONSTRAINT [PK_PERSONAL_ACCESO_ORGANIZACION]
		PRIMARY KEY CLUSTERED ([K_PERSONAL_ACCESO_ORGANIZACION])
GO

-- //////////////////////////////////////////////////////////////

/*

ALTER TABLE [dbo].[PERSONAL] ADD 
	CONSTRAINT [FK_PERSONAL_01]  
		FOREIGN KEY ([K_ESTATUS_PERSONAL]) 
		REFERENCES [dbo].[ESTATUS_PERSONAL] ([K_ESTATUS_PERSONAL]),
	CONSTRAINT [FK_PERSONAL_02]  
		FOREIGN KEY ([K_TIPO_PERSONAL]) 
		REFERENCES [dbo].[TIPO_PERSONAL] ([K_TIPO_PERSONAL])
GO

*/



-- //////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PERSONAL_ACCESO_ORGANIZACION] 
	ADD		[K_USUARIO_ALTA]				[INT]		NOT NULL,
			[F_ALTA]						[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]				[INT]		NOT NULL,
			[F_CAMBIO]						[DATETIME]	NOT NULL,
			[L_BORRADO]						[INT]		NOT NULL,
			[K_USUARIO_BAJA]				[INT]		NULL,
			[F_BAJA]						[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[PERSONAL_ACCESO_ORGANIZACION] ADD 
	CONSTRAINT [FK_PERSONAL_ACCESO_ORGANIZACION_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PERSONAL_ACCESO_ORGANIZACION_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PERSONAL_ACCESO_ORGANIZACION_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO









-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
