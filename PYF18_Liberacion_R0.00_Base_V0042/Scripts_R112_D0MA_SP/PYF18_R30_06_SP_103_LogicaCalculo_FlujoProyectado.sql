-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////









-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_103h_SALDOS_RDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_103h_SALDOS_RDO]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_103h_SALDOS_RDO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_103h_SALDOS_RDO]'
	
	-- ================================

	DECLARE @VP_CARTERA_CYC_INICIAL		DECIMAL(19,4);

	DECLARE @VP_N_DIA					INT = 1;
	DECLARE @VP_N_DIA_ANTERIOR			INT = 1;

	WHILE (@VP_N_DIA<=31)
		BEGIN
		
		SET @VP_N_DIA_ANTERIOR = (@VP_N_DIA-1)

		-- /////////////////////////////////////////////////
		-- // RDO / SALDOS

		
		EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
													3039, @VP_N_DIA_ANTERIOR,	-- [#3039] SALDO FINAL
													@OU_VALOR = @VP_CARTERA_CYC_INICIAL		OUTPUT
		 		
		EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4, -- [#3001] S.INICIAL
																3001,	@VP_CARTERA_CYC_INICIAL, @VP_N_DIA
	
		-- ==============================
		--     #3001 -> S.INICIAL
		-- (+) #3004 -> (1) ING / INGRESO TOTAL
		-- (-) #3035 -> EGRESO TOTAL	
		--#3037 -> RDO. ACUM.			-- ==============================
		EXECUTE [dbo].[PG_CA_MATE_N1_01A_SUMAR_A_MAS_B]			@PP_K_DOCUMENTO_D0M4, 
																3037, 0, 3001, 3004 

		EXECUTE [dbo].[PG_CA_MATE_N1_05B_ACUMULAR_MENOS_A]		@PP_K_DOCUMENTO_D0M4,
																3037, 0, 3035

		-- /////////////////////////////////////////////////
		--      #3037 -> RDO. ACUM.	
		--  (+) #3038 -> PRÉSTAMO (+/-)
		-- #3039 -> SALDO FINAL		-- ==============================
		EXECUTE [dbo].[PG_CA_MATE_N1_01A_SUMAR_A_MAS_B]		@PP_K_DOCUMENTO_D0M4,	
															3039, 0,	3037, 3038 


		-- =============================		
		SET @VP_N_DIA = @VP_N_DIA + 1;
		
		END;

	-- /////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_103x_PAGOS_21_22_23]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_103x_PAGOS_21_22_23]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_103x_PAGOS_21_22_23]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	-- ==============================
	@PP_K_DATO_D0M4_BASE		INT,
	@PP_K_DATO_D0M4_TARIFA		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_103x_PAGOS_21_22_23]'
	
	-- ==============================
	-- WIWI // HGF // AHORITA LO TOMA DEL DIA 1, HAY QUE ACTTUAL;IZA PARA QUE SEA EL DEL DIA

	DECLARE @VP_TARIFA					DECIMAL(19,4) = 0
	
	EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
												@PP_K_DATO_D0M4_TARIFA, 1,	
												@OU_VALOR = @VP_TARIFA		OUTPUT
	-- ==============================

	DECLARE @VP_MONTO_BASE				DECIMAL(19,4) = 0
	
	EXECUTE [dbo].[PG_FG_DATA_N1_DATO_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_BASE,
													@OU_VALOR = @VP_MONTO_BASE			OUTPUT
	-- ==============================

	DECLARE @VP_MONTO_A_APLICAR			DECIMAL(19,4) = 0
	
	SET @VP_MONTO_A_APLICAR =	(	@VP_MONTO_BASE * @VP_TARIFA   ) 

	-- =============================		
	
	DECLARE @VP_N_DIA_APLICAR			INT = 21;  			

	EXECUTE [dbo].[PG_RN_PRIMER_HABIL_ANTES_24]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4,
													@OU_N_DIA = @VP_N_DIA_APLICAR		OUTPUT
	-- =============================		

	EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
															@PP_K_DATO_D0M4_RESULTADO,	@VP_MONTO_A_APLICAR, @VP_N_DIA_APLICAR
	-- =============================		

	EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4,
														@PP_K_DATO_D0M4_RESULTADO

	-- /////////////////////////////////////////////////////////////
GO


-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_103d_FIRAGAS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_103d_FIRAGAS]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_103d_FIRAGAS]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_103d_FIRAGAS]'
	
	-- ==============================

	DECLARE @ID_P3048_c_FG			INT = 3048;			-- [#3048] (P@) ¢ FG
--	DECLARE @AVP_c_FG				DECIMAL(19,4)		-- WIWI			 ¢ FG	0.28 

	EXECUTE [dbo].[PG_RN_PRECIO_COSTO_PERFIL_SET_VALOR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4,
															@ID_P3048_c_FG, 'FG'

	DECLARE @ID_P3030_FIRAGAS			INT = 3030;				-- [#3030] FIRAGAS
	DECLARE @ID_P3040_VENTA_KG			INT = 3040;				-- [#3040] VENTA (KG) / CEME


	EXECUTE [dbo].[PG_OP_DATA_N1_103x_PAGOS_21_22_23]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_DOCUMENTO_D0M4,
														@ID_P3030_FIRAGAS, @ID_P3040_VENTA_KG, @ID_P3048_c_FG

	-- /////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_103e_MP_IMBURSA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_103e_MP_IMBURSA]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_103e_MP_IMBURSA]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_103e_MP_IMBURSA]'
	
	-- ==============================

	DECLARE @ID_P3049_c_MP_INBURSA	INT = 3049;			-- [#3049] (P@) ¢ MP INB
--	DECLARE @AVP_c_MP_INBURSA		DECIMAL(19,4)		-- WIWI			 ¢ MP INB	0.18 

	EXECUTE [dbo].[PG_RN_PRECIO_COSTO_PERFIL_SET_VALOR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4,
															@ID_P3049_c_MP_INBURSA, 'MP_INB'

	DECLARE @ID_P3031_MP_IMBURSA		INT = 3031;				-- [#3031] -> MP INBURSA
	DECLARE @ID_P3040_VENTA_KG			INT = 3040;				-- [#3040] VENTA (KG) / CEME
	
	EXECUTE [dbo].[PG_OP_DATA_N1_103x_PAGOS_21_22_23]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_DOCUMENTO_D0M4,
														@ID_P3031_MP_IMBURSA, @ID_P3040_VENTA_KG, @ID_P3049_c_MP_INBURSA

	-- /////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_103f_SMD]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_103f_SMD]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_103f_SMD]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_103f_SMD]'
	
	-- ==============================

	DECLARE @ID_P3050_c_SMD			INT = 3050;			-- [#3050] (P@) ¢ SMD
--	DECLARE @AVP_c_SMD				DECIMAL(19,4)		-- WIWI			 ¢ SMD	0.30 

	EXECUTE [dbo].[PG_RN_PRECIO_COSTO_PERFIL_SET_VALOR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4,
															@ID_P3050_c_SMD, 'SMD'

	DECLARE @ID_P3032_SMD				INT = 3032;				-- [#3032] -> SMD

	DECLARE @ID_P3040_VENTA_KG			INT = 3040;				-- [#3040] VENTA (KG) / CEME


	EXECUTE [dbo].[PG_OP_DATA_N1_103x_PAGOS_21_22_23]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_DOCUMENTO_D0M4,
														@ID_P3032_SMD, @ID_P3040_VENTA_KG, @ID_P3050_c_SMD

	-- /////////////////////////////////////////////////////////////
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_103g_SMP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_103g_SMP]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_103g_SMP]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_103g_SMP]'
	
	-- ==============================

	DECLARE @ID_P3051_c_SMP			INT = 3051;			-- [#3051] (P@) ¢ SMP
--	DECLARE @AVP_c_SMP				DECIMAL(19,4)		-- WIWI			 ¢ SMP	0.70 

	EXECUTE [dbo].[PG_RN_PRECIO_COSTO_PERFIL_SET_VALOR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4,
															@ID_P3051_c_SMP, 'SMP'

	DECLARE @ID_P3033_SMP				INT = 3033;				-- [#3033] -> SMP
	DECLARE @ID_P3040_VENTA_KG			INT = 3040;				-- [#3040] VENTA (KG) / CEME


	EXECUTE [dbo].[PG_OP_DATA_N1_103x_PAGOS_21_22_23]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_DOCUMENTO_D0M4,
														@ID_P3033_SMP, @ID_P3040_VENTA_KG, @ID_P3051_c_SMP

	-- /////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_103c_AMORTIZACION_PETROGAS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_103c_AMORTIZACION_PETROGAS]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_103c_AMORTIZACION_PETROGAS]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_103c_AMORTIZACION_PETROGAS]'
	
	-- ==============================

	DECLARE @ID_P3046_APG			INT = 3046;			-- [#3046] (P@) ¢ APG
--	DECLARE @AVP_APG				DECIMAL(19,4)		-- WIWI			 ¢ APG	0.27 

	EXECUTE [dbo].[PG_RN_PRECIO_COSTO_PERFIL_SET_VALOR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4,
															@ID_P3046_APG, 'APG'

	DECLARE @ID_P3019_AMORTIZACION_PETROGAS	INT = 3019;				-- [#3019] AMORT. PETRO.
	DECLARE @ID_P3040_VENTA_KG				INT = 3040;				-- [#3040] VENTA (KG) / CEME

	EXECUTE [dbo].[PG_OP_DATA_N1_103x_PAGOS_21_22_23]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4,
															@ID_P3019_AMORTIZACION_PETROGAS, @ID_P3040_VENTA_KG, @ID_P3046_APG

	-- /////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_103a_INVENTARIO_REPOSICION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_103a_INVENTARIO_REPOSICION]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_103a_INVENTARIO_REPOSICION]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_103a_INVENTARIO_REPOSICION]'
	
	-- ==============================
	
	DECLARE @ID_P3043_DIA_SEMANA		INT = 3043;		-- [#3043] DIA DE LA SEMANA / FLUP
	DECLARE @ID_P3044_ASUETOS			INT = 3044;

	DECLARE @ID_P3040_VENTA_KG			INT = 3040;		-- [#3040] VENTA (KG) / CEME
	DECLARE @ID_P3041_INVERNTARIO_REPOSICION_KG		
										INT = 3041;		-- [#3041] INVENTARIO (KG) / REPOSICION
	-- ==============================

	DECLARE @VP_N_DIA_SEMANA			DECIMAL(19,4);
	DECLARE @VP_L_ASUETO				DECIMAL(19,4);

	DECLARE @VP_VENTA_KG_5_VIE	DECIMAL(19,4);
	DECLARE @VP_VENTA_KG_6_SAB	DECIMAL(19,4);
	DECLARE @VP_VENTA_KG_7_DOM	DECIMAL(19,4);

	DECLARE @VP_REPOSICION_REZAGADA		DECIMAL(19,4);
	DECLARE @VP_P3041_INVENTARIO_REPOSICION_KG			
										DECIMAL(19,4);

	DECLARE @VP_N_DIA					INT = 1;
	DECLARE @VP_N_DIA_ANTERIOR			INT = 1;
	DECLARE @VP_N_DIA_SIN_DEPOSITO		INT = 1;

	WHILE (@VP_N_DIA<=31)
		BEGIN
		
		SET @VP_N_DIA_ANTERIOR = (@VP_N_DIA-1)

		-- ////////////////////////////////////////////////////
		-- // INGRESOS X VENTA
		
		EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
													@ID_P3043_DIA_SEMANA, @VP_N_DIA,	
													@OU_VALOR = @VP_N_DIA_SEMANA		OUTPUT

		EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
													@ID_P3044_ASUETOS, @VP_N_DIA,	
													@OU_VALOR = @VP_L_ASUETO			OUTPUT
		-- =============================	

		IF @VP_N_DIA_SEMANA IN ( 6, 7 )				-- SAB/DOM = NO DEPOSITOS
			SET @VP_P3041_INVENTARIO_REPOSICION_KG = 0
		ELSE
			IF @VP_N_DIA_SEMANA IN ( 2,3,4,5 )		-- MAR/MIE/JUE/VIE = DEPOSITOS DIA ANTERIOR
				EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
															@ID_P3040_VENTA_KG, @VP_N_DIA_ANTERIOR,	
															@OU_VALOR = @VP_P3041_INVENTARIO_REPOSICION_KG		OUTPUT
			ELSE
				BEGIN								-- LUN = DEPOSITOS VIE+SAB+DOM ANTERIOR
				
				SET @VP_N_DIA_SIN_DEPOSITO = ( @VP_N_DIA - 1 )
				
				EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
															@ID_P3040_VENTA_KG, @VP_N_DIA_SIN_DEPOSITO,	-- VENTA CONTADO DOMINGO	
															@OU_VALOR = @VP_VENTA_KG_5_VIE		OUTPUT

				SET @VP_N_DIA_SIN_DEPOSITO = ( @VP_N_DIA - 2 )

				EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
															@ID_P3040_VENTA_KG, @VP_N_DIA_SIN_DEPOSITO,	-- VENTA CONTADO SABADO
															@OU_VALOR = @VP_VENTA_KG_6_SAB		OUTPUT

				SET @VP_N_DIA_SIN_DEPOSITO = ( @VP_N_DIA - 3 )

				EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
															@ID_P3040_VENTA_KG, @VP_N_DIA_SIN_DEPOSITO,	-- VENTA CONTADO VIERNES
															@OU_VALOR = @VP_VENTA_KG_7_DOM		OUTPUT
				-- =================
	
				SET @VP_P3041_INVENTARIO_REPOSICION_KG = ( @VP_VENTA_KG_5_VIE + @VP_VENTA_KG_6_SAB + @VP_VENTA_KG_7_DOM )

				END

		-- =============================		
		-- WIWI // REPOSICION INVENTARIO

		IF @VP_L_ASUETO=1
			BEGIN
			
			SET		@VP_REPOSICION_REZAGADA = @VP_P3041_INVENTARIO_REPOSICION_KG
			SET		@VP_P3041_INVENTARIO_REPOSICION_KG = 0
			
			END
		ELSE
			IF NOT ( @VP_N_DIA_SEMANA IN ( 6, 7 ) )				-- SAB/DOM = NO DEPOSITOS
				SET		@VP_P3041_INVENTARIO_REPOSICION_KG =  ( @VP_P3041_INVENTARIO_REPOSICION_KG + @VP_REPOSICION_REZAGADA )

		-- =============================		

		EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
																@ID_P3041_INVERNTARIO_REPOSICION_KG,	@VP_P3041_INVENTARIO_REPOSICION_KG, @VP_N_DIA
		-- =============================		

		SET @VP_N_DIA = @VP_N_DIA + 1;
		
		END;

	-- /////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4,
														@ID_P3041_INVERNTARIO_REPOSICION_KG

	-- /////////////////////////////////////////////////////////////
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CEME_X_FLUP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CEME_X_FLUP]
GO


CREATE PROCEDURE [dbo].[PG_RN_CEME_X_FLUP]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4_FLUP	INT,
	@OU_K_DOCUMENTO_D0M4_CEME	INT		OUTPUT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_RN_CEME_X_FLUP]'

	-- ======================================
	
	DECLARE @VP_K_UNIDAD_OPERATIVA		INT
	DECLARE @VP_K_YYYY					INT
	DECLARE @VP_K_MM					INT

	SELECT	@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA,
			@VP_K_YYYY =				K_YYYY, 					
			@VP_K_MM =					K_MM
										FROM	DOCUMENTO_D0M4
										WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4_FLUP
	-- ============================
	
	DECLARE @VP_K_DOCUMENTO_D0M4_CEME	INT		

	SELECT	@VP_K_DOCUMENTO_D0M4_CEME =	K_DOCUMENTO_D0M4
										FROM	DOCUMENTO_D0M4
										WHERE	K_FORMATO_D0M4=101	-- #101	C3M3 // COMPROMISO
										AND		K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA 
										AND		K_YYYY=@VP_K_YYYY 
										AND		K_MM=@VP_K_MM 					
	IF @PP_L_DEBUG>1
		PRINT '@VP_K_DOCUMENTO_D0M4_CEME = ' + CONVERT(VARCHAR(50),@VP_K_DOCUMENTO_D0M4_CEME)

	-- ============================

	SET @OU_K_DOCUMENTO_D0M4_CEME = @VP_K_DOCUMENTO_D0M4_CEME
	
	-- ======================================
GO





-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_103b_CALCULO_FLETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_103b_CALCULO_FLETE]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_103b_CALCULO_FLETE]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_103b_CALCULO_FLETE]'
	
	-- ==============================

	DECLARE @ID_P3040_VENTA_KG			INT = 3040;			-- [#3040] VENTA (KG) / CEME
	DECLARE @VP_P3040_VENTA_KG			DECIMAL(19,4) = 0
	
	EXECUTE [dbo].[PG_FG_DATA_N1_DATO_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @ID_P3040_VENTA_KG,
													@OU_VALOR = @VP_P3040_VENTA_KG			OUTPUT

	-- ==============================
	
	DECLARE @ID_P3045_FLETE_X_KG	INT = 3045;			-- [#3045] (P@) FLETE ($)

	EXECUTE [dbo].[PG_RN_PRECIO_COSTO_PERFIL_SET_VALOR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4,
															@ID_P3045_FLETE_X_KG, 'FLETE'

	-- ==============================
	-- WIWI // HGF // AHORITA LO TOMA DEL DIA 1, HAY QUE ACTTUAL;IZA PARA QUE SEA EL DEL DIA

	DECLARE @VP_FLETE_X_KG			DECIMAL(19,4) 		-- WIWI 0.89

	EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
												@ID_P3045_FLETE_X_KG, 1,	
												@OU_VALOR = @VP_FLETE_X_KG		OUTPUT


	DECLARE @ID_P3009_FLETE			INT = 3009;			-- [#3009] OTROS / FLETE
	
	DECLARE @VP_MONTO_FLETE_SEMANAL		DECIMAL(19,4) 



	DECLARE @VP_N_VIERNES				INT = 4;			

	EXECUTE [dbo].[PG_RN_VIERNES_HABILES_EN_MES]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4,
													@OU_N_VIERNES_HABILES =	@VP_N_VIERNES		OUTPUT

	SET @VP_MONTO_FLETE_SEMANAL = ( @VP_P3040_VENTA_KG * @VP_FLETE_X_KG	) / @VP_N_VIERNES

	
	-- ==============================================
	-- [3043]	(P@) DIA DE LA SEMANA / FLUP
	-- [3044]	(P@) ASUETOS / FLUP
	DECLARE @ID_P3043_DIA_SEMANA		INT = 3043;
	DECLARE @ID_P3044_ASUETOS			INT = 3044;

	DECLARE @VP_N_DIA_SEMANA			INT;
	DECLARE @VP_L_ASUETO				INT;

-- ============================= CICLO X DIAS

	DECLARE @VP_N_DIA					INT = 1;
	
	WHILE (@VP_N_DIA<=31)
		BEGIN

		EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
													@ID_P3043_DIA_SEMANA, @VP_N_DIA,	
													@OU_VALOR = @VP_N_DIA_SEMANA		OUTPUT
		
		EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
													@ID_P3044_ASUETOS, @VP_N_DIA,	
													@OU_VALOR = @VP_L_ASUETO			OUTPUT
		-- =============================			

		IF @VP_L_ASUETO=0
			IF @VP_N_DIA_SEMANA=5				-- VIERNES
				EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
																		@ID_P3009_FLETE,	@VP_MONTO_FLETE_SEMANAL, @VP_N_DIA
		-- =============================		

		SET @VP_N_DIA = @VP_N_DIA + 1;
		
		END;

	-- =============================		

	EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4,
														@ID_P3009_FLETE

	-- /////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_103_FLUJO_PROYECTADO_RECALCULAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_103_FLUJO_PROYECTADO_RECALCULAR]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_103_FLUJO_PROYECTADO_RECALCULAR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_103_FLUJO_PROYECTADO_RECALCULAR]'

	-- /////////////////////////////////////////////////////////
	
	DECLARE @VP_K_DOCUMENTO_D0M4_CEME	INT	
	
	EXECUTE	[dbo].[PG_RN_CEME_X_FLUP]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
										@PP_K_DOCUMENTO_D0M4, 
										@OU_K_DOCUMENTO_D0M4_CEME = @VP_K_DOCUMENTO_D0M4_CEME		OUTPUT

	-- /////////////////////////////////////////////////////////

	-- [#3043] DIA DE LA SEMANA / FLUP //////////////
--	EXECUTE [dbo].[PG_CA_BADA_N1_NN_CLONAR_RENGLON]		@VP_K_DOCUMENTO_D0M4_CEME, 1020,	-- [#1020] DIA DE LA SEMANA / CEME
--														@PP_K_DOCUMENTO_D0M4, 3043,			0	


	-- #3002 -> ING / VTA. CONTADO //////////////////
	EXECUTE [dbo].[PG_CA_BADA_N1_NN_CLONAR_RENGLON]		@VP_K_DOCUMENTO_D0M4_CEME, 1009,	-- [#1009] INGRESOS X VENTA ($) 
														@PP_K_DOCUMENTO_D0M4, 3002,			1	
	-- #3003 -> ING / COBRANZA //////////////////////
	EXECUTE [dbo].[PG_CA_BADA_N1_NN_CLONAR_RENGLON]		@VP_K_DOCUMENTO_D0M4_CEME, 1010,	-- [#1010] INGRESOS X COBRANZA ($)
														@PP_K_DOCUMENTO_D0M4, 3003,			1

	-- [#3040] VENTA (KG) / CEME   <<<<<< [#1002] VENTA (KG)
	EXECUTE [dbo].[PG_CA_BADA_N1_NN_CLONAR_RENGLON]		@VP_K_DOCUMENTO_D0M4_CEME, 1002,	-- [#1002] VENTA (KG)
														@PP_K_DOCUMENTO_D0M4, 3040,			1


	-- ==============================================
	-- [3043]	(P@) DIA DE LA SEMANA / FLUP
	-- [3044]	(P@) ASUETOS / FLUP
	DECLARE @ID_P3043_DIA_SEMANA		INT = 3043;
	DECLARE @ID_P3044_ASUETOS			INT = 3044;
	
	EXECUTE [dbo].[PG_OP_DATA_N1_DIA_SEMANA_Y_ASUETOS_CALCULAR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_DOCUMENTO_D0M4, @ID_P3043_DIA_SEMANA, @ID_P3044_ASUETOS
	-- ==============================================

	

	-- /////////////////////////////////////////////////////////
	-- #3002 -> ING / VTA. CONTADO
	-- #3003 -> ING / COBRANZA
	-- #3004 -> (1) ING / INGRESO TOTAL						-- ==============================
	EXECUTE [dbo].[PG_CA_MATE_N1_01C_SUMAR_RANGO_D1_D9]		@PP_K_DOCUMENTO_D0M4,	3004, 1,
															3002, 3003


	-- //////////////////////////////////////////////////////////////


	-- /////////////////////////////////////////////////////////
	-- #3005 -> GAS / ATRASO

	-- #3006 -> GAS / FACTURA
	EXECUTE [PG_OP_DATA_N1_103a_INVENTARIO_REPOSICION]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4	

	EXECUTE [dbo].[PG_CA_MATE_N1_10B_ASIGNAR_VALOR]			@PP_K_DOCUMENTO_D0M4,	-- WIWI ESTO ES PROVISIONAL // LEERLOS DE PRECIOS
															3042, 0, 12.49			-- [#3042] PCN ($)
	EXECUTE [dbo].[PG_CA_MATE_N1_03A_MULTIPLICAR_A_X_B]		@PP_K_DOCUMENTO_D0M4,	
															3006,	1,	3041, 3042	-- [#3041] INVENTARIO (KG) / REPOSICION || [#3042] PCN ($)

	-- #3007 -> PPTO / NÓMINA
	EXECUTE [dbo].[PG_CA_BADA_N1_NN_CLONAR_RENGLON]		@VP_K_DOCUMENTO_D0M4_CEME, 1007,	-- [#3007] INGRESOS X VENTA ($) 
														@PP_K_DOCUMENTO_D0M4, 3007,			1	
	-- #3008 -> PPTO / GASTOS
	-- #3009 -> OTROS / FLETE -- =================
	EXECUTE [dbo].[PG_OP_DATA_N1_103b_CALCULO_FLETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4	


	-- #3010 -> OTROS / NÓM. CORP. ZULE
	-- #3011 -> (2) TOTAL									-- ==============================
	EXECUTE [dbo].[PG_CA_MATE_N1_01C_SUMAR_RANGO_D1_D9]		@PP_K_DOCUMENTO_D0M4,	3011, 1,
															3005, 3006, 3007, 3008, 3009, 3010
	-- /////////////////////////////////////////////////////////
	-- ==============================
	-- #3012 -> IMP. FEDERALES
	-- #3013 -> IMP. PLANTA
	-- #3014 -> COOP. IMPUESTOS
	-- #3015 -> (3) IMPUESTOS / TOTAL						-- ==============================
	EXECUTE [dbo].[PG_CA_MATE_N1_01C_SUMAR_RANGO_D1_D9]		@PP_K_DOCUMENTO_D0M4,	3015, 1,
															3012, 3013, 3014
	-- /////////////////////////////////////////////////////////
	-- #3016 -> CRED. TERC.
	-- #3017 -> PQ. INV. PLANTA
	-- #3018 -> INTERESES
	-- #3019 -> AMORT. PETRO.
	EXECUTE [dbo].[PG_OP_DATA_N1_103c_AMORTIZACION_PETROGAS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, 
																@PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4	
	-- #3020 -> (4) OBLIG. BANCARIAS / TOTAL					-- ==============================
	EXECUTE [dbo].[PG_CA_MATE_N1_01C_SUMAR_RANGO_D1_D9]			@PP_K_DOCUMENTO_D0M4,	3020, 1,
																3016, 3017, 3018, 3019
	-- /////////////////////////////////////////////////////////
	-- ==============================
	-- #3021 -> EXTRAORDINARIOS
	-- #3022 -> INVERSIONES
	-- #3023 -> NO GESTIONABLES
	-- #3024 -> (5) EXTR. Y OTROS / TOTAL					-- ==============================
	EXECUTE [dbo].[PG_CA_MATE_N1_01C_SUMAR_RANGO_D1_D9]		@PP_K_DOCUMENTO_D0M4,	3024, 1,
															3021, 3022, 3023
	-- /////////////////////////////////////////////////////////
	-- #3025 -> ASPTA
	-- #3026 -> OTROS GASTOS
	-- #3027 -> COOPERACIONES
	-- #3028 -> (6) CORPORATIVOS / TOTAL					-- ==============================
	EXECUTE [dbo].[PG_CA_MATE_N1_01C_SUMAR_RANGO_D1_D9]		@PP_K_DOCUMENTO_D0M4,	3028, 1,
															3025, 3026, 3027
	-- /////////////////////////////////////////////////////////
	
	DECLARE @ID_P3047_c_SMRU		INT = 3047;			-- [#3047] (P@) ¢ SMRU  //  ¢ SMRU	0.89 

	EXECUTE [dbo].[PG_RN_PRECIO_COSTO_PERFIL_SET_VALOR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4,
															@ID_P3047_c_SMRU, 'SMRU'
	-- [#3029] SMRU
	EXECUTE [dbo].[PG_CA_MATE_N1_03A_MULTIPLICAR_A_X_B]		@PP_K_DOCUMENTO_D0M4,	
															3029,	1,	3041, @ID_P3047_c_SMRU	-- [#3041] INVENTARIO (KG) / REPOSICION

	-- #3030 -> FIRAGAS
	EXECUTE [dbo].[PG_OP_DATA_N1_103d_FIRAGAS]				@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4	
	-- #3031 -> MP INBURSA
	EXECUTE [dbo].[PG_OP_DATA_N1_103e_MP_IMBURSA]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4	
	-- #3032 -> SMD
	EXECUTE [dbo].[PG_OP_DATA_N1_103f_SMD]					@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4	
	-- #3033 -> SMP
	EXECUTE [dbo].[PG_OP_DATA_N1_103g_SMP]					@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4	

	-- #3034 -> (7) RESERVAS / TOTAL						-- ==============================
	EXECUTE [dbo].[PG_CA_MATE_N1_01C_SUMAR_RANGO_D1_D9]		@PP_K_DOCUMENTO_D0M4,	3034, 1,
															3029, 3030, 3031, 3032, 3033
	-- /////////////////////////////////////////////////////////
	-- #3011 -> (2) TOTAL
	-- #3015 -> (3) IMPUESTOS / TOTAL
	-- #3020 -> (4) OBLIG. BANCARIAS / TOTAL
	-- #3024 -> (5) EXTR. Y OTROS / TOTAL
	-- #3028 -> (6) CORPORATIVOS / TOTAL
	-- #3034 -> (7) RESERVAS / TOTAL
	-- #3035 -> EGRESO TOTAL								-- ==============================
	EXECUTE [dbo].[PG_CA_MATE_N1_01C_SUMAR_RANGO_D1_D9]		@PP_K_DOCUMENTO_D0M4,	3035, 1,
															3011, 3015, 3020, 3024, 3028, 3034


	-- /////////////////////////////////////////////////////////
	--    [#3036] RDO. DEL DIA
	--    [#3037] RDO. ACUM.
	--    [#3038] PRÉSTAMO (+/-)
	--    [#3039] SALDO FINAL

	-- ==============================================
	-- #3036 -> RDO. DEL DIA		
	--			#3004 -> (1) ING / INGRESO TOTAL
	--		(-) #3035 -> EGRESO TOTAL
	EXECUTE [dbo].[PG_CA_MATE_N1_02A_RESTAR_A_MENOS_B]		@PP_K_DOCUMENTO_D0M4,	
															3036,	1,	3004, 3035
	-- ==============================================
	--    [#3037] RDO. ACUM.
	--    [#3039] SALDO FINAL
	--				--> [#3001] S.INICIAL
	EXECUTE [dbo].[PG_OP_DATA_N1_103h_SALDOS_RDO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_DOCUMENTO_D0M4	

	-- //////////////////////////////////////////
	-- // DOCUMENTO_D0M4 >> ACTUALIZAR ESTATUS
	EXECUTE	[dbo].[PG_UP_DOCUMENTO_D0M4_L_RECALCULADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4

	EXECUTE [dbo].[PG_TR_DOCUMENTO_D0M4_ESTATUS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4, 3		-- K_ESTATUS_DOCUMENTO_D0M4	// #3 PREVIO

	-- //////////////////////////////////////////////////////////////
GO



-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
