-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CONTROL OPERACION / <UNIDAD_OPERATIVA>
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	24/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- SELECT * FROM MATRIZ_CONTROL_X_MES



-- //////////////////////////////////////////////////////
-- // SP // CARGA INICIAL
-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_MATRIZ_CONTROL_X_MES_X_UNIDAD_OPERATIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_MATRIZ_CONTROL_X_MES_X_UNIDAD_OPERATIVA]
GO


CREATE PROCEDURE [dbo].[PG_CI_MATRIZ_CONTROL_X_MES_X_UNIDAD_OPERATIVA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_YYYY						INT,
	@PP_K_UNIDAD_OPERATIVA			INT
AS			
		-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	[K_YYYY]
							FROM	[MATRIZ_CONTROL_X_MES_X_UNIDAD_OPERATIVA]
							WHERE	[K_YYYY]=@PP_K_YYYY
							AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO  [dbo].[MATRIZ_CONTROL_X_MES_X_UNIDAD_OPERATIVA] 
			( [K_YYYY],		K_UNIDAD_OPERATIVA )
		VALUES
			( @PP_K_YYYY,	@PP_K_UNIDAD_OPERATIVA )
			
	-- ==============================================
GO





-- //////////////////////////////////////////////////////
-- // DATA // CARGA INICIAL
-- //////////////////////////////////////////////////////


EXECUTE [dbo].[PG_CI_MATRIZ_CONTROL_X_MES_X_UNIDAD_OPERATIVA]	0,0,0,	2016, 51
EXECUTE [dbo].[PG_CI_MATRIZ_CONTROL_X_MES_X_UNIDAD_OPERATIVA]	0,0,0,	2017, 52
EXECUTE [dbo].[PG_CI_MATRIZ_CONTROL_X_MES_X_UNIDAD_OPERATIVA]	0,0,0,	2018, 53
EXECUTE [dbo].[PG_CI_MATRIZ_CONTROL_X_MES_X_UNIDAD_OPERATIVA]	0,0,0,	2019, 54 
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
