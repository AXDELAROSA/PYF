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
--											ESTADO_SERVIDOR			
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_ESTADO_SERVIDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_ESTADO_SERVIDOR]
GO


CREATE PROCEDURE [dbo].[PG_LI_ESTADO_SERVIDOR]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_D_ESTADO_SERVIDOR	VARCHAR(255),
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

		EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_D_ESTADO_SERVIDOR, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
		-- =========================================

		SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
				ESTADO_SERVIDOR.*,
				D_ESTATUS_ACTIVO, S_ESTATUS_ACTIVO
		FROM	ESTADO_SERVIDOR, ESTATUS_ACTIVO
		WHERE	ESTADO_SERVIDOR.L_ESTADO_SERVIDOR=ESTATUS_ACTIVO.K_ESTATUS_ACTIVO
		AND		L_BORRADO=0
		AND		(	
					D_ESTADO_SERVIDOR		LIKE '%'+@PP_D_ESTADO_SERVIDOR+'%' 
				OR	K_ESTADO_SERVIDOR=@VP_K_FOLIO 
				)	
		AND		( @PP_K_ESTATUS_ACTIVO=-1	OR		ESTADO_SERVIDOR.L_ESTADO_SERVIDOR=@PP_K_ESTATUS_ACTIVO )
		ORDER BY D_ESTADO_SERVIDOR
				
		END
	ELSE
		BEGIN	-- RESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

		SELECT	ESTADO_SERVIDOR.*,
				D_ESTATUS_ACTIVO, S_ESTATUS_ACTIVO
		FROM	ESTADO_SERVIDOR, ESTATUS_ACTIVO
		WHERE	ESTADO_SERVIDOR.L_ESTADO_SERVIDOR=ESTATUS_ACTIVO.K_ESTATUS_ACTIVO
		AND		ESTADO_SERVIDOR.K_ESTADO_SERVIDOR<0

		END

	-- ////////////////////////////////////////////////

	EXECUTE		[dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														-- ===========================================
														2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
														'SELECT',
														@VP_MENSAJE,
														-- ===========================================
														'[PG_LI_ESTADO_SERVIDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
														0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
														-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
														0, 0, @PP_D_ESTADO_SERVIDOR, 'PYF18_Finanzas_V9999_R0' , 0.00, 0.00,
														-- === @PP_VALOR_1 al 6_DATO
														'', '', '@PP_D_ESTADO_SERVIDOR', '', '', ''

	-- //////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_ESTADO_SERVIDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_ESTADO_SERVIDOR]
GO

CREATE PROCEDURE [dbo].[PG_SK_ESTADO_SERVIDOR]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_ESTADO_SERVIDOR	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE			[dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
															1, -- @PP_K_DATA_SISTEMA,	
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		SELECT	ESTADO_SERVIDOR.*
		FROM	ESTADO_SERVIDOR
		WHERE	L_BORRADO=0
		AND		ESTADO_SERVIDOR.K_ESTADO_SERVIDOR=@PP_K_ESTADO_SERVIDOR
		
		END
	ELSE
		BEGIN	-- RESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

		SELECT	ESTADO_SERVIDOR.*
		FROM	ESTADO_SERVIDOR
		WHERE	ESTADO_SERVIDOR.K_ESTADO_SERVIDOR<0

		END

	-- //////////////////////////////////////////

	EXECUTE		[dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														-- ===========================================
														2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
														'SEEK',
														@VP_MENSAJE,
														-- ===========================================
														'[PG_SK_ESTADO_SERVIDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
														@PP_K_ESTADO_SERVIDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
														-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
														0, 0, '', 'PYF18_Finanzas_V9999_R0' , 0.00, 0.00,
														-- === @PP_VALOR_1 al 6_DATO
														'', '', '@', '', '', ''
	-- //////////////////////////////////////////
GO


	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_ESTADO_SERVIDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_ESTADO_SERVIDOR]
GO


CREATE PROCEDURE [dbo].[PG_IN_ESTADO_SERVIDOR]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_D_ESTADO_SERVIDOR	VARCHAR(100),
	@PP_C_ESTADO_SERVIDOR	VARCHAR(500),
	@PP_S_ESTADO_SERVIDOR	VARCHAR(10),
	@PP_O_ESTADO_SERVIDOR	INT,
	@PP_L_ESTADO_SERVIDOR	INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_ESTADO_SERVIDOR	INT = 0
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ESTADO_SERVIDOR_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_ESTADO_SERVIDOR, @PP_D_ESTADO_SERVIDOR,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
														'ESTADO_SERVIDOR', 
														@OU_K_TABLA_DISPONIBLE = @VP_K_ESTADO_SERVIDOR			OUTPUT

		-- //////////////////////////////////////////////////////////////
		

		INSERT INTO ESTADO_SERVIDOR
			(	[K_ESTADO_SERVIDOR],	[D_ESTADO_SERVIDOR],
				[C_ESTADO_SERVIDOR],	[S_ESTADO_SERVIDOR], 
				[O_ESTADO_SERVIDOR],	[L_ESTADO_SERVIDOR],
				-- ===========================

				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_ESTADO_SERVIDOR,	@PP_D_ESTADO_SERVIDOR,
				@PP_C_ESTADO_SERVIDOR,	@PP_S_ESTADO_SERVIDOR,
				@PP_O_ESTADO_SERVIDOR,	@PP_L_ESTADO_SERVIDOR,
				-- ===========================

				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [ESTADO_SERVIDOR]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@VP_K_ESTADO_SERVIDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_ESTADO_SERVIDOR AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_ESTADO_SERVIDOR AS CLAVE

	-- //////////////////////////////////////////

	EXECUTE		[dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														-- ===========================================
														3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
														'INSERT',
														@VP_MENSAJE,
														-- ===========================================
														'[PG_IN_ESTADO_SERVIDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
														@VP_K_ESTADO_SERVIDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
														-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
														0, 0, @PP_D_ESTADO_SERVIDOR, 'PYF18_Finanzas_V9999_R0' , 0.00, 0.00,
														-- === @PP_VALOR_1 al 6_DATO
														'', '', '@PP_D_ESTADO_SERVIDOR', '', '', ''
	-- //////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> ACTUALIZAR / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ESTADO_SERVIDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_ESTADO_SERVIDOR]
GO

CREATE PROCEDURE [dbo].[PG_UP_ESTADO_SERVIDOR]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_ESTADO_SERVIDOR	INT,
	@PP_D_ESTADO_SERVIDOR	VARCHAR(100),
	@PP_C_ESTADO_SERVIDOR	VARCHAR(500),
	@PP_S_ESTADO_SERVIDOR	VARCHAR(100),
	@PP_O_ESTADO_SERVIDOR	INT,
	@PP_L_ESTADO_SERVIDOR	INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ESTADO_SERVIDOR_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_ESTADO_SERVIDOR, @PP_D_ESTADO_SERVIDOR,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	ESTADO_SERVIDOR
		SET		
				
				[D_ESTADO_SERVIDOR] =	@PP_D_ESTADO_SERVIDOR,
				[C_ESTADO_SERVIDOR] =	@PP_C_ESTADO_SERVIDOR, 
				[S_ESTADO_SERVIDOR] =	@PP_S_ESTADO_SERVIDOR,
				[O_ESTADO_SERVIDOR] =	@PP_O_ESTADO_SERVIDOR,
				[L_ESTADO_SERVIDOR] =	@PP_L_ESTADO_SERVIDOR,
				-- ===========================

				-- ====================
				[F_CAMBIO]			=	GETDATE(), 
				[K_USUARIO_CAMBIO]	=	@PP_K_USUARIO_ACCION
		WHERE	K_ESTADO_SERVIDOR=@PP_K_ESTADO_SERVIDOR
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [ESTADO_SERVIDOR]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@PP_K_ESTADO_SERVIDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ESTADO_SERVIDOR AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ESTADO_SERVIDOR AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE		[dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														-- ===========================================
														3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
														'UPDATE',
														@VP_MENSAJE,
														-- ===========================================
														'[PG_UP_ESTADO_SERVIDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
														@PP_K_ESTADO_SERVIDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
														-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
														0, 0, @PP_D_ESTADO_SERVIDOR, 'PYF18_Finanzas_V9999_R0' , 0.00, 0.00,
														-- === @PP_VALOR_1 al 6_DATO
														'', '', '@PP_D_ESTADO_SERVIDOR', '', '', ''

	-- //////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_ESTADO_SERVIDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_ESTADO_SERVIDOR]
GO


CREATE PROCEDURE [dbo].[PG_DL_ESTADO_SERVIDOR]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_ESTADO_SERVIDOR	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ESTADO_SERVIDOR_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_ESTADO_SERVIDOR, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	ESTADO_SERVIDOR
		SET		
				[L_BORRADO]		 =	1,
				-- ====================
				[F_BAJA]		 =	GETDATE(), 
				[K_USUARIO_BAJA] =	@PP_K_USUARIO_ACCION
		WHERE	K_ESTADO_SERVIDOR=@PP_K_ESTADO_SERVIDOR
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [ESTADO_SERVIDOR]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@PP_K_ESTADO_SERVIDOR)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ESTADO_SERVIDOR AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ESTADO_SERVIDOR AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE		[dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														-- ===========================================
														5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
														'DELETE',
														@VP_MENSAJE,
														-- ===========================================
														'[PG_DL_ESTADO_SERVIDOR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
														@PP_K_ESTADO_SERVIDOR, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
														-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
														0, 0, '', 'PYF18_Finanzas_V9999_R0' , 0.00, 0.00,
														-- === @PP_VALOR_1 al 6_DATO
														'', '', '', '', '', ''

	-- //////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
