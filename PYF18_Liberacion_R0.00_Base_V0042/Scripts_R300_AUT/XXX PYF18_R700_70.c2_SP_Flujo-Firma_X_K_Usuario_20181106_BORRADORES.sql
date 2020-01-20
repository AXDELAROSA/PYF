-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_R700_50.c_SP_Flujo-Firma_X_K_Usuario
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			AUTORIZACION_FIRMA
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			AX DE LA ROSA // HECTOR A. GONZALEZ 
-- // Fecha creación:	06/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  LISTADO FLUJO_FIRMA_X_K_USUARIO
-- //////////////////////////////////////////////////////////////

/*

EXECUTE [dbo].[PG_LI_FLUJO_FIRMA_X_K_USUARIO] 0,0,401,'',-1,-1

EXECUTE [dbo].[PG_LI_FLUJO_FIRMA_X_K_USUARIO] 0,0,401,'',-1, 1

EXECUTE [dbo].[PG_LI_FLUJO_FIRMA_X_K_USUARIO] 0,0,401,'',-1, 2

EXECUTE [dbo].[PG_LI_FLUJO_FIRMA_X_K_USUARIO] 0,0,401,'',-1, 3

EXECUTE [dbo].[PG_LI_FLUJO_FIRMA_X_K_USUARIO] 0,0,401,'',-1, 4

*/


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APG_LI_FLUJO_FIRMA_X_K_USUARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[APG_LI_FLUJO_FIRMA_X_K_USUARIO]
GO	


CREATE PROCEDURE [dbo].[APG_LI_FLUJO_FIRMA_X_K_USUARIO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_BUSCAR					VARCHAR(100),
	@PP_K_MODO_AUTORIZACION		INT,
	@PP_K_ESTATUS_FIRMA			INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)	= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT		= 1000
	
		EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																			1, -- WIWI // @VP_L_APLICAR_MAX_ROWS,
																			@OU_MAXROWS = @VP_LI_N_REGISTROS		OUTPUT
	-- =========================================	
	IF NOT (@VP_MENSAJE='')
		SET @VP_LI_N_REGISTROS = 0

	-- ///////////////////////////////////////////

	SELECT	TOP ( @VP_LI_N_REGISTROS )		
			FLUJO_FIRMA.*, 
			-- =========================================
			AUTORIZACION_FIRMA.D_AUTORIZACION_FIRMA, AUTORIZACION_FIRMA.S_AUTORIZACION_FIRMA,
			AUTORIZACION_FIRMA.MONTO_AUTORIZAR,AUTORIZACION_FIRMA.MONTO_AUTORIZADO,
			-- =========================================
			D_MODO_AUTORIZACION,  S_MODO_AUTORIZACION,
			-- =========================================
			USUARIO.D_USUARIO AS D_USUARIO_CAMBIO, USUARIO.S_USUARIO AS S_USUARIO_CAMBIO,
			-- =========================================
			ESTATUS_FIRMA.D_ESTATUS_FIRMA AS D_ESTATUS_FIRMA_FLUJO, ESTATUS_FIRMA.S_ESTATUS_FIRMA AS S_ESTATUS_FIRMA_FLUJO,
			-- =========================================
			ESTATUS_FIRMAA.D_ESTATUS_FIRMA AS ESTATUS_FIRMAA_D_ESTATUS_FIRMA,ESTATUS_FIRMAA.S_ESTATUS_FIRMA AS ESTATUS_FIRMAA_S_ESTATUS_FIRMA,
			ESTATUS_FIRMAB.D_ESTATUS_FIRMA AS ESTATUS_FIRMAB_D_ESTATUS_FIRMA,ESTATUS_FIRMAB.S_ESTATUS_FIRMA AS ESTATUS_FIRMAB_S_ESTATUS_FIRMA,
			ESTATUS_FIRMAC.D_ESTATUS_FIRMA AS ESTATUS_FIRMAC_D_ESTATUS_FIRMA, ESTATUS_FIRMAC.S_ESTATUS_FIRMA AS ESTATUS_FIRMAC_S_ESTATUS_FIRMA,
			-- =========================================
			ROLA.D_ROL_AUTORIZACION AS ROLA_D_ROL_AUTORIZACION, ROLA.S_ROL_AUTORIZACION AS ROLA_S_ROL_AUTORIZACION, 
			ROLB.D_ROL_AUTORIZACION AS ROLB_D_ROL_AUTORIZACION, ROLB.S_ROL_AUTORIZACION AS ROLB_S_ROL_AUTORIZACION,
			ROLC.D_ROL_AUTORIZACION AS ROLC_D_ROL_AUTORIZACION,	ROLC.S_ROL_AUTORIZACION AS ROLC_S_ROL_AUTORIZACION,
			-- =========================================
			USUARIO_FIRMAA.D_USUARIO AS USUARIO_FIRMAA_D_USUARIO, USUARIO_FIRMAA.S_USUARIO AS USUARIO_FIRMAA_S_USUARIO,
			USUARIO_FIRMAB.D_USUARIO AS USUARIO_FIRMAB_D_USUARIO, USUARIO_FIRMAB.S_USUARIO AS USUARIO_FIRMAB_S_USUARIO,
			USUARIO_FIRMAC.D_USUARIO AS USUARIO_FIRMAC_D_USUARIO, USUARIO_FIRMAC.S_USUARIO AS USUARIO_FIRMAC_S_USUARIO
			-- =========================================
	FROM	FLUJO_FIRMA
			-- =========================================
			LEFT JOIN AUTORIZACION_FIRMA ON FLUJO_FIRMA.K_AUTORIZACION_FIRMA=AUTORIZACION_FIRMA.K_AUTORIZACION_FIRMA
			-- =========================================
			LEFT JOIN ESTATUS_FIRMA AS ESTATUS_FIRMA_AUTORIZACION ON AUTORIZACION_FIRMA.K_ESTATUS_FIRMA=ESTATUS_FIRMA_AUTORIZACION.K_ESTATUS_FIRMA
			-- =========================================
			LEFT JOIN MODO_AUTORIZACION ON FLUJO_FIRMA.K_MODO_AUTORIZACION=MODO_AUTORIZACION.K_MODO_AUTORIZACION
			-- =========================================
			LEFT JOIN ESTATUS_FIRMA ON FLUJO_FIRMA.K_ESTATUS_FIRMA=ESTATUS_FIRMA.K_ESTATUS_FIRMA
			-- =========================================
			LEFT JOIN ROL_AUTORIZACION AS ROLA ON FLUJO_FIRMA.K_ROL_AUTORIZACION_A=ROLA.K_ROL_AUTORIZACION
			LEFT JOIN ROL_AUTORIZACION AS ROLB ON FLUJO_FIRMA.K_ROL_AUTORIZACION_B=ROLB.K_ROL_AUTORIZACION
			LEFT JOIN ROL_AUTORIZACION AS ROLC ON FLUJO_FIRMA.K_ROL_AUTORIZACION_C=ROLC.K_ROL_AUTORIZACION
			-- =========================================
			LEFT JOIN USUARIO AS USUARIO_FIRMAA ON FLUJO_FIRMA.K_USUARIO_FIRMA_A=USUARIO_FIRMAA.K_USUARIO
			LEFT JOIN USUARIO AS USUARIO_FIRMAB ON FLUJO_FIRMA.K_USUARIO_FIRMA_B=USUARIO_FIRMAB.K_USUARIO
			LEFT JOIN USUARIO AS USUARIO_FIRMAC ON FLUJO_FIRMA.K_USUARIO_FIRMA_C=USUARIO_FIRMAC.K_USUARIO
			-- =========================================
			LEFT JOIN ESTATUS_FIRMA AS ESTATUS_FIRMAA ON FLUJO_FIRMA.K_ESTATUS_FIRMA_A=ESTATUS_FIRMAA.K_ESTATUS_FIRMA
			LEFT JOIN ESTATUS_FIRMA AS ESTATUS_FIRMAB ON FLUJO_FIRMA.K_ESTATUS_FIRMA_B=ESTATUS_FIRMAB.K_ESTATUS_FIRMA
			LEFT JOIN ESTATUS_FIRMA AS ESTATUS_FIRMAC ON FLUJO_FIRMA.K_ESTATUS_FIRMA_C=ESTATUS_FIRMAC.K_ESTATUS_FIRMA
			-- =========================================
			LEFT JOIN USUARIO ON FLUJO_FIRMA.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- =========================================
	WHERE	FLUJO_FIRMA.L_BORRADO=0
		-- =========================================
	AND		(	@PP_K_MODO_AUTORIZACION=-1		OR	FLUJO_FIRMA.K_MODO_AUTORIZACION=@PP_K_MODO_AUTORIZACION )
	-- =========================================
	AND		(	@PP_K_ESTATUS_FIRMA=-1 			OR 	(	FLUJO_FIRMA.K_ESTATUS_FIRMA=@PP_K_ESTATUS_FIRMA
													AND	AUTORIZACION_FIRMA.K_ESTATUS_FIRMA=@PP_K_ESTATUS_FIRMA
													) 
			)
	AND		(	@PP_K_ESTATUS_FIRMA=-1
				OR
				(	FLUJO_FIRMA.K_ESTATUS_FIRMA_A=@PP_K_ESTATUS_FIRMA AND FLUJO_FIRMA.K_USUARIO_FIRMA_A=@PP_K_USUARIO_ACCION	)
				OR
				(	FLUJO_FIRMA.K_ESTATUS_FIRMA_B=@PP_K_ESTATUS_FIRMA AND FLUJO_FIRMA.K_USUARIO_FIRMA_B=@PP_K_USUARIO_ACCION	)
				OR
				(	FLUJO_FIRMA.K_ESTATUS_FIRMA_C=@PP_K_ESTATUS_FIRMA AND FLUJO_FIRMA.K_USUARIO_FIRMA_C=@PP_K_USUARIO_ACCION	)
			)
	-- =========================================
	AND		(		D_AUTORIZACION_FIRMA		LIKE '%'+@PP_BUSCAR+'%' 	
				OR	D_MODO_AUTORIZACION			LIKE '%'+@PP_BUSCAR+'%' 
			)
	-- =========================================
	AND		(	FLUJO_FIRMA.K_USUARIO_FIRMA_A=@PP_K_USUARIO_ACCION
			OR	FLUJO_FIRMA.K_USUARIO_FIRMA_B=@PP_K_USUARIO_ACCION
			OR	FLUJO_FIRMA.K_USUARIO_FIRMA_C=@PP_K_USUARIO_ACCION
		)
	ORDER BY FLUJO_FIRMA.K_FLUJO_FIRMA ASC

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////