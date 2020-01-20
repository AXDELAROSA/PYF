-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_WF_MOVIMIENTO_BANCO_CONCILIACION_20181109_DPR.sql
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_INVESTIGABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_INVESTIGABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_INVESTIGABLE]
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

	DECLARE @VP_K_ESTATUS_CONCILIACION				INT
	DECLARE	@VP_D_ESTATUS_CONCILIACION				VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_CONCILIACION =			ESTATUS_CONCILIACION.K_ESTATUS_CONCILIACION,
			@VP_D_ESTATUS_CONCILIACION =			ESTATUS_CONCILIACION.D_ESTATUS_CONCILIACION
											FROM	MOVIMIENTO_BANCO, ESTATUS_CONCILIACION
											WHERE	MOVIMIENTO_BANCO.K_ESTATUS_CONCILIACION=ESTATUS_CONCILIACION.K_ESTATUS_CONCILIACION
											AND		MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_CONCILIACION IS NULL
			SET @VP_RESULTADO =  'No se localizó el [MOVIMIENTO_BANCO].'
			
	-- =============================
	-- K_ESTATUS_CONCILIACION	
	-- #0 PENDIENTE | #1 INVESTIGACIÓN | #2 ACLARACIÓN | #3 CONCILIADO | #4 NO CONCILIABLE |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_CONCILIACION IN ( 0 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_CONCILIACION)+'-'+@VP_D_ESTATUS_CONCILIACION+'] de la [CONCILIACIÓN] del [MOVIMIENTO_BANCO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // INVESTIGACIÓN
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_INVESTIGACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_INVESTIGACION]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_INVESTIGACION]
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
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_INVESTIGABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																				@PP_K_MOVIMIENTO_BANCO,	 
																				@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //INV//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / INVESTIGACIÓN
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_INVESTIGACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_INVESTIGACION]
GO


CREATE PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_INVESTIGACION]
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
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_INVESTIGACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_MOVIMIENTO_BANCO,
																			@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_MOVIMIENTO_BANCO = 0-PENDIENTE / 1-INVESTIGACIÓN / 2-ACLARACIÓN / 3-CONCILIADO / 4-NO CONCILIABLE
			
		UPDATE	MOVIMIENTO_BANCO
		SET		K_ESTATUS_MOVIMIENTO_BANCO		= 1,		-- INVESTIGACIÓN
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible poner en estatus de [Investigación] la [CONCILIACIÓN] del [MOVIMIENTO_BANCO]: ' + @VP_MENSAJE 
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
													'INVESTIGACIÓN',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_INVESTIGACION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_ACLARABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_ACLARABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_ACLARABLE]
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

	DECLARE @VP_K_ESTATUS_CONCILIACION				INT
	DECLARE	@VP_D_ESTATUS_CONCILIACION				VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_CONCILIACION =			ESTATUS_CONCILIACION.K_ESTATUS_CONCILIACION,
			@VP_D_ESTATUS_CONCILIACION =			ESTATUS_CONCILIACION.D_ESTATUS_CONCILIACION
											FROM	MOVIMIENTO_BANCO, ESTATUS_CONCILIACION
											WHERE	MOVIMIENTO_BANCO.K_ESTATUS_CONCILIACION=ESTATUS_CONCILIACION.K_ESTATUS_CONCILIACION
											AND		MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_CONCILIACION IS NULL
			SET @VP_RESULTADO =  'No se localizó el [MOVIMIENTO_BANCO].'
			
	-- =============================
	-- K_ESTATUS_CONCILIACION	
	-- #0 PENDIENTE | #1 INVESTIGACIÓN | #2 ACLARACIÓN | #3 CONCILIADO | #4 NO CONCILIABLE |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_CONCILIACION IN ( 1 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_CONCILIACION)+'-'+@VP_D_ESTATUS_CONCILIACION+'] de la [CONCILIACIÓN] del [MOVIMIENTO_BANCO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // ACLARACIÓN
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ACLARACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ACLARACION]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ACLARACION]
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
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_ACLARABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																				@PP_K_MOVIMIENTO_BANCO,	 
																				@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //ACL//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / ACLARACIÓN
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_ACLARACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_ACLARACION]
GO


CREATE PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_ACLARACION]
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
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ACLARACION]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_MOVIMIENTO_BANCO,
																			@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_MOVIMIENTO_BANCO = 0-PENDIENTE / 1-INVESTIGACIÓN / 2-ACLARACIÓN / 3-CONCILIADO / 4-NO CONCILIABLE
			
		UPDATE	MOVIMIENTO_BANCO
		SET		K_ESTATUS_MOVIMIENTO_BANCO	= 2,		-- ACLARACIÓN
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible poner en estatus de [Aclaración] la [CONCILIACIÓN] del [MOVIMIENTO_BANCO]: ' + @VP_MENSAJE 
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
													'ACLARACIÓN',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_ACLARACION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_CONCILIABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_CONCILIABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_CONCILIABLE]
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

	DECLARE @VP_K_ESTATUS_CONCILIACION				INT
	DECLARE	@VP_D_ESTATUS_CONCILIACION				VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_CONCILIACION =			ESTATUS_CONCILIACION.K_ESTATUS_CONCILIACION,
			@VP_D_ESTATUS_CONCILIACION =			ESTATUS_CONCILIACION.D_ESTATUS_CONCILIACION
											FROM	MOVIMIENTO_BANCO, ESTATUS_CONCILIACION
											WHERE	MOVIMIENTO_BANCO.K_ESTATUS_CONCILIACION=ESTATUS_CONCILIACION.K_ESTATUS_CONCILIACION
											AND		MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_CONCILIACION IS NULL
			SET @VP_RESULTADO =  'No se localizó el [MOVIMIENTO_BANCO].'
			
	-- =============================
	-- K_ESTATUS_CONCILIACION	
	-- #0 PENDIENTE | #1 INVESTIGACIÓN | #2 ACLARACIÓN | #3 CONCILIADO | #4 NO CONCILIABLE |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_CONCILIACION IN ( 0, 1, 2 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_CONCILIACION)+'-'+@VP_D_ESTATUS_CONCILIACION+'] de la [CONCILIACIÓN] del [MOVIMIENTO_BANCO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // CONCILIADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_CONCILIADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_CONCILIADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_CONCILIADO]
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
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_CONCILIABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																				@PP_K_MOVIMIENTO_BANCO,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_CONCILIADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_CONCILIADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_CONCILIADO]
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
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_CONCILIADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_MOVIMIENTO_BANCO,
																			@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_MOVIMIENTO_BANCO = 0-PENDIENTE / 1-INVESTIGACIÓN / 2-ACLARACIÓN / 3-CONCILIADO / 4-NO CONCILIABLE
			
		UPDATE	MOVIMIENTO_BANCO
		SET		K_ESTATUS_MOVIMIENTO_BANCO	= 3,		-- CONCILIADO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Conciliar] el [MOVIMIENTO_BANCO]: ' + @VP_MENSAJE 
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
													'CONCILIADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_CONCILIADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_NO_CONCILIABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_NO_CONCILIABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_NO_CONCILIABLE]
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

	DECLARE @VP_K_ESTATUS_CONCILIACION				INT
	DECLARE	@VP_D_ESTATUS_CONCILIACION				VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_CONCILIACION =			ESTATUS_CONCILIACION.K_ESTATUS_CONCILIACION,
			@VP_D_ESTATUS_CONCILIACION =			ESTATUS_CONCILIACION.D_ESTATUS_CONCILIACION
											FROM	MOVIMIENTO_BANCO, ESTATUS_CONCILIACION
											WHERE	MOVIMIENTO_BANCO.K_ESTATUS_CONCILIACION=ESTATUS_CONCILIACION.K_ESTATUS_CONCILIACION
											AND		MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_CONCILIACION IS NULL
			SET @VP_RESULTADO =  'No se localizó el [MOVIMIENTO_BANCO].'
			
	-- =============================
	-- K_ESTATUS_CONCILIACION	
	-- #0 PENDIENTE | #1 INVESTIGACIÓN | #2 ACLARACIÓN | #3 CONCILIADO | #4 NO CONCILIABLE |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_CONCILIACION IN ( 1, 2 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_CONCILIACION)+'-'+@VP_D_ESTATUS_CONCILIACION+'] de la [CONCILIACIÓN] del [MOVIMIENTO_BANCO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // NO CONCILIABLE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_NO_CONCILIABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_NO_CONCILIABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_NO_CONCILIABLE]
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
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_NO_CONCILIABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																					@PP_K_MOVIMIENTO_BANCO,	 
																					@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //NCON//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / NO CONCILIABLE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_NO_CONCILIABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_NO_CONCILIABLE]
GO


CREATE PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_NO_CONCILIABLE]
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
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_NO_CONCILIABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																				@PP_K_MOVIMIENTO_BANCO,
																				@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_MOVIMIENTO_BANCO = 0-PENDIENTE / 1-INVESTIGACIÓN / 2-ACLARACIÓN / 3-CONCILIADO / 4-NO CONCILIABLE
			
		UPDATE	MOVIMIENTO_BANCO
		SET		K_ESTATUS_MOVIMIENTO_BANCO	= 4,		-- NO CONCILIABLE
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible poner en estatus de [No Conciliable] el [MOVIMIENTO_BANCO]: ' + @VP_MENSAJE 
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
													'NO_CONCILIABLE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_NO_CONCILIABLE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_REGRESABLE_A_PENDIENTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_REGRESABLE_A_PENDIENTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_REGRESABLE_A_PENDIENTE]
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

	DECLARE @VP_K_ESTATUS_CONCILIACION				INT
	DECLARE	@VP_D_ESTATUS_CONCILIACION				VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_CONCILIACION =			ESTATUS_CONCILIACION.K_ESTATUS_CONCILIACION,
			@VP_D_ESTATUS_CONCILIACION =			ESTATUS_CONCILIACION.D_ESTATUS_CONCILIACION
											FROM	MOVIMIENTO_BANCO, ESTATUS_CONCILIACION
											WHERE	MOVIMIENTO_BANCO.K_ESTATUS_CONCILIACION=ESTATUS_CONCILIACION.K_ESTATUS_CONCILIACION
											AND		MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_CONCILIACION IS NULL
			SET @VP_RESULTADO =  'No se localizó el [MOVIMIENTO_BANCO].'
			
	-- =============================
	-- K_ESTATUS_CONCILIACION	
	-- #0 PENDIENTE | #1 INVESTIGACIÓN | #2 ACLARACIÓN | #3 CONCILIADO | #4 NO CONCILIABLE |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_CONCILIACION IN ( 4 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_CONCILIACION)+'-'+@VP_D_ESTATUS_CONCILIACION+'] de la [CONCILIACIÓN] del [MOVIMIENTO_BANCO] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // REGRESAR A PENDIENTE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_REGRESAR_A_PENDIENTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_REGRESAR_A_PENDIENTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_REGRESAR_A_PENDIENTE]
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
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_ES_REGRESABLE_A_PENDIENTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																							@PP_K_MOVIMIENTO_BANCO,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_REGRESAR_A_PENDIENTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_REGRESAR_A_PENDIENTE]
GO


CREATE PROCEDURE [dbo].[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_REGRESAR_A_PENDIENTE]
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
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_CONCILIACION_REGRESAR_A_PENDIENTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_MOVIMIENTO_BANCO,
																						@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_MOVIMIENTO_BANCO = 0-PENDIENTE / 1-INVESTIGACIÓN / 2-ACLARACIÓN / 3-CONCILIADO / 4-NO CONCILIABLE
			
		UPDATE	MOVIMIENTO_BANCO
		SET		K_ESTATUS_MOVIMIENTO_BANCO	= 0,		-- PENDIENTE
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible regresar a [Pendiente] la [CONCILIACIÓN] del [MOVIMIENTO_BANCO]: ' + @VP_MENSAJE 
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
													'REGRESAR_A_PENDIENTE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_MOVIMIENTO_BANCO_CONCILIACION_REGRESAR_A_PENDIENTE]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
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