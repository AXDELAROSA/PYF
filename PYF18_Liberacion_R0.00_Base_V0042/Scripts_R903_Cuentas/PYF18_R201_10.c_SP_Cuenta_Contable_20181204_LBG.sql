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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_CUENTA_CONTABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_CUENTA_CONTABLE]
GO


CREATE PROCEDURE [dbo].[PG_LI_CUENTA_CONTABLE]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================	
	@PP_BUSCAR						VARCHAR(200),
	@PP_K_NIVEL_CUENTA_CONTABLE		INT,
	@PP_K_TIPO_CUENTA_CONTABLE		INT,
	@PP_K_SAT_AGRUPADOR				INT,
	@PP_L_AFECTABLE					INT,
	@PP_L_PRESUPUESTO				INT,
	@PP_L_ES_CUENTA_CONTABLE		INT
	
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
		
	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0
	
	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]		@PP_BUSCAR, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	SELECT	TOP ( @VP_INT_NUMERO_REGISTROS )
			CUENTA_CONTABLE.*, 
			D_TIPO_CUENTA_CONTABLE, S_TIPO_CUENTA_CONTABLE,
			D_NIVEL_CUENTA_CONTABLE, S_NIVEL_CUENTA_CONTABLE,
			D_SAT_AGRUPADOR, S_SAT_AGRUPADOR,
			D_USUARIO AS D_USUARIO_CAMBIO		
			-- =====================
	FROM	CUENTA_CONTABLE, USUARIO, 
			NIVEL_CUENTA_CONTABLE,
			TIPO_CUENTA_CONTABLE,
			SAT_AGRUPADOR
			-- =====================
	WHERE	CUENTA_CONTABLE.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- =====================
	AND		CUENTA_CONTABLE.K_NIVEL_CUENTA_CONTABLE=NIVEL_CUENTA_CONTABLE.K_NIVEL_CUENTA_CONTABLE
	AND		CUENTA_CONTABLE.K_TIPO_CUENTA_CONTABLE=TIPO_CUENTA_CONTABLE.K_TIPO_CUENTA_CONTABLE
	AND		CUENTA_CONTABLE.K_SAT_AGRUPADOR=SAT_AGRUPADOR.K_SAT_AGRUPADOR
			-- =====================
	AND		(	
				D_CUENTA_CONTABLE		LIKE '%'+@PP_BUSCAR+'%' 
			OR	S_CUENTA_CONTABLE		LIKE '%'+@PP_BUSCAR+'%' 
			OR	CODIGO					LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_CUENTA_CONTABLE_2		LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_CUENTA_CONTABLE_3		LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_TIPO_CUENTA_CONTABLE	LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_NIVEL_CUENTA_CONTABLE	LIKE '%'+@PP_BUSCAR+'%' 
			OR	CUENTA_CONTABLE.K_CUENTA_CONTABLE=@VP_K_FOLIO 
			)		
	AND		(	CUENTA_CONTABLE.L_BORRADO=0		OR		@VP_L_VER_BORRADOS=1	)	
	AND		( @PP_K_NIVEL_CUENTA_CONTABLE=-1 OR CUENTA_CONTABLE.K_NIVEL_CUENTA_CONTABLE=@PP_K_NIVEL_CUENTA_CONTABLE )
	AND		( @PP_K_TIPO_CUENTA_CONTABLE=-1 OR CUENTA_CONTABLE.K_TIPO_CUENTA_CONTABLE=@PP_K_TIPO_CUENTA_CONTABLE )
	AND		( @PP_K_SAT_AGRUPADOR=-1 OR CUENTA_CONTABLE.K_SAT_AGRUPADOR=@PP_K_SAT_AGRUPADOR )
	AND		( @PP_L_AFECTABLE=0 OR CUENTA_CONTABLE.L_AFECTABLE=@PP_L_AFECTABLE )
	AND		( @PP_L_PRESUPUESTO=0 OR CUENTA_CONTABLE.L_PRESUPUESTO=@PP_L_PRESUPUESTO )
	AND		( @PP_L_ES_CUENTA_CONTABLE=0 OR CUENTA_CONTABLE.L_ES_CUENTA_CONTABLE=@PP_L_ES_CUENTA_CONTABLE )

			-- =====================		
	ORDER BY K_CUENTA_CONTABLE
	
	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_CUENTA_CONTABLE]', -- @PP_STORED_PROCEDURE	[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_BUSCAR, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_CUENTA_CONTABLE', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CUENTA_CONTABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CUENTA_CONTABLE]
GO


CREATE PROCEDURE [dbo].[PG_SK_CUENTA_CONTABLE]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_CUENTA_CONTABLE				INT
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

	DECLARE @VP_INT_NUMERO_REGISTROS	INT =100

	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0
	
	
	SELECT	TOP ( @VP_INT_NUMERO_REGISTROS )
			CUENTA_CONTABLE.*, 
			D_USUARIO AS D_USUARIO_CAMBIO		
			-- =====================
	FROM	CUENTA_CONTABLE, USUARIO
			-- =====================
	WHERE	CUENTA_CONTABLE.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		CUENTA_CONTABLE.K_CUENTA_CONTABLE=@PP_K_CUENTA_CONTABLE		

	-----////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_CUENTA_CONTABLE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_CONTABLE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_CUENTA_CONTABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_CUENTA_CONTABLE]
GO


CREATE PROCEDURE [dbo].[PG_IN_CUENTA_CONTABLE]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_D_CUENTA_CONTABLE		VARCHAR(200),
	@PP_C_CUENTA_CONTABLE		VARCHAR(255),
	@PP_S_CUENTA_CONTABLE		VARCHAR(10),
	@PP_O_CUENTA_CONTABLE		INT,
	@PP_D_CUENTA_CONTABLE_2		VARCHAR(200),
	@PP_D_CUENTA_CONTABLE_3		VARCHAR(200),
	@PP_CODIGO					VARCHAR(50),
	@PP_L_AFECTABLE				INT,
	@PP_L_PRESUPUESTO			INT,	
	@PP_L_ES_CUENTA_CONTABLE	INT,
	@PP_K_NIVEL_CUENTA_CONTABLE	INT,
	@PP_K_TIPO_CUENTA_CONTABLE	INT,
	@PP_K_SAT_AGRUPADOR			INT	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_CUENTA_CONTABLE				INT = 0
	DECLARE @VP_O_CUENTA_CONTABLE				INT = 0

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_CONTABLE_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_CUENTA_CONTABLE, @PP_D_CUENTA_CONTABLE, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'CUENTA_CONTABLE', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_CUENTA_CONTABLE			OUTPUT

		-- //////////////////////////////////////////////////////////////
		
		INSERT INTO CUENTA_CONTABLE
		(	K_CUENTA_CONTABLE,			D_CUENTA_CONTABLE, 			
			S_CUENTA_CONTABLE,			O_CUENTA_CONTABLE,
			C_CUENTA_CONTABLE,
			D_CUENTA_CONTABLE_2,		D_CUENTA_CONTABLE_3,
			CODIGO,						L_AFECTABLE,				
			L_PRESUPUESTO,				L_ES_CUENTA_CONTABLE,		
			K_NIVEL_CUENTA_CONTABLE,	K_TIPO_CUENTA_CONTABLE,
			K_SAT_AGRUPADOR,			
			K_USUARIO_CAMBIO,		F_CAMBIO,
			K_USUARIO_ALTA,			F_ALTA,
			L_BORRADO)							
		VALUES		
		(	@VP_K_CUENTA_CONTABLE,		@PP_D_CUENTA_CONTABLE,	
			@PP_S_CUENTA_CONTABLE,		@PP_O_CUENTA_CONTABLE,
			@PP_C_CUENTA_CONTABLE,
			@PP_D_CUENTA_CONTABLE_2,	@PP_D_CUENTA_CONTABLE_3,
			@PP_CODIGO,					@PP_L_AFECTABLE,
			@PP_L_PRESUPUESTO,			@PP_L_ES_CUENTA_CONTABLE,
			@PP_K_NIVEL_CUENTA_CONTABLE,@PP_K_TIPO_CUENTA_CONTABLE,
			@PP_K_SAT_AGRUPADOR,		
			@PP_K_USUARIO_ACCION,	GETDATE(),
			@PP_K_USUARIO_ACCION,	GETDATE(),
			0		)
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] la [Cuenta Contable]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CCt.'+CONVERT(VARCHAR(10),@VP_K_CUENTA_CONTABLE)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_CUENTA_CONTABLE AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_CUENTA_CONTABLE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_CUENTA_CONTABLE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_CUENTA_CONTABLE, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_CUENTA_CONTABLE', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_CUENTA_CONTABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_CUENTA_CONTABLE]
GO

CREATE PROCEDURE [dbo].[PG_UP_CUENTA_CONTABLE]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_CUENTA_CONTABLE		INT,
	@PP_D_CUENTA_CONTABLE		VARCHAR(100),
	@PP_C_CUENTA_CONTABLE		VARCHAR(255),
	@PP_S_CUENTA_CONTABLE		VARCHAR(10),
	@PP_O_CUENTA_CONTABLE		INT,
	@PP_D_CUENTA_CONTABLE_2		VARCHAR(200),
	@PP_D_CUENTA_CONTABLE_3		VARCHAR(200),
	@PP_CODIGO					VARCHAR(50),
	@PP_L_AFECTABLE				INT,
	@PP_L_PRESUPUESTO			INT,	
	@PP_L_ES_CUENTA_CONTABLE	INT,	
	@PP_K_NIVEL_CUENTA_CONTABLE	INT,
	@PP_K_TIPO_CUENTA_CONTABLE	INT,
	@PP_K_SAT_AGRUPADOR			INT	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_CONTABLE_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_CUENTA_CONTABLE, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	CUENTA_CONTABLE
		SET		
				[D_CUENTA_CONTABLE]			= @PP_D_CUENTA_CONTABLE, 
				[C_CUENTA_CONTABLE]			= @PP_C_CUENTA_CONTABLE,
				[S_CUENTA_CONTABLE]			= @PP_S_CUENTA_CONTABLE,
				[D_CUENTA_CONTABLE_2]		= @PP_D_CUENTA_CONTABLE_2,
				[D_CUENTA_CONTABLE_3]		= @PP_D_CUENTA_CONTABLE_3,		
				[CODIGO]					= @PP_CODIGO,					
				[L_AFECTABLE]				= @PP_L_AFECTABLE,				
				[L_PRESUPUESTO]				= @PP_L_PRESUPUESTO,	
				[L_ES_CUENTA_CONTABLE]		= @PP_L_ES_CUENTA_CONTABLE,
				[K_NIVEL_CUENTA_CONTABLE]	= @PP_K_NIVEL_CUENTA_CONTABLE,	
				[K_TIPO_CUENTA_CONTABLE]	= @PP_K_TIPO_CUENTA_CONTABLE,	
				[K_SAT_AGRUPADOR]			= @PP_K_SAT_AGRUPADOR,
				-- ===========================
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION, 
				[F_CAMBIO]					= GETDATE() 
		WHERE	K_CUENTA_CONTABLE=@PP_K_CUENTA_CONTABLE
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible <Actualizar> la Cuenta-Contable: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CCt.'+CONVERT(VARCHAR(10),@PP_K_CUENTA_CONTABLE)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_CONTABLE AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_CUENTA_CONTABLE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_CONTABLE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_CUENTA_CONTABLE, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_CUENTA_CONTABLE', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_CUENTA_CONTABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_CUENTA_CONTABLE]
GO


CREATE PROCEDURE [dbo].[PG_DL_CUENTA_CONTABLE]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_CUENTA_CONTABLE				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE	=	''

	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_CONTABLE_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_CUENTA_CONTABLE, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN


		UPDATE	CUENTA_CONTABLE
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_CUENTA_CONTABLE=@PP_K_CUENTA_CONTABLE

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible <Borrar> la Cuenta-Contable: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CCt.'+CONVERT(VARCHAR(10),@PP_K_CUENTA_CONTABLE)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_CONTABLE AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_CUENTA_CONTABLE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_CONTABLE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

