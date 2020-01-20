-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CONTROL OPERACION / <GLOBAL>
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_MATRIZ_CONTROL_X_MES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_MATRIZ_CONTROL_X_MES]
GO


CREATE PROCEDURE [dbo].[PG_CI_MATRIZ_CONTROL_X_MES]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_YYYY						INT
AS			
		-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	[K_YYYY]
							FROM	[MATRIZ_CONTROL_X_MES]
							WHERE	[K_YYYY]=@PP_K_YYYY

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO  [dbo].[MATRIZ_CONTROL_X_MES] 
			( [K_YYYY] )
		VALUES
			( @PP_K_YYYY )
			
	-- ==============================================
GO





-- //////////////////////////////////////////////////////
-- // DATA // CARGA INICIAL
-- //////////////////////////////////////////////////////


EXECUTE [dbo].[PG_CI_MATRIZ_CONTROL_X_MES]	0,0,0,	2016
EXECUTE [dbo].[PG_CI_MATRIZ_CONTROL_X_MES]	0,0,0,	2017
EXECUTE [dbo].[PG_CI_MATRIZ_CONTROL_X_MES]	0,0,0,	2018
EXECUTE [dbo].[PG_CI_MATRIZ_CONTROL_X_MES]	0,0,0,	2019
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
