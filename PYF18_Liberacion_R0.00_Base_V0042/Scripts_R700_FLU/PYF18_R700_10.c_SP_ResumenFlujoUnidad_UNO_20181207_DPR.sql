-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:		PYF18_Finanzas
-- // MODULO:				RESUMEN FLUJO DIARIO / UNIDAD OPERATIVA
-- // OPERACION:			LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:				HGF
-- // Modificador:			DANIEL PORTILLO ROMERO (Por integración de RNs de Control)
-- // Fecha creación:		18/OCT/2018
-- // Fecha modificación:	07/DIC/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_RESUMEN_FLUJO_DIARIO_X_UNO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_RESUMEN_FLUJO_DIARIO_X_UNO]
GO



CREATE PROCEDURE [dbo].[PG_LI_RESUMEN_FLUJO_DIARIO_X_UNO]
	@PP_L_DEBUG								INT,
	@PP_K_SISTEMA_EXE						INT,
	@PP_K_USUARIO_ACCION					INT,
	-- ===========================	
	@PP_BUSCAR								VARCHAR(255),
	@PP_K_UNIDAD_OPERATIVA					INT,
	@PP_K_ESTATUS_RESUMEN_FLUJO_DIARIO		INT,
	@PP_K_TIPO_UO							INT,
	@PP_K_ZONA_UO							INT,
	@PP_K_RAZON_SOCIAL						INT,
	@PP_F_INICIAL							DATE,
	@PP_F_FINAL								DATE	
AS
	
	DECLARE @PP_C_CUENTA_BANCO			VARCHAR(255) = ''

	DECLARE @VP_MENSAJE					VARCHAR(300)
	DECLARE @VP_L_APLICAR_MAX_ROWS		INT = 1
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_LI_N_REGISTROS		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_LI_N_REGISTROS		OUTPUT		
	-- =========================================		

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	-- =========================================		

	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]		@PP_C_CUENTA_BANCO, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	SELECT	TOP ( @VP_LI_N_REGISTROS )
			[D_TIEMPO_FECHA] AS F_OPERACION_DDMMMYYYY,
			[RESUMEN_FLUJO_DIARIO_X_UNO].*,
			[D_UNIDAD_OPERATIVA], [S_UNIDAD_OPERATIVA],
			[D_ESTATUS_RESUMEN_FLUJO_DIARIO], [S_ESTATUS_RESUMEN_FLUJO_DIARIO],
			[D_ZONA_UO], [S_ZONA_UO],
			[D_TIPO_UO], [S_TIPO_UO],
			[D_RAZON_SOCIAL], [S_RAZON_SOCIAL]
			-- =====================
	FROM	[RESUMEN_FLUJO_DIARIO_X_UNO], 
			[UNIDAD_OPERATIVA], [ESTATUS_RESUMEN_FLUJO_DIARIO],
			[TIPO_UO], [ZONA_UO], [RAZON_SOCIAL],
			[TIEMPO_FECHA]
			-- =====================
	WHERE	[RESUMEN_FLUJO_DIARIO_X_UNO].[K_UNIDAD_OPERATIVA]=[UNIDAD_OPERATIVA].[K_UNIDAD_OPERATIVA]
	AND		[RESUMEN_FLUJO_DIARIO_X_UNO].[K_ESTATUS_RESUMEN_FLUJO_DIARIO]=[ESTATUS_RESUMEN_FLUJO_DIARIO].[K_ESTATUS_RESUMEN_FLUJO_DIARIO]
	AND		[RESUMEN_FLUJO_DIARIO_X_UNO].[F_OPERACION]=[TIEMPO_FECHA].[F_TIEMPO_FECHA]
	AND		[UNIDAD_OPERATIVA].[K_TIPO_UO]=[TIPO_UO].[K_TIPO_UO]
	AND		[UNIDAD_OPERATIVA].[K_ZONA_UO]=[ZONA_UO].[K_ZONA_UO]
	AND		[UNIDAD_OPERATIVA].[K_RAZON_SOCIAL]=[RAZON_SOCIAL].[K_RAZON_SOCIAL]
			-- =====================
	AND		(		D_UNIDAD_OPERATIVA		LIKE '%'+@PP_BUSCAR+'%' 
				OR	D_ZONA_UO				LIKE '%'+@PP_BUSCAR+'%' 
				OR	D_RAZON_SOCIAL			LIKE '%'+@PP_BUSCAR+'%' 
				OR	RESUMEN_FLUJO_DIARIO_X_UNO.K_RESUMEN_FLUJO_DIARIO_X_UNO=@VP_K_FOLIO 		)	
			-- =====================
	AND		( @PP_F_INICIAL IS NULL				OR	@PP_F_INICIAL<=RESUMEN_FLUJO_DIARIO_X_UNO.F_OPERACION )
	AND		( @PP_F_FINAL IS NULL				OR	RESUMEN_FLUJO_DIARIO_X_UNO.F_OPERACION<=@PP_F_FINAL )
			-- =====================
	AND		( @PP_K_UNIDAD_OPERATIVA=-1					OR		RESUMEN_FLUJO_DIARIO_X_UNO.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA )
	AND		( @PP_K_ESTATUS_RESUMEN_FLUJO_DIARIO=-1		OR		RESUMEN_FLUJO_DIARIO_X_UNO.K_ESTATUS_RESUMEN_FLUJO_DIARIO=@PP_K_ESTATUS_RESUMEN_FLUJO_DIARIO )
	AND		( @PP_K_TIPO_UO=-1							OR		UNIDAD_OPERATIVA.K_TIPO_UO=@PP_K_TIPO_UO )
	AND		( @PP_K_ZONA_UO=-1							OR		UNIDAD_OPERATIVA.K_ZONA_UO=@PP_K_ZONA_UO )
	AND		( @PP_K_RAZON_SOCIAL=-1						OR		UNIDAD_OPERATIVA.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL )
--	AND		( @PP_F_OPERACION IS NULL					OR		RESUMEN_FLUJO_DIARIO_X_UNO.F_OPERACION=@PP_F_OPERACION )
--	AND		( @PP_F_OPERACION IS NULL					OR		( YEAR(RESUMEN_FLUJO_DIARIO_X_UNO.F_OPERACION)=YEAR(@PP_F_OPERACION) AND MONTH(RESUMEN_FLUJO_DIARIO_X_UNO.F_OPERACION)=MONTH(@PP_F_OPERACION) ) )
			-- =====================		
	ORDER BY	RESUMEN_FLUJO_DIARIO_X_UNO.F_OPERACION DESC, 
				D_ZONA_UO, D_UNIDAD_OPERATIVA

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_RESUMEN_FLUJO_DIARIO_X_UNO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_C_CUENTA_BANCO, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_CUENTA_BANCO', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO









-- //////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  GENERAR RESUMEN_FLUJO_DIARIO X UNO - INGRESOS
-- //////////////////////////////////////////////////////////////////////////
/*

SELECT * FROM RESUMEN_FLUJO_DIARIO_X_UNO

EXECUTE [PG_IN_RESUMEN_FLUJO_DIARIO_X_UNO]	0,0,0,	'01/OCT/2018', 30
EXECUTE [PG_IN_RESUMEN_FLUJO_DIARIO_X_UNO]	0,0,0,	'02/OCT/2018', 30

*/


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_RESUMEN_FLUJO_DIARIO_X_UNO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_RESUMEN_FLUJO_DIARIO_X_UNO]
GO

CREATE PROCEDURE [dbo].[PG_IN_RESUMEN_FLUJO_DIARIO_X_UNO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_F_OPERACION					DATE,
	@PP_K_UNIDAD_OPERATIVA			INT
	-- =================================
AS			

	DECLARE @VP_MENSAJE							VARCHAR(300) = ''
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_UNIDAD_OPERATIVA, @PP_F_OPERACION,
																	@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////	

	DECLARE @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO	INT = 0

	IF @VP_MENSAJE=''
		EXECUTE	[dbo].[PG_IN_RESUMEN_FLUJO_DIARIO_X_UNO_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_F_OPERACION, @PP_K_UNIDAD_OPERATIVA,
																@OU_K_RESUMEN_FLUJO_DIARIO_X_UNO = @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO		OUTPUT		

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible <Crear> el Resumen Flujo / Unidad Operativa: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#RFL.'+CONVERT(VARCHAR(10),@VP_K_RESUMEN_FLUJO_DIARIO_X_UNO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO AS CLAVE
	
	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_RESUMEN_FLUJO_DIARIO_X_UNO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_RESUMEN_FLUJO_DIARIO_X_UNO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, '', '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO











-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
