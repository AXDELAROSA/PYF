-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////


DELETE 
FROM [dbo].[PARAMETRO_SUCURSAL] 

GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --> [PG_CI_PARAMETRO_SUCURSAL]
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PARAMETRO_SUCURSAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PARAMETRO_SUCURSAL]
GO


CREATE PROCEDURE [dbo].[PG_CI_PARAMETRO_SUCURSAL]
	@PP_L_DEBUG					    INT,
	@PP_K_SISTEMA_EXE			    INT,
	@PP_K_USUARIO_ACCION		    INT,	
	-- ===========================	
    @PP_K_PARAMETRO_SUCURSAL	INT,
	@PP_O_PARAMETRO_SUCURSAL	INT,
	@PP_D_PARAMETRO_SUCURSAL	VARCHAR(200),
	-- ===========================
	@PP_K_UNIDAD_OPERATIVA		    INT,
	@PP_K_YYYY					    INT,
	@PP_K_MM					    INT,
	-- ===========================				  
	@PP_P2016_DTO_DESCUENTO_X_KG				DECIMAL(19,4),
	@PP_DESCUENTO_CONTADO						DECIMAL(19,4),
	@PP_DESCUENTO_CREDITO						DECIMAL(19,4),
	@PP_P2023_PCN								DECIMAL(19,4),
	-- ===================================				  
	@PP_VENTA_PORCENTAJE_CONTADO				DECIMAL(19,4),
	@PP_VENTA_PORCENTAJE_CREDITO				DECIMAL(19,4),
	@PP_P1012_CARTERA_CYC_INICIAL				DECIMAL(19,4),
	@PP_P1013_CARTERA_CYC_FINAL					DECIMAL(19,4),
	@PP_COBRANZA_HOLGURA						DECIMAL(19,4),
	-- ===================================				  
	@PP_PERFIL_VENTA_CONTADO_1_LUNES			DECIMAL(19,4),
	@PP_PERFIL_VENTA_CONTADO_2_MARTES			DECIMAL(19,4),
	@PP_PERFIL_VENTA_CONTADO_3_MIERCOLES		DECIMAL(19,4),
	@PP_PERFIL_VENTA_CONTADO_4_JUEVES			DECIMAL(19,4),
	@PP_PERFIL_VENTA_CONTADO_5_VIERNES			DECIMAL(19,4),
	@PP_PERFIL_VENTA_CONTADO_6_SABADO			DECIMAL(19,4),
	@PP_PERFIL_VENTA_CONTADO_7_DOMINGO			DECIMAL(19,4),
	-- ===================================					  
	@PP_PERFIL_VENTA_CREDITO_1_LUNES			DECIMAL(19,4),
	@PP_PERFIL_VENTA_CREDITO_2_MARTES			DECIMAL(19,4),
	@PP_PERFIL_VENTA_CREDITO_3_MIERCOLES		DECIMAL(19,4),
	@PP_PERFIL_VENTA_CREDITO_4_JUEVES			DECIMAL(19,4),
	@PP_PERFIL_VENTA_CREDITO_5_VIERNES			DECIMAL(19,4),
	@PP_PERFIL_VENTA_CREDITO_6_SABADO			DECIMAL(19,4),
	@PP_PERFIL_VENTA_CREDITO_7_DOMINGO			DECIMAL(19,4),
	-- ===================================					  
	@PP_PERFIL_COBRANZA_1_LUNES					DECIMAL(19,4),
	@PP_PERFIL_COBRANZA_2_MARTES				DECIMAL(19,4),
	@PP_PERFIL_COBRANZA_3_MIERCOLES				DECIMAL(19,4),
	@PP_PERFIL_COBRANZA_4_JUEVES				DECIMAL(19,4),
	@PP_PERFIL_COBRANZA_5_VIERNES				DECIMAL(19,4),
	@PP_PERFIL_COBRANZA_6_SABADO				DECIMAL(19,4),
	@PP_PERFIL_COBRANZA_7_DOMINGO				DECIMAL(19,4), 				
	-- ====================================
	@PP_L_BORRADO								INT
AS

	INSERT INTO PARAMETRO_SUCURSAL
		(	
			[K_PARAMETRO_SUCURSAL],		
			[O_PARAMETRO_SUCURSAL],[D_PARAMETRO_SUCURSAL],
			[K_UNIDAD_OPERATIVA], 
			[K_ESTATUS_PARAMETRO_SUCURSAL],
			-- ===========================	
			[P2016_DTO_DESCUENTO_X_KG],
			[DESCUENTO_CONTADO],
			[DESCUENTO_CREDITO],
			[P2023_PCN],
			-- ===========================
			[VENTA_PORCENTAJE_CONTADO], [VENTA_PORCENTAJE_CREDITO],
			[P1012_CARTERA_CYC_INICIAL], [P1013_CARTERA_CYC_FINAL],
			[COBRANZA_HOLGURA],
			-- ============================
			[PERFIL_VENTA_CONTADO_1_LUNES], [PERFIL_VENTA_CONTADO_2_MARTES],
			[PERFIL_VENTA_CONTADO_3_MIERCOLES], [PERFIL_VENTA_CONTADO_4_JUEVES],
			[PERFIL_VENTA_CONTADO_5_VIERNES], [PERFIL_VENTA_CONTADO_6_SABADO],
			[PERFIL_VENTA_CONTADO_7_DOMINGO],
			-- =============================
			[PERFIL_VENTA_CREDITO_1_LUNES], [PERFIL_VENTA_CREDITO_2_MARTES], 
			[PERFIL_VENTA_CREDITO_3_MIERCOLES], [PERFIL_VENTA_CREDITO_4_JUEVES], 
			[PERFIL_VENTA_CREDITO_5_VIERNES], [PERFIL_VENTA_CREDITO_6_SABADO],
			[PERFIL_VENTA_CREDITO_7_DOMINGO],
			-- ===============================
			[PERFIL_COBRANZA_1_LUNES], [PERFIL_COBRANZA_2_MARTES],
			[PERFIL_COBRANZA_3_MIERCOLES], [PERFIL_COBRANZA_4_JUEVES],
			[PERFIL_COBRANZA_5_VIERNES], [PERFIL_COBRANZA_6_SABADO],
			[PERFIL_COBRANZA_7_DOMINGO],
			-- ===========================		
			[K_USUARIO_ALTA],	[F_ALTA],
			[K_USUARIO_CAMBIO],	[F_CAMBIO],
			[L_BORRADO]		)	
	VALUES	
		(	 
			@PP_K_PARAMETRO_SUCURSAL, @PP_O_PARAMETRO_SUCURSAL,	
			@PP_D_PARAMETRO_SUCURSAL, @PP_K_UNIDAD_OPERATIVA,	
			2, 
			-- ===========================	
			@PP_P2016_DTO_DESCUENTO_X_KG, @PP_DESCUENTO_CONTADO,
			@PP_DESCUENTO_CREDITO, @PP_P2023_PCN,		
			-- ===========================		
			@PP_VENTA_PORCENTAJE_CONTADO, @PP_VENTA_PORCENTAJE_CREDITO,	
			@PP_P1012_CARTERA_CYC_INICIAL, @PP_P1013_CARTERA_CYC_FINAL,
			@PP_COBRANZA_HOLGURA,	
			-- =============================
			@PP_PERFIL_VENTA_CONTADO_1_LUNES, @PP_PERFIL_VENTA_CONTADO_2_MARTES, 
			@PP_PERFIL_VENTA_CONTADO_3_MIERCOLES, @PP_PERFIL_VENTA_CONTADO_4_JUEVES, 
			@PP_PERFIL_VENTA_CONTADO_5_VIERNES, @PP_PERFIL_VENTA_CONTADO_6_SABADO,	
			@PP_PERFIL_VENTA_CONTADO_7_DOMINGO,
			-- =============================
			@PP_PERFIL_VENTA_CREDITO_1_LUNES, @PP_PERFIL_VENTA_CREDITO_2_MARTES,	
			@PP_PERFIL_VENTA_CREDITO_3_MIERCOLES, @PP_PERFIL_VENTA_CREDITO_4_JUEVES,	
			@PP_PERFIL_VENTA_CREDITO_5_VIERNES,	@PP_PERFIL_VENTA_CREDITO_6_SABADO,	
			@PP_PERFIL_VENTA_CREDITO_7_DOMINGO,	
			-- =============================	
			@PP_PERFIL_COBRANZA_1_LUNES, @PP_PERFIL_COBRANZA_2_MARTES, 
			@PP_PERFIL_COBRANZA_3_MIERCOLES, @PP_PERFIL_COBRANZA_4_JUEVES, 
			@PP_PERFIL_COBRANZA_5_VIERNES, @PP_PERFIL_COBRANZA_6_SABADO,			
			@PP_PERFIL_COBRANZA_7_DOMINGO,		
			-- =============================			
			@PP_K_USUARIO_ACCION,		GETDATE(),
			@PP_K_USUARIO_ACCION,		GETDATE(),
			@PP_L_BORRADO
		)

	-- ////////////////////////////////////////////////
GO


-- /////////////////////////////////////////////////////////////////////
-- // CARGA INICIAL PARAMETRO_SUCURSAL
-- /////////////////////////////////////////////////////////////////////



-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1001,10,'1001#2018#3',	1, 2018, 3, 1.5, 0.05, 0.95, 9.45, 1800000, 2100000, 85000000, 80000000, 0.1, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1002,10,'1002#2018#3', 2, 2018, 3, 1.54, 0.09, 0.91, 9.58, 1920000, 2107000, 85160000, 81600000, 0.22, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1003,10,'1003#2018#3', 3, 2018, 3, 1.55, 0.1, 0.9, 9.59, 1930000, 2114000, 85000000, 82400000, 0.23, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1004,10,'1004#2018#3', 4, 2018, 3, 1.5, 0.11, 0.89, 9.6, 1940000, 2121000, 85010000, 83200000, 0.24, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1005,10,'1005#2018#3', 5, 2018, 3, 1.51, 0.12, 0.88, 9.61, 1950000, 2128000, 85020000, 84000000, 0.25, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1006,10,'1006#2018#3', 6, 2018, 3, 1.52, 0.13, 0.87, 9.62, 1800000, 2135000, 85030000, 84800000, 0.26, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1008,10,'1008#2018#3', 8, 2018, 3, 1.54, 0.06, 0.94, 9.64, 1980000, 2149000, 85050000, 86400000, 0.28, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1009,10,'1009#2018#3', 9, 2018, 3, 1.55, 0.07, 0.93, 9.65, 1990000, 2156000, 85060000, 87200000, 0.29, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1011,10,'1011#2018#3', 11, 2018, 3, 1.51, 0.09, 0.91, 9.67, 2010000, 2170000, 85080000, 80800000, 0.31, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1012,10,'1012#2018#3', 12, 2018, 3, 1.52, 0.1, 0.9, 9.45, 2020000, 2100000, 85090000, 81600000, 0.32, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1013,10,'1013#2018#3', 13, 2018, 3, 1.53, 0.11, 0.89, 9.46, 2030000, 2107000, 85100000, 82400000, 0.33, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1014,10,'1014#2018#3', 14, 2018, 3, 1.54, 0.12, 0.88, 9.47, 2040000, 2114000, 85110000, 83200000, 0.34, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1015,10,'1015#2018#3', 15, 2018, 3, 1.55, 0.13, 0.87, 9.48, 2050000, 2121000, 85120000, 84000000, 0.35, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1016,10,'1016#2018#3', 16, 2018, 3, 1.5, 0.05, 0.95, 9.49, 2060000, 2128000, 85130000, 84800000, 0.36, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1017,10,'1017#2018#3', 17, 2018, 3, 1.51, 0.06, 0.94, 9.5, 2070000, 2135000, 85140000, 85600000, 0.37, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1018,10,'1018#2018#3', 18, 2018, 3, 1.52, 0.07, 0.93, 9.51, 2080000, 2142000, 85150000, 86400000, 0.38, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1020,10,'1020#2018#3', 20, 2018, 3, 1.54, 0.09, 0.91, 9.53, 2100000, 2156000, 85000000, 80000000, 0.1, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1021,10,'1021#2018#3', 21, 2018, 3, 1.55, 0.1, 0.9, 9.54, 2110000, 2163000, 85010000, 80800000, 0.11, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1023,10,'1023#2018#3', 23, 2018, 3, 1.51, 0.12, 0.88, 9.56, 1800000, 2100000, 85030000, 82400000, 0.13, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1024,10,'1024#2018#3', 24, 2018, 3, 1.52, 0.13, 0.87, 9.57, 1810000, 2107000, 85040000, 83200000, 0.14, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1025,10,'1025#2018#3', 25, 2018, 3, 1.53, 0.05, 0.95, 9.58, 1820000, 2114000, 85050000, 84000000, 0.15, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1026,10,'1026#2018#3', 26, 2018, 3, 1.54, 0.06, 0.94, 9.59, 1830000, 2121000, 85060000, 84800000, 0.16, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1027,10,'1027#2018#3', 27, 2018, 3, 1.55, 0.07, 0.93, 9.6, 1840000, 2128000, 85070000, 85600000, 0.17, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1028,10,'1028#2018#3', 28, 2018, 3, 1.5, 0.08, 0.92, 9.61, 1850000, 2135000, 85080000, 86400000, 0.18, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1029,10,'1029#2018#3', 29, 2018, 3, 1.51, 0.09, 0.91, 9.62, 1860000, 2142000, 85090000, 87200000, 0.19, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1030,10,'1030#2018#3', 30, 2018, 3, 1.52, 0.1, 0.9, 9.63, 1870000, 2149000, 85100000, 80000000, 0.2, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1031,10,'1031#2018#3', 31, 2018, 3, 1.53, 0.11, 0.89, 9.64, 1880000, 2156000, 85110000, 80800000, 0.21, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1032,10,'1032#2018#3', 32, 2018, 3, 1.54, 0.12, 0.88, 9.65, 1890000, 2163000, 85120000, 81600000, 0.22, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1033,10,'1033#2018#3', 33, 2018, 3, 1.55, 0.13, 0.87, 9.66, 1900000, 2170000, 85130000, 82400000, 0.23, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1034,10,'1034#2018#3', 34, 2018, 3, 1.5, 0.05, 0.95, 9.67, 1910000, 2100000, 85140000, 83200000, 0.24, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1035,10,'1035#2018#3', 35, 2018, 3, 1.51, 0.06, 0.94, 9.45, 1920000, 2107000, 85150000, 84000000, 0.25, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1036,10,'1036#2018#3', 36, 2018, 3, 1.52, 0.07, 0.93, 9.46, 1930000, 2114000, 85160000, 84800000, 0.26, 11, 21, 31, 41, 51, 6, 7, 40, 32, 22, 12, 52, 12, 5, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1038,10,'1038#2018#3', 38, 2018, 3, 0.61, 0.07, 0.93, 12.49, 1950000, 2441571, 78116126.99, 76163602.3709586, 0, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1039,10,'1039#2018#3', 39, 2018, 3, 1.55, 0.1, 0.9, 9.49, 1960000, 2135000, 85020000, 87200000, 0.29, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1040,10,'1040#2018#3', 40, 2018, 3, 1.5, 0.11, 0.89, 9.5, 1970000, 2142000, 85030000, 80000000, 0.3, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1041,10,'1041#2018#3', 41, 2018, 3, 1.51, 0.12, 0.88, 9.51, 1980000, 2149000, 85040000, 80800000, 0.31, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1042,10,'1042#2018#3', 42, 2018, 3, 1.52, 0.13, 0.87, 9.52, 1990000, 2156000, 85050000, 81600000, 0.32, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1043,10,'1043#2018#3', 43, 2018, 3, 1.53, 0.05, 0.95, 9.53, 2503581, 2163000, 85060000, 82400000, 0.33, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1044,10,'1044#2018#3', 44, 2018, 3, 1.54, 0.06, 0.94, 9.54, 2010000, 2170000, 85070000, 83200000, 0.34, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1045,10,'1045#2018#3', 45, 2018, 3, 1.55, 0.07, 0.93, 9.55, 2020000, 2100000, 85080000, 84000000, 0.35, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1046,10,'1046#2018#3', 46, 2018, 3, 1.5, 0.08, 0.92, 9.56, 2030000, 2107000, 85090000, 84800000, 0.36, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1047,10,'1047#2018#3', 47, 2018, 3, 1.51, 0.09, 0.91, 9.57, 2040000, 2114000, 85100000, 85600000, 0.37, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1048,10,'1048#2018#3', 48, 2018, 3, 0.61, 0.1, 0.9, 12.49, 2050000, 2441571, 78116126.99, 76163602.3709586, 0, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1049,10,'1049#2018#3', 49, 2018, 3, 1.53, 0.11, 0.89, 9.59, 2060000, 2128000, 85120000, 87200000, 0.39, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1051,10,'1051#2018#3', 51, 2018, 3, 1.55, 0.13, 0.87, 9.61, 2080000, 2142000, 85140000, 80800000, 0.11, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1053,10,'1053#2018#3', 53, 2018, 3, 1.51, 0.06, 0.94, 9.63, 2100000, 2156000, 85160000, 82400000, 0.13, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1054,10,'1054#2018#3', 54, 2018, 3, 1.52, 0.07, 0.93, 9.64, 2110000, 2163000, 85000000, 83200000, 0.14, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1055,10,'1055#2018#3', 55, 2018, 3, 1.53, 0.08, 0.92, 9.65, 2503581, 2170000, 85010000, 84000000, 0.15, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1056,10,'1056#2018#3', 56, 2018, 3, 1.54, 0.09, 0.91, 9.66, 1800000, 2100000, 85020000, 84800000, 0.16, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1057,10,'1057#2018#3', 57, 2018, 3, 1.55, 0.1, 0.9, 9.67, 1810000, 2107000, 85030000, 85600000, 0.17, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1059,10,'1059#2018#3', 59, 2018, 3, 1.51, 0.12, 0.88, 9.46, 1830000, 2121000, 85050000, 87200000, 0.19, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1060,10,'1060#2018#3', 60, 2018, 3, 1.52, 0.13, 0.87, 9.47, 1840000, 2128000, 85060000, 80000000, 0.2, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1061,10,'1061#2018#3', 61, 2018, 3, 1.53, 0.05, 0.95, 9.48, 1850000, 2135000, 85070000, 80800000, 0.21, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1062,10,'1062#2018#3', 62, 2018, 3, 1.54, 0.06, 0.94, 9.49, 1860000, 2142000, 85080000, 81600000, 0.22, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1063,10,'1063#2018#3', 63, 2018, 3, 1.55, 0.07, 0.93, 9.5, 1870000, 2149000, 85090000, 82400000, 0.23, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1064,10,'1064#2018#3', 64, 2018, 3, 1.5, 0.08, 0.92, 9.51, 1880000, 2156000, 85100000, 83200000, 0.24, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1065,10,'1065#2018#3', 65, 2018, 3, 1.51, 0.09, 0.91, 9.52, 1890000, 2163000, 85110000, 84000000, 0.25, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1066,10,'1066#2018#3', 66, 2018, 3, 1.52, 0.1, 0.9, 9.53, 1900000, 2170000, 85120000, 84800000, 0.26, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1068,10,'1068#2018#3', 68, 2018, 3, 1.54, 0.12, 0.88, 9.55, 1920000, 2107000, 85140000, 86400000, 0.28, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1069,10,'1069#2018#3', 69, 2018, 3, 1.55, 0.13, 0.87, 9.56, 1930000, 2114000, 85150000, 87200000, 0.29, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1070,10,'1070#2018#3', 70, 2018, 3, 1.5, 0.05, 0.95, 9.57, 1940000, 2121000, 85160000, 80000000, 0.3, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1071,10,'1071#2018#3', 71, 2018, 3, 1.51, 0.06, 0.94, 9.58, 1950000, 2128000, 85000000, 80800000, 0.31, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1073,10,'1073#2018#3', 73, 2018, 3, 1.53, 0.08, 0.92, 9.6, 1970000, 2142000, 85020000, 82400000, 0.33, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1076,10,'1076#2018#3', 76, 2018, 3, 1.5, 0.11, 0.89, 9.63, 2000000, 2163000, 85050000, 84800000, 0.36, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1082,10,'1082#2018#3', 82, 2018, 3, 1.5, 0.08, 0.92, 9.46, 2060000, 2128000, 85110000, 81600000, 0.12, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0
EXECUTE [PG_CI_PARAMETRO_SUCURSAL] 0, 0, 0, 1083,10,'1083#2018#3', 83, 2018, 3, 1.51, 0.09, 0.91, 9.47, 2070000, 2135000, 85120000, 82400000, 0.13, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 0, 0, 13, 33, 33, 23, 23, 0, 0,0


GO



-- ===============================================
-- UPDATE PARA CONVERTIR A PORCENTAJE DE 0-1 LA VENTA CREDITO Y CONTADO

UPDATE	PARAMETRO_SUCURSAL 
SET		VENTA_PORCENTAJE_CREDITO = ( VENTA_PORCENTAJE_CREDITO / (VENTA_PORCENTAJE_CONTADO+VENTA_PORCENTAJE_CREDITO) ),
		VENTA_PORCENTAJE_CONTADO = ( VENTA_PORCENTAJE_CONTADO / (VENTA_PORCENTAJE_CONTADO+VENTA_PORCENTAJE_CREDITO) )
GO



-- ===============================================
SET NOCOUNT OFF
-- ===============================================




-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
