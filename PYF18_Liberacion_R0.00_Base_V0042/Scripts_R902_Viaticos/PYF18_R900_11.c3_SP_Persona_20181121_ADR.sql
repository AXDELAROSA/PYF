-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			SP_Persona_20181117_DPR.sql
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			CONTROL DE VIAJES - PERSONA 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PERSONA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PERSONA]
GO


CREATE PROCEDURE [dbo].[PG_LI_PERSONA]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_BUSCAR							VARCHAR(200),
	@PP_K_BANCO							INT
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
				PERSONA.*,
				BANCO.D_BANCO, BANCO.S_BANCO,
				D_USUARIO AS D_USUARIO_CAMBIO
				-- =============================	
	FROM		PERSONA, 
				BANCO, USUARIO
				-- =============================
	WHERE		PERSONA.K_PERSONA=BANCO.K_BANCO
	AND			PERSONA.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
				-- =============================
	AND			(	PERSONA.D_PERSONA				LIKE '%'+@PP_BUSCAR+'%'
				OR	PERSONA.PUESTO					LIKE '%'+@PP_BUSCAR+'%' 
				OR	PERSONA.DEPARTAMENTO			LIKE '%'+@PP_BUSCAR+'%'
				OR	PERSONA.JEFE_INMEDIATO			LIKE '%'+@PP_BUSCAR+'%'
				OR	PERSONA.NUMERO_CUENTA			LIKE '%'+@PP_BUSCAR+'%'
				OR	PERSONA.NUMERO_TARJETA			LIKE '%'+@PP_BUSCAR+'%'
				OR	PERSONA.CLABE					LIKE '%'+@PP_BUSCAR+'%'
				OR  PERSONA.K_PERSONA=@VP_K_FOLIO							)
				-- =============================
	AND			( @PP_K_BANCO=-1				OR	PERSONA.K_PERSONA=@PP_K_BANCO )
	AND			( @VP_L_VER_BORRADOS=1			OR	PERSONA.L_BORRADO=0 )
				-- =============================
	ORDER BY	K_PERSONA	DESC
	
	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_PERSONA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_PERSONA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_PERSONA]
GO


CREATE PROCEDURE [dbo].[PG_SK_PERSONA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
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
				PERSONA.*,
				BANCO.D_BANCO, BANCO.S_BANCO,
				D_USUARIO AS D_USUARIO_CAMBIO
				-- =====================
		FROM	PERSONA, 
				BANCO, USUARIO
				-- =====================
		WHERE	PERSONA.K_BANCO=BANCO.K_BANCO
		AND		PERSONA.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
		AND		PERSONA.K_PERSONA=@PP_K_PERSONA
		

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_PERSONA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PERSONA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_PERSONA, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO



	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PERSONA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PERSONA]
GO


CREATE PROCEDURE [dbo].[PG_IN_PERSONA]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_BANCO							INT,
	@PP_D_PERSONA						VARCHAR(100),
	@PP_PUESTO							VARCHAR(100),
	@PP_DEPARTAMENTO					VARCHAR(100),
	@PP_JEFE_INMEDIATO					VARCHAR(100),
	-- ===========================
	@PP_NUMERO_CUENTA					VARCHAR(100),
	@PP_NUMERO_TARJETA					VARCHAR(100),
	@PP_CLABE							VARCHAR(100)
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- ///////////////////////////////////////////////////
	
	DECLARE @VP_K_PERSONA			INT = 0

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															'PERSONA', 
															@OU_K_TABLA_DISPONIBLE = @VP_K_PERSONA	OUTPUT	
	-- ///////////////////////////////////////////////////
	
	--IF @VP_MENSAJE=''
	--	EXECUTE [dbo].[PG_RN_PERSONA_UNIQUE]				@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
	--														@VP_K_PERSONA, 
	--														@PP_D_PERSONA, @PP_RFC_PERSONA,
	--														@OU_RESULTADO_VALIDACION = @VP_MENSAJE				OUTPUT	
		-- ///////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN

		INSERT INTO PERSONA
			(	[K_PERSONA],				[K_BANCO], 
				[D_PERSONA],				[PUESTO],
				[DEPARTAMENTO],				[JEFE_INMEDIATO], 
				-- ===========================
				[NUMERO_CUENTA],			[NUMERO_TARJETA],
				[CLABE],
				-- ===========================
				[K_USUARIO_ALTA],			[F_ALTA], 
				[K_USUARIO_CAMBIO],			[F_CAMBIO],
				[L_BORRADO], 
				[K_USUARIO_BAJA],			[F_BAJA]  )
		VALUES	
			(	@VP_K_PERSONA,				@PP_K_BANCO, 
				@PP_D_PERSONA,				@PP_PUESTO, 
				@PP_DEPARTAMENTO,			@PP_JEFE_INMEDIATO,
				-- ===========================
				@PP_NUMERO_CUENTA,			@PP_NUMERO_TARJETA, 
				@PP_CLABE,
				-- ============================
				@PP_K_USUARIO_ACCION,		GETDATE(), 
				@PP_K_USUARIO_ACCION,		GETDATE(),
				0, 
				NULL,						NULL		)
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] la [Persona]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Pe.'+CONVERT(VARCHAR(10),@VP_K_PERSONA)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PERSONA AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_PERSONA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_PERSONA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, @PP_D_PERSONA, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_NOMBRE', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PERSONA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PERSONA]
GO

CREATE PROCEDURE [dbo].[PG_UP_PERSONA]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_PERSONA				INT,
	-- ===========================
	@PP_K_BANCO					INT,
	@PP_D_PERSONA				VARCHAR(100),
	@PP_PUESTO					VARCHAR(100),
	@PP_DEPARTAMENTO			VARCHAR(100),
	@PP_JEFE_INMEDIATO			VARCHAR(100),
	-- ===========================
	@PP_NUMERO_CUENTA			VARCHAR(100),
	@PP_NUMERO_TARJETA			VARCHAR(100),
	@PP_CLABE					VARCHAR(100)
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PERSONA_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_PERSONA, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	--IF @VP_MENSAJE=''
	--	EXECUTE [dbo].[PG_RN_PERSONA_UNIQUE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
	--												@PP_K_PERSONA, 
	--												@PP_D_PERSONA, @PP_RFC_PERSONA,
	--												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	PERSONA
		SET		[K_BANCO]					= @PP_K_BANCO,
				[D_PERSONA]					= @PP_D_PERSONA,
				[PUESTO]					= @PP_PUESTO,
				[DEPARTAMENTO]				= @PP_DEPARTAMENTO,	
				[JEFE_INMEDIATO]			= @PP_JEFE_INMEDIATO,
				-- ========================== -- ===========================
				[NUMERO_CUENTA]				= @PP_NUMERO_CUENTA,
				[NUMERO_TARJETA]			= @PP_NUMERO_TARJETA,
				[CLABE]						= @PP_CLABE,
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION
		WHERE	K_PERSONA=@PP_K_PERSONA
	
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] la [Persona]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Pe.'+CONVERT(VARCHAR(10),@PP_K_PERSONA)+']'
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
													'[PG_UP_PERSONA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PERSONA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_PERSONA, '', 0.00, 0.00,
													0, 0, @PP_D_PERSONA, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_NOMBRE', '', '', ''

	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_PERSONA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_PERSONA]
GO


CREATE PROCEDURE [dbo].[PG_DL_PERSONA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PERSONA					INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PERSONA_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PERSONA, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	PERSONA
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_PERSONA=@PP_K_PERSONA
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la [Persona]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Pe.'+CONVERT(VARCHAR(10),@PP_K_PERSONA)+']'
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
													'[PG_DL_PERSONA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PERSONA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
	
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
