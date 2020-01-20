-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / REGLAS NEGOCIO
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TABLA_AMORTIZACION_GENERAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_GENERAR]
GO


CREATE PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_GENERAR]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_CREDITO_BANCARIO				[INT], 
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
	
	-- ///////////////////////////////////////////
/*
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														X, -- @PP_K_DATA_SISTEMA,	
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT		
	-- /////////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_SOLICITUD_ES_EDITABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_SOLICITUD,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- /////////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_SOLICITUD_MISMA_PLANTA]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_SOLICITUD, @PP_K_CLIENTE,	
														@PP_K_ESTATUS_SOLICITUD, @PP_K_TIPO_SOLICITUD,	
														@PP_K_PLANTA, @PP_IMPORTE, 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
*/
	-- /////////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //TBL//'

	-- /////////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TABLA_AMORTIZACION_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_EXISTE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_TABLA_AMORTIZACION			[INT], 
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
	
	-- ///////////////////////////////////////////

	DECLARE	@VP_K_TABLA_AMORTIZACION	INT

	SELECT	@VP_K_TABLA_AMORTIZACION =	K_TABLA_AMORTIZACION
										FROM	TABLA_AMORTIZACION
										WHERE	K_TABLA_AMORTIZACION=@PP_K_TABLA_AMORTIZACION
	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_TABLA_AMORTIZACION IS NULL )
			SET @VP_RESULTADO =  'La [Cuenta Bancaria] no existe.' 
	
	-- ===========================
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO 

	-- /////////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TABLA_AMORTIZACION_ES_EDITABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_ES_EDITABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_ES_EDITABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_TABLA_AMORTIZACION			[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_TABLA_AMORTIZACION			INT
	DECLARE	@VP_D_ESTATUS_TABLA_AMORTIZACION			VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_TABLA_AMORTIZACION =		TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION,
			@VP_D_ESTATUS_TABLA_AMORTIZACION =		ESTATUS_TABLA_AMORTIZACION.D_ESTATUS_TABLA_AMORTIZACION
													FROM	TABLA_AMORTIZACION, ESTATUS_TABLA_AMORTIZACION
													WHERE	TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION=ESTATUS_TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION
													AND		TABLA_AMORTIZACION.K_TABLA_AMORTIZACION=@PP_K_TABLA_AMORTIZACION
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_TABLA_AMORTIZACION IS NULL
			SET @VP_RESULTADO =  'No se localizó el registro de  [Amortización].' 

	-- =============================
	-- K_ESTATUS_SOLICITUD	
	-- // 1 PENDIENTE / 2 POR PAGAR / 3 PAGADO / 4 CANCELADA
	IF @VP_RESULTADO=''
		IF NOT ( @VP_K_ESTATUS_TABLA_AMORTIZACION IN ( 1, 2 ) ) 
		BEGIN
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_TABLA_AMORTIZACION)+'-'+@VP_D_ESTATUS_TABLA_AMORTIZACION
			SET @VP_RESULTADO =	@VP_RESULTADO + '] de la [Amortización #'+CONVERT(VARCHAR(10),@PP_K_TABLA_AMORTIZACION)+'] no lo permite.'
		END
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION UPDATE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TABLA_AMORTIZACION_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_UPDATE]
GO


CREATE PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_UPDATE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_TABLA_AMORTIZACION			[INT], 
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
	
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														@PP_K_TABLA_AMORTIZACION, -- @PP_K_DATA_SISTEMA,	
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT		
	-- /////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_TABLA_AMORTIZACION_EXISTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_TABLA_AMORTIZACION,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- /////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_TABLA_AMORTIZACION_ES_EDITABLE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_TABLA_AMORTIZACION, 
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	-- /////////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //UPD//'

	-- /////////////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TABLA_AMORTIZACION_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_INSERT]
GO


CREATE PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_INSERT]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_USUARIO_ACCION		[INT],
	-- ===========================		
	@PP_K_TABLA_AMORTIZACION	[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
	
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
		
	-- ///////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_TABLA_AMORTIZACION_EXISTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_TABLA_AMORTIZACION,
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	
	-- ///////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //INS//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO









