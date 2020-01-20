-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			INSTRUCCION / AUTOMATIZACION X FACTURA
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	25/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////





-- ///////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_X_K_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_X_K_FACTURA_CXP]
GO	


CREATE PROCEDURE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_X_K_FACTURA_CXP]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_FACTURA_CXP				INT, 
	@PP_F_MOVIMIENTO_FLUJO_DIARIO	DATE, 
	@PP_K_INSTRUCCION				INT,
	@PP_K_UNIDAD_OPERATIVA			INT
AS
	-- ============================================

	IF @PP_L_DEBUG>0
		BEGIN
		PRINT	'============================ [PG_IN_MOVIMIENTO_FLUJO_DIARIO_X_K_FACTURA_CXP]'
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
	DECLARE @VP_K_TRASPASO				INT 

	-- ============================================
	
	DECLARE @VP_S_UNIDAD_OPERATIVA		VARCHAR(100)
	DECLARE @VP_D_UNIDAD_OPERATIVA		VARCHAR(500) 
	
	DECLARE @VP_SERIE 					VARCHAR(100)
	DECLARE @VP_FOLIO 					VARCHAR(100)
	DECLARE @VP_K_CATEGORIA_PROVEEDOR	INT
	DECLARE @VP_D_CATEGORIA_PROVEEDOR	VARCHAR(100)
	DECLARE @VP_S_TIPO_COMPROBANTE		VARCHAR(100)

	SELECT	@VP_SERIE =					SERIE,
			@VP_FOLIO =					FOLIO,
			@VP_MONTO =					SALDO,
			@VP_ABONO =					SALDO,
			@VP_S_TIPO_COMPROBANTE =	S_TIPO_COMPROBANTE,
			@VP_S_UNIDAD_OPERATIVA =	S_UNIDAD_OPERATIVA,
			@VP_D_UNIDAD_OPERATIVA =	D_UNIDAD_OPERATIVA,
--			@VP_K_RAZON_SOCIAL =		FACTURA_CXP.K_RAZON_SOCIAL,
			@VP_K_RAZON_SOCIAL =		UNIDAD_OPERATIVA.K_RAZON_SOCIAL,
			@VP_D_CATEGORIA_PROVEEDOR = D_CATEGORIA_PROVEEDOR,		-- +' / '+D_PROVEEDOR,
			@VP_K_CATEGORIA_PROVEEDOR = PROVEEDOR.K_CATEGORIA_PROVEEDOR,		-- +' / '+D_PROVEEDOR,
			@VP_F_DOCUMENTO =			F_EMISION,
			@VP_BENEFICIARIO =			D_PROVEEDOR
										FROM	FACTURA_CXP, TIPO_COMPROBANTE,
												UNIDAD_OPERATIVA, 
												PROVEEDOR, CATEGORIA_PROVEEDOR
										WHERE	FACTURA_CXP.K_TIPO_COMPROBANTE=TIPO_COMPROBANTE.K_TIPO_COMPROBANTE
										AND		FACTURA_CXP.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
										AND		FACTURA_CXP.K_PROVEEDOR=PROVEEDOR.K_PROVEEDOR
										AND		PROVEEDOR.K_CATEGORIA_PROVEEDOR=CATEGORIA_PROVEEDOR.K_CATEGORIA_PROVEEDOR
										AND		FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP										
	-- ===============================
	DECLARE @VP_K_RUBRO_FLUJO			INT = 070			-- CXP

	-- K_CATEGORIA_PROVEEDOR = #1 GAS // #2	FLETE
	-- K_RUBRO_FLUJO = #030 GAS // #040 FLETE // #070 CXP
	
	IF @VP_K_CATEGORIA_PROVEEDOR=1
		SET @VP_K_RUBRO_FLUJO = 030	-- #030 GAS
	ELSE
		IF @VP_K_CATEGORIA_PROVEEDOR=2
			SET @VP_K_RUBRO_FLUJO = 040 -- #040 FLETE
		ELSE
			SET @VP_K_RUBRO_FLUJO = 070 -- #070 CXP

	-- ===============================
		
	EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, @VP_K_RUBRO_FLUJO
	-- ===============================
		
--	SET @VP_REFERENCIA_1 = @VP_S_UNIDAD_OPERATIVA + ' [#FAC.'+CONVERT(VARCHAR(10),@PP_K_FACTURA_CXP)+']'  

	SET @VP_REFERENCIA_1 = @VP_S_UNIDAD_OPERATIVA + ' [' + @VP_S_TIPO_COMPROBANTE +'#'+ LTRIM(@VP_SERIE) +'-' + @VP_FOLIO + '] '  
	
--	SET @VP_REFERENCIA_2 = @VP_S_TIPO_COMPROBANTE + ' ' + @VP_REFERENCIA_2 +'#'+ @VP_SERIE +'-' + @VP_FOLIO

	SET	@VP_REFERENCIA_2 = @VP_D_CATEGORIA_PROVEEDOR + ' '
	SET @VP_REFERENCIA_2 = @VP_REFERENCIA_2 + '[+$'+CONVERT(VARCHAR(100),CONVERT(DECIMAL(19,2),@VP_ABONO))+'] '
--	SET @VP_REFERENCIA_2 = @VP_REFERENCIA_2 + @VP_S_TIPO_COMPROBANTE + ' ' +'#'+ @VP_SERIE +'-' + @VP_FOLIO + ' '
	SET @VP_REFERENCIA_2 = @VP_REFERENCIA_2 + 'AL <'+ CONVERT(VARCHAR(100),@VP_F_DOCUMENTO)+'>'

	-- ============================================

	DECLARE @VP_K_CUENTA_BANCO		INT	

	EXECUTE	[dbo].[PG_RN_CUENTA_CONCENTRADORA_X_K_UNIDAD_OPERATIVA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_UNIDAD_OPERATIVA,
																		@OU_K_CUENTA_BANCO = @VP_K_CUENTA_BANCO		OUTPUT
	-- ============================================

	DECLARE @VP_K_MOVIMIENTO_FLUJO_DIARIO		INT
	
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
														@PP_K_FACTURA_CXP, @VP_K_TRASPASO, @PP_K_INSTRUCCION

	-- ///////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_UP_MOVIMIENTO_FLUJO_DIARIO_SUBTOTAL_SECCION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_F_MOVIMIENTO_FLUJO_DIARIO, @PP_K_UNIDAD_OPERATIVA, 
																	@VP_K_RUBRO_FLUJO

	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_INSTRUCCION_REFERENCIA_2_X_K_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_INSTRUCCION_REFERENCIA_2_X_K_FACTURA_CXP]
GO	


CREATE PROCEDURE [dbo].[PG_UP_INSTRUCCION_REFERENCIA_2_X_K_FACTURA_CXP]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_INSTRUCCION		INT,
	@PP_K_FACTURA_CXP		INT
AS
	-- ===================================

	DECLARE @VP_REFERENCIA_2			VARCHAR(100)
	DECLARE @VP_MONTO_APLICAR			DECIMAL(19,4)

	DECLARE @VP_SERIE 		VARCHAR(100)
	DECLARE @VP_FOLIO 		VARCHAR(100)
	
	
	SELECT	@VP_SERIE =					SERIE,
			@VP_FOLIO =					FOLIO,
			@VP_REFERENCIA_2 =			S_TIPO_COMPROBANTE,
			@VP_MONTO_APLICAR =			SALDO
										FROM	FACTURA_CXP, PROVEEDOR, TIPO_COMPROBANTE
										WHERE	FACTURA_CXP.K_PROVEEDOR=PROVEEDOR.K_PROVEEDOR
										AND		FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP
										AND		FACTURA_CXP.K_TIPO_COMPROBANTE=TIPO_COMPROBANTE.K_TIPO_COMPROBANTE
	-- ================================
	
	SET @VP_REFERENCIA_2 =		@VP_REFERENCIA_2 +'#'+ @VP_SERIE +'-' + @VP_FOLIO

	IF @VP_REFERENCIA_2 IS NULL
		SET @VP_REFERENCIA_2 = 0

	-- ================================

	UPDATE	INSTRUCCION
	SET		REFERENCIA_2 = REFERENCIA_2 + ' [+$'+CONVERT(VARCHAR(100),CONVERT(DECIMAL(19,2),@VP_MONTO_APLICAR))+'] ' + @VP_REFERENCIA_2
	WHERE	K_INSTRUCCION=@PP_K_INSTRUCCION
				
	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_DETALLE_INSTRUCCION_X_K_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_DETALLE_INSTRUCCION_X_K_FACTURA_CXP]
GO	


CREATE PROCEDURE [dbo].[PG_IN_DETALLE_INSTRUCCION_X_K_FACTURA_CXP]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_INSTRUCCION		INT,
	@PP_K_FACTURA_CXP		INT
AS

	DECLARE @VP_K_TRASPASO		INT = NULL

	-- ===========================================

	DECLARE @VP_MONTO			DECIMAL(19,4)

	SELECT	@VP_MONTO =			SALDO
								FROM	FACTURA_CXP
								WHERE	K_FACTURA_CXP=@PP_K_FACTURA_CXP

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
														@VP_K_TRASPASO, @PP_K_FACTURA_CXP,
														@VP_MONTO
		-- ===========================================
		END
				
	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_INSTRUCCION_GET_PARAMETROS_X_K_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_INSTRUCCION_GET_PARAMETROS_X_K_FACTURA_CXP] 
GO	


CREATE PROCEDURE [dbo].[PG_RN_INSTRUCCION_GET_PARAMETROS_X_K_FACTURA_CXP]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_FACTURA_CXP		INT,
	@PP_F_INSTRUCCION		DATE,
	-- ===========================
	@OU_K_CUENTA_BANCO					INT				OUTPUT,
	@OU_BENEFICIARIO					VARCHAR(100)	OUTPUT,
	@OU_REFERENCIA_1					VARCHAR(500)	OUTPUT,
	@OU_REFERENCIA_2					VARCHAR(500)	OUTPUT,
	@OU_MONTO_INSTRUCCION				DECIMAL(19,4)	OUTPUT
AS
	-- =============================

	DECLARE @VP_K_CUENTA_BANCO			INT = 0
	DECLARE @VP_BENEFICIARIO			VARCHAR(100) = ''
	DECLARE @VP_REFERENCIA_1			VARCHAR(500) = ''
	DECLARE @VP_REFERENCIA_2			VARCHAR(500) = ''
	DECLARE @VP_MONTO_INSTRUCCION		DECIMAL(19,4) 

	DECLARE @VP_F_OPERACION				DATE 

	-- ===============================

	DECLARE @VP_S_UNIDAD_OPERATIVA		VARCHAR(500) 
	DECLARE @VP_D_UNIDAD_OPERATIVA		VARCHAR(500) 
	
	SELECT	@VP_S_UNIDAD_OPERATIVA =	S_UNIDAD_OPERATIVA,
			@VP_D_UNIDAD_OPERATIVA =	D_UNIDAD_OPERATIVA,
			@VP_MONTO_INSTRUCCION =		SALDO,
			@VP_REFERENCIA_1 =			D_CATEGORIA_PROVEEDOR+' / '+D_PROVEEDOR,
			@VP_F_OPERACION =			F_EMISION,
			@VP_BENEFICIARIO =			D_PROVEEDOR
										FROM	FACTURA_CXP, UNIDAD_OPERATIVA, 
												PROVEEDOR, CATEGORIA_PROVEEDOR
										WHERE	FACTURA_CXP.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
										AND		FACTURA_CXP.K_PROVEEDOR=PROVEEDOR.K_PROVEEDOR
										AND		PROVEEDOR.K_CATEGORIA_PROVEEDOR=CATEGORIA_PROVEEDOR.K_CATEGORIA_PROVEEDOR
										AND		FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP										
	-- ===============================
	
	SET @VP_REFERENCIA_1 = 'CXP - ' + @VP_S_UNIDAD_OPERATIVA +' ['+ CONVERT(VARCHAR(100),@VP_F_OPERACION)+'] ' + @VP_REFERENCIA_1

	SET	@VP_REFERENCIA_2 = 'AUTO (X_K_FACTURA) = '
	
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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_INSTRUCCION_X_K_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_INSTRUCCION_X_K_FACTURA_CXP]
GO	


CREATE PROCEDURE [dbo].[PG_IN_INSTRUCCION_X_K_FACTURA_CXP]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_FACTURA_CXP		INT,
	@PP_F_INSTRUCCION		DATE,
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO	INT,
	@PP_K_UNIDAD_OPERATIVA	INT,
	@OU_K_INSTRUCCION		INT			OUTPUT
AS
	-- ============================
	
	DECLARE @VP_K_PROVEEDOR			INT
		
	SELECT	@VP_K_PROVEEDOR =		K_PROVEEDOR
									FROM	FACTURA_CXP
									WHERE	K_FACTURA_CXP=@PP_K_FACTURA_CXP
	
	-- ============================
	
	DECLARE @VP_K_INSTRUCCION		INT
	
	SELECT	@VP_K_INSTRUCCION =		MAX(K_INSTRUCCION)
									FROM	INSTRUCCION
									WHERE	K_RESUMEN_FLUJO_DIARIO_X_UNO=@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO
									AND		F_INSTRUCCION=@PP_F_INSTRUCCION
									AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
									AND		K_PROVEEDOR=@VP_K_PROVEEDOR
	-- ============================
	
	IF @VP_K_INSTRUCCION IS NULL
		BEGIN

		DECLARE @VP_K_TIPO_INSTRUCCION				INT = 102		-- CXP
		DECLARE @VP_K_ESTATUS_INSTRUCCION			INT = 1
		DECLARE @VP_K_FORMA_INSTRUCCION				INT = 2			-- CHEQUE
		DECLARE @VP_L_CAPTURA_MANUAL				INT = 0

		-- =============================

		DECLARE @VP_K_RAZON_SOCIAL					INT = 0

		-- =============================

		DECLARE @VP_K_CUENTA_BANCO					INT 
		DECLARE @VP_BENEFICIARIO					VARCHAR(100) 
		DECLARE @VP_REFERENCIA_1					VARCHAR(500) 
		DECLARE @VP_REFERENCIA_2					VARCHAR(500) 
		DECLARE @VP_MONTO_INSTRUCCION				DECIMAL(19,4) 
	
		EXECUTE	[dbo].[PG_RN_INSTRUCCION_GET_PARAMETROS_X_K_FACTURA_CXP]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_FACTURA_CXP, @PP_F_INSTRUCCION,
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

-- [PG_PR_INSTRUCCION_X_K_FACTURA_CXP] 1,0,0,	1002098, '5/NOV/2018'


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]
GO	


CREATE PROCEDURE [dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_FACTURA_CXP		INT,
	@PP_F_INSTRUCCION		DATE
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)	= ''

	IF (@PP_K_FACTURA_CXP % 1)=0 
		SET @VP_MENSAJE = ''
	ELSE
		SET @VP_MENSAJE = 'ERROR NO ES CINCO'

	-- /////////////////////////////////////////////////////////////////////
		
	DECLARE @VP_F_OPERACION				DATE

	SET		@VP_F_OPERACION =			@PP_F_INSTRUCCION

	-- /////////////////////////////////////////////////////////////////////

	DECLARE @VP_K_UNIDAD_OPERATIVA		INT

	SELECT	@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA
										FROM	FACTURA_CXP
										WHERE	K_FACTURA_CXP=@PP_K_FACTURA_CXP

	-- ==========================================

	DECLARE @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO		INT

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_PREEXISTENCIA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@VP_F_OPERACION, @VP_K_UNIDAD_OPERATIVA,
																			@OU_K_RESUMEN_FLUJO_DIARIO_X_UNO = @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO		OUTPUT
	-- ==========================================

	DECLARE @VP_K_INSTRUCCION	INT

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_IN_INSTRUCCION_X_K_FACTURA_CXP]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_FACTURA_CXP, @PP_F_INSTRUCCION,
															@VP_K_RESUMEN_FLUJO_DIARIO_X_UNO, @VP_K_UNIDAD_OPERATIVA,
															@OU_K_INSTRUCCION = @VP_K_INSTRUCCION		OUTPUT
	-- ==========================================

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_IN_DETALLE_INSTRUCCION_X_K_FACTURA_CXP]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@VP_K_INSTRUCCION, @PP_K_FACTURA_CXP
	-- ==========================================

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_UP_INSTRUCCION_REFERENCIA_2_X_K_FACTURA_CXP]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@VP_K_INSTRUCCION, @PP_K_FACTURA_CXP
	-- ==========================================

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_UP_INSTRUCCION_TOTALIZAR]					@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@VP_K_INSTRUCCION
	-- ==========================================
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_TITULO_TODOS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_FACTURA_CXP, @PP_F_INSTRUCCION, @VP_K_INSTRUCCION,
																	@VP_K_UNIDAD_OPERATIVA
	-- ==========================================

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_IN_MOVIMIENTO_FLUJO_DIARIO_X_K_FACTURA_CXP]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_FACTURA_CXP, @PP_F_INSTRUCCION, @VP_K_INSTRUCCION,
																		@VP_K_UNIDAD_OPERATIVA
	
	-- ///////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Generar] la [Instrucción(xCXP)]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CXP.'+CONVERT(VARCHAR(10),@PP_K_FACTURA_CXP)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FACTURA_CXP AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO



-- ///////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////
