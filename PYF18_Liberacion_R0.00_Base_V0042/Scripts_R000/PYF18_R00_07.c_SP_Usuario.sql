-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	[PYF18_Finanzas_V9999_R0]
-- // MODULO:			USUARIO
-- // OPERACION:		LIBERACION // STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////

--//////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_USUARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_USUARIO]
GO

CREATE PROCEDURE [dbo].[PG_LI_USUARIO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_D_USUARIO				VARCHAR(255),
	@PP_K_TIPO_USUARIO			INT,
	@PP_K_ESTATUS_ACTIVO		INT
	-- ===========================
AS

	DECLARE @VP_D_USUARIO_CAMBIO		VARCHAR(100)
	DECLARE @VP_MENSAJE					VARCHAR(300)
	DECLARE @VP_L_APLICAR_MAX_ROWS		INT = 1
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_INT_NUMERO_REGISTROS	INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
		-- =========================================		

	-- ///////////////////////////////////////////

	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_D_USUARIO, 
													@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT

	-- ///////////////////////////////////////////

	SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
			USUARIO.*, US.D_USUARIO AS D_USUARIO_CAMBIO,
			TU.D_TIPO_USUARIO,EA.D_ESTATUS_ACTIVO, EA.S_ESTATUS_ACTIVO	

	FROM	USUARIO
	LEFT JOIN USUARIO US ON USUARIO.K_USUARIO_CAMBIO=US.K_USUARIO
	LEFT JOIN TIPO_USUARIO TU ON USUARIO.K_TIPO_USUARIO=TU.K_TIPO_USUARIO
	LEFT JOIN ESTATUS_ACTIVO EA ON USUARIO.L_USUARIO=EA.K_ESTATUS_ACTIVO
	WHERE	USUARIO.L_BORRADO=0
	AND		(	
				USUARIO.D_USUARIO		LIKE '%'+@PP_D_USUARIO+'%' 
			OR	USUARIO.K_USUARIO=@VP_K_FOLIO 
			)
	AND		( @PP_K_TIPO_USUARIO=-1	OR		USUARIO.K_TIPO_USUARIO=@PP_K_TIPO_USUARIO)	
	AND		( @PP_K_ESTATUS_ACTIVO=-1	OR		USUARIO.K_ESTATUS_USUARIO=@PP_K_ESTATUS_ACTIVO)
	
	ORDER BY USUARIO.D_USUARIO
		
	-- ///////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_USUARIO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_USUARIO, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_USUARIO', '', '', ''
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_USUARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_USUARIO]
GO

CREATE PROCEDURE [dbo].[PG_SK_USUARIO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_USUARIO			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	SELECT	USUARIO.*,
			D_ESTATUS_ACTIVO, S_ESTATUS_ACTIVO
	FROM	USUARIO, ESTATUS_ACTIVO
	WHERE	USUARIO.L_USUARIO=ESTATUS_ACTIVO.K_ESTATUS_ACTIVO
	AND		L_BORRADO=0
	AND		USUARIO.K_USUARIO=@PP_K_USUARIO
		
	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_USUARIO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_USUARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@', '', '', ''

GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_USUARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_USUARIO]
GO

CREATE PROCEDURE [dbo].[PG_IN_USUARIO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_D_USUARIO				VARCHAR(100),
	@PP_C_USUARIO				VARCHAR(500),
	@PP_S_USUARIO				VARCHAR(10),
	@PP_L_USUARIO				INT,
	@PP_CORREO					VARCHAR(100),
	@PP_LOGIN_ID				VARCHAR(25),
	@PP_CONTRASENA				VARCHAR(25),
	@PP_K_ESTATUS_USUARIO		INT,
	@PP_K_TIPO_USUARIO			INT,
	@PP_K_PERSONAL_PREDEFINIDO	INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	DECLARE @VP_O_USUARIO	INT = 0
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_USUARIO	INT = 0
	
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_USUARIO_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@VP_K_USUARIO, @PP_D_USUARIO ,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'USUARIO', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_USUARIO			OUTPUT

		-- //////////////////////////////////////////////////////////////
		

		INSERT INTO USUARIO
			(	[K_USUARIO],		[D_USUARIO],
				[C_USUARIO],		[S_USUARIO],
				[O_USUARIO],		[L_USUARIO],
				[CORREO],
				[LOGIN_ID],			[CONTRASENA],
				[F_CONTRASENA],		[K_ESTATUS_USUARIO],
				[K_TIPO_USUARIO],	[K_PERSONAL_PREDEFINIDO],
				-- ===========================

				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_USUARIO,		@PP_D_USUARIO,
				@PP_C_USUARIO,		@PP_S_USUARIO,
				@VP_O_USUARIO,		@PP_L_USUARIO,
				@PP_CORREO,
				@PP_LOGIN_ID,		@PP_CONTRASENA,
				GETDATE(),			@PP_K_ESTATUS_USUARIO,
				@PP_K_TIPO_USUARIO,	@PP_K_PERSONAL_PREDEFINIDO,
				-- ===========================

				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [USUARIO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Ca.'+CONVERT(VARCHAR(10),@VP_K_USUARIO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_USUARIO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_USUARIO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_USUARIO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_USUARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_USUARIO, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_USUARIO', '', '', ''

GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> ACTUALIZAR / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_USUARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_USUARIO]
GO

CREATE PROCEDURE [dbo].[PG_UP_USUARIO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_USUARIO				INT,
	@PP_D_USUARIO				VARCHAR(100),
	@PP_C_USUARIO				VARCHAR(500),
	@PP_S_USUARIO				VARCHAR(10),
	@PP_L_USUARIO				INT,
	@PP_CORREO					VARCHAR(100),
	@PP_LOGIN_ID				VARCHAR(25),
	@PP_CONTRASENA				VARCHAR(25),
	@PP_K_ESTATUS_USUARIO		INT,
	@PP_K_TIPO_USUARIO			INT,
	@PP_K_PERSONAL_PREDEFINIDO	INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	DECLARE	@VP_CONTRASENA	VARCHAR(100)
	
	SELECT @VP_CONTRASENA =	CONTRASENA
							FROM	dbo.USUARIO
							WHERE	K_USUARIO=@PP_K_USUARIO

	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_USUARIO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_USUARIO, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	USUARIO
		SET						 
				[D_USUARIO]					=	@PP_D_USUARIO,
				[C_USUARIO]					=	@PP_C_USUARIO,
				[S_USUARIO]					=	@PP_S_USUARIO,
				[L_USUARIO]					=	@PP_L_USUARIO,
				[CORREO]					=	@PP_CORREO,
				[LOGIN_ID]					=	@PP_LOGIN_ID,
				[CONTRASENA]				=	@PP_CONTRASENA,
				[F_CONTRASENA]				=	GETDATE(),
				[K_ESTATUS_USUARIO]			=	@PP_K_ESTATUS_USUARIO,
				[K_TIPO_USUARIO]			=	@PP_K_TIPO_USUARIO,
				[K_PERSONAL_PREDEFINIDO]	=	@PP_K_PERSONAL_PREDEFINIDO,
				-- ===========================
				[F_CAMBIO]					=	GETDATE(), 
				[K_USUARIO_CAMBIO]			=	@PP_K_USUARIO_ACCION
		WHERE	K_USUARIO=@PP_K_USUARIO
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [USUARIO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Ca.'+CONVERT(VARCHAR(10),@PP_K_USUARIO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_USUARIO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_USUARIO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_USUARIO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_USUARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0,@VP_CONTRASENA, @PP_CONTRASENA , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@VP_CONTRASENA', '@PP_CONTRASENA', '', ''
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_USUARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_USUARIO]
GO

CREATE PROCEDURE [dbo].[PG_DL_USUARIO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_USUARIO			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_USUARIO_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_USUARIO, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	USUARIO
		SET		
				[L_BORRADO]			=	1,
				-- ====================
				[F_BAJA]			=	GETDATE(), 
				[K_USUARIO_BAJA]	=	@PP_K_USUARIO_ACCION
		WHERE	K_USUARIO=@PP_K_USUARIO
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la [USUARIO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Ca.'+CONVERT(VARCHAR(10),@PP_K_USUARIO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_USUARIO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_USUARIO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_USUARIO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_USUARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													@PP_K_USUARIO, 0,'', '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'@PP_K_USUARIO', '', '', '', '', ''

	-- //////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////