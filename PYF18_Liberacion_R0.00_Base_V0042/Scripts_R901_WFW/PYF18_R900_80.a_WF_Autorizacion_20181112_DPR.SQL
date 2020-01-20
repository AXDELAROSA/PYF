-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_WF_AUTORIZACION_20181112_DPR.sql
-- /////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			AUTORIZACIÓN
-- // OPERACIÓN:		LIBERACIÓN / WORKFLOWS
-- /////////////////////////////////////////////////////////////
-- // Autor:			DANIEL PORTILLO	ROMERO
-- // Fecha creación:	12/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_AUTORIZACION_ES_ACTIVABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_AUTORIZACION_ES_ACTIVABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_AUTORIZACION_ES_ACTIVABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_AUTORIZACION					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_AUTORIZACION		INT
	DECLARE	@VP_D_ESTATUS_AUTORIZACION		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_AUTORIZACION =		ESTATUS_AUTORIZACION.K_ESTATUS_AUTORIZACION,
			@VP_D_ESTATUS_AUTORIZACION =		ESTATUS_AUTORIZACION.D_ESTATUS_AUTORIZACION
										FROM	AUTORIZACION, ESTATUS_AUTORIZACION
										WHERE	AUTORIZACION.K_ESTATUS_AUTORIZACION=ESTATUS_AUTORIZACION.K_ESTATUS_AUTORIZACION
										AND		AUTORIZACION.K_AUTORIZACION=@PP_K_AUTORIZACION
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_AUTORIZACION IS NULL
			SET @VP_RESULTADO =  'No se localizó la [AUTORIZACIÓN].'
			
	-- =============================
	-- K_ESTATUS_AUTORIZACION	
	-- #1 ACTIVO | #2 SUSPENDIDO | #3 CANCELADO |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_AUTORIZACION IN ( 2, 3 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_AUTORIZACION)+'-'+@VP_D_ESTATUS_AUTORIZACION+'] de la [AUTORIZACIÓN] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // ACTIVA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_AUTORIZACION_ACTIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_AUTORIZACION_ACTIVA]
GO


CREATE PROCEDURE [dbo].[PG_RN_AUTORIZACION_ACTIVA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_AUTORIZACION				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_AUTORIZACION_ES_ACTIVABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_AUTORIZACION,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //ACT//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / ACTIVA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_AUTORIZACION_ACTIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_AUTORIZACION_ACTIVA]
GO


CREATE PROCEDURE [dbo].[PG_TR_AUTORIZACION_ACTIVA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_AUTORIZACION				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_AUTORIZACION_ACTIVA]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_AUTORIZACION,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_AUTORIZACION = 1-ACTIVA / 2-SUSPENDIDA / 3-CANCELADA
		
		UPDATE	AUTORIZACION
		SET		K_ESTATUS_AUTORIZACION		= 1,		-- ACTIVA
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	AUTORIZACION.K_AUTORIZACION=@PP_K_AUTORIZACION
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Activar] la [AUTORIZACIÓN]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#AUT.'+CONVERT(VARCHAR(10),@PP_K_AUTORIZACION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_AUTORIZACION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'ACTIVA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_AUTORIZACION_ACTIVA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_AUTORIZACION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_AUTORIZACION_ES_SUSPENDIBLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_AUTORIZACION_ES_SUSPENDIBLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_AUTORIZACION_ES_SUSPENDIBLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_AUTORIZACION					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_AUTORIZACION		INT
	DECLARE	@VP_D_ESTATUS_AUTORIZACION		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_AUTORIZACION =		ESTATUS_AUTORIZACION.K_ESTATUS_AUTORIZACION,
			@VP_D_ESTATUS_AUTORIZACION =		ESTATUS_AUTORIZACION.D_ESTATUS_AUTORIZACION
										FROM	AUTORIZACION, ESTATUS_AUTORIZACION
										WHERE	AUTORIZACION.K_ESTATUS_AUTORIZACION=ESTATUS_AUTORIZACION.K_ESTATUS_AUTORIZACION
										AND		AUTORIZACION.K_AUTORIZACION=@PP_K_AUTORIZACION
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_AUTORIZACION IS NULL
			SET @VP_RESULTADO =  'No se localizó la [AUTORIZACIÓN].'
			
	-- =============================
	-- K_ESTATUS_AUTORIZACION	
	-- #1 ACTIVO | #2 SUSPENDIDO | #3 CANCELADO |
	

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_AUTORIZACION IN ( 1, 3 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_AUTORIZACION)+'-'+@VP_D_ESTATUS_AUTORIZACION+'] de la [AUTORIZACIÓN] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // SUSPENDIDA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_AUTORIZACION_SUSPENDIDA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_AUTORIZACION_SUSPENDIDA]
GO


CREATE PROCEDURE [dbo].[PG_RN_AUTORIZACION_SUSPENDIDA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_AUTORIZACION				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_AUTORIZACION_ES_SUSPENDIBLE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_AUTORIZACION,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //SUS//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / SUSPENDIDA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_AUTORIZACION_SUSPENDIDA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_AUTORIZACION_SUSPENDIDA]
GO


CREATE PROCEDURE [dbo].[PG_TR_AUTORIZACION_SUSPENDIDA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_AUTORIZACION				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_AUTORIZACION_SUSPENDIDA]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_AUTORIZACION,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_AUTORIZACION = 1-ACTIVA / 2-SUSPENDIDA / 3-CANCELADA
		
		UPDATE	AUTORIZACION
		SET		K_ESTATUS_AUTORIZACION		= 2,		-- SUSPENDIDA
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	AUTORIZACION.K_AUTORIZACION=@PP_K_AUTORIZACION
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Suspender] la [AUTORIZACIÓN]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#AUT.'+CONVERT(VARCHAR(10),@PP_K_AUTORIZACION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_AUTORIZACION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SUSPENDIDA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_AUTORIZACION_SUSPENDIDA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_AUTORIZACION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_AUTORIZACION_ES_CANCELABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_AUTORIZACION_ES_CANCELABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_AUTORIZACION_ES_CANCELABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_AUTORIZACION					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_AUTORIZACION		INT
	DECLARE	@VP_D_ESTATUS_AUTORIZACION		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_AUTORIZACION =		ESTATUS_AUTORIZACION.K_ESTATUS_AUTORIZACION,
			@VP_D_ESTATUS_AUTORIZACION =		ESTATUS_AUTORIZACION.D_ESTATUS_AUTORIZACION
										FROM	AUTORIZACION, ESTATUS_AUTORIZACION
										WHERE	AUTORIZACION.K_ESTATUS_AUTORIZACION=ESTATUS_AUTORIZACION.K_ESTATUS_AUTORIZACION
										AND		AUTORIZACION.K_AUTORIZACION=@PP_K_AUTORIZACION
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_AUTORIZACION IS NULL
			SET @VP_RESULTADO =  'No se localizó la [AUTORIZACIÓN].' 

	-- =============================
	-- K_ESTATUS_AUTORIZACION	
	-- #1 ACTIVO | #2 SUSPENDIDO | #3 CANCELADO |
	

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_AUTORIZACION IN ( 1, 2 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_AUTORIZACION)+'-'+@VP_D_ESTATUS_AUTORIZACION+'] de la [AUTORIZACIÓN] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // CANCELADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_AUTORIZACION_CANCELADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_AUTORIZACION_CANCELADA]
GO


CREATE PROCEDURE [dbo].[PG_RN_AUTORIZACION_CANCELADA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_AUTORIZACION				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_AUTORIZACION_ES_CANCELABLE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_AUTORIZACION,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //CNC//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / CANCELADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_AUTORIZACION_CANCELADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_AUTORIZACION_CANCELADA]
GO


CREATE PROCEDURE [dbo].[PG_TR_AUTORIZACION_CANCELADA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_AUTORIZACION				INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_AUTORIZACION_CANCELADA]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_AUTORIZACION,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_AUTORIZACION = 1-ACTIVA / 2-SUSPENDIDA / 3-CANCELADA

		UPDATE	AUTORIZACION
		SET		K_ESTATUS_AUTORIZACION		= 3,		-- CANCELADA
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION
		WHERE	AUTORIZACION.K_AUTORIZACION=@PP_K_AUTORIZACION
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Cancelar] la [AUTORIZACIÓN]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#AUT.'+CONVERT(VARCHAR(10),@PP_K_AUTORIZACION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_AUTORIZACION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CANCELADA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_AUTORIZACION_CANCELADA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_AUTORIZACION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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