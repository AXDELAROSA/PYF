-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PLAN_PRESUPUESTO GASTOS/PLANTA
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	15/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



/*


DELETE FROM  PARTIDA_PLAN_PRESUPUESTO

DELETE FROM  PLAN_PRESUPUESTO

-- =====================================

EXECUTE [dbo].[PG_PR_PLAN_PRESUPUESTO_MASIVO]	1,0,0,	60, -1, -1,		2017, 1

EXECUTE [dbo].[PG_PR_PLAN_PRESUPUESTO_MASIVO]	0,0,0,	50, -1, -1,		2017, 2

EXECUTE [dbo].[PG_PR_PLAN_PRESUPUESTO_MASIVO]	0,0,0,	40, -1, -1,		2018, 1

EXECUTE [dbo].[PG_PR_PLAN_PRESUPUESTO_MASIVO]	1,0,0,	30, -1, -1,		2018, 2

-- =====================================

UPDATE	PLAN_PRESUPUESTO
SET		K_USUARIO_PASO_1=111	-- 111	C.ZAMARRON
WHERE	(K_PLAN_PRESUPUESTO % 5)=1

UPDATE	PLAN_PRESUPUESTO
SET		K_USUARIO_PASO_2=122	-- 122	A.SALGADO
WHERE	(K_PLAN_PRESUPUESTO % 3)=1

UPDATE	PLAN_PRESUPUESTO
SET		K_USUARIO_PASO_3=144	-- 144	T.RUIZ
WHERE	(K_PLAN_PRESUPUESTO % 7)=1

-- =====================================

133	D.PORTILLO
155	U155
166	L.BARRAZA
169	H.GONZALEZ

-- =====================================

SELECT * FROM  PLAN_PRESUPUESTO

SELECT * FROM  PARTIDA_PLAN_PRESUPUESTO

-- =====================================

UPDATE	PARTIDA_PLAN_PRESUPUESTO
SET		K_PROGRAMACION_PARTIDA = 1		-- K_RUBRO_PRESUPUESTO*10)+CONVERT(DECIMAL(19,2),(K_RUBRO_PRESUPUESTO*K_PLAN_PRESUPUESTO)/100.1)
WHERE	K_PLAN_PRESUPUESTO=1
AND		K_RUBRO_PRESUPUESTO<>1


UPDATE	PARTIDA_PLAN_PRESUPUESTO
SET		MONTO_BASE = (K_RUBRO_PRESUPUESTO*10)+CONVERT(DECIMAL(19,2),(K_RUBRO_PRESUPUESTO*K_PLAN_PRESUPUESTO)/100.1)
WHERE	K_PLAN_PRESUPUESTO=1
AND		K_RUBRO_PRESUPUESTO<>1

SELECT * FROM  PARTIDA_PLAN_PRESUPUESTO WHERE	K_PLAN_PRESUPUESTO=1

EXECUTE [dbo].[PG_PR_PARTIDA_PLAN_PRESUPUESTO_RECALCULO] 0,0,0, 1

EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION] 1,0,0, 1



*/


-- //////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PARAMETROS_INIT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PARAMETROS_INIT]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PARAMETROS_INIT]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PLAN_PRESUPUESTO			INT
	-- ===========================
AS		

GO

-- //////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PUSH_AUTORIZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PUSH_AUTORIZADO]
GO



CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PUSH_AUTORIZADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PLAN_PRESUPUESTO			INT
AS		

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	PARTIDA_PLAN_PRESUPUESTO 
		SET		
				-- ===========================
				M01_AUTORIZADO = M01_REVISADO,
				M02_AUTORIZADO = M02_REVISADO,
				M03_AUTORIZADO = M03_REVISADO,
				M04_AUTORIZADO = M04_REVISADO,
				M05_AUTORIZADO = M05_REVISADO,
				M06_AUTORIZADO = M06_REVISADO				
				-- ===========================				
		WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO

		-- ==============================================
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Generar] del [Planes/Presupuesto]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#POV.'+CONVERT(VARCHAR(10),@PP_K_PLAN_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

--	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PLAN_PRESUPUESTO AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PUSH_REVISADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PUSH_REVISADO]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PUSH_REVISADO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PLAN_PRESUPUESTO			INT
AS		

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	PARTIDA_PLAN_PRESUPUESTO 
		SET		
				-- ===========================
				M01_REVISADO = M01_PREVIO,
				M02_REVISADO = M02_PREVIO,
				M03_REVISADO = M03_PREVIO,
				M04_REVISADO = M04_PREVIO,
				M05_REVISADO = M05_PREVIO,
				M06_REVISADO = M06_PREVIO				
				-- ===========================				
		WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO

		-- ==============================================
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Generar] del [Planes/Presupuesto]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#POV.'+CONVERT(VARCHAR(10),@PP_K_PLAN_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

--	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PLAN_PRESUPUESTO AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////

-- EXECUTE [PG_UP_PARTIDA_PLAN_PRESUPUESTO_RECALCULO] 1,0,0, 51, 90


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_RECALCULO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_RECALCULO]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_RECALCULO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PLAN_PRESUPUESTO			INT,
	@PP_K_RUBRO_PRESUPUESTO			INT
	-- ===========================
AS

	DECLARE @VP_K_CALCULO_PARTIDA_PRESUPUESTO	INT
	DECLARE @VP_MONTO_BASE						DECIMAL(19,4)

	SELECT	@VP_K_CALCULO_PARTIDA_PRESUPUESTO =	K_CALCULO_PARTIDA_PRESUPUESTO,
			@VP_MONTO_BASE =					MONTO_BASE
												FROM	PARTIDA_PLAN_PRESUPUESTO 
												WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
												AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO

	IF @PP_L_DEBUG>0
		PRINT @VP_K_CALCULO_PARTIDA_PRESUPUESTO
												
	-- /////////////////////////////////////////////////////
	-- K_CALCULO_PARTIDA_PRESUPUESTO	
	-- 1	X MES
	-- 2	X SEMANA

	IF @VP_K_CALCULO_PARTIDA_PRESUPUESTO=1			-- 1	X MES
		UPDATE	PARTIDA_PLAN_PRESUPUESTO 
		SET		M01_PREVIO = @VP_MONTO_BASE,
				M02_PREVIO = @VP_MONTO_BASE,
				M03_PREVIO = @VP_MONTO_BASE,
				M04_PREVIO = @VP_MONTO_BASE,
				M05_PREVIO = @VP_MONTO_BASE,
				M06_PREVIO = @VP_MONTO_BASE
				-- ===========================				
		WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
		AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	ELSE
		IF @VP_K_CALCULO_PARTIDA_PRESUPUESTO=2			-- 2	X SEMANA
			UPDATE	PARTIDA_PLAN_PRESUPUESTO 
			SET		M01_PREVIO = ( @VP_MONTO_BASE*(	SELECT	SXM.M01_PREVIO 
													FROM	PARTIDA_PLAN_PRESUPUESTO AS SXM 
													WHERE	SXM.K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
													AND		SXM.K_RUBRO_PRESUPUESTO=1 )	),
					M02_PREVIO = ( @VP_MONTO_BASE*(	SELECT	SXM.M02_PREVIO 
													FROM	PARTIDA_PLAN_PRESUPUESTO AS SXM 
													WHERE	SXM.K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
													AND		SXM.K_RUBRO_PRESUPUESTO=1 )	 ),
					M03_PREVIO = ( @VP_MONTO_BASE*(	SELECT	SXM.M03_PREVIO 
													FROM	PARTIDA_PLAN_PRESUPUESTO AS SXM 
													WHERE	SXM.K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
													AND		SXM.K_RUBRO_PRESUPUESTO=1 )	 ),
					M04_PREVIO = ( @VP_MONTO_BASE*(	SELECT	SXM.M04_PREVIO 
													FROM	PARTIDA_PLAN_PRESUPUESTO AS SXM 
													WHERE	SXM.K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
													AND		SXM.K_RUBRO_PRESUPUESTO=1 )	 ),
					M05_PREVIO = ( @VP_MONTO_BASE*(	SELECT	SXM.M05_PREVIO 
													FROM	PARTIDA_PLAN_PRESUPUESTO AS SXM 
													WHERE	SXM.K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
													AND		SXM.K_RUBRO_PRESUPUESTO=1 )	 ),
					M06_PREVIO = ( @VP_MONTO_BASE*(	SELECT	SXM.M06_PREVIO 
													FROM	PARTIDA_PLAN_PRESUPUESTO AS SXM 
													WHERE	SXM.K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
													AND		SXM.K_RUBRO_PRESUPUESTO=1 )	 )
					-- ===========================				
			
			WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
			AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
		ELSE
			UPDATE	PARTIDA_PLAN_PRESUPUESTO 
			SET		M01_PREVIO = 0,
					M02_PREVIO = 0,
					M03_PREVIO = 0,
					M04_PREVIO = 0,
					M05_PREVIO = 0,
					M06_PREVIO = 0
					-- ===========================				
			WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
			AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO

	-- ==============================================
	


	-- //////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////

-- EXECUTE [PG_UP_PARTIDA_PLAN_PRESUPUESTO_RECALCULO] 1,0,0, 51, 90


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_PARTIDA_PLAN_PRESUPUESTO_RECALCULO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_PARTIDA_PLAN_PRESUPUESTO_RECALCULO]
GO


CREATE PROCEDURE [dbo].[PG_PR_PARTIDA_PLAN_PRESUPUESTO_RECALCULO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PLAN_PRESUPUESTO			INT
	-- ===========================
AS

	DECLARE CU_RUBRO_PRESUPUESTO_RECALCULO
		CURSOR	LOCAL FOR
				SELECT	K_RUBRO_PRESUPUESTO
				FROM	RUBRO_PRESUPUESTO
				WHERE	K_RUBRO_PRESUPUESTO<>1
					
		-- ========================================

		DECLARE @VP_CU_K_RUBRO_PRESUPUESTO	INT
			
		-- ========================================

		OPEN CU_RUBRO_PRESUPUESTO_RECALCULO

		FETCH NEXT FROM CU_RUBRO_PRESUPUESTO_RECALCULO INTO @VP_CU_K_RUBRO_PRESUPUESTO
		
		-- ==================================
		
		WHILE @@FETCH_STATUS = 0
			BEGIN					
			-- ==================================

			EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_RECALCULO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_PLAN_PRESUPUESTO, @VP_CU_K_RUBRO_PRESUPUESTO
			-- ========================================

			FETCH NEXT FROM CU_RUBRO_PRESUPUESTO_RECALCULO INTO @VP_CU_K_RUBRO_PRESUPUESTO
			
			END

		-- ========================================

		CLOSE		CU_RUBRO_PRESUPUESTO_RECALCULO
		DEALLOCATE	CU_RUBRO_PRESUPUESTO_RECALCULO


	-- ==============================================
	
	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PUSH_REVISADO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_PLAN_PRESUPUESTO			

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PUSH_AUTORIZADO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_PLAN_PRESUPUESTO			
	-- ==============================================

	EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_AGREGACION]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_PLAN_PRESUPUESTO	

		
	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PREVIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PREVIO]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PREVIO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PLAN_PRESUPUESTO			INT,
	@PP_K_RUBRO_PRESUPUESTO			INT,
	-- ===========================
	@PP_M01_SEMANAS					DECIMAL(19,4),
	@PP_M02_SEMANAS					DECIMAL(19,4),
	@PP_M03_SEMANAS					DECIMAL(19,4),
	@PP_M04_SEMANAS					DECIMAL(19,4),
	@PP_M05_SEMANAS					DECIMAL(19,4),
	@PP_M06_SEMANAS					DECIMAL(19,4)
AS		
	-- ==============================================

	UPDATE	PARTIDA_PLAN_PRESUPUESTO 
	SET		M01_PREVIO = @PP_M01_SEMANAS,
			M02_PREVIO = @PP_M02_SEMANAS,
			M03_PREVIO = @PP_M03_SEMANAS,
			M04_PREVIO = @PP_M04_SEMANAS,
			M05_PREVIO = @PP_M05_SEMANAS,
			M06_PREVIO = @PP_M06_SEMANAS
			-- ===========================				
	WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
	AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	
	-- //////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PLAN_PRESUPUESTO_SEMANAS_MES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PLAN_PRESUPUESTO_SEMANAS_MES]
GO


CREATE PROCEDURE [dbo].[PG_UP_PLAN_PRESUPUESTO_SEMANAS_MES]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PLAN_PRESUPUESTO			INT,
	-- ===========================
	@PP_M01_SEMANAS					DECIMAL(19,4),
	@PP_M02_SEMANAS					DECIMAL(19,4),
	@PP_M03_SEMANAS					DECIMAL(19,4),
	@PP_M04_SEMANAS					DECIMAL(19,4),
	@PP_M05_SEMANAS					DECIMAL(19,4),
	@PP_M06_SEMANAS					DECIMAL(19,4)
AS		

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		-- ==============================================

		UPDATE	PARTIDA_PLAN_PRESUPUESTO 
		SET		M01_PREVIO = @PP_M01_SEMANAS,
				M02_PREVIO = @PP_M02_SEMANAS,
				M03_PREVIO = @PP_M03_SEMANAS,
				M04_PREVIO = @PP_M04_SEMANAS,
				M05_PREVIO = @PP_M05_SEMANAS,
				M06_PREVIO = @PP_M06_SEMANAS,
				-- ===========================
				M01_REVISADO = @PP_M01_SEMANAS,
				M02_REVISADO = @PP_M02_SEMANAS,
				M03_REVISADO = @PP_M03_SEMANAS,
				M04_REVISADO = @PP_M04_SEMANAS,
				M05_REVISADO = @PP_M05_SEMANAS,
				M06_REVISADO = @PP_M06_SEMANAS,
				-- ===========================
				M01_AUTORIZADO = @PP_M01_SEMANAS,
				M02_AUTORIZADO = @PP_M02_SEMANAS,
				M03_AUTORIZADO = @PP_M03_SEMANAS,
				M04_AUTORIZADO = @PP_M04_SEMANAS,
				M05_AUTORIZADO = @PP_M05_SEMANAS,
				M06_AUTORIZADO = @PP_M06_SEMANAS
				-- ===========================				
		WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
		AND		K_RUBRO_PRESUPUESTO=1				-- #0001	Semanas Mes

		-- ==============================================

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Generar] del [Planes/Presupuesto]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#POV.'+CONVERT(VARCHAR(10),@PP_K_PLAN_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

--	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PLAN_PRESUPUESTO AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_PARTIDA_PLAN_PRESUPUESTO_X_K_PLAN_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_PARTIDA_PLAN_PRESUPUESTO_X_K_PLAN_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_PR_PARTIDA_PLAN_PRESUPUESTO_X_K_PLAN_PRESUPUESTO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PLAN_PRESUPUESTO			INT
	-- ===========================
AS		

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- ==============================================

		DELETE 
		FROM	PARTIDA_PLAN_PRESUPUESTO
		WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO

		-- ==============================================

		DECLARE CU_RUBRO_PRESUPUESTO
			CURSOR	LOCAL FOR
					SELECT	K_RUBRO_PRESUPUESTO
					FROM	RUBRO_PRESUPUESTO
					
			-- ========================================

			DECLARE @VP_CU_K_RUBRO_PRESUPUESTO	INT
			
			-- ========================================

			OPEN CU_RUBRO_PRESUPUESTO

			FETCH NEXT FROM CU_RUBRO_PRESUPUESTO INTO @VP_CU_K_RUBRO_PRESUPUESTO
		
			-- ==================================
		
			WHILE @@FETCH_STATUS = 0
				BEGIN		
			
				-- ==================================

				INSERT INTO	[dbo].[PARTIDA_PLAN_PRESUPUESTO] 
					(	[K_PLAN_PRESUPUESTO],
						-- ===========================
						[K_RUBRO_PRESUPUESTO],	
						[K_CALCULO_PARTIDA_PRESUPUESTO], [K_PROGRAMACION_PARTIDA],
						-- ===========================
						[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
						[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]		 )		
				VALUES
					(	@PP_K_PLAN_PRESUPUESTO,
						-- ===========================
						@VP_CU_K_RUBRO_PRESUPUESTO,	
						1, 501, -- [K_CALCULO_PARTIDA_PRESUPUESTO], [K_PROGRAMACION_PARTIDA], -- K_PROGRAMACION_PARTIDA	D_PROGRAMACION_PARTIDA 501	W11111
						-- ===========================
						@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
						0, NULL, NULL		)

				-- ========================================

				FETCH NEXT FROM CU_RUBRO_PRESUPUESTO INTO @VP_CU_K_RUBRO_PRESUPUESTO
			
				END

			-- ========================================

			CLOSE		CU_RUBRO_PRESUPUESTO
			DEALLOCATE	CU_RUBRO_PRESUPUESTO

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Generar] del [Planes/Presupuesto]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#POV.'+CONVERT(VARCHAR(10),@PP_K_PLAN_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

--	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PLAN_PRESUPUESTO AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_PLAN_PRESUPUESTO_MASIVO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_PLAN_PRESUPUESTO_MASIVO]
GO


CREATE PROCEDURE [dbo].[PG_PR_PLAN_PRESUPUESTO_MASIVO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_ZONA_UO					INT,
	@PP_K_RAZON_SOCIAL				INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	-- ===========================
	@PP_K_YYYY						INT,
	@PP_K_TEMPORADA					INT
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

	DECLARE @VP_K_PLAN_PRESUPUESTO	INT = 0

	IF @VP_MENSAJE=''
		BEGIN
		
		DECLARE @VP_M01_SEMANAS DECIMAL(19,4)
		DECLARE @VP_M02_SEMANAS DECIMAL(19,4)
		DECLARE @VP_M03_SEMANAS DECIMAL(19,4)
		DECLARE @VP_M04_SEMANAS DECIMAL(19,4)
		DECLARE @VP_M05_SEMANAS DECIMAL(19,4)
		DECLARE @VP_M06_SEMANAS DECIMAL(19,4)
	
		-- ==============================================

		EXECUTE [dbo].[PG_RN_SEMANAS_X_MES_X_YYYY_TEMPORADA]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_YYYY, @PP_K_TEMPORADA,
																@OU_M01_SEMANAS = @VP_M01_SEMANAS	OUTPUT,
																@OU_M02_SEMANAS = @VP_M02_SEMANAS	OUTPUT,
																@OU_M03_SEMANAS = @VP_M03_SEMANAS	OUTPUT,
																@OU_M04_SEMANAS = @VP_M04_SEMANAS	OUTPUT,
																@OU_M05_SEMANAS = @VP_M05_SEMANAS	OUTPUT,
																@OU_M06_SEMANAS = @VP_M06_SEMANAS	OUTPUT
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
			
				DELETE	
				FROM	[PARTIDA_PLAN_PRESUPUESTO] 
				WHERE	[K_PLAN_PRESUPUESTO] IN (	SELECT	K_PLAN_PRESUPUESTO
													FROM	[PLAN_PRESUPUESTO] 
													WHERE	[K_UNIDAD_OPERATIVA]=@VP_CU_K_UNIDAD_OPERATIVA
													AND		[K_YYYY]=@PP_K_YYYY		)

				DELETE	
				FROM	[PLAN_PRESUPUESTO] 
				WHERE	[K_UNIDAD_OPERATIVA]=@VP_CU_K_UNIDAD_OPERATIVA
				AND		[K_YYYY]=@PP_K_YYYY
				AND		[K_TEMPORADA]=@PP_K_TEMPORADA

				-- ==================================

				IF @VP_CU_K_UNIDAD_OPERATIVA>0
					BEGIN
			
					EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																'PLAN_PRESUPUESTO', 
																@OU_K_TABLA_DISPONIBLE = @VP_K_PLAN_PRESUPUESTO		OUTPUT	
					-- ==================================

					INSERT INTO	[dbo].[PLAN_PRESUPUESTO] 
						(	[K_PLAN_PRESUPUESTO],
							-- ===========================
							[K_UNIDAD_OPERATIVA],
							[K_YYYY], [K_TEMPORADA],			
							[K_ESTATUS_PLAN_PRESUPUESTO],
							-- ===========================
							[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
							[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]		 )		
					VALUES
						(	@VP_K_PLAN_PRESUPUESTO, 
							-- ===========================
							@VP_CU_K_UNIDAD_OPERATIVA,
							@PP_K_YYYY, @PP_K_TEMPORADA,			
							1,	-- @VP_K_ESTATUS_PLAN_PRESUPUESTO,
							-- ===========================
							@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
							0, NULL, NULL		)

					-- ========================================

					EXECUTE [dbo].[PG_PR_PARTIDA_PLAN_PRESUPUESTO_X_K_PLAN_PRESUPUESTO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																							@VP_K_PLAN_PRESUPUESTO	

					EXECUTE [dbo].[PG_UP_PLAN_PRESUPUESTO_SEMANAS_MES]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@VP_K_PLAN_PRESUPUESTO,	
																		@VP_M01_SEMANAS, @VP_M02_SEMANAS, @VP_M03_SEMANAS, 
																		@VP_M04_SEMANAS, @VP_M05_SEMANAS, @VP_M06_SEMANAS

					EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PARAMETROS_INIT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																					@VP_K_PLAN_PRESUPUESTO
					-- ========================================
	
					END

				FETCH NEXT FROM CU_UNIDAD_OPERATIVA INTO @VP_CU_K_UNIDAD_OPERATIVA
			
				END

			-- ========================================

			CLOSE		CU_UNIDAD_OPERATIVA
			DEALLOCATE	CU_UNIDAD_OPERATIVA

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Generar] del [Planes/Presupuesto]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#POV.'+CONVERT(VARCHAR(10),@VP_K_PLAN_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PLAN_PRESUPUESTO AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_PLAN_PRESUPUESTO_X_UNO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_PLAN_PRESUPUESTO_X_UNO]
GO


CREATE PROCEDURE [dbo].[PG_PR_PLAN_PRESUPUESTO_X_UNO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_UNIDAD_OPERATIVA			INT,
	-- ===========================
	@PP_K_YYYY						INT,
	@PP_K_TEMPORADA					INT
	-- ===========================
AS		

	DECLARE @VP_K_ZONA_UO			INT = -1
	DECLARE @VP_K_RAZON_SOCIAL		INT = -1

	EXECUTE [dbo].[PG_PR_PLAN_PRESUPUESTO_MASIVO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@VP_K_ZONA_UO, @VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA,
													@PP_K_YYYY, @PP_K_TEMPORADA

	-- //////////////////////////////////////////////////////////////
GO





-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
