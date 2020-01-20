-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_WF_DOCUMENTO_D0M4_20181112_DPR.sql
-- /////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			DOCUMENTO_D0M4
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DOCUMENTO_D0M4_ES_PROCESABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_ES_PROCESABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_ES_PROCESABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_DOCUMENTO_D0M4				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_DOCUMENTO_D0M4		INT
	DECLARE	@VP_D_ESTATUS_DOCUMENTO_D0M4		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_DOCUMENTO_D0M4 =			ESTATUS_DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4,
			@VP_D_ESTATUS_DOCUMENTO_D0M4 =			ESTATUS_DOCUMENTO_D0M4.D_ESTATUS_DOCUMENTO_D0M4
											FROM	DOCUMENTO_D0M4, ESTATUS_DOCUMENTO_D0M4
											WHERE	DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4=ESTATUS_DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4
											AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_DOCUMENTO_D0M4 IS NULL
			SET @VP_RESULTADO =  'No se localizó el [DOCUMENTO_D0M4].'
			
	-- =============================
	-- K_ESTATUS_DOCUMENTO_D0M4	
	-- #1 ABIERTO | #2 EN PROCESO | #3 PREVIO | #4 CERRADO |
	-- #5 AUTORIZADO | 

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_DOCUMENTO_D0M4 IN ( 1 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_DOCUMENTO_D0M4)+'-'+@VP_D_ESTATUS_DOCUMENTO_D0M4+'] del [DOCUMENTO_D0M4] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // EN PROCESO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DOCUMENTO_D0M4_EN_PROCESO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_EN_PROCESO]
GO


CREATE PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_EN_PROCESO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_DOCUMENTO_D0M4			[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_ES_PROCESABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_DOCUMENTO_D0M4,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_DOCUMENTO_D0M4_EN_PROCESO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_DOCUMENTO_D0M4_EN_PROCESO]
GO


CREATE PROCEDURE [dbo].[PG_TR_DOCUMENTO_D0M4_EN_PROCESO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_EN_PROCESO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_DOCUMENTO_D0M4 = 1-ABIERTO / 2-EN PROCESO / 3-PREVIO / 4-CERRADO / 5-AUTORIZADO
		
		UPDATE	DOCUMENTO_D0M4
		SET		K_ESTATUS_DOCUMENTO_D0M4	= 2,		-- EN PROCESO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible poner [En Proceso] el [DOCUMENTO_D0M4]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#D0M4.'+CONVERT(VARCHAR(10),@PP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'EN PROCESO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_DOCUMENTO_D0M4_EN_PROCESO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_DOCUMENTO_D0M4, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DOCUMENTO_D0M4_ES_PREVIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_ES_PREVIO]
GO


CREATE PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_ES_PREVIO]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_DOCUMENTO_D0M4				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_DOCUMENTO_D0M4		INT
	DECLARE	@VP_D_ESTATUS_DOCUMENTO_D0M4		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_DOCUMENTO_D0M4 =			ESTATUS_DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4,
			@VP_D_ESTATUS_DOCUMENTO_D0M4 =			ESTATUS_DOCUMENTO_D0M4.D_ESTATUS_DOCUMENTO_D0M4
											FROM	DOCUMENTO_D0M4, ESTATUS_DOCUMENTO_D0M4
											WHERE	DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4=ESTATUS_DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4
											AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_DOCUMENTO_D0M4 IS NULL
			SET @VP_RESULTADO =  'No se localizó el [DOCUMENTO_D0M4].'
			
	-- =============================
	-- K_ESTATUS_DOCUMENTO_D0M4	
	-- #1 ABIERTO | #2 EN PROCESO | #3 PREVIO | #4 CERRADO |
	-- #5 AUTORIZADO | 

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_DOCUMENTO_D0M4 IN ( 2 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_DOCUMENTO_D0M4)+'-'+@VP_D_ESTATUS_DOCUMENTO_D0M4+'] del [DOCUMENTO_D0M4] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // PREVIO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DOCUMENTO_D0M4_PREVIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_PREVIO]
GO


CREATE PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_PREVIO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_DOCUMENTO_D0M4			[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_ES_PREVIO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //PRV//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / PREVIO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_DOCUMENTO_D0M4_PREVIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_DOCUMENTO_D0M4_PREVIO]
GO


CREATE PROCEDURE [dbo].[PG_TR_DOCUMENTO_D0M4_PREVIO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_PREVIO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_DOCUMENTO_D0M4,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_DOCUMENTO_D0M4 = 1-ABIERTO / 2-EN PROCESO / 3-PREVIO / 4-CERRADO / 5-AUTORIZADO
		
		UPDATE	DOCUMENTO_D0M4
		SET		K_ESTATUS_DOCUMENTO_D0M4	= 3,		-- PREVIO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible poner en estatus de [Previo] el [DOCUMENTO_D0M4]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#D0M4.'+CONVERT(VARCHAR(10),@PP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'PREVIO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_DOCUMENTO_D0M4_PREVIO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_DOCUMENTO_D0M4, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DOCUMENTO_D0M4_ES_AUTORIZABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_ES_AUTORIZABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_ES_AUTORIZABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_DOCUMENTO_D0M4				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_DOCUMENTO_D0M4		INT
	DECLARE	@VP_D_ESTATUS_DOCUMENTO_D0M4		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_DOCUMENTO_D0M4 =			ESTATUS_DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4,
			@VP_D_ESTATUS_DOCUMENTO_D0M4 =			ESTATUS_DOCUMENTO_D0M4.D_ESTATUS_DOCUMENTO_D0M4
											FROM	DOCUMENTO_D0M4, ESTATUS_DOCUMENTO_D0M4
											WHERE	DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4=ESTATUS_DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4
											AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_DOCUMENTO_D0M4 IS NULL
			SET @VP_RESULTADO =  'No se localizó el [DOCUMENTO_D0M4].' 

	-- =============================
	-- K_ESTATUS_DOCUMENTO_D0M4	
	-- #1 ABIERTO | #2 EN PROCESO | #3 PREVIO | #4 CERRADO |
	-- #5 AUTORIZADO | 

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_DOCUMENTO_D0M4 IN ( 3 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_DOCUMENTO_D0M4)+'-'+@VP_D_ESTATUS_DOCUMENTO_D0M4+'] del [DOCUMENTO_D0M4] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // AUTORIZADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DOCUMENTO_D0M4_AUTORIZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_AUTORIZADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_AUTORIZADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_DOCUMENTO_D0M4			[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_ES_AUTORIZABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_DOCUMENTO_D0M4,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_DOCUMENTO_D0M4_AUTORIZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_DOCUMENTO_D0M4_AUTORIZADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_DOCUMENTO_D0M4_AUTORIZADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4			INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_AUTORIZADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_DOCUMENTO_D0M4 = 1-ABIERTO / 2-EN PROCESO / 3-PREVIO / 4-CERRADO / 5-AUTORIZADO

		UPDATE	DOCUMENTO_D0M4
		SET		K_ESTATUS_DOCUMENTO_D0M4		= 5,		-- AUTORIZADO
				-- ====================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION
		WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Autorizar] el [DOCUMENTO_D0M4]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#D0M4.'+CONVERT(VARCHAR(10),@PP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'AUTORIZADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_DOCUMENTO_D0M4_AUTORIZADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_DOCUMENTO_D0M4, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DOCUMENTO_D0M4_ES_CERRABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_ES_CERRABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_ES_CERRABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_DOCUMENTO_D0M4				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_DOCUMENTO_D0M4		INT
	DECLARE	@VP_D_ESTATUS_DOCUMENTO_D0M4		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_DOCUMENTO_D0M4 =			ESTATUS_DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4,
			@VP_D_ESTATUS_DOCUMENTO_D0M4 =			ESTATUS_DOCUMENTO_D0M4.D_ESTATUS_DOCUMENTO_D0M4
											FROM	DOCUMENTO_D0M4, ESTATUS_DOCUMENTO_D0M4
											WHERE	DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4=ESTATUS_DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4
											AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_DOCUMENTO_D0M4 IS NULL
			SET @VP_RESULTADO =  'No se localizó el [DOCUMENTO_D0M4].' 

	-- =============================
	-- K_ESTATUS_DOCUMENTO_D0M4	
	-- #1 ABIERTO | #2 EN PROCESO | #3 PREVIO | #4 CERRADO |
	-- #5 AUTORIZADO | 

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_DOCUMENTO_D0M4 IN ( 1, 2, 3, 5 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_DOCUMENTO_D0M4)+'-'+@VP_D_ESTATUS_DOCUMENTO_D0M4+'] del [DOCUMENTO_D0M4] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // CERRADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DOCUMENTO_D0M4_CERRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_CERRADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_CERRADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_DOCUMENTO_D0M4			[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_ES_CERRABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_DOCUMENTO_D0M4,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_DOCUMENTO_D0M4_CERRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_DOCUMENTO_D0M4_CERRADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_DOCUMENTO_D0M4_CERRADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4			INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_CERRADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_DOCUMENTO_D0M4 = 1-ABIERTO / 2-EN PROCESO / 3-PREVIO / 4-CERRADO / 5-AUTORIZADO

		UPDATE	DOCUMENTO_D0M4
		SET		K_ESTATUS_DOCUMENTO_D0M4		= 4,		-- CERRADO
				-- ====================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION
		WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Cerrar] el [DOCUMENTO_D0M4]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#D0M4.'+CONVERT(VARCHAR(10),@PP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CERRADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_DOCUMENTO_D0M4_CERRADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_DOCUMENTO_D0M4, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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