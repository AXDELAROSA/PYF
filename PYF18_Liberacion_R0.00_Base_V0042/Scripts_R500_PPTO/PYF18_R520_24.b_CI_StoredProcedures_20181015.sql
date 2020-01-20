-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PLAN_GASTO GASTOS / PLANTA
-- // OPERACION:		LIBERACION / CARGA INICIAL / SPs
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	16/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////






-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PLAN_GASTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PLAN_GASTO]
GO


CREATE PROCEDURE [dbo].[PG_CI_PLAN_GASTO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ========================================
	@PP_K_PLAN_GASTO				INT,
	@PP_D_PLAN_GASTO				VARCHAR(100),
	@PP_C_PLAN_GASTO				VARCHAR(255),
	@PP_S_PLAN_GASTO				VARCHAR(10),
	@PP_O_PLAN_GASTO				INT,
	-- ========================================
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_ESCENARIO_PLAN			INT,
	@PP_K_YYYY						INT,
	@PP_K_ESTATUS_PLAN_GASTO		INT,
	@PP_L_RECALCULAR				INT
AS

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
		(	@PP_K_PLAN_GASTO,	
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

	-- =========================================================
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PARTIDA_PLAN_GASTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PARTIDA_PLAN_GASTO]
GO


CREATE PROCEDURE [dbo].[PG_CI_PARTIDA_PLAN_GASTO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ========================================
	@PP_K_PLAN_GASTO				INT,
	@PP_K_RUBRO_PRESUPUESTO			INT,
	@PP_K_PROGRAMACION_PARTIDA		INT,
	-- ========================================
	@PP_MES							INT,
    @PP_MXX_MONTO_ESTIMADO			DECIMAL(19,4)
AS

	DECLARE @VP_K_PLAN_GASTO		INT


	SELECT	@VP_K_PLAN_GASTO = 		K_PLAN_GASTO
									FROM	PARTIDA_PLAN_GASTO
									WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
									AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO

	-- =====================================

	IF @VP_K_PLAN_GASTO IS NULL
		INSERT INTO [PARTIDA_PLAN_GASTO]
			(	K_PLAN_GASTO,
				K_RUBRO_PRESUPUESTO,
				K_PROGRAMACION_PARTIDA,
				-- ============================================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA] 					)
		VALUES		
			(	@PP_K_PLAN_GASTO,
				@PP_K_RUBRO_PRESUPUESTO,
				@PP_K_PROGRAMACION_PARTIDA, 
				-- ============================================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )					

	-- =========================================================

	IF @PP_MES=01				UPDATE	PARTIDA_PLAN_GASTO
								SET		M01_MONTO_ESTIMADO = @PP_MXX_MONTO_ESTIMADO
								WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
								AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	-- ======================
	IF @PP_MES=02				UPDATE	PARTIDA_PLAN_GASTO
								SET		M02_MONTO_ESTIMADO = @PP_MXX_MONTO_ESTIMADO
								WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
								AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	-- ======================
	IF @PP_MES=03				UPDATE	PARTIDA_PLAN_GASTO
								SET		M03_MONTO_ESTIMADO = @PP_MXX_MONTO_ESTIMADO
								WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
								AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	-- ======================
	IF @PP_MES=04				UPDATE	PARTIDA_PLAN_GASTO
								SET		M04_MONTO_ESTIMADO = @PP_MXX_MONTO_ESTIMADO
								WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
								AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	-- ======================
	IF @PP_MES=05				UPDATE	PARTIDA_PLAN_GASTO
								SET		M05_MONTO_ESTIMADO = @PP_MXX_MONTO_ESTIMADO
								WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
								AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	-- ======================
	IF @PP_MES=06				UPDATE	PARTIDA_PLAN_GASTO
								SET		M06_MONTO_ESTIMADO = @PP_MXX_MONTO_ESTIMADO
								WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
								AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	-- ======================
	IF @PP_MES=07				UPDATE	PARTIDA_PLAN_GASTO
								SET		M07_MONTO_ESTIMADO = @PP_MXX_MONTO_ESTIMADO
								WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
								AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	-- ======================
	IF @PP_MES=08				UPDATE	PARTIDA_PLAN_GASTO
								SET		M08_MONTO_ESTIMADO = @PP_MXX_MONTO_ESTIMADO
								WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
								AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	-- ======================
	IF @PP_MES=09				UPDATE	PARTIDA_PLAN_GASTO
								SET		M09_MONTO_ESTIMADO = @PP_MXX_MONTO_ESTIMADO
								WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
								AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	-- ======================
	IF @PP_MES=10				UPDATE	PARTIDA_PLAN_GASTO
								SET		M10_MONTO_ESTIMADO = @PP_MXX_MONTO_ESTIMADO
								WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
								AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	-- ======================
	IF @PP_MES=11				UPDATE	PARTIDA_PLAN_GASTO
								SET		M11_MONTO_ESTIMADO = @PP_MXX_MONTO_ESTIMADO
								WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
								AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	-- ======================
	IF @PP_MES=12				UPDATE	PARTIDA_PLAN_GASTO
								SET		M12_MONTO_ESTIMADO = @PP_MXX_MONTO_ESTIMADO
								WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
								AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	-- ======================

	UPDATE	PARTIDA_PLAN_GASTO
	SET		M00_MONTO_ESTIMADO =	( 
										M01_MONTO_ESTIMADO + M02_MONTO_ESTIMADO + M03_MONTO_ESTIMADO +
										M04_MONTO_ESTIMADO + M05_MONTO_ESTIMADO + M06_MONTO_ESTIMADO +
										M07_MONTO_ESTIMADO + M08_MONTO_ESTIMADO + M09_MONTO_ESTIMADO +
										M10_MONTO_ESTIMADO + M11_MONTO_ESTIMADO + M12_MONTO_ESTIMADO 
									)
	WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO
	AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO

	-- ========================================
GO





-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
