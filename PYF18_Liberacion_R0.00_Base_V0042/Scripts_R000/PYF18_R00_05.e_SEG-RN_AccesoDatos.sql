-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			
-- // OPERACION:		LIBERACION / 
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DATA_VER_BORRADOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DATA_VER_BORRADOS]
GO


CREATE PROCEDURE [dbo].[PG_RN_DATA_VER_BORRADOS]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@OU_L_VER_BORRADOS					[INT]		OUTPUT
AS

	DECLARE	@VP_K_PERFIL_X_DATA_ACCESO		INT

	SELECT	@VP_K_PERFIL_X_DATA_ACCESO =	MIN(K_DATA_OPERACION)
											FROM	DATA_ACCESO
											WHERE	K_USUARIO=@PP_K_USUARIO_ACCION
	IF @PP_L_DEBUG=1
		IF @VP_K_PERFIL_X_DATA_ACCESO IS NULL
			PRINT '@VP_K_PERFIL_X_DATA_ACCESO = NULO'
		ELSE
			PRINT '@VP_K_PERFIL_X_DATA_ACCESO = '+CONVERT(VARCHAR(100),@VP_K_PERFIL_X_DATA_ACCESO)
	
	-- ===========================

	DECLARE	@VP_K_PERFIL_X_USUARIO_PERFIL	INT

	SELECT	@VP_K_PERFIL_X_USUARIO_PERFIL =	MIN(K_DATA_PERFIL)
											FROM	USUARIO_DATA_PERFIL
											WHERE	K_USUARIO=@PP_K_USUARIO_ACCION
	IF @PP_L_DEBUG=1
		IF @VP_K_PERFIL_X_USUARIO_PERFIL IS NULL
			PRINT '@VP_K_PERFIL_X_USUARIO_PERFIL = NULO'
		ELSE
			PRINT '@VP_K_PERFIL_X_USUARIO_PERFIL = '+CONVERT(VARCHAR(100),@VP_K_PERFIL_X_USUARIO_PERFIL)	
	-- ===========================

	DECLARE	@VP_L_VER_BORRADOS		INT 

	IF @VP_K_PERFIL_X_DATA_ACCESO=0	OR @VP_K_PERFIL_X_USUARIO_PERFIL=0		--K_DATA_PERFIL	// 0 TI/MASTER
		SET @VP_L_VER_BORRADOS = 1
	ELSE
		SET @VP_L_VER_BORRADOS = 0
	
	-- ===========================

	SET @OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS

	-- /////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DATA_ACCESO_VALIDACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DATA_ACCESO_VALIDACION]
GO


CREATE PROCEDURE [dbo].[PG_RN_DATA_ACCESO_VALIDACION]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_DATA_SISTEMA					[INT],	
	@PP_K_DATA_OPERACION				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- ///////////////////////////////////////////
	-- K_DATA_OPERACION	
	-- 1 LISTADO LI // 2 FICHA SK // 3 INSERTAR IN // 4 ACTUALIZAR UP // 5 BORRAR DL

	DECLARE @VP_N_ACCESO_X_USUARIO		INT = 0
	
	SELECT	@VP_N_ACCESO_X_USUARIO =	COUNT([K_DATA_OPERACION])	
										FROM	[dbo].[DATA_ACCESO]
										WHERE	[K_USUARIO]=@PP_K_USUARIO_ACCION
										AND		[K_DATA_SISTEMA]=@PP_K_DATA_SISTEMA
										AND		[K_DATA_OPERACION]=@PP_K_DATA_OPERACION
	-- =======================

	DECLARE @VP_N_ACCESO_X_PERFIL		INT = 0
	
	SELECT	@VP_N_ACCESO_X_PERFIL =		COUNT([K_DATA_OPERACION])	
										FROM	[dbo].[DATA_ACCESO], [dbo].[USUARIO_DATA_PERFIL]
										WHERE	[USUARIO_DATA_PERFIL].[K_USUARIO]=@PP_K_USUARIO_ACCION
										AND		[DATA_ACCESO].K_DATA_PERFIL=[USUARIO_DATA_PERFIL].K_DATA_PERFIL
										AND		[DATA_ACCESO].K_USUARIO IS NULL
										AND		[DATA_ACCESO].[K_DATA_SISTEMA]=@PP_K_DATA_SISTEMA
										AND		[DATA_ACCESO].[K_DATA_OPERACION]=@PP_K_DATA_OPERACION
	-- =======================

	IF @VP_RESULTADO=''
		IF @VP_N_ACCESO_X_USUARIO=0 AND @VP_N_ACCESO_X_PERFIL=0
			SET @VP_RESULTADO =  'No tiene autorización para realizar esta operación.' 								
											
	-- ///////////////////////////////////////////

	SET @VP_RESULTADO=''	-- WIWI // 20180904 // HGF // DESACTIVAR VALIDACION ACCESO A DATOS
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION SELECT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DATA_ACCESO_SELECT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DATA_ACCESO_SELECT]
GO


CREATE PROCEDURE [dbo].[PG_RN_DATA_ACCESO_SELECT]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_DATA_SISTEMA					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- ///////////////////////////////////////////
	-- K_DATA_OPERACION	
	-- 1 LISTADO LI // 2 FICHA SK // 3 INSERTAR IN // 4 ACTUALIZAR UP // 5 BORRAR DL

	DECLARE @VP_K_DATA_OPERACION	INT

	SET @VP_K_DATA_OPERACION = 1

	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_VALIDACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_DATA_SISTEMA, @VP_K_DATA_OPERACION,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' [Select]'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION SELECT/FICHA
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DATA_ACCESO_SEEK]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DATA_ACCESO_SEEK]
GO


CREATE PROCEDURE [dbo].[PG_RN_DATA_ACCESO_SEEK]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_DATA_SISTEMA					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- ///////////////////////////////////////////
	-- K_DATA_OPERACION	
	-- 1 LISTADO LI // 2 FICHA SK // 3 INSERTAR IN // 4 ACTUALIZAR UP // 5 BORRAR DL

	DECLARE @VP_K_DATA_OPERACION	INT

	SET @VP_K_DATA_OPERACION = 2

	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_VALIDACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_DATA_SISTEMA, @VP_K_DATA_OPERACION,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' [Seek]'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DATA_ACCESO_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DATA_ACCESO_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_RN_DATA_ACCESO_DELETE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_DATA_SISTEMA					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
	-- ///////////////////////////////////////////
	-- K_DATA_OPERACION	
	-- 1 LISTADO LI // 2 FICHA SK // 3 INSERTAR IN // 4 ACTUALIZAR UP // 5 BORRAR DL

	DECLARE @VP_K_DATA_OPERACION	INT

	SET @VP_K_DATA_OPERACION = 5

	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_VALIDACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_DATA_SISTEMA, @VP_K_DATA_OPERACION,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' [Delete]'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DATA_ACCESO_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DATA_ACCESO_INSERT]
GO


CREATE PROCEDURE [dbo].[PG_RN_DATA_ACCESO_INSERT]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_DATA_SISTEMA					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- ///////////////////////////////////////////
	-- K_DATA_OPERACION	
	-- 1 LISTADO LI // 2 FICHA SK // 3 INSERTAR IN // 4 ACTUALIZAR UP // 5 BORRAR DL

	DECLARE @VP_K_DATA_OPERACION	INT

	SET @VP_K_DATA_OPERACION = 3

	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_VALIDACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_DATA_SISTEMA, @VP_K_DATA_OPERACION,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' [Insert]'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION UPDATE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DATA_ACCESO_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DATA_ACCESO_UPDATE]
GO


CREATE PROCEDURE [dbo].[PG_RN_DATA_ACCESO_UPDATE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_DATA_SISTEMA					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- ///////////////////////////////////////////
	-- K_DATA_OPERACION	
	-- 1 LISTADO LI // 2 FICHA SK // 3 INSERTAR IN // 4 ACTUALIZAR UP // 5 BORRAR DL

	DECLARE @VP_K_DATA_OPERACION	INT

	SET @VP_K_DATA_OPERACION = 4

	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_VALIDACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_DATA_SISTEMA, @VP_K_DATA_OPERACION,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' [Update]'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////
