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
-- // STORED PROCEDURE ---> RN_EXISTE_PERO_BORRADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PARAMETRO_SUCURSAL_EXISTE_PERO_BORRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_EXISTE_PERO_BORRADO]
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_BORRABLE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PARAMETRO_SUCURSAL_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_EXISTE]
	@PP_L_DEBUG					    [INT],
	@PP_K_SISTEMA_EXE			    [INT],
	@PP_K_USUARIO_ACCION		    [INT],
	-- ======================== 
	@PP_K_PARAMETRO_SUCURSAL   [INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_PARAMETRO_SUCURSAL	INT
	DECLARE @VP_L_BORRADO			INT
		
	SELECT	@VP_K_PARAMETRO_SUCURSAL	=	PARAMETRO_SUCURSAL.K_PARAMETRO_SUCURSAL,
			@VP_L_BORRADO			=	PARAMETRO_SUCURSAL.L_BORRADO
    FROM	PARAMETRO_SUCURSAL
    WHERE	PARAMETRO_SUCURSAL.K_PARAMETRO_SUCURSAL=@PP_K_PARAMETRO_SUCURSAL										

	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_PARAMETRO_SUCURSAL IS NULL )
			SET @VP_RESULTADO =  'La [PARAMETRO_SUCURSAL] no existe.' 
	
	-- ===========================

	IF @VP_RESULTADO=''
		IF @VP_L_BORRADO=1
			SET @VP_RESULTADO =  'La [PARAMETRO_SUCURSAL] fue dada de baja.' 
					
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PARAMETRO_SUCURSAL_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_DELETE]
	@PP_L_DEBUG					    [INT],
	@PP_K_SISTEMA_EXE			    [INT],
	@PP_K_USUARIO_ACCION		    [INT],
	-- ===========================		
	@PP_K_PARAMETRO_SUCURSAL		    [INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PARAMETRO_SUCURSAL_EXISTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PARAMETRO_SUCURSAL,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////




	-- ///////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //DEL//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PARAMETRO_SUCURSAL_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_INSERT]
GO


CREATE PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_INSERT]
	@PP_L_DEBUG					    [INT],
	@PP_K_SISTEMA_EXE			    [INT],
	@PP_K_USUARIO_ACCION		    [INT],
	-- ===========================		
	@PP_K_PARAMETRO_SUCURSAL	[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	-- ///////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //INS//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO
		
	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION UPDATE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PARAMETRO_SUCURSAL_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_UPDATE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PARAMETRO_SUCURSAL_UPDATE]
	@PP_L_DEBUG					    [INT],
	@PP_K_SISTEMA_EXE			    [INT],
	@PP_K_USUARIO_ACCION		    [INT],
	-- ===========================		
	@PP_K_PARAMETRO_SUCURSAL	[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PARAMETRO_SUCURSAL_EXISTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PARAMETRO_SUCURSAL,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	
	-- //////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //UPD//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
