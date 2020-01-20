-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PROVEEDOR / CXP
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			Alex de la Rosa
-- // Fecha creación:	24/SEP/2018
-- //////////////////////////////////////////////////////////////  

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PROVEEDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PROVEEDOR]
GO


CREATE PROCEDURE [dbo].[PG_LI_PROVEEDOR]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_BUSCAR						VARCHAR(200),
	@PP_K_ESTATUS_PROVEEDOR			INT,
	@PP_K_CATEGORIA_PROVEEDOR		INT,
	@PP_FISCAL_K_ESTADO				INT,
	@PP_OFICINA_K_ESTADO			INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1
		
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_LI_N_REGISTROS		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															@VP_L_APLICAR_MAX_ROWS,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- =========================================	
	
	DECLARE @VP_K_FOLIO				INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]				@PP_BUSCAR, 
																@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
	
	DECLARE @VP_L_VER_BORRADOS		INT		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================
	
	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	SELECT		TOP (@VP_LI_N_REGISTROS)
				PR.*,
				EPR.D_ESTATUS_PROVEEDOR, CPR.D_CATEGORIA_PROVEEDOR, ESTADO.D_ESTADO,
				EPR.S_ESTATUS_PROVEEDOR, CPR.S_CATEGORIA_PROVEEDOR, ESTADO.S_ESTADO,
				D_USUARIO AS D_USUARIO_CAMBIO
				-- =============================	
	FROM		PROVEEDOR PR, 
				ESTATUS_PROVEEDOR EPR, CATEGORIA_PROVEEDOR CPR,
				ESTADO,
				USUARIO AS USR
				-- =============================
	WHERE		PR.K_ESTATUS_PROVEEDOR=EPR.K_ESTATUS_PROVEEDOR
	AND			PR.K_CATEGORIA_PROVEEDOR=CPR.K_CATEGORIA_PROVEEDOR
	AND			(	PR.FISCAL_K_ESTADO = ESTADO.K_ESTADO
				OR	PR.OFICINA_K_ESTADO = ESTADO.K_ESTADO )
	AND			PR.K_USUARIO_CAMBIO=USR.K_USUARIO
				-- =============================
	AND			(	PR.K_PROVEEDOR=@VP_K_FOLIO
				OR	PR.RAZON_SOCIAL					LIKE '%'+@PP_BUSCAR+'%'
				OR	PR.D_PROVEEDOR					LIKE '%'+@PP_BUSCAR+'%' 
				OR	PR.RFC_PROVEEDOR				LIKE '%'+@PP_BUSCAR+'%'
				OR	PR.C_PROVEEDOR					LIKE '%'+@PP_BUSCAR+'%' )
				-- =============================
	AND			( @PP_FISCAL_K_ESTADO =-1			OR	PR.FISCAL_K_ESTADO=@PP_FISCAL_K_ESTADO )
	AND			( @PP_OFICINA_K_ESTADO =-1			OR	PR.OFICINA_K_ESTADO=@PP_OFICINA_K_ESTADO )
	AND			( @PP_K_ESTATUS_PROVEEDOR	=-1		OR	PR.K_ESTATUS_PROVEEDOR=@PP_K_ESTATUS_PROVEEDOR )
	AND			( @PP_K_CATEGORIA_PROVEEDOR =-1		OR	PR.K_CATEGORIA_PROVEEDOR=@PP_K_CATEGORIA_PROVEEDOR )
				-- =============================
	ORDER BY	K_PROVEEDOR	DESC
	
	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_PROVEEDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_BUSCAR, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_BUSCAR', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_PROVEEDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_PROVEEDOR]
GO


CREATE PROCEDURE [dbo].[PG_SK_PROVEEDOR]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PROVEEDOR					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_L_VER_BORRADOS		INT		
	
		EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT = 100
	
		IF @VP_MENSAJE<>''
			SET @VP_LI_N_REGISTROS = 0
			
		SELECT	TOP (@VP_LI_N_REGISTROS)
				PR.*,
				EPR.D_ESTATUS_PROVEEDOR, CPR.D_CATEGORIA_PROVEEDOR,
				ESTADO.D_ESTADO,
				D_USUARIO AS D_USUARIO_CAMBIO
				-- =====================
		FROM	PROVEEDOR PR, 
				ESTATUS_PROVEEDOR EPR, CATEGORIA_PROVEEDOR CPR,
				ESTADO,
				USUARIO
				-- =====================
		WHERE	PR.K_ESTATUS_PROVEEDOR = EPR.K_ESTATUS_PROVEEDOR
		AND		PR.K_CATEGORIA_PROVEEDOR = CPR.K_CATEGORIA_PROVEEDOR
		AND		PR.FISCAL_K_ESTADO = ESTADO.K_ESTADO
		AND		PR.OFICINA_K_ESTADO = ESTADO.K_ESTADO
		AND		PR.K_PROVEEDOR=@PP_K_PROVEEDOR
		

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_PROVEEDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PROVEEDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_PROVEEDOR, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO



	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PROVEEDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PROVEEDOR]
GO


CREATE PROCEDURE [dbo].[PG_IN_PROVEEDOR]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_D_PROVEEDOR					VARCHAR(100),
	@PP_C_PROVEEDOR					VARCHAR(255),
	@PP_S_PROVEEDOR					VARCHAR(10),
	-- ===========================
	@PP_RAZON_SOCIAL				VARCHAR(100),
	@PP_RFC_PROVEEDOR				VARCHAR(13),
	@PP_CURP						VARCHAR(100),
	@PP_CORREO						VARCHAR(100),
	@PP_TELEFONO					VARCHAR(100),
	@PP_N_DIAS_CREDITO				INT,
	-- ===========================
	@PP_FISCAL_CALLE				VARCHAR(100),
	@PP_FISCAL_NUMERO_EXTERIOR		VARCHAR(100),
	@PP_FISCAL_NUMERO_INTERIOR		VARCHAR(100),
	@PP_FISCAL_COLONIA				VARCHAR(100),
	@PP_FISCAL_POBLACION			VARCHAR(100),
	@PP_FISCAL_CP					VARCHAR(100),
	@PP_FISCAL_MUNICIPIO			VARCHAR(100),
	@PP_FISCAL_K_ESTADO				INT,
	-- ===========================
	@PP_OFICINA_CALLE				VARCHAR(100),
	@PP_OFICINA_NUMERO_EXTERIOR		VARCHAR(100),
	@PP_OFICINA_NUMERO_INTERIOR		VARCHAR(100),
	@PP_OFICINA_COLONIA				VARCHAR(100),
	@PP_OFICINA_POBLACION			VARCHAR(100),
	@PP_OFICINA_CP					VARCHAR(100),
	@PP_OFICINA_MUNICIPIO			VARCHAR(100),
	@PP_OFICINA_K_ESTADO			INT,
	-- ===========================
	@PP_K_ESTATUS_PROVEEDOR			INT,
	@PP_K_CATEGORIA_PROVEEDOR		INT,
	-- ============================
	@PP_CONTACTO_VENTA				VARCHAR(100),
	@PP_CONTACTO_VENTA_TELEFONO		VARCHAR(100),
	@PP_CONTACTO_VENTA_CORREO		VARCHAR(100),
	-- ============================
	@PP_CONTACTO_PAGO				VARCHAR(100),
	@PP_CONTACTO_PAGO_TELEFONO		VARCHAR(100),
	@PP_CONTACTO_PAGO_CORREO		VARCHAR(100)
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_PROVEEDOR			INT = 0

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'PROVEEDOR', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_PROVEEDOR	OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_UNIQUE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@VP_K_PROVEEDOR, 
													@PP_D_PROVEEDOR, @PP_RFC_PROVEEDOR,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
		-- //////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		INSERT INTO PROVEEDOR
			(	[K_PROVEEDOR], [D_PROVEEDOR], 
				[C_PROVEEDOR], [S_PROVEEDOR], 
				[O_PROVEEDOR],
				-- ===========================
				[RAZON_SOCIAL],	[RFC_PROVEEDOR], 
				[CURP],	[CORREO], [TELEFONO], 
				[N_DIAS_CREDITO],
				-- ===========================
				[FISCAL_CALLE], [FISCAL_NUMERO_EXTERIOR], [FISCAL_NUMERO_INTERIOR], 
				[FISCAL_COLONIA], [FISCAL_POBLACION],
				[FISCAL_CP],[FISCAL_MUNICIPIO], [FISCAL_K_ESTADO], 
				-- ===========================
				[OFICINA_CALLE], [OFICINA_NUMERO_EXTERIOR], [OFICINA_NUMERO_INTERIOR], 
				[OFICINA_COLONIA], [OFICINA_POBLACION],
				[OFICINA_CP],[OFICINA_MUNICIPIO], [OFICINA_K_ESTADO], 
				-- ===========================

				[K_ESTATUS_PROVEEDOR],[K_CATEGORIA_PROVEEDOR],
				-- ===========================
				[CONTACTO_VENTA],[CONTACTO_VENTA_TELEFONO],[CONTACTO_VENTA_CORREO],
				-- ===========================
				[CONTACTO_PAGO],[CONTACTO_PAGO_TELEFONO],[CONTACTO_PAGO_CORREO],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_PROVEEDOR, @PP_D_PROVEEDOR, 
				@PP_C_PROVEEDOR, @PP_S_PROVEEDOR,
				10,
				-- ===========================
				@PP_RAZON_SOCIAL, @PP_RFC_PROVEEDOR, 
				@PP_CURP, @PP_CORREO, @PP_TELEFONO,
				@PP_N_DIAS_CREDITO,
				-- ===========================
				@PP_FISCAL_CALLE, @PP_FISCAL_NUMERO_EXTERIOR, @PP_FISCAL_NUMERO_INTERIOR,
				@PP_FISCAL_COLONIA, @PP_FISCAL_POBLACION,
				@PP_FISCAL_CP, @PP_FISCAL_MUNICIPIO, @PP_FISCAL_K_ESTADO, 
				-- ===========================
				@PP_OFICINA_CALLE, @PP_OFICINA_NUMERO_EXTERIOR, @PP_OFICINA_NUMERO_INTERIOR,
				@PP_OFICINA_COLONIA, @PP_OFICINA_POBLACION,
				@PP_OFICINA_CP, @PP_OFICINA_MUNICIPIO, @PP_OFICINA_K_ESTADO, 
				-- ===========================
				@PP_K_ESTATUS_PROVEEDOR, @PP_K_CATEGORIA_PROVEEDOR,
				-- ============================
				@PP_CONTACTO_VENTA, @PP_CONTACTO_VENTA_TELEFONO,
				@PP_CONTACTO_VENTA_CORREO,
				-- ============================
				@PP_CONTACTO_PAGO, @PP_CONTACTO_PAGO_TELEFONO,
				@PP_CONTACTO_PAGO_CORREO,		
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [Proveedor]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Pr.'+CONVERT(VARCHAR(10),@VP_K_PROVEEDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PROVEEDOR AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_PROVEEDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_PROVEEDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, @PP_C_PROVEEDOR, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_PROVEEDOR', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PROVEEDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PROVEEDOR]
GO

CREATE PROCEDURE [dbo].[PG_UP_PROVEEDOR]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PROVEEDOR					INT,
	@PP_D_PROVEEDOR					VARCHAR(100),
	@PP_C_PROVEEDOR					VARCHAR(255),
	@PP_S_PROVEEDOR					VARCHAR(10),
	-- ===========================
	@PP_RAZON_SOCIAL				VARCHAR(100),
	@PP_RFC_PROVEEDOR				VARCHAR(13),
	@PP_CURP						VARCHAR(100),
	@PP_CORREO						VARCHAR(100),
	@PP_TELEFONO					VARCHAR(100),
	@PP_N_DIAS_CREDITO				INT,
	-- ===========================
	@PP_FISCAL_CALLE				VARCHAR(100),
	@PP_FISCAL_NUMERO_EXTERIOR		VARCHAR(100),
	@PP_FISCAL_NUMERO_INTERIOR		VARCHAR(100),
	@PP_FISCAL_COLONIA				VARCHAR(100),
	@PP_FISCAL_POBLACION			VARCHAR(100),
	@PP_FISCAL_CP					VARCHAR(100),
	@PP_FISCAL_MUNICIPIO			VARCHAR(100),
	@PP_FISCAL_K_ESTADO				INT,
	-- ===========================
	@PP_OFICINA_CALLE				VARCHAR(100),
	@PP_OFICINA_NUMERO_EXTERIOR		VARCHAR(100),
	@PP_OFICINA_NUMERO_INTERIOR		VARCHAR(100),
	@PP_OFICINA_COLONIA				VARCHAR(100),
	@PP_OFICINA_POBLACION			VARCHAR(100),
	@PP_OFICINA_CP					VARCHAR(100),
	@PP_OFICINA_MUNICIPIO			VARCHAR(100),
	@PP_OFICINA_K_ESTADO			INT,
	-- ===========================
	@PP_K_ESTATUS_PROVEEDOR			INT,
	@PP_K_CATEGORIA_PROVEEDOR		INT,
	-- ============================
	@PP_CONTACTO_VENTA				VARCHAR(100),
	@PP_CONTACTO_VENTA_TELEFONO		VARCHAR(100),
	@PP_CONTACTO_VENTA_CORREO		VARCHAR(100),
	-- ============================
	@PP_CONTACTO_PAGO				VARCHAR(100),
	@PP_CONTACTO_PAGO_TELEFONO		VARCHAR(100),
	@PP_CONTACTO_PAGO_CORREO		VARCHAR(100)
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_PROVEEDOR, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_UNIQUE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_PROVEEDOR, 
													@PP_D_PROVEEDOR, @PP_RFC_PROVEEDOR,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	PROVEEDOR
		SET		
				[D_PROVEEDOR]						= @PP_D_PROVEEDOR,
				[C_PROVEEDOR]						= @PP_C_PROVEEDOR,
				[S_PROVEEDOR]						= @PP_S_PROVEEDOR,
				[O_PROVEEDOR]						= 10,
				-- ========================== -- ===========================
				[RAZON_SOCIAL]						= @PP_RAZON_SOCIAL,
				[RFC_PROVEEDOR]						= @PP_RFC_PROVEEDOR,				
				[CURP]								= @PP_CURP,
				[CORREO]							= @PP_CORREO,
				[TELEFONO]							= @PP_TELEFONO,
				[N_DIAS_CREDITO]					= [N_DIAS_CREDITO],
				-- ========================== -- ===========================
				[FISCAL_CALLE]						= @PP_FISCAL_CALLE,
				[FISCAL_NUMERO_EXTERIOR]			= @PP_FISCAL_NUMERO_EXTERIOR,
				[FISCAL_NUMERO_INTERIOR]			= @PP_FISCAL_NUMERO_INTERIOR,
				[FISCAL_COLONIA]					= @PP_FISCAL_COLONIA,
				[FISCAL_POBLACION]					= @PP_FISCAL_POBLACION,
				[FISCAL_CP]							= @PP_FISCAL_CP,
				[FISCAL_MUNICIPIO]					= @PP_FISCAL_MUNICIPIO,
				[FISCAL_K_ESTADO]					= @PP_FISCAL_K_ESTADO,
				-- ========================== -- ===========================
				[OFICINA_CALLE]						= @PP_FISCAL_CALLE,
				[OFICINA_NUMERO_EXTERIOR]			= @PP_FISCAL_NUMERO_EXTERIOR,
				[OFICINA_NUMERO_INTERIOR]			= @PP_FISCAL_NUMERO_INTERIOR,
				[OFICINA_COLONIA]					= @PP_FISCAL_COLONIA,
				[OFICINA_POBLACION]					= @PP_FISCAL_POBLACION,
				[OFICINA_CP]						= @PP_FISCAL_CP,
				[OFICINA_MUNICIPIO]					= @PP_FISCAL_MUNICIPIO,
				[OFICINA_K_ESTADO]					= @PP_FISCAL_K_ESTADO,
				-- ========================== -- ===========================
				[K_ESTATUS_PROVEEDOR]				= @PP_K_ESTATUS_PROVEEDOR,
				[K_CATEGORIA_PROVEEDOR]				= @PP_K_CATEGORIA_PROVEEDOR,		
				-- ========================== -- ============================
				[CONTACTO_VENTA]					= @PP_CONTACTO_VENTA,
				[CONTACTO_VENTA_TELEFONO]			= @PP_CONTACTO_VENTA_TELEFONO,
				[CONTACTO_VENTA_CORREO]				= @PP_CONTACTO_VENTA_CORREO,
				-- ========================== -- ============================
				[CONTACTO_PAGO]						= @PP_CONTACTO_PAGO,
				[CONTACTO_PAGO_TELEFONO]			= @PP_CONTACTO_PAGO_TELEFONO,
				[CONTACTO_PAGO_CORREO]				= @PP_CONTACTO_PAGO_CORREO,		
				-- ====================
				[F_CAMBIO]							= GETDATE(), 
				[K_USUARIO_CAMBIO]					= @PP_K_USUARIO_ACCION
		WHERE	K_PROVEEDOR=@PP_K_PROVEEDOR
	
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [Proveedor]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Pr.'+CONVERT(VARCHAR(10),@PP_K_PROVEEDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PROVEEDOR AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_PROVEEDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PROVEEDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_PROVEEDOR, '', 0.00, 0.00,
													0, 0, @PP_C_PROVEEDOR, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_PROVEEDOR', '', '', ''

	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_PROVEEDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_PROVEEDOR]
GO


CREATE PROCEDURE [dbo].[PG_DL_PROVEEDOR]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PROVEEDOR					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_PROVEEDOR, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	PROVEEDOR
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_PROVEEDOR=@PP_K_PROVEEDOR
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [Proveedor]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Pr.'+CONVERT(VARCHAR(10),@PP_K_PROVEEDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PROVEEDOR AS CLAVE

	-- //////////////////////////////////////////////////////////////
	
	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_PROVEEDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PROVEEDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
	
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
