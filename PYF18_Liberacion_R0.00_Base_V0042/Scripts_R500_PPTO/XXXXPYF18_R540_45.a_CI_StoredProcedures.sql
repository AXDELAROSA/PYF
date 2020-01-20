-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PRESUPUESTO GASTOS/PLANTA
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	24/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////
/*

USE [PYF18_Finanzas_V9999_R0]
GO

SELECT	PRESUPUESTO.K_UNIDAD_OPERATIVA,
		K_NIVEL_RUBRO_PRESUPUESTO, D_RUBRO_PRESUPUESTO,
		PARTIDA_PRESUPUESTO.*
FROM	RUBRO_PRESUPUESTO, PARTIDA_PRESUPUESTO,
		PRESUPUESTO
WHERE	PARTIDA_PRESUPUESTO.K_PRESUPUESTO=PRESUPUESTO.K_PRESUPUESTO
AND		RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO=PARTIDA_PRESUPUESTO.K_RUBRO_PRESUPUESTO
ORDER BY	PARTIDA_PRESUPUESTO.K_PRESUPUESTO, 
			O_RUBRO_PRESUPUESTO 
			
*/



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_CI_PRESUPUESTO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ========================================
	@PP_K_PRESUPUESTO				INT,
	@PP_D_PRESUPUESTO				VARCHAR(100),
	@PP_C_PRESUPUESTO				VARCHAR(255),
	@PP_S_PRESUPUESTO				VARCHAR(10),
	@PP_O_PRESUPUESTO				INT,
	-- ========================================
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_YYYY						INT,
	@PP_K_MM						INT,
	@PP_K_ESTATUS_PRESUPUESTO		INT,
	@PP_L_RECALCULAR				INT
AS

	INSERT INTO PRESUPUESTO
		(	K_PRESUPUESTO,	
			D_PRESUPUESTO,	C_PRESUPUESTO,	
			S_PRESUPUESTO,	O_PRESUPUESTO,	
			-- ========================================
			K_UNIDAD_OPERATIVA,	
			K_YYYY,	K_MM,	K_ESTATUS_PRESUPUESTO,	
			L_RECALCULAR,	
			-- ============================================
			[K_USUARIO_ALTA], [F_ALTA], 
			[K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA] 					)
	VALUES		
		(	@PP_K_PRESUPUESTO,	
			@PP_D_PRESUPUESTO,	@PP_C_PRESUPUESTO,			
			@PP_S_PRESUPUESTO,  @PP_O_PRESUPUESTO,				
			-- ========================================
			@PP_K_UNIDAD_OPERATIVA,			
			@PP_K_YYYY,	@PP_K_MM,	@PP_K_ESTATUS_PRESUPUESTO,		
			@PP_L_RECALCULAR,
			-- ============================================
			@PP_K_USUARIO_ACCION, GETDATE(), 
			@PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL )					

	-- =========================================================
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PRESUPUESTO_EJEMPLO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_EJEMPLO]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_EJEMPLO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ========================================
	@PP_K_PRESUPUESTO				INT,
	@PP_K_RUBRO_PRESUPUESTO			INT
	-- ========================================
AS

	UPDATE	[PARTIDA_PRESUPUESTO]
	SET		W01_MONTO_EN_PROCESO	= CONVERT( DECIMAL(19,2), (W01_MONTO_ESTIMADO*(ABS(CHECKSUM(NEWID()) % 30)/100.1)) ),
			W01_MONTO_EJERCIDO		= CONVERT( DECIMAL(19,2), (W01_MONTO_ESTIMADO*(ABS(CHECKSUM(NEWID()) % 60)/100.1)) )
	WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO
	AND 	K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO

	-- ========================================

	UPDATE	[PARTIDA_PRESUPUESTO]
	SET		W02_MONTO_EN_PROCESO	= CONVERT( DECIMAL(19,2), (W02_MONTO_ESTIMADO*(ABS(CHECKSUM(NEWID()) % 30)/100.1)) ),
			W02_MONTO_EJERCIDO		= CONVERT( DECIMAL(19,2), (W02_MONTO_ESTIMADO*(ABS(CHECKSUM(NEWID()) % 60)/100.1)) )
	WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO
	AND 	K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO

	-- ========================================

	UPDATE	[PARTIDA_PRESUPUESTO]
	SET		W03_MONTO_EN_PROCESO	= CONVERT( DECIMAL(19,2), (W03_MONTO_ESTIMADO*(ABS(CHECKSUM(NEWID()) % 30)/100.1)) ),
			W03_MONTO_EJERCIDO		= CONVERT( DECIMAL(19,2), (W03_MONTO_ESTIMADO*(ABS(CHECKSUM(NEWID()) % 60)/100.1)) )
	WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO
	AND 	K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO

	-- ========================================

	UPDATE	[PARTIDA_PRESUPUESTO]
	SET		W04_MONTO_EN_PROCESO	= CONVERT( DECIMAL(19,2), (W04_MONTO_ESTIMADO*(ABS(CHECKSUM(NEWID()) % 30)/100.1)) ),
			W04_MONTO_EJERCIDO		= CONVERT( DECIMAL(19,2), (W04_MONTO_ESTIMADO*(ABS(CHECKSUM(NEWID()) % 60)/100.1)) )
	WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO
	AND 	K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
		-- ========================================

	UPDATE	[PARTIDA_PRESUPUESTO]
	SET		W05_MONTO_EN_PROCESO	= CONVERT( DECIMAL(19,2), (W05_MONTO_ESTIMADO*(ABS(CHECKSUM(NEWID()) % 30)/100.1)) ),
			W05_MONTO_EJERCIDO		= CONVERT( DECIMAL(19,2), (W05_MONTO_ESTIMADO*(ABS(CHECKSUM(NEWID()) % 60)/100.1)) )
	WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO
	AND 	K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO

	-- ////////////////////////////////////////////////////////
GO







-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PARTIDA_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PARTIDA_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_CI_PARTIDA_PRESUPUESTO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ========================================
	@PP_K_PRESUPUESTO				INT,
	@PP_K_RUBRO_PRESUPUESTO			INT,
	@PP_K_PROGRAMACION_PARTIDA		INT,
	-- ========================================
	@PP_MES_MONTO_ESTIMADO			DECIMAL(19,4),
    @PP_W01_MONTO_ESTIMADO			DECIMAL(19,4),
    @PP_W02_MONTO_ESTIMADO			DECIMAL(19,4),
    @PP_W03_MONTO_ESTIMADO			DECIMAL(19,4),
    @PP_W04_MONTO_ESTIMADO			DECIMAL(19,4),
    @PP_W05_MONTO_ESTIMADO			DECIMAL(19,4)
AS

	INSERT INTO [PARTIDA_PRESUPUESTO]
		(	K_PRESUPUESTO,
			K_RUBRO_PRESUPUESTO,
			K_PROGRAMACION_PARTIDA,
			-- ============================================
			MES_MONTO_ESTIMADO,
			W01_MONTO_ESTIMADO,				W02_MONTO_ESTIMADO,
			W03_MONTO_ESTIMADO,				W04_MONTO_ESTIMADO,
			W05_MONTO_ESTIMADO,
			-- ============================================
			[K_USUARIO_ALTA], [F_ALTA], 
			[K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA] 					)
	VALUES		
		(	@PP_K_PRESUPUESTO,
			@PP_K_RUBRO_PRESUPUESTO,
			@PP_K_PROGRAMACION_PARTIDA, 
			-- ============================================
			@PP_MES_MONTO_ESTIMADO,
			0,								0,
			0,								0,
			0,
/*
			@PP_W01_MONTO_ESTIMADO,			@PP_W02_MONTO_ESTIMADO,
			@PP_W03_MONTO_ESTIMADO,			@PP_W04_MONTO_ESTIMADO,
			@PP_W05_MONTO_ESTIMADO,
*/
			-- ============================================
			@PP_K_USUARIO_ACCION, GETDATE(), 
			@PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL )					

	-- =========================================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_PROGRAMACION]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO
	-- ========================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_EJEMPLO]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO
	-- ========================================

	EXECUTE [PG_UP_PARTIDA_PRESUPUESTO_CALCULOS_SEMANA]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO
	-- ========================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULOS_MES]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO	
	-- ========================================
GO







-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
