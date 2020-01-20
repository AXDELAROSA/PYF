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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PLAN_GASTO_BASE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PLAN_GASTO_BASE]
GO


CREATE PROCEDURE [dbo].[PG_IN_PLAN_GASTO_BASE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ========================================
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_YYYY						INT,
	@OU_K_PLAN_GASTO				INT		OUTPUT
AS
	-- //////////////////////////////////////////////////

	DECLARE @VP_K_PLAN_GASTO				INT

	DECLARE @PP_D_PLAN_GASTO				VARCHAR(100)	= '@PP_D_PLAN_GASTO'
	DECLARE @PP_C_PLAN_GASTO				VARCHAR(255)	= '@PP_C_PLAN_GASTO'
	DECLARE @PP_S_PLAN_GASTO				VARCHAR(10)		= '@PP_S_PLAN_GASTO'
	DECLARE @PP_O_PLAN_GASTO				INT = 0

	DECLARE @PP_K_ESCENARIO_PLAN			INT = 1
	DECLARE @PP_K_ESTATUS_PLAN_GASTO		INT = 1
	DECLARE @PP_L_RECALCULAR				INT = 0

	-- //////////////////////////////////////////////////

	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'PLAN_GASTO', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_PLAN_GASTO		OUTPUT

	-- //////////////////////////////////////////////////

	INSERT INTO PLAN_GASTO
		(	K_PLAN_GASTO,	
			D_PLAN_GASTO,	C_PLAN_GASTO,	
			S_PLAN_GASTO,	O_PLAN_GASTO,	
			-- ========================================
			K_UNIDAD_OPERATIVA, K_ESCENARIO_PLAN,
			K_YYYY,	K_ESTATUS_PLAN_GASTO,	
			L_RECALCULAR,	
			-- ============================================
			[K_USUARIO_ALTA], [F_ALTA], 
			[K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA] 		)
	VALUES		
		(	@VP_K_PLAN_GASTO,	
			@PP_D_PLAN_GASTO,	@PP_C_PLAN_GASTO,			
			@PP_S_PLAN_GASTO,	@PP_O_PLAN_GASTO,				
			-- ========================================
			@PP_K_UNIDAD_OPERATIVA, @PP_K_ESCENARIO_PLAN,
			@PP_K_YYYY,	@PP_K_ESTATUS_PLAN_GASTO,	
			@PP_L_RECALCULAR,
			-- ============================================
			@PP_K_USUARIO_ACCION, GETDATE(), 
			@PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL									)

	-- //////////////////////////////////////////////////

	SET @OU_K_PLAN_GASTO = @VP_K_PLAN_GASTO

	-- //////////////////////////////////////////////////
GO





-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PARTIDA_PLAN_GASTO_BASE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PARTIDA_PLAN_GASTO_BASE]
GO


CREATE PROCEDURE [dbo].[PG_IN_PARTIDA_PLAN_GASTO_BASE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ========================================
	@PP_K_PLAN_GASTO				INT
AS

	DECLARE @VP_K_UNIDAD_OPERATIVA		INT

	SELECT	@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA		
										FROM	PLAN_GASTO
										WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
	-- ==========================

	INSERT INTO	[dbo].[PARTIDA_PLAN_GASTO] 
			(	[K_PLAN_GASTO],		[K_RUBRO_PRESUPUESTO],
				-- ============================================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA] 		)
		SELECT	@PP_K_PLAN_GASTO,	[K_RUBRO_PRESUPUESTO],
				-- ============================================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL
		FROM	RUBRO_PRESUPUESTO

	-- =========================================================
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_PLAN_GASTO_INIT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_PLAN_GASTO_INIT]
GO


CREATE PROCEDURE [dbo].[PG_PR_PLAN_GASTO_INIT]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ========================================
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_YYYY						INT,
	@OU_K_PLAN_GASTO				INT		OUTPUT
AS

	DECLARE @VP_K_PLAN_GASTO		INT		

	EXECUTE [dbo].[PG_IN_PLAN_GASTO_BASE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@PP_K_UNIDAD_OPERATIVA, @PP_K_YYYY,
											@OU_K_PLAN_GASTO = @VP_K_PLAN_GASTO			OUTPUT
	-- ==================================

	IF @VP_K_PLAN_GASTO>0
		EXECUTE [dbo].[PG_IN_PARTIDA_PLAN_GASTO_BASE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_PLAN_GASTO

	-- //////////////////////////////////////////////	

	SET @OU_K_PLAN_GASTO = @VP_K_PLAN_GASTO
	
	-- //////////////////////////////////////////////	
GO





-- //////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_PLAN_GASTO_GENERAR_X_K_PLAN_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_PLAN_GASTO_GENERAR_X_K_PLAN_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_PR_PLAN_GASTO_GENERAR_X_K_PLAN_PRESUPUESTO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PLAN_PRESUPUESTO			INT
	-- ===========================
AS		

	DECLARE @VP_K_UNIDAD_OPERATIVA		INT
	DECLARE @VP_K_YYYY					INT
	DECLARE @VP_K_TEMPORADA				INT

	SELECT	@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA,
			@VP_K_YYYY =				K_YYYY,
			@VP_K_TEMPORADA =			K_TEMPORADA
										FROM	PLAN_PRESUPUESTO
										WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
	-- ============================
	-- K_TEMPORADA /// #1 VERANO /// #2 INVIERNO

	DECLARE @VP_K_PLAN_GASTO	INT

	EXECUTE [dbo].[PG_PR_PLAN_GASTO_INIT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@VP_K_UNIDAD_OPERATIVA, @VP_K_YYYY,
											@OU_K_PLAN_GASTO = @VP_K_PLAN_GASTO		OUTPUT

	-- ==================================

	IF @VP_K_TEMPORADA=1
		UPDATE	PARTIDA_PLAN_GASTO 
		SET		M04_MONTO_ESTIMADO = PPP.M01_AUTORIZADO,
				M05_MONTO_ESTIMADO = PPP.M02_AUTORIZADO,
				M06_MONTO_ESTIMADO = PPP.M03_AUTORIZADO,
				M07_MONTO_ESTIMADO = PPP.M04_AUTORIZADO,
				M08_MONTO_ESTIMADO = PPP.M05_AUTORIZADO,
				M09_MONTO_ESTIMADO = PPP.M06_AUTORIZADO
		FROM	PARTIDA_PLAN_PRESUPUESTO AS PPP
		WHERE	K_PLAN_GASTO=@VP_K_PLAN_GASTO
		AND		PPP.K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
		AND		PARTIDA_PLAN_GASTO.K_RUBRO_PRESUPUESTO=PPP.K_RUBRO_PRESUPUESTO
	ELSE
		IF @VP_K_TEMPORADA=2
			UPDATE	PARTIDA_PLAN_GASTO 
			SET		M10_MONTO_ESTIMADO = PPP.M01_AUTORIZADO,
					M11_MONTO_ESTIMADO = PPP.M02_AUTORIZADO,
					M12_MONTO_ESTIMADO = PPP.M03_AUTORIZADO
			FROM	PARTIDA_PLAN_PRESUPUESTO AS PPP
			WHERE	K_PLAN_GASTO=@VP_K_PLAN_GASTO
			AND		PPP.K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
			AND		PARTIDA_PLAN_GASTO.K_RUBRO_PRESUPUESTO=PPP.K_RUBRO_PRESUPUESTO

	-- ////////////////////////////////////////////////////////////////////

	IF @VP_K_TEMPORADA=2
		BEGIN
		
		SET @VP_K_YYYY = @VP_K_YYYY+1
		
		EXECUTE [dbo].[PG_PR_PLAN_GASTO_INIT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@VP_K_UNIDAD_OPERATIVA, @VP_K_YYYY,
												@OU_K_PLAN_GASTO = @VP_K_PLAN_GASTO		OUTPUT

		UPDATE	PARTIDA_PLAN_GASTO 
		SET		M01_MONTO_ESTIMADO = PPP.M04_AUTORIZADO,
				M02_MONTO_ESTIMADO = PPP.M05_AUTORIZADO,
				M03_MONTO_ESTIMADO = PPP.M06_AUTORIZADO
		FROM	PARTIDA_PLAN_PRESUPUESTO AS PPP
		WHERE	K_PLAN_GASTO=@VP_K_PLAN_GASTO
		AND		PPP.K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
		AND		PARTIDA_PLAN_GASTO.K_RUBRO_PRESUPUESTO=PPP.K_RUBRO_PRESUPUESTO
					
		END

	-- //////////////////////////////////////////////	
GO




-- ==========================================================
-- ==========================================================

/*

EXECUTE [dbo].[PG_PR_PLAN_PRESUPUESTO_MASIVO]	1,0,0,	60, -1, -1,		2010, 1

EXECUTE [dbo].[PG_PR_PLAN_PRESUPUESTO_MASIVO]	0,0,0,	50, -1, -1,		2010, 2

EXECUTE [dbo].[PG_PR_PLAN_PRESUPUESTO_MASIVO]	0,0,0,	40, -1, -1,		2010, 1

EXECUTE [dbo].[PG_PR_PLAN_PRESUPUESTO_MASIVO]	1,0,0,	30, -1, -1,		2010, 2




DELETE FROM PARTIDA_PLAN_GASTO  WHERE K_PLAN_GASTO>=63

DELETE FROM PLAN_GASTO  WHERE K_PLAN_GASTO>=63

-- ==========================================================

EXECUTE [PG_PR_PLAN_GASTO_GENERAR_X_K_PLAN_PRESUPUESTO] 1,0,0, 10
EXECUTE [PG_PR_PLAN_GASTO_GENERAR_X_K_PLAN_PRESUPUESTO] 1,0,0, 12
EXECUTE [PG_PR_PLAN_GASTO_GENERAR_X_K_PLAN_PRESUPUESTO] 1,0,0, 14
EXECUTE [PG_PR_PLAN_GASTO_GENERAR_X_K_PLAN_PRESUPUESTO] 1,0,0, 16
EXECUTE [PG_PR_PLAN_GASTO_GENERAR_X_K_PLAN_PRESUPUESTO] 1,0,0, 18

EXECUTE [PG_PR_PLAN_GASTO_GENERAR_X_K_PLAN_PRESUPUESTO] 1,0,0, 20
EXECUTE [PG_PR_PLAN_GASTO_GENERAR_X_K_PLAN_PRESUPUESTO] 1,0,0, 22
EXECUTE [PG_PR_PLAN_GASTO_GENERAR_X_K_PLAN_PRESUPUESTO] 1,0,0, 24
EXECUTE [PG_PR_PLAN_GASTO_GENERAR_X_K_PLAN_PRESUPUESTO] 1,0,0, 26
EXECUTE [PG_PR_PLAN_GASTO_GENERAR_X_K_PLAN_PRESUPUESTO] 1,0,0, 28


-- SELECT * FROM PLAN_PRESUPUESTO

-- SELECT * FROM PLAN_GASTO

-- SELECT * FROM PARTIDA_PLAN_GASTO WHERE K_PLAN_GASTO>=63



*/


-- ==========================================================
-- ==========================================================




-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
