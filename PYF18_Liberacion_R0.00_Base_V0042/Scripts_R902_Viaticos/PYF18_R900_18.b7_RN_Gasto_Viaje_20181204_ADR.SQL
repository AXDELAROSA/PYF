-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			RN_Gasto_Viaje_20181116_DPR.sql
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			CONTROL DE VIAJES - GASTO_VIAJE
-- // OPERACIÓN:		LIBERACIÓN / REGLAS DE NEGOCIO
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			Daniel Portillo Romero
-- // Fecha creación:	16/NOV/2018 
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EXISTE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_GASTO_VIAJE_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_GASTO_VIAJE_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_GASTO_VIAJE_EXISTE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================		
	@PP_K_GASTO_VIAJE				INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION		VARCHAR (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO			VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_GASTO_VIAJE			INT
	DECLARE @VP_L_BORRADO				INT
		
	SELECT	@VP_K_GASTO_VIAJE		=	GASTO_VIAJE.K_GASTO_VIAJE,
			@VP_L_BORRADO			=	GASTO_VIAJE.L_BORRADO
										FROM	GASTO_VIAJE
										WHERE	GASTO_VIAJE.K_GASTO_VIAJE=@PP_K_GASTO_VIAJE										
	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_GASTO_VIAJE IS NULL )
			SET @VP_RESULTADO =  'El [GASTO_VIAJE] no existe.' 
	
	-- ===========================

	IF @VP_RESULTADO=''
		IF @VP_L_BORRADO=1
			SET @VP_RESULTADO =  'El [GASTO_VIAJE] fue dado de baja.' 
					
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EXISTE_VIAJE_GASTO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_GASTO_VIAJE_X_K_VIAJE_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_GASTO_VIAJE_X_K_VIAJE_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_GASTO_VIAJE_X_K_VIAJE_EXISTE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================		
	@PP_K_VIAJE						INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION		VARCHAR (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO			VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_VIAJE					INT
	DECLARE @VP_L_BORRADO				INT
		
	SELECT	@VP_K_VIAJE				=	GASTO_VIAJE.K_VIAJE
										FROM	GASTO_VIAJE
										WHERE	GASTO_VIAJE.K_VIAJE=@PP_K_VIAJE
										AND GASTO_VIAJE.L_BORRADO = 0										
	-- ===========================

	--IF @VP_RESULTADO=''
	IF ( @VP_K_VIAJE IS NOT NULL )
		SET @VP_RESULTADO = ''
		ELSE 
		SET @VP_RESULTADO =  'NO EXISTE GASTO VIAJE ASOCIADO AL VIAJE //LI//'			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_GASTO_VIAJE_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_GASTO_VIAJE_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_RN_GASTO_VIAJE_DELETE]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_USUARIO_ACCION		[INT],
	-- ===========================		
	@PP_K_GASTO_VIAJE			[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''

	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														11, -- @PP_K_DATA_SISTEMA,	
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
		
	-- ///////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_GASTO_VIAJE_EXISTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_GASTO_VIAJE,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////


	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //DEL//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_GASTO_VIAJE_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_GASTO_VIAJE_INSERT]
GO


CREATE PROCEDURE [dbo].[PG_RN_GASTO_VIAJE_INSERT]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_USUARIO_ACCION		[INT],
	-- ===========================		
	@PP_K_GASTO_VIAJE			[INT],		
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
		
	-- ///////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //INS//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACIÓN UPDATE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_GASTO_VIAJE_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_GASTO_VIAJE_UPDATE]
GO


CREATE PROCEDURE [dbo].[PG_RN_GASTO_VIAJE_UPDATE]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_USUARIO_ACCION		[INT],
	-- ===========================		
	@PP_K_GASTO_VIAJE			[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
		
	-- ///////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_GASTO_VIAJE_EXISTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_GASTO_VIAJE,	 
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	-- ///////////////////////////////////////////
	
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
