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



--EXECUTE [dbo].[PG_LI_VALOR_PARAMETRO] 'PP_D_VALOR_PARAMETRO', ''

--EXECUTE [PG_UP_VALOR_PARAMETRO] 10, '@PP_D_VALOR_PARAMETRO', '@PP_C_VALOR_PARAMETRO', 6,
--		  '@VALOR_PARAMETRO_TXT_1', '@VALOR_PARAMETRO_TXT_2', '@VALOR_PARAMETRO_TXT_3', 0, 0, 0, 0, 0, 0,

--EXECUTE [PG_SK_VALOR_PARAMETRO] 10


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_VALOR_PARAMETRO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_VALOR_PARAMETRO]
GO


CREATE PROCEDURE [dbo].[PG_LI_VALOR_PARAMETRO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_L_APLICAR_MAX_ROWS	INT,
	@PP_D_VALOR_PARAMETRO	VARCHAR(100),
	@PP_K_PARAMETRO			INT
AS

	DECLARE @VP_INT_NUMERO_REGISTROS INT
	
	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																@PP_L_APLICAR_MAX_ROWS, 
																@OU_LI_N_REGISTROS = @VP_INT_NUMERO_REGISTROS		OUTPUT
	-- ============================================

	SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
			VALOR_PARAMETRO.*, 
			D_PARAMETRO
	FROM	VALOR_PARAMETRO, PARAMETRO	
	WHERE	VALOR_PARAMETRO.K_PARAMETRO = PARAMETRO.K_PARAMETRO
	  AND	D_VALOR_PARAMETRO		LIKE '%'+@PP_D_VALOR_PARAMETRO+'%'
	  AND	( @PP_K_PARAMETRO=-1	OR	 @PP_K_PARAMETRO = VALOR_PARAMETRO.K_PARAMETRO )
GO

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_VALOR_PARAMETRO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_VALOR_PARAMETRO]
GO


CREATE PROCEDURE [dbo].[PG_SK_VALOR_PARAMETRO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_VALOR_PARAMETRO		INT
AS

	SELECT	VALOR_PARAMETRO.*, 
			D_PARAMETRO
	FROM	VALOR_PARAMETRO, PARAMETRO	
	WHERE	VALOR_PARAMETRO.K_PARAMETRO = PARAMETRO.K_PARAMETRO
	  AND	K_VALOR_PARAMETRO			= @PP_K_VALOR_PARAMETRO

GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_VALOR_PARAMETRO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_VALOR_PARAMETRO]
GO


CREATE PROCEDURE [dbo].[PG_UP_VALOR_PARAMETRO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_VALOR_PARAMETRO			INT,
	@PP_D_VALOR_PARAMETRO			VARCHAR(100),
	@PP_C_VALOR_PARAMETRO			VARCHAR(255),
	@PP_VALOR_PARAMETRO_TXT_1		VARCHAR(255),
	@PP_VALOR_PARAMETRO_TXT_2		VARCHAR(255),
	@PP_VALOR_PARAMETRO_TXT_3		VARCHAR(255),
	@PP_VALOR_PARAMETRO_INT_1		INT,
	@PP_VALOR_PARAMETRO_INT_2		INT,
	@PP_VALOR_PARAMETRO_INT_3		INT,
	@PP_VALOR_PARAMETRO_FLO_1		FLOAT,
	@PP_VALOR_PARAMETRO_FLO_2		FLOAT,
	@PP_VALOR_PARAMETRO_FLO_3		FLOAT
AS

	UPDATE	VALOR_PARAMETRO
	SET		D_VALOR_PARAMETRO		= @PP_D_VALOR_PARAMETRO, 
			C_VALOR_PARAMETRO		= @PP_C_VALOR_PARAMETRO,
			VALOR_PARAMETRO_TXT_1	= @PP_VALOR_PARAMETRO_TXT_1,
			VALOR_PARAMETRO_TXT_2	= @PP_VALOR_PARAMETRO_TXT_2,
			VALOR_PARAMETRO_TXT_3	= @PP_VALOR_PARAMETRO_TXT_3,
			VALOR_PARAMETRO_INT_1	= @PP_VALOR_PARAMETRO_INT_1,
			VALOR_PARAMETRO_INT_2	= @PP_VALOR_PARAMETRO_INT_2,
			VALOR_PARAMETRO_INT_3	= @PP_VALOR_PARAMETRO_INT_3,
			VALOR_PARAMETRO_FLO_1	= @PP_VALOR_PARAMETRO_FLO_1,
			VALOR_PARAMETRO_FLO_2	= @PP_VALOR_PARAMETRO_FLO_2,
			VALOR_PARAMETRO_FLO_3	= @PP_VALOR_PARAMETRO_FLO_3
	WHERE	K_VALOR_PARAMETRO		= @PP_K_VALOR_PARAMETRO

GO


-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
