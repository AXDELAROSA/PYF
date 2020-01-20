-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			ESTRUCTURA / UNIDAD OPERATIVA
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_UNIDAD_OPERATIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_UNIDAD_OPERATIVA]
GO

CREATE PROCEDURE [dbo].[PG_LI_UNIDAD_OPERATIVA]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_D_UNIDAD_OPERATIVA	VARCHAR(255),
	@PP_K_TIPO_UO			INT,
	@PP_K_ZONA_UO			INT,
	@PP_K_SERVIDOR			INT,
	@PP_K_REGION			INT,
	@PP_K_ESTATUS_ACTIVO	INT
	-- ===========================
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)

	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	
	DECLARE @VP_INT_NUMERO_REGISTROS	INT
	
	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
	-- =========================================		

	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_D_UNIDAD_OPERATIVA, 
													@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================

	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0
		
	SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
			UNIDAD_OPERATIVA.*,
			CONVERT(DECIMAL(10,0),(UTILIZACION_ALMACEN*100)) AS UTILIZACION_ALMACEN_100,
			-- =================================			
			D_ESTATUS_ACTIVO, D_RAZON_SOCIAL, D_REGION, D_TIPO_UO, D_ZONA_UO, D_SERVIDOR,
			S_ESTATUS_ACTIVO, S_RAZON_SOCIAL, S_REGION, S_TIPO_UO, S_ZONA_UO, S_SERVIDOR,					
			D_USUARIO AS D_USUARIO_CAMBIO
			-- =================================
	FROM	UNIDAD_OPERATIVA, 
			ESTATUS_ACTIVO, RAZON_SOCIAL, REGION,
			TIPO_UO, ZONA_UO, SERVIDOR,
			USUARIO
			-- =================================
	WHERE	UNIDAD_OPERATIVA.L_UNIDAD_OPERATIVA=ESTATUS_ACTIVO.K_ESTATUS_ACTIVO
	AND		UNIDAD_OPERATIVA.L_BORRADO=0
	AND		UNIDAD_OPERATIVA.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		UNIDAD_OPERATIVA.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL
	AND		UNIDAD_OPERATIVA.K_TIPO_UO=TIPO_UO.K_TIPO_UO		
	AND		UNIDAD_OPERATIVA.K_ZONA_UO=ZONA_UO.K_ZONA_UO
	AND		UNIDAD_OPERATIVA.K_SERVIDOR=SERVIDOR.K_SERVIDOR
	AND		UNIDAD_OPERATIVA.K_REGION=REGION.K_REGION
	AND		(	D_UNIDAD_OPERATIVA		LIKE '%'+@PP_D_UNIDAD_OPERATIVA+'%' 
			OR	D_RAZON_SOCIAL 			LIKE '%'+@PP_D_UNIDAD_OPERATIVA+'%' 	
			OR	K_UNIDAD_OPERATIVA=@VP_K_FOLIO 			)	
	AND		( @PP_K_ESTATUS_ACTIVO=-1	OR		UNIDAD_OPERATIVA.L_UNIDAD_OPERATIVA=@PP_K_ESTATUS_ACTIVO )
	AND		( @PP_K_TIPO_UO=-1			OR		UNIDAD_OPERATIVA.K_TIPO_UO=@PP_K_TIPO_UO )
	AND		( @PP_K_ZONA_UO=-1			OR		UNIDAD_OPERATIVA.K_ZONA_UO=@PP_K_ZONA_UO )
	AND		( @PP_K_SERVIDOR=-1			OR		UNIDAD_OPERATIVA.K_SERVIDOR=@PP_K_SERVIDOR )
	AND		( @PP_K_REGION=-1			OR		UNIDAD_OPERATIVA.K_REGION=@PP_K_REGION )
	ORDER BY D_UNIDAD_OPERATIVA

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_UNIDAD_OPERATIVA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_UNIDAD_OPERATIVA, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_UNIDAD_OPERATIVA', '', '', ''

	-- ////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////
-- [PG_SK_UNIDAD_OPERATIVA] 0,0,0, 5

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_UNIDAD_OPERATIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_UNIDAD_OPERATIVA]
GO

CREATE PROCEDURE [dbo].[PG_SK_UNIDAD_OPERATIVA]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_UNIDAD_OPERATIVA		INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_INT_NUMERO_REGISTROS INT = 0

	IF @VP_MENSAJE=''
		SET @VP_INT_NUMERO_REGISTROS = 1

	SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
			UNIDAD_OPERATIVA.*,
			CONVERT(DECIMAL(10,0),(UTILIZACION_ALMACEN*100)) AS UTILIZACION_ALMACEN_100,
			-- =================================			
			D_ESTATUS_ACTIVO, D_RAZON_SOCIAL, D_REGION, D_TIPO_UO, D_ZONA_UO, D_SERVIDOR,
			S_ESTATUS_ACTIVO, S_RAZON_SOCIAL, S_REGION, S_TIPO_UO, S_ZONA_UO, S_SERVIDOR,					
			D_USUARIO AS D_USUARIO_CAMBIO
			-- =================================
	FROM	UNIDAD_OPERATIVA, 
			ESTATUS_ACTIVO, RAZON_SOCIAL, REGION,
			TIPO_UO, ZONA_UO, SERVIDOR,
			USUARIO
			-- =================================
	WHERE	UNIDAD_OPERATIVA.L_UNIDAD_OPERATIVA=ESTATUS_ACTIVO.K_ESTATUS_ACTIVO
	AND		UNIDAD_OPERATIVA.L_BORRADO=0
	AND		UNIDAD_OPERATIVA.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		UNIDAD_OPERATIVA.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL
	AND		UNIDAD_OPERATIVA.K_TIPO_UO=TIPO_UO.K_TIPO_UO		
	AND		UNIDAD_OPERATIVA.K_ZONA_UO=ZONA_UO.K_ZONA_UO
	AND		UNIDAD_OPERATIVA.K_SERVIDOR=SERVIDOR.K_SERVIDOR
	AND		UNIDAD_OPERATIVA.K_REGION=REGION.K_REGION
	AND		UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA

	--		===============================================

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_UNIDAD_OPERATIVA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_UNIDAD_OPERATIVA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@', '', '', ''
	-- //////////////////////////////////////////
GO


	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_UNIDAD_OPERATIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_UNIDAD_OPERATIVA]
GO

CREATE PROCEDURE [dbo].[PG_IN_UNIDAD_OPERATIVA]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_D_UNIDAD_OPERATIVA		VARCHAR(100),
	@PP_C_UNIDAD_OPERATIVA		VARCHAR(500),
	@PP_S_UNIDAD_OPERATIVA		VARCHAR(10),
	@PP_O_UNIDAD_OPERATIVA		INT,
	@PP_L_UNIDAD_OPERATIVA		INT,
	@PP_K_TIPO_UO				INT,
	@PP_K_ZONA_UO				INT,
	@PP_ICS_sucursalID			INT,
	@PP_K_SERVIDOR				INT,			
	@PP_K_RAZON_SOCIAL			INT,			
	@PP_K_REGION				INT,			
	@PP_PERMISO_CRE				VARCHAR(100),	
	@PP_TELEFONO				VARCHAR(20)	,
	@PP_CALLE					VARCHAR(100),	
	@PP_NUMERO_EXTERIOR			VARCHAR(10)	,
	@PP_NUMERO_INTERIOR			VARCHAR(10)	,
	@PP_COLONIA					VARCHAR(100),	
	@PP_POBLACION				VARCHAR(100),	
	@PP_CP						VARCHAR(10)	,
	@PP_MUNICIPIO				VARCHAR(100)	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_UNIDAD_OPERATIVA	INT = 0
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_UNIDAD_OPERATIVA_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_UNIDAD_OPERATIVA, @PP_D_UNIDAD_OPERATIVA,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
														'UNIDAD_OPERATIVA', 
														@OU_K_TABLA_DISPONIBLE = @VP_K_UNIDAD_OPERATIVA			OUTPUT

		-- //////////////////////////////////////////////////////////////
		

		INSERT INTO UNIDAD_OPERATIVA
			(	[K_UNIDAD_OPERATIVA],	[D_UNIDAD_OPERATIVA],	[C_UNIDAD_OPERATIVA],
				[S_UNIDAD_OPERATIVA],	[O_UNIDAD_OPERATIVA],	[L_UNIDAD_OPERATIVA],
				[K_TIPO_UO],			[K_ZONA_UO],			[ICS_sucursalId],
				-- ===========================
				[K_SERVIDOR],			[K_RAZON_SOCIAL],		[K_REGION],			
				[PERMISO_CRE],			[TELEFONO],				[CALLE],
				[NUMERO_EXTERIOR],		[NUMERO_INTERIOR],		[COLONIA],
				[POBLACION],			[CP],					[MUNICIPIO],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_UNIDAD_OPERATIVA,	@PP_D_UNIDAD_OPERATIVA,	@PP_C_UNIDAD_OPERATIVA,
				@PP_S_UNIDAD_OPERATIVA,	@PP_O_UNIDAD_OPERATIVA,	@PP_L_UNIDAD_OPERATIVA,
				@PP_K_TIPO_UO,			@PP_K_ZONA_UO,			@PP_ICS_sucursalID,
				-- ===========================
				@PP_K_SERVIDOR,			@PP_K_RAZON_SOCIAL,		@PP_K_REGION,
				@PP_PERMISO_CRE,		@PP_TELEFONO,			@PP_CALLE,
				@PP_NUMERO_EXTERIOR,	@PP_NUMERO_INTERIOR,	@PP_COLONIA,
				@PP_POBLACION,			@PP_CP,					@PP_MUNICIPIO,
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] la [UNIDAD_OPERATIVA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#UO.'+CONVERT(VARCHAR(10),@VP_K_UNIDAD_OPERATIVA)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_UNIDAD_OPERATIVA AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_UNIDAD_OPERATIVA AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_UNIDAD_OPERATIVA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_UNIDAD_OPERATIVA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_UNIDAD_OPERATIVA, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_UNIDAD_OPERATIVA', '', '', ''
	-- //////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> ACTUALIZAR / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_UNIDAD_OPERATIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_UNIDAD_OPERATIVA]
GO

CREATE PROCEDURE [dbo].[PG_UP_UNIDAD_OPERATIVA]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_D_UNIDAD_OPERATIVA		VARCHAR(100),
	@PP_C_UNIDAD_OPERATIVA		VARCHAR(500),
	@PP_S_UNIDAD_OPERATIVA		VARCHAR(10),
	@PP_0_UNIDAD_OPERATIVA		INT,
	@PP_L_UNIDAD_OPERATIVA		INT,
	@PP_K_TIPO_UO				INT,
	@PP_K_ZONA_UO				INT,
	@PP_ICS_sucursalID			INT,
	@PP_K_SERVIDOR				INT,			
	@PP_K_RAZON_SOCIAL			INT,			
	@PP_K_REGION				INT,			
	@PP_PERMISO_CRE				VARCHAR(100),	
	@PP_TELEFONO				VARCHAR(20)	,
	@PP_CALLE					VARCHAR(100),	
	@PP_NUMERO_EXTERIOR			VARCHAR(10)	,
	@PP_NUMERO_INTERIOR			VARCHAR(10)	,
	@PP_COLONIA					VARCHAR(100),	
	@PP_POBLACION				VARCHAR(100),	
	@PP_CP						VARCHAR(10)	,
	@PP_MUNICIPIO				VARCHAR(100)	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_UNIDAD_OPERATIVA_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_UNIDAD_OPERATIVA, @PP_D_UNIDAD_OPERATIVA,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	UNIDAD_OPERATIVA
		SET		
				
				[D_UNIDAD_OPERATIVA]	=	@PP_D_UNIDAD_OPERATIVA,
				[C_UNIDAD_OPERATIVA]	=	@PP_C_UNIDAD_OPERATIVA,
				[S_UNIDAD_OPERATIVA]	=	@PP_S_UNIDAD_OPERATIVA,
				[K_TIPO_UO]				=	@PP_K_TIPO_UO,
				[K_ZONA_UO]				=	@PP_K_ZONA_UO,
				[ICS_sucursalId]		=	@PP_ICS_sucursalID,		
				[O_UNIDAD_OPERATIVA]	=	@PP_0_UNIDAD_OPERATIVA,
				[L_UNIDAD_OPERATIVA]	=	@PP_L_UNIDAD_OPERATIVA ,
				-- ===========================
				[K_SERVIDOR]			=	@PP_K_SERVIDOR,		
				[K_RAZON_SOCIAL]		=	@PP_K_RAZON_SOCIAL,
				[K_REGION]				=	@PP_K_REGION,		
				[PERMISO_CRE]			=	@PP_PERMISO_CRE,		
				[TELEFONO]				=	@PP_TELEFONO,		
				[CALLE]					=	@PP_CALLE,			
				[NUMERO_EXTERIOR]		=	@PP_NUMERO_EXTERIOR,	
				[NUMERO_INTERIOR]		=	@PP_NUMERO_INTERIOR,	
				[COLONIA]				=	@PP_COLONIA,			
				[POBLACION]				=	@PP_POBLACION,		
				[CP]					=	@PP_CP,				
				[MUNICIPIO]				=	@PP_MUNICIPIO,	
				-- ====================
				[F_CAMBIO]				 =	GETDATE(), 
				[K_USUARIO_CAMBIO]		 =	@PP_K_USUARIO_ACCION
		WHERE	K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] la [UNIDAD_OPERATIVA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#UO.'+CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_UNIDAD_OPERATIVA AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_UNIDAD_OPERATIVA AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_UNIDAD_OPERATIVA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_UNIDAD_OPERATIVA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_UNIDAD_OPERATIVA, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_UNIDAD_OPERATIVA', '', '', ''

	-- //////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_UNIDAD_OPERATIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_UNIDAD_OPERATIVA]
GO

CREATE PROCEDURE [dbo].[PG_DL_UNIDAD_OPERATIVA]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_UNIDAD_OPERATIVA			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_UNIDAD_OPERATIVA_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_UNIDAD_OPERATIVA, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	UNIDAD_OPERATIVA
		SET		
				[L_BORRADO]		 =	1,
				-- ====================
				[F_BAJA]		 =	GETDATE(), 
				[K_USUARIO_BAJA] =	@PP_K_USUARIO_ACCION
		WHERE	K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la [UNIDAD_OPERATIVA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#UO.'+CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_UNIDAD_OPERATIVA AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_UNIDAD_OPERATIVA AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_UNIDAD_OPERATIVA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_UNIDAD_OPERATIVA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- //////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
