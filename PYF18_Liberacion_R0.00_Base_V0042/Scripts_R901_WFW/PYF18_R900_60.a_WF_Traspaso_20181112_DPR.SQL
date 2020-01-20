-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_WF_TRASPASO_20181112_DPR.sql
-- /////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			TRASPASO
-- // OPERACIÓN:		LIBERACIÓN / WORKFLOWS ESTATUS_TRASPASO
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_ES_PROGRAMABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_ES_PROGRAMABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_ES_PROGRAMABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_TRASPASO						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_TRASPASO		INT
	DECLARE	@VP_D_ESTATUS_TRASPASO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_TRASPASO =			ESTATUS_TRASPASO.K_ESTATUS_TRASPASO,
			@VP_D_ESTATUS_TRASPASO =			ESTATUS_TRASPASO.D_ESTATUS_TRASPASO
										FROM	TRASPASO, ESTATUS_TRASPASO
										WHERE	TRASPASO.K_ESTATUS_TRASPASO=ESTATUS_TRASPASO.K_ESTATUS_TRASPASO
										AND		TRASPASO.K_TRASPASO=@PP_K_TRASPASO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_TRASPASO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [TRASPASO].'
			
	-- =============================
	-- K_ESTATUS_TRASPASO	
	-- #1 BASE | #2 PROGRAMADO | #3 AUTORIZADO | #4 EJECUTADO |
	-- #5 CONCILIADO | #6 CANCELADO | 

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_TRASPASO IN ( 1 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_TRASPASO)+'-'+@VP_D_ESTATUS_TRASPASO+'] del [TRASPASO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // PROGRAMADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_PROGRAMADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_PROGRAMADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_PROGRAMADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_TRASPASO					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_TRASPASO_ES_PROGRAMABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_TRASPASO,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //PRG//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / PROGRAMADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_TRASPASO_PROGRAMADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_TRASPASO_PROGRAMADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_TRASPASO_PROGRAMADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_TRASPASO				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TRASPASO_PROGRAMADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_TRASPASO,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_TRASPASO = 1-BASE / 2-PROGRAMADO / 3-AUTORIZADO / 4-EJECUTADO / 5-CONCILIADO / 6-CANCELADO
		
		UPDATE	TRASPASO
		SET		K_ESTATUS_TRASPASO			= 2,		-- PROGRAMADO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	TRASPASO.K_TRASPASO=@PP_K_TRASPASO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Programar] el [TRASPASO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#TRA.'+CONVERT(VARCHAR(10),@PP_K_TRASPASO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_TRASPASO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'PROGRAMADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_TRASPASO_PROGRAMADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_TRASPASO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_ES_AUTORIZABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_ES_AUTORIZABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_ES_AUTORIZABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_TRASPASO						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_TRASPASO		INT
	DECLARE	@VP_D_ESTATUS_TRASPASO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_TRASPASO =			ESTATUS_TRASPASO.K_ESTATUS_TRASPASO,
			@VP_D_ESTATUS_TRASPASO =			ESTATUS_TRASPASO.D_ESTATUS_TRASPASO
										FROM	TRASPASO, ESTATUS_TRASPASO
										WHERE	TRASPASO.K_ESTATUS_TRASPASO=ESTATUS_TRASPASO.K_ESTATUS_TRASPASO
										AND		TRASPASO.K_TRASPASO=@PP_K_TRASPASO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_TRASPASO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [TRASPASO].'
			
	-- =============================
	-- K_ESTATUS_TRASPASO	
	-- #1 BASE | #2 PROGRAMADO | #3 AUTORIZADO | #4 EJECUTADO |
	-- #5 CONCILIADO | #6 CANCELADO | 

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_TRASPASO IN ( 2 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_TRASPASO)+'-'+@VP_D_ESTATUS_TRASPASO+'] del [TRASPASO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // AUTORIZADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_AUTORIZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_AUTORIZADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_AUTORIZADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_TRASPASO					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_TRASPASO_ES_AUTORIZABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_TRASPASO,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_TRASPASO_AUTORIZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_TRASPASO_AUTORIZADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_TRASPASO_AUTORIZADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_TRASPASO				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TRASPASO_AUTORIZADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_TRASPASO,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_TRASPASO = 1-BASE / 2-PROGRAMADO / 3-AUTORIZADO / 4-EJECUTADO / 5-CONCILIADO / 6-CANCELADO
		
		UPDATE	TRASPASO
		SET		K_ESTATUS_TRASPASO			= 3,		-- AUTORIZADO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	TRASPASO.K_TRASPASO=@PP_K_TRASPASO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Autorizar] el [TRASPASO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#TRA.'+CONVERT(VARCHAR(10),@PP_K_TRASPASO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_TRASPASO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'AUTORIZADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_TRASPASO_AUTORIZADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_TRASPASO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_ES_EJECUTABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_ES_EJECUTABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_ES_EJECUTABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_TRASPASO						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_TRASPASO		INT
	DECLARE	@VP_D_ESTATUS_TRASPASO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_TRASPASO =			ESTATUS_TRASPASO.K_ESTATUS_TRASPASO,
			@VP_D_ESTATUS_TRASPASO =			ESTATUS_TRASPASO.D_ESTATUS_TRASPASO
										FROM	TRASPASO, ESTATUS_TRASPASO
										WHERE	TRASPASO.K_ESTATUS_TRASPASO=ESTATUS_TRASPASO.K_ESTATUS_TRASPASO
										AND		TRASPASO.K_TRASPASO=@PP_K_TRASPASO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_TRASPASO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [TRASPASO].' 

	-- =============================
	-- K_ESTATUS_TRASPASO	
	-- #1 BASE | #2 PROGRAMADO | #3 AUTORIZADO | #4 EJECUTADO |
	-- #5 CONCILIADO | #6 CANCELADO | 

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_TRASPASO IN ( 3 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_TRASPASO)+'-'+@VP_D_ESTATUS_TRASPASO+'] del [TRASPASO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // EJECUTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_EJECUTADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_EJECUTADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_EJECUTADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_TRASPASO					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_TRASPASO_ES_EJECUTABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_TRASPASO,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //EJC//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / EJECUTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_TRASPASO_EJECUTADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_TRASPASO_EJECUTADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_TRASPASO_EJECUTADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_TRASPASO					INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TRASPASO_AUTORIZADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_TRASPASO,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_TRASPASO = 1-BASE / 2-PROGRAMADO / 3-AUTORIZADO / 4-EJECUTADO / 5-CONCILIADO / 6-CANCELADO

		UPDATE	TRASPASO
		SET		K_ESTATUS_TRASPASO		= 4,		-- EJECUTADO
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	TRASPASO.K_TRASPASO=@PP_K_TRASPASO
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Ejecutar] el [TRASPASO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#TRA.'+CONVERT(VARCHAR(10),@PP_K_TRASPASO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_TRASPASO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'EJECUTADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_TRASPASO_EJECUTADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_TRASPASO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_ES_CONCILIABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_ES_CONCILIABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_ES_CONCILIABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_TRASPASO						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_TRASPASO		INT
	DECLARE	@VP_D_ESTATUS_TRASPASO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_TRASPASO =			ESTATUS_TRASPASO.K_ESTATUS_TRASPASO,
			@VP_D_ESTATUS_TRASPASO =			ESTATUS_TRASPASO.D_ESTATUS_TRASPASO
										FROM	TRASPASO, ESTATUS_TRASPASO
										WHERE	TRASPASO.K_ESTATUS_TRASPASO=ESTATUS_TRASPASO.K_ESTATUS_TRASPASO
										AND		TRASPASO.K_TRASPASO=@PP_K_TRASPASO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_TRASPASO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [TRASPASO].'
			
	-- =============================
	-- K_ESTATUS_TRASPASO	
	-- #1 BASE | #2 PROGRAMADO | #3 AUTORIZADO | #4 EJECUTADO |
	-- #5 CONCILIADO | #6 CANCELADO | 

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_TRASPASO IN ( 4 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_TRASPASO)+'-'+@VP_D_ESTATUS_TRASPASO+'] del [TRASPASO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // CONCILIADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_CONCILIADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_CONCILIADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_CONCILIADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_TRASPASO					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_TRASPASO_ES_CONCILIABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_TRASPASO,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //CON//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / CONCILIADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_TRASPASO_CONCILIADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_TRASPASO_CONCILIADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_TRASPASO_CONCILIADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_TRASPASO					INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TRASPASO_CONCILIADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_TRASPASO,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_TRASPASO = 1-BASE / 2-PROGRAMADO / 3-AUTORIZADO / 4-EJECUTADO / 5-CONCILIADO / 6-CANCELADO
		
		UPDATE	TRASPASO
		SET		K_ESTATUS_TRASPASO			= 5,		-- CONCILIADO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	TRASPASO.K_TRASPASO=@PP_K_TRASPASO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Conciliar] el [TRASPASO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#TRA.'+CONVERT(VARCHAR(10),@PP_K_TRASPASO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_TRASPASO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CONCILIADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_TRASPASO_CONCILIADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_TRASPASO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_ES_CANCELABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_ES_CANCELABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_ES_CANCELABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_TRASPASO						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_TRASPASO		INT
	DECLARE	@VP_D_ESTATUS_TRASPASO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_TRASPASO =			ESTATUS_TRASPASO.K_ESTATUS_TRASPASO,
			@VP_D_ESTATUS_TRASPASO =			ESTATUS_TRASPASO.D_ESTATUS_TRASPASO
										FROM	TRASPASO, ESTATUS_TRASPASO
										WHERE	TRASPASO.K_ESTATUS_TRASPASO=ESTATUS_TRASPASO.K_ESTATUS_TRASPASO
										AND		TRASPASO.K_TRASPASO=@PP_K_TRASPASO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_TRASPASO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [TRASPASO].' 

	-- =============================
	-- K_ESTATUS_TRASPASO	
	-- #1 BASE | #2 PROGRAMADO | #3 AUTORIZADO | #4 EJECUTADO |
	-- #5 CONCILIADO | #6 CANCELADO | 

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_TRASPASO IN ( 1, 2, 3 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_TRASPASO)+'-'+@VP_D_ESTATUS_TRASPASO+'] del [TRASPASO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // CANCELADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_CANCELADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_CANCELADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_CANCELADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_TRASPASO					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_TRASPASO_ES_CANCELABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_TRASPASO,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //CNC//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / CANCELADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_TRASPASO_CANCELADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_TRASPASO_CANCELADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_TRASPASO_CANCELADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_TRASPASO					INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TRASPASO_CANCELADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_TRASPASO,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_TRASPASO = 1-BASE / 2-PROGRAMADO / 3-AUTORIZADO / 4-EJECUTADO / 5-CONCILIADO / 6-CANCELADO

		UPDATE	TRASPASO
		SET		K_ESTATUS_TRASPASO		= 6,		-- CANCELADO
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	TRASPASO.K_TRASPASO=@PP_K_TRASPASO
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Cancelar] el [TRASPASO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#TRA.'+CONVERT(VARCHAR(10),@PP_K_TRASPASO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_TRASPASO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CANCELADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_TRASPASO_CANCELADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_TRASPASO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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
