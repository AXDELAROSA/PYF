-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / GRAFICA
-- //////////////////////////////////////////////////////////////
/*	

EXECUTE	[dbo].[PG_GR_003_VENTA_PROYECCION] 0,0,0,	   -1, -1, -1,		2017, 2,	1001, 1000

EXECUTE	[dbo].[PG_GR_003_VENTA_PROYECCION] 0,0,0,	   30, -1, -1,		2017, 2,	0, 1000

EXECUTE	[dbo].[PG_GR_003_VENTA_PROYECCION] 0,0,0,	   -1, -1,  3,		2017, 2,	0, 1000

EXECUTE	[dbo].[PG_GR_004_VENTA_CEMEC] 0,0,0,	   -1, 28, -1,		2017, 2,	0, 1000

*/


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_GR_004_VENTA_CEMEC]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_GR_004_VENTA_CEMEC]
GO



CREATE PROCEDURE [dbo].[PG_GR_004_VENTA_CEMEC]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_ZONA_UO				INT,
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	-- ===========================	
	@PP_K_YYYY					INT,
	@PP_K_MES					INT,
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DIVISOR				INT	
	-- ===========================
AS

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
			CONVERT(VARCHAR(100),DOC.K_YYYY)+'/'+
			CONVERT(VARCHAR(100),DOC.K_MM)+'-'+S_DATO_D0M4+'-'+S_UNIDAD_OPERATIVA			
									AS GR_Serie
		--	'ObjetivoVentaKg'			AS GR_Serie
,[D01_VALOR] AS D01
,[D02_VALOR] AS D02
,[D03_VALOR] AS D03
,[D04_VALOR] AS D04
,[D05_VALOR] AS D05
,[D06_VALOR] AS D06
,[D07_VALOR] AS D07
,[D08_VALOR] AS D08
,[D09_VALOR] AS D09
,[D10_VALOR] AS D10
,[D11_VALOR] AS D11
,[D12_VALOR] AS D12
,[D13_VALOR] AS D13
,[D14_VALOR] AS D14
,[D15_VALOR] AS D15
,[D16_VALOR] AS D16
,[D17_VALOR] AS D17
,[D18_VALOR] AS D18
,[D19_VALOR] AS D19
,[D20_VALOR] AS D20
,[D21_VALOR] AS D21
,[D22_VALOR] AS D22
,[D23_VALOR] AS D23
,[D24_VALOR] AS D24
,[D25_VALOR] AS D25
,[D26_VALOR] AS D26
,[D27_VALOR] AS D27
,[D28_VALOR] AS D28
,[D29_VALOR] AS D29
,[D30_VALOR] AS D30
,[D31_VALOR] AS D31

/*			SUM( CONVERT( INT, ( [VENTAS_KG_H0_01] / @PP_K_DIVISOR ) ) )	AS	GR_Hi01,
			SUM( CONVERT( INT, ( [VENTAS_KG_PR_06] / @PP_K_DIVISOR ) ) )	AS	GR_Pr06
			*/
			------------------------------------------
			-- S_UNIDAD_OPERATIVA,		D_UNIDAD_OPERATIVA, 			
			-- S_ZONA_UO,				D_ZONA_UO,
			-- S_REGION,				D_REGION,
			-- S_RAZON_SOCIAL,			D_RAZON_SOCIAL		
			------------------------------------------
	FROM	DOCUMENTO_D0M4 AS DOC, VI_UNIDAD_OPERATIVA_CATALOGOS, 
			DATA_N1_X_DI_D0M4,				
			TIEMPO_MES, FORMATO_D0M4, DATO_D0M4
	WHERE	DOC.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA 	
	AND		DOC.K_FORMATO_D0M4=FORMATO_D0M4.K_FORMATO_D0M4 
	AND		DOC.K_DOCUMENTO_D0M4=DATA_N1_X_DI_D0M4.K_DOCUMENTO_D0M4

	AND		DATA_N1_X_DI_D0M4.K_DATO_D0M4=DATO_D0M4.K_DATO_D0M4

	AND		DOC.K_MM=TIEMPO_MES.K_TIEMPO_MES
	AND		DOC.L_BORRADO=0
	
	AND		DATA_N1_X_DI_D0M4.K_DATO_D0M4 IN  (	1003, 1004 )	-- #1003 VENTA (KG) / CONTADO - #1004 VENTA (KG) / CREDITO

			-- =====================
	AND		( @PP_K_ZONA_UO=-1				OR	@PP_K_ZONA_UO=VI_K_ZONA_UO )
	AND		( @PP_K_RAZON_SOCIAL=-1			OR	@PP_K_RAZON_SOCIAL=VI_K_RAZON_SOCIAL )
	AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR	@PP_K_UNIDAD_OPERATIVA=VI_K_UNIDAD_OPERATIVA )
	AND		( @PP_K_DOCUMENTO_D0M4=0		OR  @PP_K_DOCUMENTO_D0M4=DOC.K_DOCUMENTO_D0M4 )
	AND		( @PP_K_MES=-1					OR  @PP_K_MES=DOC.K_MM )
	AND		( @PP_K_YYYY=-1					OR  @PP_K_YYYY=DOC.K_YYYY )
			-- =====================
--	ORDER BY PERFORMANCE.K_YYYY, PERFORMANCE.K_TEMPORADA

	-- ////////////////////////////////////////////////
GO




--EXECUTE	[dbo].[PG_GR_004_VENTA_CEMEC] 0,0,0,	   -1, -1, -1,		2017, -1,  0, 1
GO


EXECUTE	[dbo].[PG_GR_004_VENTA_CEMEC] 0,0,0,	   -1, -1, -1,		-1, -1,  46, 1






-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
