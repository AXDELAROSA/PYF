-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_WF_FACTURA_CXP_20181109_DPR.sql
-- /////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			FACTURA_CXP
-- // OPERACIÓN:		LIBERACIÓN / WORKFLOWS ESTATUS_FACTURA_CXP
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_ES_ACLARABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_ES_ACLARABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_ES_ACLARABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_FACTURA_CXP		INT
	DECLARE	@VP_D_ESTATUS_FACTURA_CXP		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_FACTURA_CXP =		ESTATUS_FACTURA_CXP.K_ESTATUS_FACTURA_CXP,
			@VP_D_ESTATUS_FACTURA_CXP =		ESTATUS_FACTURA_CXP.D_ESTATUS_FACTURA_CXP
											FROM	FACTURA_CXP, ESTATUS_FACTURA_CXP
											WHERE	FACTURA_CXP.K_ESTATUS_FACTURA_CXP=ESTATUS_FACTURA_CXP.K_ESTATUS_FACTURA_CXP
											AND		FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_FACTURA_CXP IS NULL
			SET @VP_RESULTADO =  'No se localizó la [FACTURA_CXP].'
			
	-- =============================
	-- K_ESTATUS_FACTURA_CXP	
	-- #1 RECIBIDA | #2 ACLARACIÓN | #3 AUTORIZADA | #4 PROGRAMADO |
	-- #5 PAGOS | #6 LIQUIDADA | #7 CANCELADA |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_FACTURA_CXP IN ( 1 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_FACTURA_CXP)+'-'+@VP_D_ESTATUS_FACTURA_CXP+'] de la [FACTURA_CXP] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // ACLARACIÓN
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_ACLARACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_ACLARACION]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_ACLARACION]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_ES_ACLARABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_FACTURA_CXP,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_FACTURA_CXP_ACLARACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_FACTURA_CXP_ACLARACION]
GO


CREATE PROCEDURE [dbo].[PG_TR_FACTURA_CXP_ACLARACION]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_FACTURA_CXP				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_ACLARACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_FACTURA_CXP,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_FACTURA_CXP = 1-RECIBIDA / 2-ACLARACIÓN / 3-AUTORIZADA / 4-PROGRAMADO / 5-PAGOS / 6-LIQUIDADA / 7-CANCELADO
		
		UPDATE	FACTURA_CXP
		SET		K_ESTATUS_FACTURA_CXP		= 2,		-- ACLARACIÓN
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Aclarar] la [FACTURA_CXP]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CXP.'+CONVERT(VARCHAR(10),@PP_K_FACTURA_CXP)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FACTURA_CXP AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'ACLARACIÓN',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_FACTURA_CXP_ACLARACION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FACTURA_CXP, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_ES_AUTORIZABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_ES_AUTORIZABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_ES_AUTORIZABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_FACTURA_CXP		INT
	DECLARE	@VP_D_ESTATUS_FACTURA_CXP		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_FACTURA_CXP =		ESTATUS_FACTURA_CXP.K_ESTATUS_FACTURA_CXP,
			@VP_D_ESTATUS_FACTURA_CXP =		ESTATUS_FACTURA_CXP.D_ESTATUS_FACTURA_CXP
											FROM	FACTURA_CXP, ESTATUS_FACTURA_CXP
											WHERE	FACTURA_CXP.K_ESTATUS_FACTURA_CXP=ESTATUS_FACTURA_CXP.K_ESTATUS_FACTURA_CXP
											AND		FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_FACTURA_CXP IS NULL
			SET @VP_RESULTADO =  'No se localizó la [FACTURA_CXP].'
			
	-- =============================
	-- K_ESTATUS_FACTURA_CXP	
	-- #1 RECIBIDA | #2 ACLARACIÓN | #3 AUTORIZADA | #4 PROGRAMADO |
	-- #5 PAGOS | #6 LIQUIDADA | #7 CANCELADA |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_FACTURA_CXP IN ( 1, 2 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_FACTURA_CXP)+'-'+@VP_D_ESTATUS_FACTURA_CXP+'] de la [FACTURA_CXP] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // AUTORIZADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_AUTORIZAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_AUTORIZAR]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_AUTORIZAR]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_ES_AUTORIZABLE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_FACTURA_CXP,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //AUT//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / AUTORIZAR
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_FACTURA_CXP_AUTORIZAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_FACTURA_CXP_AUTORIZAR]
GO


CREATE PROCEDURE [dbo].[PG_TR_FACTURA_CXP_AUTORIZAR]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_FACTURA_CXP				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_AUTORIZAR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_FACTURA_CXP,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_FACTURA_CXP = 1-RECIBIDA / 2-ACLARACIÓN / 3-AUTORIZADA / 4-PROGRAMADO / 5-PAGOS / 6-LIQUIDADA / 7-CANCELADO
		
		UPDATE	FACTURA_CXP
		SET		K_ESTATUS_FACTURA_CXP		= 3,		-- AUTORIZADA
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Autorizar] la [FACTURA_CXP]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CXP.'+CONVERT(VARCHAR(10),@PP_K_FACTURA_CXP)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FACTURA_CXP AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'AUTORIZAR',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_FACTURA_CXP_AUTORIZAR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FACTURA_CXP, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_ES_PROGRAMABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_ES_PROGRAMABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_ES_PROGRAMABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_FACTURA_CXP		INT
	DECLARE	@VP_D_ESTATUS_FACTURA_CXP		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_FACTURA_CXP =		ESTATUS_FACTURA_CXP.K_ESTATUS_FACTURA_CXP,
			@VP_D_ESTATUS_FACTURA_CXP =		ESTATUS_FACTURA_CXP.D_ESTATUS_FACTURA_CXP
											FROM	FACTURA_CXP, ESTATUS_FACTURA_CXP
											WHERE	FACTURA_CXP.K_ESTATUS_FACTURA_CXP=ESTATUS_FACTURA_CXP.K_ESTATUS_FACTURA_CXP
											AND		FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_FACTURA_CXP IS NULL
			SET @VP_RESULTADO =  'No se localizó la [FACTURA_CXP].' 

	-- =============================
	-- K_ESTATUS_FACTURA_CXP	
	-- #1 RECIBIDA | #2 ACLARACIÓN | #3 AUTORIZADA | #4 PROGRAMADO |
	-- #5 PAGOS | #6 LIQUIDADA | #7 CANCELADA |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_FACTURA_CXP IN ( 3 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_FACTURA_CXP)+'-'+@VP_D_ESTATUS_FACTURA_CXP+'] de la [FACTURA_CXP] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // PROGRAMADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_PROGRAMADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_PROGRAMADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_PROGRAMADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_ES_PROGRAMABLE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_FACTURA_CXP,	 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_FACTURA_CXP_PROGRAMADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_FACTURA_CXP_PROGRAMADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_FACTURA_CXP_PROGRAMADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_FACTURA_CXP				INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_PROGRAMADO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_FACTURA_CXP,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_FACTURA_CXP = 1-RECIBIDA / 2-ACLARACIÓN / 3-AUTORIZADA / 4-PROGRAMADO / 5-PAGOS / 6-LIQUIDADA / 7-CANCELADO

		UPDATE	FACTURA_CXP
		SET		K_ESTATUS_FACTURA_CXP	= 4,		-- PROGRAMADO
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Programar] la [FACTURA_CXP]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CXP.'+CONVERT(VARCHAR(10),@PP_K_FACTURA_CXP)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FACTURA_CXP AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'PROGRAMADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_FACTURA_CXP_PROGRAMADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FACTURA_CXP, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_ES_PAGABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_ES_PAGABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_ES_PAGABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_FACTURA_CXP		INT
	DECLARE	@VP_D_ESTATUS_FACTURA_CXP		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_FACTURA_CXP =		ESTATUS_FACTURA_CXP.K_ESTATUS_FACTURA_CXP,
			@VP_D_ESTATUS_FACTURA_CXP =		ESTATUS_FACTURA_CXP.D_ESTATUS_FACTURA_CXP
											FROM	FACTURA_CXP, ESTATUS_FACTURA_CXP
											WHERE	FACTURA_CXP.K_ESTATUS_FACTURA_CXP=ESTATUS_FACTURA_CXP.K_ESTATUS_FACTURA_CXP
											AND		FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_FACTURA_CXP IS NULL
			SET @VP_RESULTADO =  'No se localizó la [FACTURA_CXP].'
			
	-- =============================
	-- K_ESTATUS_FACTURA_CXP	
	-- #1 RECIBIDA | #2 ACLARACIÓN | #3 AUTORIZADA | #4 PROGRAMADO |
	-- #5 PAGOS | #6 LIQUIDADA | #7 CANCELADA |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_FACTURA_CXP IN ( 4 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_FACTURA_CXP)+'-'+@VP_D_ESTATUS_FACTURA_CXP+'] de la [FACTURA_CXP] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // PAGOS
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_PAGOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_PAGOS]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_PAGOS]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_ES_PAGABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_FACTURA_CXP,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //PAG//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / PAGOS
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_FACTURA_CXP_PAGOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_FACTURA_CXP_PAGOS]
GO


CREATE PROCEDURE [dbo].[PG_TR_FACTURA_CXP_PAGOS]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_FACTURA_CXP				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_PAGOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_FACTURA_CXP,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_FACTURA_CXP = 1-RECIBIDA / 2-ACLARACIÓN / 3-AUTORIZADA / 4-PROGRAMADO / 5-PAGOS / 6-LIQUIDADA / 7-CANCELADO
		
		UPDATE	FACTURA_CXP
		SET		K_ESTATUS_FACTURA_CXP		= 5,		-- PAGOS
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Pagar] la [FACTURA_CXP]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CXP.'+CONVERT(VARCHAR(10),@PP_K_FACTURA_CXP)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FACTURA_CXP AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'PAGOS',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_FACTURA_CXP_PAGOS]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FACTURA_CXP, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_ES_LIQUIDABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_ES_LIQUIDABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_ES_LIQUIDABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_FACTURA_CXP		INT
	DECLARE	@VP_D_ESTATUS_FACTURA_CXP		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_FACTURA_CXP =		ESTATUS_FACTURA_CXP.K_ESTATUS_FACTURA_CXP,
			@VP_D_ESTATUS_FACTURA_CXP =		ESTATUS_FACTURA_CXP.D_ESTATUS_FACTURA_CXP
											FROM	FACTURA_CXP, ESTATUS_FACTURA_CXP
											WHERE	FACTURA_CXP.K_ESTATUS_FACTURA_CXP=ESTATUS_FACTURA_CXP.K_ESTATUS_FACTURA_CXP
											AND		FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_FACTURA_CXP IS NULL
			SET @VP_RESULTADO =  'No se localizó la [FACTURA_CXP].' 

	-- =============================
	-- K_ESTATUS_FACTURA_CXP	
	-- #1 RECIBIDA | #2 ACLARACIÓN | #3 AUTORIZADA | #4 LIQUIDADA |
	-- #5 PAGOS | #6 LIQUIDADA | #7 CANCELADA |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_FACTURA_CXP IN ( 5 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_FACTURA_CXP)+'-'+@VP_D_ESTATUS_FACTURA_CXP+'] de la [FACTURA_CXP] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // LIQUIDADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_LIQUIDADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_LIQUIDADA]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_LIQUIDADA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_ES_LIQUIDABLE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_FACTURA_CXP,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //LIQ//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / LIQUIDADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_FACTURA_CXP_LIQUIDADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_FACTURA_CXP_LIQUIDADA]
GO


CREATE PROCEDURE [dbo].[PG_TR_FACTURA_CXP_LIQUIDADA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_FACTURA_CXP				INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_LIQUIDADA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_FACTURA_CXP,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_FACTURA_CXP = 1-RECIBIDA / 2-ACLARACIÓN / 3-AUTORIZADA / 4-LIQUIDADA / 5-PAGOS / 6-LIQUIDADA / 7-CANCELADO

		UPDATE	FACTURA_CXP
		SET		K_ESTATUS_FACTURA_CXP	= 6,		-- LIQUIDADA
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Liquidar] la [FACTURA_CXP]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CXP.'+CONVERT(VARCHAR(10),@PP_K_FACTURA_CXP)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FACTURA_CXP AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'LIQUIDADA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_FACTURA_CXP_LIQUIDADA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FACTURA_CXP, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_ES_CANCELABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_ES_CANCELABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_ES_CANCELABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_FACTURA_CXP		INT
	DECLARE	@VP_D_ESTATUS_FACTURA_CXP		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_FACTURA_CXP =		ESTATUS_FACTURA_CXP.K_ESTATUS_FACTURA_CXP,
			@VP_D_ESTATUS_FACTURA_CXP =		ESTATUS_FACTURA_CXP.D_ESTATUS_FACTURA_CXP
											FROM	FACTURA_CXP, ESTATUS_FACTURA_CXP
											WHERE	FACTURA_CXP.K_ESTATUS_FACTURA_CXP=ESTATUS_FACTURA_CXP.K_ESTATUS_FACTURA_CXP
											AND		FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_FACTURA_CXP IS NULL
			SET @VP_RESULTADO =  'No se localizó la [FACTURA_CXP].' 

	-- =============================
	-- K_ESTATUS_FACTURA_CXP	
	-- #1 RECIBIDA | #2 ACLARACIÓN | #3 AUTORIZADA | #4 PROGRAMADO |
	-- #5 PAGOS | #6 LIQUIDADA | #7 CANCELADA |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_FACTURA_CXP IN ( 1, 2, 3, 4, 5 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_FACTURA_CXP)+'-'+@VP_D_ESTATUS_FACTURA_CXP+'] de la [FACTURA_CXP] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // CANCELAR
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_CANCELAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_CANCELAR]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_CANCELAR]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_ES_CANCELABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_FACTURA_CXP,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //CNC//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / CANCELAR
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_FACTURA_CXP_CANCELAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_FACTURA_CXP_CANCELAR]
GO


CREATE PROCEDURE [dbo].[PG_TR_FACTURA_CXP_CANCELAR]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_FACTURA_CXP				INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_CANCELAR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_FACTURA_CXP,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_FACTURA_CXP = 1-RECIBIDA / 2-ACLARACIÓN / 3-AUTORIZADA / 4-PROGRAMADO / 5-PAGOS / 6-LIQUIDADA / 7-CANCELADO

		UPDATE	FACTURA_CXP
		SET		K_ESTATUS_FACTURA_CXP	= 7,		-- CANCELADO
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Cancelar] la [FACTURA_CXP]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CXP.'+CONVERT(VARCHAR(10),@PP_K_FACTURA_CXP)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FACTURA_CXP AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CANCELAR',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_FACTURA_CXP_CANCELAR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FACTURA_CXP, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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