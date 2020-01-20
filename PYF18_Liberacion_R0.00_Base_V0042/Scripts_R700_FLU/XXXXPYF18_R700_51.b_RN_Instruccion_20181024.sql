-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			INSTRUCCION/MOVIMIENTO TESORERIA
-- // OPERACION:		LIBERACION / REGLAS DE NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	18/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_CANCELADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_CANCELADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_CANCELADO]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================			
	@PP_K_INSTRUCCION					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_INSTRUCCION		INT
	DECLARE @VP_D_ESTATUS_INSTRUCCION		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_INSTRUCCION =	INSTRUCCION.K_ESTATUS_INSTRUCCION,
			@VP_D_ESTATUS_INSTRUCCION =	ESTATUS_INSTRUCCION.D_ESTATUS_INSTRUCCION
												FROM	INSTRUCCION, ESTATUS_INSTRUCCION
												WHERE	INSTRUCCION.L_BORRADO=0
												AND		INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
	-- ==========================

	-- K_ESTATUS_INSTRUCCION	
	-- // 1	REPORTADO | 2 PAGO POR APLICAR | 3	APLICADO A COBRANZA |4 CANCELADO
	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_INSTRUCCION = 4 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_INSTRUCCION)+'-'+@VP_D_ESTATUS_INSTRUCCION+'] del [Movimiento#'+CONVERT(VARCHAR(10),@PP_K_INSTRUCCION)+'] no lo permite.'
			

	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_CAPTURA_MANUAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_CAPTURA_MANUAL]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_CAPTURA_MANUAL]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================			
	@PP_K_INSTRUCCION					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
-- /////////////////////////////////////////////////////

	DECLARE @VP_L_CAPTURA_MANUAL				INT
	
	SELECT	@VP_L_CAPTURA_MANUAL =				INSTRUCCION.L_CAPTURA_MANUAL
												FROM	INSTRUCCION
												WHERE	INSTRUCCION.L_BORRADO=0
												AND		INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
	-- ==========================

	IF @VP_RESULTADO=''
		IF @VP_L_CAPTURA_MANUAL IS NULL
			SET @VP_RESULTADO =  'No se localizó el [Movimiento Banco].' 

	-- ==========================

	-- K_ESTATUS_INSTRUCCION	
	-- // 0 ARCHIVO XML / 1	CAPTURA MANUAL/ 
	IF @VP_RESULTADO=''
		IF NOT @VP_L_CAPTURA_MANUAL=1 
			SET @VP_RESULTADO =  'La forma de captura del [Movimiento#'+CONVERT(VARCHAR(10),@PP_K_INSTRUCCION)+'] no lo permite.'
			

	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_ES_EDITABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_ES_EDITABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_ES_EDITABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================			
	@PP_K_INSTRUCCION					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_INSTRUCCION		INT
	DECLARE @VP_D_ESTATUS_INSTRUCCION		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_INSTRUCCION =	ESTATUS_INSTRUCCION.K_ESTATUS_INSTRUCCION,
			@VP_D_ESTATUS_INSTRUCCION =	ESTATUS_INSTRUCCION.D_ESTATUS_INSTRUCCION
												FROM	INSTRUCCION, ESTATUS_INSTRUCCION
												WHERE	INSTRUCCION.L_BORRADO=0
												AND		INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
	-- ==========================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_INSTRUCCION IS NULL
			SET @VP_RESULTADO =  'No se localizó el [Movimiento Banco].' 

	-- ==========================

	-- K_ESTATUS_INSTRUCCION	
	-- // 1	REPORTADO | 2 PAGO POR APLICAR | 3	APLICADO A COBRANZA |4 CANCELADO
	IF @VP_RESULTADO=''
		IF NOT @VP_K_ESTATUS_INSTRUCCION=2 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_INSTRUCCION)+'-'+@VP_D_ESTATUS_INSTRUCCION+'] del [Movimiento#'+CONVERT(VARCHAR(10),@PP_K_INSTRUCCION)+'] no lo permite.'
			

	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_EXISTE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================			
	@PP_K_INSTRUCCION					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
-- /////////////////////////////////////////////////////

	DECLARE @VP_K_INSTRUCCION		INT
	
	SELECT	@VP_K_INSTRUCCION =		@PP_K_INSTRUCCION
									FROM	INSTRUCCION
									WHERE	INSTRUCCION.L_BORRADO=0
									AND		INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
	-- ==========================

	IF @VP_RESULTADO=''
		IF @VP_K_INSTRUCCION IS NULL
			SET @VP_RESULTADO =  'No existe el [Movimiento Banco].' 

	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_ES_APLICABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_ES_APLICABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_ES_APLICABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================			
	@PP_K_INSTRUCCION					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_INSTRUCCION		INT
	DECLARE @VP_D_ESTATUS_INSTRUCCION		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_INSTRUCCION =	INSTRUCCION.K_ESTATUS_INSTRUCCION,
			@VP_D_ESTATUS_INSTRUCCION =	ESTATUS_INSTRUCCION.D_ESTATUS_INSTRUCCION
												FROM	INSTRUCCION, ESTATUS_INSTRUCCION
												WHERE	INSTRUCCION.L_BORRADO=0
												AND		INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
	-- ==========================

	-- K_ESTATUS_INSTRUCCION	
	-- // 1	REPORTADO | 2 PAGO POR APLICAR | 3	APLICADO A COBRANZA |4 CANCELADO
	IF @VP_RESULTADO=''
		IF NOT @VP_K_ESTATUS_INSTRUCCION = 2 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_INSTRUCCION)+'-'+@VP_D_ESTATUS_INSTRUCCION+'] del [Movimiento#'+CONVERT(VARCHAR(10),@PP_K_INSTRUCCION)+'] no lo permite.'
			

	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_INSERT] 
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_INSERT]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_INSTRUCCION					[INT],	
	@PP_K_CUENTA_BANCO					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''

	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														8, -- @PP_K_DATA_SISTEMA,	
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_CUENTA_BANCO_ACTIVA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														@PP_K_CUENTA_BANCO,
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////	

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + '  //INS//'

	-- ///////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- ///////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_DELETE] 
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_DELETE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_INSTRUCCION					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''

	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_DELETE]				@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																8, -- @PP_K_DATA_SISTEMA,	
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_EXISTE]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																@PP_K_INSTRUCCION,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////		

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_ES_EDITABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																@PP_K_INSTRUCCION,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////	

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_CAPTURA_MANUAL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																@PP_K_INSTRUCCION,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////	

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + '  //DEL//'

	-- ///////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- ///////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_APLICAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_APLICAR] 
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_APLICAR]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_INSTRUCCION					[INT],
	@PP_K_SOLICITUD						[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''

	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_DELETE]				@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																8, -- @PP_K_DATA_SISTEMA,	
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT		
	-- ///////////////////////////////////////////
/*
-- WIWI/HGF // VIENE DE PREMA

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_SOLICITUD_EXISTE]					@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																@PP_K_SOLICITUD,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
*/
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_EXISTE]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																@PP_K_INSTRUCCION,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////	
	
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_ES_APLICABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																@PP_K_INSTRUCCION,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////	

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + '  //APL//'

	-- ///////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- ///////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION UPDATE
-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_UPDATE] 
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_UPDATE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_INSTRUCCION					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''

	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]				@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																8, -- @PP_K_DATA_SISTEMA,	
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_EXISTE]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																@PP_K_INSTRUCCION,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////	
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_ES_EDITABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																@PP_K_INSTRUCCION,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////	
	
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_CAPTURA_MANUAL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																@PP_K_INSTRUCCION,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////	

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + '  //UPD//'

	-- ///////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- ///////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION UPDATE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_CANCELAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_CANCELAR] 
GO


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_CANCELAR]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_INSTRUCCION				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''

	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]				@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																8, -- @PP_K_DATA_SISTEMA,	
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_EXISTE]				@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																@PP_K_INSTRUCCION,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////	
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_CANCELADO]				@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																@PP_K_INSTRUCCION,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////	

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + '  //CAN//'

	-- ///////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- ///////////////////////////////////////////////
GO







-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////