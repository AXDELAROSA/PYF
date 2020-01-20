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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PARAMETRO_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PARAMETRO_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_CI_PARAMETRO_DOCUMENTO_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	@PP_K_DOCUMENTO_D0M4		INT,
	-- ==================================
	@PP_P2016_DTO_DESCUENTO_X_KG			DECIMAL(19,4), 
	@PP_DESCUENTO_CONTADO					DECIMAL(19,4), 
	@PP_DESCUENTO_CREDITO					DECIMAL(19,4), 
	@PP_P2023_PCN							DECIMAL(19,4), 
	@PP_P1003_VENTA_KG_CONTADO				DECIMAL(19,4), 
	@PP_P1004_VENTA_KG_CREDITO				DECIMAL(19,4), 
	-- ==================================
	@PP_P1012_CARTERA_CYC_INICIAL			DECIMAL(19,4), 
	@PP_P1013_CARTERA_CYC_FINAL				DECIMAL(19,4), 
	@PP_COBRANZA_HOLGURA					DECIMAL(19,4),
	-- ==================================
	@PP_PERFIL_VENTA_CONTADO_1_LUNES		DECIMAL(19,4), 
	@PP_PERFIL_VENTA_CONTADO_2_MARTES		DECIMAL(19,4), 
	@PP_PERFIL_VENTA_CONTADO_3_MIERCOLES	DECIMAL(19,4), 
	@PP_PERFIL_VENTA_CONTADO_4_JUEVES		DECIMAL(19,4), 
	@PP_PERFIL_VENTA_CONTADO_5_VIERNES		DECIMAL(19,4), 
	@PP_PERFIL_VENTA_CONTADO_6_SABADO		DECIMAL(19,4), 
	@PP_PERFIL_VENTA_CONTADO_7_DOMINGO		DECIMAL(19,4), 
	-- ==================================
	@PP_PERFIL_VENTA_CREDITO_1_LUNES		DECIMAL(19,4), 
	@PP_PERFIL_VENTA_CREDITO_2_MARTES		DECIMAL(19,4), 
	@PP_PERFIL_VENTA_CREDITO_3_MIERCOLES	DECIMAL(19,4), 
	@PP_PERFIL_VENTA_CREDITO_4_JUEVES		DECIMAL(19,4), 
	@PP_PERFIL_VENTA_CREDITO_5_VIERNES		DECIMAL(19,4), 
	@PP_PERFIL_VENTA_CREDITO_6_SABADO		DECIMAL(19,4), 
	@PP_PERFIL_VENTA_CREDITO_7_DOMINGO		DECIMAL(19,4), 
	-- ==================================
	@PP_PERFIL_COBRANZA_1_LUNES				DECIMAL(19,4), 
	@PP_PERFIL_COBRANZA_2_MARTES			DECIMAL(19,4), 
	@PP_PERFIL_COBRANZA_3_MIERCOLES			DECIMAL(19,4), 
	@PP_PERFIL_COBRANZA_4_JUEVES			DECIMAL(19,4), 
	@PP_PERFIL_COBRANZA_5_VIERNES			DECIMAL(19,4), 
	@PP_PERFIL_COBRANZA_6_SABADO			DECIMAL(19,4), 
	@PP_PERFIL_COBRANZA_7_DOMINGO			DECIMAL(19,4)
AS

	INSERT INTO PARAMETRO_DOCUMENTO_D0M4
		(	[K_DOCUMENTO_D0M4], 
			-- ============================
			[P2016_DTO_DESCUENTO_X_KG], [DESCUENTO_CONTADO], [DESCUENTO_CREDITO], 
			[P2023_PCN], 
			[P1003_VENTA_KG_CONTADO], [P1004_VENTA_KG_CREDITO], 
			[P1012_CARTERA_CYC_INICIAL], [P1013_CARTERA_CYC_FINAL], [COBRANZA_HOLGURA], 
			-- ============================
			[PERFIL_VENTA_CONTADO_1_LUNES], [PERFIL_VENTA_CONTADO_2_MARTES], [PERFIL_VENTA_CONTADO_3_MIERCOLES], [PERFIL_VENTA_CONTADO_4_JUEVES], [PERFIL_VENTA_CONTADO_5_VIERNES], [PERFIL_VENTA_CONTADO_6_SABADO], [PERFIL_VENTA_CONTADO_7_DOMINGO], 
			[PERFIL_VENTA_CREDITO_1_LUNES], [PERFIL_VENTA_CREDITO_2_MARTES], [PERFIL_VENTA_CREDITO_3_MIERCOLES], [PERFIL_VENTA_CREDITO_4_JUEVES], [PERFIL_VENTA_CREDITO_5_VIERNES], [PERFIL_VENTA_CREDITO_6_SABADO], [PERFIL_VENTA_CREDITO_7_DOMINGO], 
			[PERFIL_COBRANZA_1_LUNES], [PERFIL_COBRANZA_2_MARTES], [PERFIL_COBRANZA_3_MIERCOLES], [PERFIL_COBRANZA_4_JUEVES], [PERFIL_COBRANZA_5_VIERNES], [PERFIL_COBRANZA_6_SABADO], [PERFIL_COBRANZA_7_DOMINGO]
	  	)	
	VALUES	
		(	@PP_K_DOCUMENTO_D0M4, 
			-- ============================
			@PP_P2016_DTO_DESCUENTO_X_KG, @PP_DESCUENTO_CONTADO, @PP_DESCUENTO_CREDITO, 
			@PP_P2023_PCN, 
			@PP_P1003_VENTA_KG_CONTADO, @PP_P1004_VENTA_KG_CREDITO, 
			@PP_P1012_CARTERA_CYC_INICIAL, @PP_P1013_CARTERA_CYC_FINAL, @PP_COBRANZA_HOLGURA, 
			-- ============================
			@PP_PERFIL_VENTA_CONTADO_1_LUNES, @PP_PERFIL_VENTA_CONTADO_2_MARTES, @PP_PERFIL_VENTA_CONTADO_3_MIERCOLES, @PP_PERFIL_VENTA_CONTADO_4_JUEVES, @PP_PERFIL_VENTA_CONTADO_5_VIERNES, @PP_PERFIL_VENTA_CONTADO_6_SABADO, @PP_PERFIL_VENTA_CONTADO_7_DOMINGO, 
			@PP_PERFIL_VENTA_CREDITO_1_LUNES, @PP_PERFIL_VENTA_CREDITO_2_MARTES, @PP_PERFIL_VENTA_CREDITO_3_MIERCOLES, @PP_PERFIL_VENTA_CREDITO_4_JUEVES, @PP_PERFIL_VENTA_CREDITO_5_VIERNES, @PP_PERFIL_VENTA_CREDITO_6_SABADO, @PP_PERFIL_VENTA_CREDITO_7_DOMINGO, 
			@PP_PERFIL_COBRANZA_1_LUNES, @PP_PERFIL_COBRANZA_2_MARTES, @PP_PERFIL_COBRANZA_3_MIERCOLES, @PP_PERFIL_COBRANZA_4_JUEVES, @PP_PERFIL_COBRANZA_5_VIERNES, @PP_PERFIL_COBRANZA_6_SABADO, @PP_PERFIL_COBRANZA_7_DOMINGO
		)

	-- ==============================================

	EXECUTE [dbo].[PG_TR_DOCUMENTO_D0M4_ESTATUS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_DOCUMENTO_D0M4, 2		-- K_ESTATUS_DOCUMENTO_D0M4	// #2 WORKING

	-- ==============================================
GO




-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////



