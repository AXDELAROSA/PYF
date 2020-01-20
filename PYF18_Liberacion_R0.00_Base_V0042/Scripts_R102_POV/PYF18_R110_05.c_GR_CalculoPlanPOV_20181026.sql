-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PERFORMANCE OPERATIVO
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////







-- //////////////////////////////////////////////////////////////
-- // DIVISOR
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIVISOR]') AND type in (N'U'))
	DROP TABLE [dbo].[DIVISOR]
GO


CREATE TABLE [dbo].[DIVISOR] (
	[K_DIVISOR]	[INT] NOT NULL,
	[D_DIVISOR]	[VARCHAR] (100) NOT NULL,
	[S_DIVISOR]	[VARCHAR] (10) NOT NULL,
	[O_DIVISOR]	[INT] NOT NULL,
	[C_DIVISOR]	[VARCHAR] (255) NOT NULL,
	[L_DIVISOR]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[DIVISOR]
	ADD CONSTRAINT [PK_DIVISOR]
		PRIMARY KEY CLUSTERED ([K_DIVISOR])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_DIVISOR_01_DESCRIPCION] 
	   ON [dbo].[DIVISOR] ( [D_DIVISOR] )
GO


ALTER TABLE [dbo].[DIVISOR] ADD 
	CONSTRAINT [FK_DIVISOR_01] 
		FOREIGN KEY ( [L_DIVISOR] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_DIVISOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_DIVISOR]
GO


CREATE PROCEDURE [dbo].[PG_CI_DIVISOR]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	-- ========================================
	@PP_K_DIVISOR		INT,
	@PP_D_DIVISOR		VARCHAR(100),
	@PP_S_DIVISOR		VARCHAR(10),
	@PP_O_DIVISOR		INT,
	@PP_C_DIVISOR		VARCHAR(255),
	@PP_L_DIVISOR		INT
AS
	
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_DIVISOR
							FROM	DIVISOR
							WHERE	K_DIVISOR=@PP_K_DIVISOR

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO DIVISOR	
			(	K_DIVISOR,				D_DIVISOR, 
				S_DIVISOR,				O_DIVISOR,
				C_DIVISOR,
				L_DIVISOR				)		
		VALUES	
			(	@PP_K_DIVISOR,			@PP_D_DIVISOR,	
				@PP_S_DIVISOR,			@PP_O_DIVISOR,
				@PP_C_DIVISOR,
				@PP_L_DIVISOR			)
	ELSE
		UPDATE	DIVISOR
		SET		D_DIVISOR	= @PP_D_DIVISOR,	
				S_DIVISOR	= @PP_S_DIVISOR,			
				O_DIVISOR	= @PP_O_DIVISOR,
				C_DIVISOR	= @PP_C_DIVISOR,
				L_DIVISOR	= @PP_L_DIVISOR	
		WHERE	K_DIVISOR=@PP_K_DIVISOR

	-- =========================================================
GO

-- //////////////////////////////////////////////////////////////

-- SELECT * FROM DIVISOR


-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_DIVISOR] 0, 0,       1, 'UNIDAD',		'1',    1, '', 1
EXECUTE [dbo].[PG_CI_DIVISOR] 0, 0,    1000, 'MILES',		'1x3',  0, '', 1
EXECUTE [dbo].[PG_CI_DIVISOR] 0, 0, 1000000, 'MILLONES',	'1x6',  3, '', 1
GO
-- ===============================================
SET NOCOUNT OFF
-- ===============================================



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / GRAFICA
-- //////////////////////////////////////////////////////////////
/*	

EXECUTE	[dbo].[PG_GR_001_VENTA_ANUAL] 0,0,0,	    30, -1, -1,		2010, 2018,    1000

EXECUTE	[dbo].[PG_GR_001_VENTA_ANUAL] 0,0,0,		-1, -1,  3,		2010, 2018,    1000

EXECUTE	[dbo].[PG_GR_001_VENTA_ANUAL] 0,0,0,		-1, 28, -1,		2010, 2018,    1000

*/


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_GR_001_VENTA_ANUAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_GR_001_VENTA_ANUAL]
GO



CREATE PROCEDURE [dbo].[PG_GR_001_VENTA_ANUAL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_ZONA_UO				INT,
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	-- ===========================	
	@PP_K_YYYY_INICIO			INT,
	@PP_K_YYYY_FIN				INT,
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
-- // STORED PROCEDURE ---> SELECT / GRAFICA
-- //////////////////////////////////////////////////////////////
/*	

EXECUTE	[dbo].[PG_GR_002_VENTA_X_TEMPORADA] 0,0,0,	    30, -1, -1,		2010, 2018, -1,   1000

EXECUTE	[dbo].[PG_GR_002_VENTA_X_TEMPORADA] 0,0,0,		-1, -1,  3,		2010, 2018, -1,   1000

EXECUTE	[dbo].[PG_GR_002_VENTA_X_TEMPORADA] 0,0,0,		-1, 28, -1,		2010, 2018, -1,   1000

*/



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_GR_002_VENTA_X_TEMPORADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_GR_002_VENTA_X_TEMPORADA]
GO



CREATE PROCEDURE [dbo].[PG_GR_002_VENTA_X_TEMPORADA]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_ZONA_UO				INT,
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	-- ===========================	
	@PP_K_YYYY_INICIO			INT,
	@PP_K_YYYY_FIN				INT,
	@PP_K_TEMPORADA				INT,	
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
			CONVERT(VARCHAR(100),PERFORMANCE.K_YYYY)+'/'+S_TEMPORADA			
												AS	GR_Tiempo,
			PERFORMANCE.K_YYYY, PERFORMANCE.K_TEMPORADA,
			------------------------------------------
			-- S_UNIDAD_OPERATIVA,		D_UNIDAD_OPERATIVA, 			
			-- S_ZONA_UO,				D_ZONA_UO,
			-- S_REGION,				D_REGION,
			-- S_RAZON_SOCIAL,			D_RAZON_SOCIAL		
			------------------------------------------
			SUM ( CONVERT( INT, ( V02_VALOR / @PP_K_DIVISOR ) )	)
												AS	GR_VentaKG,
			SUM ( CONVERT( INT, ( (V02_VALOR / @PP_K_DIVISOR) * 0.540 ) ) )	
												AS	GR_VentaLT
			------------------------------------------
	FROM	PERFORMANCE_N3_X_TEMP AS PERFORMANCE, TEMPORADA, 				
			VI_UNIDAD_OPERATIVA_CATALOGOS			
	WHERE	PERFORMANCE.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
	AND		PERFORMANCE.K_TEMPORADA=TEMPORADA.K_TEMPORADA
			-- =====================
	AND		( @PP_K_ZONA_UO=-1				OR	@PP_K_ZONA_UO=VI_K_ZONA_UO )
	AND		( @PP_K_RAZON_SOCIAL=-1			OR	@PP_K_RAZON_SOCIAL=VI_K_RAZON_SOCIAL )
	AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR	@PP_K_UNIDAD_OPERATIVA=VI_K_UNIDAD_OPERATIVA )
			-- =====================
	AND		( @PP_K_TEMPORADA=-1			OR	@PP_K_TEMPORADA=PERFORMANCE.K_TEMPORADA )
	AND		( @VP_K_METRICA=-1				OR	@VP_K_METRICA=PERFORMANCE.K_METRICA )
	AND		(	@PP_K_YYYY_INICIO<=PERFORMANCE.K_YYYY
					AND
				PERFORMANCE.K_YYYY<=@PP_K_YYYY_FIN		)
	GROUP BY	CONVERT(VARCHAR(100),PERFORMANCE.K_YYYY)+'/'+S_TEMPORADA,
				PERFORMANCE.K_YYYY, PERFORMANCE.K_TEMPORADA			
	ORDER BY PERFORMANCE.K_YYYY, PERFORMANCE.K_TEMPORADA

	-- ////////////////////////////////////////////////
GO






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / GRAFICA
-- //////////////////////////////////////////////////////////////
/*	

EXECUTE	[dbo].[PG_GR_003_VENTA_PROYECCION] 0,0,0,	   -1, -1, -1,		2017, 2,	1001, 1000

EXECUTE	[dbo].[PG_GR_003_VENTA_PROYECCION] 0,0,0,	   30, -1, -1,		2017, 2,	0, 1000

EXECUTE	[dbo].[PG_GR_003_VENTA_PROYECCION] 0,0,0,	   -1, -1,  3,		2017, 2,	0, 1000

EXECUTE	[dbo].[PG_GR_003_VENTA_PROYECCION] 0,0,0,	   -1, 28, -1,		2017, 2,	0, 1000

*/


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_GR_003_VENTA_PROYECCION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_GR_003_VENTA_PROYECCION]
GO



CREATE PROCEDURE [dbo].[PG_GR_003_VENTA_PROYECCION]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_ZONA_UO				INT,
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	-- ===========================	
	@PP_K_YYYY					INT,
	@PP_K_TEMPORADA				INT,
	@PP_K_PLAN_POV				INT,
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
			'ObjetivoVentaKg'			AS GR_Serie,
			SUM( CONVERT( INT, ( [VENTAS_KG_H0_01] / @PP_K_DIVISOR ) ) )	AS	GR_Hi01,
			SUM( CONVERT( INT, ( [VENTAS_KG_H0_02] / @PP_K_DIVISOR ) ) )	AS	GR_Hi02,
			SUM( CONVERT( INT, ( [VENTAS_KG_H0_03] / @PP_K_DIVISOR ) ) )	AS	GR_Hi03,
			SUM( CONVERT( INT, ( [VENTAS_KG_H0_04] / @PP_K_DIVISOR ) ) )	AS	GR_Hi04,
			SUM( CONVERT( INT, ( [VENTAS_KG_H0_05] / @PP_K_DIVISOR ) ) )	AS	GR_Hi05,
			SUM( CONVERT( INT, ( [VENTAS_KG_H0_06] / @PP_K_DIVISOR ) ) )	AS	GR_Hi06,
			SUM( CONVERT( INT, ( [VENTAS_KG_H1_01] / @PP_K_DIVISOR ) ) )	AS	GR_Hi07,
			SUM( CONVERT( INT, ( [VENTAS_KG_H1_02] / @PP_K_DIVISOR ) ) )	AS	GR_Hi08,
			SUM( CONVERT( INT, ( [VENTAS_KG_H1_03] / @PP_K_DIVISOR ) ) )	AS	GR_Hi09,
			SUM( CONVERT( INT, ( [VENTAS_KG_H1_04] / @PP_K_DIVISOR ) ) )	AS	GR_Hi10,
			SUM( CONVERT( INT, ( [VENTAS_KG_H1_05] / @PP_K_DIVISOR ) ) )	AS	GR_Hi11,
			SUM( CONVERT( INT, ( [VENTAS_KG_H1_06] / @PP_K_DIVISOR ) ) )	AS	GR_Hi12,
			SUM( CONVERT( INT, ( [VENTAS_KG_PR_01] / @PP_K_DIVISOR ) ) )	AS	GR_Pr01,
			SUM( CONVERT( INT, ( [VENTAS_KG_PR_02] / @PP_K_DIVISOR ) ) )	AS	GR_Pr02,
			SUM( CONVERT( INT, ( [VENTAS_KG_PR_03] / @PP_K_DIVISOR ) ) )	AS	GR_Pr03,
			SUM( CONVERT( INT, ( [VENTAS_KG_PR_04] / @PP_K_DIVISOR ) ) )	AS	GR_Pr04,
			SUM( CONVERT( INT, ( [VENTAS_KG_PR_05] / @PP_K_DIVISOR ) ) )	AS	GR_Pr05,
			SUM( CONVERT( INT, ( [VENTAS_KG_PR_06] / @PP_K_DIVISOR ) ) )	AS	GR_Pr06
			------------------------------------------
			-- S_UNIDAD_OPERATIVA,		D_UNIDAD_OPERATIVA, 			
			-- S_ZONA_UO,				D_ZONA_UO,
			-- S_REGION,				D_REGION,
			-- S_RAZON_SOCIAL,			D_RAZON_SOCIAL		
			------------------------------------------
	FROM	PLAN_POV AS POV, TEMPORADA, 				
			VI_UNIDAD_OPERATIVA_CATALOGOS			
	WHERE	POV.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
	AND		POV.K_TEMPORADA=TEMPORADA.K_TEMPORADA
			-- =====================
	AND		( @PP_K_ZONA_UO=-1				OR	@PP_K_ZONA_UO=VI_K_ZONA_UO )
	AND		( @PP_K_RAZON_SOCIAL=-1			OR	@PP_K_RAZON_SOCIAL=VI_K_RAZON_SOCIAL )
	AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR	@PP_K_UNIDAD_OPERATIVA=VI_K_UNIDAD_OPERATIVA )
	AND		( @PP_K_PLAN_POV=0				OR  @PP_K_PLAN_POV=POV.K_PLAN_POV )
			-- =====================
	AND		POV.K_YYYY=@PP_K_YYYY					
	AND		POV.K_TEMPORADA=@PP_K_TEMPORADA				
			-- =====================
--	ORDER BY PERFORMANCE.K_YYYY, PERFORMANCE.K_TEMPORADA

	-- ////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
