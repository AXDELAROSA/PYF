-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PLAN_GASTO GASTOS / PLANTA
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	25/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////





-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_LI_PARTIDA_PLAN_GASTO]		0,0,0,	'', -1, -1, -1, -1,  0,0



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PARTIDA_PLAN_GASTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PARTIDA_PLAN_GASTO]
GO


CREATE PROCEDURE [dbo].[PG_LI_PARTIDA_PLAN_GASTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_BUSCAR					VARCHAR(200),
	@PP_K_ZONA_UO				INT,
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	-- ==============================
	@PP_K_TIPO_UO					INT,
	@PP_K_YYYY						INT,
	@PP_K_ESCENARIO_PLAN			INT,
	@PP_K_ESTATUS_PLAN_GASTO		INT,
	@PP_K_NIVEL_RUBRO_PRESUPUESTO	INT,
	-- ==============================
	@PP_L_EXCLUIR_CEROS				INT,
	@PP_L_EXCLUIR_ETIQUETAS			INT
AS

	DECLARE @PP_K_REGION			INT = -1

	DECLARE @VP_MENSAJE		VARCHAR(300)
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	IF @PP_L_DEBUG=1
		PRINT @VP_MENSAJE
	
	-- ///////////////////////////////////////////
		
	DECLARE @VP_LI_N_REGISTROS		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															@VP_L_APLICAR_MAX_ROWS,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- =========================================	

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0
	
	-- =========================================		

	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_BUSCAR, 
													@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
		
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	SELECT	TOP ( @VP_LI_N_REGISTROS )
			PLAN_GASTO.K_UNIDAD_OPERATIVA, PLAN_GASTO.K_YYYY,
			PARTIDA_PLAN_GASTO.*, USUARIO.D_USUARIO AS D_USUARIO_CAMBIO,
			RUBRO_PRESUPUESTO.K_NIVEL_RUBRO_PRESUPUESTO, 
			-- ================================= 
			D_ESTATUS_PLAN_GASTO, D_ESCENARIO_PLAN, 
			D_UNIDAD_OPERATIVA, 
			D_TIPO_UO, D_ZONA_UO, D_RAZON_SOCIAL, D_REGION,
			D_RUBRO_PRESUPUESTO, D_PROGRAMACION_PARTIDA,
			-- ================================= 
			S_ESTATUS_PLAN_GASTO, S_ESCENARIO_PLAN, 
			S_UNIDAD_OPERATIVA, 
			S_TIPO_UO, S_ZONA_UO, S_RAZON_SOCIAL, S_REGION,
			S_RUBRO_PRESUPUESTO, S_PROGRAMACION_PARTIDA
			-- ================================= 
	FROM	PLAN_GASTO, 
			ESTATUS_PLAN_GASTO, ESCENARIO_PLAN, 
			VI_UNIDAD_OPERATIVA_CATALOGOS,
			PARTIDA_PLAN_GASTO, 
			RUBRO_PRESUPUESTO, PROGRAMACION_PARTIDA,
			USUARIO
			-- ================================= 
	WHERE	PLAN_GASTO.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
	AND		PLAN_GASTO.K_ESTATUS_PLAN_GASTO=ESTATUS_PLAN_GASTO.K_ESTATUS_PLAN_GASTO
	AND		PLAN_GASTO.K_ESCENARIO_PLAN=ESCENARIO_PLAN.K_ESCENARIO_PLAN
			-- ================================= 
	AND		PARTIDA_PLAN_GASTO.K_PLAN_GASTO=PLAN_GASTO.K_PLAN_GASTO
	AND		PARTIDA_PLAN_GASTO.K_PROGRAMACION_PARTIDA=PROGRAMACION_PARTIDA.K_PROGRAMACION_PARTIDA
	AND		PARTIDA_PLAN_GASTO.K_RUBRO_PRESUPUESTO=RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO
	AND		PARTIDA_PLAN_GASTO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- ================================= 
	AND		(	
				PLAN_GASTO.K_PLAN_GASTO=@VP_K_FOLIO 
			OR	D_RUBRO_PRESUPUESTO			LIKE '%'+@PP_BUSCAR+'%' 
			OR	C_RUBRO_PRESUPUESTO			LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_PLAN_GASTO				LIKE '%'+@PP_BUSCAR+'%' 
			OR	C_PLAN_GASTO				LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_UNIDAD_OPERATIVA			LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_ZONA_UO					LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_RAZON_SOCIAL				LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_REGION					LIKE '%'+@PP_BUSCAR+'%' 
			)
			-- ================================= 
	AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR	@PP_K_UNIDAD_OPERATIVA=VI_K_UNIDAD_OPERATIVA )
	AND		( @PP_K_TIPO_UO=-1				OR	@PP_K_TIPO_UO=VI_K_TIPO_UO )
	AND		( @PP_K_ZONA_UO=-1				OR	@PP_K_ZONA_UO=VI_K_ZONA_UO )
	AND		( @PP_K_RAZON_SOCIAL=-1			OR	@PP_K_RAZON_SOCIAL=VI_K_RAZON_SOCIAL )
	AND		( @PP_K_REGION=-1				OR	@PP_K_REGION=VI_K_REGION )
			-- ================================= 
	AND		( @PP_K_YYYY=-1						OR	@PP_K_YYYY=PLAN_GASTO.K_YYYY )
	AND		( @PP_K_ESTATUS_PLAN_GASTO=-1		OR	@PP_K_ESTATUS_PLAN_GASTO=PLAN_GASTO.K_ESTATUS_PLAN_GASTO )
	AND		( @PP_K_ESCENARIO_PLAN=-1			OR	@PP_K_ESCENARIO_PLAN=PLAN_GASTO.K_ESCENARIO_PLAN )
	AND		( @PP_K_NIVEL_RUBRO_PRESUPUESTO=-1	OR	@PP_K_NIVEL_RUBRO_PRESUPUESTO=RUBRO_PRESUPUESTO.K_NIVEL_RUBRO_PRESUPUESTO )
			-- ================================= 
	AND		( @PP_L_EXCLUIR_CEROS=0				OR	(	PARTIDA_PLAN_GASTO.M00_MONTO_ESTIMADO>0
													OR	RUBRO_PRESUPUESTO.K_NIVEL_RUBRO_PRESUPUESTO=0	)	 )
	AND		( @PP_L_EXCLUIR_ETIQUETAS=0			OR		RUBRO_PRESUPUESTO.K_NIVEL_RUBRO_PRESUPUESTO>0	)
	AND		( PARTIDA_PLAN_GASTO.L_BORRADO=0	OR	@VP_L_VER_BORRADOS=1	)
			-- ==============================
	ORDER BY PARTIDA_PLAN_GASTO.K_PLAN_GASTO, 
			 O_RUBRO_PRESUPUESTO 

	-- //////////////////////////////////////////////////////////////
GO






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_GASTO_DECIMALES_X_K_PLAN_GASTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_GASTO_DECIMALES_X_K_PLAN_GASTO]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_GASTO_DECIMALES_X_K_PLAN_GASTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================			
	@PP_K_PLAN_GASTO			INT
AS

	UPDATE	PARTIDA_PLAN_GASTO
	SET	
			[M00_MONTO_ESTIMADO] = CONVERT(DECIMAL(19,2),[M00_MONTO_ESTIMADO]),
			[M01_MONTO_ESTIMADO] = CONVERT(DECIMAL(19,2),[M01_MONTO_ESTIMADO]),
			[M02_MONTO_ESTIMADO] = CONVERT(DECIMAL(19,2),[M02_MONTO_ESTIMADO]),
			[M03_MONTO_ESTIMADO] = CONVERT(DECIMAL(19,2),[M03_MONTO_ESTIMADO]),
			[M04_MONTO_ESTIMADO] = CONVERT(DECIMAL(19,2),[M04_MONTO_ESTIMADO]),
			[M05_MONTO_ESTIMADO] = CONVERT(DECIMAL(19,2),[M05_MONTO_ESTIMADO]),
			[M06_MONTO_ESTIMADO] = CONVERT(DECIMAL(19,2),[M06_MONTO_ESTIMADO]),
			[M07_MONTO_ESTIMADO] = CONVERT(DECIMAL(19,2),[M07_MONTO_ESTIMADO]),
			[M08_MONTO_ESTIMADO] = CONVERT(DECIMAL(19,2),[M08_MONTO_ESTIMADO]),
			[M09_MONTO_ESTIMADO] = CONVERT(DECIMAL(19,2),[M09_MONTO_ESTIMADO]),
			[M10_MONTO_ESTIMADO] = CONVERT(DECIMAL(19,2),[M10_MONTO_ESTIMADO]),
			[M11_MONTO_ESTIMADO] = CONVERT(DECIMAL(19,2),[M11_MONTO_ESTIMADO]),
			[M12_MONTO_ESTIMADO] = CONVERT(DECIMAL(19,2),[M12_MONTO_ESTIMADO])
	WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO

	-- ==========================================================
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_GASTO_M00_SUMAR_X_K_PLAN_GASTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_GASTO_M00_SUMAR_X_K_PLAN_GASTO]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_GASTO_M00_SUMAR_X_K_PLAN_GASTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================			
	@PP_K_PLAN_GASTO			INT
AS
	
	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_GASTO_DECIMALES_X_K_PLAN_GASTO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_PLAN_GASTO			
	-- ============================================

	UPDATE	PARTIDA_PLAN_GASTO
	SET	
			[M00_MONTO_ESTIMADO] = (	
										[M01_MONTO_ESTIMADO]			
									+	[M02_MONTO_ESTIMADO] 
									+	[M03_MONTO_ESTIMADO] 
									+	[M04_MONTO_ESTIMADO] 
									+	[M05_MONTO_ESTIMADO] 
									+	[M06_MONTO_ESTIMADO] 
									+	[M07_MONTO_ESTIMADO] 
									+	[M08_MONTO_ESTIMADO] 
									+	[M09_MONTO_ESTIMADO] 
									+	[M10_MONTO_ESTIMADO] 
									+	[M11_MONTO_ESTIMADO] 
									+	[M12_MONTO_ESTIMADO]	)
	WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO

	-- ===================================================
GO




-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
