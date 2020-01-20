-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PERSONAL
-- // OPERACION:		LIBERACION / STORED PROCEDURES
-- //////////////////////////////////////////////////////////////
-- // Autor:			DANIEL PORTILLO	ROMERO
-- // Fecha creación:	29/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PERSONAL_ACCESO_ORGANIZACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PERSONAL_ACCESO_ORGANIZACION]
GO


CREATE PROCEDURE [dbo].[PG_LI_PERSONAL_ACCESO_ORGANIZACION]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ==============================================	
	@PP_BUSCAR							VARCHAR(200),
	-- ==============================================	
	@PP_K_PERSONAL						INT,
	@PP_K_RAZON_SOCIAL					INT,
	@PP_K_ZONA_UO						INT,
	@PP_K_UNIDAD_OPERATIVA				INT
AS

	DECLARE @VP_MENSAJE					VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS		INT = 1
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS	INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_LI_N_REGISTROS		OUTPUT	
	-- =========================================		

	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]		@PP_BUSCAR, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
	
	DECLARE @VP_L_VER_BORRADOS		INT		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	-- =========================================
		
	SELECT	TOP (@VP_LI_N_REGISTROS)
				PERSONAL_ACCESO_ORGANIZACION.*,
				PERSONAL.D_PERSONAL, PERSONAL.S_PERSONAL,
				RAZON_SOCIAL.D_RAZON_SOCIAL, RAZON_SOCIAL.S_RAZON_SOCIAL,
				ZONA_UO.D_ZONA_UO, ZONA_UO.S_ZONA_UO,
				UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA, UNIDAD_OPERATIVA.S_UNIDAD_OPERATIVA,
				USUARIO.D_USUARIO AS D_USUARIO_CAMBIO		
			-- =====================
	FROM		PERSONAL_ACCESO_ORGANIZACION 
	LEFT JOIN	PERSONAL			ON PERSONAL_ACCESO_ORGANIZACION.K_PERSONAL=PERSONAL.K_PERSONAL
	LEFT JOIN	RAZON_SOCIAL		ON PERSONAL_ACCESO_ORGANIZACION.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL
	LEFT JOIN	ZONA_UO				ON PERSONAL_ACCESO_ORGANIZACION.K_ZONA_UO=ZONA_UO.K_ZONA_UO	
	LEFT JOIN	UNIDAD_OPERATIVA	ON PERSONAL_ACCESO_ORGANIZACION.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	INNER JOIN	USUARIO				ON PERSONAL_ACCESO_ORGANIZACION.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- =====================
	WHERE	(		PERSONAL.D_PERSONAL									LIKE '%'+@PP_BUSCAR+'%' 
				OR	PERSONAL.C_PERSONAL									LIKE '%'+@PP_BUSCAR+'%' 
				OR	RAZON_SOCIAL.D_RAZON_SOCIAL							LIKE '%'+@PP_BUSCAR+'%' 
				OR	ZONA_UO.D_ZONA_UO									LIKE '%'+@PP_BUSCAR+'%' 
				OR	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA					LIKE '%'+@PP_BUSCAR+'%' 
				OR	PERSONAL_ACCESO_ORGANIZACION.K_PERSONAL_ACCESO_ORGANIZACION=@VP_K_FOLIO 
				OR	PERSONAL_ACCESO_ORGANIZACION.K_RAZON_SOCIAL=@VP_K_FOLIO
				OR	PERSONAL_ACCESO_ORGANIZACION.K_ZONA_UO=@VP_K_FOLIO
				OR	PERSONAL_ACCESO_ORGANIZACION.K_UNIDAD_OPERATIVA=@VP_K_FOLIO
			)	
			-- =====================
	AND		( @PP_K_PERSONAL=-1								OR	PERSONAL_ACCESO_ORGANIZACION.K_PERSONAL=@PP_K_PERSONAL )
	AND		( @PP_K_RAZON_SOCIAL=-1							OR	PERSONAL_ACCESO_ORGANIZACION.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL )
	AND		( @PP_K_ZONA_UO=-1								OR	PERSONAL_ACCESO_ORGANIZACION.K_ZONA_UO=@PP_K_ZONA_UO )
	AND		( @PP_K_UNIDAD_OPERATIVA=-1						OR	PERSONAL_ACCESO_ORGANIZACION.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA )
	AND		( PERSONAL_ACCESO_ORGANIZACION.L_BORRADO=0		OR	@VP_L_VER_BORRADOS=1 )	
			-- =====================		
	ORDER BY K_PERSONAL_ACCESO_ORGANIZACION DESC
			
	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_PERSONAL_ACCESO_ORGANIZACION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_PERSONAL_ACCESO_ORGANIZACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_PERSONAL_ACCESO_ORGANIZACION]
GO


CREATE PROCEDURE [dbo].[PG_SK_PERSONAL_ACCESO_ORGANIZACION]
	@PP_L_DEBUG								INT,
	@PP_K_SISTEMA_EXE						INT,
	@PP_K_USUARIO_ACCION					INT,
	-- ===========================
	@PP_K_PERSONAL_ACCESO_ORGANIZACION		INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_L_VER_BORRADOS		INT		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT = 100

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	-- =========================================
		
	SELECT	TOP (@VP_LI_N_REGISTROS)
			PERSONAL_ACCESO_ORGANIZACION.*,
			PERSONAL.D_PERSONAL, PERSONAL.S_PERSONAL,
			RAZON_SOCIAL.D_RAZON_SOCIAL, RAZON_SOCIAL.S_RAZON_SOCIAL,
			ZONA_UO.D_ZONA_UO, ZONA_UO.S_ZONA_UO,
			UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA, UNIDAD_OPERATIVA.S_UNIDAD_OPERATIVA, 
			D_USUARIO AS D_USUARIO_CAMBIO			
			-- =====================
	FROM		PERSONAL_ACCESO_ORGANIZACION
	LEFT JOIN	PERSONAL			ON PERSONAL_ACCESO_ORGANIZACION.K_PERSONAL=PERSONAL.K_PERSONAL
	LEFT JOIN	RAZON_SOCIAL		ON PERSONAL_ACCESO_ORGANIZACION.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL
	LEFT JOIN	ZONA_UO				ON PERSONAL_ACCESO_ORGANIZACION.K_ZONA_UO=ZONA_UO.K_ZONA_UO	
	LEFT JOIN	UNIDAD_OPERATIVA	ON PERSONAL_ACCESO_ORGANIZACION.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	INNER JOIN	USUARIO				ON PERSONAL_ACCESO_ORGANIZACION.K_USUARIO_CAMBIO=USUARIO.K_USUARIO				
			-- =====================
	WHERE	PERSONAL_ACCESO_ORGANIZACION.K_PERSONAL_ACCESO_ORGANIZACION=@PP_K_PERSONAL_ACCESO_ORGANIZACION
		
	-----////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_PERSONAL_ACCESO_ORGANIZACION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PERSONAL_ACCESO_ORGANIZACION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PERSONAL_ACCESO_ORGANIZACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PERSONAL_ACCESO_ORGANIZACION]
GO


CREATE PROCEDURE [dbo].[PG_IN_PERSONAL_ACCESO_ORGANIZACION]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PERSONAL					INT,		
	@PP_K_RAZON_SOCIAL				INT,
	@PP_K_ZONA_UO					INT,
	@PP_K_UNIDAD_OPERATIVA			INT
	
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_PERSONAL_ACCESO_ORGANIZACION		INT = 0
	
	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'PERSONAL_ACCESO_ORGANIZACION', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_PERSONAL_ACCESO_ORGANIZACION			OUTPUT
	-- ==================================

	DECLARE @VP_O_PERSONAL_ACCESO_ORGANIZACION		INT = 0

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@VP_K_PERSONAL_ACCESO_ORGANIZACION,
																		@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN	
		
		-- ////////////////////////////////////////////////////////////////
		
		INSERT INTO PERSONAL_ACCESO_ORGANIZACION
			(	[K_PERSONAL_ACCESO_ORGANIZACION], 
				[K_PERSONAL], [K_RAZON_SOCIAL], [K_ZONA_UO], 
				[K_UNIDAD_OPERATIVA], 			
				-- ============================================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_PERSONAL_ACCESO_ORGANIZACION,
				@PP_K_PERSONAL, @PP_K_RAZON_SOCIAL, 
				@PP_K_ZONA_UO, @PP_K_UNIDAD_OPERATIVA,  		
				-- ============================================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [PERSONAL_ACCESO_ORGANIZACION]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Ac.'+CONVERT(VARCHAR(10),@VP_K_PERSONAL_ACCESO_ORGANIZACION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PERSONAL_ACCESO_ORGANIZACION AS CLAVE
	
	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_PERSONAL_ACCESO_ORGANIZACION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_PERSONAL_ACCESO_ORGANIZACION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_PERSONAL_ACCESO_ORGANIZACION, '', 0.00, 0.00,
													0, 0, '', '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PERSONAL_ACCESO_ORGANIZACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PERSONAL_ACCESO_ORGANIZACION]
GO

CREATE PROCEDURE [dbo].[PG_UP_PERSONAL_ACCESO_ORGANIZACION]
	@PP_L_DEBUG								INT,
	@PP_K_SISTEMA_EXE						INT,
	@PP_K_USUARIO_ACCION					INT,
	-- ===========================
	@PP_K_PERSONAL_ACCESO_ORGANIZACION		INT,
	@PP_K_PERSONAL							INT,		
	@PP_K_RAZON_SOCIAL						INT,
	@PP_K_ZONA_UO							INT,
	@PP_K_UNIDAD_OPERATIVA					INT
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_PERSONAL_ACCESO_ORGANIZACION, 
																	@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
				
		-- ==================================

		UPDATE	PERSONAL_ACCESO_ORGANIZACION
		SET		
				[K_PERSONAL]				= @PP_K_PERSONAL,
				[K_RAZON_SOCIAL]			= @PP_K_RAZON_SOCIAL, 
				[K_ZONA_UO]					= @PP_K_ZONA_UO,
				[K_UNIDAD_OPERATIVA]		= @PP_K_UNIDAD_OPERATIVA,
				-- ===========================
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION, 
				[F_CAMBIO]					= GETDATE() 
		WHERE	K_PERSONAL_ACCESO_ORGANIZACION=@PP_K_PERSONAL_ACCESO_ORGANIZACION
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [PERSONAL_ACCESO_ORGANIZACION]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Ac.'+CONVERT(VARCHAR(10),@PP_K_PERSONAL_ACCESO_ORGANIZACION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PERSONAL_ACCESO_ORGANIZACION AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_PERSONAL_ACCESO_ORGANIZACION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PERSONAL_ACCESO_ORGANIZACION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_PERSONAL_ACCESO_ORGANIZACION, '', 0.00, 0.00,
													0, 0, '', '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_PERSONAL_ACCESO_ORGANIZACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_PERSONAL_ACCESO_ORGANIZACION]
GO


CREATE PROCEDURE [dbo].[PG_DL_PERSONAL_ACCESO_ORGANIZACION]
	@PP_L_DEBUG								INT,
	@PP_K_SISTEMA_EXE						INT,
	@PP_K_USUARIO_ACCION					INT,
	-- ===========================
	@PP_K_PERSONAL_ACCESO_ORGANIZACION		INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_PERSONAL_ACCESO_ORGANIZACION, 
																		@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	PERSONAL_ACCESO_ORGANIZACION
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_PERSONAL_ACCESO_ORGANIZACION=@PP_K_PERSONAL_ACCESO_ORGANIZACION

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [PERSONAL_ACCESO_ORGANIZACION]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Ac.'+CONVERT(VARCHAR(10),@PP_K_PERSONAL_ACCESO_ORGANIZACION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PERSONAL_ACCESO_ORGANIZACION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_PERSONAL_ACCESO_ORGANIZACION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PERSONAL_ACCESO_ORGANIZACION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
