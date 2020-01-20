-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_WF_PRESUPUESTO_20181112_DPR.sql
-- /////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			PRESUPUESTO
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_ES_PROCESABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_ES_PROCESABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_ES_PROCESABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_PRESUPUESTO		INT
	DECLARE	@VP_D_ESTATUS_PRESUPUESTO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_PRESUPUESTO =			ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO,
			@VP_D_ESTATUS_PRESUPUESTO =			ESTATUS_PRESUPUESTO.D_ESTATUS_PRESUPUESTO
										FROM	PRESUPUESTO, ESTATUS_PRESUPUESTO
										WHERE	PRESUPUESTO.K_ESTATUS_PRESUPUESTO=ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO
										AND		PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_PRESUPUESTO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [PRESUPUESTO].'
			
	-- =============================
	-- K_ESTATUS_PRESUPUESTO	
	-- #1 BASE | #2 EN PROCESO | #3 PREVIO | #4 AUTORIZADO |
	-- #5 CANCELADO | #6 EJECUTADO | #7 CERRADO |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_PRESUPUESTO IN ( 1 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_PRESUPUESTO)+'-'+@VP_D_ESTATUS_PRESUPUESTO+'] del [PRESUPUESTO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // EN PROCESO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_EN_PROCESO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_EN_PROCESO]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_EN_PROCESO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_ES_PROCESABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PRESUPUESTO,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_PRESUPUESTO_EN_PROCESO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_PRESUPUESTO_EN_PROCESO]
GO


CREATE PROCEDURE [dbo].[PG_TR_PRESUPUESTO_EN_PROCESO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_PRESUPUESTO				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_EN_PROCESO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PRESUPUESTO,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_PRESUPUESTO = 1-BASE / 2-EN PROCESO / 3-PREVIO / 4-AUTORIZADO / 5-CANCELADO / 6-EJECUTADO / 7-CERRADO
		
		UPDATE	PRESUPUESTO
		SET		K_ESTATUS_PRESUPUESTO		= 2,		-- EN PROCESO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible poner [En Proceso] el [PRESUPUESTO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PRE.'+CONVERT(VARCHAR(10),@PP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRESUPUESTO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'EN PROCESO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_PRESUPUESTO_EN_PROCESO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PRESUPUESTO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_ES_PREVIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_ES_PREVIO]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_ES_PREVIO]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_PRESUPUESTO		INT
	DECLARE	@VP_D_ESTATUS_PRESUPUESTO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_PRESUPUESTO =			ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO,
			@VP_D_ESTATUS_PRESUPUESTO =			ESTATUS_PRESUPUESTO.D_ESTATUS_PRESUPUESTO
										FROM	PRESUPUESTO, ESTATUS_PRESUPUESTO
										WHERE	PRESUPUESTO.K_ESTATUS_PRESUPUESTO=ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO
										AND		PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_PRESUPUESTO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [PRESUPUESTO].'
			
	-- =============================
	-- K_ESTATUS_PRESUPUESTO	
	-- #1 BASE | #2 EN PROCESO | #3 PREVIO | #4 AUTORIZADO |
	-- #5 CANCELADO | #6 EJECUTADO | #7 CERRADO |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_PRESUPUESTO IN ( 2 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_PRESUPUESTO)+'-'+@VP_D_ESTATUS_PRESUPUESTO+'] del [PRESUPUESTO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // PREVIO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_PREVIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_PREVIO]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_PREVIO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_ES_PREVIO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PRESUPUESTO,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_PRESUPUESTO_PREVIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_PRESUPUESTO_PREVIO]
GO


CREATE PROCEDURE [dbo].[PG_TR_PRESUPUESTO_PREVIO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_PRESUPUESTO				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_PREVIO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PRESUPUESTO,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_PRESUPUESTO = 1-BASE / 2-EN PROCESO / 3-PREVIO / 4-AUTORIZADO / 5-CANCELADO / 6-EJECUTADO / 7-CERRADO
		
		UPDATE	PRESUPUESTO
		SET		K_ESTATUS_PRESUPUESTO		= 3,		-- PREVIO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible poner en estatus de [Previo] el [PRESUPUESTO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PRE.'+CONVERT(VARCHAR(10),@PP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRESUPUESTO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'PREVIO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_PRESUPUESTO_PREVIO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PRESUPUESTO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_ES_AUTORIZABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_ES_AUTORIZABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_ES_AUTORIZABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_PRESUPUESTO		INT
	DECLARE	@VP_D_ESTATUS_PRESUPUESTO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_PRESUPUESTO =			ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO,
			@VP_D_ESTATUS_PRESUPUESTO =			ESTATUS_PRESUPUESTO.D_ESTATUS_PRESUPUESTO
										FROM	PRESUPUESTO, ESTATUS_PRESUPUESTO
										WHERE	PRESUPUESTO.K_ESTATUS_PRESUPUESTO=ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO
										AND		PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_PRESUPUESTO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [PRESUPUESTO].' 

	-- =============================
	-- K_ESTATUS_PRESUPUESTO	
	-- #1 BASE | #2 EN PROCESO | #3 PREVIO | #4 AUTORIZADO |
	-- #5 CANCELADO | #6 EJECUTADO | #7 CERRADO |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_PRESUPUESTO IN ( 3 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_PRESUPUESTO)+'-'+@VP_D_ESTATUS_PRESUPUESTO+'] del [PRESUPUESTO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // AUTORIZADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_AUTORIZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_AUTORIZADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_AUTORIZADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_ES_AUTORIZABLE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PRESUPUESTO,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_PRESUPUESTO_AUTORIZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_PRESUPUESTO_AUTORIZADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_PRESUPUESTO_AUTORIZADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_PRESUPUESTO				INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_AUTORIZADO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PRESUPUESTO,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_PRESUPUESTO = 1-BASE / 2-EN PROCESO / 3-PREVIO / 4-AUTORIZADO / 5-CANCELADO / 6-EJECUTADO / 7-CERRADO

		UPDATE	PRESUPUESTO
		SET		K_ESTATUS_PRESUPUESTO	= 4,		-- AUTORIZADO
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Autorizar] el [PRESUPUESTO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PRE.'+CONVERT(VARCHAR(10),@PP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRESUPUESTO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'AUTORIZADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_PRESUPUESTO_AUTORIZADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PRESUPUESTO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_ES_CANCELABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_ES_CANCELABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_ES_CANCELABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_PRESUPUESTO		INT
	DECLARE	@VP_D_ESTATUS_PRESUPUESTO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_PRESUPUESTO =			ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO,
			@VP_D_ESTATUS_PRESUPUESTO =			ESTATUS_PRESUPUESTO.D_ESTATUS_PRESUPUESTO
										FROM	PRESUPUESTO, ESTATUS_PRESUPUESTO
										WHERE	PRESUPUESTO.K_ESTATUS_PRESUPUESTO=ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO
										AND		PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_PRESUPUESTO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [PRESUPUESTO].'
			
	-- =============================
	-- K_ESTATUS_PRESUPUESTO	
	-- #1 BASE | #2 EN PROCESO | #3 PREVIO | #4 AUTORIZADO |
	-- #5 CANCELADO | #6 EJECUTADO | #7 CERRADO |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_PRESUPUESTO IN ( 1, 2, 3, 4 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_PRESUPUESTO)+'-'+@VP_D_ESTATUS_PRESUPUESTO+'] del [PRESUPUESTO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // CANCELADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_CANCELADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_CANCELADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_CANCELADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_ES_CANCELABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PRESUPUESTO,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_PRESUPUESTO_CANCELADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_PRESUPUESTO_CANCELADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_PRESUPUESTO_CANCELADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_PRESUPUESTO				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_CANCELADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PRESUPUESTO,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_PRESUPUESTO = 1-BASE / 2-EN PROCESO / 3-PREVIO / 4-AUTORIZADO / 5-CANCELADO / 6-EJECUTADO / 7-CERRADO
		
		UPDATE	PRESUPUESTO
		SET		K_ESTATUS_PRESUPUESTO		= 5,		-- CANCELADO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Cancelar] el [PRESUPUESTO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PRE.'+CONVERT(VARCHAR(10),@PP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRESUPUESTO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CANCELADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_PRESUPUESTO_CANCELADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PRESUPUESTO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_ES_EJECUTABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_ES_EJECUTABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_ES_EJECUTABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_PRESUPUESTO		INT
	DECLARE	@VP_D_ESTATUS_PRESUPUESTO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_PRESUPUESTO =			ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO,
			@VP_D_ESTATUS_PRESUPUESTO =			ESTATUS_PRESUPUESTO.D_ESTATUS_PRESUPUESTO
										FROM	PRESUPUESTO, ESTATUS_PRESUPUESTO
										WHERE	PRESUPUESTO.K_ESTATUS_PRESUPUESTO=ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO
										AND		PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_PRESUPUESTO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [PRESUPUESTO].' 

	-- =============================
	-- K_ESTATUS_PRESUPUESTO	
	-- #1 BASE | #2 EN PROCESO | #3 PREVIO | #4 AUTORIZADO |
	-- #5 CANCELADO | #6 EJECUTADO | #7 CERRADO |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_PRESUPUESTO IN ( 4 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_PRESUPUESTO)+'-'+@VP_D_ESTATUS_PRESUPUESTO+'] del [PRESUPUESTO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // EJECUTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_EJECUTADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_EJECUTADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_EJECUTADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_ES_EJECUTABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PRESUPUESTO,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //EJC//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / EJECUTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_PRESUPUESTO_EJECUTADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_PRESUPUESTO_EJECUTADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_PRESUPUESTO_EJECUTADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_PRESUPUESTO				INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_EJECUTADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PRESUPUESTO,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_PRESUPUESTO = 1-BASE / 2-EN PROCESO / 3-PREVIO / 4-AUTORIZADO / 5-CANCELADO / 6-EJECUTADO / 7-CERRADO

		UPDATE	PRESUPUESTO
		SET		K_ESTATUS_PRESUPUESTO	= 6,		-- EJECUTADO
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Ejecutar] el [PRESUPUESTO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PRE.'+CONVERT(VARCHAR(10),@PP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRESUPUESTO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'EJECUTADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_PRESUPUESTO_EJECUTADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PRESUPUESTO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_ES_CERRABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_ES_CERRABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_ES_CERRABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_PRESUPUESTO		INT
	DECLARE	@VP_D_ESTATUS_PRESUPUESTO		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_PRESUPUESTO =			ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO,
			@VP_D_ESTATUS_PRESUPUESTO =			ESTATUS_PRESUPUESTO.D_ESTATUS_PRESUPUESTO
										FROM	PRESUPUESTO, ESTATUS_PRESUPUESTO
										WHERE	PRESUPUESTO.K_ESTATUS_PRESUPUESTO=ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO
										AND		PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_PRESUPUESTO IS NULL
			SET @VP_RESULTADO =  'No se localizó el [PRESUPUESTO].' 

	-- =============================
	-- K_ESTATUS_PRESUPUESTO	
	-- #1 BASE | #2 EN PROCESO | #3 PREVIO | #4 AUTORIZADO |
	-- #5 CANCELADO | #6 EJECUTADO | #7 CERRADO |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_PRESUPUESTO IN ( 6 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_PRESUPUESTO)+'-'+@VP_D_ESTATUS_PRESUPUESTO+'] del [PRESUPUESTO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // CERRADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_CERRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_CERRADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_CERRADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_ES_CERRABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PRESUPUESTO,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_PRESUPUESTO_CERRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_PRESUPUESTO_CERRADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_PRESUPUESTO_CERRADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_PRESUPUESTO				INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_CERRADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PRESUPUESTO,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_PRESUPUESTO = 1-BASE / 2-EN PROCESO / 3-PREVIO / 4-AUTORIZADO / 5-CANCELADO / 6-EJECUTADO / 7-CERRADO

		UPDATE	PRESUPUESTO
		SET		K_ESTATUS_PRESUPUESTO	= 7,		-- CERRADO
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Cerrar] el [PRESUPUESTO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PRE.'+CONVERT(VARCHAR(10),@PP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRESUPUESTO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CERRADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_PRESUPUESTO_CERRADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PRESUPUESTO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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