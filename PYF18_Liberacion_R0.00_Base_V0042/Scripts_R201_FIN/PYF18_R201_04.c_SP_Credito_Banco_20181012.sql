-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			CREDITO_BANCARIO
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			Alex de la Rosa   --LBG
-- // Fecha creación:	10/09/18		  --19/09/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO


-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_CREDITO_BANCARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_CREDITO_BANCARIO]
GO


CREATE PROCEDURE [dbo].[PG_LI_CREDITO_BANCARIO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ==============================================	
	@PP_BUSCAR							VARCHAR(200),
	@PP_K_RAZON_SOCIAL_ACREDITADA		INT,
	@PP_K_RAZON_SOCIAL_BENEFICIADA		INT,
	@PP_K_GRUPO_CREDITO					INT,
	@PP_K_MOTIVO_CREDITO_BANCARIO		INT,
	@PP_K_TIPO_CREDITO_BANCARIO			INT,
	@PP_K_BANCO							INT,
	@PP_K_MONEDA						INT,
	@PP_K_ESTATUS_CREDITO_BANCARIO		INT
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

	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]		@PP_BUSCAR, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0

	SELECT	TOP(@VP_INT_NUMERO_REGISTROS)
			CREDITO_BANCARIO.*, D_USUARIO AS D_USUARIO_CAMBIO,	
			(CREDITO_BANCARIO.TASA_INTERES_ANUAL * 100)	AS TASA_INTERES_ANUAL_0_100,
			CUENTA, CLABE,
			-- =====================					
			D_GRUPO_CREDITO, D_TIPO_CREDITO_BANCARIO, D_MOTIVO_CREDITO_BANCARIO, D_BANCO, D_MONEDA, D_CUENTA_BANCO, D_ESTATUS_CREDITO_BANCARIO, D_TIPO_CALCULO_CREDITO,
			S_GRUPO_CREDITO, S_TIPO_CREDITO_BANCARIO, S_MOTIVO_CREDITO_BANCARIO, S_BANCO, S_MONEDA, S_CUENTA_BANCO, S_ESTATUS_CREDITO_BANCARIO, S_TIPO_CALCULO_CREDITO,
			-- =====================
			R1.D_RAZON_SOCIAL D_ACREDITADA, R2.D_RAZON_SOCIAL D_BENEFICIADA,	
			R1.S_RAZON_SOCIAL S_ACREDITADA, R2.S_RAZON_SOCIAL S_BENEFICIADA	
			-- =====================
	FROM	CREDITO_BANCARIO, USUARIO,
			GRUPO_CREDITO, TIPO_CREDITO_BANCARIO, MOTIVO_CREDITO_BANCARIO,
			BANCO, MONEDA, CUENTA_BANCO, ESTATUS_CREDITO_BANCARIO, TIPO_CALCULO_CREDITO,
			RAZON_SOCIAL R1, RAZON_SOCIAL R2
			-- =====================
	WHERE	(	CREDITO_BANCARIO.L_BORRADO=0		OR		@VP_L_VER_BORRADOS=1	)
			-- =====================
	AND		CREDITO_BANCARIO.K_RAZON_SOCIAL_ACREDITADA=R1.K_RAZON_SOCIAL
	AND		CREDITO_BANCARIO.K_RAZON_SOCIAL_BENEFICIADA=R2.K_RAZON_SOCIAL
	AND		CREDITO_BANCARIO.K_GRUPO_CREDITO=GRUPO_CREDITO.K_GRUPO_CREDITO
	AND		CREDITO_BANCARIO.K_MOTIVO_CREDITO_BANCARIO=MOTIVO_CREDITO_BANCARIO.K_MOTIVO_CREDITO_BANCARIO
	AND		CREDITO_BANCARIO.K_TIPO_CREDITO_BANCARIO=TIPO_CREDITO_BANCARIO.K_TIPO_CREDITO_BANCARIO
	AND		CREDITO_BANCARIO.K_BANCO=BANCO.K_BANCO
	AND		CREDITO_BANCARIO.K_MONEDA=MONEDA.K_MONEDA
	AND		CREDITO_BANCARIO.K_CUENTA_BANCO_PAGO=CUENTA_BANCO.K_CUENTA_BANCO
	AND		CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO=ESTATUS_CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO
	AND		CREDITO_BANCARIO.K_TIPO_CALCULO_CREDITO=TIPO_CALCULO_CREDITO.K_TIPO_CALCULO_CREDITO			
	AND		CREDITO_BANCARIO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- =====================
	AND		(	@PP_BUSCAR='' 
				OR	D_CREDITO_BANCARIO	LIKE '%'+@PP_BUSCAR+'%' 
				OR	R1.D_RAZON_SOCIAL	LIKE '%'+@PP_BUSCAR+'%' 
				OR	R2.D_RAZON_SOCIAL	LIKE '%'+@PP_BUSCAR+'%' 
				OR	GRUPO_CREDITO.D_GRUPO_CREDITO	LIKE '%'+@PP_BUSCAR+'%' 
				OR	MOTIVO_CREDITO_BANCARIO.D_MOTIVO_CREDITO_BANCARIO	LIKE '%'+@PP_BUSCAR+'%'
				OR	TIPO_CREDITO_BANCARIO.D_TIPO_CREDITO_BANCARIO	LIKE '%'+@PP_BUSCAR+'%' 
				OR	BANCO.D_BANCO	LIKE '%'+@PP_BUSCAR+'%' 
				OR	MONEDA.D_MONEDA	LIKE '%'+@PP_BUSCAR+'%' 
				OR	CUENTA_BANCO.D_CUENTA_BANCO	LIKE '%'+@PP_BUSCAR+'%' 
				OR	ESTATUS_CREDITO_BANCARIO.D_ESTATUS_CREDITO_BANCARIO	LIKE '%'+@PP_BUSCAR+'%' 
				OR	TIPO_CALCULO_CREDITO.D_TIPO_CALCULO_CREDITO		LIKE '%'+@PP_BUSCAR+'%'  
			-- =====================
				OR	CREDITO_BANCARIO.K_CREDITO_BANCARIO=@VP_K_FOLIO 
			)	
			-- ===================== @PP_K_MOTIVO_CREDITO_BANCARIO
	AND		( @PP_K_RAZON_SOCIAL_ACREDITADA=-1	OR	CREDITO_BANCARIO.K_RAZON_SOCIAL_ACREDITADA=@PP_K_RAZON_SOCIAL_ACREDITADA )
	AND		( @PP_K_RAZON_SOCIAL_BENEFICIADA=-1	OR	CREDITO_BANCARIO.K_RAZON_SOCIAL_BENEFICIADA=@PP_K_RAZON_SOCIAL_BENEFICIADA )
	AND		( @PP_K_GRUPO_CREDITO=-1	OR	CREDITO_BANCARIO.K_GRUPO_CREDITO=@PP_K_GRUPO_CREDITO )
	AND		( @PP_K_MOTIVO_CREDITO_BANCARIO=-1	OR	CREDITO_BANCARIO.K_MOTIVO_CREDITO_BANCARIO=@PP_K_MOTIVO_CREDITO_BANCARIO )
	AND		( @PP_K_TIPO_CREDITO_BANCARIO=-1	OR	CREDITO_BANCARIO.K_TIPO_CREDITO_BANCARIO=@PP_K_TIPO_CREDITO_BANCARIO )
	AND		( @PP_K_BANCO=-1	OR	CREDITO_BANCARIO.K_BANCO=@PP_K_BANCO )
	AND		( @PP_K_MONEDA=-1	OR	CREDITO_BANCARIO.K_MONEDA=@PP_K_MONEDA )
	AND		( @PP_K_ESTATUS_CREDITO_BANCARIO=-1	OR	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO=@PP_K_ESTATUS_CREDITO_BANCARIO )
			-- =====================		
	ORDER BY K_CREDITO_BANCARIO DESC
		
	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_CREDITO_BANCARIO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_BUSCAR, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_CREDITO_BANCARIO', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CREDITO_BANCARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CREDITO_BANCARIO]
GO


CREATE PROCEDURE [dbo].[PG_SK_CREDITO_BANCARIO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_CREDITO_BANCARIO		INT
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

	DECLARE @VP_INT_NUMERO_REGISTROS	INT	= 1
	
	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0

	SELECT	TOP(@VP_INT_NUMERO_REGISTROS)
			CREDITO_BANCARIO.*, D_USUARIO AS D_USUARIO_CAMBIO,	
			(CREDITO_BANCARIO.TASA_INTERES_ANUAL * 100) AS TASA_INTERES_ANUAL_0_100,
			CUENTA, CLABE,
			-- =====================					
			D_GRUPO_CREDITO, D_TIPO_CREDITO_BANCARIO, D_MOTIVO_CREDITO_BANCARIO, D_BANCO, D_MONEDA, D_CUENTA_BANCO, D_ESTATUS_CREDITO_BANCARIO, D_TIPO_CALCULO_CREDITO,
			S_GRUPO_CREDITO, S_TIPO_CREDITO_BANCARIO, S_MOTIVO_CREDITO_BANCARIO, S_BANCO, S_MONEDA, S_CUENTA_BANCO, S_ESTATUS_CREDITO_BANCARIO, S_TIPO_CALCULO_CREDITO,
			-- =====================
			R1.D_RAZON_SOCIAL D_ACREDITADA, R2.D_RAZON_SOCIAL D_BENEFICIADA,	
			R1.S_RAZON_SOCIAL S_ACREDITADA, R2.S_RAZON_SOCIAL S_BENEFICIADA	
			-- =====================
	FROM	CREDITO_BANCARIO, USUARIO,
			GRUPO_CREDITO, TIPO_CREDITO_BANCARIO, MOTIVO_CREDITO_BANCARIO,
			BANCO, MONEDA, CUENTA_BANCO, ESTATUS_CREDITO_BANCARIO, TIPO_CALCULO_CREDITO,
			RAZON_SOCIAL R1, RAZON_SOCIAL R2
			-- =====================
	WHERE	(	CREDITO_BANCARIO.L_BORRADO=0		OR		@VP_L_VER_BORRADOS=1	)
			-- =====================
	AND		CREDITO_BANCARIO.K_RAZON_SOCIAL_ACREDITADA=R1.K_RAZON_SOCIAL
	AND		CREDITO_BANCARIO.K_RAZON_SOCIAL_BENEFICIADA=R2.K_RAZON_SOCIAL
	AND		CREDITO_BANCARIO.K_GRUPO_CREDITO=GRUPO_CREDITO.K_GRUPO_CREDITO
	AND		CREDITO_BANCARIO.K_MOTIVO_CREDITO_BANCARIO=MOTIVO_CREDITO_BANCARIO.K_MOTIVO_CREDITO_BANCARIO
	AND		CREDITO_BANCARIO.K_TIPO_CREDITO_BANCARIO=TIPO_CREDITO_BANCARIO.K_TIPO_CREDITO_BANCARIO
	AND		CREDITO_BANCARIO.K_BANCO=BANCO.K_BANCO
	AND		CREDITO_BANCARIO.K_MONEDA=MONEDA.K_MONEDA
	AND		CREDITO_BANCARIO.K_CUENTA_BANCO_PAGO=CUENTA_BANCO.K_CUENTA_BANCO
	AND		CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO=ESTATUS_CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO
	AND		CREDITO_BANCARIO.K_TIPO_CALCULO_CREDITO=TIPO_CALCULO_CREDITO.K_TIPO_CALCULO_CREDITO			
	AND		CREDITO_BANCARIO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- =====================
	AND		CREDITO_BANCARIO.K_CREDITO_BANCARIO=@PP_K_CREDITO_BANCARIO

	-----////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_CREDITO_BANCARIO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CREDITO_BANCARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_CREDITO_BANCARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_CREDITO_BANCARIO]
GO


CREATE PROCEDURE [dbo].[PG_IN_CREDITO_BANCARIO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_D_CREDITO_BANCARIO				VARCHAR (100),
	@PP_C_CREDITO_BANCARIO				VARCHAR (255),
	@PP_K_RAZON_SOCIAL_ACREDITADA       INT,			
	@PP_K_RAZON_SOCIAL_BENEFICIADA      INT,			
	@PP_K_GRUPO_CREDITO					INT,
	@PP_K_MOTIVO_CREDITO_BANCARIO		INT,			
	@PP_JUSTIFICACION					VARCHAR (500),
	@PP_K_TIPO_CREDITO_BANCARIO			INT,
	@PP_K_BANCO							INT,
	@PP_K_MONEDA						INT,
	@PP_K_CUENTA_BANCO_PAGO				INT,
	@PP_NUMERO_CREDITO					VARCHAR (100),
	@PP_K_TIPO_CALCULO_CREDITO			INT,			
	@PP_MONTO_PRESTAMO					DECIMAL(19,4),
	@PP_TASA_INTERES_ANUAL				FLOAT,  
	@PP_CANTIDAD_PERIODOS				INT,
	@PP_F_INICIO						DATE	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_CREDITO_BANCARIO				INT = 0
	DECLARE @VP_O_CREDITO_BANCARIO				INT = 0

		
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'CREDITO_BANCARIO', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_CREDITO_BANCARIO			OUTPUT

		
		-- /////////////////////////////////////////////////////////////////////

		IF @VP_MENSAJE=''
			EXECUTE [dbo].[PG_RN_CREDITO_BANCARIO_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_CREDITO_BANCARIO,
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

		-- //////////////////////////////////////////////////////////////

		DECLARE @VP_TASA_INTERES_ANUAL AS FLOAT
		SET @VP_TASA_INTERES_ANUAL=@PP_TASA_INTERES_ANUAL/100

		-- //////////////////////////////////////////////////////////////
		
		INSERT INTO CREDITO_BANCARIO
			(	[K_CREDITO_BANCARIO],			
				[D_CREDITO_BANCARIO],[C_CREDITO_BANCARIO],	
				[K_RAZON_SOCIAL_ACREDITADA],[K_RAZON_SOCIAL_BENEFICIADA],
				[K_GRUPO_CREDITO],
				-- ============================================
				[K_MOTIVO_CREDITO_BANCARIO],[JUSTIFICACION],
				[K_TIPO_CREDITO_BANCARIO], 
				[K_BANCO], [K_MONEDA], [K_CUENTA_BANCO_PAGO],			
				-- ============================================
				[K_ESTATUS_CREDITO_BANCARIO], [NUMERO_CREDITO],
				-- ============================================
				[K_TIPO_CALCULO_CREDITO], [MONTO_PRESTAMO],
				[TASA_INTERES_ANUAL], [CANTIDAD_PERIODOS],
				[F_INICIO], [O_CREDITO_BANCARIO],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_CREDITO_BANCARIO,
				@PP_D_CREDITO_BANCARIO, @PP_C_CREDITO_BANCARIO,
				@PP_K_RAZON_SOCIAL_ACREDITADA,@PP_K_RAZON_SOCIAL_BENEFICIADA,
				@PP_K_GRUPO_CREDITO,
				-- ============================================
				@PP_K_MOTIVO_CREDITO_BANCARIO,@PP_JUSTIFICACION,				
				@PP_K_TIPO_CREDITO_BANCARIO,
				@PP_K_BANCO, @PP_K_MONEDA, @PP_K_CUENTA_BANCO_PAGO,			
				-- ============================================
				1, @PP_NUMERO_CREDITO,
				-- ============================================
				@PP_K_TIPO_CALCULO_CREDITO, @PP_MONTO_PRESTAMO,
				@VP_TASA_INTERES_ANUAL, @PP_CANTIDAD_PERIODOS,
				@PP_F_INICIO, 10,
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )
		
		-- //////////////////////////////////////////////////////////////

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [CREDITO_BANCARIO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Cb.'+CONVERT(VARCHAR(10),@VP_K_CREDITO_BANCARIO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_CREDITO_BANCARIO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_CREDITO_BANCARIO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_CREDITO_BANCARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_CREDITO_BANCARIO, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_CREDITO_BANCARIO', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UP CREDITO BANCARIO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_CREDITO_BANCARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_CREDITO_BANCARIO]
GO


CREATE PROCEDURE [dbo].[PG_UP_CREDITO_BANCARIO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_CREDITO_BANCARIO				INT,
	@PP_D_CREDITO_BANCARIO				VARCHAR (100),
	@PP_C_CREDITO_BANCARIO				VARCHAR (255),
	@PP_K_RAZON_SOCIAL_ACREDITADA       INT,			
	@PP_K_RAZON_SOCIAL_BENEFICIADA      INT,			
	@PP_K_GRUPO_CREDITO					INT,
	@PP_K_MOTIVO_CREDITO_BANCARIO		INT,			
	@PP_JUSTIFICACION					VARCHAR (500),
	@PP_K_TIPO_CREDITO_BANCARIO			INT,
	@PP_K_BANCO							INT,
	@PP_K_MONEDA						INT,
	@PP_K_CUENTA_BANCO_PAGO				INT,
	@PP_NUMERO_CREDITO					VARCHAR (100),
	@PP_K_TIPO_CALCULO_CREDITO			INT,			
	@PP_MONTO_PRESTAMO					DECIMAL(19,4),
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

	DECLARE @VP_TASA_INTERES_ANUAL AS FLOAT
		SET @VP_TASA_INTERES_ANUAL=@PP_TASA_INTERES_ANUAL/100

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	CREDITO_BANCARIO
		SET		[D_CREDITO_BANCARIO]		   = @PP_D_CREDITO_BANCARIO,				
				[C_CREDITO_BANCARIO]           = @PP_C_CREDITO_BANCARIO,	
				[K_RAZON_SOCIAL_ACREDITADA]    = @PP_K_RAZON_SOCIAL_ACREDITADA,     
				[K_RAZON_SOCIAL_BENEFICIADA]   = @PP_K_RAZON_SOCIAL_BENEFICIADA,    
				[K_GRUPO_CREDITO]              = @PP_K_GRUPO_CREDITO,					
				[K_MOTIVO_CREDITO_BANCARIO]    = @PP_K_MOTIVO_CREDITO_BANCARIO,
				[JUSTIFICACION]                = @PP_JUSTIFICACION,	
				[K_TIPO_CREDITO_BANCARIO]      = @PP_K_TIPO_CREDITO_BANCARIO,
				[K_BANCO]                      = @PP_K_BANCO,			
				[K_MONEDA]                     = @PP_K_MONEDA,						
				[K_CUENTA_BANCO_PAGO]          = @PP_K_CUENTA_BANCO_PAGO,
				[NUMERO_CREDITO]               = @PP_NUMERO_CREDITO,			
				[K_TIPO_CALCULO_CREDITO]       = @PP_K_TIPO_CALCULO_CREDITO,
				[MONTO_PRESTAMO]               = @PP_MONTO_PRESTAMO,		
				[TASA_INTERES_ANUAL]           = @VP_TASA_INTERES_ANUAL,				
				[CANTIDAD_PERIODOS]            = @PP_CANTIDAD_PERIODOS,			
				[F_INICIO]					   = @PP_F_INICIO,
				-- ===========================
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION, 
				[F_CAMBIO]						= GETDATE() 
		WHERE	K_CREDITO_BANCARIO=@PP_K_CREDITO_BANCARIO
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [CREDITO_BANCARIO]: ' + @VP_MENSAJE 
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
													'[PG_UP_CREDITO_BANCARIO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CREDITO_BANCARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_CREDITO_BANCARIO, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_CREDITO_BANCARIO', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_CREDITO_BANCARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_CREDITO_BANCARIO]
GO


CREATE PROCEDURE [dbo].[PG_DL_CREDITO_BANCARIO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_CREDITO_BANCARIO				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE	=	''

	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CREDITO_BANCARIO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_CREDITO_BANCARIO, 
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN


		UPDATE	CREDITO_BANCARIO
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_CREDITO_BANCARIO=@PP_K_CREDITO_BANCARIO

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [CREDITO_BANCARIO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Cb.'+CONVERT(VARCHAR(10),@PP_K_CREDITO_BANCARIO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CREDITO_BANCARIO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_CREDITO_BANCARIO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CREDITO_BANCARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO
