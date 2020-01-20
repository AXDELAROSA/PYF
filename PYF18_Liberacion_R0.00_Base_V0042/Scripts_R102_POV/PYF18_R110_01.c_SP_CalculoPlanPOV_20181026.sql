-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CALCULOS
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PLAN_POV]') AND type in (N'P', N'PC'))
	DROP PROCEDURE	[dbo].[PG_LI_PLAN_POV]
GO


CREATE PROCEDURE [dbo].[PG_LI_PLAN_POV]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================		
	@PP_BUSCAR							VARCHAR(200),
	-- ===========================
	@PP_K_ZONA_UO						INT,
	@PP_K_RAZON_SOCIAL					INT,
	@PP_K_UNIDAD_OPERATIVA				INT,
	-- ===========================
	@PP_K_YYYY							INT,
	@PP_K_TEMPORADA						INT,
	@PP_K_ESTATUS_CALCULO				INT,
	@PP_K_DIVISOR						INT
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

	IF @VP_MENSAJE=''
		BEGIN
	
		DECLARE @VP_INT_NUMERO_REGISTROS	INT
	
		EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																			@VP_L_APLICAR_MAX_ROWS,		
																			@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
		-- =========================================		

		DECLARE @VP_K_FOLIO		INT

		EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_BUSCAR, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
		-- =========================================

		IF @VP_MENSAJE<>''
			SET @VP_INT_NUMERO_REGISTROS=0

		SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
				PLAN_POV.*, 
				PLAN_POV.CRECIMIENTO_MERCADO*100 CRECIMIENTO_MERCADO_0_100,
				PLAN_POV.INCREMENTO_PARTICIPACION*100 INCREMENTO_PARTICIPACION_0_100,	
				-- ========================
				CONVERT( INT, ( [VENTAS_KG_H0] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_H0,
				CONVERT( INT, ( [VENTAS_KG_H1] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_H1,
				CONVERT( INT, ( [VENTAS_KG_PR] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_PR,
				-- ========================
				CONVERT( INT, ( [VENTAS_KG_H0_01] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_H0_01,
				CONVERT( INT, ( [VENTAS_KG_H0_02] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_H0_02,
				CONVERT( INT, ( [VENTAS_KG_H0_03] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_H0_03,
				CONVERT( INT, ( [VENTAS_KG_H0_04] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_H0_04,
				CONVERT( INT, ( [VENTAS_KG_H0_05] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_H0_05,
				CONVERT( INT, ( [VENTAS_KG_H0_06] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_H0_06,
				-- ========================
				CONVERT( INT, ( [VENTAS_KG_H1_01] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_H1_01,
				CONVERT( INT, ( [VENTAS_KG_H1_02] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_H1_02,
				CONVERT( INT, ( [VENTAS_KG_H1_03] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_H1_03,
				CONVERT( INT, ( [VENTAS_KG_H1_04] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_H1_04,
				CONVERT( INT, ( [VENTAS_KG_H1_05] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_H1_05,
				CONVERT( INT, ( [VENTAS_KG_H1_06] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_H1_06,
				-- ========================
				CONVERT( INT, ( [VENTAS_KG_PR_01] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_PR_01,
				CONVERT( INT, ( [VENTAS_KG_PR_02] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_PR_02,
				CONVERT( INT, ( [VENTAS_KG_PR_03] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_PR_03,
				CONVERT( INT, ( [VENTAS_KG_PR_04] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_PR_04,
				CONVERT( INT, ( [VENTAS_KG_PR_05] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_PR_05,
				CONVERT( INT, ( [VENTAS_KG_PR_06] / @PP_K_DIVISOR ) ) AS DIV_VENTAS_KG_PR_06,
				-- =========================		
				D_TEMPORADA,			S_TEMPORADA,
				D_ZONA_UO,				S_ZONA_UO,
				D_RAZON_SOCIAL,			S_RAZON_SOCIAL,			
				D_UNIDAD_OPERATIVA,		S_UNIDAD_OPERATIVA,
				D_ESTATUS_ACTIVO,		S_ESTATUS_ACTIVO,
				-- =========================		
				VI_K_ZONA_UO		AS K_ZONA_UO,	
				VI_K_RAZON_SOCIAL	AS K_RAZON_SOCIAL,
				-- =========================		
				USUARIO.D_USUARIO	AS 'D_USUARIO_CAMBIO'
		FROM	PLAN_POV, VI_UNIDAD_OPERATIVA_CATALOGOS,
				TEMPORADA, ESTATUS_ACTIVO, USUARIO
		WHERE	PLAN_POV.K_USUARIO_CAMBIO=USUARIO.K_USUARIO 
		AND		PLAN_POV.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA 
		AND		PLAN_POV.K_ESTATUS_CALCULO=ESTATUS_ACTIVO.K_ESTATUS_ACTIVO 
		AND		PLAN_POV.K_TEMPORADA=TEMPORADA.K_TEMPORADA
		AND		PLAN_POV.L_BORRADO=0
		AND		(	D_UNIDAD_OPERATIVA	LIKE '%'+@PP_BUSCAR+'%' 
					OR	K_PLAN_POV=@VP_K_FOLIO	)	
		AND		(	@PP_K_ZONA_UO=-1			OR  VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_ZONA_UO=@PP_K_ZONA_UO	)			
		AND		(	@PP_K_RAZON_SOCIAL=-1		OR  VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL	)			
		AND		(	@PP_K_UNIDAD_OPERATIVA=-1	OR  PLAN_POV.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA	)	
		AND		(	@PP_K_ESTATUS_CALCULO=-1	OR  PLAN_POV.K_ESTATUS_CALCULO=@PP_K_ESTATUS_CALCULO	)		
		AND		(	@PP_K_YYYY=-1				OR  PLAN_POV.K_YYYY=@PP_K_YYYY	)	
		AND		(	@PP_K_TEMPORADA=-1			OR  PLAN_POV.K_TEMPORADA=@PP_K_TEMPORADA	)
		ORDER BY O_PLAN_POV
						
		END	

	-- ////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PLAN_POV_VENTAS_KG_H0]') AND type in (N'P', N'PC'))
	DROP PROCEDURE	[dbo].[PG_UP_PLAN_POV_VENTAS_KG_H0]
GO


CREATE PROCEDURE [dbo].[PG_UP_PLAN_POV_VENTAS_KG_H0]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================	
	@PP_K_PLAN_POV					INT
AS

	DECLARE @VP_K_YYYY				INT
	DECLARE @VP_K_TEMPORADA			INT
	DECLARE @VP_K_UNIDAD_OPERATIVA	INT
				
	SELECT	@VP_K_YYYY =				K_YYYY,
			@VP_K_TEMPORADA =			K_TEMPORADA,
			@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA		
										FROM	PLAN_POV
										WHERE	K_PLAN_POV=@PP_K_PLAN_POV
	-- ==============================

	IF @VP_K_TEMPORADA=1	-- VERANO
		UPDATE	PLAN_POV
		SET		[VENTAS_KG_H0_01] = (	SELECT	SUM(M04_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=(@VP_K_YYYY-1)
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H0_02] = (	SELECT	SUM(M05_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=(@VP_K_YYYY-1)
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H0_03] = (	SELECT	SUM(M06_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=(@VP_K_YYYY-1)
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H0_04] = (	SELECT	SUM(M07_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=(@VP_K_YYYY-1)
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H0_05] = (	SELECT	SUM(M09_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=(@VP_K_YYYY-1)
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H0_06] = (	SELECT	SUM(M06_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=(@VP_K_YYYY-1)
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	)
		WHERE	K_PLAN_POV=@PP_K_PLAN_POV
	
	-- =====================================

	IF @VP_K_TEMPORADA=2	-- INVIERNO
		UPDATE	PLAN_POV
		SET		[VENTAS_KG_H0_01] = (	SELECT	SUM(M10_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=(@VP_K_YYYY-1)
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H0_02] = (	SELECT	SUM(M11_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=(@VP_K_YYYY-1)
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H0_03] = (	SELECT	SUM(M12_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=(@VP_K_YYYY-1)
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H0_04] = (	SELECT	SUM(M01_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=@VP_K_YYYY
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H0_05] = (	SELECT	SUM(M02_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=@VP_K_YYYY
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H0_06] = (	SELECT	SUM(M03_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=@VP_K_YYYY
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	)
		WHERE	K_PLAN_POV=@PP_K_PLAN_POV
	  
	-- ============================================
	
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H0_01] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H0_01] IS NULL
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H0_02] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H0_02] IS NULL
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H0_03] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H0_03] IS NULL
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H0_04] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H0_04] IS NULL
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H0_05] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H0_05] IS NULL
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H0_06] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H0_06] IS NULL

	-- ============================================

	UPDATE	PLAN_POV
	SET		VENTAS_KG_H0 =		[VENTAS_KG_H0_01] 
							+	[VENTAS_KG_H0_02] 
							+	[VENTAS_KG_H0_03] 
							+	[VENTAS_KG_H0_04] 
							+	[VENTAS_KG_H0_05] 
							+	[VENTAS_KG_H0_06] 			
	WHERE	K_PLAN_POV=@PP_K_PLAN_POV

	-- ============================================
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PLAN_POV_VENTAS_KG_H1_QUITAR_CEROS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE	[dbo].[PG_UP_PLAN_POV_VENTAS_KG_H1_QUITAR_CEROS]
GO


CREATE PROCEDURE [dbo].[PG_UP_PLAN_POV_VENTAS_KG_H1_QUITAR_CEROS]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================	
	@PP_K_PLAN_POV					INT
AS
	-- ============================================
	
--	UPDATE	PLAN_POV	SET		[VENTAS_KG_H1_01] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H1_01]=0
--	UPDATE	PLAN_POV	SET		[VENTAS_KG_H1_02] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H1_02]=0
--	UPDATE	PLAN_POV	SET		[VENTAS_KG_H1_03] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H1_03]=0
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H1_04] = [VENTAS_KG_H1_03]	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H1_04]=0
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H1_05] = [VENTAS_KG_H1_02]	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H1_05]=0
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H1_06] = [VENTAS_KG_H1_01]	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H1_06]=0

	-- ============================================
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PLAN_POV_VENTAS_KG_H1]') AND type in (N'P', N'PC'))
	DROP PROCEDURE	[dbo].[PG_UP_PLAN_POV_VENTAS_KG_H1]
GO


CREATE PROCEDURE [dbo].[PG_UP_PLAN_POV_VENTAS_KG_H1]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================	
	@PP_K_PLAN_POV					INT
AS

	DECLARE @VP_K_YYYY				INT
	DECLARE @VP_K_TEMPORADA			INT
	DECLARE @VP_K_UNIDAD_OPERATIVA	INT
				
	SELECT	@VP_K_YYYY =				K_YYYY,
			@VP_K_TEMPORADA =			K_TEMPORADA,
			@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA		
										FROM	PLAN_POV
										WHERE	K_PLAN_POV=@PP_K_PLAN_POV
	-- ==============================

	IF @VP_K_TEMPORADA=1	-- VERANO
		UPDATE	PLAN_POV
		SET		[VENTAS_KG_H1_01] = (	SELECT	SUM(M10_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=(@VP_K_YYYY-1)
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H1_02] = (	SELECT	SUM(M11_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=(@VP_K_YYYY-1)
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H1_03] = (	SELECT	SUM(M12_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=(@VP_K_YYYY-1)
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H1_04] = (	SELECT	SUM(M01_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=@VP_K_YYYY
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H1_05] = (	SELECT	SUM(M02_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=@VP_K_YYYY
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H1_06] = (	SELECT	SUM(M03_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=@VP_K_YYYY
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	)
		WHERE	K_PLAN_POV=@PP_K_PLAN_POV
	
	-- =====================================

	IF @VP_K_TEMPORADA=2	-- INVIERNO
		UPDATE	PLAN_POV
		SET		[VENTAS_KG_H1_01] = (	SELECT	SUM(M04_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=@VP_K_YYYY
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H1_02] = (	SELECT	SUM(M05_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=@VP_K_YYYY
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H1_03] = (	SELECT	SUM(M06_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=@VP_K_YYYY
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H1_04] = (	SELECT	SUM(M07_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=@VP_K_YYYY
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H1_05] = (	SELECT	SUM(M08_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=@VP_K_YYYY
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	),
				[VENTAS_KG_H1_06] = (	SELECT	SUM(M09_VALOR)
										FROM	PERFORMANCE_N3_X_ME
										WHERE	K_METRICA=1
										AND		K_YYYY=@VP_K_YYYY
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA	)
		WHERE	K_PLAN_POV=@PP_K_PLAN_POV
	  
	-- ============================================
	
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H1_01] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H1_01] IS NULL
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H1_02] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H1_02] IS NULL
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H1_03] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H1_03] IS NULL
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H1_04] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H1_04] IS NULL
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H1_05] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H1_05] IS NULL
	UPDATE	PLAN_POV	SET		[VENTAS_KG_H1_06] = 0	WHERE	K_PLAN_POV=@PP_K_PLAN_POV	AND	[VENTAS_KG_H1_06] IS NULL

	-- ============================================

	EXECUTE[dbo].[PG_UP_PLAN_POV_VENTAS_KG_H1_QUITAR_CEROS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_PLAN_POV
	-- ============================================

	UPDATE	PLAN_POV
	SET		VENTAS_KG_H1 =		[VENTAS_KG_H1_01] 
							+	[VENTAS_KG_H1_02] 
							+	[VENTAS_KG_H1_03] 
							+	[VENTAS_KG_H1_04] 
							+	[VENTAS_KG_H1_05] 
							+	[VENTAS_KG_H1_06] 			
	WHERE	K_PLAN_POV=@PP_K_PLAN_POV

	-- ============================================
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_PLAN_POV_PROYECTAR_TEMPORADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE	[dbo].[PG_PR_PLAN_POV_PROYECTAR_TEMPORADA]
GO


CREATE PROCEDURE [dbo].[PG_PR_PLAN_POV_PROYECTAR_TEMPORADA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================	
	@PP_L_RESPUESTA					INT,
	-- ===========================	
	@PP_K_PLAN_POV					INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN

		DECLARE @VP_VENTAS_KG_H0				DECIMAL(19,4)
		DECLARE @VP_VENTAS_KG_H1				DECIMAL(19,4)
	
		DECLARE @VP_CRECIMIENTO_MERCADO			DECIMAL (19,4)
		DECLARE @VP_INCREMENTO_PARTICIPACION	DECIMAL (19,4)
		DECLARE @VP_COMPROMISO_KG_X_MES			DECIMAL (19,4)

		SELECT	@VP_VENTAS_KG_H0 =					VENTAS_KG_H0,
				@VP_VENTAS_KG_H1 =					VENTAS_KG_H1,
				@VP_CRECIMIENTO_MERCADO =			CRECIMIENTO_MERCADO,
				@VP_INCREMENTO_PARTICIPACION =		INCREMENTO_PARTICIPACION,
				@VP_COMPROMISO_KG_X_MES =			COMPROMISO_KG_X_MES	
													FROM	PLAN_POV
													WHERE	K_PLAN_POV=@PP_K_PLAN_POV
		-- =======================

		DECLARE @VP_FACTOR_ESTACIONAL		DECIMAL(19,8)

		IF @VP_VENTAS_KG_H0=0
			SET		@VP_FACTOR_ESTACIONAL =		1
		ELSE
			SET		@VP_FACTOR_ESTACIONAL =		( @VP_VENTAS_KG_H1 / @VP_VENTAS_KG_H0 )

		IF  @VP_FACTOR_ESTACIONAL=0
			SET @VP_FACTOR_ESTACIONAL = 1

		DECLARE @VP_VENTA_BASE		DECIMAL(19,4)

		SET		@VP_VENTA_BASE = 	@VP_VENTAS_KG_H1 * ( 1 / @VP_FACTOR_ESTACIONAL )
	
		IF @PP_L_DEBUG>0
			BEGIN
			PRINT '@VP_FACTOR_ESTACIONAL = ' + CONVERT(VARCHAR(100),@VP_FACTOR_ESTACIONAL)
			PRINT '@VP_VENTA_BASE = ' + CONVERT(VARCHAR(100),@VP_VENTA_BASE)
			END

		-- ==========================

		DECLARE @VP_VENTAS_KG_PR				DECIMAL(19,4)

		SET		@VP_VENTAS_KG_PR =	@VP_VENTA_BASE
									+ (@VP_VENTA_BASE*@VP_CRECIMIENTO_MERCADO)
									+ (@VP_VENTA_BASE*@VP_INCREMENTO_PARTICIPACION)
									+ (6*@VP_COMPROMISO_KG_X_MES)
	
		IF @PP_L_DEBUG>0
			BEGIN
			PRINT '@VP_VENTAS_KG_PR = ' + CONVERT(VARCHAR(100),@VP_VENTAS_KG_PR)
			END


		UPDATE	PLAN_POV
		SET		VENTAS_KG_PR =  @VP_VENTAS_KG_PR
		WHERE	K_PLAN_POV=@PP_K_PLAN_POV

		-- ==========================
	
		DECLARE @VP_VENTAS_KG_PR_SIN_COMPROMISO			DECIMAL(19,4)

		SET		@VP_VENTAS_KG_PR_SIN_COMPROMISO =  	   @VP_VENTAS_KG_PR - ( 6*@VP_COMPROMISO_KG_X_MES )

		UPDATE	PLAN_POV
		SET		VENTAS_KG_PR_01	= @VP_VENTAS_KG_PR_SIN_COMPROMISO * (VENTAS_KG_H0_01/VENTAS_KG_H0),
				VENTAS_KG_PR_02	= @VP_VENTAS_KG_PR_SIN_COMPROMISO * (VENTAS_KG_H0_02/VENTAS_KG_H0),
				VENTAS_KG_PR_03	= @VP_VENTAS_KG_PR_SIN_COMPROMISO * (VENTAS_KG_H0_03/VENTAS_KG_H0),
				VENTAS_KG_PR_04	= @VP_VENTAS_KG_PR_SIN_COMPROMISO * (VENTAS_KG_H0_04/VENTAS_KG_H0),
				VENTAS_KG_PR_05	= @VP_VENTAS_KG_PR_SIN_COMPROMISO * (VENTAS_KG_H0_05/VENTAS_KG_H0),
				VENTAS_KG_PR_06 = @VP_VENTAS_KG_PR_SIN_COMPROMISO * (VENTAS_KG_H0_06/VENTAS_KG_H0)
		WHERE	K_PLAN_POV=@PP_K_PLAN_POV
		AND		VENTAS_KG_H0<>0

		-- =====================================
	
		UPDATE	PLAN_POV
		SET		VENTAS_KG_PR_01	= VENTAS_KG_PR_01 + @VP_COMPROMISO_KG_X_MES,
				VENTAS_KG_PR_02	= VENTAS_KG_PR_02 + @VP_COMPROMISO_KG_X_MES,
				VENTAS_KG_PR_03	= VENTAS_KG_PR_03 + @VP_COMPROMISO_KG_X_MES,
				VENTAS_KG_PR_04	= VENTAS_KG_PR_04 + @VP_COMPROMISO_KG_X_MES,
				VENTAS_KG_PR_05	= VENTAS_KG_PR_05 + @VP_COMPROMISO_KG_X_MES,
				VENTAS_KG_PR_06	= VENTAS_KG_PR_06 + @VP_COMPROMISO_KG_X_MES
		WHERE	K_PLAN_POV=@PP_K_PLAN_POV

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Proyectar/Temporada] del [Plan/ObjetivoVenta]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#POV.'+CONVERT(VARCHAR(10),@PP_K_PLAN_POV)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	IF @PP_L_RESPUESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PLAN_POV AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////
-- [PG_UP_PLAN_POV_PARAMETROS_VARIACION] 0,0,0, 1171, NULL, NULL, NULL

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PLAN_POV_PARAMETROS_VARIACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE	[dbo].[PG_UP_PLAN_POV_PARAMETROS_VARIACION]
GO


CREATE PROCEDURE [dbo].[PG_UP_PLAN_POV_PARAMETROS_VARIACION]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================	
	@PP_K_PLAN_POV					INT,
	-- ===========================	
	@PP_CRECIMIENTO_MERCADO_0_100		DECIMAL (19,4),
	@PP_INCREMENTO_PARTICIPACION_0_100	DECIMAL (19,4),
	@PP_COMPROMISO_KG_X_MES				DECIMAL (19,4)
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN

		IF NOT ( @PP_CRECIMIENTO_MERCADO_0_100 IS NULL )
			UPDATE	PLAN_POV
			SET		CRECIMIENTO_MERCADO			= ( @PP_CRECIMIENTO_MERCADO_0_100 / 100)
			WHERE	K_PLAN_POV=@PP_K_PLAN_POV

		IF NOT ( @PP_INCREMENTO_PARTICIPACION_0_100 IS NULL )
			UPDATE	PLAN_POV
			SET		INCREMENTO_PARTICIPACION	= ( @PP_INCREMENTO_PARTICIPACION_0_100 / 100)
			WHERE	K_PLAN_POV=@PP_K_PLAN_POV

		IF NOT ( @PP_COMPROMISO_KG_X_MES IS NULL )
			UPDATE	PLAN_POV
			SET		COMPROMISO_KG_X_MES			= @PP_COMPROMISO_KG_X_MES
			WHERE	K_PLAN_POV=@PP_K_PLAN_POV

		-- =============================================

		EXECUTE	[dbo].[PG_PR_PLAN_POV_PROYECTAR_TEMPORADA]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															0, @PP_K_PLAN_POV

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar/Parametros] del [Plan/ObjetivoVenta]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#POV.'+CONVERT(VARCHAR(10),@PP_K_PLAN_POV)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PLAN_POV AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////
-- // SP // CARGA INICIAL
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_PLAN_POV_MASIVO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_PLAN_POV_MASIVO]
GO


CREATE PROCEDURE [dbo].[PG_PR_PLAN_POV_MASIVO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_ZONA_UO					INT,
	@PP_K_RAZON_SOCIAL				INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	-- ===========================
	@PP_K_YYYY						INT,
	@PP_K_TEMPORADA					INT,
	-- ===========================	
	@PP_CRECIMIENTO_MERCADO_0_100		DECIMAL (19,4),
	@PP_INCREMENTO_PARTICIPACION_0_100	DECIMAL (19,4),
	@PP_COMPROMISO_KG_X_MES				DECIMAL (19,4)
	-- ===========================
AS		

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE='' AND NOT (@PP_K_YYYY>0)
		SET @VP_MENSAJE = 'No ha seleccionado un <Año> válido.'

	IF @VP_MENSAJE='' AND NOT (@PP_K_TEMPORADA>0)
		SET @VP_MENSAJE = 'No ha seleccionado una <Temporada> válida.'

	IF @VP_MENSAJE='' AND (@PP_K_ZONA_UO=-1 AND @PP_K_RAZON_SOCIAL=-1 AND @PP_K_UNIDAD_OPERATIVA=-1)
		SET @VP_MENSAJE = 'No ha seleccionado un <Parámetro( Zona / RazónSocial / UnidadOperativa )> válido.'

	-- /////////////////////////////////////////////////////////////////////

	DECLARE @VP_K_PLAN_POV			INT = 0

	IF @VP_MENSAJE=''
		BEGIN
		-- ==============================================

		DECLARE CU_UNIDAD_OPERATIVA	
			CURSOR	LOCAL FOR
					SELECT	K_UNIDAD_OPERATIVA
					FROM	UNIDAD_OPERATIVA
					WHERE	K_TIPO_UO=10
					AND		( @PP_K_ZONA_UO=-1				OR		@PP_K_ZONA_UO=K_ZONA_UO		)
					AND		( @PP_K_RAZON_SOCIAL=-1			OR		@PP_K_RAZON_SOCIAL=K_RAZON_SOCIAL	)
					AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR		@PP_K_UNIDAD_OPERATIVA=K_UNIDAD_OPERATIVA	)
					
			-- ========================================

			DECLARE @VP_CU_K_UNIDAD_OPERATIVA		INT
			
			-- ========================================

			OPEN CU_UNIDAD_OPERATIVA

			FETCH NEXT FROM CU_UNIDAD_OPERATIVA INTO @VP_CU_K_UNIDAD_OPERATIVA
		
			-- ==================================
		
			WHILE @@FETCH_STATUS = 0
				BEGIN		
			
				PRINT @VP_CU_K_UNIDAD_OPERATIVA

				DELETE	
				FROM	[PLAN_POV] 
				WHERE	[K_UNIDAD_OPERATIVA]=@VP_CU_K_UNIDAD_OPERATIVA
				AND		[K_YYYY]=@PP_K_YYYY
				AND		[K_TEMPORADA]=@PP_K_TEMPORADA

				-- ==================================

				IF @VP_CU_K_UNIDAD_OPERATIVA>0
					BEGIN
			
					EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																'PLAN_POV', 
																@OU_K_TABLA_DISPONIBLE = @VP_K_PLAN_POV			OUTPUT	
					-- ==================================

					INSERT INTO	[dbo].[PLAN_POV] 
						(	[K_PLAN_POV], [O_PLAN_POV],
							[K_UNIDAD_OPERATIVA], [K_YYYY], [K_TEMPORADA],
							N_HISTORICOS,
							-- ===========================
							[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
							[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]		 )		
					VALUES
						(	@VP_K_PLAN_POV, @VP_K_PLAN_POV,
							@VP_CU_K_UNIDAD_OPERATIVA, @PP_K_YYYY, @PP_K_TEMPORADA,		
							4,		
							-- ===========================
							@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
							0, NULL, NULL		)

					-- ========================================

					EXECUTE	[dbo].[PG_UP_PLAN_POV_VENTAS_KG_H0]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@VP_K_PLAN_POV

					EXECUTE	[dbo].[PG_UP_PLAN_POV_VENTAS_KG_H1]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@VP_K_PLAN_POV

					EXECUTE [dbo].[PG_UP_PLAN_POV_PARAMETROS_VARIACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@VP_K_PLAN_POV,
																		@PP_CRECIMIENTO_MERCADO_0_100, @PP_INCREMENTO_PARTICIPACION_0_100, @PP_COMPROMISO_KG_X_MES			

					EXECUTE	[dbo].[PG_PR_PLAN_POV_PROYECTAR_TEMPORADA]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		0, @VP_K_PLAN_POV
					-- ========================================				
					END

				-- ========================================

				FETCH NEXT FROM CU_UNIDAD_OPERATIVA INTO @VP_CU_K_UNIDAD_OPERATIVA
			
				END

			-- ========================================

			CLOSE		CU_UNIDAD_OPERATIVA
			DEALLOCATE	CU_UNIDAD_OPERATIVA

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Generar/Proyección] del [Plan/ObjetivoVenta]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#POV.'+CONVERT(VARCHAR(10),@VP_K_PLAN_POV)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PLAN_POV AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO



-- /////////////////////////////////////////////////////////////////////
-- //
-- /////////////////////////////////////////////////////////////////////




-- /////////////////////////////////////////////////////////////////////


/*

DELETE	
FROM	PLAN_POV
GO


EXECUTE		[PG_PR_PLAN_POV_MASIVO] 0,0,0,	30,-1,-1, 2017, 2,		1.23, 4.56, 789

EXECUTE		[PG_PR_PLAN_POV_MASIVO] 0,0,0,	-1,10,-1, 2017, 2,		2.22, NULL, 444

EXECUTE		[PG_PR_PLAN_POV_MASIVO] 0,0,0,	30,-1,-1, 2018, 1,		1.23, 4.56, 789

*/


--  SELECT	* FROM PLAN_POV 








-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
