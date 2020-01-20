-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			SP_Proveedor_Viatico_20181116_DPR.sql
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			CONTROL DE VIAJES - PROVEEDOR_VIÁTICO 
-- // OPERACIÓN:		LIBERACIÓN / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			Daniel Portillo Romero
-- // Fecha creación:	16/NOV/2018
-- //////////////////////////////////////////////////////////////  

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PROVEEDOR_VIATICO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PROVEEDOR_VIATICO]
GO


CREATE PROCEDURE [dbo].[PG_LI_PROVEEDOR_VIATICO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_BUSCAR							VARCHAR(200),
	@PP_K_ESTATUS_PROVEEDOR_VIATICO		INT,
	@PP_K_RUBRO_VIATICO					INT
AS

	DECLARE @VP_MENSAJE					VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS		INT=1
		
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
															1, -- @PP_K_DATA_SISTEMA,	
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_LI_N_REGISTROS		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															@VP_L_APLICAR_MAX_ROWS,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- ///////////////////////////////////////////	
	
	DECLARE @VP_K_FOLIO				INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]			@PP_BUSCAR, 
															@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_L_VER_BORRADOS		INT		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]					@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- ///////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	SELECT		TOP (@VP_LI_N_REGISTROS)
				PROVEEDOR_VIATICO.*,
				ESTATUS_PROVEEDOR_VIATICO.D_ESTATUS_PROVEEDOR_VIATICO, RUBRO_VIATICO.D_RUBRO_VIATICO,
				ESTATUS_PROVEEDOR_VIATICO.S_ESTATUS_PROVEEDOR_VIATICO, RUBRO_VIATICO.S_RUBRO_VIATICO,
				D_USUARIO AS D_USUARIO_CAMBIO
				-- =============================	
	FROM		PROVEEDOR_VIATICO, 
				ESTATUS_PROVEEDOR_VIATICO, RUBRO_VIATICO,
				USUARIO
				-- =============================
	WHERE		PROVEEDOR_VIATICO.K_ESTATUS_PROVEEDOR_VIATICO=ESTATUS_PROVEEDOR_VIATICO.K_ESTATUS_PROVEEDOR_VIATICO
	AND			PROVEEDOR_VIATICO.K_RUBRO_VIATICO=RUBRO_VIATICO.K_RUBRO_VIATICO
	AND			PROVEEDOR_VIATICO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
				-- =============================
	AND			(	PROVEEDOR_VIATICO.D_PROVEEDOR_VIATICO				LIKE '%'+@PP_BUSCAR+'%'
				OR	PROVEEDOR_VIATICO.C_PROVEEDOR_VIATICO				LIKE '%'+@PP_BUSCAR+'%' 
				OR	PROVEEDOR_VIATICO.RFC_PROVEEDOR_VIATICO				LIKE '%'+@PP_BUSCAR+'%'
				OR	PROVEEDOR_VIATICO.RAZON_SOCIAL_PROVEEDOR_VIATICO	LIKE '%'+@PP_BUSCAR+'%'
				OR  PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO=@VP_K_FOLIO							)
				-- =============================
	AND			( @PP_K_ESTATUS_PROVEEDOR_VIATICO=-1	OR	PROVEEDOR_VIATICO.K_ESTATUS_PROVEEDOR_VIATICO=@PP_K_ESTATUS_PROVEEDOR_VIATICO )
	AND			( @PP_K_RUBRO_VIATICO=-1				OR	PROVEEDOR_VIATICO.K_RUBRO_VIATICO=@PP_K_RUBRO_VIATICO )
	AND			( @VP_L_VER_BORRADOS=1					OR	PROVEEDOR_VIATICO.L_BORRADO=0 )
				-- =============================
	ORDER BY	K_PROVEEDOR_VIATICO	DESC
	
	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_PROVEEDOR_VIATICO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_PROVEEDOR_VIATICO_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_PROVEEDOR_VIATICO_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_SK_PROVEEDOR_VIATICO_EXISTE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_RFC_PROVEEDOR_VIATICO		VARCHAR (100)
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_L_VER_BORRADOS		INT		
	
		EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT = 100
	
		IF @VP_MENSAJE<>''
			SET @VP_LI_N_REGISTROS = 0
			
		SELECT	TOP (@VP_LI_N_REGISTROS)
				PROVEEDOR_VIATICO.*
				-- =====================
		FROM	PROVEEDOR_VIATICO, 
				ESTATUS_PROVEEDOR_VIATICO
				-- =====================
		WHERE	PROVEEDOR_VIATICO.K_ESTATUS_PROVEEDOR_VIATICO=ESTATUS_PROVEEDOR_VIATICO.K_ESTATUS_PROVEEDOR_VIATICO
		AND		PROVEEDOR_VIATICO.RFC_PROVEEDOR_VIATICO=@PP_RFC_PROVEEDOR_VIATICO


	-- ////////////////////////////////////////////////
/*
	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_PROVEEDOR_VIATICO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PROVEEDOR_VIATICO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_PROVEEDOR_VIATICO, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''
*/
	-- ////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_PROVEEDOR_VIATICO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_PROVEEDOR_VIATICO]
GO


CREATE PROCEDURE [dbo].[PG_SK_PROVEEDOR_VIATICO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PROVEEDOR_VIATICO			INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_L_VER_BORRADOS		INT		
	
		EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT = 100
	
		IF @VP_MENSAJE<>''
			SET @VP_LI_N_REGISTROS = 0
			
		SELECT	TOP (@VP_LI_N_REGISTROS)
				PROVEEDOR_VIATICO.*,
				ESTATUS_PROVEEDOR_VIATICO.D_ESTATUS_PROVEEDOR_VIATICO, RUBRO_VIATICO.D_RUBRO_VIATICO,
				ESTATUS_PROVEEDOR_VIATICO.S_ESTATUS_PROVEEDOR_VIATICO, RUBRO_VIATICO.S_RUBRO_VIATICO,
				D_USUARIO AS D_USUARIO_CAMBIO
				-- =====================
		FROM	PROVEEDOR_VIATICO, 
				ESTATUS_PROVEEDOR_VIATICO, RUBRO_VIATICO,
				USUARIO
				-- =====================
		WHERE	PROVEEDOR_VIATICO.K_ESTATUS_PROVEEDOR_VIATICO=ESTATUS_PROVEEDOR_VIATICO.K_ESTATUS_PROVEEDOR_VIATICO
		AND		PROVEEDOR_VIATICO.K_RUBRO_VIATICO=RUBRO_VIATICO.K_RUBRO_VIATICO
		AND		PROVEEDOR_VIATICO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
		AND		PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO=@PP_K_PROVEEDOR_VIATICO
		

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_PROVEEDOR_VIATICO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PROVEEDOR_VIATICO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_PROVEEDOR_VIATICO, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO



	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PROVEEDOR_VIATICO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PROVEEDOR_VIATICO]
GO


CREATE PROCEDURE [dbo].[PG_IN_PROVEEDOR_VIATICO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_D_PROVEEDOR_VIATICO				VARCHAR(100),
	@PP_C_PROVEEDOR_VIATICO				VARCHAR(255),
	@PP_S_PROVEEDOR_VIATICO				VARCHAR(10),
	-- ===========================
	@PP_RFC_PROVEEDOR_VIATICO			VARCHAR(100),
	@PP_RAZON_SOCIAL_PROVEEDOR_VIATICO	VARCHAR(100),
	-- ===========================
	@PP_K_ESTATUS_PROVEEDOR_VIATICO		INT,
	@PP_K_RUBRO_VIATICO					INT
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- ///////////////////////////////////////////////////
	
	DECLARE @VP_K_PROVEEDOR_VIATICO			INT = 0

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															'PROVEEDOR_VIATICO', 
															@OU_K_TABLA_DISPONIBLE = @VP_K_PROVEEDOR_VIATICO	OUTPUT	
	-- ///////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_VIATICO_UNIQUE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@VP_K_PROVEEDOR_VIATICO, 
															@PP_D_PROVEEDOR_VIATICO, @PP_RFC_PROVEEDOR_VIATICO,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE				OUTPUT	
		-- ///////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		INSERT INTO PROVEEDOR_VIATICO
			(	[K_PROVEEDOR_VIATICO],				[D_PROVEEDOR_VIATICO], 
				[C_PROVEEDOR_VIATICO],				[S_PROVEEDOR_VIATICO],
				[O_PROVEEDOR_VIATICO], 
				-- ===========================
				[RFC_PROVEEDOR_VIATICO],			[RAZON_SOCIAL_PROVEEDOR_VIATICO],	
				-- ===========================
				[K_ESTATUS_PROVEEDOR_VIATICO],		[K_RUBRO_VIATICO],
				-- ===========================
				[K_USUARIO_ALTA],					[F_ALTA], 
				[K_USUARIO_CAMBIO],					[F_CAMBIO],
				[L_BORRADO], 
				[K_USUARIO_BAJA],					[F_BAJA]  )
		VALUES	
			(	@VP_K_PROVEEDOR_VIATICO,			@PP_D_PROVEEDOR_VIATICO, 
				@PP_C_PROVEEDOR_VIATICO,			@PP_S_PROVEEDOR_VIATICO, 
				10,
				-- ===========================
				@PP_RFC_PROVEEDOR_VIATICO,			@PP_RAZON_SOCIAL_PROVEEDOR_VIATICO, 
				-- ===========================
				-- ===========================
				@PP_K_ESTATUS_PROVEEDOR_VIATICO,	@PP_K_RUBRO_VIATICO,
				-- ============================
				@PP_K_USUARIO_ACCION,				GETDATE(), 
				@PP_K_USUARIO_ACCION,				GETDATE(),
				0, 
				NULL,								NULL		)
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [Proveedor de Viáticos]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PrV.'+CONVERT(VARCHAR(10),@VP_K_PROVEEDOR_VIATICO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PROVEEDOR_VIATICO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_PROVEEDOR_VIATICO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_PROVEEDOR_VIATICO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, @PP_C_PROVEEDOR_VIATICO, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_PROVEEDOR_VIATICO', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / PREREGISTRO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PROVEEDOR_VIATICO_PREREGISTRO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PROVEEDOR_VIATICO_PREREGISTRO]
GO


CREATE PROCEDURE [dbo].[PG_IN_PROVEEDOR_VIATICO_PREREGISTRO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_D_PROVEEDOR_VIATICO				VARCHAR(100),
	-- ===========================
	@PP_RFC_PROVEEDOR_VIATICO			VARCHAR(100)
	-- ===========================
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- ///////////////////////////////////////////////////
	
	DECLARE @VP_K_PROVEEDOR_VIATICO			INT = 0

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															'PROVEEDOR_VIATICO', 
															@OU_K_TABLA_DISPONIBLE = @VP_K_PROVEEDOR_VIATICO	OUTPUT	
	-- ///////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_VIATICO_UNIQUE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@VP_K_PROVEEDOR_VIATICO, 
															@PP_D_PROVEEDOR_VIATICO, @PP_RFC_PROVEEDOR_VIATICO,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE				OUTPUT	
	--///////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		INSERT INTO PROVEEDOR_VIATICO
			(	[K_PROVEEDOR_VIATICO],				[D_PROVEEDOR_VIATICO], 
				[C_PROVEEDOR_VIATICO],				[S_PROVEEDOR_VIATICO],
				[O_PROVEEDOR_VIATICO], 
				-- ===========================
				[RFC_PROVEEDOR_VIATICO],			[RAZON_SOCIAL_PROVEEDOR_VIATICO],	
				-- ===========================
				[K_ESTATUS_PROVEEDOR_VIATICO],		[K_RUBRO_VIATICO],
				-- ===========================
				[K_USUARIO_ALTA],					[F_ALTA], 
				[K_USUARIO_CAMBIO],					[F_CAMBIO],
				[L_BORRADO], 
				[K_USUARIO_BAJA],					[F_BAJA]  )
		VALUES	
			(	@VP_K_PROVEEDOR_VIATICO,			@PP_D_PROVEEDOR_VIATICO, 
				'PROVEEDOR PREREGISTRADO',			'PRGT', 
				10, @PP_RFC_PROVEEDOR_VIATICO,		@PP_D_PROVEEDOR_VIATICO,
				-- ===========================
				--[K_ESTATUS_PROVEEDOR_VIATICO] = PREREGISTRO
				 	1,								
				--[K_RUBRO_VIATICO] = OTROS,	
					12,		
				-- ============================
				@PP_K_USUARIO_ACCION,				GETDATE(), 
				@PP_K_USUARIO_ACCION,				GETDATE(),
				0, 
				NULL,								NULL		)
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [Proveedor de Viáticos]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PrV.'+CONVERT(VARCHAR(10),@VP_K_PROVEEDOR_VIATICO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PROVEEDOR_VIATICO AS CLAVE

	-- //////////////////////////////////////////////////////////////
/*
	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT/PREREGISTRO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_PROVEEDOR_VIATICO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_PROVEEDOR_VIATICO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, @PP_D_PROVEEDOR_VIATICO, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@@PP_D_PROVEEDOR_VIATICO', '', '', ''
*/
	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PROVEEDOR_VIATICO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PROVEEDOR_VIATICO]
GO

CREATE PROCEDURE [dbo].[PG_UP_PROVEEDOR_VIATICO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_PROVEEDOR_VIATICO				INT,
	-- ===========================
	@PP_D_PROVEEDOR_VIATICO				VARCHAR(100),
	@PP_C_PROVEEDOR_VIATICO				VARCHAR(255),
	@PP_S_PROVEEDOR_VIATICO				VARCHAR(10),
	-- ===========================
	@PP_RFC_PROVEEDOR_VIATICO			VARCHAR(100),
	@PP_RAZON_SOCIAL_PROVEEDOR_VIATICO	VARCHAR(100),
	-- ===========================
	@PP_K_ESTATUS_PROVEEDOR_VIATICO		INT,
	@PP_K_RUBRO_VIATICO					INT
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_VIATICO_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PROVEEDOR_VIATICO, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_VIATICO_UNIQUE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PROVEEDOR_VIATICO, 
															@PP_D_PROVEEDOR_VIATICO, @PP_RFC_PROVEEDOR_VIATICO,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	PROVEEDOR_VIATICO
		SET		[D_PROVEEDOR_VIATICO]				= @PP_D_PROVEEDOR_VIATICO,
				[C_PROVEEDOR_VIATICO]				= @PP_C_PROVEEDOR_VIATICO,
				[S_PROVEEDOR_VIATICO]				= @PP_S_PROVEEDOR_VIATICO,
				-- ========================== -- ===========================
				[RFC_PROVEEDOR_VIATICO]				= @PP_RFC_PROVEEDOR_VIATICO,	
				[RAZON_SOCIAL_PROVEEDOR_VIATICO]	= @PP_RAZON_SOCIAL_PROVEEDOR_VIATICO,
				-- ========================== -- ===========================
				[K_ESTATUS_PROVEEDOR_VIATICO]		= @PP_K_ESTATUS_PROVEEDOR_VIATICO,
				[K_RUBRO_VIATICO]					= @PP_K_RUBRO_VIATICO,
				-- ====================
				[F_CAMBIO]							= GETDATE(), 
				[K_USUARIO_CAMBIO]					= @PP_K_USUARIO_ACCION
		WHERE	K_PROVEEDOR_VIATICO=@PP_K_PROVEEDOR_VIATICO
	
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [Proveedor de Viáticos]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PrV.'+CONVERT(VARCHAR(10),@PP_K_PROVEEDOR_VIATICO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PROVEEDOR_VIATICO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_PROVEEDOR_VIATICO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PROVEEDOR_VIATICO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_PROVEEDOR_VIATICO, '', 0.00, 0.00,
													0, 0, @PP_C_PROVEEDOR_VIATICO, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_PROVEEDOR_VIATICO', '', '', ''

	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_PROVEEDOR_VIATICO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_PROVEEDOR_VIATICO]
GO


CREATE PROCEDURE [dbo].[PG_DL_PROVEEDOR_VIATICO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PROVEEDOR_VIATICO					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_VIATICO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PROVEEDOR_VIATICO, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	PROVEEDOR_VIATICO
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_PROVEEDOR_VIATICO=@PP_K_PROVEEDOR_VIATICO
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [Proveedor de Viáticos]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PrV.'+CONVERT(VARCHAR(10),@PP_K_PROVEEDOR_VIATICO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PROVEEDOR_VIATICO AS CLAVE

	-- //////////////////////////////////////////////////////////////
	
	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_PROVEEDOR_VIATICO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PROVEEDOR_VIATICO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
	
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
