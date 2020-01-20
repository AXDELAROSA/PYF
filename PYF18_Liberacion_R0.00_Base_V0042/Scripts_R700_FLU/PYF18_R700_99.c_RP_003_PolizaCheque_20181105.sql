-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_RXXX_30.c_SK_POLIZA_CHEQUE
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			POLIZACHEQUE
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			ALEX DE LA ROSA
-- // Fecha creación:	31/OCT/2018
-- ////////////////////////////////////////////////////////////// 



USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SEEK POLIZA_CHEQUE
-- //////////////////////////////////////////////////////////////

-- EXECUTE [dbo].[PG_RP_003_POLIZA_CHEQUE] 0,0,0,	19
			


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RP_003_POLIZA_CHEQUE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RP_003_POLIZA_CHEQUE]
GO	


CREATE PROCEDURE [dbo].[PG_RP_003_POLIZA_CHEQUE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_INSTRUCCION				INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)	= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													8, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_N_LINEAS	INT = 1000
	
	IF NOT (@VP_MENSAJE='')
		SET @VP_N_LINEAS = 0

	-- ///////////////////////////////////////////

	DECLARE	@VP_K_TIPO_INSTRUCCION		INT
	DECLARE	@VP_IMPORTE					DECIMAL(19,4)

	SELECT	@VP_K_TIPO_INSTRUCCION =	K_TIPO_INSTRUCCION,
			@VP_IMPORTE	=				MONTO_INSTRUCCION				
										FROM	INSTRUCCION 
										WHERE	INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
	
	-- =======================================

	DECLARE	@VP_TITULO		VARCHAR(100) = 'PÓLIZA'

	-- K_TIPO_INSTRUCCION //  101 TRASPASO // 102	CXP
	IF @VP_K_TIPO_INSTRUCCION=101
		SET @VP_TITULO = 'PÓLIZA TRASPASO'

	IF @VP_K_TIPO_INSTRUCCION=102
		SET @VP_TITULO = 'PÓLIZA CXP'

	-- =======================================

	DECLARE @VP_IMPORTE_LETRA		VARCHAR(200)
	
	EXECUTE [dbo].[PG_PR_NUM_CONVERSION_A_TEXTO_OUT]		@VP_IMPORTE,
															@OU_IMPORTE_LETRA = @VP_IMPORTE_LETRA		OUTPUT
	-- ///////////////////////////////////////////

	SELECT	TOP ( @VP_N_LINEAS )		
			'['+RAZON_SOCIAL.S_RAZON_SOCIAL+'/'+
			UNIDAD_OPERATIVA.S_UNIDAD_OPERATIVA+']'		
											AS RP_EMISOR,
			@VP_TITULO						AS RP_TITULO,
			'ISAAC/RP003'					AS RP_ID_REPORTE,
			'[#INS.'+CONVERT(VARCHAR(100),INSTRUCCION.K_INSTRUCCION)+
			'//'+S_ESTATUS_INSTRUCCION +']'		
											AS RP_ID_DOCUMENTO,
			-- ==================================================
			TIEMPO_FECHA.D_TIEMPO_FECHA		AS RP_CHEQUE_FECHA,
			INSTRUCCION.BENEFICIARIO		AS RP_CHEQUE_BENEFICIARIO,
			MONTO_INSTRUCCION				AS RP_CHEQUE_MONTO,
			@VP_IMPORTE_LETRA				AS RP_CHEQUE_MONTO_LETRAS,
			'(!) PARA ABONO EN CUENTA DEL BENEFICIARIO' 
											AS RP_CHEQUE_LEYENDA_ABONO,
			-- ==================================================
			INSTRUCCION.BENEFICIARIO		AS RP_BENEFICIARIO,
			BANCO.D_BANCO					AS RP_BANCO,
			CUENTA_BANCO.CUENTA				AS RP_CUENTA_BANCARIA,
			INSTRUCCION.REFERENCIA_1		AS RP_CONCEPTO,
			-- ==================================================
			CUENTA_BANCO.D_CUENTA_BANCO		AS RP_CONCEPTO_BANCO,
			MONTO_INSTRUCCION				AS RP_MONTO_BANCO,
			-- ==================================================
			D_USUARIO AS D_USUARIO_CAMBIO
	FROM	INSTRUCCION, 
			TIEMPO_FECHA,
			TIPO_INSTRUCCION, ESTATUS_INSTRUCCION,
			CUENTA_BANCO, BANCO,
			FORMA_INSTRUCCION,
			RAZON_SOCIAL,
			UNIDAD_OPERATIVA,
			USUARIO
			-- ==================================================
	WHERE	INSTRUCCION.K_TIPO_INSTRUCCION=TIPO_INSTRUCCION.K_TIPO_INSTRUCCION
	AND		INSTRUCCION.K_ESTATUS_INSTRUCCION=ESTATUS_INSTRUCCION.K_ESTATUS_INSTRUCCION
	AND		INSTRUCCION.K_CUENTA_BANCO=CUENTA_BANCO.K_CUENTA_BANCO
	AND		CUENTA_BANCO.K_BANCO=BANCO.K_BANCO
	AND		INSTRUCCION.K_TIPO_INSTRUCCION=TIPO_INSTRUCCION.K_TIPO_INSTRUCCION
	AND		INSTRUCCION.K_FORMA_INSTRUCCION=FORMA_INSTRUCCION.K_FORMA_INSTRUCCION
	AND		INSTRUCCION.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL
	AND		INSTRUCCION.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND		INSTRUCCION.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		INSTRUCCION.F_INSTRUCCION=TIEMPO_FECHA.F_TIEMPO_FECHA
	AND		INSTRUCCION.L_BORRADO=0
	AND		INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION

	-- //////////////////////////////////////////////////////////////
GO



	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SEEK POLIZA_CHEQUE
-- //////////////////////////////////////////////////////////////

-- EXECUTE [dbo].[PG_RP_003_POLIZA_CHEQUE_DETALLE] 0,0,0,	19
	

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RP_003_POLIZA_CHEQUE_DETALLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RP_003_POLIZA_CHEQUE_DETALLE]
GO	


CREATE PROCEDURE [dbo].[PG_RP_003_POLIZA_CHEQUE_DETALLE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_INSTRUCCION				INT
AS			
	
	DECLARE	@VP_K_TIPO_INSTRUCCION		INT
	
	SELECT	@VP_K_TIPO_INSTRUCCION =	K_TIPO_INSTRUCCION				
										FROM	INSTRUCCION 
										WHERE	INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION
	-- ============================

	IF @VP_K_TIPO_INSTRUCCION=101 -- TRASPASO
		SELECT	TRASPASO.K_TRASPASO			AS RP_K_TRASPASO,
				TRASPASO.D_TRASPASO			AS RP_CUENTA,
				TRASPASO.MONTO_AUTORIZADO	AS RP_MONTO
		FROM	DETALLE_INSTRUCCION, TRASPASO
		WHERE	DETALLE_INSTRUCCION.K_TRASPASO=TRASPASO.K_TRASPASO
		AND		DETALLE_INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION

	-- ============================

	IF @VP_K_TIPO_INSTRUCCION=102 -- CXP // FACTURA 
		SELECT	FACTURA_CXP.K_FACTURA_CXP			AS RP_K_TRASPASO,
				FACTURA_CXP.C_FACTURA_CXP			AS RP_CUENTA,
				FACTURA_CXP.SALDO					AS RP_MONTO
		FROM	DETALLE_INSTRUCCION, FACTURA_CXP
		WHERE	DETALLE_INSTRUCCION.K_FACTURA_CXP=FACTURA_CXP.K_FACTURA_CXP
		AND		DETALLE_INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION

	-- //////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
