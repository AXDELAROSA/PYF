-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_WF_PROVEEDOR_20181112_DPR.sql
-- /////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			PROVEEDOR
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_ES_ACTIVABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_ES_ACTIVABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_ES_ACTIVABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_PROVEEDOR		INT
	DECLARE	@VP_D_ESTATUS_PROVEEDOR		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_PROVEEDOR =			ESTATUS_PROVEEDOR.K_ESTATUS_PROVEEDOR,
			@VP_D_ESTATUS_PROVEEDOR =			ESTATUS_PROVEEDOR.D_ESTATUS_PROVEEDOR
										FROM	PROVEEDOR, ESTATUS_PROVEEDOR
										WHERE	PROVEEDOR.K_ESTATUS_PROVEEDOR=ESTATUS_PROVEEDOR.K_ESTATUS_PROVEEDOR
										AND		PROVEEDOR.K_PROVEEDOR=@PP_K_PROVEEDOR
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_PROVEEDOR IS NULL
			SET @VP_RESULTADO =  'No se localizó el [PROVEEDOR].'
			
	-- =============================
	-- K_ESTATUS_PROVEEDOR	
	-- #1 PREREGISTRO | #2 ACTIVO | #3 SUSPENDIDO | #4 BAJA |

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_PROVEEDOR IN ( 1, 3, 4 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_PROVEEDOR)+'-'+@VP_D_ESTATUS_PROVEEDOR+'] del [PROVEEDOR] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // ACTIVO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_ACTIVO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_ACTIVO]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_ACTIVO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_PROVEEDOR					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_ES_ACTIVABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PROVEEDOR,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //ACT//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / ACTIVO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_PROVEEDOR_ACTIVO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_PROVEEDOR_ACTIVO]
GO


CREATE PROCEDURE [dbo].[PG_TR_PROVEEDOR_ACTIVO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_PROVEEDOR					INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_ACTIVO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_PROVEEDOR,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_PROVEEDOR = 0-INACTIVO / 1-ACTIVO / 2-SUSPENDIDA / 3-CERRADA
		
		UPDATE	PROVEEDOR
		SET		K_ESTATUS_PROVEEDOR			= 1,		-- ACTIVO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	PROVEEDOR.K_PROVEEDOR=@PP_K_PROVEEDOR
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Activar] el [PROVEEDOR]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PRV.'+CONVERT(VARCHAR(10),@PP_K_PROVEEDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PROVEEDOR AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'ACTIVO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_PROVEEDOR_ACTIVO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PROVEEDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_ES_SUSPENDIBLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_ES_SUSPENDIBLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_ES_SUSPENDIBLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_PROVEEDOR		INT
	DECLARE	@VP_D_ESTATUS_PROVEEDOR		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_PROVEEDOR =			ESTATUS_PROVEEDOR.K_ESTATUS_PROVEEDOR,
			@VP_D_ESTATUS_PROVEEDOR =			ESTATUS_PROVEEDOR.D_ESTATUS_PROVEEDOR
										FROM	PROVEEDOR, ESTATUS_PROVEEDOR
										WHERE	PROVEEDOR.K_ESTATUS_PROVEEDOR=ESTATUS_PROVEEDOR.K_ESTATUS_PROVEEDOR
										AND		PROVEEDOR.K_PROVEEDOR=@PP_K_PROVEEDOR
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_PROVEEDOR IS NULL
			SET @VP_RESULTADO =  'No se localizó el [PROVEEDOR].'
			
	-- =============================
	-- K_ESTATUS_PROVEEDOR	
	-- #1 PREREGISTRO | #2 ACTIVO | #3 SUSPENDIDO | #4 BAJA |	

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_PROVEEDOR IN ( 2, 4 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_PROVEEDOR)+'-'+@VP_D_ESTATUS_PROVEEDOR+'] del [PROVEEDOR] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // SUSPENDIDO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_SUSPENDIDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_SUSPENDIDO]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_SUSPENDIDO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_PROVEEDOR					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_ES_SUSPENDIBLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PROVEEDOR,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //SUS//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / SUSPENDIDO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_PROVEEDOR_SUSPENDIDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_PROVEEDOR_SUSPENDIDO]
GO


CREATE PROCEDURE [dbo].[PG_TR_PROVEEDOR_SUSPENDIDO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_PROVEEDOR					INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_SUSPENDIDO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PROVEEDOR,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_PROVEEDOR = 0-INACTIVO / 1-ACTIVO / 2-SUSPENDIDO / 3-CERRADA
		
		UPDATE	PROVEEDOR
		SET		K_ESTATUS_PROVEEDOR			= 2,		-- SUSPENDIDO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	PROVEEDOR.K_PROVEEDOR=@PP_K_PROVEEDOR
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Suspender] el [PROVEEDOR]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PRV.'+CONVERT(VARCHAR(10),@PP_K_PROVEEDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PROVEEDOR AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SUSPENDIDO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_PROVEEDOR_SUSPENDIDO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PROVEEDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_ES_BAJABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_ES_BAJABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_ES_BAJABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_PROVEEDOR		INT
	DECLARE	@VP_D_ESTATUS_PROVEEDOR		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_PROVEEDOR =			ESTATUS_PROVEEDOR.K_ESTATUS_PROVEEDOR,
			@VP_D_ESTATUS_PROVEEDOR =			ESTATUS_PROVEEDOR.D_ESTATUS_PROVEEDOR
										FROM	PROVEEDOR, ESTATUS_PROVEEDOR
										WHERE	PROVEEDOR.K_ESTATUS_PROVEEDOR=ESTATUS_PROVEEDOR.K_ESTATUS_PROVEEDOR
										AND		PROVEEDOR.K_PROVEEDOR=@PP_K_PROVEEDOR
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_PROVEEDOR IS NULL
			SET @VP_RESULTADO =  'No se localizó el [PROVEEDOR].' 

	-- =============================
	-- K_ESTATUS_PROVEEDOR	
	-- #1 PREREGISTRO | #2 ACTIVO | #3 SUSPENDIDO | #4 BAJA |	

	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_PROVEEDOR IN ( 2, 3 ) ) 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_PROVEEDOR)+'-'+@VP_D_ESTATUS_PROVEEDOR+'] del [PROVEEDOR] no lo permite.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN // BAJA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_BAJA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_BAJA]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_BAJA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_PROVEEDOR					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- //////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_ES_BAJABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PROVEEDOR,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	-- //////////////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //BJA//'

	-- //////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- //////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICIÓN / BAJA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_PROVEEDOR_BAJA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_PROVEEDOR_BAJA]
GO


CREATE PROCEDURE [dbo].[PG_TR_PROVEEDOR_BAJA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_L_CONTESTA					INT,
	-- ===========================
	@PP_K_PROVEEDOR					INT
AS

	DECLARE	@VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_BAJA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_PROVEEDOR,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_PROVEEDOR = 0-INACTIVO / 1-ACTIVO / 2-SUSPENDIDO / 3-BAJA

		UPDATE	PROVEEDOR
		SET		K_ESTATUS_PROVEEDOR				= 3,		-- BAJA
				-- ====================
				[F_CAMBIO]						= GETDATE(), 
				[K_USUARIO_CAMBIO]				= @PP_K_USUARIO_ACCION
		WHERE	PROVEEDOR.K_PROVEEDOR=@PP_K_PROVEEDOR
		
		END


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Dar de Baja] al [PROVEEDOR]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PRV.'+CONVERT(VARCHAR(10),@PP_K_PROVEEDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PROVEEDOR AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'BAJA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_PROVEEDOR_BAJA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_PROVEEDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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