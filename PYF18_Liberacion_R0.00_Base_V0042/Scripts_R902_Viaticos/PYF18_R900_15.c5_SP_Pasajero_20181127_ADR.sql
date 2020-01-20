-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			SP_Pasajero_20181119_DPR.sql
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			CONTROL DE VIAJES - PASAJERO 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PASAJERO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PASAJERO]
GO


CREATE PROCEDURE [dbo].[PG_LI_PASAJERO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_BUSCAR							VARCHAR(200),
	@PP_K_VIAJE							INT,
	@PP_K_PERSONA						INT
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
				PASAJERO.*, PERSONA.D_PERSONA, PERSONA.PUESTO,
				VIAJE.D_VIAJE,	PERSONA_RESPONSABLE.D_PERSONA AS D_PERSONA_RESPONSABLE,
				D_USUARIO AS D_USUARIO_CAMBIO
				-- =============================	
	FROM		PASAJERO, PERSONA,
				PERSONA AS PERSONA_RESPONSABLE, VIAJE,
				USUARIO
				-- =============================
	WHERE		PASAJERO.K_PERSONA=PERSONA.K_PERSONA
	AND			PASAJERO.K_VIAJE=VIAJE.K_VIAJE
	AND			VIAJE.K_PERSONA_RESPONSABLE=PERSONA_RESPONSABLE.K_PERSONA
	AND			PASAJERO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
				-- =============================
	AND			(	PERSONA.D_PERSONA						LIKE '%'+@PP_BUSCAR+'%'
				OR	PERSONA.PUESTO							LIKE '%'+@PP_BUSCAR+'%' 
				OR	PERSONA.DEPARTAMENTO					LIKE '%'+@PP_BUSCAR+'%'
				OR	PERSONA.JEFE_INMEDIATO					LIKE '%'+@PP_BUSCAR+'%'
				OR	VIAJE.D_VIAJE							LIKE '%'+@PP_BUSCAR+'%'
				OR  PASAJERO.K_PERSONA=@VP_K_FOLIO
				OR  PASAJERO.K_VIAJE=@VP_K_FOLIO									)
				-- =============================
	AND			( @PP_K_PERSONA=-1				OR	PASAJERO.K_PERSONA=@PP_K_PERSONA )
	AND			( @PP_K_VIAJE=-1				OR	PASAJERO.K_VIAJE=@PP_K_VIAJE )
	AND			( @VP_L_VER_BORRADOS=1			OR	PASAJERO.L_BORRADO=0 )
				-- =============================
	ORDER BY	K_PERSONA	DESC
	
	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_PASAJERO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
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

-- [PG_LI_PASAJERO_X_K_VIAJE] 0,0,0,	1


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PASAJERO_X_K_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PASAJERO_X_K_VIAJE]
GO


CREATE PROCEDURE [dbo].[PG_LI_PASAJERO_X_K_VIAJE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_VIAJE							INT
AS

	DECLARE @VP_MENSAJE					VARCHAR(300) = ''
		
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
	
	SELECT		K_VIAJE, 
				PERSONA.K_PERSONA, PERSONA.D_PERSONA, PERSONA.PUESTO
				-- =============================	
	FROM		PASAJERO, PERSONA
				-- =============================
	WHERE		PASAJERO.K_PERSONA=PERSONA.K_PERSONA
	AND			PASAJERO.K_VIAJE=@PP_K_VIAJE 
	AND			( @VP_L_VER_BORRADOS=1			OR	PASAJERO.L_BORRADO=0 )
				-- =============================
	ORDER BY	D_PERSONA	DESC
		
	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_PASAJERO_X_K_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_BUSCAR', '', '', ''

	-- /////////////////////////////////////////////////////////////////////

GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_PASAJERO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_PASAJERO]
GO


CREATE PROCEDURE [dbo].[PG_SK_PASAJERO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VIAJE						INT,
	@PP_K_PERSONA					INT
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
				PASAJERO.*, PERSONA.D_PERSONA,PERSONA.PUESTO,
				VIAJE.D_VIAJE,	PERSONA_RESPONSABLE.D_PERSONA,
				D_USUARIO AS D_USUARIO_CAMBIO
				-- =============================	
		FROM	PASAJERO, PERSONA,
				PERSONA AS PERSONA_RESPONSABLE, VIAJE,
				USUARIO
				-- =============================
		WHERE	PASAJERO.K_PERSONA=PERSONA.K_PERSONA
		AND		PASAJERO.K_VIAJE=VIAJE.K_VIAJE
		AND		VIAJE.K_PERSONA_RESPONSABLE=PERSONA_RESPONSABLE.K_PERSONA
		AND		PASAJERO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
				-- =============================
		AND		PASAJERO.K_VIAJE=@PP_K_VIAJE
		AND		PASAJERO.K_PERSONA=@PP_K_PERSONA

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_PASAJERO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PERSONA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_PERSONA, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO


--EXECUTE [dbo].[PG_IN_PASAJERO] 0,0,0, 1,3
	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PASAJERO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PASAJERO]
GO


CREATE PROCEDURE [dbo].[PG_IN_PASAJERO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_VIAJE							INT,
	@PP_K_PERSONA						INT
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''


	-- ///////////////////////////////////////////////////
	
	--DECLARE @VP_K_PASAJERO			INT = 0
	--
	--	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
	--														'PASAJERO', 
	--														@OU_K_TABLA_DISPONIBLE = @VP_K_PASAJERO	OUTPUT	

	-- ///////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PASAJERO_INSERT]				@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_VIAJE, @PP_K_PERSONA,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- ///////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PASAJERO_VIAJE_EXISTE]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_VIAJE, @PP_K_PERSONA,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PASAJERO_RESPONSABLE_VIAJE_EXISTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_VIAJE, @PP_K_PERSONA,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	IF @VP_MENSAJE=''
		BEGIN

		INSERT INTO PASAJERO
			(	[K_VIAJE],					[K_PERSONA],
				-- ===========================
				[K_USUARIO_ALTA],			[F_ALTA], 
				[K_USUARIO_CAMBIO],			[F_CAMBIO],
				[L_BORRADO], 
				[K_USUARIO_BAJA],			[F_BAJA]  )
		VALUES	
			(	@PP_K_VIAJE,				@PP_K_PERSONA,
				-- ============================
				@PP_K_USUARIO_ACCION,		GETDATE(), 
				@PP_K_USUARIO_ACCION,		GETDATE(),
				0, 
				NULL,						NULL		)
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Agregar] el [Pasajero]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Pa.'+CONVERT(VARCHAR(10),@PP_K_PERSONA)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PERSONA AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_PASAJERO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PERSONA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, '', '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PASAJERO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PASAJERO]
GO

CREATE PROCEDURE [dbo].[PG_UP_PASAJERO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_VIAJE					INT,
	@PP_K_PERSONA				INT
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PASAJERO_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_PERSONA, @PP_K_VIAJE,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	--IF @VP_MENSAJE=''
	--	EXECUTE [dbo].[PG_RN_PASAJERO_UNIQUE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
	--												@PP_K_PASAJERO, 
	--												@PP_D_PASAJERO, @PP_RFC_PASAJERO,
	--												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	PASAJERO
		SET		[K_VIAJE]					= @PP_K_VIAJE,
				[K_PERSONA]					= @PP_K_PERSONA,
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION
		WHERE	K_VIAJE=@PP_K_VIAJE 
		AND		K_PERSONA=@PP_K_PERSONA
	
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [Pasajero]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Pa.'+CONVERT(VARCHAR(10),@PP_K_PERSONA)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PERSONA AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_PASAJERO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PERSONA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_PASAJERO, '', 0.00, 0.00,
													0, 0, '', '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_PASAJERO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_PASAJERO]
GO


CREATE PROCEDURE [dbo].[PG_DL_PASAJERO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VIAJE						INT,
	@PP_K_PERSONA					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PASAJERO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_PERSONA,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	PASAJERO
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_PERSONA=@PP_K_PERSONA
		AND		K_VIAJE=@PP_K_VIAJE
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [Pasajero]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Pa.'+CONVERT(VARCHAR(10),@PP_K_PERSONA)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PERSONA AS CLAVE

	-- //////////////////////////////////////////////////////////////
	
	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_PASAJERO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PERSONA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
	
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE PASAJERO_X_K_VIAJE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_PASAJERO_X_K_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_PASAJERO_X_K_VIAJE]
GO


CREATE PROCEDURE [dbo].[PG_DL_PASAJERO_X_K_VIAJE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VIAJE						INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		DELETE
		FROM	PASAJERO
		WHERE	K_VIAJE=@PP_K_VIAJE
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el/los [Pasajero(s)]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Vi.'+CONVERT(VARCHAR(10),@PP_K_VIAJE)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_VIAJE AS CLAVE

	-- //////////////////////////////////////////////////////////////
	
	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_PASAJERO_X_K_VIAJE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_VIAJE, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
