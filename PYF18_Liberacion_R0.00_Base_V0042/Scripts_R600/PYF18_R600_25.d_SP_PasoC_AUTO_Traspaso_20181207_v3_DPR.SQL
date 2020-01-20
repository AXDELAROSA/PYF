-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:		PYF18_Finanzas
-- // MODULO:				TRASPASO
-- // OPERACION:			LIBERACION / STORED PROCEDURES
-- //////////////////////////////////////////////////////////////
-- // Autor:				HECTOR A. GONZALEZ DE LA FUENTE
-- // Modificador:			DANIEL PORTILLO ROMERO (Por integración de RNs de Control)
-- // Fecha creación:		28/SEP/2018
-- // Fecha modificación:	07/DIC/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////



/*

DELETE FROM TRASPASO



EXECUTE [dbo].[PG_PR_TRASPASO_X_PARAMETROS]		0,0,0,
												51, 2018, 10

EXECUTE [dbo].[PG_PR_TRASPASO_X_PARAMETROS]		0,0,0,
												38, 2018, 05

*/


-- //////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  UPDATE PARTIDA_PRESUPUESTO RESET
-- //////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PRESUPUESTO_RESET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_RESET]
GO

CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_RESET]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_PRESUPUESTO			INT,
	@PP_K_RUBRO_PRESUPUESTO		INT,
	@PP_N_SEMANA				INT
AS
	-- ==================================

	DECLARE @VP_MENSAJE			VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PARTIDA_PRESUPUESTO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- ///////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	PARTIDA_PRESUPUESTO
		SET		[W01_MONTO_ESTIMADO]		= 0,
				[W02_MONTO_ESTIMADO]		= 0,
				[W03_MONTO_ESTIMADO]		= 0,
				[W04_MONTO_ESTIMADO]		= 0,
				[W05_MONTO_ESTIMADO]		= 0,
				[W01_MONTO_EN_PROCESO]		= 0,
				[W02_MONTO_EN_PROCESO]		= 0,
				[W03_MONTO_EN_PROCESO]		= 0,
				[W04_MONTO_EN_PROCESO]		= 0,
				[W05_MONTO_EN_PROCESO]		= 0,
				[W01_MONTO_EJERCIDO]		= 0,
				[W02_MONTO_EJERCIDO]		= 0,
				[W03_MONTO_EJERCIDO]		= 0,
				[W04_MONTO_EJERCIDO]		= 0,
				[W05_MONTO_EJERCIDO]		= 0,
				[W01_MONTO_REMANENTE]		= 0,
				[W02_MONTO_REMANENTE]		= 0,
				[W03_MONTO_REMANENTE]		= 0,
				[W04_MONTO_REMANENTE]		= 0,
				[W05_MONTO_REMANENTE]		= 0,
				[W01_PORCENTAJE_REMANENTE]	= 0,
				[W02_PORCENTAJE_REMANENTE]	= 0,
				[W03_PORCENTAJE_REMANENTE]	= 0,
				[W04_PORCENTAJE_REMANENTE]	= 0,
				[W05_PORCENTAJE_REMANENTE]	= 0
		WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO
		AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO	

		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE <> ''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible <Limpiar> la Partida del Presupuesto: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Pre.'+CONVERT(VARCHAR(10),@PP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRESUPUESTO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO_X_SEMANA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO_X_SEMANA]
GO


CREATE PROCEDURE [dbo].[PG_IN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO_X_SEMANA]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_PRESUPUESTO			INT,
	@PP_K_RUBRO_PRESUPUESTO		INT,
	@PP_N_SEMANA				INT
AS
	-- ==================================

	DECLARE @VP_FECHA_YYYY			INT
	DECLARE @VP_FECHA_MM			INT
	DECLARE @VP_K_UNIDAD_OPERATIVA	INT

	

	SELECT	@VP_FECHA_YYYY =			PRESUPUESTO.K_YYYY,
			@VP_FECHA_MM =				PRESUPUESTO.K_MM,
			@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA
										FROM	PRESUPUESTO
										WHERE	PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
	-- =======================								

	IF NOT ( @VP_FECHA_YYYY IS NULL )
		BEGIN

		DECLARE	@VP_F_LUNES		DATE

		SELECT	@VP_F_LUNES =	F_LUNES
								FROM	TIEMPO_SEMANA	
								WHERE	FECHA_YYYY=@VP_FECHA_YYYY
								AND		K_TIEMPO_MES=@VP_FECHA_MM	
								AND		N_SEMANA=@PP_N_SEMANA
		-- ===================

		DECLARE @VP_K_TRASPASO						INT = 0
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'TRASPASO', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_TRASPASO			OUTPUT	
		-- ==================================
		
		DECLARE @VP_MONTO_ESTIMADO		DECIMAL(19,4)
		
		SELECT	@VP_MONTO_ESTIMADO =	(	CASE	WHEN @PP_N_SEMANA=1	THEN W01_MONTO_ESTIMADO
													WHEN @PP_N_SEMANA=2	THEN W02_MONTO_ESTIMADO
													WHEN @PP_N_SEMANA=3	THEN W03_MONTO_ESTIMADO
													WHEN @PP_N_SEMANA=4	THEN W04_MONTO_ESTIMADO
													WHEN @PP_N_SEMANA=5	THEN W05_MONTO_ESTIMADO
											END		)										
										FROM	PARTIDA_PRESUPUESTO
										WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO
										AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO

		-- ==================================

		IF NOT ( @VP_F_LUNES IS NULL ) AND NOT ( @VP_MONTO_ESTIMADO IS NULL )
			INSERT	INTO TRASPASO
					(	[K_TRASPASO],
						[D_TRASPASO],
						[K_TIPO_TRASPASO], [K_ESTATUS_TRASPASO], [K_CONCEPTO_TRASPASO], [K_RUBRO_PRESUPUESTO],
						-- ===========================
						[L_CAPTURA_MANUAL],
						[F_OPERACION], [K_UNIDAD_OPERATIVA], [C_TRASPASO],
						[MONTO_AUTORIZADO], [MONTO_APLICAR],
						-- ===========================
						[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
						[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
				VALUES	
					(	@VP_K_TRASPASO,
						'[D_TRASPASO]',
			--			[K_TIPO_TRASPASO], [K_ESTATUS_TRASPASO], [K_CONCEPTO_TRASPASO], [K_RUBRO_PRESUPUESTO],
						1,				   3,					 0,						@PP_K_RUBRO_PRESUPUESTO,
						-- ===========================
						0,
						@VP_F_LUNES, @VP_K_UNIDAD_OPERATIVA, '[C_TRASPASO]',
						@VP_MONTO_ESTIMADO, @VP_MONTO_ESTIMADO,
						-- ===========================
						@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
						0, NULL, NULL		)
				
			-- ===========================

			DELETE 
			FROM	TRASPASO
			WHERE	K_TRASPASO=@VP_K_TRASPASO
			AND		MONTO_AUTORIZADO=0

			-- ===========================	
		END

	-- ===================================================================
GO


-- /////////////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  IN TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO INSERT
-- /////////////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO]
GO

CREATE PROCEDURE [dbo].[PG_IN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_PRESUPUESTO			INT,
	@PP_K_RUBRO_PRESUPUESTO		INT
AS

	DECLARE @VP_MENSAJE			VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																				@PP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO,
																				@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- ///////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		EXECUTE [dbo].[PG_IN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO_X_SEMANA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO, 1
		-- ==========================================================

		EXECUTE [dbo].[PG_IN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO_X_SEMANA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO, 2
		-- ==========================================================

		EXECUTE [dbo].[PG_IN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO_X_SEMANA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO, 3
		-- ==========================================================

		EXECUTE [dbo].[PG_IN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO_X_SEMANA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO, 4
		-- ==========================================================

		EXECUTE [dbo].[PG_IN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO_X_SEMANA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																						@PP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO, 5
		-- ==========================================================
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE <> ''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible <Generar> el Traspaso: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Pre.'+CONVERT(VARCHAR(10),@PP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRESUPUESTO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_TRASPASO_GENERAR_X_K_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_TRASPASO_GENERAR_X_K_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_PR_TRASPASO_GENERAR_X_K_PRESUPUESTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_PRESUPUESTO			INT
AS

	DECLARE CU_PARTIDA_PRESUPUESTO
		CURSOR FOR 
			SELECT	K_RUBRO_PRESUPUESTO
			FROM	RUBRO_PRESUPUESTO
			WHERE	K_NIVEL_RUBRO_PRESUPUESTO=5;

	-- ========================================
	
	DECLARE @VP_CU_K_RUBRO_PRESUPUESTO		INT

	OPEN CU_PARTIDA_PRESUPUESTO  
		FETCH NEXT FROM CU_PARTIDA_PRESUPUESTO INTO @VP_CU_K_RUBRO_PRESUPUESTO  

	-- ========================================

	WHILE @@FETCH_STATUS = 0  
		BEGIN  
		
		EXECUTE [dbo].[PG_IN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_PRESUPUESTO, @VP_CU_K_RUBRO_PRESUPUESTO
		-- ========================================

		FETCH NEXT FROM CU_PARTIDA_PRESUPUESTO INTO @VP_CU_K_RUBRO_PRESUPUESTO 
		END 

	-- ========================================

	CLOSE CU_PARTIDA_PRESUPUESTO  

	DEALLOCATE CU_PARTIDA_PRESUPUESTO 

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_TRASPASO X K PRESUPUESTO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_X_K_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_X_K_PRESUPUESTO]
GO

CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_X_K_PRESUPUESTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================			
	@PP_K_PRESUPUESTO			INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(300)		OUTPUT
AS
	DECLARE @VP_MENSAJE AS VARCHAR(300) = ''

	 -- ////////////////////////////////////////////////////

	DECLARE @VP_D_UNIDAD_OPERATIVA		VARCHAR(100)	= ''
	DECLARE @VP_D_MES					VARCHAR(10)		= ''
	DECLARE @VP_K_RAZON_SOCIAL			INT = -1
	DECLARE @VP_K_UNIDAD_OPERATIVA		INT = -1
	DECLARE @VP_K_YYYY					INT = -1
	DECLARE @VP_K_MM					INT = -1

	SELECT	@VP_D_UNIDAD_OPERATIVA =	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA,
			@VP_D_MES =					MES.D_MES,
			@VP_K_UNIDAD_OPERATIVA =	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA,
			@VP_K_RAZON_SOCIAL =		UNIDAD_OPERATIVA.K_RAZON_SOCIAL,
			@VP_K_YYYY =				K_YYYY,
			@VP_K_MM =					K_MM
										FROM	PRESUPUESTO, UNIDAD_OPERATIVA, MES
										WHERE	PRESUPUESTO.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA 
										AND		PRESUPUESTO.K_MM=MES.K_MES 
										AND		PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO

	-- ////////////////////////////////////////////////////

	IF @VP_MENSAJE = ''
		EXECUTE [dbo].[PG_RN_CONTROL_L_04_PPT_GENERAR_TRASPASOS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@VP_K_RAZON_SOCIAL, @VP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																	@PP_K_PRESUPUESTO,
																	@OU_RESULTADO_VALIDACION = @VP_MENSAJE	OUTPUT
	-- ////////////////////////////////////////////////////

	IF @VP_MENSAJE = ''
		BEGIN

		DECLARE @VP_TRASPASOS_GENERADOS		INT = 0
		
		SELECT @VP_TRASPASOS_GENERADOS =	COUNT(K_TRASPASO) 
											FROM	PRESUPUESTO,TRASPASO
											WHERE	PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
											AND		PRESUPUESTO.K_UNIDAD_OPERATIVA=TRASPASO.K_UNIDAD_OPERATIVA
											AND		PRESUPUESTO.K_YYYY=YEAR(TRASPASO.F_OPERACION)
											AND		PRESUPUESTO.K_MM=MONTH(TRASPASO.F_OPERACION)		
											AND		TRASPASO.K_ESTATUS_TRASPASO<>6
											-- 1	BASE	2	PROGRAMADO	3	AUTORIZADO	4	EJECUTADO	5	CONCILIADO	6	CANCELADO
		IF @PP_L_DEBUG>0
			SELECT @PP_K_PRESUPUESTO PRESUPUESTO, @VP_TRASPASOS_GENERADOS AS TRASP_GEN
	-- /////////////////////////////////////////////////////	

		IF @VP_TRASPASOS_GENERADOS>0
			BEGIN
					
			SET		@VP_MENSAJE = 'Existen '+CONVERT(VARCHAR(10),@VP_TRASPASOS_GENERADOS)+' [Traspaso(s)] '
			SET		@VP_MENSAJE = @VP_MENSAJE + 'generado(s) para la [UNO#' +CONVERT(VARCHAR(10),@VP_D_UNIDAD_OPERATIVA)
			SET		@VP_MENSAJE = @VP_MENSAJE + ' del Año #'+CONVERT(VARCHAR(10),@VP_K_YYYY)
			SET		@VP_MENSAJE = @VP_MENSAJE + ', Mes '+CONVERT(VARCHAR(10),@VP_D_MES)
			SET		@VP_MENSAJE = @VP_MENSAJE + ' con estatus distinto de [Cancelado]'

			END

		IF @PP_L_DEBUG>0
			SELECT @VP_MENSAJE MENSAJE_RN

		END

	-- /////////////////////////////////////////////////////

	SET @OU_RESULTADO_VALIDACION = @VP_MENSAJE
	
	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APG_PR_TRASPASO_X_K_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[APG_PR_TRASPASO_X_K_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[APG_PR_TRASPASO_X_K_PRESUPUESTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_PRESUPUESTO			INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	EXECUTE [dbo].[PG_RN_TRASPASO_X_K_PRESUPUESTO]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE,	@PP_K_USUARIO_ACCION,
															@PP_K_PRESUPUESTO, @OU_RESULTADO_VALIDACION	=	@VP_MENSAJE	OUTPUT

	IF @VP_MENSAJE=''
	BEGIN	
		DECLARE @VP_FECHA_YYYY		INT
		DECLARE @VP_FECHA_MM		INT

		SELECT	@VP_FECHA_YYYY =	PRESUPUESTO.K_YYYY,
				@VP_FECHA_MM =		PRESUPUESTO.K_MM
									FROM	PRESUPUESTO
									WHERE	PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
		-- =======================								

		IF NOT ( @VP_FECHA_YYYY IS NULL )
			BEGIN

			DELETE
			FROM	TRASPASO
			WHERE	YEAR(F_OPERACION)=@VP_FECHA_YYYY
			AND		MONTH(F_OPERACION)=@VP_FECHA_MM

			-- ====================================

			DECLARE	@VP_F_LUNES_1		DATE
			DECLARE	@VP_F_LUNES_2		DATE
			DECLARE	@VP_F_LUNES_3		DATE
			DECLARE	@VP_F_LUNES_4		DATE
			DECLARE	@VP_F_LUNES_5		DATE

			SELECT	@VP_F_LUNES_1 =		F_LUNES
										FROM	TIEMPO_SEMANA	
										WHERE	FECHA_YYYY=@VP_FECHA_YYYY
										AND		K_TIEMPO_MES=@VP_FECHA_MM	
										AND		N_SEMANA=1

			SELECT	@VP_F_LUNES_2 =		F_LUNES
										FROM	TIEMPO_SEMANA	
										WHERE	FECHA_YYYY=@VP_FECHA_YYYY
										AND		K_TIEMPO_MES=@VP_FECHA_MM	
										AND		N_SEMANA=2

			SELECT	@VP_F_LUNES_3 =		F_LUNES
										FROM	TIEMPO_SEMANA	
										WHERE	FECHA_YYYY=@VP_FECHA_YYYY
										AND		K_TIEMPO_MES=@VP_FECHA_MM	
										AND		N_SEMANA=3

			SELECT	@VP_F_LUNES_4 =		F_LUNES
										FROM	TIEMPO_SEMANA	
										WHERE	FECHA_YYYY=@VP_FECHA_YYYY
										AND		K_TIEMPO_MES=@VP_FECHA_MM	
										AND		N_SEMANA=4

			SELECT	@VP_F_LUNES_5 =		F_LUNES
										FROM	TIEMPO_SEMANA	
										WHERE	FECHA_YYYY=@VP_FECHA_YYYY
										AND		K_TIEMPO_MES=@VP_FECHA_MM	
										AND		N_SEMANA=5

			-- ====================================
				
			INSERT	INTO TRASPASO
					(	[K_TRASPASO],
						[D_TRASPASO],
						[K_TIPO_TRASPASO], [K_ESTATUS_TRASPASO], [K_CONCEPTO_TRASPASO], [K_RUBRO_PRESUPUESTO],
						-- ===========================
						[L_CAPTURA_MANUAL],
						[F_OPERACION], [K_UNIDAD_OPERATIVA], [C_TRASPASO],
						[MONTO_AUTORIZADO], [MONTO_APLICAR],
						-- ===========================
						[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
						[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
				SELECT	
						((@PP_K_PRESUPUESTO*100000) + (PAR.K_RUBRO_PRESUPUESTO*10) + 1), -- [K_TRASPASO],
						'[D_TRASPASO]',
			--			[K_TIPO_TRASPASO], [K_ESTATUS_TRASPASO], [K_CONCEPTO_TRASPASO], [K_RUBRO_PRESUPUESTO],
						1,				   3,					 0,						PAR.K_RUBRO_PRESUPUESTO,
						-- ===========================
						0,
						@VP_F_LUNES_1, PTO.K_UNIDAD_OPERATIVA, '[C_TRASPASO]',
						PAR.W01_MONTO_ESTIMADO, PAR.W01_MONTO_ESTIMADO,
						-- ===========================
						@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
						0, NULL, NULL 
				FROM	PRESUPUESTO AS PTO, PARTIDA_PRESUPUESTO AS PAR
				WHERE	PTO.K_PRESUPUESTO=PAR.K_PRESUPUESTO
				AND		PTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
				AND		PAR.W01_MONTO_ESTIMADO<>0


			INSERT	INTO TRASPASO
					(	[K_TRASPASO],
						[D_TRASPASO],
						[K_TIPO_TRASPASO], [K_ESTATUS_TRASPASO], [K_CONCEPTO_TRASPASO], [K_RUBRO_PRESUPUESTO],
						-- ===========================
						[L_CAPTURA_MANUAL],
						[F_OPERACION], [K_UNIDAD_OPERATIVA], [C_TRASPASO],
						[MONTO_AUTORIZADO], [MONTO_APLICAR],
						-- ===========================
						[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
						[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
				SELECT	
						((@PP_K_PRESUPUESTO*100000) + (PAR.K_RUBRO_PRESUPUESTO*10) + 2), -- [K_TRASPASO],
						'[D_TRASPASO]',
			--			[K_TIPO_TRASPASO], [K_ESTATUS_TRASPASO], [K_CONCEPTO_TRASPASO], [K_RUBRO_PRESUPUESTO],
						1,				   3,					 0,						PAR.K_RUBRO_PRESUPUESTO,
						-- ===========================
						0,
						@VP_F_LUNES_2, PTO.K_UNIDAD_OPERATIVA, '[C_TRASPASO]',
						PAR.W02_MONTO_ESTIMADO, PAR.W02_MONTO_ESTIMADO,
						-- ===========================
						@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
						0, NULL, NULL 
				FROM	PRESUPUESTO AS PTO, PARTIDA_PRESUPUESTO AS PAR
				WHERE	PTO.K_PRESUPUESTO=PAR.K_PRESUPUESTO
				AND		PTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
				AND		PAR.W02_MONTO_ESTIMADO<>0

			
			INSERT	INTO TRASPASO
					(	[K_TRASPASO],
						[D_TRASPASO],
						[K_TIPO_TRASPASO], [K_ESTATUS_TRASPASO], [K_CONCEPTO_TRASPASO], [K_RUBRO_PRESUPUESTO],
						-- ===========================
						[L_CAPTURA_MANUAL],
						[F_OPERACION], [K_UNIDAD_OPERATIVA], [C_TRASPASO],
						[MONTO_AUTORIZADO], [MONTO_APLICAR],
						-- ===========================
						[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
						[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
				SELECT	
						((@PP_K_PRESUPUESTO*100000) + (PAR.K_RUBRO_PRESUPUESTO*10) + 3), -- [K_TRASPASO],
						'[D_TRASPASO]',
			--			[K_TIPO_TRASPASO], [K_ESTATUS_TRASPASO], [K_CONCEPTO_TRASPASO], [K_RUBRO_PRESUPUESTO],
						1,				   3,					 0,						PAR.K_RUBRO_PRESUPUESTO,
						-- ===========================
						0,
						@VP_F_LUNES_3, PTO.K_UNIDAD_OPERATIVA, '[C_TRASPASO]',
						PAR.W03_MONTO_ESTIMADO, PAR.W03_MONTO_ESTIMADO,
						-- ===========================
						@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
						0, NULL, NULL 
				FROM	PRESUPUESTO AS PTO, PARTIDA_PRESUPUESTO AS PAR
				WHERE	PTO.K_PRESUPUESTO=PAR.K_PRESUPUESTO
				AND		PTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
				AND		PAR.W03_MONTO_ESTIMADO<>0

			
			INSERT	INTO TRASPASO
					(	[K_TRASPASO],
						[D_TRASPASO],
						[K_TIPO_TRASPASO], [K_ESTATUS_TRASPASO], [K_CONCEPTO_TRASPASO], [K_RUBRO_PRESUPUESTO],
						-- ===========================
						[L_CAPTURA_MANUAL],
						[F_OPERACION], [K_UNIDAD_OPERATIVA], [C_TRASPASO],
						[MONTO_AUTORIZADO], [MONTO_APLICAR],
						-- ===========================
						[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
						[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
				SELECT	
						((@PP_K_PRESUPUESTO*100000) + (PAR.K_RUBRO_PRESUPUESTO*10) + 4), -- [K_TRASPASO],
						'[D_TRASPASO]',
			--			[K_TIPO_TRASPASO], [K_ESTATUS_TRASPASO], [K_CONCEPTO_TRASPASO], [K_RUBRO_PRESUPUESTO],
						1,				   3,					 0,						PAR.K_RUBRO_PRESUPUESTO,
						-- ===========================
						0,
						@VP_F_LUNES_4, PTO.K_UNIDAD_OPERATIVA, '[C_TRASPASO]',
						PAR.W04_MONTO_ESTIMADO, PAR.W04_MONTO_ESTIMADO,
						-- ===========================
						@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
						0, NULL, NULL 
				FROM	PRESUPUESTO AS PTO, PARTIDA_PRESUPUESTO AS PAR
				WHERE	PTO.K_PRESUPUESTO=PAR.K_PRESUPUESTO
				AND		PTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
				AND		PAR.W04_MONTO_ESTIMADO<>0



			IF NOT ( @VP_F_LUNES_5 IS NULL )
				INSERT	INTO TRASPASO
						(	[K_TRASPASO],
							[D_TRASPASO],
							[K_TIPO_TRASPASO], [K_ESTATUS_TRASPASO], [K_CONCEPTO_TRASPASO], [K_RUBRO_PRESUPUESTO],
							-- ===========================
							[L_CAPTURA_MANUAL],
							[F_OPERACION], [K_UNIDAD_OPERATIVA], [C_TRASPASO],
							[MONTO_AUTORIZADO], [MONTO_APLICAR],
							-- ===========================
							[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
							[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
					SELECT	
							((@PP_K_PRESUPUESTO*100000) + (PAR.K_RUBRO_PRESUPUESTO*10) + 5), -- [K_TRASPASO],
							'[D_TRASPASO]',
				--			[K_TIPO_TRASPASO], [K_ESTATUS_TRASPASO], [K_CONCEPTO_TRASPASO], [K_RUBRO_PRESUPUESTO],
							1,				   3,					 0,						PAR.K_RUBRO_PRESUPUESTO,
							-- ===========================
							0,
							@VP_F_LUNES_5, PTO.K_UNIDAD_OPERATIVA, '[C_TRASPASO]',
							PAR.W05_MONTO_ESTIMADO, PAR.W05_MONTO_ESTIMADO,
							-- ===========================
							@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
							0, NULL, NULL 
					FROM	PRESUPUESTO AS PTO, PARTIDA_PRESUPUESTO AS PAR
					WHERE	PTO.K_PRESUPUESTO=PAR.K_PRESUPUESTO
					AND		PTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
					AND		PAR.W05_MONTO_ESTIMADO<>0

			END

	END

	-- /////////////////////////////////////////////////////////////////////

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Generar] los [TRASPASOS]: ' + @VP_MENSAJE 
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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_TRASPASO_X_PARAMETROS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_TRASPASO_X_PARAMETROS]
GO


CREATE PROCEDURE [dbo].[PG_PR_TRASPASO_X_PARAMETROS]
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
	
	DECLARE @VP_K_PRESUPUESTO AS INTEGER = 0

	EXECUTE [dbo].[PG_RN_PRESUPUESTO_K_X_PARAMETROS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,	@PP_K_USUARIO_ACCION,
															@PP_K_UNIDAD_OPERATIVA,	@PP_K_YYYY,	@PP_K_MM,
															@OU_K_PRESUPUESTO = @VP_K_PRESUPUESTO		OUTPUT
	-- ================================================

	IF @VP_K_PRESUPUESTO>0  
		BEGIN
		EXECUTE [dbo].[PG_RN_TRASPASO_X_K_PRESUPUESTO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,	@PP_K_USUARIO_ACCION,
															@VP_K_PRESUPUESTO, @OU_RESULTADO_VALIDACION	=	@VP_MENSAJE	OUTPUT

		IF @PP_L_DEBUG>0
			SELECT @VP_MENSAJE MENSAJE_PR

		IF	@VP_MENSAJE=''
			BEGIN
			EXECUTE [dbo].[PG_PR_TRASPASO_GENERAR_X_K_PRESUPUESTO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,	@PP_K_USUARIO_ACCION,
																		@VP_K_PRESUPUESTO	
			END
		END		
	ELSE
		BEGIN
		SET @VP_MENSAJE='El Presupuesto para la UO#'+CONVERT(VARCHAR(3),@PP_K_UNIDAD_OPERATIVA)
		SET @VP_MENSAJE=@VP_MENSAJE+', del Año '+CONVERT(VARCHAR(3),@PP_K_YYYY)
		SET @VP_MENSAJE=@VP_MENSAJE+', del Mes '+CONVERT(VARCHAR(3),@PP_K_MM)
		SET @VP_MENSAJE=@VP_MENSAJE+' No ha sido Generado.'

		IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Generar] los [TRASPASOS]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PRE.'+CONVERT(VARCHAR(10),@VP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END

		END							
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PRESUPUESTO AS CLAVE
	
	-- ////////////////////////////////////////////////////////////////////
GO






-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
