-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			FINANCIAMIENTO
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////
-- SELECT * FROM BANCO
-- EXECUTE [PG_LI_BANCO] 0,0,0, '', -1, -1
 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_LI_BANCO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================	
	@PP_C_BANCO				VARCHAR(255),
	@PP_K_ESTATUS_BANCO		INT,
	@PP_K_PAIS				INT
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

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]		@PP_C_BANCO, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================
	
	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0

	SELECT	TOP ( @VP_INT_NUMERO_REGISTROS )
			BANCO.*,
			S_ESTATUS_BANCO,	D_ESTATUS_BANCO, 
			S_PAIS,				D_PAIS,
			D_USUARIO AS D_USUARIO_CAMBIO			
			-- =====================
	FROM	BANCO, PAIS, ESTATUS_BANCO, USUARIO
			-- =====================
	WHERE	(	BANCO.L_BORRADO=0		OR		@VP_L_VER_BORRADOS=1	)
	AND		BANCO.K_ESTATUS_BANCO=ESTATUS_BANCO.K_ESTATUS_BANCO
	AND		BANCO.K_PAIS=PAIS.K_PAIS
	AND		BANCO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- =====================
	AND		(	D_BANCO	LIKE '%'+@PP_C_BANCO+'%' 
				OR	BANCO.K_BANCO=@VP_K_FOLIO 		)	
	AND		( @PP_K_ESTATUS_BANCO=-1	OR	ESTATUS_BANCO.K_ESTATUS_BANCO=@PP_K_ESTATUS_BANCO )
	AND		( @PP_K_PAIS=-1	OR	BANCO.K_PAIS=@PP_K_PAIS )
			-- =====================		
	ORDER BY D_BANCO
	
	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_BANCO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_C_BANCO, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_BANCO', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////
-- EXECUTE [PG_SK_BANCO] 0,0,0, 23

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_SK_BANCO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_BANCO				INT
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
	
	DECLARE @VP_INT_NUMERO_REGISTROS INT = 1

	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0
	
	SELECT	TOP ( @VP_INT_NUMERO_REGISTROS )
			BANCO.*,
			S_ESTATUS_BANCO,	D_ESTATUS_BANCO, 
			S_PAIS,				D_PAIS,
			D_USUARIO AS D_USUARIO_CAMBIO			
			-- =====================
	FROM	BANCO, PAIS, ESTATUS_BANCO, USUARIO
			-- =====================
	WHERE	(	BANCO.L_BORRADO=0		OR		@VP_L_VER_BORRADOS=1	)
	AND		BANCO.K_ESTATUS_BANCO=ESTATUS_BANCO.K_ESTATUS_BANCO
	AND		BANCO.K_PAIS=PAIS.K_PAIS
	AND		BANCO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- =====================
	AND		BANCO.K_BANCO=@PP_K_BANCO		

	-----////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_BANCO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_IN_BANCO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_D_BANCO				VARCHAR(100),
	@PP_C_BANCO				VARCHAR(255),
	@PP_S_BANCO				VARCHAR(10),
	@PP_L_BANCO				INT,
	@PP_K_ESTATUS_BANCO		INT,
	@PP_K_PAIS				INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_BANCO				INT = 0
	DECLARE @VP_O_BANCO				INT = 0

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_BANCO_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@VP_K_BANCO, @PP_D_BANCO, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'BANCO', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_BANCO			OUTPUT

		-- //////////////////////////////////////////////////////////////
		
		INSERT INTO BANCO
			(	[K_BANCO],			[D_BANCO],	
				[C_BANCO],			[S_BANCO],
				[O_BANCO],			[L_BANCO],
				[K_ESTATUS_BANCO],  [K_PAIS],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_BANCO,			@PP_D_BANCO,
				@PP_C_BANCO,			@PP_S_BANCO, 
				@VP_O_BANCO,			@PP_L_BANCO,
				@PP_K_ESTATUS_BANCO,	@PP_K_PAIS,
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [Banco]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#BCO.'+CONVERT(VARCHAR(10),@VP_K_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_BANCO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_BANCO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_BANCO, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_BANCO', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_BANCO]
GO

CREATE PROCEDURE [dbo].[PG_UP_BANCO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_BANCO				INT,
	@PP_D_BANCO				VARCHAR(100),
	@PP_C_BANCO				VARCHAR(255),
	@PP_S_BANCO				VARCHAR(10),
	@PP_L_BANCO				INT,
	@PP_K_ESTATUS_BANCO		INT,
	@PP_K_PAIS				INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_BANCO_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_BANCO, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	BANCO
		SET		
				[D_BANCO]			= @PP_D_BANCO, 
				[C_BANCO]			= @PP_C_BANCO,
				[S_BANCO]			= @PP_S_BANCO,
				[L_BANCO]			= @PP_L_BANCO,
				[K_ESTATUS_BANCO]	= @PP_K_ESTATUS_BANCO,
				[K_PAIS]			= @PP_K_PAIS,
				-- ===========================
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION, 
				[F_CAMBIO]					= GETDATE() 
		WHERE	K_BANCO=@PP_K_BANCO
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [Banco]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#BCO.'+CONVERT(VARCHAR(10),@PP_K_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
			
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_BANCO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_BANCO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_BANCO, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_BANCO', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_DL_BANCO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_BANCO				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE	=	''

	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_BANCO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_BANCO, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN


		UPDATE	BANCO
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_BANCO=@PP_K_BANCO

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [Banco]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#BCO.'+CONVERT(VARCHAR(10),@PP_K_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_BANCO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_BANCO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

