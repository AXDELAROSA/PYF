-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			GRAFICA LIQUIDACION
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR GONZALEZ DE LA FUENTE
-- // Fecha creaci�n:	01/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_GR_005a_VENTA_SERIE_ANUAL_X_MESES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_GR_005a_VENTA_SERIE_ANUAL_X_MESES]
GO



CREATE PROCEDURE [dbo].[PG_GR_005a_VENTA_SERIE_ANUAL_X_MESES]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_YYYY					INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_METRICA				INT,
	@PP_K_DIVISOR				INT	
AS
	
	SELECT	PERFORMANCE_N3_X_ME.XLS_UNIDAD_OPERATIVA,
			M01_VALOR GR_Ene, M02_VALOR GR_Feb, M03_VALOR GR_Mar,
			M04_VALOR GR_Abr, M05_VALOR GR_May, M06_VALOR GR_Jun,
			M07_VALOR GR_Jul, M08_VALOR GR_Ago, M09_VALOR GR_Sep,
			M10_VALOR GR_Oct, M11_VALOR GR_Nov, M12_VALOR GR_Dic
	FROM	PERFORMANCE_N3_X_ME
	WHERE	L_BORRADO=0
	AND		PERFORMANCE_N3_X_ME.K_YYYY=@PP_K_YYYY 
	AND     PERFORMANCE_N3_X_ME.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
	AND     PERFORMANCE_N3_X_ME.K_METRICA=@PP_K_METRICA

	-- ////////////////////////////////////////////////
GO
		




		
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / GRAFICA
-- //////////////////////////////////////////////////////////////
/*	

EXECUTE	[dbo].[PG_GR_001_VENTA_ANUAL] 0,0,0,	    30, -1, -1,		2010, 2018,    1000

EXECUTE	[dbo].[PG_GR_001_VENTA_ANUAL] 0,0,0,		-1, -1,  3,		2010, 2018,    1000

EXECUTE	[dbo].[PG_GR_001_VENTA_ANUAL] 0,0,0,		-1, 28, -1,		2010, 2018,    1000

*/


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_GR_005b_VENTA_SERIE_ANUAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_GR_005b_VENTA_SERIE_ANUAL]
GO



CREATE PROCEDURE [dbo].[PG_GR_005b_VENTA_SERIE_ANUAL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_METRICA				INT,
	@PP_K_DIVISOR				INT	
	-- ===========================
AS

	DECLARE @PP_K_ZONA_UO		INT = -1
	DECLARE @PP_K_RAZON_SOCIAL	INT = -1

	-- ===========================	

	DECLARE @PP_K_YYYY_INICIO			INT = 2007
	DECLARE @PP_K_YYYY_FIN				INT = 2017


	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1

	SET		@VP_MENSAJE		= ''
	
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

	DECLARE @VP_K_METRICA				INT = 1

	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0

	-- =========================================		
	
	SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
			PERFORMANCE.K_YYYY					AS	GR_Tiempo,
			------------------------------------------
			-- S_UNIDAD_OPERATIVA,		D_UNIDAD_OPERATIVA, 			
			-- S_ZONA_UO,				D_ZONA_UO,
			-- S_REGION,				D_REGION,
			-- S_RAZON_SOCIAL,			D_RAZON_SOCIAL		
			------------------------------------------
			SUM ( CONVERT( INT, ( PERFORMANCE.VALOR_ACUMULADO / @PP_K_DIVISOR ) ) )	
												AS	GR_VentaKG,
			SUM ( CONVERT( INT, ( (PERFORMANCE.VALOR_ACUMULADO / @PP_K_DIVISOR) * 0.540 ) )	)
												AS	GR_VentaLT
			------------------------------------------
	FROM	PERFORMANCE_N3_X_ME AS PERFORMANCE, 	
			VI_UNIDAD_OPERATIVA_CATALOGOS			
	WHERE	PERFORMANCE.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
			-- =====================
	AND		( @PP_K_ZONA_UO=-1				OR	@PP_K_ZONA_UO=VI_K_ZONA_UO )
	AND		( @PP_K_RAZON_SOCIAL=-1			OR	@PP_K_RAZON_SOCIAL=VI_K_RAZON_SOCIAL )
	AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR	@PP_K_UNIDAD_OPERATIVA=VI_K_UNIDAD_OPERATIVA )
			-- =====================
	AND		( @VP_K_METRICA=-1				OR	@VP_K_METRICA=PERFORMANCE.K_METRICA )
	AND		(	@PP_K_YYYY_INICIO<=PERFORMANCE.K_YYYY
					AND
				PERFORMANCE.K_YYYY<=@PP_K_YYYY_FIN		)
	GROUP BY PERFORMANCE.K_YYYY
	ORDER BY PERFORMANCE.K_YYYY

	-- ////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////