-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_WF_INSTRUCCION_20181110_DPR.sql
-- /////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			INSTRUCCIÓN
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_ES_PROGRAMABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_ES_PROGRAMABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_ES_PROGRAMABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_INSTRUCCION					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_INSTRUCCION		INT
	DECLARE	@VP_D_ESTATUS_INSTRUCCION		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_INSTRUCCION =			ESTATUS_INSTRUCCION.K_ESTATUS_INSTRUCCION,
			@VP_D_ESTATUS_INSTRUCCION =			ESTATUS_INSTRUCCION.D_ESTATUS_INSTRUCCION
										FROM	INSTRUCCION, ESTATUS_INSTRUCCION
										WHERE	INSTRUCCION.K_ESTATUS_INSTRUCCION=ESTATUS_INSTRUCCION.K_ESTATUS_INSTRUCCION
										AND		INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_INSTRUCCION IS NULL
			SET @VP_RESULTADO =  'No se localizó la [INSTRUCCIÓN].'
			
	-- =============================
	-- K_ESTATUS_INSTRUCCION	
	-- #1 EN PROCESO | #2 PROGRAMADA | #3 AUTORIZADA | #4 EJECUTADA |
	-- #5 CONCILIADA | #6 CANCELADA |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_INSTRUCCION IN ( 1 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_INSTRUCCION)+'-'+@VP_D_ESTATUS_INSTRUCCION+'] de la [INSTRUCCIÓN] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // PROGRAMADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_PROGRAMADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_PROGRAMADA]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_PROGRAMADA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_INSTRUCCION				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_ES_PROGRAMABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_INSTRUCCION,	 
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //PRG//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / PROGRAMADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_INSTRUCCION_PROGRAMADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_INSTRUCCION_PROGRAMADA]
GO


CREATE PROCEDURE [dbo].[PG_TR_INSTRUCCION_PROGRAMADA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_INSTRUCCION				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_PROGRAMADA]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_INSTRUCCION,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_INSTRUCCION = 1-EN PROCESO / 2-PROGRAMADA / 3-AUTORIZADA / 4-EJECUTADA / 5-CONCILIADA / 6-CANCELADA
		
		UPDATE	INSTRUCCION
		SET		K_ESTATUS_INSTRUCCION		= 2,		-- PROGRAMADA
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Programar] la [INSTRUCCIÓN]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#INS.'+CONVERT(VARCHAR(10),@PP_K_INSTRUCCION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_INSTRUCCION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'PROGRAMADA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_INSTRUCCION_PROGRAMADA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_INSTRUCCION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_ES_AUTORIZABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_ES_AUTORIZABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_ES_AUTORIZABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_INSTRUCCION					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_INSTRUCCION		INT
	DECLARE	@VP_D_ESTATUS_INSTRUCCION		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_INSTRUCCION =			ESTATUS_INSTRUCCION.K_ESTATUS_INSTRUCCION,
			@VP_D_ESTATUS_INSTRUCCION =			ESTATUS_INSTRUCCION.D_ESTATUS_INSTRUCCION
										FROM	INSTRUCCION, ESTATUS_INSTRUCCION
										WHERE	INSTRUCCION.K_ESTATUS_INSTRUCCION=ESTATUS_INSTRUCCION.K_ESTATUS_INSTRUCCION
										AND		INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_INSTRUCCION IS NULL
			SET @VP_RESULTADO =  'No se localizó la [INSTRUCCIÓN].'
			
	-- =============================
	-- K_ESTATUS_INSTRUCCION	
	-- #1 EN PROCESO | #2 PROGRAMADA | #3 AUTORIZADA | #4 EJECUTADA |
	-- #5 CONCILIADA | #6 CANCELADA |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_INSTRUCCION IN ( 2 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_INSTRUCCION)+'-'+@VP_D_ESTATUS_INSTRUCCION+'] de la [INSTRUCCIÓN] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // AUTORIZADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_AUTORIZADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_AUTORIZADA]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_AUTORIZADA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_INSTRUCCION				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_ES_AUTORIZABLE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_INSTRUCCION,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //AUT//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / AUTORIZADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_INSTRUCCION_AUTORIZADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_INSTRUCCION_AUTORIZADA]
GO


CREATE PROCEDURE [dbo].[PG_TR_INSTRUCCION_AUTORIZADA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_INSTRUCCION				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_AUTORIZADA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_INSTRUCCION,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_INSTRUCCION = 1-EN PROCESO / 2-PROGRAMADA / 3-AUTORIZADA / 4-EJECUTADA / 5-CONCILIADA / 6-CANCELADA
		
		UPDATE	INSTRUCCION
		SET		K_ESTATUS_INSTRUCCION		= 3,		-- AUTORIZADA
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Autorizar] la [INSTRUCCIÓN]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#INS.'+CONVERT(VARCHAR(10),@PP_K_INSTRUCCION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_INSTRUCCION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'AUTORIZADA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_INSTRUCCION_AUTORIZADA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_INSTRUCCION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_ES_EJECUTABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_ES_EJECUTABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_ES_EJECUTABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_INSTRUCCION					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_INSTRUCCION		INT
	DECLARE	@VP_D_ESTATUS_INSTRUCCION		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_INSTRUCCION =			ESTATUS_INSTRUCCION.K_ESTATUS_INSTRUCCION,
			@VP_D_ESTATUS_INSTRUCCION =			ESTATUS_INSTRUCCION.D_ESTATUS_INSTRUCCION
										FROM	INSTRUCCION, ESTATUS_INSTRUCCION
										WHERE	INSTRUCCION.K_ESTATUS_INSTRUCCION=ESTATUS_INSTRUCCION.K_ESTATUS_INSTRUCCION
										AND		INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_INSTRUCCION IS NULL
			SET @VP_RESULTADO =  'No se localizó la [INSTRUCCIÓN].' 

	-- =============================
	-- K_ESTATUS_INSTRUCCION	
	-- #1 EN PROCESO | #2 PROGRAMADA | #3 AUTORIZADA | #4 EJECUTADA |
	-- #5 CONCILIADA | #6 CANCELADA |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_INSTRUCCION IN ( 3 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_INSTRUCCION)+'-'+@VP_D_ESTATUS_INSTRUCCION+'] de la [INSTRUCCIÓN] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // EJECUTADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_EJECUTADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_EJECUTADA]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_EJECUTADA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_INSTRUCCION				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_ES_EJECUTABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_INSTRUCCION,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //EJC//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / EJECUTADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_INSTRUCCION_EJECUTADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_INSTRUCCION_EJECUTADA]
GO


CREATE PROCEDURE [dbo].[PG_TR_INSTRUCCION_EJECUTADA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_INSTRUCCION				INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_EJECUTADA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_INSTRUCCION,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_INSTRUCCION = 1-EN PROCESO / 2-PROGRAMADA / 3-AUTORIZADA / 4-EJECUTADA / 5-CONCILIADA / 6-CANCELADA

		UPDATE	INSTRUCCION
		SET		K_ESTATUS_INSTRUCCION	= 4,		-- EJECUTADA
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Ejecutar] la [INSTRUCCIÓN]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#INS.'+CONVERT(VARCHAR(10),@PP_K_INSTRUCCION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_INSTRUCCION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'EJECUTADA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_INSTRUCCION_EJECUTADA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_INSTRUCCION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_ES_CONCILIABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_ES_CONCILIABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_ES_CONCILIABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_INSTRUCCION					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_INSTRUCCION		INT
	DECLARE	@VP_D_ESTATUS_INSTRUCCION		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_INSTRUCCION =		ESTATUS_INSTRUCCION.K_ESTATUS_INSTRUCCION,
			@VP_D_ESTATUS_INSTRUCCION =		ESTATUS_INSTRUCCION.D_ESTATUS_INSTRUCCION
											FROM	INSTRUCCION, ESTATUS_INSTRUCCION
											WHERE	INSTRUCCION.K_ESTATUS_INSTRUCCION=ESTATUS_INSTRUCCION.K_ESTATUS_INSTRUCCION
											AND		INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_INSTRUCCION IS NULL
			SET @VP_RESULTADO =  'No se localizó la [INSTRUCCIÓN].'
			
	-- =============================
	-- K_ESTATUS_INSTRUCCION	
	-- #1 EN PROCESO | #2 PROGRAMADA | #3 AUTORIZADA | #4 EJECUTADA |
	-- #5 CONCILIADA | #6 CANCELADA |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_INSTRUCCION IN ( 4 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_INSTRUCCION)+'-'+@VP_D_ESTATUS_INSTRUCCION+'] de la [INSTRUCCIÓN] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // CONCILIADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_CONCILIADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_CONCILIADA]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_CONCILIADA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_INSTRUCCION				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_ES_CONCILIABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_INSTRUCCION,	 
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //CON//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / CONCILIADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_INSTRUCCION_CONCILIADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_INSTRUCCION_CONCILIADA]
GO


CREATE PROCEDURE [dbo].[PG_TR_INSTRUCCION_CONCILIADA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_INSTRUCCION				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_CONCILIADA]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_INSTRUCCION,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_INSTRUCCION = 1-EN PROCESO / 2-PROGRAMADA / 3-AUTORIZADA / 4-EJECUTADA / 5-CONCILIADA / 6-CANCELADA
		
		UPDATE	INSTRUCCION
		SET		K_ESTATUS_INSTRUCCION		= 5,		-- CONCILIADA
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Conciliar] la [INSTRUCCIÓN]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#INS.'+CONVERT(VARCHAR(10),@PP_K_INSTRUCCION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_INSTRUCCION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CONCILIADA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_INSTRUCCION_CONCILIADA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_INSTRUCCION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_ES_CANCELABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_ES_CANCELABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_ES_CANCELABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_INSTRUCCION					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_INSTRUCCION		INT
	DECLARE	@VP_D_ESTATUS_INSTRUCCION		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_INSTRUCCION =		ESTATUS_INSTRUCCION.K_ESTATUS_INSTRUCCION,
			@VP_D_ESTATUS_INSTRUCCION =		ESTATUS_INSTRUCCION.D_ESTATUS_INSTRUCCION
											FROM	INSTRUCCION, ESTATUS_INSTRUCCION
											WHERE	INSTRUCCION.K_ESTATUS_INSTRUCCION=ESTATUS_INSTRUCCION.K_ESTATUS_INSTRUCCION
											AND		INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_INSTRUCCION IS NULL
			SET @VP_RESULTADO =  'No se localizó la [INSTRUCCIÓN].' 

	-- =============================
	-- K_ESTATUS_INSTRUCCION	
	-- #1 EN PROCESO | #2 PROGRAMADA | #3 AUTORIZADA | #4 EJECUTADA |
	-- #5 CONCILIADA | #6 CANCELADA |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_INSTRUCCION IN ( 1, 2, 3 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_INSTRUCCION)+'-'+@VP_D_ESTATUS_INSTRUCCION+'] de la [INSTRUCCIÓN] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // CANCELADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_CANCELADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_CANCELADA]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_CANCELADA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_INSTRUCCION				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_ES_CANCELABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_INSTRUCCION,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //CNC//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / CANCELADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_INSTRUCCION_CANCELADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_INSTRUCCION_CANCELADA]
GO


CREATE PROCEDURE [dbo].[PG_TR_INSTRUCCION_CANCELADA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_INSTRUCCION				INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_CANCELADA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_INSTRUCCION,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_INSTRUCCION = 1-EN PROCESO / 2-PROGRAMADA / 3-AUTORIZADA / 4-EJECUTADA / 5-CONCILIADA / 6-CANCELADA

		UPDATE	INSTRUCCION
		SET		K_ESTATUS_INSTRUCCION	= 6,		-- CANCELADA
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Cancelar] la [INSTRUCCIÓN]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#INS.'+CONVERT(VARCHAR(10),@PP_K_INSTRUCCION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_INSTRUCCION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CANCELADA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_INSTRUCCION_CANCELADA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_INSTRUCCION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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