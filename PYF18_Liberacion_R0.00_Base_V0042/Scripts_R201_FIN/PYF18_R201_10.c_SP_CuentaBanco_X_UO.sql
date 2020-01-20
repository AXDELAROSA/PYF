-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			CUENTA_BANCO_UO
-- // OPERACION:		LIBERACION / STORED PROCEDURE
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

-- EXECUTE [PG_LI_CUENTA_BANCO_UO] 0,0,69,'',-1,3



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_CUENTA_BANCO_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_CUENTA_BANCO_UO]
GO


CREATE PROCEDURE [dbo].[PG_LI_CUENTA_BANCO_UO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_BUSCAR					VARCHAR(200),	
	@PP_K_ZONA_UO				INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_TIPO_CUENTA_BANCO		INT
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
	
	DECLARE @VP_INT_NUMERO_REGISTROS	INT
	
	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
	-- =========================================		
	
	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0

	SELECT	TOP  (@VP_INT_NUMERO_REGISTROS)
			CBUO.*,
			-- ================================= 
			CB.D_CUENTA_BANCO,	CB.CLABE, 
			CB.F_APERTURA,		CB.F_CANCELACION, 
			BN.K_BANCO,			BN.D_BANCO,
			-- ================================= 
			D_UNIDAD_OPERATIVA, 
			D_TIPO_UO, D_ZONA_UO, D_RAZON_SOCIAL, D_REGION,
			-- ================================= 
			D_TIPO_CUENTA_BANCO,S_TIPO_CUENTA_BANCO,
			-- =================================
			S_UNIDAD_OPERATIVA, 
			S_TIPO_UO, S_ZONA_UO, S_RAZON_SOCIAL, S_REGION
			-- ================================= 
	FROM	CUENTA_BANCO_UO CBUO, VI_UNIDAD_OPERATIVA_CATALOGOS,
			CUENTA_BANCO CB, BANCO BN, TIPO_CUENTA_BANCO TCB
	WHERE	CBUO.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
	AND		CBUO.K_CUENTA_BANCO=CB.K_CUENTA_BANCO
	AND		CBUO.K_TIPO_CUENTA_BANCO= TCB.K_TIPO_CUENTA_BANCO
	AND		CB.K_BANCO=BN.K_BANCO
	AND		(	CLABE				LIKE '%'+@PP_BUSCAR+'%'  
			OR	D_CUENTA_BANCO		LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_UNIDAD_OPERATIVA	LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_ZONA_UO			LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_BANCO				LIKE '%'+@PP_BUSCAR+'%' 		)
	AND		(	@PP_K_UNIDAD_OPERATIVA=-1	OR	VI_K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA	)  
	AND		(	@PP_K_ZONA_UO=-1			OR	VI_K_ZONA_UO=@PP_K_ZONA_UO )
	AND		(	@PP_K_TIPO_CUENTA_BANCO=-1	OR	CBUO.K_TIPO_CUENTA_BANCO=@PP_K_TIPO_CUENTA_BANCO )
	ORDER BY CBUO.K_UNIDAD_OPERATIVA

	
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
													'[PG_LI_CUENTA_BANCO_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_UNIDAD_OPERATIVA, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '','PYF18_Finanzas_V9999_R0'  , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@', '', '', ''

	-- //////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO CUENTA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_CUENTA_BANCO_UO_CUENTA_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_CUENTA_BANCO_UO_CUENTA_BANCO]
GO

CREATE PROCEDURE [dbo].[PG_LI_CUENTA_BANCO_UO_CUENTA_BANCO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_CUENTA_BANCO			INT
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

		SELECT TOP  (@VP_INT_NUMERO_REGISTROS)
				UO.K_UNIDAD_OPERATIVA,UO.D_UNIDAD_OPERATIVA,ZUO.D_ZONA_UO						
		FROM	CUENTA_BANCO_UO CBUO,  
				UNIDAD_OPERATIVA UO, ZONA_UO ZUO
		WHERE	CBUO.K_UNIDAD_OPERATIVA=UO.K_UNIDAD_OPERATIVA		
		AND		UO.K_ZONA_UO = ZUO.K_ZONA_UO
		AND		(	@PP_K_CUENTA_BANCO=-1	OR	CBUO.K_CUENTA_BANCO=@PP_K_CUENTA_BANCO	)  
		ORDER BY CBUO.K_UNIDAD_OPERATIVA

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
													'[PG_LI_CUENTA_BANCO_UO_CUENTA_BANCO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '','PYF18_Finanzas_V9999_R0'  , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@', '', '', ''

	-- //////////////////////////////////////////

GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_CUENTA_BANCO_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_CUENTA_BANCO_UO]
GO

CREATE PROCEDURE [dbo].[PG_IN_CUENTA_BANCO_UO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_CUENTA_BANCO		INT,
	@PP_K_UNIDAD_OPERATIVA	INT 
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
		
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_BANCO_UO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_CUENTA_BANCO, @PP_K_UNIDAD_OPERATIVA,  
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
			EXECUTE [dbo].[PG_RN_CUENTA_BANCO_UO_EXISTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_CUENTA_BANCO, @PP_K_UNIDAD_OPERATIVA,
															@OU_RESULTADO_VALIDACION =	@VP_MENSAJE		OUTPUT

			IF @VP_MENSAJE = ''  -- si el mensaje es '' no existe registro alguno
			BEGIN
				
				INSERT INTO CUENTA_BANCO_UO
					(	[K_CUENTA_BANCO],
						[K_UNIDAD_OPERATIVA])
				VALUES	
					(	@PP_K_CUENTA_BANCO,
						@PP_K_UNIDAD_OPERATIVA)
					
			END
		END
		
		-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Relacionar] la cuenta de banco con la Planta: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CB.'+CONVERT(VARCHAR(10),@PP_K_CUENTA_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_BANCO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_BANCO AS CLAVE

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
													'[PG_IN_CUENTA_BANCO_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', 'PYF18_Finanzas_V9999_R0' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''
	-- //////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_CUENTA_BANCO_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_CUENTA_BANCO_UO]
GO


CREATE PROCEDURE [dbo].[PG_DL_CUENTA_BANCO_UO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_CUENTA_BANCO		INT,
	@PP_K_UNIDAD_OPERATIVA	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_BANCO_UO_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_CUENTA_BANCO, @PP_K_UNIDAD_OPERATIVA,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		DELETE
		FROM	CUENTA_BANCO_UO
		WHERE	CUENTA_BANCO_UO.K_CUENTA_BANCO=@PP_K_CUENTA_BANCO
		AND		CUENTA_BANCO_UO.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
		END
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la Relacion [Cuenta Banco/Planta]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PL.'+CONVERT(VARCHAR(10),@PP_K_CUENTA_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_BANCO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_BANCO AS CLAVE

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
													'[PG_DL_CUENTA_BANCO_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, 'PYF18_Finanzas_V9999_R0', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- //////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_CUENTA_BANCO_UO_CUENTA_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_CUENTA_BANCO_UO_CUENTA_BANCO]
GO

CREATE PROCEDURE [dbo].[PG_IN_CUENTA_BANCO_UO_CUENTA_BANCO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_CUENTA_BANCO		INT,
	@PP_K_UNIDAD_OPERATIVA	INT 
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
		
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_BANCO_UO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_CUENTA_BANCO, @PP_K_UNIDAD_OPERATIVA,  
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
			EXECUTE [dbo].[PG_RN_CUENTA_BANCO_UO_EXISTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_CUENTA_BANCO, @PP_K_UNIDAD_OPERATIVA,
															@OU_RESULTADO_VALIDACION =	@VP_MENSAJE		OUTPUT

			IF @VP_MENSAJE = ''  -- si el mensaje es '' no existe registro alguno
			BEGIN
				
				INSERT INTO CUENTA_BANCO_UO
					(	[K_CUENTA_BANCO],
						[K_UNIDAD_OPERATIVA])
				VALUES	
					(	@PP_K_CUENTA_BANCO,
						@PP_K_UNIDAD_OPERATIVA)
					
			END
		END
		
		-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Relacionar] la cuenta de banco con la Planta: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CB.'+CONVERT(VARCHAR(10),@PP_K_CUENTA_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_BANCO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_BANCO AS CLAVE

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
													'[PG_IN_CUENTA_BANCO_UO_CUENTA_BANCO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', 'PYF18_Finanzas_V9999_R0' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''
	-- //////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_CUENTA_BANCO_UO_CUENTA_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_CUENTA_BANCO_UO_CUENTA_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_DL_CUENTA_BANCO_UO_CUENTA_BANCO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_CUENTA_BANCO		INT,
	@PP_K_UNIDAD_OPERATIVA	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_BANCO_UO_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_CUENTA_BANCO, @PP_K_UNIDAD_OPERATIVA,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		DELETE
		FROM	CUENTA_BANCO_UO
		WHERE	CUENTA_BANCO_UO.K_CUENTA_BANCO=@PP_K_CUENTA_BANCO
		AND		CUENTA_BANCO_UO.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
		END
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la Relacion [Cuenta Banco/Planta]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PL.'+CONVERT(VARCHAR(10),@PP_K_CUENTA_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_BANCO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_BANCO AS CLAVE

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
													'[PG_DL_CUENTA_BANCO_UO_CUENTA_BANCO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, 'PYF18_Finanzas_V9999_R0', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- //////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
