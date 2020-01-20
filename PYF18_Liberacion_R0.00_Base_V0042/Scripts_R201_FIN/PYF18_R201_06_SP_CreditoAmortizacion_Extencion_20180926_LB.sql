-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / STORED PROCEDURES
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APG_SK_CREDITO_BANCARIO_AMORTIZACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[APG_SK_CREDITO_BANCARIO_AMORTIZACION]
GO


CREATE PROCEDURE [dbo].[APG_SK_CREDITO_BANCARIO_AMORTIZACION]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_CREDITO_BANCARIO	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
			SELECT 	CREDITO_BANCARIO.*		
			-- =====================
			FROM	CREDITO_BANCARIO
					-- =====================
			WHERE	CREDITO_BANCARIO.K_CREDITO_BANCARIO=@PP_K_CREDITO_BANCARIO 

		END
	ELSE
		BEGIN	-- ESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

			SELECT 	CREDITO_BANCARIO.*		
			-- =====================
			FROM	CREDITO_BANCARIO
					-- =====================
			WHERE	CREDITO_BANCARIO.K_CREDITO_BANCARIO=@PP_K_CREDITO_BANCARIO 
			AND		CREDITO_BANCARIO.K_CREDITO_BANCARIO<0

		END

	-----////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_CREDITO_BANCARIO_AMORTIZACION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CREDITO_BANCARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_LI_CREDITO_BANCARIO_AMORTIZACION]		0,0,0,		29


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APG_LI_TABLA_AMORTIZACION_X_K_CREDITO_BANCARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[APG_LI_TABLA_AMORTIZACION_X_K_CREDITO_BANCARIO]
GO


CREATE PROCEDURE [dbo].[APG_LI_TABLA_AMORTIZACION_X_K_CREDITO_BANCARIO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_CREDITO_BANCARIO	INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300)
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT = 1
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_INT_NUMERO_REGISTROS	INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT	
	-- =========================================		
		
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	IF @VP_MENSAJE=''
		BEGIN
			SELECT	TOP(@VP_INT_NUMERO_REGISTROS) 
					TABLA_AMORTIZACION.* ,CREDITO_BANCARIO.*,	R1.D_RAZON_SOCIAL,R2.D_RAZON_SOCIAL, GRUPO_CREDITO.D_GRUPO_CREDITO,
					ESTATUS_TABLA_AMORTIZACION.D_ESTATUS_TABLA_AMORTIZACION,BANCO.D_BANCO,MONEDA.D_MONEDA,
					D_USUARIO AS D_USUARIO_CAMBIO		
					-- =====================
			FROM	TABLA_AMORTIZACION, CREDITO_BANCARIO,RAZON_SOCIAL R1, RAZON_SOCIAL R2, GRUPO_CREDITO, ESTATUS_TABLA_AMORTIZACION,
					BANCO,MONEDA, USUARIO
					-- =====================
			WHERE	(	CREDITO_BANCARIO.L_BORRADO=0		OR		@VP_L_VER_BORRADOS=1	)
					-- =====================
			AND		TABLA_AMORTIZACION.K_CREDITO_BANCARIO=CREDITO_BANCARIO.K_CREDITO_BANCARIO
			AND		TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION=ESTATUS_TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION
			AND		CREDITO_BANCARIO.K_RAZON_SOCIAL_ACREDITADA=R1.K_RAZON_SOCIAL
			AND		CREDITO_BANCARIO.K_RAZON_SOCIAL_BENEFICIADA=R2.K_RAZON_SOCIAL			
			AND		CREDITO_BANCARIO.K_GRUPO_CREDITO=GRUPO_CREDITO.K_GRUPO_CREDITO
			AND		CREDITO_BANCARIO.K_BANCO=BANCO.K_BANCO	
			AND		CREDITO_BANCARIO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			AND		CREDITO_BANCARIO.K_MONEDA=MONEDA.K_MONEDA
			AND		CREDITO_BANCARIO.K_CREDITO_BANCARIO=@PP_K_CREDITO_BANCARIO	
		--	ORDER BY D_CREDITO_BANCARIO
			ORDER BY N_PERIODO ASC
		END
	ELSE
		BEGIN
			SELECT	TABLA_AMORTIZACION.* ,CREDITO_BANCARIO.*,	R1.D_RAZON_SOCIAL,R2.D_RAZON_SOCIAL, GRUPO_CREDITO.D_GRUPO_CREDITO,
					ESTATUS_TABLA_AMORTIZACION.D_ESTATUS_TABLA_AMORTIZACION,BANCO.D_BANCO,MONEDA.D_MONEDA,
					D_USUARIO AS D_USUARIO_CAMBIO		
					-- =====================
			FROM	TABLA_AMORTIZACION, CREDITO_BANCARIO,RAZON_SOCIAL R1, RAZON_SOCIAL R2, GRUPO_CREDITO, ESTATUS_TABLA_AMORTIZACION,
					BANCO,MONEDA, USUARIO
					-- =====================
			WHERE	(	CREDITO_BANCARIO.L_BORRADO=0		OR		@VP_L_VER_BORRADOS=1	)
					-- =====================
			AND		TABLA_AMORTIZACION.K_CREDITO_BANCARIO=CREDITO_BANCARIO.K_CREDITO_BANCARIO
			AND		TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION=ESTATUS_TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION
			AND		CREDITO_BANCARIO.K_RAZON_SOCIAL_ACREDITADA=R1.K_RAZON_SOCIAL
			AND		CREDITO_BANCARIO.K_RAZON_SOCIAL_BENEFICIADA=R2.K_RAZON_SOCIAL			
			AND		CREDITO_BANCARIO.K_GRUPO_CREDITO=GRUPO_CREDITO.K_GRUPO_CREDITO
			AND		CREDITO_BANCARIO.K_BANCO=BANCO.K_BANCO	
			AND		CREDITO_BANCARIO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			AND		CREDITO_BANCARIO.K_MONEDA=MONEDA.K_MONEDA
						-- =====================
				AND		TABLA_AMORTIZACION.K_TABLA_AMORTIZACION<0
		END

		
	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_TABLA_AMORTIZACION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_CREDITO_BANCARIO, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_TABLA_AMORTIZACION', '', '', ''

														
	-- /////////////////////////////////////////////////////////////////////
	
	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_CREDITO_AMORTIZACION_SIMULACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_CREDITO_AMORTIZACION_SIMULACION]
GO

CREATE PROCEDURE [dbo].[PG_OP_CREDITO_AMORTIZACION_SIMULACION]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	
	@PP_L_CONTESTA						INT,
	
	@PP_K_CREDITO_BANCARIO				INT,	
	@PP_K_TIPO_CALCULO_CREDITO			INT,
	@PP_MONTO_PRESTAMO					DECIMAL(19, 4),
	@PP_TASA_INTERES_ANUAL				FLOAT,
	@PP_CANTIDAD_PERIODOS				INT,
	@PP_F_INICIO						DATE
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CREDITO_BANCARIO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_CREDITO_BANCARIO, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

        DECLARE @VP_TASA_INTERES_ANUAL		FLOAT

        SET		@VP_TASA_INTERES_ANUAL = ( @PP_TASA_INTERES_ANUAL / 100 )

		-- ========================================

		UPDATE	CREDITO_BANCARIO
		SET						
				[K_TIPO_CALCULO_CREDITO]		= @PP_K_TIPO_CALCULO_CREDITO,
				[MONTO_PRESTAMO]				= @PP_MONTO_PRESTAMO,
				[TASA_INTERES_ANUAL]			= @VP_TASA_INTERES_ANUAL,
				[CANTIDAD_PERIODOS]				= @PP_CANTIDAD_PERIODOS,
				[F_INICIO]						= @PP_F_INICIO,
				-- ===========================
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION, 
				[F_CAMBIO]					= GETDATE() 
		WHERE	K_CREDITO_BANCARIO=@PP_K_CREDITO_BANCARIO

		-- ==================================================

		EXECUTE [DBO].[PG_DL_TABLA_AMORTIZACION_X_K_CREDITO_BANCARIO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_CREDITO_BANCARIO 
		-- ==================================================

		EXECUTE [DBO].[PG_OP_TABLA_AMORTIZACION_GENERAR]				@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_L_CONTESTA,
																		@PP_K_CREDITO_BANCARIO 
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [CREDITO/AMORTIZACION]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Cb.'+CONVERT(VARCHAR(10),@PP_K_CREDITO_BANCARIO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CREDITO_BANCARIO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_OP_CREDITO_AMORTIZACION_SIMULACION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CREDITO_BANCARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_CREDITO_BANCARIO, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_CREDITO_BANCARIO', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APG_SK_CREDITO_BANCARIO_ESTADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[APG_SK_CREDITO_BANCARIO_ESTADO]
GO


CREATE PROCEDURE [dbo].[APG_SK_CREDITO_BANCARIO_ESTADO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_CREDITO_BANCARIO	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
			SELECT 	CREDITO_BANCARIO.*		
			-- =====================
			FROM	CREDITO_BANCARIO
					-- =====================
			WHERE	CREDITO_BANCARIO.K_CREDITO_BANCARIO=@PP_K_CREDITO_BANCARIO 

		END
	ELSE
		BEGIN	-- ESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

			SELECT 	CREDITO_BANCARIO.*		
			-- =====================
			FROM	CREDITO_BANCARIO
					-- =====================
			WHERE	CREDITO_BANCARIO.K_CREDITO_BANCARIO=@PP_K_CREDITO_BANCARIO 
			AND		CREDITO_BANCARIO.K_CREDITO_BANCARIO<0

		END

	-----////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_CREDITO_BANCARIO_AMORTIZACION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CREDITO_BANCARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_LI_CREDITO_BANCARIO_AMORTIZACION]		0,0,0,		29


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APG_LI_CREDITO_BANCARIO_ESTADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[APG_LI_CREDITO_BANCARIO_ESTADO]
GO


CREATE PROCEDURE [dbo].[APG_LI_CREDITO_BANCARIO_ESTADO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_CREDITO_BANCARIO	INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300)
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT = 1
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_INT_NUMERO_REGISTROS	INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT	
	-- =========================================		
		
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	IF @VP_MENSAJE=''
		BEGIN
			SELECT	TOP(@VP_INT_NUMERO_REGISTROS)
					TABLA_AMORTIZACION.* ,CREDITO_BANCARIO.*,	R1.D_RAZON_SOCIAL,R2.D_RAZON_SOCIAL, GRUPO_CREDITO.D_GRUPO_CREDITO,
					ESTATUS_TABLA_AMORTIZACION.D_ESTATUS_TABLA_AMORTIZACION,BANCO.D_BANCO,MONEDA.D_MONEDA,
					D_USUARIO AS D_USUARIO_CAMBIO			
					-- =====================
			FROM	TABLA_AMORTIZACION, CREDITO_BANCARIO,RAZON_SOCIAL R1, RAZON_SOCIAL R2, GRUPO_CREDITO, ESTATUS_TABLA_AMORTIZACION,
					BANCO,MONEDA, USUARIO
					-- =====================
			WHERE	(	CREDITO_BANCARIO.L_BORRADO=0		OR		@VP_L_VER_BORRADOS=1	)
					-- =====================
			AND		TABLA_AMORTIZACION.K_CREDITO_BANCARIO=CREDITO_BANCARIO.K_CREDITO_BANCARIO
			AND		TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION=ESTATUS_TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION
			AND		CREDITO_BANCARIO.K_RAZON_SOCIAL_ACREDITADA=R1.K_RAZON_SOCIAL
			AND		CREDITO_BANCARIO.K_RAZON_SOCIAL_BENEFICIADA=R2.K_RAZON_SOCIAL			
			AND		CREDITO_BANCARIO.K_GRUPO_CREDITO=GRUPO_CREDITO.K_GRUPO_CREDITO
			AND		CREDITO_BANCARIO.K_BANCO=BANCO.K_BANCO	
			AND		CREDITO_BANCARIO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			AND		CREDITO_BANCARIO.K_MONEDA=MONEDA.K_MONEDA
			AND		CREDITO_BANCARIO.K_CREDITO_BANCARIO=@PP_K_CREDITO_BANCARIO	
		--	ORDER BY D_CREDITO_BANCARIO
			ORDER BY N_PERIODO ASC
		END
	ELSE
		BEGIN
			SELECT	TABLA_AMORTIZACION.* ,CREDITO_BANCARIO.*,	R1.D_RAZON_SOCIAL,R2.D_RAZON_SOCIAL, GRUPO_CREDITO.D_GRUPO_CREDITO,
					ESTATUS_TABLA_AMORTIZACION.D_ESTATUS_TABLA_AMORTIZACION,BANCO.D_BANCO,MONEDA.D_MONEDA,
					D_USUARIO AS D_USUARIO_CAMBIO			
					-- =====================
			FROM	TABLA_AMORTIZACION, CREDITO_BANCARIO,RAZON_SOCIAL R1, RAZON_SOCIAL R2, GRUPO_CREDITO, ESTATUS_TABLA_AMORTIZACION,
					BANCO,MONEDA, USUARIO
					-- =====================
			WHERE	(	CREDITO_BANCARIO.L_BORRADO=0		OR		@VP_L_VER_BORRADOS=1	)
					-- =====================
			AND		TABLA_AMORTIZACION.K_CREDITO_BANCARIO=CREDITO_BANCARIO.K_CREDITO_BANCARIO
			AND		TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION=ESTATUS_TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION
			AND		CREDITO_BANCARIO.K_RAZON_SOCIAL_ACREDITADA=R1.K_RAZON_SOCIAL
			AND		CREDITO_BANCARIO.K_RAZON_SOCIAL_BENEFICIADA=R2.K_RAZON_SOCIAL			
			AND		CREDITO_BANCARIO.K_GRUPO_CREDITO=GRUPO_CREDITO.K_GRUPO_CREDITO
			AND		CREDITO_BANCARIO.K_BANCO=BANCO.K_BANCO	
			AND		CREDITO_BANCARIO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			AND		CREDITO_BANCARIO.K_MONEDA=MONEDA.K_MONEDA
						-- =====================
			AND		TABLA_AMORTIZACION.K_TABLA_AMORTIZACION<0
		END

		
	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_TABLA_AMORTIZACION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_CREDITO_BANCARIO, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_TABLA_AMORTIZACION', '', '', ''

														
	-- /////////////////////////////////////////////////////////////////////
	
	-- /////////////////////////////////////////////////////////////////////
GO





-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
