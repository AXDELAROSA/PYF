-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_WF_FLUJO_ESTATUS_FIRMA_C_20181112_DPR.sql
-- /////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			FLUJO_FIRMA
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_REVISABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_REVISABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_REVISABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_FLUJO_FIRMA					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_FIRMA_C				INT
	DECLARE	@VP_D_ESTATUS_FIRMA_C				VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_FIRMA_C =			ESTATUS_FIRMA.K_ESTATUS_FIRMA,
			@VP_D_ESTATUS_FIRMA_C =			ESTATUS_FIRMA.D_ESTATUS_FIRMA
									FROM	FLUJO_FIRMA, ESTATUS_FIRMA
									WHERE	FLUJO_FIRMA.K_ESTATUS_FIRMA_C=ESTATUS_FIRMA.K_ESTATUS_FIRMA
									AND		FLUJO_FIRMA.K_FLUJO_FIRMA=@PP_K_FLUJO_FIRMA
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_FIRMA_C IS NULL
			SET @VP_RESULTADO =  'No se localizó el [FLUJO_FIRMA].'
			
	-- =============================
	-- K_ESTATUS_FIRMA	
	-- #1 PENDIENTE | #2 REVISIÓN | #3 AUTORIZADO | #4 RECHAZADO |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_FIRMA_C IN ( 1 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_FIRMA_C)+'-'+@VP_D_ESTATUS_FIRMA_C+'] de la [FIRMA C] del [FLUJO_FIRMA] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // REVISIÓN
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_REVISION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_REVISION]
GO


CREATE PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_REVISION]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_FLUJO_FIRMA				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_REVISABLE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_FLUJO_FIRMA,	 
																	@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //REV//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / REVISIÓN
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_FLUJO_ESTATUS_FIRMA_C_REVISION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_FLUJO_ESTATUS_FIRMA_C_REVISION]
GO


CREATE PROCEDURE [dbo].[PG_TR_FLUJO_ESTATUS_FIRMA_C_REVISION]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_FLUJO_FIRMA				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_REVISION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_FLUJO_FIRMA,
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_FIRMA = 1-PENDIENTE / 2-REVISIÓN / 3-AUTORIZADO / 4-RECHAZADO
			
		UPDATE	FLUJO_FIRMA
		SET		K_ESTATUS_FIRMA				= 2,		-- REVISIÓN
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	FLUJO_FIRMA.K_FLUJO_FIRMA=@PP_K_FLUJO_FIRMA
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Revisar] la [FIRMA C] del [FLUJO_FIRMA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#FJF.'+CONVERT(VARCHAR(10),@PP_K_FLUJO_FIRMA)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FLUJO_FIRMA AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'REVISIÓN',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_FLUJO_ESTATUS_FIRMA_C_REVISION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FLUJO_FIRMA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_AUTORIZABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_AUTORIZABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_AUTORIZABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_FLUJO_FIRMA					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_FIRMA_C				INT
	DECLARE	@VP_D_ESTATUS_FIRMA_C				VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_FIRMA_C =			ESTATUS_FIRMA.K_ESTATUS_FIRMA,
			@VP_D_ESTATUS_FIRMA_C =			ESTATUS_FIRMA.D_ESTATUS_FIRMA
									FROM	FLUJO_FIRMA, ESTATUS_FIRMA
									WHERE	FLUJO_FIRMA.K_ESTATUS_FIRMA_C=ESTATUS_FIRMA.K_ESTATUS_FIRMA
									AND		FLUJO_FIRMA.K_FLUJO_FIRMA=@PP_K_FLUJO_FIRMA
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_FIRMA_C IS NULL
			SET @VP_RESULTADO =  'No se localizó el [FLUJO_FIRMA].'
			
	-- =============================
	-- K_ESTATUS_FIRMA	
	-- #1 PENDIENTE | #2 REVISIÓN | #3 AUTORIZADO | #4 RECHAZADO |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_FIRMA_C IN ( 1, 2 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_FIRMA_C)+'-'+@VP_D_ESTATUS_FIRMA_C+'] de la [FIRMA C] del [FLUJO_FIRMA] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // AUTORIZADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_AUTORIZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_AUTORIZADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_AUTORIZADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_FLUJO_FIRMA				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_AUTORIZABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_FLUJO_FIRMA,	 
																		@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //AUT//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / AUTORIZADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_FLUJO_ESTATUS_FIRMA_C_AUTORIZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_FLUJO_ESTATUS_FIRMA_C_AUTORIZADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_FLUJO_ESTATUS_FIRMA_C_AUTORIZADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_FLUJO_FIRMA				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_AUTORIZADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_FLUJO_FIRMA,
																	@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_FIRMA = 1-PENDIENTE / 2-REVISIÓN / 3-AUTORIZADO / 4-RECHAZADO
			
		UPDATE	FLUJO_FIRMA
		SET		K_ESTATUS_FIRMA				= 3,		-- AUTORIZADO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	FLUJO_FIRMA.K_FLUJO_FIRMA=@PP_K_FLUJO_FIRMA
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Autorizar] la [FIRMA C] del [FLUJO_FIRMA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#FJF.'+CONVERT(VARCHAR(10),@PP_K_FLUJO_FIRMA)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FLUJO_FIRMA AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'AUTORIZADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_FLUJO_ESTATUS_FIRMA_C_AUTORIZADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FLUJO_FIRMA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_RECHAZABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_RECHAZABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_RECHAZABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_FLUJO_FIRMA					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_FIRMA_C				INT
	DECLARE	@VP_D_ESTATUS_FIRMA_C				VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_FIRMA_C =			ESTATUS_FIRMA.K_ESTATUS_FIRMA,
			@VP_D_ESTATUS_FIRMA_C =			ESTATUS_FIRMA.D_ESTATUS_FIRMA
									FROM	FLUJO_FIRMA, ESTATUS_FIRMA
									WHERE	FLUJO_FIRMA.K_ESTATUS_FIRMA_C=ESTATUS_FIRMA.K_ESTATUS_FIRMA
									AND		FLUJO_FIRMA.K_FLUJO_FIRMA=@PP_K_FLUJO_FIRMA
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_FIRMA_C IS NULL
			SET @VP_RESULTADO =  'No se localizó el [FLUJO_FIRMA].'
			
	-- =============================
	-- K_ESTATUS_FIRMA	
	-- #1 PENDIENTE | #2 REVISIÓN | #3 AUTORIZADO | #4 RECHAZADO |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_FIRMA_C IN ( 1, 2, 3 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_FIRMA_C)+'-'+@VP_D_ESTATUS_FIRMA_C+'] de la [FIRMA C] del [FLUJO_FIRMA] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // RECHAZADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_RECHAZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_RECHAZADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_RECHAZADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_FLUJO_FIRMA				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_RECHAZABLE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_FLUJO_FIRMA,	 
																	@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //REC//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / RECHAZADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_FLUJO_ESTATUS_FIRMA_C_RECHAZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_FLUJO_ESTATUS_FIRMA_C_RECHAZADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_FLUJO_ESTATUS_FIRMA_C_RECHAZADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_FLUJO_FIRMA				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_RECHAZADO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_FLUJO_FIRMA,
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_FIRMA = 1-PENDIENTE / 2-REVISIÓN / 3-AUTORIZADO / 4-RECHAZADO
			
		UPDATE	FLUJO_FIRMA
		SET		K_ESTATUS_FIRMA				= 4,		-- RECHAZADO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	FLUJO_FIRMA.K_FLUJO_FIRMA=@PP_K_FLUJO_FIRMA
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Rechazar] la [FIRMA C] del [FLUJO_FIRMA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#FJF.'+CONVERT(VARCHAR(10),@PP_K_FLUJO_FIRMA)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FLUJO_FIRMA AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'RECHAZADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_FLUJO_ESTATUS_FIRMA_C_RECHAZADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FLUJO_FIRMA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_REGRESABLE_A_PENDIENTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_REGRESABLE_A_PENDIENTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_REGRESABLE_A_PENDIENTE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_FLUJO_FIRMA					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_FIRMA_C				INT
	DECLARE	@VP_D_ESTATUS_FIRMA_C				VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_FIRMA_C =			ESTATUS_FIRMA.K_ESTATUS_FIRMA,
			@VP_D_ESTATUS_FIRMA_C =			ESTATUS_FIRMA.D_ESTATUS_FIRMA
									FROM	FLUJO_FIRMA, ESTATUS_FIRMA
									WHERE	FLUJO_FIRMA.K_ESTATUS_FIRMA_C=ESTATUS_FIRMA.K_ESTATUS_FIRMA
									AND		FLUJO_FIRMA.K_FLUJO_FIRMA=@PP_K_FLUJO_FIRMA
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_FIRMA_C IS NULL
			SET @VP_RESULTADO =  'No se localizó el [FLUJO_FIRMA].'
			
	-- =============================
	-- K_ESTATUS_FIRMA	
	-- #1 PENDIENTE | #2 REVISIÓN | #3 AUTORIZADO | #4 RECHAZADO |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_FIRMA_C IN ( 4 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_FIRMA_C)+'-'+@VP_D_ESTATUS_FIRMA_C+'] de la [FIRMA C] del [FLUJO_FIRMA] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // REGRESAR A PENDIENTE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_REGRESAR_A_PENDIENTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_REGRESAR_A_PENDIENTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_REGRESAR_A_PENDIENTE]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_FLUJO_FIRMA				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_ES_REGRESABLE_A_PENDIENTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																				@PP_K_FLUJO_FIRMA,	 
																				@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //RPND//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / REGRESAR A PENDIENTE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_FLUJO_ESTATUS_FIRMA_C_REGRESAR_A_PENDIENTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_FLUJO_ESTATUS_FIRMA_C_REGRESAR_A_PENDIENTE]
GO


CREATE PROCEDURE [dbo].[PG_TR_FLUJO_ESTATUS_FIRMA_C_REGRESAR_A_PENDIENTE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_FLUJO_FIRMA				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FLUJO_ESTATUS_FIRMA_C_REGRESAR_A_PENDIENTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_FLUJO_FIRMA,
																			@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_FIRMA = 1-PENDIENTE / 2-REVISIÓN / 3-AUTORIZADO / 4-RECHAZADO
			
		UPDATE	FLUJO_FIRMA
		SET		K_ESTATUS_FIRMA				= 1,		-- PENDIENTE
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	FLUJO_FIRMA.K_FLUJO_FIRMA=@PP_K_FLUJO_FIRMA
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible regresar a [Pendiente] la [FIRMA C] del [FLUJO_FIRMA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#FJF.'+CONVERT(VARCHAR(10),@PP_K_FLUJO_FIRMA)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FLUJO_FIRMA AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'REGRESAR_A_PENDIENTE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_FLUJO_ESTATUS_FIRMA_C_REGRESAR_A_PENDIENTE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FLUJO_FIRMA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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