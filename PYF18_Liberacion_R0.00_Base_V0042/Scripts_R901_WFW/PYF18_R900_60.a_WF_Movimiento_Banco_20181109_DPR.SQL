-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_WF_MOVIMIENTO_BANCO_20181109_DPR.sql
-- /////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			MOVIMIENTO_BANCO
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_ES_PAGO_POR_APLICAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_ES_PAGO_POR_APLICAR]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_ES_PAGO_POR_APLICAR]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_MOVIMIENTO_BANCO				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_MOVIMIENTO_BANCO		INT
	DECLARE	@VP_D_ESTATUS_MOVIMIENTO_BANCO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_MOVIMIENTO_BANCO =		ESTATUS_MOVIMIENTO_BANCO.K_ESTATUS_MOVIMIENTO_BANCO,
			@VP_D_ESTATUS_MOVIMIENTO_BANCO =		ESTATUS_MOVIMIENTO_BANCO.D_ESTATUS_MOVIMIENTO_BANCO
											FROM	MOVIMIENTO_BANCO, ESTATUS_MOVIMIENTO_BANCO
											WHERE	MOVIMIENTO_BANCO.K_ESTATUS_MOVIMIENTO_BANCO=ESTATUS_MOVIMIENTO_BANCO.K_ESTATUS_MOVIMIENTO_BANCO
											AND		MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_MOVIMIENTO_BANCO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [MOVIMIENTO_BANCO].'
			
	-- =============================
	-- K_ESTATUS_MOVIMIENTO_BANCO	
	-- #1 REPORTADO | #2 PAGO POR APLICAR | #3 APLICADO A COBRANZA | #4 CANCELADO |
	
	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_MOVIMIENTO_BANCO IN ( 1 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_MOVIMIENTO_BANCO)+'-'+@VP_D_ESTATUS_MOVIMIENTO_BANCO+'] del [MOVIMIENTO_BANCO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // PAGO POR APLICAR
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_PAGO_POR_APLICAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_PAGO_POR_APLICAR]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_PAGO_POR_APLICAR]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_MOVIMIENTO_BANCO			[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_ES_PAGO_POR_APLICAR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_MOVIMIENTO_BANCO,	 
																		@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //PAPL//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / PAGO POR APLICAR
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_MOVIMIENTO_BANCO_PAGO_POR_APLICAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_PAGO_POR_APLICAR]
GO


CREATE PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_PAGO_POR_APLICAR]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_MOVIMIENTO_BANCO			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_PAGO_POR_APLICAR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_MOVIMIENTO_BANCO,
																	@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_MOVIMIENTO_BANCO = 1-REPORTADO / 2-PAGO POR APLICAR / 3-APLICADO A COBRANZA / 4-CANCELADO
		
		UPDATE	MOVIMIENTO_BANCO
		SET		K_ESTATUS_MOVIMIENTO_BANCO		= 2,		-- PAGO POR APLICAR
				-- ====================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION 
		WHERE	MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible poner en estatus de [Pago por Aplicar] el [MOVIMIENTO_BANCO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#MBA.'+CONVERT(VARCHAR(10),@PP_K_MOVIMIENTO_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MOVIMIENTO_BANCO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'PAGO POR APLICAR',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_MOVIMIENTO_BANCO_PAGO_POR_APLICAR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_MOVIMIENTO_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_ES_APLICABLE_A_COBRANZA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_ES_APLICABLE_A_COBRANZA]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_ES_APLICABLE_A_COBRANZA]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_MOVIMIENTO_BANCO				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_MOVIMIENTO_BANCO		INT
	DECLARE	@VP_D_ESTATUS_MOVIMIENTO_BANCO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_MOVIMIENTO_BANCO =		ESTATUS_MOVIMIENTO_BANCO.K_ESTATUS_MOVIMIENTO_BANCO,
			@VP_D_ESTATUS_MOVIMIENTO_BANCO =		ESTATUS_MOVIMIENTO_BANCO.D_ESTATUS_MOVIMIENTO_BANCO
											FROM	MOVIMIENTO_BANCO, ESTATUS_MOVIMIENTO_BANCO
											WHERE	MOVIMIENTO_BANCO.K_ESTATUS_MOVIMIENTO_BANCO=ESTATUS_MOVIMIENTO_BANCO.K_ESTATUS_MOVIMIENTO_BANCO
											AND		MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_MOVIMIENTO_BANCO IS NULL
			SET @VP_RESULTADO =  'No se localizó la [MOVIMIENTO_BANCO].'
			
	-- =============================
	-- K_ESTATUS_MOVIMIENTO_BANCO	
	-- #1 PREVIO | #2 ACTIVO | #3 HISTÓRICO |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_MOVIMIENTO_BANCO IN ( 2 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_MOVIMIENTO_BANCO)+'-'+@VP_D_ESTATUS_MOVIMIENTO_BANCO+'] del [MOVIMIENTO_BANCO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // APLICADO A COBRANZA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_APLICADO_A_COBRANZA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_APLICADO_A_COBRANZA]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_APLICADO_A_COBRANZA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_MOVIMIENTO_BANCO			[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_ES_APLICABLE_A_COBRANZA]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_MOVIMIENTO_BANCO,	 
																		@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //APLC//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / APLICADO A COBRANZA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_MOVIMIENTO_BANCO_APLICADO_A_COBRANZA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_APLICADO_A_COBRANZA]
GO


CREATE PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_APLICADO_A_COBRANZA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_MOVIMIENTO_BANCO			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_APLICADO_A_COBRANZA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_MOVIMIENTO_BANCO,
																		@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_MOVIMIENTO_BANCO = 1-REPORTADO / 2-PAGO POR APLICAR / 3-APLICADO A COBRANZA / 4-CANCELADO
		
		UPDATE	MOVIMIENTO_BANCO
		SET		K_ESTATUS_MOVIMIENTO_BANCO		= 3,		-- APLICADO A COBRANZA
				-- ====================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION 
		WHERE	MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Aplicar a Cobranza] el [MOVIMIENTO_BANCO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PSU.'+CONVERT(VARCHAR(10),@PP_K_MOVIMIENTO_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MOVIMIENTO_BANCO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'APLICADO A COBRANZA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_MOVIMIENTO_BANCO_APLICADO_A_COBRANZA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_MOVIMIENTO_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_ES_CANCELABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_ES_CANCELABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_ES_CANCELABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_MOVIMIENTO_BANCO				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_MOVIMIENTO_BANCO		INT
	DECLARE	@VP_D_ESTATUS_MOVIMIENTO_BANCO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_MOVIMIENTO_BANCO =		ESTATUS_MOVIMIENTO_BANCO.K_ESTATUS_MOVIMIENTO_BANCO,
			@VP_D_ESTATUS_MOVIMIENTO_BANCO =		ESTATUS_MOVIMIENTO_BANCO.D_ESTATUS_MOVIMIENTO_BANCO
											FROM	MOVIMIENTO_BANCO, ESTATUS_MOVIMIENTO_BANCO
											WHERE	MOVIMIENTO_BANCO.K_ESTATUS_MOVIMIENTO_BANCO=ESTATUS_MOVIMIENTO_BANCO.K_ESTATUS_MOVIMIENTO_BANCO
											AND		MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_MOVIMIENTO_BANCO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [MOVIMIENTO_BANCO].'
			
	-- =============================
	-- K_ESTATUS_MOVIMIENTO_BANCO	
	-- #1 REPORTADO | #2 PAGO POR APLICAR | #3 APLICADO A COBRANZA | #4 CANCELADO |
	
	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_MOVIMIENTO_BANCO IN ( 1, 2 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_MOVIMIENTO_BANCO)+'-'+@VP_D_ESTATUS_MOVIMIENTO_BANCO+'] del [MOVIMIENTO_BANCO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // CANCELADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_CANCELADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CANCELADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CANCELADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_MOVIMIENTO_BANCO			[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_ES_CANCELABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_MOVIMIENTO_BANCO,	 
																	@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //CNC//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / CANCELADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_MOVIMIENTO_BANCO_CANCELADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_CANCELADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_CANCELADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_MOVIMIENTO_BANCO			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_CANCELADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_MOVIMIENTO_BANCO,
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_MOVIMIENTO_BANCO = 1-REPORTADO / 2-PAGO POR APLICAR / 3-APLICADO A COBRANZA / 4-CANCELADO
		
		UPDATE	MOVIMIENTO_BANCO
		SET		K_ESTATUS_MOVIMIENTO_BANCO		= 4,		-- CANCELADO
				-- ====================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION 
		WHERE	MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Cancelar] el [MOVIMIENTO_BANCO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#MBA.'+CONVERT(VARCHAR(10),@PP_K_MOVIMIENTO_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MOVIMIENTO_BANCO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CANCELADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_MOVIMIENTO_BANCO_CANCELADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_MOVIMIENTO_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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