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






-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_DATA_N3_X_K_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_DATA_N3_X_K_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_DL_DATA_N3_X_K_DOCUMENTO_D0M4]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4			INT
	-- ===========================
AS		

	DELETE 
	FROM	DATA_N3_X_ME_D0M4
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	-- ////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_DATA_N3_X_ME_D0M4_X_K_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_DATA_N3_X_ME_D0M4_X_K_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_IN_DATA_N3_X_ME_D0M4_X_K_DOCUMENTO_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS
	-- ==============================================
	
	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
	
/*	WIWI // IMPLEMENTAR REGLAS DE NEGOCIO
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_N3_X_ME_D0M4_]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_DOCUMENTO_D0M4, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
*/
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
		
		EXECUTE [dbo].[PG_DL_DATA_N3_X_K_DOCUMENTO_D0M4]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4														
		-- ===============================

		DECLARE @VP_K_FORMATO_D0M4			INT
				
		SELECT	@VP_K_FORMATO_D0M4 =		K_FORMATO_D0M4
											FROM	DOCUMENTO_D0M4
											WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		-- ===============================

		INSERT INTO DATA_N3_X_ME_D0M4
				(	K_DOCUMENTO_D0M4,			K_DATO_D0M4		)	
			SELECT	@PP_K_DOCUMENTO_D0M4,		K_DATO_D0M4
				--	@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				--	0, NULL, NULL )
			FROM	FORMATO_D0M4, DEFINICION_D0M4 
			WHERE	FORMATO_D0M4.K_FORMATO_D0M4=@VP_K_FORMATO_D0M4
			AND		FORMATO_D0M4.K_FORMATO_D0M4=DEFINICION_D0M4.K_FORMATO_D0M4
			
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



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_DATA_N3_X_ME_D0M4_X_K_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_DATA_N3_X_ME_D0M4_X_K_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_LI_DATA_N3_X_ME_D0M4_X_K_DOCUMENTO_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS
	-- ==============================================
	
	SELECT	
			DATO_D0M4.K_DATO_D0M4,
			D_DATO_D0M4, S_UNIDAD_DATO_D0M4, L_VISIBLE,
			' /// ',
			[VALOR_ACUMULADO],
			[M01_VALOR], [M02_VALOR], [M03_VALOR], [M04_VALOR], [M05_VALOR], [M06_VALOR], 
			[M07_VALOR], [M08_VALOR], [M09_VALOR], [M10_VALOR], [M11_VALOR], [M12_VALOR]
	--		DATA_N3_X_ME_D0M4.*
	--		D_FORMATO_D0M4, D_NIVEL_DETALLE,
	--		FORMATO_D0M4.K_FORMATO_D0M4,
	--		DATO_D0M4.K_DATO_D0M4 
	FROM	DOCUMENTO_D0M4, DATA_N3_X_ME_D0M4, DATO_D0M4, UNIDAD_DATO_D0M4,
			FORMATO_D0M4, NIVEL_DETALLE, DEFINICION_D0M4
	WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=DATA_N3_X_ME_D0M4.K_DOCUMENTO_D0M4
	AND		DATA_N3_X_ME_D0M4.K_DATO_D0M4=DATO_D0M4.K_DATO_D0M4
	AND		DATO_D0M4.K_UNIDAD_DATO_D0M4=UNIDAD_DATO_D0M4.K_UNIDAD_DATO_D0M4

	AND		DOCUMENTO_D0M4.K_FORMATO_D0M4=FORMATO_D0M4.K_FORMATO_D0M4
	AND		FORMATO_D0M4.K_NIVEL_DETALLE=NIVEL_DETALLE.K_NIVEL_DETALLE
	AND		FORMATO_D0M4.K_FORMATO_D0M4=DEFINICION_D0M4.K_FORMATO_D0M4
	AND		DEFINICION_D0M4.K_DATO_D0M4=DATA_N3_X_ME_D0M4.K_DATO_D0M4
	/*
	AND		DEFINICION_D0M4.K_DATO_D0M4=DATO_D0M4.K_DATO_D0M4
	*/
	ORDER BY O_FORMATO_D0M4, DEFINICION_D0M4.O_DEFINICION_D0M4

	-- //////////////////////////////////////////////////////////////
GO


-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
