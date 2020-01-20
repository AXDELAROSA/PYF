-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:		PYF18_Finanzas
-- // MODULO:				INSTRUCCION / AUTOMATIZACION X TRASPASO
-- // OPERACION:			LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:				HECTOR A. GONZALEZ DE LA FUENTE
-- // Modificador:			DANIEL PORTILLO ROMERO (Por integración de RNs de Control)
-- // Fecha creación:		25/OCT/2018
-- // Fecha modificación:	07/DIC/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_MOVIMIENTO_FLUJO_DIARIO_SUBTOTAL_SECCION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_MOVIMIENTO_FLUJO_DIARIO_SUBTOTAL_SECCION]
GO	


CREATE PROCEDURE [dbo].[PG_UP_MOVIMIENTO_FLUJO_DIARIO_SUBTOTAL_SECCION]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_F_MOVIMIENTO_FLUJO_DIARIO	DATE, 
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_RUBRO_FLUJO				INT
AS

	DECLARE @VP_MONTO	DECIMAL(19,4)
	DECLARE @VP_CARGO	DECIMAL(19,4)
	DECLARE @VP_ABONO	DECIMAL(19,4)
	
	-- ===============================================

	SELECT	@VP_MONTO =		SUM(MONTO),
			@VP_CARGO =		SUM(CARGO),
			@VP_ABONO =		SUM(ABONO)
							FROM	MOVIMIENTO_FLUJO_DIARIO
							WHERE	F_MOVIMIENTO_FLUJO_DIARIO=@PP_F_MOVIMIENTO_FLUJO_DIARIO 
							AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
							AND		K_RUBRO_FLUJO=@PP_K_RUBRO_FLUJO	
							AND		K_TIPO_MOVIMIENTO_FLUJO_DIARIO<>3	-- SUBTOTAL
						
	-- ===============================================

	IF @VP_MONTO IS NULL
		BEGIN
		SET @VP_MONTO	= 0
		SET @VP_CARGO	= 0
		SET @VP_ABONO	= 0
		END

	-- ===============================================

	UPDATE	MOVIMIENTO_FLUJO_DIARIO
	SET		MONTO = @VP_MONTO,
			CARGO = @VP_CARGO,
			ABONO = @VP_ABONO 
	WHERE	F_MOVIMIENTO_FLUJO_DIARIO=@PP_F_MOVIMIENTO_FLUJO_DIARIO 
	AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
	AND		K_RUBRO_FLUJO=@PP_K_RUBRO_FLUJO	
	AND		K_TIPO_MOVIMIENTO_FLUJO_DIARIO=3	-- SUBTOTAL

	-- ===============================================
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UP_MOVIMIENTO_FLUJO_DIARIO INGRESOS
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_MOVIMIENTO_FLUJO_DIARIO_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_MOVIMIENTO_FLUJO_DIARIO_SQL]
GO

CREATE PROCEDURE [dbo].[PG_UP_MOVIMIENTO_FLUJO_DIARIO_SQL]
	@PP_L_DEBUG								INT,
	@PP_K_SISTEMA_EXE						INT,
	@PP_K_USUARIO_ACCION					INT,
	-- ====================================
	@PP_K_MOVIMIENTO_FLUJO_DIARIO			INT,
	-- ====================================
	@PP_MONTO								DECIMAL(19,4),
	@PP_CARGO								DECIMAL(19,4)
AS

	IF @PP_L_DEBUG>0
		BEGIN
		PRINT	'============================ [PG_UP_MOVIMIENTO_FLUJO_DIARIO_SQL]'
		PRINT	'@PP_K_MOVIMIENTO_FLUJO_DIARIO = '+CONVERT(VARCHAR(100),@PP_K_MOVIMIENTO_FLUJO_DIARIO)
		END

	-- ==================================================

	UPDATE	[MOVIMIENTO_FLUJO_DIARIO]
	SET		[MONTO] =  @PP_MONTO,
			[CARGO] =  @PP_CARGO,
      		-- ===========================
			[K_USUARIO_CAMBIO] =  @PP_K_USUARIO_ACCION,
			[F_CAMBIO] = GETDATE()
	WHERE	[K_MOVIMIENTO_FLUJO_DIARIO] =  @PP_K_MOVIMIENTO_FLUJO_DIARIO

	-- ==============================================
GO




-- //////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  GENERAR MOVIMIENTO_FLUJO_DIARIO INGRESOS
-- //////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS]
GO

CREATE PROCEDURE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_F_MOVIMIENTO_FLUJO_DIARIO	DATE, 
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_RUBRO_FLUJO				INT,
	@PP_K_TIPO_LIBRO_INGRESOS		INT
AS
	-- ============================================
	
	DECLARE @VP_MENSAJE AS VARCHAR(300) = ''

	-- ============================================

	IF @VP_MENSAJE = ''
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_UNIDAD_OPERATIVA, @PP_F_MOVIMIENTO_FLUJO_DIARIO,
																	@OU_RESULTADO_VALIDACION = @VP_MENSAJE	OUTPUT

	-- ============================================

	IF @VP_MENSAJE = ''
		BEGIN

		DECLARE @VP_K_TIPO_MOVIMIENTO_FLUJO_DIARIO		INT = 1		-- INGRESOS
		DECLARE @VP_K_ESTATUS_MOVIMIENTO_FLUJO_DIARIO	INT = 1

		-- ============================================
		DECLARE @VP_K_RAZON_SOCIAL			INT = 0
		DECLARE @VP_K_CUENTA_BANCO			INT = 0
		-- ============================================
		DECLARE @VP_BENEFICIARIO			VARCHAR(100) = ''	
		DECLARE @VP_REFERENCIA_1			VARCHAR(500) = ''
		DECLARE @VP_REFERENCIA_2			VARCHAR(500) = ''
		-- ============================================
		DECLARE @VP_MONTO					DECIMAL(19,4) = 0
		DECLARE @VP_CARGO					DECIMAL(19,4) = 0
		DECLARE @VP_ABONO					DECIMAL(19,4) = 0
		DECLARE @VP_SALDO_FINAL				DECIMAL(19,4) = 0
		-- ============================================
		DECLARE @VP_F_DOCUMENTO				DATE	-- OK >> SQL
		DECLARE @VP_K_FACTURA_CXP			INT 
		DECLARE @VP_K_TRASPASO				INT 
		DECLARE @VP_K_INSTRUCCION			INT

		SET @VP_F_DOCUMENTO = @PP_F_MOVIMIENTO_FLUJO_DIARIO

		-- ============================================
/*		
		DECLARE @VP_S_UNIDAD_OPERATIVA		VARCHAR(100)
		DECLARE @VP_K_RUBRO_PADRE			INT
		
		SELECT	@VP_S_UNIDAD_OPERATIVA =	S_UNIDAD_OPERATIVA,
				@VP_BENEFICIARIO =			D_UNIDAD_OPERATIVA,
				@VP_K_RAZON_SOCIAL =		K_RAZON_SOCIAL,
				@VP_ABONO =					MONTO_APLICAR,
				@VP_REFERENCIA_2 =			D_RUBRO_PRESUPUESTO,
				@VP_K_RUBRO_PADRE =			K_RUBRO_PADRE,
				@VP_F_DOCUMENTO =			F_OPERACION
											FROM	TRASPASO, UNIDAD_OPERATIVA, RUBRO_PRESUPUESTO
											WHERE	TRASPASO.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
											AND		TRASPASO.K_RUBRO_PRESUPUESTO=RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO
											AND		TRASPASO.K_TRASPASO=@PP_K_TRASPASO
*/

		-- ===============================

		DECLARE @VP_D_TIPO_LIBRO_INGRESOS	VARCHAR(100)

		SELECT @VP_D_TIPO_LIBRO_INGRESOS =	D_TIPO_LIBRO_INGRESOS
											FROM	TIPO_LIBRO_INGRESOS
											WHERE	K_TIPO_LIBRO_INGRESOS=@PP_K_TIPO_LIBRO_INGRESOS

		-- ===============================


		EXECUTE [dbo].[PG_RN_CUENTA_INGRESO_X_K_UNIDAD_OPERATIVA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_UNIDAD_OPERATIVA,
																		@OU_K_CUENTA_BANCO = @VP_K_CUENTA_BANCO		OUTPUT

		SELECT @VP_REFERENCIA_1 =	D_CUENTA_BANCO
									FROM	CUENTA_BANCO
									WHERE	K_CUENTA_BANCO=@VP_K_CUENTA_BANCO

									
		-- ===============================

		DECLARE @VP_D_RUBRO_FLUJO			VARCHAR(100)

		SELECT	@VP_D_RUBRO_FLUJO =			D_RUBRO_FLUJO
											FROM	RUBRO_FLUJO
											WHERE	K_RUBRO_FLUJO=@PP_K_RUBRO_FLUJO

		SET @VP_BENEFICIARIO = @VP_D_TIPO_LIBRO_INGRESOS -- + '// '+ @VP_D_RUBRO_FLUJO

		-- ============================================

		DECLARE @VP_INGRESOS		DECIMAL (19,4)
		
		SELECT	@VP_INGRESOS =		MONTO
									FROM	ACTA_INGRESOS
									WHERE	F_OPERACION=@PP_F_MOVIMIENTO_FLUJO_DIARIO	 
									AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA	
									AND		K_TIPO_LIBRO_INGRESOS=@PP_K_TIPO_LIBRO_INGRESOS		
		IF @VP_INGRESOS IS NULL
			SET @VP_INGRESOS = 0
			SET @VP_MONTO = @VP_INGRESOS
			SET @VP_CARGO = @VP_INGRESOS

		-- ============================================

		DECLARE @VP_K_MOVIMIENTO_FLUJO_DIARIO			INT
		
		SELECT @VP_K_MOVIMIENTO_FLUJO_DIARIO =			K_MOVIMIENTO_FLUJO_DIARIO
														FROM MOVIMIENTO_FLUJO_DIARIO 
														WHERE K_RUBRO_FLUJO = @PP_K_RUBRO_FLUJO
														AND	F_MOVIMIENTO_FLUJO_DIARIO = @PP_F_MOVIMIENTO_FLUJO_DIARIO
														AND	K_TIPO_MOVIMIENTO_FLUJO_DIARIO = @VP_K_TIPO_MOVIMIENTO_FLUJO_DIARIO
														AND	K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA

		-- ============================================

		IF @VP_K_MOVIMIENTO_FLUJO_DIARIO IS NULL -- SI K_MOVIMIENTO_FLUJO_DIARIO NO EXISTE, HACE UN INSERT
			BEGIN
				
			EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
														'MOVIMIENTO_FLUJO_DIARIO', 
														@OU_K_TABLA_DISPONIBLE = @VP_K_MOVIMIENTO_FLUJO_DIARIO			OUTPUT
			-- ================================

			EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_MOVIMIENTO_FLUJO_DIARIO, 0, @PP_F_MOVIMIENTO_FLUJO_DIARIO, 
																@VP_K_TIPO_MOVIMIENTO_FLUJO_DIARIO, @VP_K_ESTATUS_MOVIMIENTO_FLUJO_DIARIO,
																@PP_K_RUBRO_FLUJO, @VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA,
																@VP_K_CUENTA_BANCO,
																@VP_BENEFICIARIO, @VP_REFERENCIA_1, @VP_REFERENCIA_2,
																@VP_MONTO, @VP_CARGO, @VP_ABONO, @VP_SALDO_FINAL,
																@VP_F_DOCUMENTO,
																@VP_K_FACTURA_CXP, @VP_K_TRASPASO, @VP_K_INSTRUCCION
		-- ///////////////////////////////////////////////
			END
		ELSE -- SI K_MOVIMIENTO_FLUJO_DIARIO SI EXISTE, HACE UN UPDATE
			EXECUTE [dbo].[PG_UP_MOVIMIENTO_FLUJO_DIARIO_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_MOVIMIENTO_FLUJO_DIARIO, @VP_MONTO, @VP_CARGO

		END
	-- ///////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible <Crear> el Movimiento de Flujo Diario de Ingreso: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PFD.'+CONVERT(VARCHAR(10),@VP_K_MOVIMIENTO_FLUJO_DIARIO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
			
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_MOVIMIENTO_FLUJO_DIARIO AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO






-- ///////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> IN_MOVIMIENTO_FLUJO_DIARIO INGRESOS TODOS
-- ///////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS_TODOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS_TODOS]
GO

CREATE PROCEDURE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS_TODOS]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_F_MOVIMIENTO_FLUJO_DIARIO	DATE, 
	@PP_K_UNIDAD_OPERATIVA			INT
AS
	-- ///////////////////////////////////////////////////////////
	-- K_RUBRO_FLUJO	#020 INGRESO			
	DECLARE @VP_K_RUBRO_FLUJO	INT = 020

	-- ===============================
	--	K_TIPO_LIBRO_INGRESOS	#101	VENTA CONTADO
	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, 
															@VP_K_RUBRO_FLUJO, 101
	-- ===============================
	--	K_TIPO_LIBRO_INGRESOS	#102	VENTA CREDITO
	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, 
															@VP_K_RUBRO_FLUJO, 102
	-- ===============================
	--	K_TIPO_LIBRO_INGRESOS	#103	COBRANZA
	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, 
															@VP_K_RUBRO_FLUJO, 103
	-- ===============================
	--	K_TIPO_LIBRO_INGRESOS	#104	VENTA VALE/GAS
	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, 
															@VP_K_RUBRO_FLUJO, 104
	-- ===============================
	--	K_TIPO_LIBRO_INGRESOS	#105	VENTA ANTICIPADA
	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, 
															@VP_K_RUBRO_FLUJO, 105
	
	-- ///////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_UP_MOVIMIENTO_FLUJO_DIARIO_SUBTOTAL_SECCION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, 
																	@VP_K_RUBRO_FLUJO

	-- ///////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_INGRESOS_X_FECHA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_INGRESOS_X_FECHA]
GO	


CREATE PROCEDURE [dbo].[PG_PR_INGRESOS_X_FECHA]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_F_INGRESO			DATE
AS

	-- ///////////////////////////////////////////////////////////////
	
	DECLARE CU_UNIDAD_OPERATIVA
		CURSOR	LOCAL FOR
				SELECT	K_UNIDAD_OPERATIVA
				FROM	UNIDAD_OPERATIVA
				WHERE	K_TIPO_UO=10
					
		-- ========================================

		DECLARE @VP_CU_K_UNIDAD_OPERATIVA	INT
			
		-- ========================================

		OPEN CU_UNIDAD_OPERATIVA

		FETCH NEXT FROM CU_UNIDAD_OPERATIVA INTO @VP_CU_K_UNIDAD_OPERATIVA
		
		WHILE @@FETCH_STATUS = 0
			BEGIN		
			-- =========================================
			
			EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS_TODOS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_F_INGRESO, @VP_CU_K_UNIDAD_OPERATIVA

			-- ========================================

		    FETCH NEXT FROM CU_UNIDAD_OPERATIVA INTO @VP_CU_K_UNIDAD_OPERATIVA
			
			END

		-- ========================================

	CLOSE		CU_UNIDAD_OPERATIVA
	DEALLOCATE	CU_UNIDAD_OPERATIVA

	-- //////////////////////////////////////////////////////////////
GO








-- ///////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////
