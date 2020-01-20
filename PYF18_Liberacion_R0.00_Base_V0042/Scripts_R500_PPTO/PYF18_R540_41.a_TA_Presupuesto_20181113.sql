-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PRESUPUESTO GASTOS/PLANTA
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	24/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRESUPUESTO]') AND type in (N'U'))
	DROP TABLE [dbo].[PRESUPUESTO] 
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_PRESUPUESTO]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_PRESUPUESTO] 
GO





-- ///////////////////////////////////////////////////////////////
-- // ESTATUS_PRESUPUESTO 						
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ESTATUS_PRESUPUESTO] (
	[K_ESTATUS_PRESUPUESTO]		[INT] 			NOT NULL,
	[D_ESTATUS_PRESUPUESTO]		[VARCHAR] (100) NOT NULL,
	[S_ESTATUS_PRESUPUESTO]		[VARCHAR] (10) 	NOT NULL,
	[O_ESTATUS_PRESUPUESTO]		[INT] 			NOT NULL,
	[C_ESTATUS_PRESUPUESTO]		[VARCHAR] (255) NOT NULL,
	[L_ESTATUS_PRESUPUESTO]		[INT] 			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[ESTATUS_PRESUPUESTO]
	ADD CONSTRAINT [PK_ESTATUS_PRESUPUESTO]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_PRESUPUESTO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_PRESUPUESTO_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_PRESUPUESTO] ( [D_ESTATUS_PRESUPUESTO] )
GO

-- //////////////////////////////////////////////////////






IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_PRESUPUESTO]
GO



CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_PRESUPUESTO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	-- =========================
	@PP_K_ESTATUS_PRESUPUESTO		INT,
	@PP_D_ESTATUS_PRESUPUESTO		VARCHAR(100),
	@PP_S_ESTATUS_PRESUPUESTO		VARCHAR(10),
	@PP_O_ESTATUS_PRESUPUESTO		INT,
	@PP_C_ESTATUS_PRESUPUESTO		VARCHAR(255),
	@PP_L_ESTATUS_PRESUPUESTO		INT
AS

	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_ESTATUS_PRESUPUESTO
							FROM	ESTATUS_PRESUPUESTO
							WHERE	K_ESTATUS_PRESUPUESTO=@PP_K_ESTATUS_PRESUPUESTO

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO ESTATUS_PRESUPUESTO
		(	K_ESTATUS_PRESUPUESTO,			D_ESTATUS_PRESUPUESTO, 
			S_ESTATUS_PRESUPUESTO,			O_ESTATUS_PRESUPUESTO,
			C_ESTATUS_PRESUPUESTO,
			L_ESTATUS_PRESUPUESTO			)		
		VALUES	
		(	@PP_K_ESTATUS_PRESUPUESTO,		@PP_D_ESTATUS_PRESUPUESTO,	
			@PP_S_ESTATUS_PRESUPUESTO,		@PP_O_ESTATUS_PRESUPUESTO,
			@PP_C_ESTATUS_PRESUPUESTO,
			@PP_L_ESTATUS_PRESUPUESTO		)
	ELSE
		UPDATE	ESTATUS_PRESUPUESTO
		SET		D_ESTATUS_PRESUPUESTO	= @PP_D_ESTATUS_PRESUPUESTO,	
				S_ESTATUS_PRESUPUESTO	= @PP_S_ESTATUS_PRESUPUESTO,			
				O_ESTATUS_PRESUPUESTO	= @PP_O_ESTATUS_PRESUPUESTO,
				C_ESTATUS_PRESUPUESTO	= @PP_C_ESTATUS_PRESUPUESTO,
				L_ESTATUS_PRESUPUESTO	= @PP_L_ESTATUS_PRESUPUESTO	
		WHERE	K_ESTATUS_PRESUPUESTO=@PP_K_ESTATUS_PRESUPUESTO

	-- ==============================================
GO





-- ///////////////////////////////////////////////////////////////
-- // ESTATUS_PRESUPUESTO 						
-- ///////////////////////////////////////////////////////////////

EXECUTE [dbo].[PG_CI_ESTATUS_PRESUPUESTO]	0, 0, 1, 'BASE',			'BASE', 10, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PRESUPUESTO]	0, 0, 2, 'EN PROCESO',		'PROC', 20, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PRESUPUESTO]	0, 0, 3, 'PREVIO',			'PREV', 30, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PRESUPUESTO]	0, 0, 4, 'AUTORIZADO',		'AUTR', 40, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PRESUPUESTO]	0, 0, 5, 'CANCELADO',		'CANC', 50, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PRESUPUESTO]	0, 0, 6, 'EJECUTADO',		'EJEC', 60, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_PRESUPUESTO]	0, 0, 7, 'CERRADO',			'CERR', 70, '', 1
GO






-- ///////////////////////////////////////////////////////////////
-- //						PRESUPUESTO 						
-- ///////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[PRESUPUESTO] (
	[K_PRESUPUESTO]				[INT] NOT NULL,
	[D_PRESUPUESTO]				[VARCHAR] (100) NOT NULL,
	[C_PRESUPUESTO]				[VARCHAR] (255) NOT NULL,
	[S_PRESUPUESTO]				[VARCHAR] (10) NOT NULL,
	[O_PRESUPUESTO]				[INT] NOT NULL,  
	-- ========================================
--	[K_FORMATO_D0M4]				[INT] NOT NULL,
	[K_UNIDAD_OPERATIVA]			[INT] NOT NULL,
	[K_YYYY]						[INT] NOT NULL,
	[K_MM]							[INT] NOT NULL,
	[K_ESTATUS_PRESUPUESTO]		[INT] NOT NULL,
--	[K_PRECIO_COSTO_PERFIL]			[INT] NOT NULL,
	[L_RECALCULAR]					[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PRESUPUESTO]
	ADD CONSTRAINT [PK_PRESUPUESTO]
		PRIMARY KEY CLUSTERED ([K_PRESUPUESTO])
GO




-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PRESUPUESTO] ADD 
	CONSTRAINT [FK_PRESUPUESTO_01] 
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA]),
	CONSTRAINT [FK_PRESUPUESTO_02] 
		FOREIGN KEY ([K_ESTATUS_PRESUPUESTO]) 
		REFERENCES [dbo].[ESTATUS_PRESUPUESTO] ([K_ESTATUS_PRESUPUESTO])
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PRESUPUESTO] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[PRESUPUESTO] ADD 
	CONSTRAINT [FK_PRESUPUESTO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PRESUPUESTO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PRESUPUESTO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
