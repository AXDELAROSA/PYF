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


-- SELECT * FROM	sys.sysobjects WHERE	name LIKE 'PG%'







-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_101a_PERFIL_VENTA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_101a_PERFIL_VENTA]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_101a_PERFIL_VENTA]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_DIA_SEMANA	INT,
	@PP_K_DATO_D0M4_PESO		INT,
	@PP_K_DATO_D0M4_VENTA		INT,
	-- ==============================
	@PP_L_CONTADO				INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_101a_PERFIL_VENTA]'

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_CA_MATE_N1_10B_ASIGNAR_VALOR]		@PP_K_DOCUMENTO_D0M4,  
														@PP_K_DATO_D0M4_PESO, 0, 0.00

	-- ////////////////////////////////////////////////

	DECLARE @VP_PESO_1_LUNES			DECIMAL(19,4) = 0,
			@VP_PESO_2_MARTES			DECIMAL(19,4) = 0,
			@VP_PESO_3_MIERCOLES		DECIMAL(19,4) = 0,
			@VP_PESO_4_JUEVES			DECIMAL(19,4) = 0,
			@VP_PESO_5_VIERNES			DECIMAL(19,4) = 0,
			@VP_PESO_6_SABADO			DECIMAL(19,4) = 0,
			@VP_PESO_7_DOMINGO			DECIMAL(19,4) = 0

	IF @PP_L_CONTADO=1
		SELECT	@VP_PESO_1_LUNES =			PERFIL_VENTA_CONTADO_1_LUNES,
				@VP_PESO_2_MARTES =			PERFIL_VENTA_CONTADO_2_MARTES,	
				@VP_PESO_3_MIERCOLES =		PERFIL_VENTA_CONTADO_3_MIERCOLES,	
				@VP_PESO_4_JUEVES =			PERFIL_VENTA_CONTADO_4_JUEVES,	
				@VP_PESO_5_VIERNES =		PERFIL_VENTA_CONTADO_5_VIERNES,	
				@VP_PESO_6_SABADO =			PERFIL_VENTA_CONTADO_6_SABADO,	
				@VP_PESO_7_DOMINGO =		PERFIL_VENTA_CONTADO_7_DOMINGO	
											FROM	PARAMETRO_DOCUMENTO_D0M4
											WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	ELSE
		SELECT	@VP_PESO_1_LUNES =			PERFIL_VENTA_CREDITO_1_LUNES,
				@VP_PESO_2_MARTES =			PERFIL_VENTA_CREDITO_2_MARTES,	
				@VP_PESO_3_MIERCOLES =		PERFIL_VENTA_CREDITO_3_MIERCOLES,	
				@VP_PESO_4_JUEVES =			PERFIL_VENTA_CREDITO_4_JUEVES,	
				@VP_PESO_5_VIERNES =		PERFIL_VENTA_CREDITO_5_VIERNES,	
				@VP_PESO_6_SABADO =			PERFIL_VENTA_CREDITO_6_SABADO,	
				@VP_PESO_7_DOMINGO =		PERFIL_VENTA_CREDITO_7_DOMINGO	
											FROM	PARAMETRO_DOCUMENTO_D0M4
											WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	-- ////////////////////////////////////////////////

	DECLARE @VP_N_DIA_MAX		INT 

	SELECT	@VP_N_DIA_MAX =		MAX(FECHA_DD)
								FROM	TIEMPO_FECHA, DOCUMENTO_D0M4	
								WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4 
								AND		TIEMPO_FECHA.FECHA_YYYY=DOCUMENTO_D0M4.K_YYYY
								AND		TIEMPO_FECHA.K_TIEMPO_MES=DOCUMENTO_D0M4.K_MM
	-- ======================
	
	DECLARE @VP_PESO_A_APLICAR	DECIMAL(19,4);

	DECLARE @VP_N_DIA_SEMANA	INT = 1;

	DECLARE @VP_N_DIA			INT = 1;

	WHILE (@VP_N_DIA<=@VP_N_DIA_MAX)
		BEGIN

		EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
													@PP_K_DATO_D0M4_DIA_SEMANA, @VP_N_DIA,	
													@OU_VALOR = @VP_N_DIA_SEMANA		OUTPUT
		-- =============================		

		IF @VP_N_DIA_SEMANA=1		
			SET @VP_PESO_A_APLICAR = @VP_PESO_1_LUNES		
		ELSE
			IF @VP_N_DIA_SEMANA=2		
				SET @VP_PESO_A_APLICAR = @VP_PESO_2_MARTES			
			ELSE
				IF @VP_N_DIA_SEMANA=3		
					SET @VP_PESO_A_APLICAR = @VP_PESO_3_MIERCOLES		
				ELSE
					IF @VP_N_DIA_SEMANA=4		
						SET @VP_PESO_A_APLICAR = @VP_PESO_4_JUEVES			
					ELSE
						IF @VP_N_DIA_SEMANA=5		
							SET @VP_PESO_A_APLICAR = @VP_PESO_5_VIERNES			
						ELSE
							IF @VP_N_DIA_SEMANA=6		
								SET @VP_PESO_A_APLICAR = @VP_PESO_6_SABADO			
							ELSE
								SET @VP_PESO_A_APLICAR = @VP_PESO_7_DOMINGO			
		
		-- =============================		

		SET @VP_N_DIA_SEMANA = @VP_N_DIA_SEMANA +@VP_N_DIA

		EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
																@PP_K_DATO_D0M4_PESO, @VP_PESO_A_APLICAR, @VP_N_DIA
		-- =============================		
		
		SET		@VP_N_DIA = @VP_N_DIA + 1

		END

	-- ////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4,
														@PP_K_DATO_D0M4_PESO

	-- //////////////////////////////////////////////////////////////
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_101b_VENTA_X_PERFIL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_101b_VENTA_X_PERFIL]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_101b_VENTA_X_PERFIL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_PERFIL		INT,
	@PP_K_DATO_D0M4_VENTA		INT,
	-- ==============================
	@PP_L_CONTADO				INT

AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_101b_VENTA_X_PERFIL]'

	-- ////////////////////////////////////////////////

	DECLARE @VP_VENTA_MENSUAL		DECIMAL(19,4);
	
	IF @PP_L_CONTADO=1
		SELECT	@VP_VENTA_MENSUAL =			P1003_VENTA_KG_CONTADO	
											FROM	PARAMETRO_DOCUMENTO_D0M4
											WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	ELSE
		SELECT	@VP_VENTA_MENSUAL =			P1004_VENTA_KG_CREDITO
											FROM	PARAMETRO_DOCUMENTO_D0M4
											WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_CA_MATE_N1_10B_ASIGNAR_VALOR]		@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_VENTA, 0, 0.00

	-- ==========================================

	DECLARE @VP_PESO_ACUMULADO	DECIMAL(19,4);
	
--	EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]		@PP_K_DOCUMENTO_D0M4,
	EXECUTE [dbo].[PG_FG_DATA_N1_DATO_ACUMULADO]	@PP_K_DOCUMENTO_D0M4,
													@PP_K_DATO_D0M4_PERFIL,	
													@OU_VALOR = @VP_PESO_ACUMULADO		OUTPUT
	-- ==========================================
	
	IF @VP_PESO_ACUMULADO=0		-- WIWI // HGF // VALIDAR CASO CERO
		SET @VP_PESO_ACUMULADO = -7

	DECLARE @VP_PESO_A_APLICAR	DECIMAL(19,4);
	DECLARE @VP_VENTA_X_DIA		DECIMAL(19,4);

	DECLARE @VP_N_DIA			INT = 1;

	WHILE (@VP_N_DIA<=31)
		BEGIN

		EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
													@PP_K_DATO_D0M4_PERFIL, @VP_N_DIA,	
													@OU_VALOR = @VP_PESO_A_APLICAR		OUTPUT
		-- =============================		
		
		IF @VP_PESO_ACUMULADO=-7
			SET	@VP_VENTA_X_DIA = @VP_VENTA_MENSUAL * ( 1/7 )
		ELSE
			SET	@VP_VENTA_X_DIA = @VP_VENTA_MENSUAL * ( @VP_PESO_A_APLICAR/@VP_PESO_ACUMULADO )

		-- =============================		

		EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
																@PP_K_DATO_D0M4_VENTA, @VP_VENTA_X_DIA, @VP_N_DIA
		-- =============================		
		
		SET		@VP_N_DIA = @VP_N_DIA + 1

		END

	-- ////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4,
														@PP_K_DATO_D0M4_VENTA

	-- //////////////////////////////////////////////////////////////
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_101c_CALCULO_DESCUENTOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_101c_CALCULO_DESCUENTOS]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_101c_CALCULO_DESCUENTOS]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_101c_CALCULO_DESCUENTOS]'

	-- ==============================================
		
	DECLARE @VP_DESCUENTO_X_KILO			DECIMAL(19,4)  
	DECLARE @VP_PARTICIPACION_CREDITO		DECIMAL(19,4)  
	DECLARE @VP_PARTICIPACION_CONTADO		DECIMAL(19,4)  


	SELECT	@VP_DESCUENTO_X_KILO =			[P2016_DTO_DESCUENTO_X_KG],
			@VP_PARTICIPACION_CONTADO =		[DESCUENTO_CONTADO],
			@VP_PARTICIPACION_CREDITO =		[DESCUENTO_CREDITO]
											FROM	PARAMETRO_DOCUMENTO_D0M4
											WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	-- ====================================

	DECLARE @VP_D1002_VENTA_KG_TOTAL		DECIMAL(19,4) = 0
	DECLARE @VP_D1003_VENTA_KG_CONTADO		DECIMAL(19,4) = 0
	DECLARE @VP_D1004_VENTA_KG_CREDITO		DECIMAL(19,4) = 0
	
	EXECUTE [dbo].[PG_FG_DATA_N1_DATO_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, 1002,
													@OU_VALOR = @VP_D1002_VENTA_KG_TOTAL			OUTPUT
	
	EXECUTE [dbo].[PG_FG_DATA_N1_DATO_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, 1003,
													@OU_VALOR = @VP_D1003_VENTA_KG_CONTADO			OUTPUT

	EXECUTE [dbo].[PG_FG_DATA_N1_DATO_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, 1004,
													@OU_VALOR = @VP_D1004_VENTA_KG_CREDITO			OUTPUT

	IF @PP_L_DEBUG>1
		BEGIN
		PRINT	'@VP_D1002_VENTA_KG_TOTAL   = ' + CONVERT(VARCHAR(100), @VP_D1002_VENTA_KG_TOTAL)
		PRINT	'@VP_VENTA_KG_CONTADO       = ' + CONVERT(VARCHAR(100), @VP_D1003_VENTA_KG_CONTADO)
		PRINT	'@VP_VENTA_KG_CREDITO       = ' + CONVERT(VARCHAR(100), @VP_D1004_VENTA_KG_CREDITO)
		END

	-- ==============================================

	DECLARE @VP_DESCUENTO_ACUMULADO_TOTAL		DECIMAL(19,4) = 0

	SET		@VP_DESCUENTO_ACUMULADO_TOTAL = ( @VP_D1002_VENTA_KG_TOTAL * @VP_DESCUENTO_X_KILO )

	IF @PP_L_DEBUG>1
		PRINT	'@VP_DESCUENTO_ACUMULADO_TOTAL = ' + CONVERT(VARCHAR(100),@VP_DESCUENTO_ACUMULADO_TOTAL)

	-- ==============================================

	DECLARE @VP_DESCUENTO_ACUMULADO_CONTADO		DECIMAL(19,4) = 0
	DECLARE @VP_DESCUENTO_ACUMULADO_CREDITO		DECIMAL(19,4) = 0
	
	SET @VP_DESCUENTO_ACUMULADO_CONTADO	= ( @VP_DESCUENTO_ACUMULADO_TOTAL * @VP_PARTICIPACION_CONTADO )

	SET @VP_DESCUENTO_ACUMULADO_CREDITO	= ( @VP_DESCUENTO_ACUMULADO_TOTAL - @VP_DESCUENTO_ACUMULADO_CONTADO )

	IF @PP_L_DEBUG>1
		PRINT	'@VP_DESCUENTO_ACUMULADO_CONTADO = ' + CONVERT(VARCHAR(100),@VP_DESCUENTO_ACUMULADO_CONTADO)
	IF @PP_L_DEBUG>1
		PRINT	'@VP_DESCUENTO_ACUMULADO_CREDITO = ' + CONVERT(VARCHAR(100),@VP_DESCUENTO_ACUMULADO_CREDITO)

	-- ==============================================

	DECLARE @VP_DESCUENTO_X_KILO_CONTADO		DECIMAL(19,4) = 0
	DECLARE @VP_DESCUENTO_X_KILO_CREDITO		DECIMAL(19,4) = 0
	
	IF @VP_D1003_VENTA_KG_CONTADO<>0
		SET @VP_DESCUENTO_X_KILO_CONTADO =			@VP_DESCUENTO_ACUMULADO_CONTADO / @VP_D1003_VENTA_KG_CONTADO
	
	IF @VP_D1004_VENTA_KG_CREDITO<>0
		SET @VP_DESCUENTO_X_KILO_CREDITO =			@VP_DESCUENTO_ACUMULADO_CREDITO	/ @VP_D1004_VENTA_KG_CREDITO

	IF @PP_L_DEBUG>1
		PRINT	'@VP_DESCUENTO_X_KILO_CONTADO = ' + CONVERT(VARCHAR(100),@VP_DESCUENTO_X_KILO_CONTADO)
	IF @PP_L_DEBUG>1
		PRINT	'@VP_DESCUENTO_X_KILO_CREDITO = ' + CONVERT(VARCHAR(100),@VP_DESCUENTO_X_KILO_CREDITO)

	-- ==============================================

	EXECUTE [dbo].[PG_CA_MATE_N1_10B_ASIGNAR_VALOR]	@PP_K_DOCUMENTO_D0M4, 1014, 0, @VP_DESCUENTO_X_KILO_CONTADO		

	EXECUTE [dbo].[PG_CA_MATE_N1_10B_ASIGNAR_VALOR]	@PP_K_DOCUMENTO_D0M4, 1015, 0, @VP_DESCUENTO_X_KILO_CREDITO

	-- ==============================================
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_101f_INGRESOS_DIARIOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_101f_INGRESOS_DIARIOS]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_101f_INGRESOS_DIARIOS]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_101f_INGRESOS_DIARIOS]'

	-- ==============================

	DECLARE @ID_P1020_DIA_SEMANA			INT = 1020;
	DECLARE @ID_P1027_ASUETOS				INT = 1027;
	DECLARE @ID_P1018_VENTA_NETA_CONTADO	INT = 1018;
	DECLARE @ID_P1009_INGRESOS_X_VENTA		INT = 1009;

	-- ==============================

	DECLARE @VP_N_DIA_SEMANA				DECIMAL(19,4);
	DECLARE @VP_L_ASUETO					INT = 0;

	DECLARE @VP_INGRESOS_X_VENTA_5_VIE		DECIMAL(19,4);
	DECLARE @VP_INGRESOS_X_VENTA_6_SAB		DECIMAL(19,4);
	DECLARE @VP_INGRESOS_X_VENTA_7_DOM		DECIMAL(19,4);

	DECLARE @VP_INGRESOS_X_VENTA			DECIMAL(19,4);

	DECLARE @VP_INGRESOS_REZAGADOS			DECIMAL(19,4) = 0;

	DECLARE @VP_N_DIA_ANTERIOR				INT = 1;
	DECLARE @VP_N_DIA_SIN_DEPOSITO			INT = 1;

	-- ==============================

	DECLARE @VP_N_DIA						INT = 1;

	WHILE (@VP_N_DIA<=31)
		BEGIN
		
		SET @VP_N_DIA_ANTERIOR = (@VP_N_DIA-1)
		
		-- ////////////////////////////////////////////////////
		
		EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
													@ID_P1020_DIA_SEMANA, @VP_N_DIA,	
													@OU_VALOR = @VP_N_DIA_SEMANA		OUTPUT
		-- ======================================
		
		EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
													@ID_P1027_ASUETOS, @VP_N_DIA,	
													@OU_VALOR = @VP_L_ASUETO			OUTPUT
		-- ======================================


		-- ////////////////////////////////////////////////////
		-- // INGRESOS X VENTA
		
		IF @VP_N_DIA_SEMANA IN ( 6, 7 )				-- SAB/DOM = NO DEPOSITOS
			SET @VP_INGRESOS_X_VENTA = 0
		ELSE
			IF @VP_N_DIA_SEMANA IN ( 2,3,4,5 )		-- MAR/MIE/JUE/VIE = DEPOSITOS DIA ANTERIOR
				BEGIN

				EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
															@ID_P1018_VENTA_NETA_CONTADO, @VP_N_DIA_ANTERIOR,	
															@OU_VALOR = @VP_INGRESOS_X_VENTA		OUTPUT			
				END
			ELSE
				BEGIN								-- LUN = DEPOSITOS VIE+SAB+DOM ANTERIOR
				
				SET @VP_N_DIA_SIN_DEPOSITO = ( @VP_N_DIA - 1 )
				
				EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
															@ID_P1018_VENTA_NETA_CONTADO, @VP_N_DIA_SIN_DEPOSITO,	-- VENTA CONTADO DOMINGO	
															@OU_VALOR = @VP_INGRESOS_X_VENTA_5_VIE		OUTPUT

				SET @VP_N_DIA_SIN_DEPOSITO = ( @VP_N_DIA - 2 )

				EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
															@ID_P1018_VENTA_NETA_CONTADO, @VP_N_DIA_SIN_DEPOSITO,	-- VENTA CONTADO SABADO
															@OU_VALOR = @VP_INGRESOS_X_VENTA_6_SAB		OUTPUT

				SET @VP_N_DIA_SIN_DEPOSITO = ( @VP_N_DIA - 3 )

				EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
															@ID_P1018_VENTA_NETA_CONTADO, @VP_N_DIA_SIN_DEPOSITO,	-- VENTA CONTADO VIERNES
															@OU_VALOR = @VP_INGRESOS_X_VENTA_7_DOM		OUTPUT
				-- =================
	
				SET @VP_INGRESOS_X_VENTA = ( @VP_INGRESOS_X_VENTA_5_VIE + @VP_INGRESOS_X_VENTA_6_SAB + @VP_INGRESOS_X_VENTA_7_DOM )

				END

		-- =============================		
		
		IF @VP_L_ASUETO=1
			BEGIN
			
			SET		@VP_INGRESOS_REZAGADOS = @VP_INGRESOS_X_VENTA
			SET		@VP_INGRESOS_X_VENTA = 0
			
			END
		ELSE
			IF NOT ( @VP_N_DIA_SEMANA IN ( 6, 7 ) )				-- SAB/DOM = NO DEPOSITOS
				SET		@VP_INGRESOS_X_VENTA =  ( @VP_INGRESOS_X_VENTA + @VP_INGRESOS_REZAGADOS )

		
		EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
																@ID_P1009_INGRESOS_X_VENTA,	@VP_INGRESOS_X_VENTA, @VP_N_DIA
		-- =============================		
		SET @VP_N_DIA = @VP_N_DIA + 1;
		
		END;

	-- /////////////////////////////////////////////////////////////
	
	EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4,
														@ID_P1009_INGRESOS_X_VENTA

	-- /////////////////////////////////////////////////////////////
GO





-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_101g_SALDOS_CYC]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_101g_SALDOS_CYC]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_101g_SALDOS_CYC]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_101g_SALDOS_CYC]'
	
	-- ================================

	DECLARE @VP_CARTERA_CYC_INICIAL		DECIMAL(19,4);

	DECLARE @VP_N_DIA					INT = 1;
	DECLARE @VP_N_DIA_ANTERIOR			INT = 1;

	WHILE (@VP_N_DIA<=31)
		BEGIN
		
		SET @VP_N_DIA_ANTERIOR = (@VP_N_DIA-1)

		-- ////////////////////////////////////////////////////
		-- // CARTERA

		-- CARTERA CYC ($) / INICIAL	PESOS	1012 -- =========================
		
		EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
													1013, @VP_N_DIA_ANTERIOR,	-- OBTIENE CARTERA FINAL DEL DIA ANTERIOR
													@OU_VALOR = @VP_CARTERA_CYC_INICIAL		OUTPUT
		 		
		EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
																1012,	@VP_CARTERA_CYC_INICIAL, @VP_N_DIA
	
		-- CARTERA CYC ($) / FINAL	PESOS	1013 -- =============================
		EXECUTE [dbo].[PG_CA_MATE_N1_01A_SUMAR_A_MAS_B]		@PP_K_DOCUMENTO_D0M4,	
															1013,	0,	1012, 1019		-- SF = SALDO INICIAL + VENTA$ CREDITO
		EXECUTE [dbo].[PG_CA_MATE_N1_05B_ACUMULAR_MENOS_A]	@PP_K_DOCUMENTO_D0M4,	
															1013,	0,	1007			-- SF = SF - COBRAN$A
		-- =============================		
		SET @VP_N_DIA = @VP_N_DIA + 1;
		
		END;

	-- /////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_101d_PERFIL_COBRANZA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_101d_PERFIL_COBRANZA]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_101d_PERFIL_COBRANZA]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_DIA_SEMANA	INT,
	@PP_K_DATO_D0M4_PESO		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_101d_PERFIL_COBRANZA]'

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_CA_MATE_N1_10B_ASIGNAR_VALOR]		@PP_K_DOCUMENTO_D0M4,  
														@PP_K_DATO_D0M4_PESO, 0, 0.00

	-- ////////////////////////////////////////////////

	DECLARE @VP_PESO_1_LUNES			DECIMAL(19,4) = 0,
			@VP_PESO_2_MARTES			DECIMAL(19,4) = 0,
			@VP_PESO_3_MIERCOLES		DECIMAL(19,4) = 0,
			@VP_PESO_4_JUEVES			DECIMAL(19,4) = 0,
			@VP_PESO_5_VIERNES			DECIMAL(19,4) = 0,
			@VP_PESO_6_SABADO			DECIMAL(19,4) = 0,
			@VP_PESO_7_DOMINGO			DECIMAL(19,4) = 0


	SELECT	@VP_PESO_1_LUNES =			PERFIL_COBRANZA_1_LUNES,
			@VP_PESO_2_MARTES =			PERFIL_COBRANZA_2_MARTES,	
			@VP_PESO_3_MIERCOLES =		PERFIL_COBRANZA_3_MIERCOLES,	
			@VP_PESO_4_JUEVES =			PERFIL_COBRANZA_4_JUEVES,	
			@VP_PESO_5_VIERNES =		PERFIL_COBRANZA_5_VIERNES,	
			@VP_PESO_6_SABADO =			PERFIL_COBRANZA_6_SABADO,	
			@VP_PESO_7_DOMINGO =		PERFIL_COBRANZA_7_DOMINGO	
										FROM	PARAMETRO_DOCUMENTO_D0M4
										WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	-- ////////////////////////////////////////////////

	DECLARE @VP_N_DIA_MAX		INT 

	SELECT	@VP_N_DIA_MAX =		MAX(FECHA_DD)
								FROM	TIEMPO_FECHA, DOCUMENTO_D0M4	
								WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4 
								AND		TIEMPO_FECHA.FECHA_YYYY=DOCUMENTO_D0M4.K_YYYY
								AND		TIEMPO_FECHA.K_TIEMPO_MES=DOCUMENTO_D0M4.K_MM
	-- ======================

	DECLARE @VP_COBRANZA_HOLGURA		DECIMAL(19,4) = 0
			
	SELECT	@VP_COBRANZA_HOLGURA =		COBRANZA_HOLGURA
										FROM	PARAMETRO_DOCUMENTO_D0M4
										WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	-- ======================
	
	DECLARE @VP_PESO_A_APLICAR	DECIMAL(19,4);

	DECLARE @VP_N_DIA_SEMANA	INT = 1;
	DECLARE @VP_L_ASUETO		INT = 0;

	DECLARE @VP_N_DIA			INT = 1;

	WHILE (@VP_N_DIA<=@VP_N_DIA_MAX)
		BEGIN

		EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
													@PP_K_DATO_D0M4_DIA_SEMANA, @VP_N_DIA,	
													@OU_VALOR = @VP_N_DIA_SEMANA		OUTPUT
		-- =============================		
		
		EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
													1027, @VP_N_DIA,	
													@OU_VALOR = @VP_L_ASUETO		OUTPUT
		-- =============================	

		IF @VP_L_ASUETO=1
			SET @VP_PESO_A_APLICAR = 0
		ELSE
			IF @VP_N_DIA_SEMANA=1		
				SET @VP_PESO_A_APLICAR = @VP_PESO_1_LUNES		
			ELSE
				IF @VP_N_DIA_SEMANA=2		
					SET @VP_PESO_A_APLICAR = @VP_PESO_2_MARTES			
				ELSE
					IF @VP_N_DIA_SEMANA=3		
						SET @VP_PESO_A_APLICAR = @VP_PESO_3_MIERCOLES		
					ELSE
						IF @VP_N_DIA_SEMANA=4		
							SET @VP_PESO_A_APLICAR = @VP_PESO_4_JUEVES			
						ELSE
							IF @VP_N_DIA_SEMANA=5		
								SET @VP_PESO_A_APLICAR = @VP_PESO_5_VIERNES			
							ELSE
								IF @VP_N_DIA_SEMANA=6		
									SET @VP_PESO_A_APLICAR = @VP_PESO_6_SABADO			
								ELSE
									SET @VP_PESO_A_APLICAR = @VP_PESO_7_DOMINGO			
		
		-- =============================		

		IF @VP_N_DIA>25
			SET @VP_PESO_A_APLICAR = ( @VP_PESO_A_APLICAR * (1-@VP_COBRANZA_HOLGURA) )
		
		EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
																@PP_K_DATO_D0M4_PESO, @VP_PESO_A_APLICAR, @VP_N_DIA
		-- =============================		

		SET		@VP_N_DIA_SEMANA = @VP_N_DIA_SEMANA +@VP_N_DIA

		SET		@VP_N_DIA = @VP_N_DIA + 1

		END

	-- ////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4,
														@PP_K_DATO_D0M4_PESO

	-- //////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_101e_COBRANZA_X_PERFIL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_101e_COBRANZA_X_PERFIL]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_101e_COBRANZA_X_PERFIL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_PERFIL		INT,
	@PP_K_DATO_D0M4_COBRANZA	INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_101e_COBRANZA_X_PERFIL]'

	-- ////////////////////////////////////////////////

	
	DECLARE @VP_P1012_CARTERA_CYC_INICIAL		DECIMAL(19,4);
	DECLARE @VP_P1013_CARTERA_CYC_FINAL			DECIMAL(19,4);
		
	SELECT	@VP_P1012_CARTERA_CYC_INICIAL =		P1012_CARTERA_CYC_INICIAL,
			@VP_P1013_CARTERA_CYC_FINAL =		P1013_CARTERA_CYC_FINAL
												FROM	PARAMETRO_DOCUMENTO_D0M4
												WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
															1012, @VP_P1012_CARTERA_CYC_INICIAL, 0

	EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
															1013, @VP_P1012_CARTERA_CYC_INICIAL, 0

	-- ////////////////////////////////////////////////

	DECLARE @VP_1019_VENTA_CREDITO_MES				DECIMAL(19,4) = 0;

	EXECUTE [dbo].[PG_FG_DATA_N1_DATO_ACUMULADO]	@PP_K_DOCUMENTO_D0M4,
													1019,	
													@OU_VALOR = @VP_1019_VENTA_CREDITO_MES		OUTPUT

	-- ////////////////////////////////////////////////

	DECLARE @VP_COBRANZA_MENSUAL	DECIMAL(19,4);
	
	SET		@VP_COBRANZA_MENSUAL = ( @VP_P1012_CARTERA_CYC_INICIAL + @VP_1019_VENTA_CREDITO_MES ) - @VP_P1013_CARTERA_CYC_FINAL 

	IF @VP_COBRANZA_MENSUAL<0
		SET @VP_COBRANZA_MENSUAL = 0

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_CA_MATE_N1_10B_ASIGNAR_VALOR]		@PP_K_DOCUMENTO_D0M4, 
														@PP_K_DATO_D0M4_COBRANZA, 0, 0.00
	-- ==========================================

	DECLARE @VP_PESO_ACUMULADO	DECIMAL(19,4);
	
--	EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]		@PP_K_DOCUMENTO_D0M4,
	EXECUTE [dbo].[PG_FG_DATA_N1_DATO_ACUMULADO]	@PP_K_DOCUMENTO_D0M4,
													@PP_K_DATO_D0M4_PERFIL,	
													@OU_VALOR = @VP_PESO_ACUMULADO		OUTPUT
	-- ==========================================

	IF @VP_PESO_ACUMULADO=0		-- WIWI // HGF // VALIDAR CASO CERO
		SET @VP_PESO_ACUMULADO = -7

	DECLARE @VP_PESO_A_APLICAR		DECIMAL(19,4);
	DECLARE @VP_COBRANZA_X_DIA		DECIMAL(19,4);
		
	DECLARE @VP_N_DIA				INT = 1;

	WHILE (@VP_N_DIA<=31)
		BEGIN

		EXECUTE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]	@PP_K_DOCUMENTO_D0M4,
													@PP_K_DATO_D0M4_PERFIL, @VP_N_DIA,	
													@OU_VALOR = @VP_PESO_A_APLICAR		OUTPUT
		-- =============================		
		
		IF @VP_PESO_ACUMULADO=-7
			SET	@VP_COBRANZA_X_DIA = @VP_COBRANZA_MENSUAL * ( 1/7 )
		ELSE
			SET	@VP_COBRANZA_X_DIA = @VP_COBRANZA_MENSUAL * ( @VP_PESO_A_APLICAR/@VP_PESO_ACUMULADO )

		-- =============================		

		EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
																@PP_K_DATO_D0M4_COBRANZA, @VP_COBRANZA_X_DIA, @VP_N_DIA
		-- =============================		
		
		SET		@VP_N_DIA = @VP_N_DIA + 1

		END

	-- ////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4,
														@PP_K_DATO_D0M4_COBRANZA

	-- //////////////////////////////////////////////////////////////
GO





-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_101_COMPROMISO_RECALCULAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_101_COMPROMISO_RECALCULAR]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_101_COMPROMISO_RECALCULAR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '////////////////////////////////////////////////////// CEMEC / [PG_OP_DATA_N1_101_COMPROMISO_RECALCULAR]'

	-- ==============================================
	--	#1020	(P@) DIA DE LA SEMANA / CEME
	--  #1027	(P@) ASUETO / CEME
	DECLARE @ID_P1020_DIA_SEMANA		INT = 1020;
	DECLARE @ID_P1027_ASUETOS			INT = 1027;
	
	EXECUTE [dbo].[PG_OP_DATA_N1_DIA_SEMANA_Y_ASUETOS_CALCULAR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_DOCUMENTO_D0M4, @ID_P1020_DIA_SEMANA, @ID_P1027_ASUETOS

	-- ==============================================
	-- 1001	PRECIO VENTA ($)

	DECLARE @VP_P1001_PV_PRECIO_VENTA_X_KG		DECIMAL(19,4) = 0

	EXECUTE [dbo].[PG_RN_PV_PRECIO_VENTA_KG_X_K_DOCUMENTO_D0M4]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_DOCUMENTO_D0M4,
																	@OU_PV_PRECIO_VENTA_X_KG = @VP_P1001_PV_PRECIO_VENTA_X_KG		OUTPUT
	
	-- WIWI // HGF // 20181031 // PRUEBAS ASISTENTE CEMEC
	SET @VP_P1001_PV_PRECIO_VENTA_X_KG = 20.00

	EXECUTE [dbo].[PG_CA_MATE_N1_10B_ASIGNAR_VALOR]	@PP_K_DOCUMENTO_D0M4, 1001, 0, @VP_P1001_PV_PRECIO_VENTA_X_KG

	IF @VP_P1001_PV_PRECIO_VENTA_X_KG=0
		BEGIN
		IF @PP_L_DEBUG>1
			PRINT '@VP_P1001_PV_PRECIO_VENTA_X_KG = CERO'
		END
	ELSE
		BEGIN
		-- ============================================== ////////////////////////////////////////////////////////
		--	1021	PERFIL - VENTA (KG) / CONTADO
		--	1003	VENTA (KG) / CONTADO
		DECLARE @VP_VENTA_KG_X_MES_CONTADO		DECIMAL(19,4)	=	00 

		EXECUTE [dbo].[PG_OP_DATA_N1_101a_PERFIL_VENTA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4, @ID_P1020_DIA_SEMANA, 1021, 1003,
															1

		EXECUTE [dbo].[PG_OP_DATA_N1_101b_VENTA_X_PERFIL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4, 1021, 1003,
															1
																	
		-- ============================================== ////////////////////////////////////////////////////////
		--	1022	PERFIL - VENTA (KG) / CREDITO
		--	1004	VENTA (KG) / CREDITO
		DECLARE @VP_VENTA_KG_X_MES_CREDITO		DECIMAL(19,4)	=	00

		EXECUTE [dbo].[PG_OP_DATA_N1_101a_PERFIL_VENTA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4, @ID_P1020_DIA_SEMANA, 1022, 1004,
															0

		EXECUTE [dbo].[PG_OP_DATA_N1_101b_VENTA_X_PERFIL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4, 1022, 1004,
															0

		-- ============================================== ////////////////////////////////////////////////////////
		-- VENTA (KG)	KG	1002				
		EXECUTE [dbo].[PG_CA_MATE_N1_01A_SUMAR_A_MAS_B]		@PP_K_DOCUMENTO_D0M4,	
															1002,	1,	1003, 1004
		-- ==============================================

		EXECUTE [dbo].[PG_OP_DATA_N1_101c_CALCULO_DESCUENTOS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_DOCUMENTO_D0M4		
		-- ==============================================
		-- VENTA ($) / CONTADO	PESOS	1005	
		EXECUTE [dbo].[PG_CA_MATE_N1_03A_MULTIPLICAR_A_X_B]		@PP_K_DOCUMENTO_D0M4,	
																1005,	1,	1003, 1001
		-- DESCUENTO S/VENTA ($) / CONTADO	1	1016
		EXECUTE [dbo].[PG_CA_MATE_N1_03A_MULTIPLICAR_A_X_B]		@PP_K_DOCUMENTO_D0M4,	
																1016,	1,	1003, 1014
		-- VENTA NETA ($) / CONTADO	1	1018
		EXECUTE [dbo].[PG_CA_MATE_N1_02A_RESTAR_A_MENOS_B]		@PP_K_DOCUMENTO_D0M4,	
																1018,	1,	1005, 1016

		-- ==============================================
		-- VENTA ($) / CREDITO	PESOS	1006	
		EXECUTE [dbo].[PG_CA_MATE_N1_03A_MULTIPLICAR_A_X_B]		@PP_K_DOCUMENTO_D0M4,	
																1006,	1,	1004, 1001
		-- DESCUENTO S/VENTA ($) / CREDITO	1	1017
		EXECUTE [dbo].[PG_CA_MATE_N1_03A_MULTIPLICAR_A_X_B]		@PP_K_DOCUMENTO_D0M4,	
																1017,	1,	1004, 1015
		-- VENTA NETA ($) / CREDITO	1	1019
		EXECUTE [dbo].[PG_CA_MATE_N1_02A_RESTAR_A_MENOS_B]		@PP_K_DOCUMENTO_D0M4,	
																1019,	1,	1006, 1017

		-- ==============================================
		-- 	1008	NOMINA ($)
		EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]		@PP_K_DOCUMENTO_D0M4,
																1008

		-- ==============================================
		-- 1023	PERFIL - COBRANZA ($) / CREDITO
		EXECUTE [dbo].[PG_OP_DATA_N1_101d_PERFIL_COBRANZA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_DOCUMENTO_D0M4,
																@ID_P1020_DIA_SEMANA, 1023
		-- 1007	COBRANZA ($)	-- =========================
		EXECUTE [dbo].[PG_OP_DATA_N1_101e_COBRANZA_X_PERFIL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_DOCUMENTO_D0M4, 1023, 1007
															
		-- INGRESOS X COBRANZA ($)	PESOS	1010	-- =========================
		EXECUTE [dbo].[PG_CA_MATE_N1_10A_ASIGNAR_A]				@PP_K_DOCUMENTO_D0M4,	
																1010,	1,	1007

		-- ////////////////////////////////////////////////

		EXECUTE [dbo].[PG_OP_DATA_N1_101f_INGRESOS_DIARIOS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_DOCUMENTO_D0M4

		EXECUTE [dbo].[PG_OP_DATA_N1_101g_SALDOS_CYC]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_DOCUMENTO_D0M4

		-- //////////////////////////////////////////////////////////////

		-- INGRESOS TOTALES ($)	PESOS	1011	-- =============================
		EXECUTE [dbo].[PG_CA_MATE_N1_01A_SUMAR_A_MAS_B]			@PP_K_DOCUMENTO_D0M4,	
																1011,	0,	1009, 1010

		EXECUTE [dbo].[PG_CA_MATE_N1_05B_ACUMULAR_MENOS_A]		@PP_K_DOCUMENTO_D0M4,	
																1011,	1,	1008			-- MENOS TOMAS DE NOMINA		
		-- //////////////////////////////////////////
		-- // DOCUMENTO_D0M4 >> ACTUALIZAR ESTATUS
		EXECUTE	[dbo].[PG_UP_DOCUMENTO_D0M4_L_RECALCULADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_DOCUMENTO_D0M4

		EXECUTE [dbo].[PG_TR_DOCUMENTO_D0M4_ESTATUS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_DOCUMENTO_D0M4, 3		-- K_ESTATUS_DOCUMENTO_D0M4	// #3 PREVIO
				
		END

	-- //////////////////////////////////////////////////////////////
GO




-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////

