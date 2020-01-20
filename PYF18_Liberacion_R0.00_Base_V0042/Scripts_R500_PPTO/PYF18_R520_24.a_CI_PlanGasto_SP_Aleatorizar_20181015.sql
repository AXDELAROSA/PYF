-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PLAN_GASTO GASTOS / PLANTA
-- // OPERACION:		LIBERACION / CARGA INICIAL / SP
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	16/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_PARTIDA_PLAN_GASTO_ALEATORIZAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_PARTIDA_PLAN_GASTO_ALEATORIZAR]
GO


CREATE PROCEDURE [dbo].[PG_PR_PARTIDA_PLAN_GASTO_ALEATORIZAR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================			
	@PP_K_PLAN_GASTO			INT
AS
	-- SELECT  RAND(convert(varbinary, newid())) ALEATORIO_0_1

/*
	SELECT	K_RUBRO_PRESUPUESTO, ( (RAND(convert(varbinary, newid())) * ((K_PLAN_GASTO+CONVERT(INT,(K_RUBRO_PRESUPUESTO/10))) % 40))/100 ) -0.10
	FROM	PARTIDA_PLAN_GASTO
*/

	DECLARE @VP_AMPLITUD AS INT = 40

	UPDATE	PARTIDA_PLAN_GASTO
	SET	
			[M01_MONTO_ESTIMADO] = ([M01_MONTO_ESTIMADO] *	(	1 + 
																 ( (RAND(convert(varbinary, newid())) * ((K_PLAN_GASTO+CONVERT(INT,(K_RUBRO_PRESUPUESTO/10))) % @VP_AMPLITUD))/100 ) - 0.10 )
															),
			[M02_MONTO_ESTIMADO] = ([M02_MONTO_ESTIMADO] *	(	1 + 
																 ( (RAND(convert(varbinary, newid())) * ((K_PLAN_GASTO+CONVERT(INT,(K_RUBRO_PRESUPUESTO/10))) % @VP_AMPLITUD))/100 ) - 0.10 )
															),
			[M03_MONTO_ESTIMADO] = ([M03_MONTO_ESTIMADO] *	(	1 + 
																 ( (RAND(convert(varbinary, newid())) * ((K_PLAN_GASTO+CONVERT(INT,(K_RUBRO_PRESUPUESTO/10))) % @VP_AMPLITUD))/100 ) - 0.10 )
															),
			[M04_MONTO_ESTIMADO] = ([M04_MONTO_ESTIMADO] *	(	1 + 
																 ( (RAND(convert(varbinary, newid())) * ((K_PLAN_GASTO+CONVERT(INT,(K_RUBRO_PRESUPUESTO/10))) % @VP_AMPLITUD))/100 ) - 0.10 )
															),
			[M05_MONTO_ESTIMADO] = ([M05_MONTO_ESTIMADO] *	(	1 + 
																 ( (RAND(convert(varbinary, newid())) * ((K_PLAN_GASTO+CONVERT(INT,(K_RUBRO_PRESUPUESTO/10))) % @VP_AMPLITUD))/100 ) - 0.10 )
															),															
			[M06_MONTO_ESTIMADO] = ([M06_MONTO_ESTIMADO] *	(	1 + 
																 ( (RAND(convert(varbinary, newid())) * ((K_PLAN_GASTO+CONVERT(INT,(K_RUBRO_PRESUPUESTO/10))) % @VP_AMPLITUD))/100 ) - 0.10 )
															),															
			[M07_MONTO_ESTIMADO] = ([M07_MONTO_ESTIMADO] *	(	1 + 
																 ( (RAND(convert(varbinary, newid())) * ((K_PLAN_GASTO+CONVERT(INT,(K_RUBRO_PRESUPUESTO/10))) % @VP_AMPLITUD))/100 ) - 0.10 )
															),
			[M08_MONTO_ESTIMADO] = ([M08_MONTO_ESTIMADO] *	(	1 + 
																 ( (RAND(convert(varbinary, newid())) * ((K_PLAN_GASTO+CONVERT(INT,(K_RUBRO_PRESUPUESTO/10))) % @VP_AMPLITUD))/100 ) - 0.10 )
															),
			[M09_MONTO_ESTIMADO] = ([M09_MONTO_ESTIMADO] *	(	1 + 
																 ( (RAND(convert(varbinary, newid())) * ((K_PLAN_GASTO+CONVERT(INT,(K_RUBRO_PRESUPUESTO/10))) % @VP_AMPLITUD))/100 ) - 0.10 )
															),
			[M10_MONTO_ESTIMADO] = ([M10_MONTO_ESTIMADO] *	(	1 + 
																 ( (RAND(convert(varbinary, newid())) * ((K_PLAN_GASTO+CONVERT(INT,(K_RUBRO_PRESUPUESTO/10))) % @VP_AMPLITUD))/100 ) - 0.10 )
															),
			[M11_MONTO_ESTIMADO] = ([M11_MONTO_ESTIMADO] *	(	1 + 
																 ( (RAND(convert(varbinary, newid())) * ((K_PLAN_GASTO+CONVERT(INT,(K_RUBRO_PRESUPUESTO/10))) % @VP_AMPLITUD))/100 ) - 0.10 )
															),															
			[M12_MONTO_ESTIMADO] = ([M12_MONTO_ESTIMADO] *	(	1 + 
																 ( (RAND(convert(varbinary, newid())) * ((K_PLAN_GASTO+CONVERT(INT,(K_RUBRO_PRESUPUESTO/10))) % @VP_AMPLITUD))/100 ) - 0.10 )
															)
	WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO

	-- ===================================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_GASTO_M00_SUMAR_X_K_PLAN_GASTO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_PLAN_GASTO
	-- ===================================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_GASTO_DECIMALES_X_K_PLAN_GASTO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_PLAN_GASTO			
	-- ===================================================
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_PLAN_GASTO_CLONAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_PLAN_GASTO_CLONAR]
GO


CREATE PROCEDURE [dbo].[PG_PR_PLAN_GASTO_CLONAR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================			
	@PP_K_PLAN_GASTO			INT,
	@PP_K_UNIDAD_OPERATIVA		INT
AS

	DECLARE	@VP_K_PLAN_GASTO_NEW		INT

	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'PLAN_GASTO', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_PLAN_GASTO_NEW			OUTPUT
	-- ================================

	DECLARE	@VP_D_PLAN_GASTO		VARCHAR(500)
	
	SET		@VP_D_PLAN_GASTO =		'PLAN_GASTO [#'+CONVERT(VARCHAR(100),@VP_K_PLAN_GASTO_NEW)+'] UO#'+CONVERT(VARCHAR(100),@PP_K_UNIDAD_OPERATIVA)+'/YYYY#2018'		

	DECLARE	@VP_C_PLAN_GASTO		VARCHAR(500)
	
	SET		@VP_C_PLAN_GASTO =		'QA/CI [#'+CONVERT(VARCHAR(100),@VP_K_PLAN_GASTO_NEW)+'] UO#'+CONVERT(VARCHAR(100),@PP_K_UNIDAD_OPERATIVA)+'/YYYY#2018'		
	
	DECLARE	@VP_S_PLAN_GASTO		VARCHAR(500)

	SET		@VP_S_PLAN_GASTO =		'[QA#'+CONVERT(VARCHAR(100),@VP_K_PLAN_GASTO_NEW)+']' 

	-- ================================

	INSERT INTO [PLAN_GASTO]
			(	[K_PLAN_GASTO], 
				[D_PLAN_GASTO], [C_PLAN_GASTO], [S_PLAN_GASTO], [O_PLAN_GASTO], 
				-- ===============================
				[K_UNIDAD_OPERATIVA], 
				[K_ESCENARIO_PLAN], [K_YYYY], [K_ESTATUS_PLAN_GASTO], 
				[L_RECALCULAR], 
				-- ===============================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO], 
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]		)
		SELECT	@VP_K_PLAN_GASTO_NEW, 
				@VP_D_PLAN_GASTO, @VP_C_PLAN_GASTO, @VP_S_PLAN_GASTO, [O_PLAN_GASTO], 
				-- ===============================
				@PP_K_UNIDAD_OPERATIVA, 
				[K_ESCENARIO_PLAN], [K_YYYY], [K_ESTATUS_PLAN_GASTO], 
				[L_RECALCULAR], 
				-- ===============================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL 
	  FROM		[dbo].[PLAN_GASTO]
	  WHERE		K_PLAN_GASTO=@PP_K_PLAN_GASTO			

	-- ===============================================
	
	INSERT INTO [PARTIDA_PLAN_GASTO]
			(	[K_PLAN_GASTO],
				[K_RUBRO_PRESUPUESTO], [K_PROGRAMACION_PARTIDA],
				-- ===============================
				[MONTO_ESTIMADO], [M00_MONTO_ESTIMADO],
				[M01_MONTO_ESTIMADO], [M02_MONTO_ESTIMADO], [M03_MONTO_ESTIMADO], [M04_MONTO_ESTIMADO],
				[M05_MONTO_ESTIMADO], [M06_MONTO_ESTIMADO], [M07_MONTO_ESTIMADO], [M08_MONTO_ESTIMADO],
				[M09_MONTO_ESTIMADO], [M10_MONTO_ESTIMADO], [M11_MONTO_ESTIMADO], [M12_MONTO_ESTIMADO],
				-- ===============================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO], 
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]		)
		SELECT 
				@VP_K_PLAN_GASTO_NEW,
				[K_RUBRO_PRESUPUESTO], [K_PROGRAMACION_PARTIDA],
				-- ===============================
				[MONTO_ESTIMADO], [M00_MONTO_ESTIMADO],
				[M01_MONTO_ESTIMADO], [M02_MONTO_ESTIMADO], [M03_MONTO_ESTIMADO], [M04_MONTO_ESTIMADO],
				[M05_MONTO_ESTIMADO], [M06_MONTO_ESTIMADO], [M07_MONTO_ESTIMADO], [M08_MONTO_ESTIMADO],
				[M09_MONTO_ESTIMADO], [M10_MONTO_ESTIMADO], [M11_MONTO_ESTIMADO], [M12_MONTO_ESTIMADO],
				-- ===============================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL 
		FROM	[dbo].[PARTIDA_PLAN_GASTO]
		WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO			

	-- ===============================================
	
	EXECUTE [dbo].[PG_PR_PARTIDA_PLAN_GASTO_ALEATORIZAR]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@VP_K_PLAN_GASTO_NEW
	-- ===============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_GASTO_AGREGACION]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@VP_K_PLAN_GASTO_NEW
	-- ===============================================

	-- K_ESTATUS_PLAN_GASTO = #1 BASE / #2 WORKING / #3 PREVIO / #4 CERRADO / #5 AUTORIZADO / #6 CANCELADO

	UPDATE	[PLAN_GASTO]
	SET		[K_ESTATUS_PLAN_GASTO] = (K_PLAN_GASTO % 6)+1 


	UPDATE	[PLAN_GASTO]
	SET		[K_ESTATUS_PLAN_GASTO] = 5
	WHERE	(K_PLAN_GASTO % 3)=0 


	-- ===============================================
GO



-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////
