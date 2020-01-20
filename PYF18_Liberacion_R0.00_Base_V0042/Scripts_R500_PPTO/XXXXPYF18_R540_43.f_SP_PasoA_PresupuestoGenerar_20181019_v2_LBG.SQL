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

/*

DELETE FROM PARTIDA_PRESUPUESTO
DELETE FROM PRESUPUESTO

*/





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_GENERAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_GENERAR]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_GENERAR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================			
	@PP_K_PLAN_GASTO			INT,
	@PP_K_MM					INT,	
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR (300)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_UNIDAD_OPERATIVA		INT
	DECLARE @VP_K_YYYY					INT
	DECLARE @VP_D_UNIDAD_OPERATIVA AS VARCHAR(50)		
	DECLARE @VP_D_MES AS VARCHAR(10)

	SELECT	@VP_K_UNIDAD_OPERATIVA	=	PLAN_GASTO.K_UNIDAD_OPERATIVA,
			@VP_D_UNIDAD_OPERATIVA	=	D_UNIDAD_OPERATIVA,
			@VP_K_YYYY				=	K_YYYY,
			@VP_D_MES				=	D_MES
										FROM	PLAN_GASTO,UNIDAD_OPERATIVA,MES
										WHERE	PLAN_GASTO.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
										AND		MES.K_MES=@PP_K_MM
										AND		K_PLAN_GASTO=@PP_K_PLAN_GASTO
										
	-- ==============================================
	


	DECLARE @VP_K_ESTATUS_PLAN_GASTO		INT = 0
	DECLARE @VP_D_ESTATUS_PLAN_GASTO		VARCHAR(100) = ''

	SELECT	@VP_K_ESTATUS_PLAN_GASTO =		ESTATUS_PLAN_GASTO.K_ESTATUS_PLAN_GASTO,
			@VP_D_ESTATUS_PLAN_GASTO =		ESTATUS_PLAN_GASTO.D_ESTATUS_PLAN_GASTO
											FROM	PLAN_GASTO, ESTATUS_PLAN_GASTO
											WHERE	PLAN_GASTO.K_ESTATUS_PLAN_GASTO=ESTATUS_PLAN_GASTO.K_ESTATUS_PLAN_GASTO
											AND		PLAN_GASTO.K_PLAN_GASTO=@PP_K_PLAN_GASTO
	IF @VP_K_ESTATUS_PLAN_GASTO<>5
		SET @VP_RESULTADO =	'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_PLAN_GASTO)+'-'
							+@VP_D_ESTATUS_PLAN_GASTO+'] del [PlanGasto#'+CONVERT(VARCHAR(10),@PP_K_PLAN_GASTO)+'] no permite generar de presupuesto.'


	IF @VP_RESULTADO=''
		BEGIN
	
		DECLARE @VP_EXISTE_PRESUPUESTO		INT=0
		DECLARE @VP_K_PRESUPUESTO			INT=0

		SELECT	@VP_EXISTE_PRESUPUESTO =	COUNT(PRESUPUESTO.K_PRESUPUESTO)
											FROM	PRESUPUESTO,PLAN_GASTO,ESTATUS_PRESUPUESTO
											WHERE	PRESUPUESTO.K_ESTATUS_PRESUPUESTO=ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO
											AND		PRESUPUESTO.K_YYYY=PLAN_GASTO.K_YYYY
											AND		PRESUPUESTO.K_MM=@PP_K_MM
											AND		PRESUPUESTO.K_UNIDAD_OPERATIVA=PLAN_GASTO.K_UNIDAD_OPERATIVA
											AND		K_PLAN_GASTO=@PP_K_PLAN_GASTO
											AND		PRESUPUESTO.K_ESTATUS_PRESUPUESTO<>6
											--	1	BASE	/2	WORKING	/3	PREVIO	/4	CERRADO	/5	AUTORIZADO	/6	CANCELADO

		IF	@VP_EXISTE_PRESUPUESTO>0
			BEGIN

			DECLARE @VP_MENSAJE AS VARCHAR(300) = ''
	
			SET		@VP_MENSAJE = 'Existen '+CONVERT(VARCHAR(10),@VP_EXISTE_PRESUPUESTO)+' [Presupuesto(s)] '
			SET		@VP_MENSAJE = @VP_MENSAJE + 'generados para [UNO#' +CONVERT(VARCHAR(10),@VP_D_UNIDAD_OPERATIVA)+']'
			SET		@VP_MENSAJE = @VP_MENSAJE + ' del Año#'+CONVERT(VARCHAR(10),@VP_K_YYYY)
			SET		@VP_MENSAJE = @VP_MENSAJE + ' , Mes#'+CONVERT(VARCHAR(10),@VP_D_MES)
			SET		@VP_MENSAJE = @VP_MENSAJE + ' con estatus distinto de [Cancelado].'
	
			SET @VP_RESULTADO =	@VP_MENSAJE
	
			END		


	END
/*

	DECLARE @VP_K_ESTATUS_AUTORIZACION		INT
	DECLARE @VP_D_ESTATUS_AUTORIZACION		VARCHAR(100)
	
	SELECT	@VP_K_ESTATUS_AUTORIZACION =	AUTORIZACION.K_ESTATUS_AUTORIZACION,
			@VP_D_ESTATUS_AUTORIZACION =	ESTATUS_AUTORIZACION.D_ESTATUS_AUTORIZACION
												FROM	AUTORIZACION, ESTATUS_AUTORIZACION
												WHERE	AUTORIZACION.L_BORRADO=0
												AND		AUTORIZACION.K_AUTORIZACION=@PP_K_AUTORIZACION
	-- ==========================

	-- K_ESTATUS_AUTORIZACION	
	-- // 1	BASE   /	2	WORKING		/	3	PREVIO	/	4	CERRADO		/	5	AUTORIZADO	/	6	CANCELADO
	IF @VP_RESULTADO=''
		IF @VP_K_ESTATUS_AUTORIZACION = 4 
			SET @VP_RESULTADO =  'El [Estatus#'+CONVERT(VARCHAR(10),@VP_K_ESTATUS_AUTORIZACION)+'-'+@VP_D_ESTATUS_AUTORIZACION+'] del [Movimiento#'+CONVERT(VARCHAR(10),@PP_K_AUTORIZACION)+'] no lo permite.'
			
*/

	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SK_PRESUPUESTO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_K_X_PARAMETROS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_K_X_PARAMETROS]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_K_X_PARAMETROS]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================			
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_YYYY					INT,	
	@PP_K_MM 					INT,	
	-- ===========================		
	@OU_K_PRESUPUESTO			VARCHAR (300)	OUTPUT
AS
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_PRESUPUESTO		INT
	
	SELECT	@VP_K_PRESUPUESTO =		K_PRESUPUESTO
									FROM	PRESUPUESTO
									WHERE	K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
									AND		K_YYYY=@PP_K_YYYY
									AND		K_MM=@PP_K_MM

	-- /////////////////////////////////////////////////////
	
	SET @OU_K_PRESUPUESTO = @VP_K_PRESUPUESTO

	-- /////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_PR_PRESUPUESTO_GENERAR]	0,0,0,	1030, 8


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_PRESUPUESTO_GENERAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_PRESUPUESTO_GENERAR]
GO


CREATE PROCEDURE [dbo].[PG_PR_PRESUPUESTO_GENERAR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_PLAN_GASTO			INT,
	@PP_K_MM					INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_GENERAR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PLAN_GASTO, @PP_K_MM, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////////
	
	DECLARE @VP_D_UNIDAD_OPERATIVA		VARCHAR(100)
	DECLARE @VP_K_PRESUPUESTO			INT = -1
	DECLARE @VP_K_UNIDAD_OPERATIVA		INT = -1
	DECLARE @VP_K_YYYY					INT = -1

	SELECT	@VP_D_UNIDAD_OPERATIVA =	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA,
			@VP_K_UNIDAD_OPERATIVA =	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA,
			@VP_K_YYYY =				K_YYYY
										FROM	PLAN_GASTO, UNIDAD_OPERATIVA 
										WHERE	PLAN_GASTO.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA 
										AND		PLAN_GASTO.K_PLAN_GASTO=@PP_K_PLAN_GASTO

	IF @VP_MENSAJE=''
		BEGIN

		DELETE
		FROM	PARTIDA_PRESUPUESTO
		WHERE	K_PRESUPUESTO IN (	SELECT	K_PRESUPUESTO
									FROM	PRESUPUESTO
									WHERE	K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA
									AND		K_YYYY=@VP_K_YYYY
									AND		K_MM=@PP_K_MM		)
		
		-- ==============================================

		DELETE
		FROM	PRESUPUESTO
		WHERE	K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA
		AND		K_YYYY=@VP_K_YYYY
		AND		K_MM=@PP_K_MM	

		-- ==============================================
		
		DECLARE @VP_D_PRESUPUESTO			VARCHAR(100) = 'AUTO / PPTO'

		SET		@VP_D_PRESUPUESTO = 'PPTO/GASTO '
		SET		@VP_D_PRESUPUESTO = @VP_D_PRESUPUESTO + '> '+CONVERT(VARCHAR(10),@VP_K_YYYY)+'/'+ RIGHT('00'+CONVERT(VARCHAR(10),@PP_K_MM),2)+' '
		SET		@VP_D_PRESUPUESTO = @VP_D_PRESUPUESTO + '> ' + @VP_D_UNIDAD_OPERATIVA+' '
		SET		@VP_D_PRESUPUESTO = @VP_D_PRESUPUESTO + '[UNO#' +CONVERT(VARCHAR(10),@VP_K_UNIDAD_OPERATIVA)+']'

		DECLARE @VP_C_PRESUPUESTO			VARCHAR(255) = ''

		SET		@VP_C_PRESUPUESTO = 'AUTOPRESUPUESTO PARA '
		SET		@VP_C_PRESUPUESTO = @VP_C_PRESUPUESTO + '[UNO#' +CONVERT(VARCHAR(10),@VP_K_UNIDAD_OPERATIVA)+''
		SET		@VP_C_PRESUPUESTO = @VP_C_PRESUPUESTO + '('+CONVERT(VARCHAR(10),@VP_K_YYYY)+'/'+RIGHT('00'+CONVERT(VARCHAR(10),@PP_K_MM),2)+')'
		SET		@VP_C_PRESUPUESTO = @VP_C_PRESUPUESTO + '] '
		SET		@VP_C_PRESUPUESTO = @VP_C_PRESUPUESTO + 'SEGUN [PGA#' +CONVERT(VARCHAR(10),@PP_K_PLAN_GASTO)+'].'
			
		DECLARE @VP_S_PRESUPUESTO				VARCHAR(10)  = 'AUTO'
		DECLARE @VP_O_PRESUPUESTO				INT = 11

		DECLARE @VP_K_ESTATUS_PRESUPUESTO		INT = 1
		DECLARE @VP_L_RECALCULAR				INT = 1
		
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'PRESUPUESTO', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_PRESUPUESTO			OUTPUT
		-- ======================================
			
		EXECUTE	[dbo].[PG_IN_PRESUPUESTO_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@VP_K_PRESUPUESTO,
													@VP_D_PRESUPUESTO, @VP_C_PRESUPUESTO, @VP_S_PRESUPUESTO, @VP_O_PRESUPUESTO,		
													@VP_K_UNIDAD_OPERATIVA,	
													@VP_K_YYYY, @PP_K_MM, @VP_K_ESTATUS_PRESUPUESTO,
													@VP_L_RECALCULAR	
		-- ======================================

		INSERT INTO [dbo].[PARTIDA_PRESUPUESTO]
			(		K_PRESUPUESTO,			K_RUBRO_PRESUPUESTO, 
					K_PROGRAMACION_PARTIDA, MES_MONTO_ESTIMADO,
					-- ================================
					[K_USUARIO_ALTA], [F_ALTA], 
					[K_USUARIO_CAMBIO], [F_CAMBIO],
					[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  ) 
			SELECT	@VP_K_PRESUPUESTO,		K_RUBRO_PRESUPUESTO, 
					K_PROGRAMACION_PARTIDA, PARTIDA_PLAN_GASTO.M07_MONTO_ESTIMADO,
					-- ================================
					@PP_K_USUARIO_ACCION, GETDATE(), 
					@PP_K_USUARIO_ACCION, GETDATE(),
					0, NULL, NULL 
			FROM	PARTIDA_PLAN_GASTO
			WHERE	K_PLAN_GASTO=@PP_K_PLAN_GASTO

			-- ==============================================		
		END		

	IF @VP_K_PRESUPUESTO<1
		BEGIN	

		EXECUTE [DBO].[PG_RN_PRESUPUESTO_K_X_PARAMETROS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_UNIDAD_OPERATIVA,	@VP_K_YYYY, @PP_K_MM,
																@OU_K_PRESUPUESTO = @VP_K_PRESUPUESTO			OUTPUT
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PRESUPUESTO AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO




	




-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
