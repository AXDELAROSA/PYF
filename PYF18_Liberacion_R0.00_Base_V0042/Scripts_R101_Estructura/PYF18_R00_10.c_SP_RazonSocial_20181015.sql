-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			ORGANIZACION / RAZON_SOCIAL 
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_RAZON_SOCIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_RAZON_SOCIAL]
GO


CREATE PROCEDURE [dbo].[PG_LI_RAZON_SOCIAL]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_D_RAZON_SOCIAL				VARCHAR(255),
	@PP_K_ESTATUS_RAZON_SOCIAL		INT,
	@PP_K_TIPO_RAZON_SOCIAL			INT,
	@PP_K_REGION					INT
	-- ===========================
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	IF @PP_L_DEBUG=1
		PRINT @VP_MENSAJE
	
	-- ///////////////////////////////////////////
		
	DECLARE @VP_LI_N_REGISTROS		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															@VP_L_APLICAR_MAX_ROWS,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- =========================================	

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0
	
	-- =========================================		

	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_D_RAZON_SOCIAL, 
													@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
		
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	SELECT	TOP ( @VP_LI_N_REGISTROS )
			RAZON_SOCIAL.*,
			USUARIO.D_USUARIO AS D_USUARIO_CAMBIO,
			-- ==============================
			D_ESTATUS_RAZON_SOCIAL, D_TIPO_RAZON_SOCIAL, D_REGION,
			S_ESTATUS_RAZON_SOCIAL, S_TIPO_RAZON_SOCIAL, S_REGION
			-- ==============================
	FROM	RAZON_SOCIAL, USUARIO, 
			ESTATUS_RAZON_SOCIAL, TIPO_RAZON_SOCIAL, REGION
			-- ==============================
	WHERE	RAZON_SOCIAL.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL=ESTATUS_RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL
	AND		RAZON_SOCIAL.K_TIPO_RAZON_SOCIAL=TIPO_RAZON_SOCIAL.K_TIPO_RAZON_SOCIAL
	AND		RAZON_SOCIAL.K_REGION=REGION.K_REGION
			-- ==============================
	AND		(	D_RAZON_SOCIAL			LIKE '%'+@PP_D_RAZON_SOCIAL+'%' 
			OR	RFC_RAZON_SOCIAL		LIKE '%'+@PP_D_RAZON_SOCIAL+'%' 
			OR	D_TIPO_RAZON_SOCIAL		LIKE '%'+@PP_D_RAZON_SOCIAL+'%' 
			OR	K_RAZON_SOCIAL=@VP_K_FOLIO	)	
			-- ==============================
	AND		(	@PP_K_ESTATUS_RAZON_SOCIAL=-1	OR  RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL=@PP_K_ESTATUS_RAZON_SOCIAL )
	AND		(	@PP_K_TIPO_RAZON_SOCIAL=-1		OR  RAZON_SOCIAL.K_TIPO_RAZON_SOCIAL=@PP_K_TIPO_RAZON_SOCIAL )
	AND		(	@PP_K_REGION=-1					OR  RAZON_SOCIAL.K_REGION=@PP_K_REGION	)
	AND		(	RAZON_SOCIAL.L_BORRADO=0		OR	@VP_L_VER_BORRADOS=1	)
			-- ==============================
	ORDER BY D_RAZON_SOCIAL ASC

	-- ////////////////////////////////////////////////

GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_RAZON_SOCIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_RAZON_SOCIAL]
GO


CREATE PROCEDURE [dbo].[PG_SK_RAZON_SOCIAL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_RAZON_SOCIAL				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		SELECT	RAZON_SOCIAL.*, 
				-- ==============================
				D_ESTATUS_RAZON_SOCIAL, D_TIPO_RAZON_SOCIAL, D_REGION,
				S_ESTATUS_RAZON_SOCIAL, S_TIPO_RAZON_SOCIAL, S_REGION
				-- ==============================
		FROM	RAZON_SOCIAL, USUARIO, 
				ESTATUS_RAZON_SOCIAL, TIPO_RAZON_SOCIAL, REGION
				-- ==============================
		WHERE	RAZON_SOCIAL.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
		AND		RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL=ESTATUS_RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL
		AND		RAZON_SOCIAL.K_TIPO_RAZON_SOCIAL=TIPO_RAZON_SOCIAL.K_TIPO_RAZON_SOCIAL
		AND		RAZON_SOCIAL.K_REGION=REGION.K_REGION
				-- ==============================
		AND		RAZON_SOCIAL.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL

		END

	-- ////////////////////////////////////////////////
GO


	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_RAZON_SOCIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_RAZON_SOCIAL]
GO


CREATE PROCEDURE [dbo].[PG_IN_RAZON_SOCIAL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================				
	@PP_D_RAZON_SOCIAL			VARCHAR(100),	
	@PP_S_RAZON_SOCIAL			VARCHAR(10),	
	@PP_K_ESTATUS_RAZON_SOCIAL	INT,	
	@PP_K_TIPO_RAZON_SOCIAL		INT,	
	@PP_RAZON_SOCIAL			VARCHAR(100),	
	@PP_RFC_RAZON_SOCIAL		VARCHAR(100),	
	@PP_CURP					VARCHAR(100),	
	@PP_CORREO					VARCHAR(100),	
	@PP_TELEFONO				VARCHAR(100),	
	@PP_CALLE					VARCHAR(100),	
	@PP_NUMERO_EXTERIOR			VARCHAR(100),	
	@PP_NUMERO_INTERIOR			VARCHAR(100),	
	@PP_COLONIA					VARCHAR(100),	
	@PP_POBLACION				VARCHAR(100),	
	@PP_CP						VARCHAR(100),	
	@PP_MUNICIPIO				VARCHAR(100),	
	@PP_K_REGION				INT	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_RAZON_SOCIAL	INT = 0
	DECLARE @VP_O_RAZON_SOCIAL	INT = 0
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RAZON_SOCIAL_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@VP_K_RAZON_SOCIAL, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RAZON_SOCIAL_UNIQUE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@VP_K_RAZON_SOCIAL, 
													@PP_D_RAZON_SOCIAL, @PP_RFC_RAZON_SOCIAL,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'RAZON_SOCIAL', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_RAZON_SOCIAL	OUTPUT

		-- //////////////////////////////////////////////////////////////
		
		INSERT INTO RAZON_SOCIAL
			(	[K_RAZON_SOCIAL],
				[D_RAZON_SOCIAL], [S_RAZON_SOCIAL], [O_RAZON_SOCIAL],
				[K_ESTATUS_RAZON_SOCIAL], K_TIPO_RAZON_SOCIAL,
				-- ===========================
				[RAZON_SOCIAL], [RFC_RAZON_SOCIAL], 
				[CURP], [CORREO], [TELEFONO], 
				[CALLE], [NUMERO_EXTERIOR], [NUMERO_INTERIOR],
				[COLONIA], [POBLACION],	[CP],
				[MUNICIPIO], [K_REGION],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_RAZON_SOCIAL,
				@PP_D_RAZON_SOCIAL, @PP_S_RAZON_SOCIAL, @VP_O_RAZON_SOCIAL,
				@PP_K_ESTATUS_RAZON_SOCIAL,	@PP_K_TIPO_RAZON_SOCIAL,
				-- ===========================
				@PP_RAZON_SOCIAL, @PP_RFC_RAZON_SOCIAL, 
				@PP_CURP, @PP_CORREO,@PP_TELEFONO, 
				@PP_CALLE, @PP_NUMERO_EXTERIOR, @PP_NUMERO_INTERIOR,
				@PP_COLONIA, @PP_POBLACION,@PP_CP, 
				@PP_MUNICIPIO, @PP_K_REGION,
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] la [Razón Social]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#RZS.'+CONVERT(VARCHAR(10),@VP_K_RAZON_SOCIAL)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_RAZON_SOCIAL AS CLAVE

	-- //////////////////////////////////////////////////////////////

GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> ACTUALIZAR / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_RAZON_SOCIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_RAZON_SOCIAL]
GO

CREATE PROCEDURE [dbo].[PG_UP_RAZON_SOCIAL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_RAZON_SOCIAL			INT,
	@PP_D_RAZON_SOCIAL			VARCHAR(100),
	@PP_S_RAZON_SOCIAL			VARCHAR(100),
	@PP_K_ESTATUS_RAZON_SOCIAL	INT,	
	@PP_K_TIPO_RAZON_SOCIAL		INT,	
	@PP_RAZON_SOCIAL			VARCHAR(100),
	@PP_RFC_RAZON_SOCIAL		VARCHAR(100),
	@PP_CURP					VARCHAR(100),
	@PP_CORREO					VARCHAR(100),
	@PP_TELEFONO				VARCHAR(100),
	@PP_CALLE					VARCHAR(100),
	@PP_NUMERO_EXTERIOR			VARCHAR(100),
	@PP_NUMERO_INTERIOR			VARCHAR(100),
	@PP_COLONIA					VARCHAR(100),
	@PP_POBLACION				VARCHAR(100),
	@PP_CP						VARCHAR(100),
	@PP_MUNICIPIO				VARCHAR(100),
	@PP_K_REGION				INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RAZON_SOCIAL_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_RAZON_SOCIAL, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RAZON_SOCIAL_UNIQUE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_RAZON_SOCIAL, 
													@PP_D_RAZON_SOCIAL, @PP_RFC_RAZON_SOCIAL,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	RAZON_SOCIAL
		SET		
				[D_RAZON_SOCIAL]		= @PP_D_RAZON_SOCIAL,
				[S_RAZON_SOCIAL]		= @PP_S_RAZON_SOCIAL,
				[K_ESTATUS_RAZON_SOCIAL] = @PP_K_ESTATUS_RAZON_SOCIAL,	
				[K_TIPO_RAZON_SOCIAL]	= @PP_K_TIPO_RAZON_SOCIAL,
				-- ===========================
			    [RAZON_SOCIAL]			= @PP_RAZON_SOCIAL, 
				[RFC_RAZON_SOCIAL]		= @PP_RFC_RAZON_SOCIAL,
				[CURP]					= @PP_CURP,			
				[CORREO]				= @PP_CORREO,
				[TELEFONO]				= @PP_TELEFONO,
				[CALLE]					= @PP_CALLE, 
				[NUMERO_EXTERIOR]		= @PP_NUMERO_EXTERIOR, 
				[NUMERO_INTERIOR]		= @PP_NUMERO_INTERIOR, 
				[COLONIA]				= @PP_COLONIA, 
				[POBLACION]				= @PP_POBLACION, 
				[CP]					= @PP_CP,
				[MUNICIPIO]				= @PP_MUNICIPIO, 
				[K_REGION]				= @PP_K_REGION,
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] la [Razón Social]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#RZS.'+CONVERT(VARCHAR(10),@PP_K_RAZON_SOCIAL)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_RAZON_SOCIAL AS CLAVE

	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_RAZON_SOCIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_RAZON_SOCIAL]
GO


CREATE PROCEDURE [dbo].[PG_DL_RAZON_SOCIAL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_RAZON_SOCIAL			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RAZON_SOCIAL_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_RAZON_SOCIAL, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
	--	DELETE
	--	FROM	EMPRESA
	--	WHERE	EMPRESA.K_EMPRESA=@PP_K_EMPRESA

		UPDATE	RAZON_SOCIAL
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la [Razón Social]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#RZS.'+CONVERT(VARCHAR(10),@PP_K_RAZON_SOCIAL)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_RAZON_SOCIAL AS CLAVE

	-- //////////////////////////////////////////////////////////////
	
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
