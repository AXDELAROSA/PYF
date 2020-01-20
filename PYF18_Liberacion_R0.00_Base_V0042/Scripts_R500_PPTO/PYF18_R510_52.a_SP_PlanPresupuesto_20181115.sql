-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PLAN_PRESUPUESTO GASTOS/PLANTA
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	15/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


/*

EXECUTE [dbo].[PG_LI_PLAN_PRESUPUESTO]	0,0,0,	'',	-1,-1,-1,	-1,-1,-1

*/


-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PLAN_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PLAN_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_LI_PLAN_PRESUPUESTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_BUSCAR					VARCHAR(200),
	-- ==============================
	@PP_K_ZONA_UO				INT,
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	-- ==============================
	@PP_K_YYYY						INT,
	@PP_K_TEMPORADA					INT,
	@PP_K_ESTATUS_PLAN_PRESUPUESTO	INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT = 1
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS	INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_LI_N_REGISTROS		OUTPUT	
	-- =========================================		

	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]		@PP_BUSCAR, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	-- =========================================
		
	SELECT	TOP (@VP_LI_N_REGISTROS)
			PLAN_PRESUPUESTO.*,
			USUARIO.D_USUARIO AS D_USUARIO_CAMBIO,			
			-- ================================= 
			D_UNIDAD_OPERATIVA, 
			D_TIPO_UO, D_ZONA_UO, D_RAZON_SOCIAL, D_REGION,
			D_ESTATUS_PLAN_PRESUPUESTO, D_TEMPORADA, 
			-- ================================= 
			S_UNIDAD_OPERATIVA, 
			S_TIPO_UO, S_ZONA_UO, S_RAZON_SOCIAL, S_REGION,
			S_ESTATUS_PLAN_PRESUPUESTO, S_TEMPORADA, 
			-- ================================= 
			USR_P1.D_USUARIO AS USR_P1_D_USUARIO, USR_P1.S_USUARIO AS USR_P1_S_USUARIO,
			USR_P2.D_USUARIO AS USR_P2_D_USUARIO, USR_P2.S_USUARIO AS USR_P2_S_USUARIO,
			USR_P3.D_USUARIO AS USR_P3_D_USUARIO, USR_P3.S_USUARIO AS USR_P3_S_USUARIO,
			USR_P4.D_USUARIO AS USR_P4_D_USUARIO, USR_P4.S_USUARIO AS USR_P4_S_USUARIO,
			USR_P5.D_USUARIO AS USR_P5_D_USUARIO, USR_P5.S_USUARIO AS USR_P5_S_USUARIO
			-- ================================= 
	FROM	PLAN_PRESUPUESTO
			-- =========================================
			LEFT JOIN USUARIO AS USR_P1 ON PLAN_PRESUPUESTO.K_USUARIO_PASO_1=USR_P1.K_USUARIO
			LEFT JOIN USUARIO AS USR_P2 ON PLAN_PRESUPUESTO.K_USUARIO_PASO_2=USR_P2.K_USUARIO
			LEFT JOIN USUARIO AS USR_P3 ON PLAN_PRESUPUESTO.K_USUARIO_PASO_3=USR_P3.K_USUARIO
			LEFT JOIN USUARIO AS USR_P4 ON PLAN_PRESUPUESTO.K_USUARIO_PASO_4=USR_P4.K_USUARIO
			LEFT JOIN USUARIO AS USR_P5 ON PLAN_PRESUPUESTO.K_USUARIO_PASO_5=USR_P5.K_USUARIO,
			-- =========================================
			VI_UNIDAD_OPERATIVA_CATALOGOS,
			ESTATUS_PLAN_PRESUPUESTO, TEMPORADA, 
			USUARIO
			-- ================================= 
	WHERE	PLAN_PRESUPUESTO.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
	AND		PLAN_PRESUPUESTO.K_ESTATUS_PLAN_PRESUPUESTO=ESTATUS_PLAN_PRESUPUESTO.K_ESTATUS_PLAN_PRESUPUESTO
	AND		PLAN_PRESUPUESTO.K_TEMPORADA=TEMPORADA.K_TEMPORADA
	AND		PLAN_PRESUPUESTO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- ================================= 
	AND		(	
				D_PLAN_PRESUPUESTO		LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_ZONA_UO				LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_RAZON_SOCIAL			LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_UNIDAD_OPERATIVA		LIKE '%'+@PP_BUSCAR+'%' 
			OR	PLAN_PRESUPUESTO.K_PLAN_PRESUPUESTO=@VP_K_FOLIO			)
			-- ================================= 
	AND		( @PP_K_ZONA_UO=-1				OR	@PP_K_ZONA_UO=VI_K_ZONA_UO )
	AND		( @PP_K_RAZON_SOCIAL=-1			OR	@PP_K_RAZON_SOCIAL=VI_K_RAZON_SOCIAL )
	AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR	@PP_K_UNIDAD_OPERATIVA=VI_K_UNIDAD_OPERATIVA )
	-- ==============================
	AND		( @PP_K_YYYY=-1							OR	@PP_K_YYYY=PLAN_PRESUPUESTO.K_YYYY )
	AND		( @PP_K_TEMPORADA=-1					OR	@PP_K_TEMPORADA=PLAN_PRESUPUESTO.K_TEMPORADA )
	AND		( @PP_K_ESTATUS_PLAN_PRESUPUESTO=-1		OR	@PP_K_ESTATUS_PLAN_PRESUPUESTO=PLAN_PRESUPUESTO.K_ESTATUS_PLAN_PRESUPUESTO )
	-- ==============================
	ORDER BY PLAN_PRESUPUESTO.K_YYYY DESC, S_ZONA_UO, D_RAZON_SOCIAL, D_UNIDAD_OPERATIVA
	
	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_PLAN_PRESUPUESTO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_BUSCAR, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_BUSCAR', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO





-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PLAN_PRESUPUESTO_L_RECALCULAR_SET_1]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PLAN_PRESUPUESTO_L_RECALCULAR_SET_1]
GO


CREATE PROCEDURE [dbo].[PG_UP_PLAN_PRESUPUESTO_L_RECALCULAR_SET_1]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_PLAN_PRESUPUESTO		INT
AS

	UPDATE	[PLAN_PRESUPUESTO]
	SET		L_RECALCULAR = 1	
	WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO

	-- //////////////////////////////////////////////////////////////
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PLAN_PRESUPUESTO_L_RECALCULAR_RESET_0]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PLAN_PRESUPUESTO_L_RECALCULAR_RESET_0]
GO


CREATE PROCEDURE [dbo].[PG_UP_PLAN_PRESUPUESTO_L_RECALCULAR_RESET_0]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_PLAN_PRESUPUESTO			INT
AS

	UPDATE	[PLAN_PRESUPUESTO]
	SET		L_RECALCULAR = 0	
	WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO

	-- //////////////////////////////////////////////////////////////
GO




-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
