-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:		PYF18_Finanzas
-- // MODULO:				LIBRO_INGRESOS
-- // OPERACION:			LIBERACION / REGLAS NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // Autor:				DANIEL PORTILLO	ROMERO
-- // Fecha creación:		18/SEP/2018
-- // Fecha modificación:	08/DIC/2018 (Por integración de RNs de Control)
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EXISTE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_LIBRO_INGRESOS_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_LIBRO_INGRESOS_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_LIBRO_INGRESOS_EXISTE]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_USUARIO_ACCION		[INT],
	-- ===========================		
	@PP_K_LIBRO_INGRESOS		[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = '' 
	
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_LIBRO_INGRESOS		[INT]
			
	SELECT	@VP_K_LIBRO_INGRESOS =		K_LIBRO_INGRESOS
										FROM	LIBRO_INGRESOS
										WHERE	K_LIBRO_INGRESOS=@PP_K_LIBRO_INGRESOS
	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_LIBRO_INGRESOS IS NULL )
			SET @VP_RESULTADO =  'El registro para el [LIBRO_INGRESOS] no existe.' 
		
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CLAVE_EXISTE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_LIBRO_INGRESOS_CLAVE_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_LIBRO_INGRESOS_CLAVE_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_LIBRO_INGRESOS_CLAVE_EXISTE]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_USUARIO_ACCION		[INT],
	-- ===========================		
	@PP_K_LIBRO_INGRESOS		[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO='' 
		BEGIN

		DECLARE @VP_EXISTE_CLAVE	INT

		SELECT	@VP_EXISTE_CLAVE =	COUNT(K_LIBRO_INGRESOS)
									FROM	LIBRO_INGRESOS 
									WHERE	K_LIBRO_INGRESOS=@PP_K_LIBRO_INGRESOS
										
		IF @VP_EXISTE_CLAVE>0
			SET @VP_RESULTADO =  'El folio/identificador no está disponible.' 

		END	
		
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- ===========================================================================================
-- ===========================================================================================
-- == REGLAS DE NEGOCIO BASICAS (INSERT / UPDATE / DELETE)
-- ===========================================================================================
-- ===========================================================================================


-- /////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN LIBRO_INGRESOS INSERT
-- /////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_LIBRO_INGRESOS_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_LIBRO_INGRESOS_INSERT]
GO

CREATE PROCEDURE [dbo].[PG_RN_LIBRO_INGRESOS_INSERT]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_USUARIO_ACCION		[INT],
	-- ===========================		
	@PP_K_LIBRO_INGRESOS		[INT],
	@PP_K_UNIDAD_OPERATIVA		[INT],
	@PP_F_OPERACION				[DATE],
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	 -- ////////////////////////////////////////////////////

	DECLARE @VP_K_YYYY		INT
	DECLARE @VP_K_MM		INT

	SET @VP_K_YYYY =		YEAR(@PP_F_OPERACION)
	SET @VP_K_MM =			MONTH(@PP_F_OPERACION)

	-- ===============================

	DECLARE @VP_K_RAZON_SOCIAL			INT = -1

	SELECT	@VP_K_RAZON_SOCIAL =		UNIDAD_OPERATIVA.K_RAZON_SOCIAL
								FROM	UNIDAD_OPERATIVA
								WHERE	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA

	-- ===============================

	IF @VP_RESULTADO = ''
		EXECUTE [dbo].[PG_RN_CONTROL_L_06_PFD_INGRESOS_ADD]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO	OUTPUT

	-- ////////////////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //INS//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- /////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN LIBRO_INGRESOS UPDATE
-- /////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_LIBRO_INGRESOS_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_LIBRO_INGRESOS_UPDATE]
GO

CREATE PROCEDURE [dbo].[PG_RN_LIBRO_INGRESOS_UPDATE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_LIBRO_INGRESOS				[INT],	
	@PP_K_UNIDAD_OPERATIVA				[INT],
	@PP_F_OPERACION						[DATE],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
	
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO = ''
		BEGIN

		DECLARE @VP_K_YYYY					INT
		DECLARE @VP_K_MM					INT

		SET	@VP_K_YYYY =	YEAR(@PP_F_OPERACION) 
		SET	@VP_K_MM =		MONTH(@PP_F_OPERACION) 

		-- ===========================	

		DECLARE @VP_K_RAZON_SOCIAL			INT		

		SELECT	@VP_K_RAZON_SOCIAL =		UNIDAD_OPERATIVA.K_RAZON_SOCIAL
											FROM	UNIDAD_OPERATIVA
											WHERE	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA

		-- ===========================	

		EXECUTE [dbo].[PG_RN_CONTROL_L_05_PFD_POLIZA_EDIT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

		END

	-- ///////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_LIBRO_INGRESOS_EXISTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_LIBRO_INGRESOS,	 
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	-- ///////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //UPD//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN // VALIDACION DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_LIBRO_INGRESOS_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_LIBRO_INGRESOS_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_RN_LIBRO_INGRESOS_DELETE]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_USUARIO_ACCION		[INT],
	-- ===========================		
	@PP_K_LIBRO_INGRESOS		[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300)
	
	SET		@VP_RESULTADO		= ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														1, -- @PP_K_DATA_SISTEMA,	
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_LIBRO_INGRESOS_EXISTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_LIBRO_INGRESOS, 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////




	-- ///////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //DEL//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- /////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN LIBRO_INGRESOS_ACTA_X_K_UNIDAD_OPERATIVA INSERT / UPDATE
-- /////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_LIBRO_INGRESOS_ACTA_X_K_UNIDAD_OPERATIVA_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_LIBRO_INGRESOS_ACTA_X_K_UNIDAD_OPERATIVA_UPDATE]
GO

CREATE PROCEDURE [dbo].[PG_RN_LIBRO_INGRESOS_ACTA_X_K_UNIDAD_OPERATIVA_UPDATE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_LIBRO_INGRESOS				[INT],
	@PP_K_UNIDAD_OPERATIVA				[INT],
	@PP_F_OPERACION						[DATE],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''

	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_LIBRO_INGRESOS_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_LIBRO_INGRESOS, @PP_K_UNIDAD_OPERATIVA, @PP_F_OPERACION,
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														8, -- @PP_K_DATA_SISTEMA,	
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT		

	-- ///////////////////////////////////////////	

	IF @VP_RESULTADO = ''
		BEGIN

		DECLARE @VP_K_YYYY		INT
		DECLARE @VP_K_MM		INT

		SET	@VP_K_YYYY =		YEAR(@PP_F_OPERACION) 
		SET	@VP_K_MM =			MONTH(@PP_F_OPERACION) 

		-- ===========================	

		DECLARE @VP_K_RAZON_SOCIAL			INT		

		SELECT	@VP_K_RAZON_SOCIAL =		K_RAZON_SOCIAL
											FROM	UNIDAD_OPERATIVA
											WHERE	K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA
		-- ===========================	

		EXECUTE [dbo].[PG_RN_CONTROL_L_05_PFD_POLIZA_EDIT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
		END

	-- ///////////////////////////////////////////	

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + '  //UPD//'

	-- ///////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- ///////////////////////////////////////////////
GO




-- /////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN ACTA INGRESOS UPDATE/INSERT
-- /////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_ACTA_INGRESOS_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_ACTA_INGRESOS_UPDATE]
GO

CREATE PROCEDURE [dbo].[PG_RN_ACTA_INGRESOS_UPDATE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_UNIDAD_OPERATIVA				[INT],
	@PP_F_OPERACION						[DATE],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''

		-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	 -- ////////////////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														8, -- @PP_K_DATA_SISTEMA,	
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT		

	-- ///////////////////////////////////////////	

	DECLARE @VP_K_YYYY		INT
	DECLARE @VP_K_MM		INT

	SET	@VP_K_YYYY =		YEAR(@PP_F_OPERACION) 
	SET	@VP_K_MM =			MONTH(@PP_F_OPERACION) 

	-- ===========================	

	DECLARE @VP_K_RAZON_SOCIAL			INT		

	SELECT	@VP_K_RAZON_SOCIAL =		K_RAZON_SOCIAL
										FROM	UNIDAD_OPERATIVA
										WHERE	K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA

	-- ///////////////////////////////////////////	

	IF @VP_RESULTADO = ''
		EXECUTE [dbo].[PG_RN_CONTROL_L_06_PFD_INGRESOS_ADD]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO	OUTPUT

	-- ///////////////////////////////////////////

	IF @VP_RESULTADO = ''
		EXECUTE [dbo].[PG_RN_CONTROL_L_05_PFD_POLIZA_EDIT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	-- ///////////////////////////////////////////	

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + '  //UPD//'

	-- ///////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- ///////////////////////////////////////////////
GO





-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
