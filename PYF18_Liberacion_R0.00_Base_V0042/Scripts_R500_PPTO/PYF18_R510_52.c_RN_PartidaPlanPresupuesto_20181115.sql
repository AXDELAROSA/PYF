-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PLAN_PRESUPUESTO GASTOS/PLANTA
-- // OPERACION:		LIBERACION / REGLAS NEGOCIO
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	15/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]
GO


CREATE PROCEDURE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_YYYY			INT,
	@PP_K_MES			INT,
	-- ===========================
	@OU_N_SEMANAS		DECIMAL(19,4)		OUTPUT
AS
	DECLARE @VP_N_SEMANAS		DECIMAL(19,4)

	SELECT	@VP_N_SEMANAS =		MAX([N_SEMANA])
								FROM	[TIEMPO_FECHA]
								WHERE	[FECHA_YYYY]=@PP_K_YYYY			
								AND		[K_TIEMPO_MES]=@PP_K_MES			
								AND		[FECHA_DD]>20
	-- =======================

	IF @VP_N_SEMANAS IS NULL
		SET @VP_N_SEMANAS = 4

	IF @PP_L_DEBUG>0
		PRINT '@YYYY='+CONVERT(VARCHAR(100),@PP_K_YYYY)+' @MM='+CONVERT(VARCHAR(100),@PP_K_MES)+' >>> N_SEMANAS='+CONVERT(VARCHAR(100),@VP_N_SEMANAS)

	-- =======================

	SET @OU_N_SEMANAS = @VP_N_SEMANAS

	-- =======================================
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_TEMPORADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_TEMPORADA]
GO


CREATE PROCEDURE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_TEMPORADA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_YYYY						INT,
	@PP_K_TEMPORADA					INT,
	-- ===========================
	@OU_M01_SEMANAS DECIMAL(19,4)	OUTPUT,
	@OU_M02_SEMANAS DECIMAL(19,4)	OUTPUT,
	@OU_M03_SEMANAS DECIMAL(19,4)	OUTPUT,
	@OU_M04_SEMANAS DECIMAL(19,4)	OUTPUT,
	@OU_M05_SEMANAS DECIMAL(19,4)	OUTPUT,
	@OU_M06_SEMANAS DECIMAL(19,4)	OUTPUT
AS
	-- ===========================

	DECLARE @VP_M01_SEMANAS DECIMAL(19,4) 
	DECLARE @VP_M02_SEMANAS DECIMAL(19,4) 
	DECLARE @VP_M03_SEMANAS DECIMAL(19,4) 
	DECLARE @VP_M04_SEMANAS DECIMAL(19,4) 
	DECLARE @VP_M05_SEMANAS DECIMAL(19,4) 
	DECLARE @VP_M06_SEMANAS DECIMAL(19,4) 

	-- ===========================

	IF @PP_K_TEMPORADA=1		-- VERANO
		BEGIN
	
		EXECUTE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_YYYY, 4,
														@OU_N_SEMANAS = @VP_M01_SEMANAS			OUTPUT
		EXECUTE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_YYYY, 5,
														@OU_N_SEMANAS = @VP_M02_SEMANAS			OUTPUT
		EXECUTE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_YYYY, 6,
														@OU_N_SEMANAS = @VP_M03_SEMANAS			OUTPUT
		EXECUTE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_YYYY, 7,
														@OU_N_SEMANAS = @VP_M04_SEMANAS			OUTPUT
		EXECUTE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_YYYY, 8,
														@OU_N_SEMANAS = @VP_M05_SEMANAS			OUTPUT
		EXECUTE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_YYYY, 9,
														@OU_N_SEMANAS = @VP_M06_SEMANAS			OUTPUT															
		END

	-- ===========================

	IF @PP_K_TEMPORADA=2		-- INVIERNO
		BEGIN
	
		EXECUTE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_YYYY, 10,
														@OU_N_SEMANAS = @VP_M01_SEMANAS			OUTPUT
		EXECUTE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_YYYY, 11,
														@OU_N_SEMANAS = @VP_M02_SEMANAS			OUTPUT
		EXECUTE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_YYYY, 12,
														@OU_N_SEMANAS = @VP_M03_SEMANAS			OUTPUT
		SET		@PP_K_YYYY = (@PP_K_YYYY+1)

		EXECUTE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_YYYY, 01,
														@OU_N_SEMANAS = @VP_M04_SEMANAS			OUTPUT
		EXECUTE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_YYYY, 02,
														@OU_N_SEMANAS = @VP_M05_SEMANAS			OUTPUT
		EXECUTE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_X_MM]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_YYYY, 03,
														@OU_N_SEMANAS = @VP_M06_SEMANAS			OUTPUT
		END
		
	-- ===========================

	SET @OU_M01_SEMANAS = @VP_M01_SEMANAS
	SET @OU_M02_SEMANAS = @VP_M02_SEMANAS
	SET @OU_M03_SEMANAS = @VP_M03_SEMANAS
	SET @OU_M04_SEMANAS = @VP_M04_SEMANAS
	SET @OU_M05_SEMANAS = @VP_M05_SEMANAS
	SET @OU_M06_SEMANAS = @VP_M06_SEMANAS

	-- ===========================
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CALCULO_PARTIDA_PRESUPUESTO_K_X_D]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CALCULO_PARTIDA_PRESUPUESTO_K_X_D]
GO


CREATE PROCEDURE [dbo].[PG_RN_CALCULO_PARTIDA_PRESUPUESTO_K_X_D]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================			
	@PP_D_CALCULO_PARTIDA_PRESUPUESTO	VARCHAR (200),
	-- ===========================		
	@OU_K_CALCULO_PARTIDA_PRESUPUESTO	INT		OUTPUT
AS

	DECLARE @VP_K_CALCULO_PARTIDA_PRESUPUESTO	INT = -1
		
	-- /////////////////////////////////////////////////////
	-- K_CALCULO_PARTIDA_PRESUPUESTO
	-- 1	X MES
	-- 2	X SEMANA

	IF @VP_K_CALCULO_PARTIDA_PRESUPUESTO=-1
		IF @PP_D_CALCULO_PARTIDA_PRESUPUESTO IN ('1','MES','M')
			SET @VP_K_CALCULO_PARTIDA_PRESUPUESTO = 1				-- 1	X MES

	IF @VP_K_CALCULO_PARTIDA_PRESUPUESTO=-1
		IF @PP_D_CALCULO_PARTIDA_PRESUPUESTO IN ('2','SEMANA','S','W')
			SET @VP_K_CALCULO_PARTIDA_PRESUPUESTO = 2				-- 2	X SEMANA

	-- /////////////////////////////////////////////////////

	SET @OU_K_CALCULO_PARTIDA_PRESUPUESTO	=	@VP_K_CALCULO_PARTIDA_PRESUPUESTO

	-- /////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROGRAMACION_PARTIDA_K_X_D]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROGRAMACION_PARTIDA_K_X_D]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROGRAMACION_PARTIDA_K_X_D]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================			
	@PP_D_PROGRAMACION_PARTIDA			VARCHAR (200),
	-- ===========================		
	@OU_K_PROGRAMACION_PARTIDA			INT		OUTPUT
AS

	DECLARE @VP_K_PROGRAMACION_PARTIDA	INT = -1
		
	-- /////////////////////////////////////////////////////
	-- K_PROGRAMACION_PARTIDA	
	-- 0	W?????
	-- 101	W1000-	X----
	-- 102	W0100-	-X---
	-- 103	W0010-	--X--
	-- 104	W0001-	---X-
	-- 201	W1010-	X-X--
	-- 202	W0101-	-X-X-
	-- 401	W11110	XXXX-
	-- 501	W11111	XXXXX

	IF @VP_K_PROGRAMACION_PARTIDA=-1
		IF @PP_D_PROGRAMACION_PARTIDA IN (	'W1000-','W1000','W100','W10','W1',
											 'X----', 'X---', 'X--', 'X-', 'X',
											'1'		)
			SET @VP_K_PROGRAMACION_PARTIDA = 101			-- 101	W1000-	X----

	IF @VP_K_PROGRAMACION_PARTIDA=-1
		IF @PP_D_PROGRAMACION_PARTIDA IN (	'W0100-','W0100','W010','W01',
											 '-X---', '-X--', '-X-', '-X',
											 '2'	)
			SET @VP_K_PROGRAMACION_PARTIDA = 102			-- 102	W0100-	-X---

	IF @VP_K_PROGRAMACION_PARTIDA=-1
		IF @PP_D_PROGRAMACION_PARTIDA IN (	'W0010-','W0010','W001',
											 '--X--', '--X-', '--X',
											'3'		)
			SET @VP_K_PROGRAMACION_PARTIDA = 103			-- 103	W0010-	--X--

	IF @VP_K_PROGRAMACION_PARTIDA=-1
		IF @PP_D_PROGRAMACION_PARTIDA IN (	'W0001-','W0001',
											 '---X-', '---X',
											'4'		)
			SET @VP_K_PROGRAMACION_PARTIDA = 104			-- 104	W0001-	---X-

	IF @VP_K_PROGRAMACION_PARTIDA=-1
		IF @PP_D_PROGRAMACION_PARTIDA IN (	'W1010-', 'W1010', 'W101',
											 'X-X--',  'X-X-',  'X-X',
											 '10100',  '1010',  '101',
											'Q1'	)
			SET @VP_K_PROGRAMACION_PARTIDA = 201			-- 201	W1010-	X-X--

	IF @VP_K_PROGRAMACION_PARTIDA=-1
		IF @PP_D_PROGRAMACION_PARTIDA IN (	'W0101-','W01010','W0101',
											 '-X-X-',          '-X-X',
											 '01010',          '0101',
											'Q2'	)
			SET @VP_K_PROGRAMACION_PARTIDA = 202			-- 202	W0101-	-X-X-

	IF @VP_K_PROGRAMACION_PARTIDA=-1
		IF @PP_D_PROGRAMACION_PARTIDA IN (	'W11110','W1111',
											 'XXXX-', 'XXXX',
											 '11110', '1111'		)
			SET @VP_K_PROGRAMACION_PARTIDA = 401			-- 401	W11110	XXXX-

	IF @VP_K_PROGRAMACION_PARTIDA=-1
		IF @PP_D_PROGRAMACION_PARTIDA IN (	'W11111',
											'XXXXX',
											'11111',
											'5','W','S'		)
			SET @VP_K_PROGRAMACION_PARTIDA = 501			-- 501	W11111	XXXXX

	-- /////////////////////////////////////////////////////
	
	SET @OU_K_PROGRAMACION_PARTIDA = @VP_K_PROGRAMACION_PARTIDA

	-- /////////////////////////////////////////////////////
GO





-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
