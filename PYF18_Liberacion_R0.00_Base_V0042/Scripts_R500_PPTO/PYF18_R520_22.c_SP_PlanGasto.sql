-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PLAN_GASTO / PLANTA
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	09/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PLAN_GASTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PLAN_GASTO]
GO


CREATE PROCEDURE [dbo].[PG_LI_PLAN_GASTO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_BUSCAR						VARCHAR(255),
	-- ===========================
	@PP_K_ZONA_UO					INT,
	@PP_K_REGION					INT,
	@PP_K_RAZON_SOCIAL				INT,
	@PP_K_YYYY						INT,
	@PP_K_ESCENARIO_PLAN			INT,
	@PP_K_ESTATUS_PLAN_GASTO		INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													8, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT
	
	SET @VP_LI_N_REGISTROS = 1000
	
	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															1, -- WIWI // @VP_L_APLICAR_MAX_ROWS,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- =========================================	
	
	IF NOT (@VP_MENSAJE='')
		SET @VP_LI_N_REGISTROS = 0

	-- ///////////////////////////////////////////
	
	SELECT	TOP ( @VP_LI_N_REGISTROS )	
			PLAN_GASTO.*, 
			K_YYYY,
			------------------------------------------
			S_ESCENARIO_PLAN,		D_ESCENARIO_PLAN, 
			S_ESTATUS_PLAN_GASTO,	D_ESTATUS_PLAN_GASTO,		
			------------------------------------------
			S_UNIDAD_OPERATIVA,		D_UNIDAD_OPERATIVA, 			
			S_ZONA_UO,				D_ZONA_UO,
			S_REGION,				D_REGION,
			S_RAZON_SOCIAL,			D_RAZON_SOCIAL,
			------------------------------------------
			D_USUARIO AS D_USUARIO_CAMBIO			
	FROM	PLAN_GASTO, USUARIO,
			ESCENARIO_PLAN, ESTATUS_PLAN_GASTO,
			VI_UNIDAD_OPERATIVA_CATALOGOS
	WHERE	PLAN_GASTO.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
	AND		PLAN_GASTO.K_ESCENARIO_PLAN=ESCENARIO_PLAN.K_ESCENARIO_PLAN
	AND		PLAN_GASTO.K_ESTATUS_PLAN_GASTO=ESTATUS_PLAN_GASTO.K_ESTATUS_PLAN_GASTO
	AND		PLAN_GASTO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- =====================
	AND		(	
				D_ZONA_UO			LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_REGION			LIKE '%'+@PP_BUSCAR+'%'	
			OR	D_RAZON_SOCIAL		LIKE '%'+@PP_BUSCAR+'%'
			OR	D_UNIDAD_OPERATIVA	LIKE '%'+@PP_BUSCAR+'%'
			OR	D_ESCENARIO_PLAN	LIKE '%'+@PP_BUSCAR+'%'						
			)			
			-- =====================
	AND		( @PP_K_ZONA_UO=-1				OR	@PP_K_ZONA_UO=VI_K_ZONA_UO )
	AND		( @PP_K_REGION=-1				OR	@PP_K_REGION=VI_K_REGION )
	AND		( @PP_K_RAZON_SOCIAL=-1			OR	@PP_K_RAZON_SOCIAL=VI_K_RAZON_SOCIAL )
	AND		( @PP_K_ESCENARIO_PLAN=-1		OR	@PP_K_ESCENARIO_PLAN=PLAN_GASTO.K_ESCENARIO_PLAN )
	AND		( @PP_K_ESTATUS_PLAN_GASTO=-1	OR	@PP_K_ESTATUS_PLAN_GASTO=PLAN_GASTO.K_ESTATUS_PLAN_GASTO )
	AND		( @PP_K_YYYY=-1					OR	@PP_K_YYYY=PLAN_GASTO.K_YYYY )
	AND		PLAN_GASTO.L_BORRADO=0
			-- =====================
	ORDER BY PLAN_GASTO.K_YYYY DESC, D_UNIDAD_OPERATIVA

	-- //////////////////////////////////////////////////////////////

GO







-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
