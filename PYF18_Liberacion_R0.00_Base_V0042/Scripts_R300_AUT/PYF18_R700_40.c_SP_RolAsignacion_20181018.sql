-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			ROL_ASIGNACION
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			ALEX DE LA ROSA // HECTOR A. GONZALEZ 
-- // Fecha creación:	18/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  LISTADO
-- //////////////////////////////////////////////////////////////

-- EXECUTE [PG_LI_ROL_ASIGNACION] 0,0,0, '', -1,-1,-1,-1,-1
	

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_ROL_ASIGNACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_ROL_ASIGNACION]
GO	


CREATE PROCEDURE [dbo].[PG_LI_ROL_ASIGNACION]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_BUSCAR						VARCHAR(100),
	-- ===========================
	@PP_K_RAZON_SOCIAL				INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_ZONA_UO					INT,
	@PP_K_ROL_AUTORIZACION			INT,
	@PP_K_USUARIO					INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)	= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													8, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT		= 1000
	
		EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]           @PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																1, -- WIWI // @VP_L_APLICAR_MAX_ROWS,
																@OU_MAXROWS = @VP_LI_N_REGISTROS		OUTPUT
	-- =========================================	
	
	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_BUSCAR, 
													@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
	
	IF NOT (@VP_MENSAJE='')
		SET @VP_LI_N_REGISTROS = 0

	-- ///////////////////////////////////////////

	SELECT	TOP ( @VP_LI_N_REGISTROS )		
			ROL_ASIGNACION.*, 
			D_RAZON_SOCIAL,S_RAZON_SOCIAL,D_UNIDAD_OPERATIVA, S_UNIDAD_OPERATIVA,
			D_ZONA_UO,S_ZONA_UO,D_ROL_AUTORIZACION,S_ROL_AUTORIZACION,
			USUARIO.D_USUARIO ,USUARIO.S_USUARIO,
			RAU.D_USUARIO AS D_USUARIO_CAMBIO,RAU.S_USUARIO AS S_USUARIO_CAMBIO
	FROM	ROL_ASIGNACION,RAZON_SOCIAL, UNIDAD_OPERATIVA,
			ZONA_UO, ROL_AUTORIZACION, USUARIO, USUARIO AS RAU
	WHERE	ROL_ASIGNACION.L_BORRADO=0
	AND		ROL_ASIGNACION.K_RAZON_SOCIAL = RAZON_SOCIAL.K_RAZON_SOCIAL
	AND		ROL_ASIGNACION.K_UNIDAD_OPERATIVA = UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND		UNIDAD_OPERATIVA.K_ZONA_UO = ZONA_UO.K_ZONA_UO
	AND		ROL_ASIGNACION.K_ROL_AUTORIZACION = ROL_AUTORIZACION.K_ROL_AUTORIZACION
	AND		ROL_ASIGNACION.K_USUARIO=USUARIO.K_USUARIO
	AND		ROL_ASIGNACION.K_USUARIO_CAMBIO = RAU.K_USUARIO
	AND		(	
					RAZON_SOCIAL.D_RAZON_SOCIAL			LIKE '%'+@PP_BUSCAR+'%'
				OR	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA	LIKE '%'+@PP_BUSCAR+'%'
				OR	ZONA_UO.D_ZONA_UO					LIKE '%'+@PP_BUSCAR+'%'
				OR	USUARIO.D_USUARIO					LIKE '%'+@PP_BUSCAR+'%'
				OR	ROL_ASIGNACION.K_ROL_ASIGNACION=@VP_K_FOLIO 
			)
	AND		( @PP_K_RAZON_SOCIAL=-1		OR		ROL_ASIGNACION.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL)	
	AND		( @PP_K_UNIDAD_OPERATIVA=-1	OR		ROL_ASIGNACION.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA)
	AND		( @PP_K_ZONA_UO=-1			OR		UNIDAD_OPERATIVA.K_ZONA_UO=@PP_K_ZONA_UO)
	AND		( @PP_K_ROL_AUTORIZACION=-1	OR		ROL_ASIGNACION.K_ROL_AUTORIZACION=@PP_K_ROL_AUTORIZACION)
	AND		( @PP_K_USUARIO=-1			OR		ROL_ASIGNACION.K_USUARIO=@PP_K_USUARIO)
	ORDER BY ROL_ASIGNACION.K_ROL_ASIGNACION DESC

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SEEK 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_ROL_ASIGNACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_ROL_ASIGNACION]
GO	

CREATE PROCEDURE [dbo].[PG_SK_ROL_ASIGNACION]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_ROL_ASIGNACION		INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)	= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													8, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS	INT = 1000
	
	IF NOT (@VP_MENSAJE='')
		SET @VP_LI_N_REGISTROS = 0

	-- ///////////////////////////////////////////
	
	SELECT	TOP ( @VP_LI_N_REGISTROS )		
			ROL_ASIGNACION.*, 
			D_RAZON_SOCIAL,S_RAZON_SOCIAL,D_UNIDAD_OPERATIVA, S_UNIDAD_OPERATIVA,
			D_ZONA_UO,S_ZONA_UO,D_ROL_AUTORIZACION,S_ROL_AUTORIZACION,
			USUARIO.D_USUARIO,USUARIO.S_USUARIO,
			RAU.D_USUARIO AS D_USUARIO_CAMBIO,RAU.S_USUARIO AS S_USUARIO_CAMBIO
	FROM	ROL_ASIGNACION,RAZON_SOCIAL, UNIDAD_OPERATIVA, ZONA_UO,ROL_AUTORIZACION, USUARIO, USUARIO AS RAU
	WHERE	ROL_ASIGNACION.L_BORRADO=0
	AND		ROL_ASIGNACION.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL
	AND		ROL_ASIGNACION.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND		UNIDAD_OPERATIVA.K_ZONA_UO=ZONA_UO.K_ZONA_UO 
	AND		ROL_ASIGNACION.K_ROL_AUTORIZACION=ROL_AUTORIZACION.K_ROL_AUTORIZACION
	AND		ROL_ASIGNACION.K_USUARIO=USUARIO.K_USUARIO
	AND		ROL_ASIGNACION.K_USUARIO_CAMBIO=RAU.K_USUARIO
	AND		ROL_ASIGNACION.K_ROL_ASIGNACION=@PP_K_ROL_ASIGNACION	 
	
		-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_ROL_ASIGNACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_ROL_ASIGNACION]
GO


CREATE PROCEDURE [dbo].[PG_IN_ROL_ASIGNACION] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================		
	@PP_K_RAZON_SOCIAL				INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_ROL_AUTORIZACION			INT,
	@PP_K_USUARIO					INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)	= ''
	DECLARE @VP_K_ROL_ASIGNACION			INT = 0

	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ROL_ASIGNACION_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_ROL_ASIGNACION,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'ROL_ASIGNACION', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_ROL_ASIGNACION			OUTPUT

	DECLARE @VP_K_ZONA_UO VARCHAR(100) =''

		
	-- /////////////////////////////////////////////////////////////////////

		INSERT INTO ROL_ASIGNACION
			(	
			[K_ROL_ASIGNACION],
			-- =============================
			[K_RAZON_SOCIAL], [K_UNIDAD_OPERATIVA],
			[K_ROL_AUTORIZACION], [K_USUARIO],				
			-- =====================
			[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]
			)
		VALUES
			(
			@VP_K_ROL_ASIGNACION,
			-- ===========================
			@PP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA,
			@PP_K_ROL_AUTORIZACION, @PP_K_USUARIO,
			-- ===========================
			@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL )
		END
	
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [Rol de Asignación]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#RAS.'+CONVERT(VARCHAR(10),@VP_K_ROL_ASIGNACION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_ROL_ASIGNACION AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ROL_ASIGNACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_ROL_ASIGNACION]
GO


CREATE PROCEDURE [dbo].[PG_UP_ROL_ASIGNACION]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================		
	@PP_K_ROL_ASIGNACION			INT,
	-- ===========================
	@PP_K_RAZON_SOCIAL				INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_ROL_AUTORIZACION			INT,
	@PP_K_USUARIO					INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)	= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ROL_ASIGNACION_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_ROL_ASIGNACION, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		UPDATE	ROL_ASIGNACION
		SET		
				[K_ROL_ASIGNACION]			=	@PP_K_ROL_ASIGNACION,	
				-- =====================		-- ========================
				[K_RAZON_SOCIAL]			=	@PP_K_RAZON_SOCIAL,				
				[K_UNIDAD_OPERATIVA]		=	@PP_K_UNIDAD_OPERATIVA,
				[K_ROL_AUTORIZACION]		=	@PP_K_ROL_AUTORIZACION,			
				[K_USUARIO]					=	@PP_K_USUARIO,						
				-- ====================			-- ========================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	K_ROL_ASIGNACION=@PP_K_ROL_ASIGNACION
		AND		L_BORRADO=0
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [Rol de Asignación]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#RAS.'+CONVERT(VARCHAR(10),@PP_K_ROL_ASIGNACION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ROL_ASIGNACION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_ROL_ASIGNACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_ROL_ASIGNACION]
GO


CREATE PROCEDURE [dbo].[PG_DL_ROL_ASIGNACION]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_ROL_ASIGNACION		INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ROL_ASIGNACION_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_ROL_ASIGNACION, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		UPDATE	ROL_ASIGNACION
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_ROL_ASIGNACION=@PP_K_ROL_ASIGNACION
		AND		L_BORRADO=0
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [Rol de Asignación]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#RAS.'+CONVERT(VARCHAR(10),@PP_K_ROL_ASIGNACION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ROL_ASIGNACION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
