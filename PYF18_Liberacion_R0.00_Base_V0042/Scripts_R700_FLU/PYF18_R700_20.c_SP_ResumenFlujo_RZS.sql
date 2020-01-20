-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			RESUMEN FLUJO DIARIO / RAZON SOCIAL
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			HGF
-- // Fecha creación:	18/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_RESUMEN_FLUJO_DIARIO_X_RZS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_RESUMEN_FLUJO_DIARIO_X_RZS]
GO



CREATE PROCEDURE [dbo].[PG_LI_RESUMEN_FLUJO_DIARIO_X_RZS]
	@PP_L_DEBUG								INT,
	@PP_K_SISTEMA_EXE						INT,
	@PP_K_USUARIO_ACCION					INT,
	-- ===========================	
	@PP_BUSCAR								VARCHAR(255),
	@PP_K_ESTATUS_RESUMEN_FLUJO_DIARIO		INT,
	@PP_K_RAZON_SOCIAL						INT,
	@PP_K_ESTATUS_RAZON_SOCIAL				INT,
	@PP_K_REGION							INT,
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
			[RESUMEN_FLUJO_DIARIO_X_RZS].*,
			[D_RAZON_SOCIAL], [S_RAZON_SOCIAL]
			[D_ESTATUS_RESUMEN_FLUJO_DIARIO], [S_ESTATUS_RESUMEN_FLUJO_DIARIO],
			[D_ESTATUS_RAZON_SOCIAL], [S_ESTATUS_RAZON_SOCIAL],
			[D_REGION], [S_REGION]
			-- =====================
	FROM	[RESUMEN_FLUJO_DIARIO_X_RZS], 
			[ESTATUS_RESUMEN_FLUJO_DIARIO], [TIEMPO_FECHA],
			[RAZON_SOCIAL], 
			[REGION], [ESTATUS_RAZON_SOCIAL]
			-- =====================
	WHERE	[RESUMEN_FLUJO_DIARIO_X_RZS].[K_ESTATUS_RESUMEN_FLUJO_DIARIO]=[ESTATUS_RESUMEN_FLUJO_DIARIO].[K_ESTATUS_RESUMEN_FLUJO_DIARIO]
	AND		[RESUMEN_FLUJO_DIARIO_X_RZS].[F_OPERACION]=[TIEMPO_FECHA].[F_TIEMPO_FECHA]
	AND		[RESUMEN_FLUJO_DIARIO_X_RZS].[K_RAZON_SOCIAL]=[RAZON_SOCIAL].[K_RAZON_SOCIAL]
	AND		[RAZON_SOCIAL].[K_REGION]=[REGION].[K_REGION]
	AND		[RAZON_SOCIAL].[K_ESTATUS_RAZON_SOCIAL]=[ESTATUS_RAZON_SOCIAL].[K_ESTATUS_RAZON_SOCIAL]
			-- =====================
	AND		(		D_RAZON_SOCIAL		LIKE '%'+@PP_BUSCAR+'%' 
				OR	D_REGION			LIKE '%'+@PP_BUSCAR+'%' 
				OR	[RESUMEN_FLUJO_DIARIO_X_RZS].K_RESUMEN_FLUJO_DIARIO_X_RZS=@VP_K_FOLIO 		)	
			-- =====================
	AND		( @PP_F_INICIAL IS NULL				OR	@PP_F_INICIAL<=RESUMEN_FLUJO_DIARIO_X_RZS.F_OPERACION )
	AND		( @PP_F_FINAL IS NULL				OR	RESUMEN_FLUJO_DIARIO_X_RZS.F_OPERACION<=@PP_F_FINAL )
			-- =====================
	AND		( @PP_K_ESTATUS_RESUMEN_FLUJO_DIARIO=-1		OR		RESUMEN_FLUJO_DIARIO_X_RZS.K_ESTATUS_RESUMEN_FLUJO_DIARIO=@PP_K_ESTATUS_RESUMEN_FLUJO_DIARIO )
	AND		( @PP_K_RAZON_SOCIAL=-1						OR		RESUMEN_FLUJO_DIARIO_X_RZS.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL )
	AND		( @PP_K_ESTATUS_RAZON_SOCIAL=-1				OR		RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL=@PP_K_ESTATUS_RAZON_SOCIAL )
	AND		( @PP_K_REGION=-1							OR		RAZON_SOCIAL.K_REGION=@PP_K_REGION )
--	AND		( @PP_F_OPERACION IS NULL					OR		RESUMEN_FLUJO_DIARIO_X_RZS.F_OPERACION=@PP_F_OPERACION )
--	AND		( @PP_F_OPERACION IS NULL					OR		( YEAR(RESUMEN_FLUJO_DIARIO_X_RZS.F_OPERACION)=YEAR(@PP_F_OPERACION) AND MONTH(RESUMEN_FLUJO_DIARIO_X_RZS.F_OPERACION)=MONTH(@PP_F_OPERACION) ) )
			-- =====================		
	ORDER BY [RESUMEN_FLUJO_DIARIO_X_RZS].[F_OPERACION] DESC, D_RAZON_SOCIAL

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_RESUMEN_FLUJO_DIARIO_X_RZS]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_C_CUENTA_BANCO, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_CUENTA_BANCO', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
