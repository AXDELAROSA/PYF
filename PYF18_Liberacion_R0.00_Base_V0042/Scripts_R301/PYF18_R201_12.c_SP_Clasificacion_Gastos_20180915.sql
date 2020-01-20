-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_CLASIFICACION_GASTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_CLASIFICACION_GASTO]
GO


CREATE PROCEDURE [dbo].[PG_LI_CLASIFICACION_GASTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_BUSCAR					VARCHAR(200),
	@PP_K_RUBRO_GASTO			INT
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

	SELECT	TOP ( @VP_INT_NUMERO_REGISTROS )
			CLASIFICACION_GASTO.*,
			D_USUARIO AS D_USUARIO_CAMBIO,
			D_RUBRO_GASTO, D_ESTATUS_ACTIVO, 
			S_RUBRO_GASTO, S_ESTATUS_ACTIVO
			-- =====================
	FROM	CLASIFICACION_GASTO, 
			RUBRO_GASTO, ESTATUS_ACTIVO, 
			USUARIO
			-- =====================
	WHERE	CLASIFICACION_GASTO.K_RUBRO_GASTO=RUBRO_GASTO.K_RUBRO_GASTO
	AND		CLASIFICACION_GASTO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		CLASIFICACION_GASTO.L_CLASIFICACION_GASTO=ESTATUS_ACTIVO.K_ESTATUS_ACTIVO
			-- =====================
	AND		(		
				D_CLASIFICACION_GASTO	LIKE '%'+@PP_BUSCAR+'%' 
			OR	CLASIFICACION_GASTO.K_CLASIFICACION_GASTO=@VP_K_FOLIO 
			)	
	AND		( @PP_K_RUBRO_GASTO=-1	OR	CLASIFICACION_GASTO.K_RUBRO_GASTO=@PP_K_RUBRO_GASTO )
	AND		( @VP_L_VER_BORRADOS=1	OR	CLASIFICACION_GASTO.L_BORRADO=0		)
			-- =====================		
	ORDER BY D_CLASIFICACION_GASTO
		
	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_CLASIFICACION_GASTO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_BUSCAR, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_CLASIFICACION_GASTO', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CLASIFICACION_GASTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CLASIFICACION_GASTO]
GO


CREATE PROCEDURE [dbo].[PG_SK_CLASIFICACION_GASTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_CLASIFICACION_GASTO	INT
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
	
	DECLARE @VP_INT_NUMERO_REGISTROS	INT = 100

	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0
	
	SELECT	TOP ( @VP_INT_NUMERO_REGISTROS )
			CLASIFICACION_GASTO.*,
			D_USUARIO AS D_USUARIO_CAMBIO,
			D_RUBRO_GASTO, D_ESTATUS_ACTIVO, 
			S_RUBRO_GASTO, S_ESTATUS_ACTIVO
			-- =====================
	FROM	CLASIFICACION_GASTO, 
			RUBRO_GASTO, ESTATUS_ACTIVO, 
			USUARIO
			-- =====================
	WHERE	(	CLASIFICACION_GASTO.L_BORRADO=0		OR		@VP_L_VER_BORRADOS=1	)
	AND		CLASIFICACION_GASTO.K_RUBRO_GASTO=RUBRO_GASTO.K_RUBRO_GASTO
	AND		CLASIFICACION_GASTO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		CLASIFICACION_GASTO.L_CLASIFICACION_GASTO=ESTATUS_ACTIVO.K_ESTATUS_ACTIVO
			-- =====================
	AND		CLASIFICACION_GASTO.K_CLASIFICACION_GASTO=@PP_K_CLASIFICACION_GASTO 
	
	-----////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_CLASIFICACION_GASTO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CLASIFICACION_GASTO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_CLASIFICACION_GASTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_CLASIFICACION_GASTO]
GO


CREATE PROCEDURE [dbo].[PG_IN_CLASIFICACION_GASTO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_D_CLASIFICACION_GASTO				VARCHAR(100),
	@PP_C_CLASIFICACION_GASTO				VARCHAR(255),
	@PP_S_CLASIFICACION_GASTO				VARCHAR(10),
	@PP_K_RUBRO_GASTO						INT
	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_CLASIFICACION_GASTO				INT = 0
	DECLARE @VP_O_CLASIFICACION_GASTO				INT = 0

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CLASIFICACION_GASTO_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_CLASIFICACION_GASTO, @PP_D_CLASIFICACION_GASTO, 
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'CLASIFICACION_GASTO', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_CLASIFICACION_GASTO			OUTPUT

		-- //////////////////////////////////////////////////////////////
		
		INSERT INTO CLASIFICACION_GASTO
			(	[K_CLASIFICACION_GASTO],			[D_CLASIFICACION_GASTO],	
				[C_CLASIFICACION_GASTO],			[S_CLASIFICACION_GASTO],
				[O_CLASIFICACION_GASTO],			[L_CLASIFICACION_GASTO],
				[K_RUBRO_GASTO],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_CLASIFICACION_GASTO,			@PP_D_CLASIFICACION_GASTO,
				@PP_C_CLASIFICACION_GASTO,			@PP_S_CLASIFICACION_GASTO, 
				@VP_O_CLASIFICACION_GASTO,			1,
				@PP_K_RUBRO_GASTO,
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )
		
		-- //////////////////////////////////////////////////////////////

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [Clasificación-Gasto]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CLG.'+CONVERT(VARCHAR(10),@VP_K_CLASIFICACION_GASTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_CLASIFICACION_GASTO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_CLASIFICACION_GASTO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_CLASIFICACION_GASTO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_CLASIFICACION_GASTO, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_CLASIFICACION_GASTO', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_CLASIFICACION_GASTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_CLASIFICACION_GASTO]
GO

CREATE PROCEDURE [dbo].[PG_UP_CLASIFICACION_GASTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_CLASIFICACION_GASTO	INT,
	@PP_D_CLASIFICACION_GASTO	VARCHAR(100),
	@PP_C_CLASIFICACION_GASTO	VARCHAR(255),
	@PP_S_CLASIFICACION_GASTO	VARCHAR(10),
	@PP_K_RUBRO_GASTO			INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CLASIFICACION_GASTO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_CLASIFICACION_GASTO, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	CLASIFICACION_GASTO
		SET		
				[D_CLASIFICACION_GASTO]			= @PP_D_CLASIFICACION_GASTO, 
				[C_CLASIFICACION_GASTO]			= @PP_C_CLASIFICACION_GASTO,
				[S_CLASIFICACION_GASTO]			= @PP_S_CLASIFICACION_GASTO,
				[L_CLASIFICACION_GASTO]			= 1,
				[K_RUBRO_GASTO]					= @PP_K_RUBRO_GASTO,
				-- ===========================
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION, 
				[F_CAMBIO]					= GETDATE() 
		WHERE	K_CLASIFICACION_GASTO=@PP_K_CLASIFICACION_GASTO
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [Clasificación-Gasto]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CLG.'+CONVERT(VARCHAR(10),@PP_K_CLASIFICACION_GASTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CLASIFICACION_GASTO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_CLASIFICACION_GASTO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CLASIFICACION_GASTO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_CLASIFICACION_GASTO, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_CLASIFICACION_GASTO', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_CLASIFICACION_GASTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_CLASIFICACION_GASTO]
GO


CREATE PROCEDURE [dbo].[PG_DL_CLASIFICACION_GASTO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_CLASIFICACION_GASTO				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE	=	''

	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CLASIFICACION_GASTO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_CLASIFICACION_GASTO, 
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN


		UPDATE	CLASIFICACION_GASTO
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_CLASIFICACION_GASTO=@PP_K_CLASIFICACION_GASTO

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [Clasificación-Gasto]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CLG.'+CONVERT(VARCHAR(10),@PP_K_CLASIFICACION_GASTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CLASIFICACION_GASTO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_CLASIFICACION_GASTO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CLASIFICACION_GASTO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO



-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////

