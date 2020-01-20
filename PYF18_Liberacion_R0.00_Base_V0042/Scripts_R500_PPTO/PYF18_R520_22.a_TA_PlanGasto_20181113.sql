-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PLAN_GASTO GASTOS/PLANTA
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	09/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PLAN_GASTO]') AND type in (N'U'))
	DROP TABLE [dbo].[PLAN_GASTO] 
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_PLAN_GASTO]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_PLAN_GASTO] 
GO





-- ///////////////////////////////////////////////////////////////
-- // ESTATUS_PLAN_GASTO 						
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ESTATUS_PLAN_GASTO] (
	[K_ESTATUS_PLAN_GASTO]		[INT] 			NOT NULL,
	[D_ESTATUS_PLAN_GASTO]		[VARCHAR] (100) NOT NULL,
	[S_ESTATUS_PLAN_GASTO]		[VARCHAR] (10) 	NOT NULL,
	[O_ESTATUS_PLAN_GASTO]		[INT] 			NOT NULL,
	[C_ESTATUS_PLAN_GASTO]		[VARCHAR] (255) NOT NULL,
	[L_ESTATUS_PLAN_GASTO]		[INT] 			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[ESTATUS_PLAN_GASTO]
	ADD CONSTRAINT [PK_ESTATUS_PLAN_GASTO]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_PLAN_GASTO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_PLAN_GASTO_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_PLAN_GASTO] ( [D_ESTATUS_PLAN_GASTO] )
GO

-- //////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_PLAN_GASTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_PLAN_GASTO]
GO



CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_PLAN_GASTO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	-- =========================
	@PP_K_ESTATUS_PLAN_GASTO		INT,
	@PP_D_ESTATUS_PLAN_GASTO		VARCHAR(100),
	@PP_S_ESTATUS_PLAN_GASTO		VARCHAR(10),
	@PP_O_ESTATUS_PLAN_GASTO		INT,
	@PP_C_ESTATUS_PLAN_GASTO		VARCHAR(255),
	@PP_L_ESTATUS_PLAN_GASTO		INT
AS

	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_ESTATUS_PLAN_GASTO
							FROM	ESTATUS_PLAN_GASTO
							WHERE	K_ESTATUS_PLAN_GASTO=@PP_K_ESTATUS_PLAN_GASTO

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO ESTATUS_PLAN_GASTO
		(	K_ESTATUS_PLAN_GASTO,			D_ESTATUS_PLAN_GASTO, 
			S_ESTATUS_PLAN_GASTO,			O_ESTATUS_PLAN_GASTO,
			C_ESTATUS_PLAN_GASTO,
			L_ESTATUS_PLAN_GASTO			)		
		VALUES	
		(	@PP_K_ESTATUS_PLAN_GASTO,		@PP_D_ESTATUS_PLAN_GASTO,	
			@PP_S_ESTATUS_PLAN_GASTO,		@PP_O_ESTATUS_PLAN_GASTO,
			@PP_C_ESTATUS_PLAN_GASTO,
			@PP_L_ESTATUS_PLAN_GASTO		)
	ELSE
		UPDATE	ESTATUS_PLAN_GASTO
		SET		D_ESTATUS_PLAN_GASTO	= @PP_D_ESTATUS_PLAN_GASTO,	
				S_ESTATUS_PLAN_GASTO	= @PP_S_ESTATUS_PLAN_GASTO,			
				O_ESTATUS_PLAN_GASTO	= @PP_O_ESTATUS_PLAN_GASTO,
				C_ESTATUS_PLAN_GASTO	= @PP_C_ESTATUS_PLAN_GASTO,
				L_ESTATUS_PLAN_GASTO	= @PP_L_ESTATUS_PLAN_GASTO	
		WHERE	K_ESTATUS_PLAN_GASTO=@PP_K_ESTATUS_PLAN_GASTO

	-- ==============================================
GO





-- ///////////////////////////////////////////////////////////////
-- // ESTATUS_PLAN_GASTO 						
-- ///////////////////////////////////////////////////////////////

EXECUTE [dbo].[PG_CI_ESTATUS_PLAN_GASTO]	0, 0, 1, 'BASE',			'BASE', 10, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PLAN_GASTO]	0, 0, 2, 'EN PROCESO',		'PROC', 20, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PLAN_GASTO]	0, 0, 3, 'PREVIO',			'PREV', 30, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PLAN_GASTO]	0, 0, 4, 'AUTORIZADO',		'AUTR', 40, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PLAN_GASTO]	0, 0, 5, 'CANCELADO',		'CANC', 50, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PLAN_GASTO]	0, 0, 6, 'EJECUTADO',		'EJEC', 60, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PLAN_GASTO]	0, 0, 7, 'CERRADO',			'CERR', 70, '', 1
GO




IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESCENARIO_PLAN]') AND type in (N'U'))
	DROP TABLE [dbo].[ESCENARIO_PLAN] 
GO





-- ///////////////////////////////////////////////////////////////
-- // ESCENARIO_PLAN 						
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ESCENARIO_PLAN] (
	[K_ESCENARIO_PLAN]		[INT] 			NOT NULL,
	[D_ESCENARIO_PLAN]		[VARCHAR] (100) NOT NULL,
	[S_ESCENARIO_PLAN]		[VARCHAR] (10) 	NOT NULL,
	[O_ESCENARIO_PLAN]		[INT] 			NOT NULL,
	[C_ESCENARIO_PLAN]		[VARCHAR] (255) NOT NULL,
	[L_ESCENARIO_PLAN]		[INT] 			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[ESCENARIO_PLAN]
	ADD CONSTRAINT [PK_ESCENARIO_PLAN]
		PRIMARY KEY CLUSTERED ([K_ESCENARIO_PLAN])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESCENARIO_PLAN_01_DESCRIPCION] 
	   ON [dbo].[ESCENARIO_PLAN] ( [D_ESCENARIO_PLAN] )
GO

-- //////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESCENARIO_PLAN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESCENARIO_PLAN]
GO



CREATE PROCEDURE [dbo].[PG_CI_ESCENARIO_PLAN]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	-- =========================
	@PP_K_ESCENARIO_PLAN		INT,
	@PP_D_ESCENARIO_PLAN		VARCHAR(100),
	@PP_S_ESCENARIO_PLAN		VARCHAR(10),
	@PP_O_ESCENARIO_PLAN		INT,
	@PP_C_ESCENARIO_PLAN		VARCHAR(255),
	@PP_L_ESCENARIO_PLAN		INT
AS

	INSERT INTO ESCENARIO_PLAN
		(	K_ESCENARIO_PLAN,			D_ESCENARIO_PLAN, 
			S_ESCENARIO_PLAN,			O_ESCENARIO_PLAN,
			C_ESCENARIO_PLAN,
			L_ESCENARIO_PLAN			)	
	VALUES	
		(	@PP_K_ESCENARIO_PLAN,		@PP_D_ESCENARIO_PLAN,	
			@PP_S_ESCENARIO_PLAN,		@PP_O_ESCENARIO_PLAN,
			@PP_C_ESCENARIO_PLAN,
			@PP_L_ESCENARIO_PLAN		)

	-- ==============================================
GO





-- ///////////////////////////////////////////////////////////////
-- // ESCENARIO_PLAN 						
-- ///////////////////////////////////////////////////////////////

EXECUTE [dbo].[PG_CI_ESCENARIO_PLAN]	0, 0, 1, 'BASE',			'BASE', 10, '', 1
EXECUTE [dbo].[PG_CI_ESCENARIO_PLAN]	0, 0, 2, 'PREVIO 1',		'PRE1', 20, '', 1
EXECUTE [dbo].[PG_CI_ESCENARIO_PLAN]	0, 0, 3, 'PREVIO 2',		'PRE2', 30, '', 1
EXECUTE [dbo].[PG_CI_ESCENARIO_PLAN]	0, 0, 4, 'PREVIO 3',		'PRE3', 40, '', 1
EXECUTE [dbo].[PG_CI_ESCENARIO_PLAN]	0, 0, 5, 'AUTORIZADO',		'PRE4', 50, '', 1
GO




-- ///////////////////////////////////////////////////////////////
-- //						PLAN_GASTO 						
-- ///////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[PLAN_GASTO] (
	[K_PLAN_GASTO]				[INT] NOT NULL,
	[D_PLAN_GASTO]				[VARCHAR] (100) NOT NULL,
	[C_PLAN_GASTO]				[VARCHAR] (255) NOT NULL,
	[S_PLAN_GASTO]				[VARCHAR] (10) NOT NULL,
	[O_PLAN_GASTO]				[INT] NOT NULL,  
	-- ========================================
	[K_UNIDAD_OPERATIVA]		[INT] NOT NULL,
	[K_ESCENARIO_PLAN]			[INT] NOT NULL,
	[K_YYYY]					[INT] NOT NULL,
--	[K_MM]						[INT] NOT NULL,
	[K_ESTATUS_PLAN_GASTO]		[INT] NOT NULL,
	[L_RECALCULAR]				[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PLAN_GASTO]
	ADD CONSTRAINT [PK_PLAN_GASTO]
		PRIMARY KEY CLUSTERED ([K_PLAN_GASTO])
GO




-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PLAN_GASTO] ADD 
	CONSTRAINT [FK_PLAN_GASTO_01] 
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA]),
	CONSTRAINT [FK_PLAN_GASTO_02] 
		FOREIGN KEY ([K_ESTATUS_PLAN_GASTO]) 
		REFERENCES [dbo].[ESTATUS_PLAN_GASTO] ([K_ESTATUS_PLAN_GASTO])
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PLAN_GASTO] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[PLAN_GASTO] ADD 
	CONSTRAINT [FK_PLAN_GASTO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PLAN_GASTO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PLAN_GASTO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
