-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PRESUPUESTO GASTOS/PLANTA
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	25/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////








-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_PROGRAMAR_SEMANAS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_PROGRAMAR_SEMANAS]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_PROGRAMAR_SEMANAS]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================			
	@PP_K_PRESUPUESTO			INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(300)		OUTPUT
AS
	
	DECLARE @VP_RESULTADO		VARCHAR(300) = ''	

	 -- ////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_RN_CONTROL_L_03_PPT_PROGRAMAR]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														NULL, NULL, NULL, NULL,	-- @PP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @PP_K_YYYY, @PP_K_MM,
														@PP_K_PRESUPUESTO,
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO	OUTPUT

	 -- ////////////////////////////////////////////////////

	DECLARE @VP_PRESUPUESTO_GENERADO	INTEGER = 0

	SELECT @VP_PRESUPUESTO_GENERADO =	COUNT(K_PROGRAMACION_PARTIDA) 
										FROM	PARTIDA_PRESUPUESTO
										WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO

	IF @VP_PRESUPUESTO_GENERADO<1
		SET @VP_RESULTADO = 'El Presupuesto no tiene Partidas, por lo tanto no pueden programarse semanas'
		
	-- /////////////////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		BEGIN
	
		DECLARE @VP_N_EDITADOS		INTEGER
		
		SELECT	@VP_N_EDITADOS =	COUNT(RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO)
									FROM	PARTIDA_PRESUPUESTO, RUBRO_PRESUPUESTO
									WHERE	PARTIDA_PRESUPUESTO.K_RUBRO_PRESUPUESTO=RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO
									AND		RUBRO_PRESUPUESTO.K_NIVEL_RUBRO_PRESUPUESTO=1 -- grantotal
									AND		PARTIDA_PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
									AND		(	W01_MONTO_ESTIMADO<>0 OR W02_MONTO_ESTIMADO<>0 
											OR	W03_MONTO_ESTIMADO<>0 OR W04_MONTO_ESTIMADO<>0 
											OR	W05_MONTO_ESTIMADO<>0 )	

		-- /////////////////////////////////////////////////////

		IF @VP_N_EDITADOS>0
			SET @VP_RESULTADO = 'Las semanas ya fueron programadas'

		END
	
	-- ===================================

	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PRESUPUESTO_PROGRAMACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_PROGRAMACION]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_PROGRAMACION]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ========================================
	@PP_K_PRESUPUESTO				INT,
	@PP_K_RUBRO_PRESUPUESTO			INT
	-- ========================================
AS

	DECLARE @VP_K_PROGRAMACION_PARTIDA		INT = 0	
	DECLARE @VP_MES_MONTO_ESTIMADO			DECIMAL(19,4) = 0
    
	SELECT	@VP_K_PROGRAMACION_PARTIDA =	K_PROGRAMACION_PARTIDA,
			@VP_MES_MONTO_ESTIMADO =		MES_MONTO_ESTIMADO
											FROM	PARTIDA_PRESUPUESTO
											WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO
											AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	-- =============================== 
    
	DECLARE @VP_W01_MONTO_ESTIMADO			DECIMAL(19,4) = 0
    DECLARE @VP_W02_MONTO_ESTIMADO			DECIMAL(19,4) = 0
    DECLARE @VP_W03_MONTO_ESTIMADO			DECIMAL(19,4) = 0 
    DECLARE @VP_W04_MONTO_ESTIMADO			DECIMAL(19,4) = 0
    DECLARE @VP_W05_MONTO_ESTIMADO			DECIMAL(19,4) = 0

	-- =============================== 
		
	IF NOT ( @VP_K_PROGRAMACION_PARTIDA IS NULL )
		BEGIN		
		
		
		-- K_PROGRAMACION_PARTIDA = #0	W?????
		IF @VP_K_PROGRAMACION_PARTIDA=101		-- K_PROGRAMACION_PARTIDA = 101	W1000-
			SET @VP_W01_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO )

		IF @VP_K_PROGRAMACION_PARTIDA=102		-- K_PROGRAMACION_PARTIDA = 102	W0100-
			SET @VP_W02_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO )
		
		IF @VP_K_PROGRAMACION_PARTIDA=103		-- K_PROGRAMACION_PARTIDA = 103	W0010-
			SET @VP_W03_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO )
		
		IF @VP_K_PROGRAMACION_PARTIDA=104		-- K_PROGRAMACION_PARTIDA = 104	W0001-
			SET @VP_W04_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO )
		
		IF @VP_K_PROGRAMACION_PARTIDA=201		-- K_PROGRAMACION_PARTIDA = 201	W1010-
			BEGIN
			SET @VP_W01_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO/2 )
			SET @VP_W03_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO/2 )			
			END
					
		IF @VP_K_PROGRAMACION_PARTIDA=202		-- K_PROGRAMACION_PARTIDA = 202	W0101-
			BEGIN
			SET @VP_W02_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO/2 )
			SET @VP_W04_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO/2 )			
			END

		
		IF @VP_K_PROGRAMACION_PARTIDA=401		-- K_PROGRAMACION_PARTIDA = 401	W11110
			BEGIN
			SET @VP_W01_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO/4 )
			SET @VP_W02_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO/4 )			
			SET @VP_W03_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO/4 )
			SET @VP_W04_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO/4 )			
			END

		
		IF @VP_K_PROGRAMACION_PARTIDA=501		-- K_PROGRAMACION_PARTIDA = 501	W11111
			BEGIN
			
			DECLARE @VP_N_SEMANAS			INT = 4	
	
			SELECT	@VP_N_SEMANAS =			VI_SEMANA_MAX
											FROM	VI_TIEMPO_MES_SEMANAS, PRESUPUESTO
											WHERE	PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
											AND		PRESUPUESTO.K_YYYY=VI_TIEMPO_MES_SEMANAS.VI_FECHA_YYYY
											AND		PRESUPUESTO.K_MM=VI_TIEMPO_MES_SEMANAS.VI_K_TIEMPO_MES
			IF @VP_N_SEMANAS IS NULL
				SET @VP_N_SEMANAS =4

			SET @VP_W01_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO/@VP_N_SEMANAS )
			SET @VP_W02_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO/@VP_N_SEMANAS )			
			SET @VP_W03_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO/@VP_N_SEMANAS )
			SET @VP_W04_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO/@VP_N_SEMANAS )	

			IF @VP_N_SEMANAS=5
				SET @VP_W05_MONTO_ESTIMADO = ( @VP_MES_MONTO_ESTIMADO/@VP_N_SEMANAS )			
			ELSE
				SET @VP_W05_MONTO_ESTIMADO = ( 0 )			
			
			END

		END

	-- =============================== 

	SET @VP_W01_MONTO_ESTIMADO = CONVERT(DECIMAL(19,2),@VP_W01_MONTO_ESTIMADO)				
	SET @VP_W02_MONTO_ESTIMADO = CONVERT(DECIMAL(19,2),@VP_W02_MONTO_ESTIMADO)
	SET @VP_W03_MONTO_ESTIMADO = CONVERT(DECIMAL(19,2),@VP_W03_MONTO_ESTIMADO)				
	SET @VP_W04_MONTO_ESTIMADO = CONVERT(DECIMAL(19,2),@VP_W04_MONTO_ESTIMADO)
	SET @VP_W05_MONTO_ESTIMADO = CONVERT(DECIMAL(19,2),@VP_W05_MONTO_ESTIMADO)

	-- =============================== 

	UPDATE	[PARTIDA_PRESUPUESTO]
	SET		W01_MONTO_ESTIMADO=@VP_W01_MONTO_ESTIMADO,				
			W02_MONTO_ESTIMADO=@VP_W02_MONTO_ESTIMADO,
			W03_MONTO_ESTIMADO=@VP_W03_MONTO_ESTIMADO,				
			W04_MONTO_ESTIMADO=@VP_W04_MONTO_ESTIMADO,
			W05_MONTO_ESTIMADO=@VP_W05_MONTO_ESTIMADO
	WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO
	AND 	K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
			
	-- =========================================================
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_PRESUPUESTO_PROGRAMAR_SEMANAS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_PRESUPUESTO_PROGRAMAR_SEMANAS]
GO


CREATE PROCEDURE [dbo].[PG_PR_PRESUPUESTO_PROGRAMAR_SEMANAS]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_PRESUPUESTO			INT
AS
	
	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_RN_PRESUPUESTO_PROGRAMAR_SEMANAS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PRESUPUESTO,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		DECLARE CU_PARTIDA_PRESUPUESTO_PROGRAMACION
		CURSOR	LOCAL FOR
				SELECT	K_RUBRO_PRESUPUESTO
				FROM	PARTIDA_PRESUPUESTO
				WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO		
				
		-- ========================================

		DECLARE @VP_CU_K_RUBRO_PRESUPUESTO			INT
			
		-- ========================================

		OPEN CU_PARTIDA_PRESUPUESTO_PROGRAMACION

		FETCH NEXT FROM CU_PARTIDA_PRESUPUESTO_PROGRAMACION INTO @VP_CU_K_RUBRO_PRESUPUESTO
		
		WHILE @@FETCH_STATUS = 0
			BEGIN		
			-- =========================================
			
			EXECUTE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_PROGRAMACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_PRESUPUESTO, @VP_CU_K_RUBRO_PRESUPUESTO	
			-- ========================================

				
		    FETCH NEXT FROM CU_PARTIDA_PRESUPUESTO_PROGRAMACION INTO @VP_CU_K_RUBRO_PRESUPUESTO
			
			END

		-- ========================================

		CLOSE CU_PARTIDA_PRESUPUESTO_PROGRAMACION
		DEALLOCATE CU_PARTIDA_PRESUPUESTO_PROGRAMACION

		-- /////////////////////////////////////////////////////////////////////

		EXECUTE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_AGREGACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_PRESUPUESTO
																
		-- =====================================

		END

	-- /////////////////////////////////////////////////////////////////////
	
		
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Generar] la [Programación/Semanal]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PR.'+CONVERT(VARCHAR(10),@PP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRESUPUESTO AS CLAVE
	

	-- ////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> PG_PR_PRESUPUESTO_PROGRAMAR_SEMANAS_X_PARAMETROS
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_PRESUPUESTO_PROGRAMAR_SEMANAS_X_PARAMETROS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_PRESUPUESTO_PROGRAMAR_SEMANAS_X_PARAMETROS]
GO


CREATE PROCEDURE [dbo].[PG_PR_PRESUPUESTO_PROGRAMAR_SEMANAS_X_PARAMETROS]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_YYYY					INT,	
	@PP_K_MM 					INT
AS
	
	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	DECLARE @VP_K_PRESUPUESTO	INTEGER = 0

	EXECUTE [dbo].[PG_RN_PRESUPUESTO_K_X_PARAMETROS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,	@PP_K_USUARIO_ACCION,
															@PP_K_UNIDAD_OPERATIVA,	@PP_K_YYYY,	@PP_K_MM,
															@OU_K_PRESUPUESTO=@VP_K_PRESUPUESTO	OUTPUT
	-- ==================================================
	
	IF @VP_K_PRESUPUESTO>0	
		EXECUTE [dbo].[PG_PR_PRESUPUESTO_PROGRAMAR_SEMANAS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,	@PP_K_USUARIO_ACCION,
																@VP_K_PRESUPUESTO																
	ELSE
		BEGIN
		
		SET		@VP_K_PRESUPUESTO = 0
		SET		@VP_MENSAJE = 'El presupuesto no ha sido generado.'
		
		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PRESUPUESTO AS CLAVE

		END													
	
	-- ////////////////////////////////////////////////////////////////////
GO









-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
