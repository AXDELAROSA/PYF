-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			Temporada
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////

-- //////////////////////////////////////////////////////////////
-- // TEMPORADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TEMPORADA]') AND type in (N'U'))
	DROP TABLE [dbo].[TEMPORADA]
GO


CREATE TABLE [dbo].[TEMPORADA] (
	[K_TEMPORADA]	[INT] NOT NULL,
	[D_TEMPORADA]	[VARCHAR] (100) NOT NULL,
	[S_TEMPORADA]	[VARCHAR] (10) NOT NULL,
	[O_TEMPORADA]	[INT] NOT NULL,
	[C_TEMPORADA]	[VARCHAR] (255) NOT NULL,
	[L_TEMPORADA]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[TEMPORADA]
	ADD CONSTRAINT [PK_TEMPORADA]
		PRIMARY KEY CLUSTERED ([K_TEMPORADA])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TEMPORADA_01_DESCRIPCION] 
	   ON [dbo].[TEMPORADA] ( [D_TEMPORADA] )
GO


ALTER TABLE [dbo].[TEMPORADA] ADD 
	CONSTRAINT [FK_TEMPORADA_01] 
		FOREIGN KEY ( [L_TEMPORADA] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TEMPORADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TEMPORADA]
GO


CREATE PROCEDURE [dbo].[PG_CI_TEMPORADA]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	-- ========================================
	@PP_K_TEMPORADA		INT,
	@PP_D_TEMPORADA		VARCHAR(100),
	@PP_S_TEMPORADA		VARCHAR(10),
	@PP_O_TEMPORADA		INT,
	@PP_C_TEMPORADA		VARCHAR(255),
	@PP_L_TEMPORADA		INT
AS
	
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_TEMPORADA
							FROM	TEMPORADA
							WHERE	K_TEMPORADA=@PP_K_TEMPORADA

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO TEMPORADA	
			(	K_TEMPORADA,				D_TEMPORADA, 
				S_TEMPORADA,				O_TEMPORADA,
				C_TEMPORADA,
				L_TEMPORADA				)		
		VALUES	
			(	@PP_K_TEMPORADA,			@PP_D_TEMPORADA,	
				@PP_S_TEMPORADA,			@PP_O_TEMPORADA,
				@PP_C_TEMPORADA,
				@PP_L_TEMPORADA			)
	ELSE
		UPDATE	TEMPORADA
		SET		D_TEMPORADA	= @PP_D_TEMPORADA,	
				S_TEMPORADA	= @PP_S_TEMPORADA,			
				O_TEMPORADA	= @PP_O_TEMPORADA,
				C_TEMPORADA	= @PP_C_TEMPORADA,
				L_TEMPORADA	= @PP_L_TEMPORADA	
		WHERE	K_TEMPORADA=@PP_K_TEMPORADA

	-- =========================================================
GO

-- //////////////////////////////////////////////////////////////

-- SELECT * FROM TEMPORADA


-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_TEMPORADA] 0, 0,    1, 'VERANO',		'VER',  1, '', 1
EXECUTE [dbo].[PG_CI_TEMPORADA] 0, 0,    2, 'INVIERNO',		'INV',  2, '', 1
GO
-- ===============================================
SET NOCOUNT OFF
-- ===============================================



-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
