-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			INSTRUCCION / AUTOMATIZACION X TRASPASO
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	25/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO]
GO	


CREATE PROCEDURE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_F_MOVIMIENTO_FLUJO_DIARIO	DATE, 
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_RUBRO_FLUJO				INT
AS

	DELETE	
	FROM	MOVIMIENTO_FLUJO_DIARIO	
	WHERE	@PP_F_MOVIMIENTO_FLUJO_DIARIO=F_MOVIMIENTO_FLUJO_DIARIO 
	AND		@PP_K_UNIDAD_OPERATIVA=K_UNIDAD_OPERATIVA
	AND		@PP_K_RUBRO_FLUJO=K_RUBRO_FLUJO
	AND		K_TIPO_MOVIMIENTO_FLUJO_DIARIO IN ( 0, 3, 4, 5 )

	-- ===========================================

	DECLARE @VP_K_TIPO_MOVIMIENTO_FLUJO_DIARIO		INT = 0		-- TITULO
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

	EXECUTE [dbo].[PG_RN_CUENTA_CONCENTRADORA_X_K_UNIDAD_OPERATIVA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_UNIDAD_OPERATIVA,
																		@OU_K_CUENTA_BANCO = @VP_K_CUENTA_BANCO		OUTPUT
	IF @PP_K_RUBRO_FLUJO IN ( 010, 100 )
		BEGIN

		SELECT @VP_REFERENCIA_1 =	D_CUENTA_BANCO
									FROM	CUENTA_BANCO
									WHERE	K_CUENTA_BANCO=@VP_K_CUENTA_BANCO
		END

	-- ===============================

	DECLARE @VP_D_RUBRO_FLUJO			VARCHAR(100)

	SELECT	@VP_D_RUBRO_FLUJO =			D_RUBRO_FLUJO
										FROM	RUBRO_FLUJO
										WHERE	K_RUBRO_FLUJO=@PP_K_RUBRO_FLUJO

	SET @VP_BENEFICIARIO = @VP_D_RUBRO_FLUJO

	-- ============================================

	DECLARE @VP_K_MOVIMIENTO_FLUJO_DIARIO			INT
	
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

	-- //////////////////////////////////////////////////////////////
	
	IF @PP_K_RUBRO_FLUJO=010
		SET	@VP_K_TIPO_MOVIMIENTO_FLUJO_DIARIO	= 5		-- SALDO INICIAL
	ELSE
		IF @PP_K_RUBRO_FLUJO=100
			SET	@VP_K_TIPO_MOVIMIENTO_FLUJO_DIARIO	= 4		-- SALDO FINAL
		ELSE
			SET	@VP_K_TIPO_MOVIMIENTO_FLUJO_DIARIO	= 3		-- SUBTOTAL


	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'MOVIMIENTO_FLUJO_DIARIO', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_MOVIMIENTO_FLUJO_DIARIO			OUTPUT
	-- ================================

	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_MOVIMIENTO_FLUJO_DIARIO, 999999999, @PP_F_MOVIMIENTO_FLUJO_DIARIO, 
														@VP_K_TIPO_MOVIMIENTO_FLUJO_DIARIO, @VP_K_ESTATUS_MOVIMIENTO_FLUJO_DIARIO,
														@PP_K_RUBRO_FLUJO, @VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA,
														@VP_K_CUENTA_BANCO,
														@VP_BENEFICIARIO, @VP_REFERENCIA_1, @VP_REFERENCIA_2,
														@VP_MONTO, @VP_CARGO, @VP_ABONO, @VP_SALDO_FINAL,
														@VP_F_DOCUMENTO,
														@VP_K_FACTURA_CXP, @VP_K_TRASPASO, @VP_K_INSTRUCCION

	-- //////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO_TODOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO_TODOS]
GO	


CREATE PROCEDURE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO_TODOS]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_TRASPASO					INT, 
	@PP_F_MOVIMIENTO_FLUJO_DIARIO	DATE, 
	@PP_K_INSTRUCCION				INT,
	@PP_K_UNIDAD_OPERATIVA			INT
AS

	-- ///////////////////////////////////////////////////////////		WIWI
	-- K_RUBRO_FLUJO	#010 SALDO INICIAL		#020 INGRESO			#030 GAS
	--					#040 FLETE				#050 OBLIGACIONES		#060 NOMINA
	--					#070 CXP				#080 TRASPASOS			#090 GASTO CORPORATIVO
	--					#100 SALDO FINAL

	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, 010
	-- ===============================
	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, 020
	-- ===============================
	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, 040
	-- ===============================
	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, 050
	-- ===============================
	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, 090
	-- ===============================
	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, 100
	-- ===============================

GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_X_K_TRASPASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_X_K_TRASPASO]
GO	


CREATE PROCEDURE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_X_K_TRASPASO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_TRASPASO					INT, 
	@PP_F_MOVIMIENTO_FLUJO_DIARIO	DATE, 
	@PP_K_INSTRUCCION				INT,
	@PP_K_UNIDAD_OPERATIVA			INT
AS
	-- ============================================
	
	IF @PP_L_DEBUG>0
		BEGIN
		PRINT	'============================ [PG_IN_MOVIMIENTO_FLUJO_DIARIO_X_K_TRASPASO]'
	--	PRINT	'@PP_K_MOVIMIENTO_FLUJO_DIARIO = '+CONVERT(VARCHAR(100),@PP_K_MOVIMIENTO_FLUJO_DIARIO)
		END

	-- ============================================

	DECLARE @VP_K_TIPO_MOVIMIENTO_FLUJO_DIARIO		INT = 2		-- EGRESO
	DECLARE @VP_K_ESTATUS_MOVIMIENTO_FLUJO_DIARIO	INT = 1
	-- ============================================
	DECLARE @VP_K_RAZON_SOCIAL			INT = 0
	-- ============================================
	DECLARE @VP_BENEFICIARIO			VARCHAR(100)		-- OK >> SQL
	DECLARE @VP_REFERENCIA_1			VARCHAR(500)		-- OK >> SQL
	DECLARE @VP_REFERENCIA_2			VARCHAR(500)		-- OK >> SQL
	-- ============================================
	DECLARE @VP_MONTO					DECIMAL(19,4) = 0
	DECLARE @VP_CARGO					DECIMAL(19,4) = 0
	DECLARE @VP_ABONO					DECIMAL(19,4) = 0
	DECLARE @VP_SALDO_FINAL				DECIMAL(19,4) = 0
	-- ============================================
	DECLARE @VP_F_DOCUMENTO				DATE	-- OK >> SQL
	DECLARE @VP_K_FACTURA_CXP			INT 

	-- ============================================
	
	DECLARE @VP_K_UNIDAD_OPERATIVA		INT
	DECLARE @VP_S_UNIDAD_OPERATIVA		VARCHAR(100)
	DECLARE @VP_K_RUBRO_PADRE			INT
	
	SELECT	@VP_K_UNIDAD_OPERATIVA =	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA,
			@VP_S_UNIDAD_OPERATIVA =	S_UNIDAD_OPERATIVA,
			@VP_BENEFICIARIO =			D_UNIDAD_OPERATIVA,
			@VP_K_RAZON_SOCIAL =		K_RAZON_SOCIAL,
			@VP_MONTO = 				MONTO_APLICAR,
			@VP_ABONO =					MONTO_APLICAR,
			@VP_REFERENCIA_2 =			D_RUBRO_PRESUPUESTO,
			@VP_K_RUBRO_PADRE =			K_RUBRO_PADRE,
			@VP_F_DOCUMENTO =			F_OPERACION
										FROM	TRASPASO, UNIDAD_OPERATIVA, RUBRO_PRESUPUESTO
										WHERE	TRASPASO.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
										AND		TRASPASO.K_RUBRO_PRESUPUESTO=RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO
										AND		TRASPASO.K_TRASPASO=@PP_K_TRASPASO
	-- ===============================
	
	DECLARE @VP_K_CUENTA_BANCO			INT 

	EXECUTE [dbo].[PG_RN_CUENTA_CONCENTRADORA_X_K_UNIDAD_OPERATIVA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@VP_K_UNIDAD_OPERATIVA,
																		@OU_K_CUENTA_BANCO = @VP_K_CUENTA_BANCO		OUTPUT
	-- ===============================

	DECLARE @VP_K_RUBRO_FLUJO			INT = 080	-- TRASPASOS

	IF	@VP_K_RUBRO_PADRE IN ( 40, 50, 80 )
		SET @VP_K_RUBRO_FLUJO = 060	-- #060 NOMINA
	ELSE
		SET @VP_K_RUBRO_FLUJO = 080	-- #080 TRASPASOS
	
	-- ===============================
	
	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, @VP_K_RUBRO_FLUJO
	-- ===============================
	
	SET @VP_REFERENCIA_1 = @VP_S_UNIDAD_OPERATIVA + ' [#TRA.'+CONVERT(VARCHAR(10),@PP_K_TRASPASO)+']'  
	
	SET	@VP_REFERENCIA_2 = @VP_REFERENCIA_2 +' [+$'+CONVERT(VARCHAR(100),CONVERT(DECIMAL(19,2),@VP_ABONO))+'] '
											+ 'AL <'+ CONVERT(VARCHAR(100),@VP_F_DOCUMENTO)+'>'

	-- ============================================

	DECLARE @VP_K_MOVIMIENTO_FLUJO_DIARIO			INT
	
	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'MOVIMIENTO_FLUJO_DIARIO', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_MOVIMIENTO_FLUJO_DIARIO			OUTPUT
	-- ================================

	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_MOVIMIENTO_FLUJO_DIARIO, @VP_K_MOVIMIENTO_FLUJO_DIARIO, @PP_F_MOVIMIENTO_FLUJO_DIARIO, 
														@VP_K_TIPO_MOVIMIENTO_FLUJO_DIARIO, @VP_K_ESTATUS_MOVIMIENTO_FLUJO_DIARIO,
														@VP_K_RUBRO_FLUJO, @VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA,
														@VP_K_CUENTA_BANCO,
														@VP_BENEFICIARIO, @VP_REFERENCIA_1, @VP_REFERENCIA_2,
														@VP_MONTO, @VP_CARGO, @VP_ABONO, @VP_SALDO_FINAL,
														@VP_F_DOCUMENTO,
														@VP_K_FACTURA_CXP, @PP_K_TRASPASO, @PP_K_INSTRUCCION

	-- ///////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_UP_MOVIMIENTO_FLUJO_DIARIO_SUBTOTAL_SECCION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, 
																	@VP_K_RUBRO_FLUJO

	-- ///////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APG_IN_MOVIMIENTO_FLUJO_DIARIO_X_K_TRASPASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[APG_IN_MOVIMIENTO_FLUJO_DIARIO_X_K_TRASPASO]
GO	


CREATE PROCEDURE [dbo].[APG_IN_MOVIMIENTO_FLUJO_DIARIO_X_K_TRASPASO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_TRASPASO					INT, 
	@PP_F_MOVIMIENTO_FLUJO_DIARIO	DATE, 
	@PP_K_INSTRUCCION				INT,
	@PP_K_UNIDAD_OPERATIVA			INT
AS

	DECLARE @VP_K_MOVIMIENTO_FLUJO_DIARIO			INT
	
	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'MOVIMIENTO_FLUJO_DIARIO', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_MOVIMIENTO_FLUJO_DIARIO			OUTPUT
	-- ================================

	DECLARE @VP_K_TIPO_MOVIMIENTO_FLUJO_DIARIO		INT = 2		-- EGRESO
	DECLARE @VP_K_ESTATUS_MOVIMIENTO_FLUJO_DIARIO	INT = 1
	-- ============================================
	DECLARE @VP_K_RAZON_SOCIAL			INT = 0
	-- ============================================
	DECLARE @VP_BENEFICIARIO			VARCHAR(100)		-- OK >> SQL
	DECLARE @VP_REFERENCIA_1			VARCHAR(500)		-- OK >> SQL
	DECLARE @VP_REFERENCIA_2			VARCHAR(500)		-- OK >> SQL
	-- ============================================
	DECLARE @VP_MONTO					DECIMAL(19,4) = 0
	DECLARE @VP_CARGO					DECIMAL(19,4) = 0
	DECLARE @VP_ABONO					DECIMAL(19,4) = 0
	DECLARE @VP_SALDO_FINAL				DECIMAL(19,4) = 0
	-- ============================================
	DECLARE @VP_F_DOCUMENTO				DATE	-- OK >> SQL
	DECLARE @VP_K_FACTURA_CXP			INT 

	-- ============================================
	
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
	-- ===============================

	DECLARE @VP_K_RUBRO_FLUJO			INT = 080	-- TRASPASOS

	IF	@VP_K_RUBRO_PADRE IN ( 40, 50, 80 )
		SET @VP_K_RUBRO_FLUJO = 060	-- #060 NOMINA
	ELSE
		SET @VP_K_RUBRO_FLUJO = 080	-- #080 TRASPASOS
	
	-- ===============================
	
	SET @VP_REFERENCIA_1 = @VP_S_UNIDAD_OPERATIVA + ' [#TRA.'+CONVERT(VARCHAR(10),@PP_K_TRASPASO)+']'  
	
	SET	@VP_REFERENCIA_2 = @VP_REFERENCIA_2 +' [+$'+CONVERT(VARCHAR(100),CONVERT(DECIMAL(19,2),@VP_ABONO))+'] '
											+ 'AL <'+ CONVERT(VARCHAR(100),@VP_F_DOCUMENTO)+'>'

	-- ============================================

	DECLARE @VP_K_CUENTA_BANCO			INT = 0

	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_MOVIMIENTO_FLUJO_DIARIO, @VP_K_MOVIMIENTO_FLUJO_DIARIO, @PP_F_MOVIMIENTO_FLUJO_DIARIO, 
														@VP_K_TIPO_MOVIMIENTO_FLUJO_DIARIO, @VP_K_ESTATUS_MOVIMIENTO_FLUJO_DIARIO,
														@VP_K_RUBRO_FLUJO, @VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA,
														@VP_K_CUENTA_BANCO,
														@VP_BENEFICIARIO, @VP_REFERENCIA_1, @VP_REFERENCIA_2,
														@VP_MONTO, @VP_CARGO, @VP_ABONO, @VP_SALDO_FINAL,
														@VP_F_DOCUMENTO,
														@VP_K_FACTURA_CXP, @PP_K_TRASPASO, @PP_K_INSTRUCCION

	-- //////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_INSTRUCCION_REFERENCIA_2_X_K_TRASPASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_INSTRUCCION_REFERENCIA_2_X_K_TRASPASO]
GO	


CREATE PROCEDURE [dbo].[PG_UP_INSTRUCCION_REFERENCIA_2_X_K_TRASPASO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_INSTRUCCION		INT,
	@PP_K_TRASPASO			INT
AS
	-- ===================================

	DECLARE @VP_REFERENCIA_2			VARCHAR(100)
	DECLARE @VP_MONTO_APLICAR			DECIMAL(19,4)

	SELECT	@VP_REFERENCIA_2 =			D_RUBRO_PRESUPUESTO,
			@VP_MONTO_APLICAR =			MONTO_APLICAR
										FROM	TRASPASO, RUBRO_PRESUPUESTO
										WHERE	TRASPASO.K_RUBRO_PRESUPUESTO=RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO
										AND		TRASPASO.K_TRASPASO=@PP_K_TRASPASO
	-- ================================
	
	IF @VP_REFERENCIA_2 IS NULL
		SET @VP_REFERENCIA_2 = ''

	-- ================================
	
	UPDATE	INSTRUCCION
	SET		REFERENCIA_2 = LEFT((REFERENCIA_2 + ' [+$'+CONVERT(VARCHAR(100),CONVERT(DECIMAL(19,2),@VP_MONTO_APLICAR))+'] ' + @VP_REFERENCIA_2),500)
	WHERE	K_INSTRUCCION=@PP_K_INSTRUCCION
	
		-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_INSTRUCCION_TOTALIZAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_INSTRUCCION_TOTALIZAR]
GO	


CREATE PROCEDURE [dbo].[PG_UP_INSTRUCCION_TOTALIZAR]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_INSTRUCCION		INT
AS
	-- ===================================

	DECLARE @VP_MONTO_INSTRUCCION			DECIMAL(19,4)

	SELECT	@VP_MONTO_INSTRUCCION =			SUM(MONTO)
											FROM	DETALLE_INSTRUCCION
											WHERE	K_INSTRUCCION=@PP_K_INSTRUCCION
	-- ===================================
	
	IF @VP_MONTO_INSTRUCCION IS NULL
		SET @VP_MONTO_INSTRUCCION = 0

	-- ===================================

	UPDATE	INSTRUCCION
	SET		MONTO_INSTRUCCION = @VP_MONTO_INSTRUCCION
	WHERE	K_INSTRUCCION=@PP_K_INSTRUCCION
				
	-- //////////////////////////////////////////////////////////////
GO






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_DETALLE_INSTRUCCION_X_K_TRASPASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_DETALLE_INSTRUCCION_X_K_TRASPASO]
GO	


CREATE PROCEDURE [dbo].[PG_IN_DETALLE_INSTRUCCION_X_K_TRASPASO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_INSTRUCCION		INT,
	@PP_K_TRASPASO			INT
AS

	DECLARE @VP_K_FACTURA_CXP	INT = NULL

	-- ===========================================

	DECLARE @VP_MONTO			DECIMAL(19,4)

	SELECT	@VP_MONTO =			MONTO_APLICAR
								FROM	TRASPASO
								WHERE	K_TRASPASO=@PP_K_TRASPASO

	-- ===========================================
	IF @VP_MONTO>0
		BEGIN

		DECLARE @VP_K_DETALLE_INSTRUCCION		INT

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
														'DETALLE_INSTRUCCION', 
														@OU_K_TABLA_DISPONIBLE = @VP_K_DETALLE_INSTRUCCION			OUTPUT
		-- ===========================================

		EXECUTE [dbo].[PG_IN_DETALLE_INSTRUCCION_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_DETALLE_INSTRUCCION, @PP_K_INSTRUCCION, 
														@PP_K_TRASPASO, @VP_K_FACTURA_CXP,
														@VP_MONTO
		-- ===========================================
		END
				
	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_GET_PARAMETROS_X_K_TRASPASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_GET_PARAMETROS_X_K_TRASPASO] 
GO	


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_GET_PARAMETROS_X_K_TRASPASO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_TRASPASO			INT,
	@PP_F_INSTRUCCION		DATE,
	-- ===========================
	@OU_K_CUENTA_BANCO					INT				OUTPUT,
	@OU_BENEFICIARIO					VARCHAR(100)	OUTPUT,
	@OU_REFERENCIA_1					VARCHAR(500)	OUTPUT,
	@OU_REFERENCIA_2					VARCHAR(500)	OUTPUT,
	@OU_MONTO_INSTRUCCION				DECIMAL(19,4)	OUTPUT
AS
	-- =============================

	DECLARE @VP_BENEFICIARIO			VARCHAR(100) = ''
	DECLARE @VP_REFERENCIA_1			VARCHAR(500) = ''
	DECLARE @VP_REFERENCIA_2			VARCHAR(500) = ''
	DECLARE @VP_MONTO_INSTRUCCION		DECIMAL(19,4) 

	DECLARE @VP_F_OPERACION				DATE 

	-- ===============================
	
	DECLARE @VP_K_UNIDAD_OPERATIVA		INT
	DECLARE @VP_S_UNIDAD_OPERATIVA		VARCHAR(500) 
	DECLARE @VP_D_UNIDAD_OPERATIVA		VARCHAR(500) 
	
	SELECT	@VP_K_UNIDAD_OPERATIVA =	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA,
			@VP_S_UNIDAD_OPERATIVA =	S_UNIDAD_OPERATIVA,
			@VP_D_UNIDAD_OPERATIVA =	D_UNIDAD_OPERATIVA,
			@VP_MONTO_INSTRUCCION =		MONTO_APLICAR,
			@VP_REFERENCIA_1 =			D_RUBRO_PRESUPUESTO,
			@VP_F_OPERACION =			F_OPERACION
										FROM	TRASPASO, UNIDAD_OPERATIVA, RUBRO_PRESUPUESTO
										WHERE	TRASPASO.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
										AND		TRASPASO.K_RUBRO_PRESUPUESTO=RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO
										AND		TRASPASO.K_TRASPASO=@PP_K_TRASPASO
	-- ===============================
	
	DECLARE @VP_K_CUENTA_BANCO			INT 

	EXECUTE [dbo].[PG_RN_CUENTA_CONCENTRADORA_X_K_UNIDAD_OPERATIVA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@VP_K_UNIDAD_OPERATIVA,
																		@OU_K_CUENTA_BANCO = @VP_K_CUENTA_BANCO		OUTPUT
	-- ===============================

	SET @VP_BENEFICIARIO = @VP_D_UNIDAD_OPERATIVA
	
	SET @VP_REFERENCIA_1 = 'TRASPASO - ' + @VP_S_UNIDAD_OPERATIVA +' ['+ CONVERT(VARCHAR(100),@VP_F_OPERACION)+']'

	SET	@VP_REFERENCIA_2 = 'AUTO (X_K_TRASPASO) = '
	
	-- ===============================

	SET @OU_K_CUENTA_BANCO					=	@VP_K_CUENTA_BANCO				
	SET @OU_BENEFICIARIO					=	@VP_BENEFICIARIO
	SET @OU_REFERENCIA_1					=	@VP_REFERENCIA_1
	SET @OU_REFERENCIA_2					=	@VP_REFERENCIA_2
	SET @OU_MONTO_INSTRUCCION				=	@VP_MONTO_INSTRUCCION

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_INSTRUCCION_X_K_TRASPASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_INSTRUCCION_X_K_TRASPASO]
GO	


CREATE PROCEDURE [dbo].[PG_IN_INSTRUCCION_X_K_TRASPASO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_TRASPASO			INT,
	@PP_F_INSTRUCCION		DATE,
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO	INT,
	@PP_K_UNIDAD_OPERATIVA	INT,
	@OU_K_INSTRUCCION		INT			OUTPUT
AS
	-- ============================

	DECLARE @VP_K_INSTRUCCION		INT
	
	SELECT	@VP_K_INSTRUCCION =		MAX(K_INSTRUCCION)
									FROM	INSTRUCCION
									WHERE	K_RESUMEN_FLUJO_DIARIO_X_UNO=@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO
									AND		F_INSTRUCCION=@PP_F_INSTRUCCION
									AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
	-- ============================
	
	IF @VP_K_INSTRUCCION IS NULL
		BEGIN

		DECLARE @VP_K_TIPO_INSTRUCCION				INT = 101	-- TRASPASO		
		DECLARE @VP_K_ESTATUS_INSTRUCCION			INT = 1
		DECLARE @VP_K_FORMA_INSTRUCCION				INT = 3		-- TRANSFERENCIA
		DECLARE @VP_L_CAPTURA_MANUAL				INT = 0

		-- =============================

		DECLARE @VP_K_RAZON_SOCIAL					INT = 0
		DECLARE @VP_K_PROVEEDOR						INT = 0

		-- =============================

		DECLARE @VP_K_CUENTA_BANCO					INT 
		DECLARE @VP_BENEFICIARIO					VARCHAR(100) 
		DECLARE @VP_REFERENCIA_1					VARCHAR(500) 
		DECLARE @VP_REFERENCIA_2					VARCHAR(500) 
		DECLARE @VP_MONTO_INSTRUCCION				DECIMAL(19,4) 
	
		EXECUTE	[dbo].[PG_RN_INSTRUCCION_GET_PARAMETROS_X_K_TRASPASO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_TRASPASO, @PP_F_INSTRUCCION,
																		@OU_K_CUENTA_BANCO					=	@VP_K_CUENTA_BANCO					OUTPUT,
																		@OU_BENEFICIARIO					=	@VP_BENEFICIARIO					OUTPUT,
																		@OU_REFERENCIA_1					=	@VP_REFERENCIA_1					OUTPUT,
																		@OU_REFERENCIA_2					=	@VP_REFERENCIA_2					OUTPUT,
																		@OU_MONTO_INSTRUCCION				=	@VP_MONTO_INSTRUCCION				OUTPUT
		-- ===========================================

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
														'INSTRUCCION', 
														@OU_K_TABLA_DISPONIBLE = @VP_K_INSTRUCCION			OUTPUT
		-- ===========================================

		EXECUTE [dbo].[PG_IN_INSTRUCCION_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@VP_K_INSTRUCCION, 
												@VP_K_TIPO_INSTRUCCION, @VP_K_ESTATUS_INSTRUCCION, @VP_K_FORMA_INSTRUCCION, 
												@VP_L_CAPTURA_MANUAL,
												@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO,
												@VP_K_CUENTA_BANCO, @PP_F_INSTRUCCION,	
												@VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @VP_K_PROVEEDOR,
												@VP_BENEFICIARIO, @VP_REFERENCIA_1, @VP_REFERENCIA_2, 
												@VP_MONTO_INSTRUCCION
		END

	-- ===================================

	SET @OU_K_INSTRUCCION = @VP_K_INSTRUCCION
	
	-- ==========================================
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////

/*
WIWI

[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO] 0,0,0,	31804462, '03/NOV/2018'

*/


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]
GO	


CREATE PROCEDURE [dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_TRASPASO			INT,
	@PP_F_INSTRUCCION		DATE
AS
	IF @PP_L_DEBUG>0
		BEGIN
		PRINT	'============================ [PG_PR_INSTRUCCION_X_K_TRASPASO]'
		PRINT	'@PP_K_TRASPASO = '+CONVERT(VARCHAR(100),@PP_K_TRASPASO)
		END

	DECLARE @VP_MENSAJE		VARCHAR(300)	= ''

	IF (@PP_K_TRASPASO % 2)=0 
		SET @VP_MENSAJE = ''
	ELSE
		SET @VP_MENSAJE = 'ERROR NO ES DOS'

	-- /////////////////////////////////////////////////////////////////////
		
	DECLARE @VP_F_OPERACION				DATE

	SET		@VP_F_OPERACION =			@PP_F_INSTRUCCION

	-- /////////////////////////////////////////////////////////////////////

	DECLARE @VP_K_UNIDAD_OPERATIVA		INT

	SELECT	@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA
										FROM	TRASPASO
										WHERE	K_TRASPASO=@PP_K_TRASPASO

	-- ==========================================

	DECLARE @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO		INT

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_PREEXISTENCIA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@VP_F_OPERACION, @VP_K_UNIDAD_OPERATIVA,
																			@OU_K_RESUMEN_FLUJO_DIARIO_X_UNO = @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO		OUTPUT
	-- ==========================================

	DECLARE @VP_K_INSTRUCCION	INT

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_IN_INSTRUCCION_X_K_TRASPASO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_TRASPASO, @VP_F_OPERACION,
														@VP_K_RESUMEN_FLUJO_DIARIO_X_UNO, @VP_K_UNIDAD_OPERATIVA,
														@OU_K_INSTRUCCION = @VP_K_INSTRUCCION		OUTPUT
	-- ==========================================

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_IN_DETALLE_INSTRUCCION_X_K_TRASPASO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@VP_K_INSTRUCCION, @PP_K_TRASPASO
	-- ==========================================

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_UP_INSTRUCCION_REFERENCIA_2_X_K_TRASPASO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@VP_K_INSTRUCCION, @PP_K_TRASPASO
	-- ==========================================

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_UP_INSTRUCCION_TOTALIZAR]					@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@VP_K_INSTRUCCION
	-- ==========================================
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO_TODOS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_TRASPASO, @PP_F_INSTRUCCION, @VP_K_INSTRUCCION,
																	@VP_K_UNIDAD_OPERATIVA
-- ==========================================

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_X_K_TRASPASO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_TRASPASO, @PP_F_INSTRUCCION, @VP_K_INSTRUCCION,
																	@VP_K_UNIDAD_OPERATIVA
	
	-- ///////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Generar] la [Instrucción(xTraspaso)]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#TRA.'+CONVERT(VARCHAR(10),@PP_K_TRASPASO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_TRASPASO AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO





-- ///////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////
