-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			SP_Recurso_Viaje_20181119_DPR.sql
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			CONTROL DE VIAJES - RECURSO_VIAJE 
-- // OPERACIÓN:		LIBERACIÓN / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			Daniel Portillo Romero
-- // Fecha creación:	19/NOV/2018
-- //////////////////////////////////////////////////////////////  

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_RECURSO_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_RECURSO_VIAJE]
GO


CREATE PROCEDURE [dbo].[PG_LI_RECURSO_VIAJE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_BUSCAR							VARCHAR(200),
	@PP_K_TIPO_RECURSO_VIAJE			INT,
	@PP_K_VIAJE							INT,
	-- ===========================
	@PP_K_ZONA_UO						INT,
	@PP_K_RAZON_SOCIAL					INT,
	@PP_K_UNIDAD_OPERATIVA				INT,
	-- ===========================
	@PP_K_CUENTA_BANCO					INT,
	@PP_F_INICIO						DATE,
	@PP_F_FIN							DATE
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
				FECHA.D_TIEMPO_FECHA AS F_RECURSO_VIAJE_DDMMMYYYY,
				RECURSO_VIAJE.*,
				TIPO_RECURSO_VIAJE.D_TIPO_RECURSO_VIAJE, TIPO_RECURSO_VIAJE.S_TIPO_RECURSO_VIAJE, 
				VIAJE.D_VIAJE, VIAJE.ORIGEN, VIAJE.DESTINO, VIAJE.MOTIVO,
				CUENTA_BANCO.D_CUENTA_BANCO, CUENTA_BANCO.S_CUENTA_BANCO,
				D_USUARIO AS D_USUARIO_CAMBIO, D_PERSONA,
				-- =============================
				D_UNIDAD_OPERATIVA, D_TIPO_UO, D_ZONA_UO, D_RAZON_SOCIAL, 
				S_UNIDAD_OPERATIVA, S_TIPO_UO, S_ZONA_UO, S_RAZON_SOCIAL
				-- ================================= 	
	FROM		RECURSO_VIAJE, 
				TIEMPO_FECHA AS FECHA,
				TIPO_RECURSO_VIAJE, VIAJE,
				VI_UNIDAD_OPERATIVA_CATALOGOS, CUENTA_BANCO,
				USUARIO,PERSONA
				-- =============================
	WHERE		RECURSO_VIAJE.K_TIPO_RECURSO_VIAJE=TIPO_RECURSO_VIAJE.K_TIPO_RECURSO_VIAJE
	AND			RECURSO_VIAJE.K_VIAJE=VIAJE.K_VIAJE
	AND			RECURSO_VIAJE.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
	AND			RECURSO_VIAJE.K_CUENTA_BANCO=CUENTA_BANCO.K_CUENTA_BANCO
	AND			RECURSO_VIAJE.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND			RECURSO_VIAJE.F_RECURSO_VIAJE=FECHA.F_TIEMPO_FECHA
	AND			VIAJE.K_PERSONA_RESPONSABLE=PERSONA.K_PERSONA
				-- =============================
	AND			( @PP_K_ZONA_UO=-1				OR	@PP_K_ZONA_UO=VI_K_ZONA_UO )
	AND			( @PP_K_RAZON_SOCIAL=-1			OR	@PP_K_RAZON_SOCIAL=VI_K_RAZON_SOCIAL )
	AND			( @PP_K_UNIDAD_OPERATIVA=-1		OR	@PP_K_UNIDAD_OPERATIVA=VI_K_UNIDAD_OPERATIVA )
				-- =============================
	AND			(	RECURSO_VIAJE.D_RECURSO_VIAJE				LIKE '%'+@PP_BUSCAR+'%'
				OR	RECURSO_VIAJE.C_RECURSO_VIAJE				LIKE '%'+@PP_BUSCAR+'%' 
				OR	RECURSO_VIAJE.MONTO							LIKE '%'+@PP_BUSCAR+'%'
				OR	VIAJE.D_VIAJE								LIKE '%'+@PP_BUSCAR+'%'
				OR	VIAJE.DESTINO								LIKE '%'+@PP_BUSCAR+'%'
				OR	VIAJE.ORIGEN								LIKE '%'+@PP_BUSCAR+'%'
				OR	PERSONA.D_PERSONA							LIKE '%'+@PP_BUSCAR+'%'
				OR	D_RAZON_SOCIAL								LIKE '%'+@PP_BUSCAR+'%'
				OR	D_UNIDAD_OPERATIVA							LIKE '%'+@PP_BUSCAR+'%'
				OR	CUENTA_BANCO.D_CUENTA_BANCO					LIKE '%'+@PP_BUSCAR+'%'
				OR  RECURSO_VIAJE.K_RECURSO_VIAJE=@VP_K_FOLIO
				OR  VIAJE.K_VIAJE=@VP_K_FOLIO
				OR  RECURSO_VIAJE.K_RECURSO_VIAJE=@VP_K_FOLIO							)
				-- =============================
	AND			( @PP_F_INICIO IS NULL				OR	@PP_F_INICIO<=RECURSO_VIAJE.F_RECURSO_VIAJE )
	AND			( @PP_F_FIN	IS NULL					OR	@PP_F_FIN>=RECURSO_VIAJE.F_RECURSO_VIAJE )
				-- =============================	
	AND			( @PP_K_TIPO_RECURSO_VIAJE=-1		OR	RECURSO_VIAJE.K_TIPO_RECURSO_VIAJE=@PP_K_TIPO_RECURSO_VIAJE )
	AND			( @PP_K_VIAJE=-1					OR	RECURSO_VIAJE.K_VIAJE=@PP_K_VIAJE )
	AND			( @PP_K_CUENTA_BANCO=-1				OR	RECURSO_VIAJE.K_CUENTA_BANCO=@PP_K_CUENTA_BANCO )
	AND			( @VP_L_VER_BORRADOS=1				OR	RECURSO_VIAJE.L_BORRADO=0 )
				-- =============================
	ORDER BY	K_RECURSO_VIAJE	DESC
	
	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_RECURSO_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_RECURSO_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_RECURSO_VIAJE]
GO


CREATE PROCEDURE [dbo].[PG_SK_RECURSO_VIAJE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_RECURSO_VIAJE				INT
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
			
	SELECT		TOP (@VP_LI_N_REGISTROS)
				FECHA.D_TIEMPO_FECHA AS F_RECURSO_VIAJE_DDMMMYYYY,
				RECURSO_VIAJE.*,
				TIPO_RECURSO_VIAJE.D_TIPO_RECURSO_VIAJE, TIPO_RECURSO_VIAJE.S_TIPO_RECURSO_VIAJE, 
				VIAJE.D_VIAJE, VIAJE.ORIGEN, VIAJE.DESTINO, VIAJE.MOTIVO,
				CUENTA_BANCO.D_CUENTA_BANCO, CUENTA_BANCO.S_CUENTA_BANCO,
				D_USUARIO AS D_USUARIO_CAMBIO, D_PERSONA,
				-- =============================
				D_UNIDAD_OPERATIVA, D_TIPO_UO, D_ZONA_UO, D_RAZON_SOCIAL, 
				S_UNIDAD_OPERATIVA, S_TIPO_UO, S_ZONA_UO, S_RAZON_SOCIAL
				-- ================================= 	
	FROM		RECURSO_VIAJE, 
				TIEMPO_FECHA AS FECHA,
				TIPO_RECURSO_VIAJE, VIAJE,
				VI_UNIDAD_OPERATIVA_CATALOGOS, CUENTA_BANCO,
				USUARIO,PERSONA
				-- =============================
	WHERE		RECURSO_VIAJE.K_TIPO_RECURSO_VIAJE=TIPO_RECURSO_VIAJE.K_TIPO_RECURSO_VIAJE
	AND			RECURSO_VIAJE.K_VIAJE=VIAJE.K_VIAJE
	AND			RECURSO_VIAJE.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
	AND			RECURSO_VIAJE.K_CUENTA_BANCO=CUENTA_BANCO.K_CUENTA_BANCO
	AND			RECURSO_VIAJE.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND			RECURSO_VIAJE.F_RECURSO_VIAJE=FECHA.F_TIEMPO_FECHA
	AND			VIAJE.K_PERSONA_RESPONSABLE=PERSONA.K_PERSONA
	AND			RECURSO_VIAJE.K_RECURSO_VIAJE=@PP_K_RECURSO_VIAJE
		

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_RECURSO_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_RECURSO_VIAJE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_RECURSO_VIAJE, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO



	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_RECURSO_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_RECURSO_VIAJE]
GO


CREATE PROCEDURE [dbo].[PG_IN_RECURSO_VIAJE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_D_RECURSO_VIAJE					VARCHAR(255),
	@PP_C_RECURSO_VIAJE					VARCHAR(500),
	@PP_MONTO							DECIMAL(19,4),	
	@PP_F_RECURSO_VIAJE					DATE,
	-- ===========================
	@PP_K_TIPO_RECURSO_VIAJE			INT,
	@PP_K_VIAJE							INT,
	-- ===========================
	@PP_K_RAZON_SOCIAL					INT,
	@PP_K_UNIDAD_OPERATIVA				INT,
	@PP_K_CUENTA_BANCO					INT
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- ///////////////////////////////////////////////////
	
	DECLARE @VP_K_RECURSO_VIAJE			INT = 0

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
														'RECURSO_VIAJE', 
														@OU_K_TABLA_DISPONIBLE = @VP_K_RECURSO_VIAJE	OUTPUT	
	-- ///////////////////////////////////////////////////
	
	--IF @VP_MENSAJE=''
	--	EXECUTE [dbo].[PG_RN_RECURSO_VIAJE_UNIQUE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
	--													@VP_K_RECURSO_VIAJE, 
	--													@PP_D_RECURSO_VIAJE, @PP_RFC_RECURSO_VIAJE,
	--													@OU_RESULTADO_VALIDACION = @VP_MENSAJE				OUTPUT	
		-- ///////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		INSERT INTO RECURSO_VIAJE
			(	[K_RECURSO_VIAJE],					[D_RECURSO_VIAJE], 
				[C_RECURSO_VIAJE],					[MONTO],
				[F_RECURSO_VIAJE], 
				-- ===========================
				[K_TIPO_RECURSO_VIAJE],				[K_VIAJE],	
				-- ===========================
				[K_RAZON_SOCIAL],					[K_UNIDAD_OPERATIVA],
				[K_CUENTA_BANCO],
				-- ===========================
				[K_USUARIO_ALTA],					[F_ALTA], 
				[K_USUARIO_CAMBIO],					[F_CAMBIO],
				[L_BORRADO], 
				[K_USUARIO_BAJA],					[F_BAJA]  )
		VALUES	
			(	@VP_K_RECURSO_VIAJE,				@PP_D_RECURSO_VIAJE, 
				@PP_C_RECURSO_VIAJE,				@PP_MONTO, 
				@PP_F_RECURSO_VIAJE,
				-- ===========================
				@PP_K_TIPO_RECURSO_VIAJE,			@PP_K_VIAJE, 
				-- ===========================
				@PP_K_RAZON_SOCIAL, 				@PP_K_UNIDAD_OPERATIVA,	
				@PP_K_CUENTA_BANCO,		
				-- ============================
				@PP_K_USUARIO_ACCION,				GETDATE(), 
				@PP_K_USUARIO_ACCION,				GETDATE(),
				0, 
				NULL,								NULL		)
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [Recurso de Viaje]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#ReV.'+CONVERT(VARCHAR(10),@VP_K_RECURSO_VIAJE)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_RECURSO_VIAJE AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_RECURSO_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_RECURSO_VIAJE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, @PP_C_RECURSO_VIAJE, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_RECURSO_VIAJE', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_RECURSO_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_RECURSO_VIAJE]
GO

CREATE PROCEDURE [dbo].[PG_UP_RECURSO_VIAJE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_RECURSO_VIAJE					INT,
	-- ===========================
	@PP_D_RECURSO_VIAJE					VARCHAR(255),
	@PP_C_RECURSO_VIAJE					VARCHAR(500),
	@PP_MONTO							DECIMAL(19,4),	
	@PP_F_RECURSO_VIAJE					DATE,
	-- ===========================
	@PP_K_TIPO_RECURSO_VIAJE			INT,
	@PP_K_VIAJE							INT,
	-- ===========================
	@PP_K_RAZON_SOCIAL					INT,
	@PP_K_UNIDAD_OPERATIVA				INT,
	@PP_K_CUENTA_BANCO					INT
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RECURSO_VIAJE_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_RECURSO_VIAJE, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	--IF @VP_MENSAJE=''
	--	EXECUTE [dbo].[PG_RN_RECURSO_VIAJE_UNIQUE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
	--														@PP_K_RECURSO_VIAJE, 
	--														@PP_D_RECURSO_VIAJE, @PP_RFC_RECURSO_VIAJE,
	--														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	RECURSO_VIAJE
		SET		[D_RECURSO_VIAJE]					= @PP_D_RECURSO_VIAJE,
				[C_RECURSO_VIAJE]					= @PP_C_RECURSO_VIAJE,
				[MONTO]								= @PP_MONTO,
				[F_RECURSO_VIAJE]					= @PP_F_RECURSO_VIAJE,
				-- ===========================
				[K_TIPO_RECURSO_VIAJE]				= @PP_K_TIPO_RECURSO_VIAJE,
				[K_VIAJE]							= @PP_K_VIAJE,
				-- ===========================
				[K_RAZON_SOCIAL]					= @PP_K_RAZON_SOCIAL, 
				[K_UNIDAD_OPERATIVA]				= @PP_K_UNIDAD_OPERATIVA,
				[K_CUENTA_BANCO]					= @PP_K_CUENTA_BANCO,
				-- ====================
				[F_CAMBIO]							= GETDATE(), 
				[K_USUARIO_CAMBIO]					= @PP_K_USUARIO_ACCION
		WHERE	K_RECURSO_VIAJE=@PP_K_RECURSO_VIAJE
	
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [Recurso de Viaje]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#ReV.'+CONVERT(VARCHAR(10),@PP_K_RECURSO_VIAJE)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_RECURSO_VIAJE AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_RECURSO_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_RECURSO_VIAJE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_RECURSO_VIAJE, '', 0.00, 0.00,
													0, 0, @PP_C_RECURSO_VIAJE, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_RECURSO_VIAJE', '', '', ''

	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_RECURSO_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_RECURSO_VIAJE]
GO


CREATE PROCEDURE [dbo].[PG_DL_RECURSO_VIAJE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_RECURSO_VIAJE				INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RECURSO_VIAJE_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_RECURSO_VIAJE, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	RECURSO_VIAJE
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_RECURSO_VIAJE=@PP_K_RECURSO_VIAJE
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [Recurso de Viaje]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#ReV.'+CONVERT(VARCHAR(10),@PP_K_RECURSO_VIAJE)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_RECURSO_VIAJE AS CLAVE

	-- //////////////////////////////////////////////////////////////
	
	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_RECURSO_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_RECURSO_VIAJE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
	
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
