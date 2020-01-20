-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CONTROL OPERACION / <RAZON_SOCIAL>
-- // OPERACION:		LIBERACION / STORED PROCEDURES
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	02/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////
-- [PG_LI_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 0,0,0,0

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL]
GO


CREATE PROCEDURE [dbo].[PG_LI_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_BUSCAR					VARCHAR(255),
	@PP_K_YYYY					INT,
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_ESTATUS_RAZON_SOCIAL	INT,
	@PP_K_REGION				INT
AS
	
	DECLARE @PP_C_CUENTA_BANCO			VARCHAR(255) = ''

	DECLARE @VP_MENSAJE		VARCHAR(300)
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT = 1
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_LI_N_REGISTROS		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_LI_N_REGISTROS		OUTPUT		
	-- =========================================		

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	-- =========================================		

	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]		@PP_C_CUENTA_BANCO, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	SELECT	TOP ( @VP_LI_N_REGISTROS )
			[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL].*,
			[D_RAZON_SOCIAL], [D_REGION], [D_ESTATUS_RAZON_SOCIAL],
			[S_RAZON_SOCIAL], [S_REGION], [S_ESTATUS_RAZON_SOCIAL]
			-- =====================
	FROM	[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL], [RAZON_SOCIAL],
			[REGION], [ESTATUS_RAZON_SOCIAL]
			-- =====================
	WHERE	[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL].[K_RAZON_SOCIAL]=[RAZON_SOCIAL].[K_RAZON_SOCIAL]
	AND		[RAZON_SOCIAL].[K_REGION]=[REGION].[K_REGION]
	AND		[RAZON_SOCIAL].[K_ESTATUS_RAZON_SOCIAL]=[ESTATUS_RAZON_SOCIAL].[K_ESTATUS_RAZON_SOCIAL]
			-- =====================
	AND		(	D_RAZON_SOCIAL	LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_REGION		LIKE '%'+@PP_BUSCAR+'%' 
			OR	RAZON_SOCIAL.K_RAZON_SOCIAL=@VP_K_FOLIO 		)	
			-- =====================
	AND		( @PP_K_YYYY=-1				OR		MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL.K_YYYY<=@PP_K_YYYY )
	AND		( @PP_K_RAZON_SOCIAL=-1		OR		MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL )
	AND		( @PP_K_ESTATUS_RAZON_SOCIAL=-1		OR		[RAZON_SOCIAL].K_ESTATUS_RAZON_SOCIAL=@PP_K_ESTATUS_RAZON_SOCIAL )
	AND		( @PP_K_REGION=-1					OR		[RAZON_SOCIAL].K_REGION=@PP_K_REGION )
			-- =====================		
	ORDER BY K_YYYY DESC, D_RAZON_SOCIAL

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_C_CUENTA_BANCO, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_CUENTA_BANCO', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////
-- [PG_LI_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 0,0,0,0

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL]
GO


CREATE PROCEDURE [dbo].[PG_IN_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_YYYY					INT,
	@PP_K_RAZON_SOCIAL			INT	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
/*	
	DECLARE @VP_K_LIBRO_INGRESOS				INT = 0
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_LIBRO_INGRESOS_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_LIBRO_INGRESOS,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
*/
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		DECLARE @VP_EXISTE		INT
	
		SELECT	@VP_EXISTE =	[K_YYYY]	
								FROM	[dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
								WHERE	[K_YYYY]=@PP_K_YYYY
								AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL

		-- ==============================

		IF @VP_EXISTE IS NULL
			INSERT INTO  [dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
				( [K_YYYY], 	 [K_RAZON_SOCIAL]	)
			VALUES
				( @PP_K_YYYY,	 @PP_K_RAZON_SOCIAL	)

		-- ========================================

		EXECUTE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	 01,	 @PP_K_RAZON_SOCIAL

		EXECUTE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	 02,	 @PP_K_RAZON_SOCIAL

		EXECUTE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	 03,	 @PP_K_RAZON_SOCIAL

		EXECUTE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	 04,	 @PP_K_RAZON_SOCIAL

		EXECUTE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	 05,	 @PP_K_RAZON_SOCIAL

		EXECUTE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	 06,	 @PP_K_RAZON_SOCIAL

		EXECUTE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	 07,	 @PP_K_RAZON_SOCIAL

		EXECUTE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	 08,	 @PP_K_RAZON_SOCIAL

		EXECUTE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	 09,	 @PP_K_RAZON_SOCIAL

		EXECUTE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	 10,	 @PP_K_RAZON_SOCIAL

		EXECUTE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	 11,	 @PP_K_RAZON_SOCIAL

		EXECUTE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	 12,	 @PP_K_RAZON_SOCIAL
			
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [MatrizControlxMes]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#MxM.'+CONVERT(VARCHAR(10),@PP_K_YYYY)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_YYYY AS CLAVE
	
	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_YYYY, @PP_K_RAZON_SOCIAL, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, '@PP_C_LIBRO_INGRESOS', '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_LIBRO_INGRESOS', '', '', ''

	-- //////////////////////////////////////////////////////////////
	
GO



-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
