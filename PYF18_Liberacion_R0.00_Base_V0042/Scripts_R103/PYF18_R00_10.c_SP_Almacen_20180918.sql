-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			ALMACEN-GAS
-- // OPERACION:		LIBERACION / STORED PROCEDURES
-- //////////////////////////////////////////////////////////////
-- // Autor:			DANIEL PORTILLO	ROMERO
-- // Fecha creación:	18/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ALMACEN_UTILIZACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_ALMACEN_UTILIZACION]
GO


CREATE PROCEDURE [dbo].[PG_UP_ALMACEN_UTILIZACION]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_ALMACEN					INT
AS			

	DECLARE @VP_CAPACIDAD_ALMACEN_LITROS	DECIMAL(19,4)
	DECLARE @VP_NIVEL_ALMACEN_LITROS		DECIMAL(19,4)

	SELECT	@VP_CAPACIDAD_ALMACEN_LITROS = 	CAPACIDAD_ALMACEN_LITROS,
			@VP_NIVEL_ALMACEN_LITROS =		NIVEL_ALMACEN_LITROS
											FROM	ALMACEN
											WHERE	K_ALMACEN=@PP_K_ALMACEN
	-- ================================

	IF @VP_CAPACIDAD_ALMACEN_LITROS IS NULL
		BEGIN
		SET @VP_CAPACIDAD_ALMACEN_LITROS	= 0
		SET @VP_NIVEL_ALMACEN_LITROS		= 0
		END

	-- /////////////////////////////////////////////////////////////////////
	

	DECLARE @VP_UTILIZACION_ALMACEN		FLOAT

	IF @VP_CAPACIDAD_ALMACEN_LITROS=0
		SET	@VP_UTILIZACION_ALMACEN = ( 0 )
	ELSE
		SET	@VP_UTILIZACION_ALMACEN = ( @VP_NIVEL_ALMACEN_LITROS/@VP_CAPACIDAD_ALMACEN_LITROS )

	-- ////////////////////////////////////////////////////////////////
		
	UPDATE	ALMACEN
	SET		UTILIZACION_ALMACEN = @VP_UTILIZACION_ALMACEN
	WHERE	K_ALMACEN=@PP_K_ALMACEN
	
	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_ALMACEN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_ALMACEN]
GO


CREATE PROCEDURE [dbo].[PG_LI_ALMACEN]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ==============================================	
	@PP_BUSCAR					VARCHAR(200),
	@PP_K_TIPO_ALMACEN			INT,
	@PP_K_ESTATUS_ALMACEN		INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_ZONA_UO				INT,
	@PP_F_INICIAL				DATE,
	@PP_F_FINAL					DATE
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT = 1
	
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
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	-- =========================================
		
	SELECT	TOP (@VP_LI_N_REGISTROS)
			D_TIEMPO_FECHA AS F_OPERACION_DDMMMYYYY,
			ALMACEN.*,
			CONVERT(DECIMAL(10,0),(ALMACEN.UTILIZACION_ALMACEN*100)) AS UTILIZACION_ALMACEN_100,
			D_TIPO_ALMACEN, D_ESTATUS_ALMACEN, D_UNIDAD_OPERATIVA, D_ZONA_UO,
			S_TIPO_ALMACEN, S_ESTATUS_ALMACEN, S_UNIDAD_OPERATIVA, S_ZONA_UO,
			D_USUARIO AS D_USUARIO_CAMBIO		
			-- =====================
	FROM	ALMACEN, 
			TIPO_ALMACEN, ESTATUS_ALMACEN, 
			UNIDAD_OPERATIVA, ZONA_UO,
			USUARIO, TIEMPO_FECHA					
			-- =====================
	WHERE	ALMACEN.K_TIPO_ALMACEN=TIPO_ALMACEN.K_TIPO_ALMACEN					
	AND		ALMACEN.K_ESTATUS_ALMACEN=ESTATUS_ALMACEN.K_ESTATUS_ALMACEN
	AND		ALMACEN.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		ALMACEN.F_OPERACION=TIEMPO_FECHA.F_TIEMPO_FECHA
	AND		UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=ALMACEN.K_UNIDAD_OPERATIVA
	AND		UNIDAD_OPERATIVA.K_ZONA_UO=ZONA_UO.K_ZONA_UO
			-- =====================
	AND		(		ALMACEN.K_ALMACEN=@VP_K_FOLIO 
				OR	ALMACEN.C_ALMACEN						LIKE '%'+@PP_BUSCAR+'%' 
				OR	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA		LIKE '%'+@PP_BUSCAR+'%' 
			)	
			-- =====================
	AND		( @PP_F_INICIAL IS NULL			OR	@PP_F_INICIAL<=F_OPERACION )
	AND		( @PP_F_FINAL IS NULL			OR	F_OPERACION<=@PP_F_FINAL )
			-- =====================
	AND		( @PP_K_TIPO_ALMACEN=-1			OR	ALMACEN.K_TIPO_ALMACEN=@PP_K_TIPO_ALMACEN )
	AND		( @PP_K_ESTATUS_ALMACEN=-1		OR	ALMACEN.K_ESTATUS_ALMACEN=@PP_K_ESTATUS_ALMACEN )
	AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR	ALMACEN.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA )
	AND		( @PP_K_ZONA_UO=-1				OR	ZONA_UO.K_ZONA_UO=@PP_K_ZONA_UO )
	AND		( ALMACEN.L_BORRADO=0			OR	@VP_L_VER_BORRADOS=1 )	
			-- =====================		
	ORDER BY D_UNIDAD_OPERATIVA ASC, D_ALMACEN ASC
			
	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_ALMACEN]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_ALMACEN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_ALMACEN]
GO


CREATE PROCEDURE [dbo].[PG_SK_ALMACEN]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_ALMACEN	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''
	
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

	DECLARE @VP_LI_N_REGISTROS		[INT] = 100

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	-- =========================================
		
	SELECT	TOP (@VP_LI_N_REGISTROS)
			ALMACEN.*, 
			CONVERT(DECIMAL(10,0),(ALMACEN.UTILIZACION_ALMACEN*100)) AS UTILIZACION_ALMACEN_100,
			TIPO_ALMACEN.D_TIPO_ALMACEN, ESTATUS_ALMACEN.D_ESTATUS_ALMACEN, 
			UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA, 
			D_USUARIO AS D_USUARIO_CAMBIO		
			-- =====================
	FROM	ALMACEN, 
			TIPO_ALMACEN, ESTATUS_ALMACEN, 
			UNIDAD_OPERATIVA, 
			USUARIO					
			-- =====================
	WHERE	ALMACEN.K_TIPO_ALMACEN=TIPO_ALMACEN.K_TIPO_ALMACEN					
	AND		ALMACEN.K_ESTATUS_ALMACEN=ESTATUS_ALMACEN.K_ESTATUS_ALMACEN
	AND		ALMACEN.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND		ALMACEN.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		ALMACEN.K_ALMACEN=@PP_K_ALMACEN
		
	-----////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_ALMACEN]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_ALMACEN, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_ALMACEN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_ALMACEN]
GO


CREATE PROCEDURE [dbo].[PG_IN_ALMACEN]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_D_ALMACEN					[VARCHAR] (100),
	@PP_K_TIPO_ALMACEN				INT,	
	@PP_K_ESTATUS_ALMACEN			INT,
	@PP_F_OPERACION					DATE,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_C_ALMACEN					[VARCHAR] (255),
	@PP_CAPACIDAD_ALMACEN_LITROS	DECIMAL(19,4),
	@PP_NIVEL_ALMACEN_LITROS		DECIMAL(19,4)
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_ALMACEN				INT = 0
	
	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'ALMACEN', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_ALMACEN			OUTPUT
	-- ==================================

	DECLARE @VP_O_ALMACEN				INT = 0

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ALMACEN_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@VP_K_ALMACEN,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		INSERT INTO ALMACEN
			(	[K_ALMACEN], [D_ALMACEN],
				[K_TIPO_ALMACEN], [K_ESTATUS_ALMACEN],
				-- ============================================
				[F_OPERACION], 
				[K_UNIDAD_OPERATIVA], [C_ALMACEN],
				[CAPACIDAD_ALMACEN_LITROS], [NIVEL_ALMACEN_LITROS],		
				[UTILIZACION_ALMACEN],	
				-- ============================================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_ALMACEN, @PP_D_ALMACEN,
				@PP_K_TIPO_ALMACEN, @PP_K_ESTATUS_ALMACEN,
				-- ============================================
				@PP_F_OPERACION, 
				@PP_K_UNIDAD_OPERATIVA, @PP_C_ALMACEN,
				@PP_CAPACIDAD_ALMACEN_LITROS, @PP_NIVEL_ALMACEN_LITROS, 	
				0,	
				-- ============================================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )

		-- ////////////////////////////////////////////////////////////////
		
		EXECUTE [dbo].[PG_UP_ALMACEN_UTILIZACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@VP_K_ALMACEN
			
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [ALMACEN]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#AL.'+CONVERT(VARCHAR(10),@VP_K_ALMACEN)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_ALMACEN AS CLAVE
	
	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_ALMACEN]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_ALMACEN, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_ALMACEN, '', 0.00, 0.00,
													0, 0, @PP_C_ALMACEN, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_ALMACEN', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ALMACEN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_ALMACEN]
GO

CREATE PROCEDURE [dbo].[PG_UP_ALMACEN]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_ALMACEN					INT,	
	@PP_D_ALMACEN					[VARCHAR] (100),
	@PP_K_TIPO_ALMACEN				INT,	
	@PP_K_ESTATUS_ALMACEN			INT,
	@PP_F_OPERACION					DATE,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_C_ALMACEN					[VARCHAR] (255),
	@PP_CAPACIDAD_ALMACEN_LITROS	DECIMAL(19,4),
	@PP_NIVEL_ALMACEN_LITROS		DECIMAL(19,4)
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ALMACEN_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_ALMACEN, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	ALMACEN
		SET		
				[K_TIPO_ALMACEN]			= @PP_K_TIPO_ALMACEN, 
				[D_ALMACEN]					= @PP_D_ALMACEN,
				[K_ESTATUS_ALMACEN]			= @PP_K_ESTATUS_ALMACEN,
				[F_OPERACION]				= @PP_F_OPERACION,
				[K_UNIDAD_OPERATIVA]		= @PP_K_UNIDAD_OPERATIVA,
				[C_ALMACEN]					= @PP_C_ALMACEN,
				[CAPACIDAD_ALMACEN_LITROS]	= @PP_CAPACIDAD_ALMACEN_LITROS,
				[NIVEL_ALMACEN_LITROS]		= @PP_NIVEL_ALMACEN_LITROS,
				-- ===========================
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION, 
				[F_CAMBIO]					= GETDATE() 
		WHERE	K_ALMACEN=@PP_K_ALMACEN

		-- ////////////////////////////////////////////////////////////////
		
		EXECUTE [dbo].[PG_UP_ALMACEN_UTILIZACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_ALMACEN
				
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [ALMACEN]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#AL.'+CONVERT(VARCHAR(10),@PP_K_ALMACEN)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ALMACEN AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_ALMACEN]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_ALMACEN, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_ALMACEN, '', 0.00, 0.00,
													0, 0, @PP_C_ALMACEN, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_ALMACEN', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_ALMACEN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_ALMACEN]
GO


CREATE PROCEDURE [dbo].[PG_DL_ALMACEN]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_ALMACEN				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ALMACEN_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_ALMACEN, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	ALMACEN
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_ALMACEN=@PP_K_ALMACEN

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [ALMACEN]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#AL.'+CONVERT(VARCHAR(10),@PP_K_ALMACEN)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ALMACEN AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_ALMACEN]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_ALMACEN, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
