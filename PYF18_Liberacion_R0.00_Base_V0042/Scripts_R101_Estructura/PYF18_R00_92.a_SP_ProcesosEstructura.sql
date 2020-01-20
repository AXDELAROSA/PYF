-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			ESTRUCTURA / UNIDAD OPERATIVA
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////


-- [PG_LI_PLANTA_LOTE_PROCESO] 0,0,0,		-1, -1, -1


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PLANTA_LOTE_PROCESO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PLANTA_LOTE_PROCESO]
GO


CREATE PROCEDURE [dbo].[PG_LI_PLANTA_LOTE_PROCESO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_ZONA_UO					INT,
	@PP_K_RAZON_SOCIAL				INT,
	@PP_K_UNIDAD_OPERATIVA			INT
	-- ===========================
AS		

	DECLARE @VP_MENSAJE		VARCHAR(300)

	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_INT_NUMERO_REGISTROS	INT
	
	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
	-- =========================================		

	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0

	IF @PP_K_ZONA_UO=-1	AND @PP_K_RAZON_SOCIAL=-1 AND @PP_K_UNIDAD_OPERATIVA=-1
		SET @VP_INT_NUMERO_REGISTROS = 0

	-- =========================================		
			
	SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
			UNIDAD_OPERATIVA.*,
			-- =================================			
			D_ESTATUS_ACTIVO, D_RAZON_SOCIAL, D_REGION, D_TIPO_UO, D_ZONA_UO,
			S_ESTATUS_ACTIVO, S_RAZON_SOCIAL, S_REGION, S_TIPO_UO, S_ZONA_UO,					
			D_USUARIO AS D_USUARIO_CAMBIO
			-- =================================
	FROM	UNIDAD_OPERATIVA, VI_UNIDAD_OPERATIVA_CATALOGOS,
			ESTATUS_ACTIVO, USUARIO
			-- =================================
	WHERE	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
	AND		UNIDAD_OPERATIVA.L_UNIDAD_OPERATIVA=ESTATUS_ACTIVO.K_ESTATUS_ACTIVO
	AND		UNIDAD_OPERATIVA.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- =====================================================
	AND		UNIDAD_OPERATIVA.L_BORRADO=0
	AND		UNIDAD_OPERATIVA.K_TIPO_UO=10			-- 10	PLANTA 
	AND		VI_K_UNIDAD_OPERATIVA<>0
			-- =====================================================
	AND		( @PP_K_ZONA_UO=-1				OR		VI_K_ZONA_UO=@PP_K_ZONA_UO )
	AND		( @PP_K_RAZON_SOCIAL=-1			OR		VI_K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL )
	AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR		VI_K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA )
			-- =====================================================
	ORDER BY D_ZONA_UO, D_UNIDAD_OPERATIVA

	-- ////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
