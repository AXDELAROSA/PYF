-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CALCULOS
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////







-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////
-- [PG_LI_CEMEC] 0,0,0,		'', -1,-1,-1, -1,-1,-1, 1


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_CEMEC]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_CEMEC]
GO



CREATE PROCEDURE [dbo].[PG_LI_CEMEC]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================		
	@PP_BUSCAR							VARCHAR(200),
	-- ===========================
	@PP_K_ZONA_UO						INT,
	@PP_K_RAZON_SOCIAL					INT,
	@PP_K_UNIDAD_OPERATIVA				INT,
	-- ===========================
	@PP_K_YYYY							INT,
	@PP_K_MES							INT,
	@PP_K_ESTATUS_DOCUMENTO_D0M4		INT,
	-- ===========================
	@PP_K_DIVISOR						INT
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

	IF @VP_MENSAJE=''
		BEGIN
	
		DECLARE @VP_INT_NUMERO_REGISTROS	INT
	
		EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																			@VP_L_APLICAR_MAX_ROWS,		
																			@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
		-- =========================================		

		DECLARE @VP_K_FOLIO		INT

		EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_BUSCAR, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
		-- =========================================

		IF @VP_MENSAJE<>''
			SET @VP_INT_NUMERO_REGISTROS=0

		SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
				DOC.*, 
				PARAMETRO_DOCUMENTO_D0M4.*,
				-- =========================		
				VI_K_ZONA_UO		AS K_ZONA_UO,	
				VI_K_RAZON_SOCIAL	AS K_RAZON_SOCIAL,
				-- =========================		
				D_ZONA_UO,					S_ZONA_UO,
				D_RAZON_SOCIAL,				S_RAZON_SOCIAL,			
				D_UNIDAD_OPERATIVA,			S_UNIDAD_OPERATIVA,
				D_ESTATUS_DOCUMENTO_D0M4,	S_ESTATUS_DOCUMENTO_D0M4,
				D_FORMATO_D0M4,				S_FORMATO_D0M4,
				D_TIEMPO_MES,				S_TIEMPO_MES,
				-- =========================		
				[P1003_VENTA_KG_CONTADO]		AS VENTA_KG_CONTADO,
				[P1004_VENTA_KG_CREDITO]		AS VENTA_KG_CREDITO,
				( [P1003_VENTA_KG_CONTADO]+[P1004_VENTA_KG_CREDITO]	)
												AS VENTA_KG_TOTAL,
				CONVERT( INT, ( [P1003_VENTA_KG_CONTADO] / @PP_K_DIVISOR ) )	AS DIV_VENTA_KG_CONTADO,
				CONVERT( INT, ( [P1004_VENTA_KG_CREDITO] / @PP_K_DIVISOR ) )	AS DIV_VENTA_KG_CREDITO,	
				CONVERT( INT, ( ( [P1003_VENTA_KG_CONTADO]+[P1004_VENTA_KG_CREDITO]	) / @PP_K_DIVISOR ) ) 
																				AS DIV_VENTA_KG_TOTAL,	
	  			-- =========================		
				( DESCUENTO_CONTADO*100 )			AS DESCUENTO_CONTADO_0_100,
				( DESCUENTO_CREDITO*100 )			AS DESCUENTO_CREDITO_0_100,
				( VENTA_PORCENTAJE_CONTADO*100 )	AS VENTA_PORCENTAJE_CONTADO_0_100,
				( VENTA_PORCENTAJE_CREDITO*100 )	AS VENTA_PORCENTAJE_CREDITO_0_100,
				( COBRANZA_HOLGURA*100 )			AS COBRANZA_HOLGURA_0_100,
				-- =========================		
				USUARIO.D_USUARIO	AS 'D_USUARIO_CAMBIO'
		FROM	DOCUMENTO_D0M4 AS DOC, VI_UNIDAD_OPERATIVA_CATALOGOS, 
				PARAMETRO_DOCUMENTO_D0M4,				
				TIEMPO_MES, ESTATUS_DOCUMENTO_D0M4, 
				FORMATO_D0M4, USUARIO
		WHERE	DOC.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA 	
		AND		DOC.K_DOCUMENTO_D0M4=PARAMETRO_DOCUMENTO_D0M4.K_DOCUMENTO_D0M4
		AND		DOC.K_MM=TIEMPO_MES.K_TIEMPO_MES
		AND		DOC.K_ESTATUS_DOCUMENTO_D0M4=ESTATUS_DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4
		AND		DOC.K_FORMATO_D0M4=FORMATO_D0M4.K_FORMATO_D0M4 
		AND		DOC.K_USUARIO_CAMBIO=USUARIO.K_USUARIO 
		AND		DOC.L_BORRADO=0
		AND		DOC.K_FORMATO_D0M4=101				-- #101 CEMEC / #102 FLUP
				-- =====================================================
		AND		(	D_ZONA_UO				LIKE '%'+@PP_BUSCAR+'%' 
				OR	D_RAZON_SOCIAL			LIKE '%'+@PP_BUSCAR+'%' 
				OR	D_UNIDAD_OPERATIVA		LIKE '%'+@PP_BUSCAR+'%' 
				OR	DOC.K_DOCUMENTO_D0M4=@VP_K_FOLIO	)	
				-- =====================================================
		AND		(	@PP_K_ZONA_UO=-1					OR  VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_ZONA_UO=@PP_K_ZONA_UO	)			
		AND		(	@PP_K_RAZON_SOCIAL=-1				OR  VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL	)			
		AND		(	@PP_K_UNIDAD_OPERATIVA=-1			OR  DOC.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA	)	
				-- =====================================================
		AND		(	@PP_K_ESTATUS_DOCUMENTO_D0M4=-1		OR  DOC.K_ESTATUS_DOCUMENTO_D0M4=@PP_K_ESTATUS_DOCUMENTO_D0M4	)		
		AND		(	@PP_K_YYYY=-1						OR  DOC.K_YYYY=@PP_K_YYYY	)	
		AND		(	@PP_K_MES=-1						OR  TIEMPO_MES.K_TIEMPO_MES=@PP_K_MES	)
		ORDER BY D_ZONA_UO, D_UNIDAD_OPERATIVA
						
		END	

	-- ////////////////////////////////////////////////
GO






-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
