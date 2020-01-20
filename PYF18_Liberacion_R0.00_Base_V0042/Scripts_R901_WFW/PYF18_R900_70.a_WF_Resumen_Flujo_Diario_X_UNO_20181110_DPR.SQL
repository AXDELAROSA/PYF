-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_WF_RESUMEN_FLUJO_DIARIO_X_UNO_20181110_DPR.sql
-- /////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			RESUMEN_FLUJO_DIARIO_X_UNO
-- // OPERACIÓN:		LIBERACIÓN / WORKFLOWS 
-- /////////////////////////////////////////////////////////////
-- // Autor:			DANIEL PORTILLO	ROMERO
-- // Fecha creación:	10/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_ES_PROCESABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_ES_PROCESABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_ES_PROCESABLE]
	@PP_L_DEBUG								[INT],
	@PP_K_SISTEMA_EXE						[INT],
	@PP_K_USUARIO_ACCION					[INT],
	-- ===========================			
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO		[INT],
	-- ===========================			
	@OU_RESULTADO_VALIDACION				[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO		INT
	DECLARE	@VP_D_ESTATUS_RESUMEN_FLUJO_DIARIO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO =		ESTATUS_RESUMEN_FLUJO_DIARIO.K_ESTATUS_RESUMEN_FLUJO_DIARIO,
			@VP_D_ESTATUS_RESUMEN_FLUJO_DIARIO =		ESTATUS_RESUMEN_FLUJO_DIARIO.D_ESTATUS_RESUMEN_FLUJO_DIARIO
												FROM	RESUMEN_FLUJO_DIARIO_X_UNO, ESTATUS_RESUMEN_FLUJO_DIARIO
												WHERE	RESUMEN_FLUJO_DIARIO_X_UNO.K_ESTATUS_RESUMEN_FLUJO_DIARIO=ESTATUS_RESUMEN_FLUJO_DIARIO.K_ESTATUS_RESUMEN_FLUJO_DIARIO
												AND		RESUMEN_FLUJO_DIARIO_X_UNO.K_RESUMEN_FLUJO_DIARIO_X_UNO=@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [RESUMEN_FLUJO_DIARIO_X_UNO].'
			
	-- =============================
	-- K_ESTATUS_RESUMEN_FLUJO_DIARIO	
	-- #1 PREREGISTRO | #2 EN PROCESO | #3 CERRADO | #4 REACTIVADO |
	
	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO IN ( 1 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO)+'-'+@VP_D_ESTATUS_RESUMEN_FLUJO_DIARIO+'] del [RESUMEN_FLUJO_DIARIO_X_UNO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // EN PROCESO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_EN_PROCESO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_EN_PROCESO]
GO


CREATE PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_EN_PROCESO]
	@PP_L_DEBUG								[INT],
	@PP_K_SISTEMA_EXE						[INT],
	@PP_K_USUARIO_ACCION					[INT],
	-- ===========================				
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO		[INT],	
	-- ===========================				
	@OU_RESULTADO_VALIDACION				[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_ES_PROCESABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO,	 
																			@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //PRC//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / EN PROCESO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_RESUMEN_FLUJO_DIARIO_X_UNO_EN_PROCESO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_RESUMEN_FLUJO_DIARIO_X_UNO_EN_PROCESO]
GO


CREATE PROCEDURE [dbo].[PG_TR_RESUMEN_FLUJO_DIARIO_X_UNO_EN_PROCESO]
	@PP_L_DEBUG								INT,
	@PP_K_SISTEMA_EXE						INT,
	@PP_K_USUARIO_ACCION					INT,
	-- ===========================
	@PP_L_CONTESTA							INT,
	-- ===========================
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO		INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_EN_PROCESO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO,
																		@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_RESUMEN_FLUJO_DIARIO = 1-PREREGISTRO / 2-EN PROCESO / 3-CERRADO / 4-REACTIVADO
		
		UPDATE	RESUMEN_FLUJO_DIARIO_X_UNO
		SET		K_ESTATUS_RESUMEN_FLUJO_DIARIO	= 2,		-- EN PROCESO
				-- ====================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION 
		WHERE	RESUMEN_FLUJO_DIARIO_X_UNO.K_RESUMEN_FLUJO_DIARIO_X_UNO=@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible poner [En Proceso] el [RESUMEN_FLUJO_DIARIO_X_UNO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#RFDRZS.'+CONVERT(VARCHAR(10),@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_RESUMEN_FLUJO_DIARIO_X_UNO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'EN PROCESO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_RESUMEN_FLUJO_DIARIO_X_UNO_EN_PROCESO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_ES_CERRABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_ES_CERRABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_ES_CERRABLE]
	@PP_L_DEBUG								[INT],
	@PP_K_SISTEMA_EXE						[INT],
	@PP_K_USUARIO_ACCION					[INT],
	-- ===========================			
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO		[INT],
	-- ===========================			
	@OU_RESULTADO_VALIDACION				[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO		INT
	DECLARE	@VP_D_ESTATUS_RESUMEN_FLUJO_DIARIO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO =		ESTATUS_RESUMEN_FLUJO_DIARIO.K_ESTATUS_RESUMEN_FLUJO_DIARIO,
			@VP_D_ESTATUS_RESUMEN_FLUJO_DIARIO =		ESTATUS_RESUMEN_FLUJO_DIARIO.D_ESTATUS_RESUMEN_FLUJO_DIARIO
												FROM	RESUMEN_FLUJO_DIARIO_X_UNO, ESTATUS_RESUMEN_FLUJO_DIARIO
												WHERE	RESUMEN_FLUJO_DIARIO_X_UNO.K_ESTATUS_RESUMEN_FLUJO_DIARIO=ESTATUS_RESUMEN_FLUJO_DIARIO.K_ESTATUS_RESUMEN_FLUJO_DIARIO
												AND		RESUMEN_FLUJO_DIARIO_X_UNO.K_RESUMEN_FLUJO_DIARIO_X_UNO=@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [RESUMEN_FLUJO_DIARIO_X_UNO].'
			
	-- =============================
	-- K_ESTATUS_RESUMEN_FLUJO_DIARIO	
	-- #1 PREREGISTRO | #2 EN PROCESO | #3 CERRADO | #4 REACTIVADO |
	
	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO IN ( 2, 4 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO)+'-'+@VP_D_ESTATUS_RESUMEN_FLUJO_DIARIO+'] del [RESUMEN_FLUJO_DIARIO_X_UNO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // CERRADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_CERRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_CERRADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_CERRADO]
	@PP_L_DEBUG								[INT],
	@PP_K_SISTEMA_EXE						[INT],
	@PP_K_USUARIO_ACCION					[INT],
	-- ===========================				
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO		[INT],	
	-- ===========================				
	@OU_RESULTADO_VALIDACION				[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_ES_PROCESABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO,	 
																			@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //CER//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / CERRADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_RESUMEN_FLUJO_DIARIO_X_UNO_CERRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_RESUMEN_FLUJO_DIARIO_X_UNO_CERRADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_RESUMEN_FLUJO_DIARIO_X_UNO_CERRADO]
	@PP_L_DEBUG								INT,
	@PP_K_SISTEMA_EXE						INT,
	@PP_K_USUARIO_ACCION					INT,
	-- ===========================
	@PP_L_CONTESTA							INT,
	-- ===========================
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO		INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_EN_PROCESO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO,
																		@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_RESUMEN_FLUJO_DIARIO = 1-PREREGISTRO / 2-EN PROCESO / 3-CERRADO / 4-REACTIVADO
		
		UPDATE	RESUMEN_FLUJO_DIARIO_X_UNO
		SET		K_ESTATUS_RESUMEN_FLUJO_DIARIO	= 3,		-- EN PROCESO
				-- ====================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION 
		WHERE	RESUMEN_FLUJO_DIARIO_X_UNO.K_RESUMEN_FLUJO_DIARIO_X_UNO=@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Cerrar] el [RESUMEN_FLUJO_DIARIO_X_UNO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#RFDRZS.'+CONVERT(VARCHAR(10),@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_RESUMEN_FLUJO_DIARIO_X_UNO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CERRADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_RESUMEN_FLUJO_DIARIO_X_UNO_CERRADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_ES_REACTIVABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_ES_REACTIVABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_ES_REACTIVABLE]
	@PP_L_DEBUG								[INT],
	@PP_K_SISTEMA_EXE						[INT],
	@PP_K_USUARIO_ACCION					[INT],
	-- ===========================			
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO		[INT],
	-- ===========================			
	@OU_RESULTADO_VALIDACION				[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO		INT
	DECLARE	@VP_D_ESTATUS_RESUMEN_FLUJO_DIARIO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO =		ESTATUS_RESUMEN_FLUJO_DIARIO.K_ESTATUS_RESUMEN_FLUJO_DIARIO,
			@VP_D_ESTATUS_RESUMEN_FLUJO_DIARIO =		ESTATUS_RESUMEN_FLUJO_DIARIO.D_ESTATUS_RESUMEN_FLUJO_DIARIO
												FROM	RESUMEN_FLUJO_DIARIO_X_UNO, ESTATUS_RESUMEN_FLUJO_DIARIO
												WHERE	RESUMEN_FLUJO_DIARIO_X_UNO.K_ESTATUS_RESUMEN_FLUJO_DIARIO=ESTATUS_RESUMEN_FLUJO_DIARIO.K_ESTATUS_RESUMEN_FLUJO_DIARIO
												AND		RESUMEN_FLUJO_DIARIO_X_UNO.K_RESUMEN_FLUJO_DIARIO_X_UNO=@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [RESUMEN_FLUJO_DIARIO_X_UNO].'
			
	-- =============================
	-- K_ESTATUS_RESUMEN_FLUJO_DIARIO	
	-- #1 PREREGISTRO | #2 EN PROCESO | #3 CERRADO | #4 REACTIVADO |
	
	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO IN ( 3 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO)+'-'+@VP_D_ESTATUS_RESUMEN_FLUJO_DIARIO+'] del [RESUMEN_FLUJO_DIARIO_X_UNO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // REACTIVADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_REACTIVADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_REACTIVADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_REACTIVADO]
	@PP_L_DEBUG								[INT],
	@PP_K_SISTEMA_EXE						[INT],
	@PP_K_USUARIO_ACCION					[INT],
	-- ===========================				
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO		[INT],	
	-- ===========================				
	@OU_RESULTADO_VALIDACION				[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_ES_REACTIVABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO,	 
																			@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //REAC//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / REACTIVADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_RESUMEN_FLUJO_DIARIO_X_UNO_REACTIVADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_RESUMEN_FLUJO_DIARIO_X_UNO_REACTIVADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_RESUMEN_FLUJO_DIARIO_X_UNO_REACTIVADO]
	@PP_L_DEBUG								INT,
	@PP_K_SISTEMA_EXE						INT,
	@PP_K_USUARIO_ACCION					INT,
	-- ===========================
	@PP_L_CONTESTA							INT,
	-- ===========================
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO		INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_REACTIVADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO,
																		@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_RESUMEN_FLUJO_DIARIO = 1-PREREGISTRO / 2-EN PROCESO / 3-CERRADO / 4-REACTIVADO
		
		UPDATE	RESUMEN_FLUJO_DIARIO_X_UNO
		SET		K_ESTATUS_RESUMEN_FLUJO_DIARIO	= 4,		-- REACTIVADO
				-- ====================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION 
		WHERE	RESUMEN_FLUJO_DIARIO_X_UNO.K_RESUMEN_FLUJO_DIARIO_X_UNO=@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Reactivar] el [RESUMEN_FLUJO_DIARIO_X_UNO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#RFDRZS.'+CONVERT(VARCHAR(10),@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_RESUMEN_FLUJO_DIARIO_X_UNO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'REACTIVADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_RESUMEN_FLUJO_DIARIO_X_UNO_REACTIVADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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