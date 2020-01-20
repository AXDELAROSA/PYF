-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////

-- sp_helptext PG_UP_DATA_N1_X_DI_D0M4


-- SET STRICT_CHECKS ON;
-- SET DEFERRED_NAME_RESOLUTION OFF; 




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_DATA_N1_X_K_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_DATA1_N_X_K_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_DL_DATA_N1_X_K_DOCUMENTO_D0M4]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4			INT
	-- ===========================
AS		

	DELETE 
	FROM	DATA_N1_X_DI_D0M4
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4	
	
	-- ////////////////////////////////////////////////////
GO




IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_DATA_N1_X_DI_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_DATA_N1_X_DI_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_LI_DATA_N1_X_DI_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_BUSCAR					VARCHAR(100),
	@PP_K_ZONA_UO				INT,
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	-- ==============================	
	@PP_K_FORMATO_D0M4			INT,
	@PP_K_DATO_D0M4				INT,
	@PP_K_TIEMPO_YYYY			INT,
	@PP_K_TIEMPO_MES			INT,
	@PP_L_PARAMETRICAS			INT
AS
	-- ==============================================
	
	SELECT	
			DATA_N1_X_DI_D0M4.K_DOCUMENTO_D0M4,
			DATA_N1_X_DI_D0M4.K_DATO_D0M4,
			------------------------------------------
			S_UNIDAD_OPERATIVA,		D_UNIDAD_OPERATIVA, 			
			S_ZONA_UO,				D_ZONA_UO,
			S_REGION,				D_REGION,
			S_RAZON_SOCIAL,			D_RAZON_SOCIAL,
			------------------------------------------			
			S_FORMATO_D0M4,
			DOCUMENTO_D0M4.K_YYYY	AS D_YYYY, 		
			DOCUMENTO_D0M4.K_MM		AS D_MM,
			-- =========================
			L_BOLD,	L_ITALICA, N_INDENTAR, K_ALIGN,
			-- =========================
			' /// ',
			D_DATO_D0M4, S_UNIDAD_DATO_D0M4, 
			L_VISIBLE, L_EDITABLE,
			' /// ',
			[VALOR_ACUMULADO],
			[D00_VALOR], [DXX_VALOR], [DYY_VALOR], [DZZ_VALOR],
			[D01_VALOR], [D02_VALOR], [D03_VALOR], [D04_VALOR], [D05_VALOR], [D06_VALOR], [D07_VALOR], [D08_VALOR], [D09_VALOR], [D10_VALOR],
			[D11_VALOR], [D12_VALOR], [D13_VALOR], [D14_VALOR], [D15_VALOR], [D16_VALOR], [D17_VALOR], [D18_VALOR], [D19_VALOR], [D20_VALOR], 
			[D21_VALOR], [D22_VALOR], [D23_VALOR], [D24_VALOR], [D25_VALOR], [D26_VALOR], [D27_VALOR], [D28_VALOR], [D29_VALOR], [D30_VALOR], 
			[D31_VALOR]
	--		======================================
	FROM	DOCUMENTO_D0M4, VI_UNIDAD_OPERATIVA_CATALOGOS,
			DATA_N1_X_DI_D0M4, DATO_D0M4, UNIDAD_DATO_D0M4,
			FORMATO_D0M4, NIVEL_DETALLE, DEFINICION_D0M4
	--		======================================
	WHERE	DOCUMENTO_D0M4.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
	AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=DATA_N1_X_DI_D0M4.K_DOCUMENTO_D0M4
	AND		DATA_N1_X_DI_D0M4.K_DATO_D0M4=DATO_D0M4.K_DATO_D0M4
	AND		DATO_D0M4.K_UNIDAD_DATO_D0M4=UNIDAD_DATO_D0M4.K_UNIDAD_DATO_D0M4
	--		======================================
	AND		DOCUMENTO_D0M4.K_FORMATO_D0M4=FORMATO_D0M4.K_FORMATO_D0M4
	AND		FORMATO_D0M4.K_NIVEL_DETALLE=NIVEL_DETALLE.K_NIVEL_DETALLE
	AND		FORMATO_D0M4.K_FORMATO_D0M4=DEFINICION_D0M4.K_FORMATO_D0M4
	AND		DEFINICION_D0M4.K_DATO_D0M4=DATA_N1_X_DI_D0M4.K_DATO_D0M4
	--		======================================
	AND		(	D_DATO_D0M4					LIKE '%'+@PP_BUSCAR+'%'	
			OR	D_ZONA_UO					LIKE '%'+@PP_BUSCAR+'%'
			OR	D_RAZON_SOCIAL				LIKE '%'+@PP_BUSCAR+'%'
			OR	D_UNIDAD_OPERATIVA			LIKE '%'+@PP_BUSCAR+'%'		)
	--		======================================
	AND		( @PP_K_ZONA_UO=-1				OR	@PP_K_ZONA_UO=VI_K_ZONA_UO )
	AND		( @PP_K_RAZON_SOCIAL=-1			OR	@PP_K_RAZON_SOCIAL=VI_K_RAZON_SOCIAL )
	AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR	@PP_K_UNIDAD_OPERATIVA=VI_K_UNIDAD_OPERATIVA )
	--		======================================
	AND		( @PP_K_FORMATO_D0M4=-1		OR	DOCUMENTO_D0M4.K_FORMATO_D0M4=@PP_K_FORMATO_D0M4 )
	AND		( @PP_K_TIEMPO_YYYY=-1		OR	DOCUMENTO_D0M4.K_YYYY=@PP_K_TIEMPO_YYYY )
	AND		( @PP_K_TIEMPO_MES=-1		OR	DOCUMENTO_D0M4.K_MM=@PP_K_TIEMPO_MES )
	AND		( @PP_K_DATO_D0M4=-1		OR	DATA_N1_X_DI_D0M4.K_DATO_D0M4=@PP_K_DATO_D0M4 )
	AND		( @PP_L_PARAMETRICAS=1		OR	DEFINICION_D0M4.L_VISIBLE=1 )
	--		======================================
	ORDER BY	S_ZONA_UO,
				D_UNIDAD_OPERATIVA,
				O_FORMATO_D0M4,
				DOCUMENTO_D0M4.K_YYYY, 		
				DOCUMENTO_D0M4.K_MM,
				DOCUMENTO_D0M4.K_DOCUMENTO_D0M4,
				DEFINICION_D0M4.O_DEFINICION_D0M4

	-- //////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_DATA_N1_X_DI_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_DATA_N1_X_DI_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_UP_DATA_N1_X_DI_D0M4]
-- HGF // 20180412 // CREATE PROCEDURE [dbo].[PG_UP_DATA_N1_X_DI_D0M4_VALOR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4				INT,
	-- ==============================
	@PP_D01_VALOR			DECIMAL(19,4),
	@PP_D02_VALOR			DECIMAL(19,4),
	@PP_D03_VALOR			DECIMAL(19,4),
	@PP_D04_VALOR			DECIMAL(19,4),
	@PP_D05_VALOR			DECIMAL(19,4),
	@PP_D06_VALOR			DECIMAL(19,4),
	@PP_D07_VALOR			DECIMAL(19,4),
	@PP_D08_VALOR			DECIMAL(19,4),
	@PP_D09_VALOR			DECIMAL(19,4),
	@PP_D10_VALOR			DECIMAL(19,4),
	-- ==============================
	@PP_D11_VALOR			DECIMAL(19,4),
	@PP_D12_VALOR			DECIMAL(19,4),
	@PP_D13_VALOR			DECIMAL(19,4),
	@PP_D14_VALOR			DECIMAL(19,4),
	@PP_D15_VALOR			DECIMAL(19,4),
	@PP_D16_VALOR			DECIMAL(19,4),
	@PP_D17_VALOR			DECIMAL(19,4),
	@PP_D18_VALOR			DECIMAL(19,4),
	@PP_D19_VALOR			DECIMAL(19,4),
	@PP_D20_VALOR			DECIMAL(19,4),
	-- ==============================
	@PP_D21_VALOR			DECIMAL(19,4),
	@PP_D22_VALOR			DECIMAL(19,4),
	@PP_D23_VALOR			DECIMAL(19,4),
	@PP_D24_VALOR			DECIMAL(19,4),
	@PP_D25_VALOR			DECIMAL(19,4),
	@PP_D26_VALOR			DECIMAL(19,4),
	@PP_D27_VALOR			DECIMAL(19,4),
	@PP_D28_VALOR			DECIMAL(19,4),
	@PP_D29_VALOR			DECIMAL(19,4),
	@PP_D30_VALOR			DECIMAL(19,4),
	-- ==============================
	@PP_D31_VALOR			DECIMAL(19,4)
AS
		
	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
	
/*	WIWI // IMPLEMENTAR REGLAS DE NEGOCIO
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_N1_X_DI_D0M4_]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_DOCUMENTO_D0M4, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
*/
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
		
--		DELETE
--		FROM	DATA_N1_X_DI_D0M4
--		WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

-- SELECT * FROM		[dbo].[DATA_N1_X_DI_D0M4]

		-- ===============================
		-- WIWI // HGF // 20180324 // VALIDAR ACTUALIZACION
		UPDATE	[dbo].[DATA_N1_X_DI_D0M4]
		SET		
				D01_VALOR = @PP_D01_VALOR,
				D02_VALOR = @PP_D02_VALOR,
				D03_VALOR = @PP_D03_VALOR,
				D04_VALOR = @PP_D04_VALOR,
				D05_VALOR = @PP_D05_VALOR,
				D06_VALOR = @PP_D06_VALOR,
				D07_VALOR = @PP_D07_VALOR,
				D08_VALOR = @PP_D08_VALOR,
				D09_VALOR = @PP_D09_VALOR,
				D10_VALOR = @PP_D10_VALOR,
				-- ====== = ===
				D11_VALOR = @PP_D11_VALOR,
				D12_VALOR = @PP_D12_VALOR,
				D13_VALOR = @PP_D13_VALOR,
				D14_VALOR = @PP_D14_VALOR,
				D15_VALOR = @PP_D15_VALOR,
				D16_VALOR = @PP_D16_VALOR,
				D17_VALOR = @PP_D17_VALOR,
				D18_VALOR = @PP_D18_VALOR,
				D19_VALOR = @PP_D19_VALOR,
				D20_VALOR = @PP_D20_VALOR,
				-- ====== = ===
				D21_VALOR = @PP_D21_VALOR,
				D22_VALOR = @PP_D22_VALOR,
				D23_VALOR = @PP_D23_VALOR,
				D24_VALOR = @PP_D24_VALOR,
				D25_VALOR = @PP_D25_VALOR,
				D26_VALOR = @PP_D26_VALOR,
				D27_VALOR = @PP_D27_VALOR,
				D28_VALOR = @PP_D28_VALOR,
				D29_VALOR = @PP_D29_VALOR,
				D30_VALOR = @PP_D30_VALOR,
				-- ==============================
				D31_VALOR= @PP_D31_VALOR			
		WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		AND		K_DATO_D0M4=@PP_K_DATO_D0M4

		-- ==============================

		EXECUTE	[dbo].[PG_UP_DOCUMENTO_D0M4_L_RECALCULAR]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4
/*		
		-- WIWI // HGF 20180903 // ESTAS FUNCIONES SON DE NIVEL SUPERIOR // DEBEN ESTAR FUERA.
		EXECUTE [dbo].[PG_OP_DATA_N1_101_COMPROMISO_RECALCULAR]     @PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_DOCUMENTO_D0M4

		EXECUTE [dbo].[PG_OP_DATA_N1_103_FLUJO_PROYECTADO_RECALCULAR]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_DOCUMENTO_D0M4
*/
		EXECUTE	[dbo].[PG_TR_DOCUMENTO_D0M4_ESTATUS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4, 2		-- K_ESTATUS_DOCUMENTO_D0M4	// #2 WORKING
			
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [Documento/DataN1]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Do.'+CONVERT(VARCHAR(10),@PP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO





-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_DATA_N1_X_DI_D0M4_X_K_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_DATA_N1_X_DI_D0M4_X_K_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_LI_DATA_N1_X_DI_D0M4_X_K_DOCUMENTO_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS
	-- ==============================================
	
	SELECT	
			S_FORMATO_D0M4,
			DOCUMENTO_D0M4.C_DOCUMENTO_D0M4,
			DOCUMENTO_D0M4.K_YYYY	AS D_YYYY, 		
			DOCUMENTO_D0M4.K_MM		AS D_MM,
			' /// ',
			DATO_D0M4.K_DATO_D0M4,
			D_DATO_D0M4, S_UNIDAD_DATO_D0M4, L_VISIBLE,
			' /// ',
			[VALOR_ACUMULADO],
			[D00_VALOR], [DXX_VALOR], [DYY_VALOR], [DZZ_VALOR],
			[D01_VALOR], [D02_VALOR], [D03_VALOR], [D04_VALOR], [D05_VALOR], [D06_VALOR], [D07_VALOR], [D08_VALOR], [D09_VALOR], [D10_VALOR],
			[D11_VALOR], [D12_VALOR], [D13_VALOR], [D14_VALOR], [D15_VALOR], [D16_VALOR], [D17_VALOR], [D18_VALOR], [D19_VALOR], [D20_VALOR], 
			[D21_VALOR], [D22_VALOR], [D23_VALOR], [D24_VALOR], [D25_VALOR], [D26_VALOR], [D27_VALOR], [D28_VALOR], [D29_VALOR], [D30_VALOR], 
			[D31_VALOR]
	--		DATA_N1_X_DI_D0M4.*
	--		D_FORMATO_D0M4, D_NIVEL_DETALLE,
	--		FORMATO_D0M4.K_FORMATO_D0M4,
	--		DATO_D0M4.K_DATO_D0M4 
	FROM	DOCUMENTO_D0M4, DATA_N1_X_DI_D0M4, DATO_D0M4, UNIDAD_DATO_D0M4,
			FORMATO_D0M4, NIVEL_DETALLE, DEFINICION_D0M4
	WHERE	( @PP_K_DOCUMENTO_D0M4=-1	OR	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4 )
	AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=DATA_N1_X_DI_D0M4.K_DOCUMENTO_D0M4
	AND		DATA_N1_X_DI_D0M4.K_DATO_D0M4=DATO_D0M4.K_DATO_D0M4
	AND		DATO_D0M4.K_UNIDAD_DATO_D0M4=UNIDAD_DATO_D0M4.K_UNIDAD_DATO_D0M4

	AND		DOCUMENTO_D0M4.K_FORMATO_D0M4=FORMATO_D0M4.K_FORMATO_D0M4
	AND		FORMATO_D0M4.K_NIVEL_DETALLE=NIVEL_DETALLE.K_NIVEL_DETALLE
	AND		FORMATO_D0M4.K_FORMATO_D0M4=DEFINICION_D0M4.K_FORMATO_D0M4
	AND		DEFINICION_D0M4.K_DATO_D0M4=DATA_N1_X_DI_D0M4.K_DATO_D0M4
	ORDER BY DOCUMENTO_D0M4.K_DOCUMENTO_D0M4,
			 O_FORMATO_D0M4, DEFINICION_D0M4.O_DEFINICION_D0M4

	-- //////////////////////////////////////////////////////////////
GO





-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_DATA_N1_X_DI_D0M4_X_K_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_DATA_N1_X_DI_D0M4_X_K_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_IN_DATA_N1_X_DI_D0M4_X_K_DOCUMENTO_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_L_RESPUESTA				INT,
	-- ===========================	
	@PP_K_DOCUMENTO_D0M4		INT
AS
	-- ==============================================
	
	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
	
/*	WIWI // IMPLEMENTAR REGLAS DE NEGOCIO
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_N1_X_DI_D0M4_]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_DOCUMENTO_D0M4, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
*/
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
		
		EXECUTE [dbo].[PG_DL_DATA_N1_X_K_DOCUMENTO_D0M4]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4
		-- ===============================

		DECLARE @VP_K_FORMATO_D0M4			INT
				
		SELECT	@VP_K_FORMATO_D0M4 =		K_FORMATO_D0M4
											FROM	DOCUMENTO_D0M4
											WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		-- ===============================

		INSERT INTO DATA_N1_X_DI_D0M4
				(	K_DOCUMENTO_D0M4,			K_DATO_D0M4		)	
			SELECT	@PP_K_DOCUMENTO_D0M4,		K_DATO_D0M4
				--	@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				--	0, NULL, NULL )
			FROM	FORMATO_D0M4, DEFINICION_D0M4 
			WHERE	FORMATO_D0M4.K_FORMATO_D0M4=@VP_K_FORMATO_D0M4
			AND		FORMATO_D0M4.K_FORMATO_D0M4=DEFINICION_D0M4.K_FORMATO_D0M4
		
		-- ===============================

		EXECUTE	[dbo].[PG_TR_DOCUMENTO_D0M4_ESTATUS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4, 2		-- K_ESTATUS_DOCUMENTO_D0M4	// #2 WORKING
																				
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [Documento/DataN1]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Do.'+CONVERT(VARCHAR(10),@PP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_RESPUESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO



-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
