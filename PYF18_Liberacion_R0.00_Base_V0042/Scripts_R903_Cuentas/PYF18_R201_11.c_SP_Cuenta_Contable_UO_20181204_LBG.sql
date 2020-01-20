-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CUENTA CONTABLE UO
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_CUENTA_CONTABLE_UO_X_UNO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_CUENTA_CONTABLE_UO_X_UNO]
GO


CREATE PROCEDURE [dbo].[PG_LI_CUENTA_CONTABLE_UO_X_UNO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================	
	@PP_K_UNIDAD_OPERATIVA	INT,
	@PP_K_FORMATO_CUENTA	INT,
	@PP_L_PRESUPUESTO		INT	
AS


	DECLARE @VP_MENSAJE				VARCHAR(300)
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT = 1
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_INT_NUMERO_REGISTROS	INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT	
	-- =========================================
		
	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0	
	
	-- =========================================
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================
				
	SELECT	TOP ( @VP_INT_NUMERO_REGISTROS )
			CASE   
				 WHEN K_UNIDAD_OPERATIVA IS NULL THEN 0   
				WHEN K_UNIDAD_OPERATIVA > 0 THEN 1   
			END   AS EXISTE,
			K_UNIDAD_OPERATIVA, D_CUENTA_CONTABLE,K_FORMATO_CUENTA,	
			CUENTA_CONTABLE.*,
			CUENTA_CONTABLE_UO.*,
			VI_UNIDAD_OPERATIVA_CATALOGOS.*,
			D_TIPO_CUENTA_CONTABLE, S_TIPO_CUENTA_CONTABLE,
			D_SAT_AGRUPADOR, S_SAT_AGRUPADOR, CLAVE,
			D_USUARIO AS D_USUARIO_CAMBIO			
			FROM CUENTA_CONTABLE
			LEFT JOIN CUENTA_CONTABLE_UO
			ON CUENTA_CONTABLE.K_CUENTA_CONTABLE = CUENTA_CONTABLE_UO.K_CUENTA_CONTABLE
			AND		CUENTA_CONTABLE_UO.K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA
			AND		K_FORMATO_CUENTA=@PP_K_FORMATO_CUENTA
			LEFT JOIN VI_UNIDAD_OPERATIVA_CATALOGOS 
			ON CUENTA_CONTABLE_UO.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
			LEFT JOIN TIPO_CUENTA_CONTABLE 
			ON CUENTA_CONTABLE.K_TIPO_CUENTA_CONTABLE=TIPO_CUENTA_CONTABLE.K_TIPO_CUENTA_CONTABLE
			LEFT JOIN SAT_AGRUPADOR
			ON CUENTA_CONTABLE.K_SAT_AGRUPADOR=SAT_AGRUPADOR.K_SAT_AGRUPADOR
			LEFT JOIN USUARIO
			ON CUENTA_CONTABLE.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			WHERE	(@PP_L_PRESUPUESTO = 0	OR  L_PRESUPUESTO = @PP_L_PRESUPUESTO)
				
	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_CUENTA_CONTABLE_UO]', -- @PP_STORED_PROCEDURE	[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_USUARIO_ACCION, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_K_USUARIO_ACCION', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

--IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CUENTA_CONTABLE_UO]') AND type in (N'P', N'PC'))
--	DROP PROCEDURE [dbo].[PG_SK_CUENTA_CONTABLE_UO]
--GO


--CREATE PROCEDURE [dbo].[PG_SK_CUENTA_CONTABLE_UO]
--	@PP_L_DEBUG				INT,
--	@PP_K_SISTEMA_EXE		INT,
--	@PP_K_USUARIO_ACCION	INT,
--	-- ===========================
--	@PP_K_CUENTA_CONTABLE_UO				INT
--AS

--	DECLARE @VP_MENSAJE		VARCHAR(300)
	
--	SET		@VP_MENSAJE		= ''
	
--	-- ///////////////////////////////////////////

--	IF @VP_MENSAJE=''
--		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
--													11, -- @PP_K_DATA_SISTEMA,	
--													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
--	-- ///////////////////////////////////////////
	
--	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
--	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
--													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
--	-- ///////////////////////////////////////////

--	DECLARE @VP_INT_NUMERO_REGISTROS	INT =100

--	IF @VP_MENSAJE<>''
--		SET @VP_INT_NUMERO_REGISTROS = 0
	
	
--	SELECT	TOP ( @VP_INT_NUMERO_REGISTROS )
--			CUENTA_CONTABLE_UO.*, 
--			D_USUARIO AS D_USUARIO_CAMBIO		
--			-- =====================
--	FROM	CUENTA_CONTABLE_UO, USUARIO
--			-- =====================
--	WHERE	CUENTA_CONTABLE_UO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
--	AND		CUENTA_CONTABLE_UO.K_CUENTA_CONTABLE_UO=@PP_K_CUENTA_CONTABLE_UO		

--	-----////////////////////////////////////////////////////////////////

--	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
--													-- ===========================================
--													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
--													'SEEK',
--													@VP_MENSAJE,
--													-- ===========================================
--													'[PG_SK_CUENTA_CONTABLE_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
--													@PP_K_CUENTA_CONTABLE_UO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
--													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
--													0, 0, '', '' , 0.00, 0.00,
--													-- === @PP_VALOR_1 al 6_DATO
--													'', '', '', '', '', ''

--	-- ////////////////////////////////////////////////////////////////////
--GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_CUENTA_CONTABLE_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_CUENTA_CONTABLE_UO]
GO


CREATE PROCEDURE [dbo].[PG_IN_CUENTA_CONTABLE_UO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_CUENTA_CONTABLE		INT,	
	@PP_K_UNIDAD_OPERATIVA		INT,	
	@PP_K_FORMATO_CUENTA		INT,
	@PP_O_CUENTA_CONTABLE_UO	INT
AS			

	DECLARE @VP_MENSAJE			VARCHAR(300)
	
	SET		@VP_MENSAJE			= ''

	-- /////////////////////////////////////////////////////////////////////
	IF @PP_L_DEBUG>0
		PRINT '[PG_IN_CUENTA_CONTABLE_UO]'
	DECLARE @VP_K_CUENTA_CONTABLE_UO				INT = 0
	DECLARE @VP_O_CUENTA_CONTABLE_UO				INT = 0

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_CONTABLE_UO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_CUENTA_CONTABLE_UO, @PP_K_UNIDAD_OPERATIVA, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'CUENTA_CONTABLE_UO', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_CUENTA_CONTABLE_UO			OUTPUT

		-- //////////////////////////////////////////////////////////////
		
		INSERT INTO CUENTA_CONTABLE_UO
		(	K_CUENTA_CONTABLE_UO,		K_CUENTA_CONTABLE, 			
			K_UNIDAD_OPERATIVA,			K_FORMATO_CUENTA,
			O_CUENTA_CONTABLE_UO,
			K_USUARIO_CAMBIO,			F_CAMBIO,
			K_USUARIO_ALTA,				F_ALTA,
			L_BORRADO)							
	VALUES		
		(	@VP_K_CUENTA_CONTABLE_UO,	@PP_K_CUENTA_CONTABLE,	
			@PP_K_UNIDAD_OPERATIVA,		@PP_K_FORMATO_CUENTA,
			@PP_O_CUENTA_CONTABLE_UO,
			@PP_K_USUARIO_ACCION,		GETDATE(),
			@PP_K_USUARIO_ACCION,		GETDATE(),
			0		)
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] la Asignación de <Cuenta Contable - Unidad Operativa>: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CUO.'+CONVERT(VARCHAR(10),@VP_K_CUENTA_CONTABLE_UO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_CUENTA_CONTABLE_UO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_CUENTA_CONTABLE_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_CUENTA_CONTABLE_UO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_UNIDAD_OPERATIVA, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_K_UNIDAD_OPERATIVA', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_CUENTA_CONTABLE_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_CUENTA_CONTABLE_UO]
GO

CREATE PROCEDURE [dbo].[PG_UP_CUENTA_CONTABLE_UO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_CUENTA_CONTABLE_UO	INT,
	@PP_K_CUENTA_CONTABLE		INT,	
	@PP_K_UNIDAD_OPERATIVA		INT,	
	@PP_K_FORMATO_CUENTA		INT,
	@PP_O_CUENTA_CONTABLE_UO	INT
AS			
	IF @PP_L_DEBUG>0
		PRINT '[[PG_UP_CUENTA_CONTABLE_UO]]'
	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_CONTABLE_UO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_CUENTA_CONTABLE_UO, @PP_K_UNIDAD_OPERATIVA,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	CUENTA_CONTABLE_UO
		SET		
				[K_CUENTA_CONTABLE]		=	@PP_K_CUENTA_CONTABLE, 
				[K_UNIDAD_OPERATIVA]	=	@PP_K_UNIDAD_OPERATIVA,	
				[K_FORMATO_CUENTA]		=	@PP_K_FORMATO_CUENTA,
				[O_CUENTA_CONTABLE_UO]	=	@PP_O_CUENTA_CONTABLE_UO,			
				-- ===========================
				[K_USUARIO_CAMBIO]		=	@PP_K_USUARIO_ACCION, 
				[F_CAMBIO]				=	GETDATE() 
		WHERE	K_CUENTA_CONTABLE_UO	=	@PP_K_CUENTA_CONTABLE_UO
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible <Actualizar> la Cuenta-Contable: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CCt.'+CONVERT(VARCHAR(10),@PP_K_CUENTA_CONTABLE_UO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_CONTABLE_UO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_CUENTA_CONTABLE_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_CONTABLE_UO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_UNIDAD_OPERATIVA, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_K_UNIDAD_OPERATIVA', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_CUENTA_CONTABLE_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_CUENTA_CONTABLE_UO]
GO


CREATE PROCEDURE [dbo].[PG_DL_CUENTA_CONTABLE_UO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_CUENTA_CONTABLE_UO				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE	=	''

	-- //////////////////////////////////////////////
	IF @PP_L_DEBUG>0
		PRINT '[[[PG_DL_CUENTA_CONTABLE_UO]]]'
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_CONTABLE_UO_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_CUENTA_CONTABLE_UO, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		DELETE FROM	CUENTA_CONTABLE_UO
		WHERE	K_CUENTA_CONTABLE_UO=@PP_K_CUENTA_CONTABLE_UO

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible <Borrar> la Cuenta-Contable: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CCt.'+CONVERT(VARCHAR(10),@PP_K_CUENTA_CONTABLE_UO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_CONTABLE_UO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_CUENTA_CONTABLE_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_CONTABLE_UO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IU_CUENTA_CONTABLE_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IU_CUENTA_CONTABLE_UO]
GO


CREATE PROCEDURE [dbo].[PG_IU_CUENTA_CONTABLE_UO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_CUENTA_CONTABLE_UO	INT,
	@PP_K_CUENTA_CONTABLE		INT,	
	@PP_K_UNIDAD_OPERATIVA		INT,	
	@PP_K_FORMATO_CUENTA		INT,
	@PP_O_CUENTA_CONTABLE_UO	INT,
	@PP_L_GUARDAR				INT
AS

	IF	@PP_L_GUARDAR = 0 AND @PP_K_CUENTA_CONTABLE_UO > 0
		EXECUTE [dbo].[PG_DL_CUENTA_CONTABLE_UO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_CUENTA_CONTABLE_UO					
	IF	@PP_L_GUARDAR = 0 AND @PP_K_CUENTA_CONTABLE_UO = 0
		SELECT	'' AS MENSAJE, 0 AS CLAVE
	-- //////////////////////////////////////////////
	
	IF	@PP_L_GUARDAR = 1 
		BEGIN
			IF @PP_K_CUENTA_CONTABLE_UO = 0
				EXECUTE	[dbo].[PG_IN_CUENTA_CONTABLE_UO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_CUENTA_CONTABLE,	@PP_K_UNIDAD_OPERATIVA,	@PP_K_FORMATO_CUENTA,
															@PP_O_CUENTA_CONTABLE_UO	

			IF @PP_K_CUENTA_CONTABLE_UO = 0
				EXECUTE	[dbo].[PG_UP_CUENTA_CONTABLE_UO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_CUENTA_CONTABLE_UO, @PP_K_CUENTA_CONTABLE, @PP_K_UNIDAD_OPERATIVA,	
															@PP_K_FORMATO_CUENTA, @PP_O_CUENTA_CONTABLE_UO										
		END

	-- /////////////////////////////////////////////////////////////////////
	
	
	-- /////////////////////////////////////////////////////////////////////
GO



-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////

