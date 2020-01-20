-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			LOGIN
-- // OPERACION:		LIBERACION / 
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////

--//////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LOG_IN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LOG_IN]
GO

CREATE PROCEDURE [dbo].[PG_LOG_IN]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================	
	@PP_LOGIN_ID			VARCHAR(100),
	@PP_CONTRASENA			VARCHAR(100)
	-- ===========================
AS

	DECLARE	@VP_K_USUARIO	INT
	DECLARE	@VP_MENSAJE		VARCHAR(500)
	DECLARE	@VP_LOGIN		VARCHAR(100)
	DECLARE	@VP_PASS		VARCHAR(100)
	DECLARE	@VP_D_USUARIO	VARCHAR(100)
	DECLARE	@VP_EXITO		BIT
	
	SET	@VP_MENSAJE = ''	
	SET @PP_K_USUARIO_ACCION = '69' -- ESTO PARA PERMITIR EL ACCESO AL SELECT

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	IF @VP_MENSAJE = ''
	BEGIN
		SELECT	@VP_LOGIN		=	LOGIN_ID,
				@VP_PASS		=	CONTRASENA,
				@VP_K_USUARIO	=	K_USUARIO,
				@VP_D_USUARIO	=	D_USUARIO
									FROM	dbo.USUARIO
									WHERE	LOGIN_ID=@PP_LOGIN_ID
									AND		CONTRASENA=@PP_CONTRASENA
									AND		K_ESTATUS_USUARIO=1

		IF @VP_LOGIN <> '' AND @VP_PASS <>''
			SET @VP_EXITO = 1
		ELSE
			SET @VP_MENSAJE = 'Usuario y/o contraseña invalidos.'
			
	END
	IF @VP_MENSAJE <> ''
	BEGIN
		SET @VP_MENSAJE = @VP_MENSAJE + ' Por favor verifique.'
		SET @VP_EXITO = 0
	END

	SELECT @VP_MENSAJE AS MENSAJE, @VP_K_USUARIO AS CLAVE, @VP_D_USUARIO AS DESCR, @VP_EXITO AS EXITO

	-- ///////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LOG_IN]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_USUARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_LOGIN_ID, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_LOGIN_ID', '', '', ''

	-- ///////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> LOGIN DESARROLLO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LOG_DESARROLLO_IN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LOG_DESARROLLO_IN]
GO

CREATE PROCEDURE [dbo].[PG_LOG_DESARROLLO_IN]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================	
	@PP_LOGIN_ID			VARCHAR(100),
	@PP_CONTRASENA			VARCHAR(100),
	@PP_PASSWORD_DESARROLLO	VARCHAR(100)
	-- ===========================
AS

	DECLARE	@VP_K_USUARIO	INT
	DECLARE	@VP_MENSAJE		VARCHAR(500)
	DECLARE	@VP_LOGIN		VARCHAR(100)
	DECLARE	@VP_PASS		VARCHAR(100)
	DECLARE	@VP_D_USUARIO	VARCHAR(100)
	DECLARE	@VP_EXITO		BIT
	
	SET	@VP_MENSAJE = ''	
	SET @PP_K_USUARIO_ACCION = '69' -- ESTO PARA PERMITIR EL ACCESO AL SELECT

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- ///////////////////////////////////////////


	--	VERIFICA SI EL PASSWORD DE DESARROLLO ES EL CORRECTO DE LA BASE  --

	IF @VP_MENSAJE = ''
	BEGIN
		DECLARE @VP_PASSWORD AS INT=0

		SELECT @VP_PASSWORD	=	COUNT(K_VALOR_PARAMETRO) 
								FROM	VALOR_PARAMETRO 
								WHERE	K_PARAMETRO=204	
								AND		VALOR_PARAMETRO_TXT_1=@PP_PASSWORD_DESARROLLO 
		IF @VP_PASSWORD<1
			SET @VP_MENSAJE = 'PASSWORD DESARROLLO INCORRECTO. '
	END
	


	IF @VP_MENSAJE = ''
	BEGIN
		SELECT	@VP_LOGIN		=	LOGIN_ID,
				@VP_PASS		=	CONTRASENA,
				@VP_K_USUARIO	=	K_USUARIO,
				@VP_D_USUARIO	=	D_USUARIO
									FROM	dbo.USUARIO
									WHERE	LOGIN_ID=@PP_LOGIN_ID
									AND		CONTRASENA=@PP_CONTRASENA
									AND		K_ESTATUS_USUARIO=1

		IF @VP_LOGIN <> '' AND @VP_PASS <>''
			SET @VP_EXITO = 1
		ELSE
			SET @VP_MENSAJE = 'Usuario y/o contraseña invalidos.'
			
	END
	IF @VP_MENSAJE <> ''
	BEGIN
		SET @VP_MENSAJE = @VP_MENSAJE + ' Por favor verifique.'
		SET @VP_EXITO = 0
	END

	SELECT @VP_MENSAJE AS MENSAJE, @VP_K_USUARIO AS CLAVE, @VP_D_USUARIO AS DESCR, @VP_EXITO AS EXITO

	-- ///////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LOG_IN]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_USUARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_LOGIN_ID, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_LOGIN_ID', '', '', ''

	-- ///////////////////////////////////////////
GO
