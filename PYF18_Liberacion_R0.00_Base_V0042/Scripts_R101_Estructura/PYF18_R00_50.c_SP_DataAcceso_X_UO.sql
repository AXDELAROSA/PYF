-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			DATA_ACCESO_UO
-- // OPERACION:		LIBERACION // STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			Alex de la Rosa
-- // Fecha creación:	04/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO UO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_DATA_ACCESO_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_DATA_ACCESO_UO]
GO

CREATE PROCEDURE [dbo].[PG_LI_DATA_ACCESO_UO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_UNIDAD_OPERATIVA		INT
	-- ===========================
AS

	DECLARE @VP_MENSAJE					VARCHAR(300)
	DECLARE @VP_L_APLICAR_MAX_ROWS		INT = 1
	
	SET		@VP_MENSAJE					= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
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
		
		SELECT	TOP ( @VP_INT_NUMERO_REGISTROS )
				DATA_ACCESO_UO.*,
				USUARIO.D_USUARIO, USUARIO.CORREO, 
				-- ========================
				D_UNIDAD_OPERATIVA, 
				D_TIPO_UO, D_ZONA_UO, D_RAZON_SOCIAL, D_REGION,
				S_UNIDAD_OPERATIVA, 
				S_TIPO_UO, S_ZONA_UO, S_RAZON_SOCIAL, S_REGION
				-- ================================= 
		FROM	DATA_ACCESO_UO, VI_UNIDAD_OPERATIVA_CATALOGOS,
				USUARIO
				-- ================================= 
		WHERE	DATA_ACCESO_UO.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
		AND		DATA_ACCESO_UO.K_USUARIO=USUARIO.K_USUARIO
		AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR	VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA	) 
		ORDER BY DATA_ACCESO_UO.K_UNIDAD_OPERATIVA

		END
	
	-- ///////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],
															--2	BAJA		SELECT / SEEK
															--3 MODERADA	INSERT / UPDATE
															--5 MUY ALTA	DELETE
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_DATA_ACCESO_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_UNIDAD_OPERATIVA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '','PYF18_Finanzas_V9999_R0'  , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@', '', '', ''

	-- //////////////////////////////////////////

GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO USUARIO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_DATA_ACCESO_UO_USUARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_DATA_ACCESO_UO_USUARIO]
GO


CREATE PROCEDURE [dbo].[PG_LI_DATA_ACCESO_UO_USUARIO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_USUARIO				INT
	-- ===========================
AS

	DECLARE @VP_MENSAJE					VARCHAR(300)
	DECLARE @VP_L_APLICAR_MAX_ROWS		INT = 1
	
	SET		@VP_MENSAJE					= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
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

		SELECT	TOP ( @VP_INT_NUMERO_REGISTROS )
				DATA_ACCESO_UO.*,
				USUARIO.D_USUARIO, USUARIO.CORREO, 
				-- ========================
				D_UNIDAD_OPERATIVA, 
				D_TIPO_UO, D_ZONA_UO, D_RAZON_SOCIAL, D_REGION,
				S_UNIDAD_OPERATIVA, 
				S_TIPO_UO, S_ZONA_UO, S_RAZON_SOCIAL, S_REGION
		FROM	DATA_ACCESO_UO, VI_UNIDAD_OPERATIVA_CATALOGOS,
				USUARIO
		WHERE	DATA_ACCESO_UO.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
		AND		DATA_ACCESO_UO.K_USUARIO=USUARIO.K_USUARIO
				-- ================================= 
		AND		(	@PP_K_USUARIO=-1			OR	USUARIO.K_USUARIO=@PP_K_USUARIO	) 
		ORDER BY USUARIO.K_USUARIO
		
		END
		
	-- ///////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],
															--2	BAJA		SELECT / SEEK
															--3 MODERADA	INSERT / UPDATE
															--5 MUY ALTA	DELETE
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_DATA_ACCESO_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_USUARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '','PYF18_Finanzas_V9999_R0'  , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@', '', '', ''

	-- //////////////////////////////////////////

GO


-- ///////////////////////////////////////////
-- // STORED PROCEDURE ---> LI_MASIVO
-- ///////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_DATA_ACCESO_UO_MASIVO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_DATA_ACCESO_UO_MASIVO]
GO


CREATE PROCEDURE [dbo].[PG_LI_DATA_ACCESO_UO_MASIVO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================	
	@PP_D_USUARIO			VARCHAR(255),
	@PP_K_ZONA_UO			INT,
	@PP_K_UNIDAD_OPERATIVA	INT,
	@PP_K_USUARIO			INT
	-- ===========================
AS

	DECLARE @VP_L_APLICAR_MAX_ROWS		INT = 1
	DECLARE @VP_INT_NUMERO_REGISTROS	INT
	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- ///////////////////////////////////////////		

	
		EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																			@VP_L_APLICAR_MAX_ROWS,		
																			@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
		-- =========================================	
		
		-- ///////////////////////////////////////////

	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_D_USUARIO, 
													@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT

	-- ///////////////////////////////////////////	

	SELECT	TOP ( @VP_INT_NUMERO_REGISTROS )
			USUARIO.K_USUARIO,  
			USUARIO.D_USUARIO, USUARIO.CORREO, 
			VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA AS K_UNIDAD_OPERATIVA,
			-- ========================
			D_UNIDAD_OPERATIVA, 
			D_TIPO_UO, D_ZONA_UO, D_RAZON_SOCIAL, D_REGION,
			S_UNIDAD_OPERATIVA, 
			S_TIPO_UO, S_ZONA_UO, S_RAZON_SOCIAL, S_REGION
	FROM	DATA_ACCESO_UO, USUARIO,
			VI_UNIDAD_OPERATIVA_CATALOGOS
	WHERE	DATA_ACCESO_UO.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
	AND		DATA_ACCESO_UO.K_USUARIO=USUARIO.K_USUARIO
			-- ================================= 
	AND		(	D_UNIDAD_OPERATIVA		LIKE '%'+@PP_D_USUARIO+ '%' 
			OR	D_ZONA_UO				LIKE '%'+@PP_D_USUARIO+ '%'  
			OR	D_USUARIO				LIKE '%'+@PP_D_USUARIO+ '%' 
			OR	CORREO					LIKE '%'+@PP_D_USUARIO+ '%'		)
	AND		(	@PP_K_USUARIO=-1			OR	USUARIO.K_USUARIO=@PP_K_USUARIO	) 
	AND		(	@PP_K_UNIDAD_OPERATIVA=-1	OR	VI_K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA	)
	AND		(	@PP_K_ZONA_UO=-1			OR	VI_K_ZONA_UO=@PP_K_ZONA_UO	) 
	ORDER BY USUARIO.K_USUARIO
					
	-- ////////////////////////////////////////////

	EXECUTE [PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											-- ===========================================
											2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
											'SELECT',
											@VP_MENSAJE,
											-- ===========================================
											'[PG_LI_DATA_ACCESO_UO_MASIVO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
											@PP_K_UNIDAD_OPERATIVA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
											-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
											0, 0, @PP_D_USUARIO,'PYF18_Planeacion_V0036_R0'  , 0.00, 0.00,
											-- === @PP_VALOR_1 al 6_DATO
											'', '', '@PP_D_USUARIO', '', '', ''

	-- //////////////////////////////////////////

GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_DATA_ACCESO_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_DATA_ACCESO_UO]
GO

CREATE PROCEDURE [dbo].[PG_IN_DATA_ACCESO_UO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_USUARIO			INT,
	@PP_K_UNIDAD_OPERATIVA	INT 
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
		
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_USUARIO, @PP_K_UNIDAD_OPERATIVA,  
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
			EXECUTE [dbo].[PG_RN_DATA_ACCESO_UO_EXISTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_USUARIO, @PP_K_UNIDAD_OPERATIVA,
														@OU_RESULTADO_VALIDACION =	@VP_MENSAJE		OUTPUT

			IF @VP_MENSAJE = ''  -- si el mensaje es '' no existe registro alguno
			BEGIN
				
				INSERT INTO DATA_ACCESO_UO
					(	[K_USUARIO],
						[K_UNIDAD_OPERATIVA])
				VALUES	
					(	@PP_K_USUARIO,
						@PP_K_UNIDAD_OPERATIVA)
					
			END
		END
		
		-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [Acceso/UO]: ' + @VP_MENSAJE 
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
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],
															--2	BAJA		SELECT / SEEK
															--3 MODERADA	INSERT / UPDATE
															--5 MUY ALTA	DELETE
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_DATA_ACCESO_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_USUARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', 'PYF18_Finanzas_V9999_R0' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''
	-- //////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_DATA_ACCESO_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_DATA_ACCESO_UO]
GO


CREATE PROCEDURE [dbo].[PG_DL_DATA_ACCESO_UO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_USUARIO			INT,
	@PP_K_UNIDAD_OPERATIVA	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UO_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_USUARIO, @PP_K_UNIDAD_OPERATIVA,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		DELETE
		FROM	DATA_ACCESO_UO
		WHERE	DATA_ACCESO_UO.K_USUARIO=@PP_K_USUARIO
		AND		DATA_ACCESO_UO.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
		END
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la [Acceso/UO]: ' + @VP_MENSAJE 
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
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],
															--2	BAJA		SELECT / SEEK
															--3 MODERADA	INSERT / UPDATE
															--5 MUY ALTA	DELETE
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_DATA_ACCESO_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_USUARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, 'PYF18_Finanzas_V9999_R0', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- //////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_DATA_ACCESO_UO_USUARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_DATA_ACCESO_UO_USUARIO]
GO


CREATE PROCEDURE [dbo].[PG_DL_DATA_ACCESO_UO_USUARIO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_USUARIO			INT,
	@PP_K_UNIDAD_OPERATIVA	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UO_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_USUARIO, @PP_K_UNIDAD_OPERATIVA,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		DELETE
		FROM	DATA_ACCESO_UO
		WHERE	DATA_ACCESO_UO.K_USUARIO=@PP_K_USUARIO
		AND		DATA_ACCESO_UO.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
		END
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la [Acceso/UO]: ' + @VP_MENSAJE 
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
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],
															--2	BAJA		SELECT / SEEK
															--3 MODERADA	INSERT / UPDATE
															--5 MUY ALTA	DELETE
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_DATA_ACCESO_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_USUARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, 'PYF18_Finanzas_V9999_R0', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- //////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_DATA_ACCESO_UO_USUARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_DATA_ACCESO_UO_USUARIO]
GO

CREATE PROCEDURE [dbo].[PG_IN_DATA_ACCESO_UO_USUARIO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_USUARIO			INT,
	@PP_K_UNIDAD_OPERATIVA	INT 
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
		
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_USUARIO, @PP_K_UNIDAD_OPERATIVA,  
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
			EXECUTE [dbo].[PG_RN_DATA_ACCESO_UO_EXISTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_USUARIO, @PP_K_UNIDAD_OPERATIVA,
														@OU_RESULTADO_VALIDACION =	@VP_MENSAJE		OUTPUT

			IF @VP_MENSAJE = ''  -- si el mensaje es '' no existe registro alguno
			BEGIN
				
				INSERT INTO DATA_ACCESO_UO
					(	[K_USUARIO],
						[K_UNIDAD_OPERATIVA])
				VALUES	
					(	@PP_K_USUARIO,
						@PP_K_UNIDAD_OPERATIVA)
					
			END
		END
		
		-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Asociar] la [Unidad Operativa]: ' + @VP_MENSAJE 
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
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],
															--2	BAJA		SELECT / SEEK
															--3 MODERADA	INSERT / UPDATE
															--5 MUY ALTA	DELETE
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_DATA_ACCESO_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_USUARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', 'PYF18_Finanzas_V9999_R0' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''
	-- //////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
