-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			TRASPASO
-- // OPERACION:		LIBERACION / STORED PROCEDURES
-- //////////////////////////////////////////////////////////////
-- // Autor:			DANIEL PORTILLO	ROMERO
-- // Fecha creación:	18/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // [PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EJERCIDO]
-- //////////////////////////////////////////////////////////////

/*
execute [dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EJERCIDO]  1,0,0,15,'2018-01-05',70
*/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EJERCIDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EJERCIDO]
GO
	
CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EJERCIDO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ==============================================	
	@PP_K_UNIDAD_OPERATIVA				INT,
	@PP_F_OPERACION						DATE,
	@PP_K_RUBRO_PRESUPUESTO				INT
	-- ==============================================
AS
	-- ==============================================
	DECLARE @VP_MES AS INTEGER
	DECLARE @VP_SEMANA AS INTEGER
	DECLARE @VP_YYYY AS INTEGER

	SET	@VP_YYYY=YEAR(@PP_F_OPERACION) 
	SET	@VP_MES=MONTH(@PP_F_OPERACION) 

	SELECT	@VP_SEMANA =	N_SEMANA
							FROM	TIEMPO_FECHA
							WHERE	F_TIEMPO_FECHA=@PP_F_OPERACION	

	-- ==============================================	

	DECLARE @VP_K_PRESUPUESTO AS INTEGER	

	EXECUTE [dbo].[PG_RN_PRESUPUESTO_K_X_PARAMETROS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_UNIDAD_OPERATIVA,	@VP_YYYY,	@VP_MES,
														@OU_K_PRESUPUESTO=	@VP_K_PRESUPUESTO	OUTPUT
	
	-- ==============================================
	
	DECLARE @VP_MONTO_SEMANAL_1 AS DECIMAL(19,4)
	
	EXECUTE [dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EJERCIDO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															0,@VP_K_PRESUPUESTO,@PP_K_RUBRO_PRESUPUESTO,
															@PP_K_UNIDAD_OPERATIVA,	@VP_YYYY,	@VP_MES,
															1,	@OU_RESULTADO_VALIDACION=	@VP_MONTO_SEMANAL_1	OUTPUT
	-- ==============================================
	
	DECLARE @VP_MONTO_SEMANAL_2 AS DECIMAL(19,4)
	
	EXECUTE [dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EJERCIDO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															0,@VP_K_PRESUPUESTO,@PP_K_RUBRO_PRESUPUESTO,
															@PP_K_UNIDAD_OPERATIVA,	@VP_YYYY,	@VP_MES,
															2,	@OU_RESULTADO_VALIDACION=	@VP_MONTO_SEMANAL_2	OUTPUT

	-- ==============================================
	
	DECLARE @VP_MONTO_SEMANAL_3 AS DECIMAL(19,4)
	
	EXECUTE [dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EJERCIDO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															0,@VP_K_PRESUPUESTO,@PP_K_RUBRO_PRESUPUESTO,
															@PP_K_UNIDAD_OPERATIVA,	@VP_YYYY,	@VP_MES,
															3,	@OU_RESULTADO_VALIDACION=	@VP_MONTO_SEMANAL_3	OUTPUT

	-- ==============================================
	
	DECLARE @VP_MONTO_SEMANAL_4 AS DECIMAL(19,4)
	
	EXECUTE [dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EJERCIDO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															0,@VP_K_PRESUPUESTO,@PP_K_RUBRO_PRESUPUESTO,
															@PP_K_UNIDAD_OPERATIVA,	@VP_YYYY,	@VP_MES,
															4,	@OU_RESULTADO_VALIDACION=	@VP_MONTO_SEMANAL_4	OUTPUT

	-- ==============================================
	
	DECLARE @VP_MONTO_SEMANAL_5 AS DECIMAL(19,4)
	
	EXECUTE [dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EJERCIDO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															0,@VP_K_PRESUPUESTO,@PP_K_RUBRO_PRESUPUESTO,
															@PP_K_UNIDAD_OPERATIVA,	@VP_YYYY,	@VP_MES,
															5,	@OU_RESULTADO_VALIDACION=	@VP_MONTO_SEMANAL_5	OUTPUT
	

	-- ==============================================
	
	UPDATE PARTIDA_PRESUPUESTO
	SET MES_MONTO_EJERCIDO=(@VP_MONTO_SEMANAL_1+@VP_MONTO_SEMANAL_2+@VP_MONTO_SEMANAL_3+@VP_MONTO_SEMANAL_4+@VP_MONTO_SEMANAL_5),
		W01_MONTO_EJERCIDO=@VP_MONTO_SEMANAL_1,
		W02_MONTO_EJERCIDO=@VP_MONTO_SEMANAL_2,
		W03_MONTO_EJERCIDO=@VP_MONTO_SEMANAL_3,
		W04_MONTO_EJERCIDO=@VP_MONTO_SEMANAL_4,
		W05_MONTO_EJERCIDO=@VP_MONTO_SEMANAL_5
	WHERE K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	AND	K_PRESUPUESTO=@VP_K_PRESUPUESTO
	
	-- ==============================================	

	-- ///////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // [PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EN_PROCESO]
-- //////////////////////////////////////////////////////////////

/*
execute [dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EN_PROCESO]  1,0,0,15,'2018-01-05',70
*/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EN_PROCESO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EN_PROCESO]
GO
	
CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EN_PROCESO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ==============================================	
	@PP_K_UNIDAD_OPERATIVA				INT,
	@PP_F_OPERACION						DATE,
	@PP_K_RUBRO_PRESUPUESTO				INT
	-- ==============================================
AS
	-- ==============================================
	DECLARE @VP_MES AS INTEGER
	DECLARE @VP_SEMANA AS INTEGER
	DECLARE @VP_YYYY AS INTEGER

	SET	@VP_YYYY=YEAR(@PP_F_OPERACION) 
	SET	@VP_MES=MONTH(@PP_F_OPERACION) 

	SELECT	@VP_SEMANA =	N_SEMANA
							FROM	TIEMPO_FECHA
							WHERE	F_TIEMPO_FECHA=@PP_F_OPERACION	

	-- ==============================================	

	DECLARE @VP_K_PRESUPUESTO AS INTEGER	

	EXECUTE [dbo].[PG_RN_PRESUPUESTO_K_X_PARAMETROS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_UNIDAD_OPERATIVA,	@VP_YYYY,	@VP_MES,
														@OU_K_PRESUPUESTO=	@VP_K_PRESUPUESTO	OUTPUT
	
	-- ==============================================
	
	DECLARE @VP_MONTO_SEMANAL_1 AS DECIMAL(19,4)
	
	EXECUTE [dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EN_PROCESO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															0,@VP_K_PRESUPUESTO,@PP_K_RUBRO_PRESUPUESTO,
															@PP_K_UNIDAD_OPERATIVA,	@VP_YYYY,	@VP_MES,
															1,	@OU_RESULTADO_VALIDACION=	@VP_MONTO_SEMANAL_1	OUTPUT
	-- ==============================================
	
	DECLARE @VP_MONTO_SEMANAL_2 AS DECIMAL(19,4)
	
	EXECUTE [dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EN_PROCESO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															0,@VP_K_PRESUPUESTO,@PP_K_RUBRO_PRESUPUESTO,
															@PP_K_UNIDAD_OPERATIVA,	@VP_YYYY,	@VP_MES,
															2,	@OU_RESULTADO_VALIDACION=	@VP_MONTO_SEMANAL_2	OUTPUT

	-- ==============================================
	
	DECLARE @VP_MONTO_SEMANAL_3 AS DECIMAL(19,4)
	
	EXECUTE [dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EN_PROCESO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															0,@VP_K_PRESUPUESTO,@PP_K_RUBRO_PRESUPUESTO,
															@PP_K_UNIDAD_OPERATIVA,	@VP_YYYY,	@VP_MES,
															3,	@OU_RESULTADO_VALIDACION=	@VP_MONTO_SEMANAL_3	OUTPUT

	-- ==============================================
	
	DECLARE @VP_MONTO_SEMANAL_4 AS DECIMAL(19,4)
	
	EXECUTE [dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EN_PROCESO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															0,@VP_K_PRESUPUESTO,@PP_K_RUBRO_PRESUPUESTO,
															@PP_K_UNIDAD_OPERATIVA,	@VP_YYYY,	@VP_MES,
															4,	@OU_RESULTADO_VALIDACION=	@VP_MONTO_SEMANAL_4	OUTPUT

	-- ==============================================
	
	DECLARE @VP_MONTO_SEMANAL_5 AS DECIMAL(19,4)
	
	EXECUTE [dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EN_PROCESO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															0,@VP_K_PRESUPUESTO,@PP_K_RUBRO_PRESUPUESTO,
															@PP_K_UNIDAD_OPERATIVA,	@VP_YYYY,	@VP_MES,
															5,	@OU_RESULTADO_VALIDACION=	@VP_MONTO_SEMANAL_5	OUTPUT
	

	-- ==============================================
	
	UPDATE PARTIDA_PRESUPUESTO
	SET MES_MONTO_EN_PROCESO=(@VP_MONTO_SEMANAL_1+@VP_MONTO_SEMANAL_2+@VP_MONTO_SEMANAL_3+@VP_MONTO_SEMANAL_4+@VP_MONTO_SEMANAL_5),
		W01_MONTO_EN_PROCESO=@VP_MONTO_SEMANAL_1,
		W02_MONTO_EN_PROCESO=@VP_MONTO_SEMANAL_2,
		W03_MONTO_EN_PROCESO=@VP_MONTO_SEMANAL_3,
		W04_MONTO_EN_PROCESO=@VP_MONTO_SEMANAL_4,
		W05_MONTO_EN_PROCESO=@VP_MONTO_SEMANAL_5
	WHERE K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	AND	K_PRESUPUESTO=@VP_K_PRESUPUESTO
	
	-- ==============================================	

	-- ///////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EJERCICIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EJERCICIO]
GO

CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EJERCICIO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ==============================================	
	@PP_K_UNIDAD_OPERATIVA				INT,
	@PP_F_OPERACION						DATE,
	@PP_K_RUBRO_PRESUPUESTO				INT
	-- ==============================================
AS
	-- ==============================================

	DECLARE @VP_MENSAJE					VARCHAR(300) = ''

	-- ==============================================
	
	DECLARE @VP_K_MES					INT
	DECLARE @VP_K_YYYY					INT

	SET	@VP_K_YYYY =	YEAR(@PP_F_OPERACION) 
	SET	@VP_K_MES =		MONTH(@PP_F_OPERACION) 

	IF @PP_L_DEBUG>0
		BEGIN
		PRINT  @VP_K_YYYY
		PRINT  @VP_K_MES
		END
	-- ==============================================

	IF @PP_L_DEBUG>0
		PRINT  '[PG_RN_PRESUPUESTO_K_X_PARAMETROS]'

	DECLARE @VP_K_PRESUPUESTO			INT
	
	EXECUTE [dbo].[PG_RN_PRESUPUESTO_K_X_PARAMETROS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_UNIDAD_OPERATIVA,	@VP_K_YYYY,	@VP_K_MES,
														@OU_K_PRESUPUESTO=	@VP_K_PRESUPUESTO	OUTPUT	

	IF @VP_K_PRESUPUESTO IS NULL
		SET @VP_K_PRESUPUESTO=0

	-- ==============================================	

	IF @VP_K_PRESUPUESTO <> 0	
		BEGIN	

		IF @PP_L_DEBUG>0
			PRINT  '[PG_RN_PARTIDA_PRESUPUESTO_UPDATE]'

		EXECUTE [dbo].[PG_RN_PARTIDA_PRESUPUESTO_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO,
																@OU_RESULTADO_VALIDACION= @VP_MENSAJE	OUTPUT	
		END
	ELSE
		SET @VP_MENSAJE = 'No se encontró el [Presupuesto]'
		
	-- ==============================================

	IF @VP_MENSAJE = ''
		BEGIN

		IF @PP_L_DEBUG>0
			PRINT  '[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EN_PROCESO]'

		EXECUTE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EN_PROCESO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,	@PP_K_USUARIO_ACCION,
																		@PP_K_UNIDAD_OPERATIVA,	@PP_F_OPERACION,@PP_K_RUBRO_PRESUPUESTO	
		-- ==============================================

		IF @PP_L_DEBUG>0
			PRINT  '[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EJERCIDO]'

		EXECUTE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EJERCIDO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,	@PP_K_USUARIO_ACCION,
																		@PP_K_UNIDAD_OPERATIVA,	@PP_F_OPERACION,@PP_K_RUBRO_PRESUPUESTO	
		-- ==============================================

		IF @PP_L_DEBUG>0
			PRINT  '[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_REMANENTE]'

		EXECUTE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_REMANENTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,	@PP_K_USUARIO_ACCION,
																		@PP_K_UNIDAD_OPERATIVA,	@PP_F_OPERACION,@PP_K_RUBRO_PRESUPUESTO			
		-- ==============================================	
		
		IF @PP_L_DEBUG>0
			PRINT  '[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_PORCENTAJE_REMANENTE]'

		EXECUTE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_PORCENTAJE_REMANENTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,	@PP_K_USUARIO_ACCION,
																					@PP_K_UNIDAD_OPERATIVA,	@PP_F_OPERACION,@PP_K_RUBRO_PRESUPUESTO			
		-- ==============================================	
		
		IF @PP_L_DEBUG>0
			PRINT  '[PG_UP_PRESUPUESTO_L_RECALCULAR_SET_1]'

		EXECUTE [dbo].[PG_UP_PRESUPUESTO_L_RECALCULAR_SET_1]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,	@PP_K_USUARIO_ACCION,
																@VP_K_PRESUPUESTO
		-- ==============================================

		IF @PP_L_DEBUG>0
			PRINT  '[PG_UP_PARTIDA_PRESUPUESTO_AGREGACION]'

		EXECUTE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_AGREGACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,	@PP_K_USUARIO_ACCION,
																@VP_K_PRESUPUESTO

		END	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE <> ''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible <Recalcular> el Ejercicio de la Partida del Presupuesto: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Pre.'+CONVERT(VARCHAR(10),@VP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PRESUPUESTO AS CLAVE

	-- ///////////////////////////////////////////


	GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
