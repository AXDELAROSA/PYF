-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_WF_PARAMETRO_SUCURSAL_20181109_DPR.sql
-- /////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			PARAMETRO_SUCURSAL
-- // OPERACIÓN:		LIBERACIÓN / WORKFLOWS 
-- /////////////////////////////////////////////////////////////
-- // Autor:			DANIEL PORTILLO	ROMERO
-- // Fecha creación:	09/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PARAMETRO_SUCURSAL_ES_ACTIVABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_ES_ACTIVABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_ES_ACTIVABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PARAMETRO_SUCURSAL			[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_PARAMETRO_SUCURSAL		INT
	DECLARE	@VP_D_ESTATUS_PARAMETRO_SUCURSAL		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_PARAMETRO_SUCURSAL =		ESTATUS_PARAMETRO_SUCURSAL.K_ESTATUS_PARAMETRO_SUCURSAL,
			@VP_D_ESTATUS_PARAMETRO_SUCURSAL =		ESTATUS_PARAMETRO_SUCURSAL.D_ESTATUS_PARAMETRO_SUCURSAL
											FROM	PARAMETRO_SUCURSAL, ESTATUS_PARAMETRO_SUCURSAL
											WHERE	PARAMETRO_SUCURSAL.K_ESTATUS_PARAMETRO_SUCURSAL=ESTATUS_PARAMETRO_SUCURSAL.K_ESTATUS_PARAMETRO_SUCURSAL
											AND		PARAMETRO_SUCURSAL.K_PARAMETRO_SUCURSAL=@PP_K_PARAMETRO_SUCURSAL
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_PARAMETRO_SUCURSAL IS NULL
			SET @VP_RESULTADO =  'No se localizó el [PARAMETRO_SUCURSAL].'
			
	-- =============================
	-- K_ESTATUS_PARAMETRO_SUCURSAL	
	-- #1 PREVIO | #2 ACTIVO | #3 HISTÓRICO |
	
	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_PARAMETRO_SUCURSAL IN ( 1 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_PARAMETRO_SUCURSAL)+'-'+@VP_D_ESTATUS_PARAMETRO_SUCURSAL+'] del [PARAMETRO_SUCURSAL] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // ACTIVO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PARAMETRO_SUCURSAL_ACTIVO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_ACTIVO]
GO


CREATE PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_ACTIVO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_PARAMETRO_SUCURSAL		[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PARAMETRO_SUCURSAL_ES_ACTIVABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_PARAMETRO_SUCURSAL,	 
																	@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //ACT//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / ACTIVO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_PARAMETRO_SUCURSAL_ACTIVO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_PARAMETRO_SUCURSAL_ACTIVO]
GO


CREATE PROCEDURE [dbo].[PG_TR_PARAMETRO_SUCURSAL_ACTIVO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_PARAMETRO_SUCURSAL		INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PARAMETRO_SUCURSAL_ACTIVO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PARAMETRO_SUCURSAL,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_PARAMETRO_SUCURSAL = 1-PREVIO / 2-ACTIVO / 3-HISTÓRICO
		
		UPDATE	PARAMETRO_SUCURSAL
		SET		K_ESTATUS_PARAMETRO_SUCURSAL	= 2,		-- ACTIVO
				-- ====================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION 
		WHERE	PARAMETRO_SUCURSAL.K_PARAMETRO_SUCURSAL=@PP_K_PARAMETRO_SUCURSAL
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Activar] el [PARAMETRO_SUCURSAL]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PSU.'+CONVERT(VARCHAR(10),@PP_K_PARAMETRO_SUCURSAL)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PARAMETRO_SUCURSAL AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'ACTIVO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_PARAMETRO_SUCURSAL_ACTIVO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PARAMETRO_SUCURSAL, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO




-- *************************************************************************************************
-- *************************************************************************************************
-- *************************************************************************************************
-- *************************************************************************************************
-- *************************************************************************************************




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PARAMETRO_SUCURSAL_ES_HISTORICO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_ES_HISTORICO]
GO


CREATE PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_ES_HISTORICO]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PARAMETRO_SUCURSAL			[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_PARAMETRO_SUCURSAL		INT
	DECLARE	@VP_D_ESTATUS_PARAMETRO_SUCURSAL		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_PARAMETRO_SUCURSAL =		ESTATUS_PARAMETRO_SUCURSAL.K_ESTATUS_PARAMETRO_SUCURSAL,
			@VP_D_ESTATUS_PARAMETRO_SUCURSAL =		ESTATUS_PARAMETRO_SUCURSAL.D_ESTATUS_PARAMETRO_SUCURSAL
											FROM	PARAMETRO_SUCURSAL, ESTATUS_PARAMETRO_SUCURSAL
											WHERE	PARAMETRO_SUCURSAL.K_ESTATUS_PARAMETRO_SUCURSAL=ESTATUS_PARAMETRO_SUCURSAL.K_ESTATUS_PARAMETRO_SUCURSAL
											AND		PARAMETRO_SUCURSAL.K_PARAMETRO_SUCURSAL=@PP_K_PARAMETRO_SUCURSAL
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_PARAMETRO_SUCURSAL IS NULL
			SET @VP_RESULTADO =  'No se localizó la [PARAMETRO_SUCURSAL].'
			
	-- =============================
	-- K_ESTATUS_PARAMETRO_SUCURSAL	
	-- #1 PREVIO | #2 ACTIVO | #3 HISTÓRICO |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_PARAMETRO_SUCURSAL IN ( 2 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_PARAMETRO_SUCURSAL)+'-'+@VP_D_ESTATUS_PARAMETRO_SUCURSAL+'] del [PARAMETRO_SUCURSAL] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // HISTÓRICO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PARAMETRO_SUCURSAL_HISTORICO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_HISTORICO]
GO


CREATE PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_HISTORICO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_PARAMETRO_SUCURSAL		[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PARAMETRO_SUCURSAL_ES_HISTORICO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_PARAMETRO_SUCURSAL,	 
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //HIS//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / HISTÓRICO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_PARAMETRO_SUCURSAL_HISTORICO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_PARAMETRO_SUCURSAL_HISTORICO]
GO


CREATE PROCEDURE [dbo].[PG_TR_PARAMETRO_SUCURSAL_HISTORICO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_PARAMETRO_SUCURSAL		INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PARAMETRO_SUCURSAL_HISTORICO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_PARAMETRO_SUCURSAL,
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_PARAMETRO_SUCURSAL = 1-PREVIO / 2-ACTIVO / 3-HISTÓRICO
		
		UPDATE	PARAMETRO_SUCURSAL
		SET		K_ESTATUS_PARAMETRO_SUCURSAL	= 3,		-- HISTÓRICO
				-- ====================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION 
		WHERE	PARAMETRO_SUCURSAL.K_PARAMETRO_SUCURSAL=@PP_K_PARAMETRO_SUCURSAL
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible poner en estatus [Histórico] el [PARAMETRO_SUCURSAL]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PSU.'+CONVERT(VARCHAR(10),@PP_K_PARAMETRO_SUCURSAL)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PARAMETRO_SUCURSAL AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'HISTÓRICO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_PARAMETRO_SUCURSAL_HISTORICO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PARAMETRO_SUCURSAL, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO




-- *************************************************************************************************
-- *************************************************************************************************
-- *************************************************************************************************
-- *************************************************************************************************
-- *************************************************************************************************