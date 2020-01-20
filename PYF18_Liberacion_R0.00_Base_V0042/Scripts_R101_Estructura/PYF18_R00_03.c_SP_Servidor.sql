-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION // STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////

--//////////////////////////////////////////////////////////////


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
--											SERVIDOR			
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_SERVIDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_SERVIDOR]
GO

CREATE PROCEDURE [dbo].[PG_LI_SERVIDOR]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	
	@PP_D_SERVIDOR			VARCHAR(255),
	@PP_K_ESTADO_SERVIDOR	INT,
	@PP_K_GRUPO_SERVIDOR	INT,
	@PP_K_ESTATUS_ACTIVO	INT
	-- ===========================
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1

	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE		[dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														1, -- @PP_K_DATA_SISTEMA,	
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		DECLARE @VP_INT_NUMERO_REGISTROS	INT
	
		EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																			@VP_L_APLICAR_MAX_ROWS,		
																			@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
		-- =========================================		

		DECLARE @VP_K_FOLIO		INT

		EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_D_SERVIDOR, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
		-- =========================================

		SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
				SERVIDOR.*,
				D_ESTATUS_ACTIVO, S_ESTATUS_ACTIVO
		FROM	SERVIDOR, ESTATUS_ACTIVO
		WHERE	SERVIDOR.L_SERVIDOR=ESTATUS_ACTIVO.K_ESTATUS_ACTIVO
		AND		L_BORRADO=0
		AND		(	
					D_SERVIDOR		LIKE '%'+@PP_D_SERVIDOR+'%' 
				OR	K_SERVIDOR=@VP_K_FOLIO 
				)	
		AND		( @PP_K_ESTADO_SERVIDOR =-1	OR		SERVIDOR.K_ESTADO_SERVIDOR =@PP_K_ESTADO_SERVIDOR )
		AND		( @PP_K_GRUPO_SERVIDOR  =-1	OR		SERVIDOR.K_GRUPO_SERVIDOR  =@PP_K_GRUPO_SERVIDOR )
		AND		( @PP_K_ESTATUS_ACTIVO=-1	OR		SERVIDOR.L_SERVIDOR=@PP_K_ESTATUS_ACTIVO )
		ORDER BY D_SERVIDOR
		
		END
	ELSE
		BEGIN	-- RESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

		SELECT	SERVIDOR.*,
				D_ESTATUS_ACTIVO, S_ESTATUS_ACTIVO
		FROM	SERVIDOR, ESTATUS_ACTIVO
		WHERE	SERVIDOR.L_SERVIDOR=ESTATUS_ACTIVO.K_ESTATUS_ACTIVO
		AND		SERVIDOR.K_SERVIDOR<0

		END

	-- ////////////////////////////////////////////////

	EXECUTE		[dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														-- ===========================================
														2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
														'SELECT',
														@VP_MENSAJE,
														-- ===========================================
														'[PG_LI_SERVIDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
														0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
														-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
														0, 0, @PP_D_SERVIDOR, 'PYF18_Finanzas_V9999_R0' , 0.00, 0.00,
														-- === @PP_VALOR_1 al 6_DATO
														'', '', '@PP_D_SERVIDOR', '', '', ''

	-- ////////////////////////////////////////////////

GO



-- /////////////////////////////////////////////////////////////
-- //		PG_LI_SERVIDOR_ACTIVO
-- /////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_SERVIDOR_ACTIVO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_SERVIDOR_ACTIVO]
GO

CREATE PROCEDURE [dbo].[PG_LI_SERVIDOR_ACTIVO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT
	-- ===========================
	
	-- ===========================
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1

	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE		[dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														1, -- @PP_K_DATA_SISTEMA,	
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		DECLARE @VP_INT_NUMERO_REGISTROS	INT
	
		EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																			@VP_L_APLICAR_MAX_ROWS,		
																			@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
		-- =========================================

		SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
				SERVIDOR.K_SERVIDOR, SERVIDOR.D_SERVIDOR, @VP_MENSAJE AS MENSAJE
		FROM	SERVIDOR
		WHERE	SERVIDOR.K_ESTADO_SERVIDOR NOT IN (0, 4)
		AND		L_BORRADO=0
		ORDER BY D_SERVIDOR
		
		END
	IF @VP_MENSAJE <> ''
		SELECT @VP_MENSAJE AS MENSAJE
	-- ////////////////////////////////////////////////

	EXECUTE		[dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														-- ===========================================
														2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
														'SELECT',
														@VP_MENSAJE,
														-- ===========================================
														'[PG_LI_SERVIDOR_ACTIVO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
														0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
														-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
														0, 0, 'PYF18_Finanzas_V9999_R0', '' , 0.00, 0.00,
														-- === @PP_VALOR_1 al 6_DATO
														'', '', '@', '', '', ''
	-- //////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_SERVIDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_SERVIDOR]
GO


CREATE PROCEDURE [dbo].[PG_SK_SERVIDOR]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_SERVIDOR			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
												1, -- @PP_K_DATA_SISTEMA,	
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		SELECT	SERVIDOR.*
		FROM	SERVIDOR
		WHERE	L_BORRADO=0
		AND		SERVIDOR.K_SERVIDOR=@PP_K_SERVIDOR
		
		END
	ELSE
		BEGIN	-- RESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

		SELECT	SERVIDOR.*
		FROM	SERVIDOR
		WHERE	SERVIDOR.K_SERVIDOR<0

		END

	-- ////////////////////////////////////////////////

	EXECUTE		[dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														-- ===========================================
														2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
														'SEEK',
														@VP_MENSAJE,
														-- ===========================================
														'[PG_SK_SERVIDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
														@PP_K_SERVIDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
														-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
														0, 0, '', '' , 0.00, 0.00,
														-- === @PP_VALOR_1 al 6_DATO
														'', '', '@', '', '', ''
	-- //////////////////////////////////////////
GO


	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_SERVIDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_SERVIDOR]
GO


CREATE PROCEDURE [dbo].[PG_IN_SERVIDOR]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_D_SERVIDOR			VARCHAR(100),
	@PP_C_SERVIDOR			VARCHAR(500),
	@PP_S_SERVIDOR			VARCHAR(10),
	@PP_O_SERVIDOR			INT,
	@PP_L_SERVIDOR			INT,
	@PP_D_DRIVER			VARCHAR(100),
	@PP_USUARIO				VARCHAR(100),
	@PP_PASSWORD			VARCHAR(100),
	@PP_DOMINIO				VARCHAR(200),
	@PP_K_ESTADO_SERVIDOR	INT,
	@PP_K_GRUPO_SERVIDOR	INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_SERVIDOR	INT = 0
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_SERVIDOR_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@VP_K_SERVIDOR,@PP_D_SERVIDOR, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'SERVIDOR', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_SERVIDOR			OUTPUT

		-- //////////////////////////////////////////////////////////////
		

		INSERT INTO SERVIDOR
			(	[K_SERVIDOR],	[D_SERVIDOR],			[C_SERVIDOR],
				[S_SERVIDOR],	[O_SERVIDOR],			[L_SERVIDOR],
				[D_DRIVER],		[USUARIO],				[PASSWORD],
				[DOMINIO],		[K_ESTADO_SERVIDOR],	[K_GRUPO_SERVIDOR],
				-- ===========================

				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_SERVIDOR,	@PP_D_SERVIDOR,	@PP_C_SERVIDOR,
				@PP_S_SERVIDOR,	@PP_O_SERVIDOR,	@PP_L_SERVIDOR,
				@PP_D_DRIVER,	@PP_USUARIO,	@PP_PASSWORD,
				@PP_DOMINIO,	@PP_K_ESTADO_SERVIDOR,
				@PP_K_GRUPO_SERVIDOR,
				-- ===========================

				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [SERVIDOR]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@VP_K_SERVIDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_SERVIDOR AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_SERVIDOR AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE			[dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															-- ===========================================
															3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
															'INSERT',
															@VP_MENSAJE,
															-- ===========================================
															'[PG_IN_SERVIDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
															@VP_K_SERVIDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
															-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
															0, 0, @PP_D_SERVIDOR, '' , 0.00, 0.00,
															-- === @PP_VALOR_1 al 6_DATO
															'', '', '@PP_D_SERVIDOR', '', '', ''
	-- //////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> ACTUALIZAR / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_SERVIDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_SERVIDOR]
GO

CREATE PROCEDURE [dbo].[PG_UP_SERVIDOR]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_SERVIDOR			INT,
	@PP_D_SERVIDOR			VARCHAR(100),
	@PP_C_SERVIDOR			VARCHAR(500),
	@PP_S_SERVIDOR			VARCHAR(10),
	@PP_O_SERVIDOR			INT,
	@PP_L_SERVIDOR			INT,
	@PP_D_DRIVER			VARCHAR(100),
	@PP_USUARIO				VARCHAR(100),
	@PP_PASSWORD			VARCHAR(100),
	@PP_DOMINIO				VARCHAR(200),
	@PP_K_ESTADO_SERVIDOR	INT,
	@PP_K_GRUPO_SERVIDOR	INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_SERVIDOR_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_SERVIDOR, @PP_D_SERVIDOR,
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	SERVIDOR
		SET		
				
				[D_SERVIDOR]		=	@PP_D_SERVIDOR,
				[C_SERVIDOR]		=	@PP_C_SERVIDOR,
				[S_SERVIDOR]		=	@PP_S_SERVIDOR,
				[O_SERVIDOR]		=	@PP_O_SERVIDOR,
				[L_SERVIDOR]		=	@PP_L_SERVIDOR, 
				[D_DRIVER]			=	@PP_D_DRIVER,
				[USUARIO]			=	@PP_USUARIO,
				[PASSWORD]			=	@PP_PASSWORD,
				[DOMINIO]			=	@PP_DOMINIO,
				[K_ESTADO_SERVIDOR]	=	@PP_K_ESTADO_SERVIDOR,
				[K_GRUPO_SERVIDOR]	=	@PP_K_GRUPO_SERVIDOR,
								
				-- ===========================

				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	K_SERVIDOR=@PP_K_SERVIDOR
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] la [SERVIDOR]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@PP_K_SERVIDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_SERVIDOR AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_SERVIDOR AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE		[dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														-- ===========================================
														3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
														'UPDATE',
														@VP_MENSAJE,
														-- ===========================================
														'[PG_UP_SERVIDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
														@PP_K_SERVIDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
														-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
														0, 0, @PP_D_SERVIDOR, @PP_DOMINIO , 0.00, 0.00,
														-- === @PP_VALOR_1 al 6_DATO
														'', '', '@PP_D_SERVIDOR', '@PP_DOMINIO', '', ''

	-- //////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_SERVIDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_SERVIDOR]
GO


CREATE PROCEDURE [dbo].[PG_DL_SERVIDOR]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_SERVIDOR			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_SERVIDOR_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_SERVIDOR, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	SERVIDOR
		SET		
				[L_BORRADO]		 =	1,
				-- ====================
				[F_BAJA]		 =	GETDATE(), 
				[K_USUARIO_BAJA] =	@PP_K_USUARIO_ACCION
		WHERE	K_SERVIDOR=@PP_K_SERVIDOR
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [SERVIDOR]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@PP_K_SERVIDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_SERVIDOR AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_SERVIDOR AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE		[dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														-- ===========================================
														5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
														'DELETE',
														@VP_MENSAJE,
														-- ===========================================
														'[PG_DL_SERVIDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
														@PP_K_SERVIDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
														-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
														0, 0, '', '' , 0.00, 0.00,
														-- === @PP_VALOR_1 al 6_DATO
														'', '', '', '', '', ''

	-- //////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////