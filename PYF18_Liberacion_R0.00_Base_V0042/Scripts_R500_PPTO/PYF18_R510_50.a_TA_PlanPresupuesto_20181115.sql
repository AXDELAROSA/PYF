-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PLAN PRESUPUESTO / GASTOS-PLANTA
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	15/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PARTIDA_PLAN_PRESUPUESTO]') AND type in (N'U'))
	DROP TABLE [dbo].[PARTIDA_PLAN_PRESUPUESTO] 
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PLAN_PRESUPUESTO]') AND type in (N'U'))
	DROP TABLE [dbo].[PLAN_PRESUPUESTO] 
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_PLAN_PRESUPUESTO]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_PLAN_PRESUPUESTO] 
GO





-- ///////////////////////////////////////////////////////////////
-- // ESTATUS_PLAN_PRESUPUESTO 						
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ESTATUS_PLAN_PRESUPUESTO] (
	[K_ESTATUS_PLAN_PRESUPUESTO]		[INT] 			NOT NULL,
	[D_ESTATUS_PLAN_PRESUPUESTO]		[VARCHAR] (100) NOT NULL,
	[S_ESTATUS_PLAN_PRESUPUESTO]		[VARCHAR] (10) 	NOT NULL,
	[O_ESTATUS_PLAN_PRESUPUESTO]		[INT] 			NOT NULL,
	[C_ESTATUS_PLAN_PRESUPUESTO]		[VARCHAR] (255) NOT NULL,
	[L_ESTATUS_PLAN_PRESUPUESTO]		[INT] 			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[ESTATUS_PLAN_PRESUPUESTO]
	ADD CONSTRAINT [PK_ESTATUS_PLAN_PRESUPUESTO]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_PLAN_PRESUPUESTO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_PLAN_PRESUPUESTO_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_PLAN_PRESUPUESTO] ( [D_ESTATUS_PLAN_PRESUPUESTO] )
GO

-- //////////////////////////////////////////////////////






IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_PLAN_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_PLAN_PRESUPUESTO]
GO



CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_PLAN_PRESUPUESTO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	-- =========================
	@PP_K_ESTATUS_PLAN_PRESUPUESTO		INT,
	@PP_D_ESTATUS_PLAN_PRESUPUESTO		VARCHAR(100),
	@PP_S_ESTATUS_PLAN_PRESUPUESTO		VARCHAR(10),
	@PP_O_ESTATUS_PLAN_PRESUPUESTO		INT,
	@PP_C_ESTATUS_PLAN_PRESUPUESTO		VARCHAR(255),
	@PP_L_ESTATUS_PLAN_PRESUPUESTO		INT
AS
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_ESTATUS_PLAN_PRESUPUESTO
							FROM	ESTATUS_PLAN_PRESUPUESTO
							WHERE	K_ESTATUS_PLAN_PRESUPUESTO=@PP_K_ESTATUS_PLAN_PRESUPUESTO

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO ESTATUS_PLAN_PRESUPUESTO
		(	K_ESTATUS_PLAN_PRESUPUESTO,			D_ESTATUS_PLAN_PRESUPUESTO, 
			S_ESTATUS_PLAN_PRESUPUESTO,			O_ESTATUS_PLAN_PRESUPUESTO,
			C_ESTATUS_PLAN_PRESUPUESTO,
			L_ESTATUS_PLAN_PRESUPUESTO			)		
		VALUES	
		(	@PP_K_ESTATUS_PLAN_PRESUPUESTO,		@PP_D_ESTATUS_PLAN_PRESUPUESTO,	
			@PP_S_ESTATUS_PLAN_PRESUPUESTO,		@PP_O_ESTATUS_PLAN_PRESUPUESTO,
			@PP_C_ESTATUS_PLAN_PRESUPUESTO,
			@PP_L_ESTATUS_PLAN_PRESUPUESTO		)
	ELSE
		UPDATE	ESTATUS_PLAN_PRESUPUESTO
		SET		D_ESTATUS_PLAN_PRESUPUESTO	= @PP_D_ESTATUS_PLAN_PRESUPUESTO,	
				S_ESTATUS_PLAN_PRESUPUESTO	= @PP_S_ESTATUS_PLAN_PRESUPUESTO,			
				O_ESTATUS_PLAN_PRESUPUESTO	= @PP_O_ESTATUS_PLAN_PRESUPUESTO,
				C_ESTATUS_PLAN_PRESUPUESTO	= @PP_C_ESTATUS_PLAN_PRESUPUESTO,
				L_ESTATUS_PLAN_PRESUPUESTO	= @PP_L_ESTATUS_PLAN_PRESUPUESTO	
		WHERE	K_ESTATUS_PLAN_PRESUPUESTO=@PP_K_ESTATUS_PLAN_PRESUPUESTO

	-- ==============================================
GO





-- ///////////////////////////////////////////////////////////////
-- // ESTATUS_PLAN_PRESUPUESTO 						
-- ///////////////////////////////////////////////////////////////

EXECUTE [dbo].[PG_CI_ESTATUS_PLAN_PRESUPUESTO]	0, 0, 1, 'BASE',			'BASE', 10, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PLAN_PRESUPUESTO]	0, 0, 2, 'WORKING',			'WORK', 20, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PLAN_PRESUPUESTO]	0, 0, 3, 'PREVIO',			'PREV', 30, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PLAN_PRESUPUESTO]	0, 0, 4, 'REVISADO',		'REVS', 40, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PLAN_PRESUPUESTO]	0, 0, 5, 'AUTORIZADO',		'AUTR', 50, '', 1
GO






-- ///////////////////////////////////////////////////////////////
-- //						PLAN_PRESUPUESTO 						
-- ///////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[PLAN_PRESUPUESTO] (
	[K_PLAN_PRESUPUESTO]			[INT] NOT NULL,
	[D_PLAN_PRESUPUESTO]			[VARCHAR] (100) NOT NULL	DEFAULT '',
	[C_PLAN_PRESUPUESTO]			[VARCHAR] (255) NOT NULL	DEFAULT '',
	[S_PLAN_PRESUPUESTO]			[VARCHAR] (10)  NOT NULL	DEFAULT '',
	-- ========================================
	[K_UNIDAD_OPERATIVA]			[INT] NOT NULL,
	[K_YYYY]						[INT] NOT NULL,
	[K_TEMPORADA]					[INT] NOT NULL,
	[K_ESTATUS_PLAN_PRESUPUESTO]	[INT] NOT NULL,
	-- ========================================	
	[K_USUARIO_PASO_1]				[INT]		NULL,
	[F_PASO_1]						[DATETIME]	NULL,
	[K_USUARIO_PASO_2]				[INT]		NULL,
	[F_PASO_2]						[DATETIME]	NULL,
	[K_USUARIO_PASO_3]				[INT]		NULL,
	[F_PASO_3]						[DATETIME]	NULL,
	[K_USUARIO_PASO_4]				[INT]		NULL,
	[F_PASO_4]						[DATETIME]	NULL,
	[K_USUARIO_PASO_5]				[INT]		NULL,
	[F_PASO_5]						[DATETIME]	NULL,
	-- ========================================	
	[L_RECALCULAR]					[INT] NOT NULL DEFAULT 1
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PLAN_PRESUPUESTO]
	ADD CONSTRAINT [PK_PLAN_PRESUPUESTO]
		PRIMARY KEY CLUSTERED ([K_PLAN_PRESUPUESTO])
GO




-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PLAN_PRESUPUESTO] ADD 
	CONSTRAINT [FK_PLAN_PRESUPUESTO_01] 
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA]),
	CONSTRAINT [FK_PLAN_PRESUPUESTO_02] 
		FOREIGN KEY ([K_ESTATUS_PLAN_PRESUPUESTO]) 
		REFERENCES [dbo].[ESTATUS_PLAN_PRESUPUESTO] ([K_ESTATUS_PLAN_PRESUPUESTO]),
	CONSTRAINT [FK_PLAN_PRESUPUESTO_03] 
		FOREIGN KEY ([K_TEMPORADA]) 
		REFERENCES [dbo].[TEMPORADA] ([K_TEMPORADA])
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PLAN_PRESUPUESTO] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO




ALTER TABLE [dbo].[PLAN_PRESUPUESTO] ADD 
	CONSTRAINT [FK_PLAN_PRESUPUESTO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PLAN_PRESUPUESTO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PLAN_PRESUPUESTO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
