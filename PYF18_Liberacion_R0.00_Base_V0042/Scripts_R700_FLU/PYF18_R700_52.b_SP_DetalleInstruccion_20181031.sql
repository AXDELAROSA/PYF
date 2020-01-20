-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			DETALLE_INSTRUCCION
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	18/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_DETALLE_INSTRUCCION_X_K_INSTRUCCION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_DETALLE_INSTRUCCION_X_K_INSTRUCCION]
GO




CREATE PROCEDURE [dbo].[PG_LI_DETALLE_INSTRUCCION_X_K_INSTRUCCION]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_INSTRUCCION				INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													8, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT
	
	SET @VP_LI_N_REGISTROS = 1000
	
	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															1,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- =========================================	
	
	IF NOT (@VP_MENSAJE='')
		SET @VP_LI_N_REGISTROS = 0

	-- ///////////////////////////////////////////

	SELECT	TOP ( @VP_LI_N_REGISTROS )	
				FECHA_TRA.D_TIEMPO_FECHA AS F_TRASPASO_DDMMMYYYY,
				FECHA_FAC.D_TIEMPO_FECHA AS F_CXP_DDMMMYYYY,
				DETALLE_INSTRUCCION.*,
				TRASPASO.D_TRASPASO, TRASPASO.F_OPERACION,
				FACTURA_CXP.C_FACTURA_CXP, FACTURA_CXP.F_EMISION
			-- =============================
	FROM		DETALLE_INSTRUCCION 
	LEFT JOIN	TRASPASO					ON DETALLE_INSTRUCCION.K_TRASPASO=TRASPASO.K_TRASPASO
	LEFT JOIN	FACTURA_CXP					ON DETALLE_INSTRUCCION.K_FACTURA_CXP=FACTURA_CXP.K_FACTURA_CXP
	LEFT JOIN	TIEMPO_FECHA AS FECHA_TRA	ON TRASPASO.F_OPERACION=FECHA_TRA.F_TIEMPO_FECHA
	LEFT JOIN	TIEMPO_FECHA AS FECHA_FAC	ON FACTURA_CXP.F_EMISION=FECHA_FAC.F_TIEMPO_FECHA
			-- =============================
	WHERE		DETALLE_INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION 
	AND			DETALLE_INSTRUCCION.L_BORRADO=0
			-- =====================
	ORDER BY	K_DETALLE_INSTRUCCION DESC

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_DETALLE_INSTRUCCION_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_DETALLE_INSTRUCCION_SQL]
GO


CREATE PROCEDURE [dbo].[PG_IN_DETALLE_INSTRUCCION_SQL] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_DETALLE_INSTRUCCION		INT,
	@PP_K_INSTRUCCION				INT, 
	@PP_K_TRASPASO 					INT, 
	@PP_K_FACTURA_CXP				INT,
	@PP_MONTO						DECIMAL(19,4)
AS			

	INSERT INTO [DETALLE_INSTRUCCION]	
			(	[K_DETALLE_INSTRUCCION],
				[K_INSTRUCCION], 
				[K_TRASPASO], [K_FACTURA_CXP],
				[MONTO],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )	
			VALUES
			(	@PP_K_DETALLE_INSTRUCCION,
				@PP_K_INSTRUCCION, 
				@PP_K_TRASPASO, @PP_K_FACTURA_CXP,
				@PP_MONTO,				
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )

	-- //////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
