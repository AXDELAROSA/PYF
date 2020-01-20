-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PRESUPUESTO GASTOS/PLANTA
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creaci�n:	08/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////






-- ///////////////////////////////////////////////////////////////
-- // 
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_PREVIO_X_K_NIVEL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_PREVIO_X_K_NIVEL]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_PREVIO_X_K_NIVEL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_PLAN_PRESUPUESTO			INT,
	@PP_K_NIVEL_RUBRO_PRESUPUESTO	INT
AS
	IF @PP_L_DEBUG>0
		BEGIN
		PRINT '[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_PREVIO_X_K_NIVEL]'
		PRINT @PP_K_NIVEL_RUBRO_PRESUPUESTO
		END

	-- ==============================================
	
	UPDATE	PARTIDA_PLAN_PRESUPUESTO
	SET		M01_PREVIO = (		SELECT	SUM(Q2PAR.M01_PREVIO) 
								FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
								WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
								AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
								AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M02_PREVIO = (		SELECT	SUM(Q2PAR.M02_PREVIO) 
								FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
								WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
								AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
								AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M03_PREVIO = (		SELECT	SUM(Q2PAR.M03_PREVIO) 
								FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
								WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
								AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
								AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M04_PREVIO =(		SELECT	SUM(Q2PAR.M04_PREVIO) 
								FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
								WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
								AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
								AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M05_PREVIO = (		SELECT	SUM(Q2PAR.M05_PREVIO) 
								FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
								WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
								AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
								AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M06_PREVIO = (		SELECT	SUM(Q2PAR.M06_PREVIO) 
								FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
								WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
								AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
								AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		)
	FROM	PARTIDA_PLAN_PRESUPUESTO AS Q1PAR, RUBRO_PRESUPUESTO AS Q2RUB
	WHERE	Q1PAR.K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
	AND		Q1PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
	AND 	Q2RUB.K_NIVEL_RUBRO_PRESUPUESTO=@PP_K_NIVEL_RUBRO_PRESUPUESTO

	AND		Q2RUB.K_RUBRO_PRESUPUESTO<>1

	-- //////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- // 
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_AUTORIZADO_X_K_NIVEL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_AUTORIZADO_X_K_NIVEL]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_AUTORIZADO_X_K_NIVEL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_PLAN_PRESUPUESTO			INT,
	@PP_K_NIVEL_RUBRO_PRESUPUESTO	INT
AS

	IF @PP_L_DEBUG>0
		BEGIN
		PRINT '[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_AUTORIZADO_X_K_NIVEL]'
		PRINT @PP_K_NIVEL_RUBRO_PRESUPUESTO
		END

	-- ==============================================

	UPDATE	PARTIDA_PLAN_PRESUPUESTO
	SET		M01_AUTORIZADO = (		SELECT	SUM(Q2PAR.M01_AUTORIZADO) 
									FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
									WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
									AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
									AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M02_AUTORIZADO = (		SELECT	SUM(Q2PAR.M02_AUTORIZADO) 
									FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
									WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
									AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
									AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M03_AUTORIZADO = (		SELECT	SUM(Q2PAR.M03_AUTORIZADO) 
									FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
									WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
									AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
									AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M04_AUTORIZADO = (		SELECT	SUM(Q2PAR.M04_AUTORIZADO) 
									FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
									WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
									AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
									AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M05_AUTORIZADO = (		SELECT	SUM(Q2PAR.M05_AUTORIZADO) 
									FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
									WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
									AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
									AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M06_AUTORIZADO = (		SELECT	SUM(Q2PAR.M06_AUTORIZADO) 
									FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
									WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
									AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
									AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		)
	FROM	PARTIDA_PLAN_PRESUPUESTO AS Q1PAR, RUBRO_PRESUPUESTO AS Q2RUB
	WHERE	Q1PAR.K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
	AND		Q1PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
	AND 	Q2RUB.K_NIVEL_RUBRO_PRESUPUESTO=@PP_K_NIVEL_RUBRO_PRESUPUESTO

	AND		Q2RUB.K_RUBRO_PRESUPUESTO<>1


	-- //////////////////////////////////////////////////////////////
GO



-- ///////////////////////////////////////////////////////////////
-- // 
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_REVISADO_X_K_NIVEL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_REVISADO_X_K_NIVEL]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_REVISADO_X_K_NIVEL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_PLAN_PRESUPUESTO			INT,
	@PP_K_NIVEL_RUBRO_PRESUPUESTO	INT
AS

	IF @PP_L_DEBUG>0
		BEGIN
		PRINT '[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_REVISADO_X_K_NIVEL]'
		PRINT @PP_K_NIVEL_RUBRO_PRESUPUESTO
		END

	-- ==============================================
	
	UPDATE	PARTIDA_PLAN_PRESUPUESTO
	SET		M01_REVISADO = (	SELECT	SUM(Q2PAR.M01_REVISADO) 
								FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
								WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
								AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
								AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M02_REVISADO = (	SELECT	SUM(Q2PAR.M02_REVISADO) 
								FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
								WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
								AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
								AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M03_REVISADO  = (	SELECT	SUM(Q2PAR.M03_REVISADO) 
								FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
								WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
								AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
								AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M04_REVISADO = (	SELECT	SUM(Q2PAR.M04_REVISADO) 
								FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
								WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
								AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
								AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M05_REVISADO  = (	SELECT	SUM(Q2PAR.M05_REVISADO) 
								FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
								WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
								AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
								AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		),
			M06_REVISADO  = (	SELECT	SUM(Q2PAR.M06_REVISADO) 
								FROM	PARTIDA_PLAN_PRESUPUESTO AS Q2PAR, RUBRO_PRESUPUESTO AS Q2RUB
								WHERE	Q2PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
								AND		Q2RUB.K_RUBRO_PADRE=Q1PAR.K_RUBRO_PRESUPUESTO
								AND		Q2PAR.K_PLAN_PRESUPUESTO=Q1PAR.K_PLAN_PRESUPUESTO		)
	FROM	PARTIDA_PLAN_PRESUPUESTO AS Q1PAR, RUBRO_PRESUPUESTO AS Q2RUB
	WHERE	Q1PAR.K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
	AND		Q1PAR.K_RUBRO_PRESUPUESTO=Q2RUB.K_RUBRO_PRESUPUESTO
	AND 	Q2RUB.K_NIVEL_RUBRO_PRESUPUESTO=@PP_K_NIVEL_RUBRO_PRESUPUESTO

	AND		Q2RUB.K_RUBRO_PRESUPUESTO<>1

	-- //////////////////////////////////////////////////////////////
GO





-- ///////////////////////////////////////////////////////////////
-- // 
-- ///////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_AUTORIZADO] 0,0,0,  12345

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_AUTORIZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_AUTORIZADO]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_AUTORIZADO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_PLAN_PRESUPUESTO		INT
AS
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_AUTORIZADO_X_K_NIVEL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PLAN_PRESUPUESTO, 4
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_AUTORIZADO_X_K_NIVEL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PLAN_PRESUPUESTO, 3
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_AUTORIZADO_X_K_NIVEL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PLAN_PRESUPUESTO, 2
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_AUTORIZADO_X_K_NIVEL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PLAN_PRESUPUESTO, 1

	-- //////////////////////////////////////////////////////////////
GO



-- ///////////////////////////////////////////////////////////////
-- // 
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_REVISADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_REVISADO]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_REVISADO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_PLAN_PRESUPUESTO		INT
AS
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_REVISADO_X_K_NIVEL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PLAN_PRESUPUESTO, 4
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_REVISADO_X_K_NIVEL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PLAN_PRESUPUESTO, 3
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_REVISADO_X_K_NIVEL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PLAN_PRESUPUESTO, 2
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_REVISADO_X_K_NIVEL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PLAN_PRESUPUESTO, 1

	-- //////////////////////////////////////////////////////////////
GO


-- ///////////////////////////////////////////////////////////////
-- // 
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_PREVIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_PREVIO]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_PREVIO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_PLAN_PRESUPUESTO		INT
AS
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_PREVIO_X_K_NIVEL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PLAN_PRESUPUESTO, 4
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_PREVIO_X_K_NIVEL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PLAN_PRESUPUESTO, 3
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_PREVIO_X_K_NIVEL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PLAN_PRESUPUESTO, 2
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_PREVIO_X_K_NIVEL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PLAN_PRESUPUESTO, 1

	-- //////////////////////////////////////////////////////////////
GO



-- ///////////////////////////////////////////////////////////////
-- // 
-- ///////////////////////////////////////////////////////////////
/*

SELECT	D_RUBRO_PRESUPUESTO, O_RUBRO_PRESUPUESTO AS ORDEN, K_NIVEL_RUBRO_PRESUPUESTO AS NIVEL, 
		'///' AS C,
		PARTIDA_PLAN_PRESUPUESTO.* 
FROM	PARTIDA_PLAN_PRESUPUESTO, RUBRO_PRESUPUESTO 
WHERE	PARTIDA_PLAN_PRESUPUESTO.K_RUBRO_PRESUPUESTO=RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO
AND		K_PRESUPUESTO=3001

*/

-- EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION] 0,0,0, 3001

-- EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION] 0,0,0,  12345



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_PLAN_PRESUPUESTO		INT
AS
	-- ==============================================
	
	UPDATE	PARTIDA_PLAN_PRESUPUESTO
	SET		K_CALCULO_PARTIDA_PRESUPUESTO	= 0,
			K_PROGRAMACION_PARTIDA			= 0,
			MONTO_BASE						= 0
	FROM	RUBRO_PRESUPUESTO
	WHERE	PARTIDA_PLAN_PRESUPUESTO.K_RUBRO_PRESUPUESTO=RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO
	AND		RUBRO_PRESUPUESTO.K_NIVEL_RUBRO_PRESUPUESTO<>5

	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_PREVIO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_PLAN_PRESUPUESTO
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_REVISADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_PLAN_PRESUPUESTO
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION_AUTORIZADO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_PLAN_PRESUPUESTO
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PLAN_PRESUPUESTO_L_RECALCULAR_RESET_0]				@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_PLAN_PRESUPUESTO

	-- //////////////////////////////////////////////////////////
GO









-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_PLAN_PRESUPUESTO_SUMARIZAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_PLAN_PRESUPUESTO_SUMARIZAR]
GO


CREATE PROCEDURE [dbo].[PG_PR_PLAN_PRESUPUESTO_SUMARIZAR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT
	-- ===========================
AS
	
	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////


	IF @VP_MENSAJE=''
		BEGIN
	
		DECLARE CU_PLAN_PRESUPUESTO_SUMARIZAR
		CURSOR	LOCAL FOR
				SELECT	K_PLAN_PRESUPUESTO
				FROM	PLAN_PRESUPUESTO
				WHERE	L_RECALCULAR=1
				
		-- ========================================

		DECLARE @VP_CU_K_PLAN_PRESUPUESTO			INT
			
		-- ========================================

		OPEN CU_PLAN_PRESUPUESTO_SUMARIZAR

		FETCH NEXT FROM CU_PLAN_PRESUPUESTO_SUMARIZAR INTO @VP_CU_K_PLAN_PRESUPUESTO
		
		WHILE @@FETCH_STATUS = 0
			BEGIN		
			-- =========================================
			
			EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@VP_CU_K_PLAN_PRESUPUESTO	
			-- ========================================
	
		    FETCH NEXT FROM CU_PLAN_PRESUPUESTO_SUMARIZAR INTO @VP_CU_K_PLAN_PRESUPUESTO
			
			END

		-- ========================================

		CLOSE		CU_PLAN_PRESUPUESTO_SUMARIZAR
		DEALLOCATE	CU_PLAN_PRESUPUESTO_SUMARIZAR
			
		-- ========================================
		END

	-- /////////////////////////////////////////////////////////////////////
	
		
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Recalcular] la [Presupuesto/Totales]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
--		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PR.'+CONVERT(VARCHAR(10),@PP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
--	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRESUPUESTO AS CLAVE
	
	SELECT	@VP_MENSAJE AS MENSAJE, 0 AS CLAVE
	
	-- ////////////////////////////////////////////////////////////////////
GO


-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////