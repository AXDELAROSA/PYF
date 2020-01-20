-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			SP_Gasto_Viaje_20181119_DPR.sql
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			CONTROL DE VIAJES - GASTO_VIAJE 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_GASTO_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_GASTO_VIAJE]
GO


CREATE PROCEDURE [dbo].[PG_LI_GASTO_VIAJE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_BUSCAR							VARCHAR(200),
	@PP_K_RUBRO_VIATICO					INT,
	@PP_K_PERSONA						INT,
	-- ===========================
	@PP_K_ZONA_UO						INT,
	@PP_K_RAZON_SOCIAL					INT,
	@PP_K_UNIDAD_OPERATIVA				INT,
	-- ==============================
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
				FECHA.D_TIEMPO_FECHA AS F_GASTO_VIAJE_DDMMMYYYY,
				GASTO_VIAJE.*,
				RUBRO_VIATICO.D_RUBRO_VIATICO, RUBRO_VIATICO.S_RUBRO_VIATICO, 
				VIAJE.D_VIAJE, VIAJE.ORIGEN, VIAJE.DESTINO, VIAJE.MOTIVO,
				D_ESTATUS_VIAJE,S_ESTATUS_VIAJE,
				D_USUARIO AS D_USUARIO_CAMBIO,
				D_PERSONA,
				-- ================================= 
				D_UNIDAD_OPERATIVA, D_TIPO_UO, D_ZONA_UO, D_RAZON_SOCIAL, 
				S_UNIDAD_OPERATIVA, S_TIPO_UO, S_ZONA_UO, S_RAZON_SOCIAL
				-- ================================= 
	FROM		GASTO_VIAJE, 
				TIEMPO_FECHA AS FECHA, 
				RUBRO_VIATICO, VIAJE,ESTATUS_VIAJE,
				USUARIO, VI_UNIDAD_OPERATIVA_CATALOGOS,
				PERSONA
				-- =============================
	WHERE		GASTO_VIAJE.K_RUBRO_VIATICO=RUBRO_VIATICO.K_RUBRO_VIATICO
	AND			GASTO_VIAJE.K_VIAJE=VIAJE.K_VIAJE
	AND			GASTO_VIAJE.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND			GASTO_VIAJE.F_GASTO_VIAJE=FECHA.F_TIEMPO_FECHA
	AND			VIAJE.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
	AND			VIAJE.K_ESTATUS_VIAJE=ESTATUS_VIAJE.K_ESTATUS_VIAJE
	AND			VIAJE.K_PERSONA_RESPONSABLE=PERSONA.K_PERSONA
				-- =============================			
	AND			( @PP_K_ZONA_UO=-1				OR	@PP_K_ZONA_UO=VI_K_ZONA_UO )
	AND			( @PP_K_RAZON_SOCIAL=-1			OR	@PP_K_RAZON_SOCIAL=VI_K_RAZON_SOCIAL )
	AND			( @PP_K_UNIDAD_OPERATIVA=-1		OR	@PP_K_UNIDAD_OPERATIVA=VI_K_UNIDAD_OPERATIVA )
				-- ==============================
	AND			(	GASTO_VIAJE.C_GASTO_VIAJE				LIKE '%'+@PP_BUSCAR+'%' 
				OR	GASTO_VIAJE.MONTO						LIKE '%'+@PP_BUSCAR+'%'
				OR	GASTO_VIAJE.MONTO_AUTORIZADO			LIKE '%'+@PP_BUSCAR+'%'
				OR	VIAJE.D_VIAJE							LIKE '%'+@PP_BUSCAR+'%'
				OR	VIAJE.DESTINO							LIKE '%'+@PP_BUSCAR+'%'
				OR	VIAJE.ORIGEN							LIKE '%'+@PP_BUSCAR+'%'
				OR	D_PERSONA								LIKE '%'+@PP_BUSCAR+'%'
				OR  VIAJE.K_VIAJE=@VP_K_FOLIO
				OR  GASTO_VIAJE.K_GASTO_VIAJE=@VP_K_FOLIO							)
				-- =============================
	AND			( @PP_F_INICIO IS NULL				OR	@PP_F_INICIO<=GASTO_VIAJE.F_GASTO_VIAJE )
	AND			( @PP_F_FIN	IS NULL					OR	@PP_F_FIN>=GASTO_VIAJE.F_GASTO_VIAJE )
				-- =============================	
	AND			( @PP_K_PERSONA=-1					OR  VIAJE.K_PERSONA_RESPONSABLE=@PP_K_PERSONA )
	AND			( @PP_K_RUBRO_VIATICO=-1			OR	GASTO_VIAJE.K_RUBRO_VIATICO=@PP_K_RUBRO_VIATICO )
	AND			( @VP_L_VER_BORRADOS=1				OR	GASTO_VIAJE.L_BORRADO=0 )
				-- =============================
	ORDER BY	K_GASTO_VIAJE	DESC
	
	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_GASTO_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_BUSCAR, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_BUSCAR', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_GASTO_VIAJE_X_K_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_GASTO_VIAJE_X_K_VIAJE]
GO


CREATE PROCEDURE [dbo].[PG_LI_GASTO_VIAJE_X_K_VIAJE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_VIAJE							INT
AS

	DECLARE @VP_MENSAJE					VARCHAR(300) = ''

	DECLARE @VP_L_APLICAR_MAX_ROWS		INT=1
		
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
															1, -- @PP_K_DATA_SISTEMA,	
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_L_VER_BORRADOS		INT		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]					@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- ///////////////////////////////////////////

	IF @PP_K_VIAJE >0
			SELECT		GASTO_VIAJE.[K_VIAJE], GASTO_VIAJE.[K_GASTO_VIAJE], 
						RUBRO_VIATICO.[K_RUBRO_VIATICO], [D_RUBRO_VIATICO],
						[MONTO]
						-- =============================	
			--FROM		GASTO_VIAJE, RUBRO_VIATICO,
			--			USUARIO
			FROM		RUBRO_VIATICO
						LEFT JOIN GASTO_VIAJE 
						ON	RUBRO_VIATICO.K_RUBRO_VIATICO=GASTO_VIAJE.K_RUBRO_VIATICO						
						AND	GASTO_VIAJE.K_VIAJE=@PP_K_VIAJE
						AND	GASTO_VIAJE.L_BORRADO=0
						-- =============================
			--WHERE		GASTO_VIAJE.K_RUBRO_VIATICO=RUBRO_VIATICO.K_RUBRO_VIATICO
			ORDER BY	[O_RUBRO_VIATICO]	ASC	
	ELSE
			SELECT		@PP_K_VIAJE AS [K_VIAJE], -1 AS [K_GASTO_VIAJE], 
						RUBRO_VIATICO.[K_RUBRO_VIATICO], RUBRO_VIATICO.[D_RUBRO_VIATICO],
						0 AS [MONTO]
						-- =============================	
			FROM		RUBRO_VIATICO
						-- =============================
			ORDER BY	[O_RUBRO_VIATICO]	ASC
	
	-- ////////////////////////////////////////////////
/*
	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_PRESUPUESTO_VIAJE_X_K_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_BUSCAR', '', '', ''
*/
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_GASTO_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_GASTO_VIAJE]
GO


CREATE PROCEDURE [dbo].[PG_SK_GASTO_VIAJE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_GASTO_VIAJE				INT
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
				FECHA.D_TIEMPO_FECHA AS F_GASTO_VIAJE_DDMMMYYYY,
				GASTO_VIAJE.*,
				RUBRO_VIATICO.D_RUBRO_VIATICO, RUBRO_VIATICO.S_RUBRO_VIATICO, 
				VIAJE.D_VIAJE, VIAJE.ORIGEN, VIAJE.DESTINO, VIAJE.MOTIVO,
				D_ESTATUS_VIAJE,S_ESTATUS_VIAJE,
				D_USUARIO AS D_USUARIO_CAMBIO,
				-- ================================= 
				D_UNIDAD_OPERATIVA, D_TIPO_UO, D_ZONA_UO, D_RAZON_SOCIAL, 
				S_UNIDAD_OPERATIVA, S_TIPO_UO, S_ZONA_UO, S_RAZON_SOCIAL
				K_UNIDAD_OPERATIVA, K_RAZON_SOCIAL, VI_K_ZONA_UO AS K_ZONA_UO
				-- ================================= 
		FROM	GASTO_VIAJE, 
				TIEMPO_FECHA AS FECHA, 
				RUBRO_VIATICO, VIAJE,ESTATUS_VIAJE,
				USUARIO,
				VI_UNIDAD_OPERATIVA_CATALOGOS
				-- ================================= 
		WHERE	GASTO_VIAJE.K_RUBRO_VIATICO=RUBRO_VIATICO.K_RUBRO_VIATICO
		AND		GASTO_VIAJE.K_VIAJE=VIAJE.K_VIAJE
		AND		GASTO_VIAJE.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
		AND		GASTO_VIAJE.K_GASTO_VIAJE=@PP_K_GASTO_VIAJE
		AND		GASTO_VIAJE.F_GASTO_VIAJE=FECHA.F_TIEMPO_FECHA
		AND		VIAJE.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
		AND		VIAJE.K_ESTATUS_VIAJE=ESTATUS_VIAJE.K_ESTATUS_VIAJE
		

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_GASTO_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_GASTO_VIAJE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_GASTO_VIAJE, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO



	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_GASTO_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_GASTO_VIAJE]
GO


CREATE PROCEDURE [dbo].[PG_IN_GASTO_VIAJE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_VIAJE							INT,
	@PP_K_RUBRO_VIATICO					INT,
	-- ===========================
	@PP_MONTO							DECIMAL(19,4),	
	@PP_C_GASTO_VIAJE					VARCHAR(500)
	
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- ///////////////////////////////////////////////////
	
	DECLARE @VP_K_GASTO_VIAJE			INT = 0

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
														'GASTO_VIAJE', 
														@OU_K_TABLA_DISPONIBLE = @VP_K_GASTO_VIAJE	OUTPUT	
	-- ///////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		INSERT INTO GASTO_VIAJE
			(	[K_GASTO_VIAJE],					
				[K_VIAJE],				[K_RUBRO_VIATICO],					
				-- ===========================
				[F_GASTO_VIAJE],		[MONTO],							
				[MONTO_AUTORIZADO],		[C_GASTO_VIAJE],					
				-- ===========================
				[K_USUARIO_ALTA],		[F_ALTA], 
				[K_USUARIO_CAMBIO],		[F_CAMBIO],
				[L_BORRADO], 
				[K_USUARIO_BAJA],		[F_BAJA]  )
		VALUES	
			(	@VP_K_GASTO_VIAJE,				
				@PP_K_VIAJE,			@PP_K_RUBRO_VIATICO,				
				-- ===========================
				GETDATE(),				@PP_MONTO,							
				@PP_MONTO, 				@PP_C_GASTO_VIAJE,				
				-- ============================
				@PP_K_USUARIO_ACCION,				GETDATE(), 
				@PP_K_USUARIO_ACCION,				GETDATE(),
				0, 
				NULL, NULL		)
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [Gasto de Viaje]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#GaV.'+CONVERT(VARCHAR(10),@VP_K_GASTO_VIAJE)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_GASTO_VIAJE AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_GASTO_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_GASTO_VIAJE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, @PP_C_GASTO_VIAJE, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_GASTO_VIAJE', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_GASTO_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_GASTO_VIAJE]
GO

CREATE PROCEDURE [dbo].[PG_UP_GASTO_VIAJE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_GASTO_VIAJE					INT,
	-- ===========================
	@PP_K_VIAJE							INT,
	@PP_K_RUBRO_VIATICO					INT,
	-- ===========================
	@PP_MONTO							DECIMAL(19,4),	
	@PP_C_GASTO_VIAJE					VARCHAR(500)
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_GASTO_VIAJE_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_GASTO_VIAJE, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	GASTO_VIAJE
		SET		[K_VIAJE]							= @PP_K_VIAJE,
				[K_RUBRO_VIATICO]					= @PP_K_RUBRO_VIATICO,
				-- ===========================
				[F_GASTO_VIAJE]						= GETDATE(),
				[MONTO]								= @PP_MONTO,
				[C_GASTO_VIAJE]						= @PP_C_GASTO_VIAJE,
				-- ====================
				[F_CAMBIO]							= GETDATE(), 
				[K_USUARIO_CAMBIO]					= @PP_K_USUARIO_ACCION
		WHERE	K_GASTO_VIAJE=@PP_K_GASTO_VIAJE
	
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [Gasto de Viaje]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#GaV.'+CONVERT(VARCHAR(10),@PP_K_GASTO_VIAJE)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_GASTO_VIAJE AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_GASTO_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_GASTO_VIAJE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_GASTO_VIAJE, '', 0.00, 0.00,
													0, 0, @PP_C_GASTO_VIAJE, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_GASTO_VIAJE', '', '', ''

	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_GASTO_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_GASTO_VIAJE]
GO


CREATE PROCEDURE [dbo].[PG_DL_GASTO_VIAJE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_GASTO_VIAJE				INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_GASTO_VIAJE_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_GASTO_VIAJE, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	GASTO_VIAJE
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_GASTO_VIAJE=@PP_K_GASTO_VIAJE
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [Gasto de Viaje]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#GaV.'+CONVERT(VARCHAR(10),@PP_K_GASTO_VIAJE)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_GASTO_VIAJE AS CLAVE

	-- //////////////////////////////////////////////////////////////
	
	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_GASTO_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_GASTO_VIAJE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
	
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
