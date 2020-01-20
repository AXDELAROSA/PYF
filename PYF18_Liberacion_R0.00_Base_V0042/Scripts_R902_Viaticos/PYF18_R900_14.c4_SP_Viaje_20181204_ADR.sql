-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			SP_Viaje_20181122_ADR.sql
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			CONTROL DE VIAJES - VIAJE 
-- // OPERACIÓN:		LIBERACIÓN / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			Daniel Portillo Romero
-- // Fecha creación:	17/NOV/2018
-- //////////////////////////////////////////////////////////////  

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_VIAJE]
GO


CREATE PROCEDURE [dbo].[PG_LI_VIAJE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_BUSCAR							VARCHAR(200),
	@PP_K_AUTORIZACION					INT,
	@PP_K_RAZON_SOCIAL					INT,
	@PP_K_UNIDAD_OPERATIVA				INT,
	@PP_K_ESTATUS_VIAJE					INT,
	@PP_K_PERSONA_RESPONSABLE			INT,
	-- ===========================
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
				TIEMPO_INICIO_TENTATIVO.D_TIEMPO_FECHA	AS F_INICIO_TENTATIVO_DDMMMYYYY,
				TIEMPO_INICIO_REAL.D_TIEMPO_FECHA		AS F_INICIO_REAL_DDMMMYYYY,
				TIEMPO_FINAL_TENTATIVO.D_TIEMPO_FECHA	AS F_FINAL_TENTATIVO_DDMMMYYYY,
				TIEMPO_FINAL_REAL.D_TIEMPO_FECHA		AS F_FINAL_REAL_DDMMMYYYY,
				VIAJE.*,
				AUTORIZACION.D_AUTORIZACION,			AUTORIZACION.S_AUTORIZACION,
				RAZON_SOCIAL.D_RAZON_SOCIAL,			RAZON_SOCIAL.S_RAZON_SOCIAL,
				UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA,	UNIDAD_OPERATIVA.S_UNIDAD_OPERATIVA,
				ESTATUS_VIAJE.D_ESTATUS_VIAJE,			ESTATUS_VIAJE.S_ESTATUS_VIAJE,
				PERSONA.D_PERSONA,
				D_USUARIO AS D_USUARIO_CAMBIO
				-- =============================
	FROM		VIAJE, 
				TIEMPO_FECHA AS TIEMPO_INICIO_TENTATIVO,
				TIEMPO_FECHA AS TIEMPO_INICIO_REAL,
				TIEMPO_FECHA AS TIEMPO_FINAL_TENTATIVO,
				TIEMPO_FECHA AS TIEMPO_FINAL_REAL,
				AUTORIZACION,RAZON_SOCIAL,UNIDAD_OPERATIVA,
				ESTATUS_VIAJE,PERSONA,USUARIO
				-- =============================
	WHERE		VIAJE.K_AUTORIZACION=AUTORIZACION.K_AUTORIZACION
	AND			VIAJE.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL
	AND			VIAJE.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND			VIAJE.K_ESTATUS_VIAJE=ESTATUS_VIAJE.K_ESTATUS_VIAJE
	AND			VIAJE.K_PERSONA_RESPONSABLE=PERSONA.K_PERSONA
	AND			VIAJE.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND			VIAJE.F_INICIO_TENTATIVO=TIEMPO_INICIO_TENTATIVO.F_TIEMPO_FECHA
	AND			VIAJE.F_INICIO_REAL=TIEMPO_INICIO_REAL.F_TIEMPO_FECHA
	AND			VIAJE.F_FINAL_TENTATIVO=TIEMPO_FINAL_TENTATIVO.F_TIEMPO_FECHA
	AND			VIAJE.F_FINAL_REAL=TIEMPO_FINAL_REAL.F_TIEMPO_FECHA
				-- =============================
	AND			(	VIAJE.D_VIAJE							LIKE '%'+@PP_BUSCAR+'%'
				OR	VIAJE.ORIGEN							LIKE '%'+@PP_BUSCAR+'%' 
				OR	VIAJE.DESTINO							LIKE '%'+@PP_BUSCAR+'%'
				OR	VIAJE.MOTIVO							LIKE '%'+@PP_BUSCAR+'%'
				OR	PERSONA.D_PERSONA						LIKE '%'+@PP_BUSCAR+'%'
				OR	AUTORIZACION.D_AUTORIZACION				LIKE '%'+@PP_BUSCAR+'%'
				OR	RAZON_SOCIAL.D_RAZON_SOCIAL				LIKE '%'+@PP_BUSCAR+'%'
				OR	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA		LIKE '%'+@PP_BUSCAR+'%'
				OR  VIAJE.K_VIAJE=@VP_K_FOLIO										)
				-- =====================
	AND			( @PP_F_INICIO IS NULL				OR	@PP_F_INICIO<=VIAJE.F_INICIO_REAL )
	AND			( @PP_F_FIN	IS NULL					OR	@PP_F_FIN>=VIAJE.F_FINAL_REAL )
				-- =============================	
	AND			( @PP_K_AUTORIZACION=-1				OR	VIAJE.K_AUTORIZACION=@PP_K_AUTORIZACION )
	AND			( @PP_K_RAZON_SOCIAL=-1				OR	VIAJE.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL )
	AND			( @PP_K_UNIDAD_OPERATIVA=-1			OR	VIAJE.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA )
	AND			( @PP_K_ESTATUS_VIAJE=-1			OR	VIAJE.K_ESTATUS_VIAJE=@PP_K_ESTATUS_VIAJE )
	AND			( @PP_K_PERSONA_RESPONSABLE=-1		OR	VIAJE.K_PERSONA_RESPONSABLE=@PP_K_PERSONA_RESPONSABLE )
	AND			( @VP_L_VER_BORRADOS=1				OR	VIAJE.L_BORRADO=0 )
				-- =============================
	ORDER BY	K_VIAJE	DESC
	
	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_VIAJE]
GO


CREATE PROCEDURE [dbo].[PG_SK_VIAJE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VIAJE						INT
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
				TIEMPO_INICIO_TENTATIVO.D_TIEMPO_FECHA	AS F_INICIO_TENTATIVO_DDMMMYYYY,
				TIEMPO_INICIO_REAL.D_TIEMPO_FECHA		AS F_INICIO_REAL_DDMMMYYYY,
				TIEMPO_FINAL_TENTATIVO.D_TIEMPO_FECHA	AS F_FINAL_TENTATIVO_DDMMMYYYY,
				TIEMPO_FINAL_REAL.D_TIEMPO_FECHA		AS F_FINAL_REAL_DDMMMYYYY,
				VIAJE.*,
				AUTORIZACION.D_AUTORIZACION,			AUTORIZACION.S_AUTORIZACION,
				RAZON_SOCIAL.D_RAZON_SOCIAL,			RAZON_SOCIAL.S_RAZON_SOCIAL,
				UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA,	UNIDAD_OPERATIVA.S_UNIDAD_OPERATIVA,
				ESTATUS_VIAJE.D_ESTATUS_VIAJE,			ESTATUS_VIAJE.S_ESTATUS_VIAJE,
				PERSONA.D_PERSONA,
				D_USUARIO AS D_USUARIO_CAMBIO
				-- =====================
		FROM	VIAJE, 
				TIEMPO_FECHA AS TIEMPO_INICIO_TENTATIVO,
				TIEMPO_FECHA AS TIEMPO_INICIO_REAL,
				TIEMPO_FECHA AS TIEMPO_FINAL_TENTATIVO,
				TIEMPO_FECHA AS TIEMPO_FINAL_REAL, 
				ESTATUS_VIAJE, AUTORIZACION,
				RAZON_SOCIAL, UNIDAD_OPERATIVA,
				PERSONA,USUARIO
				-- =====================
		WHERE	VIAJE.K_AUTORIZACION=AUTORIZACION.K_AUTORIZACION
		AND		VIAJE.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL
		AND		VIAJE.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
		AND		VIAJE.K_ESTATUS_VIAJE=ESTATUS_VIAJE.K_ESTATUS_VIAJE
		AND		VIAJE.K_PERSONA_RESPONSABLE=PERSONA.K_PERSONA
		AND		VIAJE.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
		AND		VIAJE.F_INICIO_TENTATIVO=TIEMPO_INICIO_TENTATIVO.F_TIEMPO_FECHA
		AND		VIAJE.F_INICIO_REAL=TIEMPO_INICIO_REAL.F_TIEMPO_FECHA
		AND		VIAJE.F_FINAL_TENTATIVO=TIEMPO_FINAL_TENTATIVO.F_TIEMPO_FECHA
		AND		VIAJE.F_FINAL_REAL=TIEMPO_FINAL_REAL.F_TIEMPO_FECHA
		AND		VIAJE.K_VIAJE=@PP_K_VIAJE
		

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_VIAJE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_VIAJE, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO



	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_VIAJE]
GO


CREATE PROCEDURE [dbo].[PG_IN_VIAJE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_AUTORIZACION				INT,
	@PP_K_RAZON_SOCIAL				INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_ESTATUS_VIAJE				INT,
	@PP_K_PERSONA_RESPONSABLE		INT,
	-- ===========================
	@PP_D_VIAJE						VARCHAR(100),
	@PP_ORIGEN						VARCHAR(100),
	@PP_DESTINO						VARCHAR(100),
	@PP_MOTIVO						VARCHAR(100),
	-- ===========================
	@PP_F_INICIO					DATE,
	@PP_F_FINAL						DATE
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- ///////////////////////////////////////////////////
	
	DECLARE @VP_K_VIAJE			INT = 0

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
														'VIAJE', 
														@OU_K_TABLA_DISPONIBLE = @VP_K_VIAJE	OUTPUT	
	
	-- ///////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN

		INSERT INTO VIAJE
			(	[K_VIAJE],					 
				[K_AUTORIZACION],			[K_RAZON_SOCIAL],			
				[K_UNIDAD_OPERATIVA],		[K_ESTATUS_VIAJE],
				[K_PERSONA_RESPONSABLE],			
				-- ===========================
				[D_VIAJE],					[ORIGEN],			
				[DESTINO],					[MOTIVO],
				-- ===========================
				[F_INICIO_TENTATIVO],		[F_INICIO_REAL],
				[F_FINAL_TENTATIVO],		[F_FINAL_REAL],
				-- ===========================
				[K_USUARIO_ALTA],			[F_ALTA], 
				[K_USUARIO_CAMBIO],			[F_CAMBIO],
				[L_BORRADO], 
				[K_USUARIO_BAJA],			[F_BAJA]  )
		VALUES	
			(	@VP_K_VIAJE,				
				@PP_K_AUTORIZACION, 		@PP_K_RAZON_SOCIAL,					
				@PP_K_UNIDAD_OPERATIVA, 	@PP_K_ESTATUS_VIAJE,
				@PP_K_PERSONA_RESPONSABLE,
				-- ===========================
				@PP_D_VIAJE,				@PP_ORIGEN, 
				@PP_DESTINO,				@PP_MOTIVO,
				-- ============================
				@PP_F_INICIO,				@PP_F_INICIO,
				@PP_F_FINAL,				@PP_F_FINAL,
				-- ============================
				@PP_K_USUARIO_ACCION,		GETDATE(), 
				@PP_K_USUARIO_ACCION,		GETDATE(),
				0, 
				NULL,						NULL		)
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [Viaje]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Vi.'+CONVERT(VARCHAR(10),@VP_K_VIAJE)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_VIAJE AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_VIAJE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, @PP_D_VIAJE, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_VIAJE', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_VIAJE]
GO

CREATE PROCEDURE [dbo].[PG_UP_VIAJE]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_VIAJE					INT,
	-- ===========================
	@PP_K_AUTORIZACION			INT,
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_ESTATUS_VIAJE			INT,
	@PP_K_PERSONA_RESPONSABLE	INT,
	-- ===========================
	@PP_D_VIAJE					VARCHAR(100),
	@PP_ORIGEN					VARCHAR(100),
	@PP_DESTINO					VARCHAR(100),
	@PP_MOTIVO					VARCHAR(100),
	-- ===========================
	@PP_F_INICIO				DATE,
	@PP_F_FINAL					DATE
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_VIAJE_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_VIAJE, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	--IF @VP_MENSAJE=''
	--	EXECUTE [PG_RN_PASAJERO_VIAJE_EXISTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
	--											@PP_K_VIAJE, @PP_K_PERSONA_RESPONSABLE,
	--											@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	VIAJE
		SET		[K_AUTORIZACION]			= @PP_K_AUTORIZACION,
				[K_RAZON_SOCIAL]			= @PP_K_RAZON_SOCIAL,
				[K_UNIDAD_OPERATIVA]		= @PP_K_UNIDAD_OPERATIVA,
				[K_ESTATUS_VIAJE]			= @PP_K_ESTATUS_VIAJE,
				[K_PERSONA_RESPONSABLE]		= @PP_K_PERSONA_RESPONSABLE,
				-- ===============================
				[D_VIAJE]					= @PP_D_VIAJE,
				[ORIGEN]					= @PP_ORIGEN,
				[DESTINO]					= @PP_DESTINO,
				[MOTIVO]					= @PP_MOTIVO,
				-- ===============================	
				[F_INICIO_REAL]				= @PP_F_INICIO,
				[F_FINAL_REAL]				= @PP_F_FINAL,
				-- ===============================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION
		WHERE	K_VIAJE=@PP_K_VIAJE
	
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [Viaje]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Vi.'+CONVERT(VARCHAR(10),@PP_K_VIAJE)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_VIAJE AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_VIAJE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_VIAJE, '', 0.00, 0.00,
													0, 0, @PP_D_VIAJE, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_VIAJE', '', '', ''

	-- //////////////////////////////////////////////////////////////
	
GO





-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
