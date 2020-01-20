-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_WF_RAZON_SOCIAL_20181112_DPR.sql
-- /////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			RAZON_SOCIAL
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RAZON_SOCIAL_ES_ACTIVABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_ES_ACTIVABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_ES_ACTIVABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_RAZON_SOCIAL		INT
	DECLARE	@VP_D_ESTATUS_RAZON_SOCIAL		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_RAZON_SOCIAL =			ESTATUS_RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL,
			@VP_D_ESTATUS_RAZON_SOCIAL =			ESTATUS_RAZON_SOCIAL.D_ESTATUS_RAZON_SOCIAL
											FROM	RAZON_SOCIAL, ESTATUS_RAZON_SOCIAL
											WHERE	RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL=ESTATUS_RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL
											AND		RAZON_SOCIAL.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_RAZON_SOCIAL IS NULL
			SET @VP_RESULTADO =  'No se localizó la [RAZÓN_SOCIAL].'
			
	-- =============================
	-- K_ESTATUS_RAZON_SOCIAL	
	-- #0 INACTIVA | #1 ACTIVA | #2 SUSPENDIDA | #3 CERRADA |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_RAZON_SOCIAL IN ( 0, 2, 3 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_RAZON_SOCIAL)+'-'+@VP_D_ESTATUS_RAZON_SOCIAL+'] de la [RAZÓN_SOCIAL] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // ACTIVA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RAZON_SOCIAL_ACTIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_ACTIVA]
GO


CREATE PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_ACTIVA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_RAZON_SOCIAL_ES_ACTIVABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_RAZON_SOCIAL,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_RAZON_SOCIAL_ACTIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_RAZON_SOCIAL_ACTIVA]
GO


CREATE PROCEDURE [dbo].[PG_TR_RAZON_SOCIAL_ACTIVA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_RAZON_SOCIAL				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RAZON_SOCIAL_ACTIVA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_RAZON_SOCIAL,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_RAZON_SOCIAL = 0-INACTIVA / 1-ACTIVA / 2-SUSPENDIDA / 3-CERRADA
		
		UPDATE	RAZON_SOCIAL
		SET		K_ESTATUS_RAZON_SOCIAL		= 1,		-- ACTIVA
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	RAZON_SOCIAL.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Activar] la [RAZÓN_SOCIAL]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#RZS.'+CONVERT(VARCHAR(10),@PP_K_RAZON_SOCIAL)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_RAZON_SOCIAL AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'ACTIVA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_RAZON_SOCIAL_ACTIVA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_RAZON_SOCIAL, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RAZON_SOCIAL_ES_SUSPENDIBLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_ES_SUSPENDIBLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_ES_SUSPENDIBLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_RAZON_SOCIAL		INT
	DECLARE	@VP_D_ESTATUS_RAZON_SOCIAL		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_RAZON_SOCIAL =			ESTATUS_RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL,
			@VP_D_ESTATUS_RAZON_SOCIAL =			ESTATUS_RAZON_SOCIAL.D_ESTATUS_RAZON_SOCIAL
											FROM	RAZON_SOCIAL, ESTATUS_RAZON_SOCIAL
											WHERE	RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL=ESTATUS_RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL
											AND		RAZON_SOCIAL.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_RAZON_SOCIAL IS NULL
			SET @VP_RESULTADO =  'No se localizó la [RAZÓN_SOCIAL].'
			
	-- =============================
	-- K_ESTATUS_RAZON_SOCIAL	
	-- #0 INACTIVA | #1 ACTIVA | #2 SUSPENDIDA | #3 CERRADA |	

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_RAZON_SOCIAL IN ( 1, 3 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_RAZON_SOCIAL)+'-'+@VP_D_ESTATUS_RAZON_SOCIAL+'] de la [RAZÓN_SOCIAL] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // SUSPENDIDA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RAZON_SOCIAL_SUSPENDIDA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_SUSPENDIDA]
GO


CREATE PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_SUSPENDIDA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_RAZON_SOCIAL_ES_SUSPENDIBLE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_RAZON_SOCIAL,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_RAZON_SOCIAL_SUSPENDIDA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_RAZON_SOCIAL_SUSPENDIDA]
GO


CREATE PROCEDURE [dbo].[PG_TR_RAZON_SOCIAL_SUSPENDIDA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_RAZON_SOCIAL				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RAZON_SOCIAL_SUSPENDIDA]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_RAZON_SOCIAL,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_RAZON_SOCIAL = 0-INACTIVA / 1-ACTIVA / 2-SUSPENDIDA / 3-CERRADA
		
		UPDATE	RAZON_SOCIAL
		SET		K_ESTATUS_RAZON_SOCIAL		= 2,		-- SUSPENDIDA
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	RAZON_SOCIAL.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Suspender] la [RAZÓN_SOCIAL]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#RZS.'+CONVERT(VARCHAR(10),@PP_K_RAZON_SOCIAL)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_RAZON_SOCIAL AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SUSPENDIDA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_RAZON_SOCIAL_SUSPENDIDA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_RAZON_SOCIAL, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RAZON_SOCIAL_ES_CERRABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_ES_CERRABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_ES_CERRABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_RAZON_SOCIAL		INT
	DECLARE	@VP_D_ESTATUS_RAZON_SOCIAL		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_RAZON_SOCIAL =			ESTATUS_RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL,
			@VP_D_ESTATUS_RAZON_SOCIAL =			ESTATUS_RAZON_SOCIAL.D_ESTATUS_RAZON_SOCIAL
											FROM	RAZON_SOCIAL, ESTATUS_RAZON_SOCIAL
											WHERE	RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL=ESTATUS_RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL
											AND		RAZON_SOCIAL.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_RAZON_SOCIAL IS NULL
			SET @VP_RESULTADO =  'No se localizó la [RAZÓN_SOCIAL].' 

	-- =============================
	-- K_ESTATUS_RAZON_SOCIAL	
	-- #0 INACTIVA | #1 ACTIVA | #2 SUSPENDIDA | #3 CERRADA |	

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_RAZON_SOCIAL IN ( 1, 2 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_RAZON_SOCIAL)+'-'+@VP_D_ESTATUS_RAZON_SOCIAL+'] de la [RAZÓN_SOCIAL] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // CERRADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RAZON_SOCIAL_CERRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_CERRADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_CERRADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_RAZON_SOCIAL_ES_CERRABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_RAZON_SOCIAL,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_RAZON_SOCIAL_CERRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_RAZON_SOCIAL_CERRADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_RAZON_SOCIAL_CERRADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_RAZON_SOCIAL				INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RAZON_SOCIAL_CERRADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_RAZON_SOCIAL,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_RAZON_SOCIAL = 0-INACTIVA / 1-ACTIVA / 2-SUSPENDIDA / 3-CERRADA

		UPDATE	RAZON_SOCIAL
		SET		K_ESTATUS_RAZON_SOCIAL			= 3,		-- CERRADA
				-- ====================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION
		WHERE	RAZON_SOCIAL.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Cerrar] la [RAZÓN_SOCIAL]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#RZS.'+CONVERT(VARCHAR(10),@PP_K_RAZON_SOCIAL)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_RAZON_SOCIAL AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CERRADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_RAZON_SOCIAL_CERRADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_RAZON_SOCIAL, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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