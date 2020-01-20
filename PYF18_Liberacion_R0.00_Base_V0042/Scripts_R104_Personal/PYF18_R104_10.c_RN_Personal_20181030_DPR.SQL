-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PERSONAL
-- // OPERACION:		LIBERACION / REGLAS NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // Autor:			DANIEL PORTILLO	ROMERO
-- // Fecha creación:	29/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EXISTE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_EXISTE]
	@PP_L_DEBUG									INT,
	@PP_K_SISTEMA_EXE							INT,
	@PP_K_USUARIO_ACCION						INT,
	-- ===========================		
	@PP_K_PERSONAL_ACCESO_ORGANIZACION			INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(200)	OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300) = '' 
	
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_PERSONAL_ACCESO_ORGANIZACION		INT
			
	SELECT	@VP_K_PERSONAL_ACCESO_ORGANIZACION =	K_PERSONAL_ACCESO_ORGANIZACION
													FROM	PERSONAL_ACCESO_ORGANIZACION
													WHERE	K_PERSONAL_ACCESO_ORGANIZACION=@PP_K_PERSONAL_ACCESO_ORGANIZACION
	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_PERSONAL_ACCESO_ORGANIZACION IS NULL )
			SET @VP_RESULTADO =  'El registro para el [PERSONAL_ACCESO_ORGANIZACION] no existe.' 
		
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CLAVE_EXISTE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_CLAVE_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_CLAVE_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_CLAVE_EXISTE]
	@PP_L_DEBUG									INT,
	@PP_K_SISTEMA_EXE							INT,
	@PP_K_USUARIO_ACCION						INT,
	-- ===========================		
	@PP_K_PERSONAL_ACCESO_ORGANIZACION			INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(200)	OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO='' 
		BEGIN

		DECLARE @VP_EXISTE_CLAVE	INT

		SELECT	@VP_EXISTE_CLAVE =	COUNT(K_PERSONAL_ACCESO_ORGANIZACION)
									FROM	PERSONAL_ACCESO_ORGANIZACION 
									WHERE	K_PERSONAL_ACCESO_ORGANIZACION=@PP_K_PERSONAL_ACCESO_ORGANIZACION
										
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


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN // VALIDACION INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_INSERT]
GO


CREATE PROCEDURE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_INSERT]
	@PP_L_DEBUG									INT,
	@PP_K_SISTEMA_EXE							INT,
	@PP_K_USUARIO_ACCION						INT,
	-- ===========================		
	@PP_K_PERSONAL_ACCESO_ORGANIZACION			INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(200)	OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //INS//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN // VALIDACION INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_UPDATE]
GO

CREATE PROCEDURE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_UPDATE]
	@PP_L_DEBUG											INT,
	@PP_K_SISTEMA_EXE									INT,
	@PP_K_USUARIO_ACCION								INT,
	-- ===========================		
	@PP_K_PERSONAL_ACCESO_ORGANIZACION					INT,	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			VARCHAR(200)	OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
		
	-- ///////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_EXISTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_PERSONAL_ACCESO_ORGANIZACION,	 
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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_DELETE]
	@PP_L_DEBUG									INT,
	@PP_K_SISTEMA_EXE							INT,
	@PP_K_USUARIO_ACCION						INT,
	-- ===========================		
	@PP_K_PERSONAL_ACCESO_ORGANIZACION			INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(200)	OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														1, -- @PP_K_DATA_SISTEMA,	
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PERSONAL_ACCESO_ORGANIZACION_EXISTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_PERSONAL_ACCESO_ORGANIZACION, 
																		@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////




	-- ///////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //DEL//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO





-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
