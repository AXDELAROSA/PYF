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
-- // DELETEs
-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATA_N3_X_ME_D0M4]') AND type in (N'U'))
	DELETE 
	FROM	[dbo].[DATA_N3_X_ME_D0M4]

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATA_N1_X_DI_D0M4]') AND type in (N'U'))
	DELETE 
	FROM	[dbo].[DATA_N1_X_DI_D0M4]

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PARAMETRO_DOCUMENTO_D0M4]') AND type in (N'U'))
	DELETE 
	FROM	[dbo].[PARAMETRO_DOCUMENTO_D0M4]

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PARAMETRO_POB]') AND type in (N'U'))
	DELETE 
	FROM	[dbo].[PARAMETRO_POB]

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DOCUMENTO_D0M4]') AND type in (N'U'))
	DELETE 
	FROM	[dbo].[DOCUMENTO_D0M4]

-- ======================

DELETE 
FROM	[dbo].[DEFINICION_D0M4] 

DELETE 
FROM	[dbo].[DATO_D0M4] 

GO





-- ///////////////////////////////////////////////////////////////
-- //						DATO_D0M4 						
-- ///////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- ===============================================



-- ==========================================================
-- DATOS // DOM4 // C3M3 // COMPROMISO VENTAS 
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1020, '(P@) DIA DE LA SEMANA / CEME', '[#1020] (P@) DIA DE LA SEMANA / CEME', 'WkDay', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1027, '(P@) ASUETO / CEME', '[#1027] (P@) ASUETO / CEME', 'WkDay', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1021, '(P@) PERFIL - VENTA (KG) / CONTADO', '[#1021] (P@) PERFIL - VENTA (KG) / CONTADO', 'Wk-Vk.Co', 0, 5
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1022, '(P@) PERFIL - VENTA (KG) / CREDITO', '[#1022] (P@) PERFIL - VENTA (KG) / CREDITO', 'Wk-Vk.Cr', 0, 5
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1023, '(P@) PERFIL - COBRANZA ($) / CREDITO', '[#1023] (P@) PERFIL - COBRANZA ($) / CREDITO', 'Wk-Co', 0, 5
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1001, '(P@) PRECIO VENTA ($PV)', '[#1001] (P@) PRECIO VENTA ($PV)', 'PV', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1014, '(F[x]) DESCUENTO PV ($) / CONTADO', '[#1014] (F[x]) DESCUENTO PV ($) / CONTADO', 'D.Co', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1015, '(F[x]) DESCUENTO PV ($) / CREDITO', '[#1015] (F[x]) DESCUENTO PV ($) / CREDITO', 'D.Cr', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1003, 'VENTA (KG) / CONTADO', '[#1003] VENTA (KG) / CONTADO', 'Vk.Co', 0, 2
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1004, 'VENTA (KG) / CREDITO', '[#1004] VENTA (KG) / CREDITO', 'Vk.Cr', 0, 2
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1002, 'VENTA (KG)', '[#1002] VENTA (KG)', 'Vk', 0, 2
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1005, 'VENTA BRUTA ($) / CONTADO', '[#1005] VENTA BRUTA ($) / CONTADO', 'V$.Co', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1016, 'DESCUENTO S/VENTA ($) / CONTADO', '[#1016] DESCUENTO S/VENTA ($) / CONTADO', 'D-V$.Co', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1018, 'VENTA NETA ($) / CONTADO', '[#1018] VENTA NETA ($) / CONTADO', 'Vn$.Co', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1006, 'VENTA BRUTA ($) / CREDITO', '[#1006] VENTA BRUTA ($) / CREDITO', 'V$.Cr', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1017, 'DESCUENTO S/VENTA ($) / CREDITO', '[#1017] DESCUENTO S/VENTA ($) / CREDITO', 'D-V$.Cr', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1019, 'VENTA NETA ($) / CREDITO', '[#1019] VENTA NETA ($) / CREDITO', 'Vn$.Cr', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1007, 'COBRANZA ($)', '[#1007] COBRANZA ($)', 'Cob$', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1009, 'INGRESOS X VENTA ($)', '[#1009] INGRESOS X VENTA ($)', 'IngXV$', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1010, 'INGRESOS X COBRANZA ($)', '[#1010] INGRESOS X COBRANZA ($)', 'IngXCob$', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1008, 'NOMINA ($) / TOMA', '[#1008] NOMINA ($) / TOMA', 'Nom', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1011, 'INGRESOS TOTALES ($)', '[#1011] INGRESOS TOTALES ($)', 'IngTot', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1012, 'CARTERA CYC ($) / INICIAL', '[#1012] CARTERA CYC ($) / INICIAL', 'CYC.Ini', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 1013, 'CARTERA CYC ($) / FINAL', '[#1013] CARTERA CYC ($) / FINAL', 'CYC.Fin', 0, 1



GO
-- ==========================================================
-- DATOS // DOM4 // PR3C // PRECIOS-COSTOS GAS 
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2001, 'S#1 - PV', 'S#1', 'PV', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2002, 'S#2 - PC', 'S#2', 'PC', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2003, 'S#2 - MG', 'S#2', 'MG', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2004, 'S#2 - FLETE', 'S#2', 'FLETE', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2005, 'S#2 - MGD', 'S#2', 'MGD', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2006, 'S#3 - ¢MC', 'S#3', '¢MC', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2007, 'S#3 - ¢CA', 'S#3', '¢CA', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2008, 'S#3 - ¢FG', 'S#3', '¢FG', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2009, 'S#3 - ¢MP INB', 'S#3', '¢MP INB', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2010, 'S#3 - ¢SMD', 'S#3', '¢SMD', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2011, 'S#3 - ¢SMP', 'S#3', '¢SMP', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2012, 'S#3 - ¢SMRU', 'S#3', '¢SMRU', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2013, 'S#3 - ¢APG', 'S#3', '¢APG', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2014, 'S#3 - TOT', 'S#3', 'TOT', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2015, 'S#4 - PV', 'S#4', 'PV', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2016, 'S#4 - Dto', 'S#4', 'Dto', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2017, 'S#4 - Com', 'S#4', 'Com', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2018, 'S#4 - PVN', 'S#4', 'PVN', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2019, 'S#5 - PC', 'S#5', 'PC', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2020, 'S#5 - HGN', 'S#5', 'HGN', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2021, 'S#5 - PCN', 'S#5', 'PCN', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2022, 'S#6 - PVN', 'S#6', 'PVN', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2023, 'S#6 - PCN', 'S#6', 'PCN', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2024, 'S#6 - MGN', 'S#6', 'MGN', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2025, 'S#6 - FLETE', 'S#6', 'FLETE', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 2026, 'S#6 - MDN', 'S#6', 'MDN', 0, 1
GO
-- ==========================================================
-- DATOS // DOM4 // C3M3 // FLUJO EFECTIVO PROYECTADO
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3043, '(P@) DIA DE LA SEMANA / FLUP', '[#3043] (P@) DIA DE LA SEMANA / FLUP', 'WkDay', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3044, '(P@) ASUETOS / FLUP', '[#3044] (P@) ASUETOS / FLUP', 'WkDay', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3042, '(P@) PCN ($)', '[#3042] (P@) PCN ($)', 'PCN$', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3045, '(P@) FLETE ($)', '[#3045] (P@) FLETE ($)', 'PCN$', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3046, '(P@) ¢ APG', '[#3046] (P@) ¢ APG', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3047, '(P@) ¢ SMRU', '[#3047] (P@) ¢ SMRU', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3048, '(P@) ¢ FG', '[#3048] (P@) ¢ FG', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3049, '(P@) ¢ MP INB', '[#3049] (P@) ¢ MP INB', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3050, '(P@) ¢ SMD', '[#3050] (P@) ¢ SMD', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3051, '(P@) ¢ SMP', '[#3051] (P@) ¢ SMP', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3040, '[CEME] >>> VENTA (KG)', '[#3040] [CEME] >>> VENTA (KG)', 'Vk', 0, 2
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3041, 'INVENTARIO (KG) / REPOSICION', '[#3041] INVENTARIO (KG) / REPOSICION', 'Rep.INV', 0, 2
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3001, 'S.INICIAL', '[#3001] S.INICIAL', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3002, 'ING / VTA. CONTADO', '[#3002] ING / VTA. CONTADO', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3003, 'ING / COBRANZA', '[#3003] ING / COBRANZA', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3004, '(1) ING / INGRESO TOTAL', '[#3004] (1) ING / INGRESO TOTAL', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3005, 'GAS / ATRASO', '[#3005] GAS / ATRASO', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3006, 'GAS / FACTURA', '[#3006] GAS / FACTURA', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3007, 'PPTO / NÓMINA', '[#3007] PPTO / NÓMINA', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3008, 'PPTO / GASTOS', '[#3008] PPTO / GASTOS', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3009, 'OTROS / FLETE', '[#3009] OTROS / FLETE', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3010, 'OTROS / NÓM. CORP. ZULE', '[#3010] OTROS / NÓM. CORP. ZULE', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3011, '(2) TOTAL', '[#3011] (2) TOTAL', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3012, 'IMP. FEDERALES', '[#3012] IMP. FEDERALES', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3013, 'IMP. PLANTA', '[#3013] IMP. PLANTA', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3014, 'COOP. IMPUESTOS', '[#3014] COOP. IMPUESTOS', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3015, '(3) IMPUESTOS / TOTAL', '[#3015] (3) IMPUESTOS / TOTAL', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3016, 'CRED. TERC.', '[#3016] CRED. TERC.', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3017, 'PQ. INV. PLANTA', '[#3017] PQ. INV. PLANTA', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3018, 'INTERESES', '[#3018] INTERESES', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3019, 'AMORT. PETRO.', '[#3019] AMORT. PETRO.', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3020, '(4) OBLIG. BANCARIAS / TOTAL', '[#3020] (4) OBLIG. BANCARIAS / TOTAL', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3021, 'EXTRAORDINARIOS', '[#3021] EXTRAORDINARIOS', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3022, 'INVERSIONES', '[#3022] INVERSIONES', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3023, 'NO GESTIONABLES', '[#3023] NO GESTIONABLES', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3024, '(5) EXTR. Y OTROS / TOTAL', '[#3024] (5) EXTR. Y OTROS / TOTAL', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3025, 'ASPTA', '[#3025] ASPTA', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3026, 'OTROS GASTOS', '[#3026] OTROS GASTOS', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3027, 'COOPERACIONES', '[#3027] COOPERACIONES', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3028, '(6) CORPORATIVOS / TOTAL', '[#3028] (6) CORPORATIVOS / TOTAL', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3029, 'SMRU', '[#3029] SMRU', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3030, 'FIRAGAS', '[#3030] FIRAGAS', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3031, 'MP INBURSA', '[#3031] MP INBURSA', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3032, 'SMD', '[#3032] SMD', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3033, 'SMP', '[#3033] SMP', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3034, '(7) RESERVAS / TOTAL', '[#3034] (7) RESERVAS / TOTAL', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3035, 'EGRESO TOTAL', '[#3035] EGRESO TOTAL', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3036, 'RDO. DEL DIA', '[#3036] RDO. DEL DIA', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3037, 'RDO. ACUM.', '[#3037] RDO. ACUM.', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3038, 'PRÉSTAMO (+/-)', '[#3038] PRÉSTAMO (+/-)', '', 0, 1
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 3039, 'SALDO FINAL', '[#3039] SALDO FINAL', '', 0, 1
GO



-- ==========================================================
-- DATOS // PYF18 // POB // PROYECCION DE OBJETIVOS 
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4043, '(P@) PARAMETRO DE TIEMPO YYYY', '[#4043] (P@) PARAMETRO DE TIEMPO YYYY', 'YYYY', 10, 5
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4044, '(P@) PARAMETRO MES MM', '[#4044] (P@) PARAMETRO MES MM', 'MM', 20, 5
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4045, '(P@) PARAMETRO MES ', '[#4045] (P@) PARAMETRO MES ', 'MONTH', 30, 5
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4046, '(P@) NUMERO DE VIERNES DEL MES', '[#4046] (P@) NUMERO DE VIERNES DEL MES', 'VofM', 40, 6
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4047, '(P@) TEMPORADA', '[#4047] (P@) TEMPORADA', 'TEMP', 50, 6
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4048, '(P@) VENTAS N-5', '[#4048] (P@) VENTAS N-5', 'VN-5', 60, 2
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4049, '(P@) VENTAS N-4', '[#4049] (P@) VENTAS N-4', 'VN-4', 70, 2
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4050, '(P@) VENTAS N-3', '[#4050] (P@) VENTAS N-3', 'VN-3', 80, 2
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4051, '(P@) VENTAS N-2', '[#4051] (P@) VENTAS N-2', 'VN-2', 90, 2
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4052, '(P@) VENTAS N-1', '[#4052] (P@) VENTAS N-1', 'VN-1', 100, 2
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4053, '(P@) PERFIL DE VENTA', '[#4053] (P@) PERFIL DE VENTA', 'PfV', 110, 4
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4055, '(P@) INCREMENTO COMPROMISO KG', '[#4055] (P@) INCREMENTO COMPROMISO KG', 'InComp', 130, 2
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4001, 'PRONOSTICO DE VENTA ESTIMADA', '[#4001] PRONOSTICO DE VENTA ESTIMADA', 'PrVent', 140, 2
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4002, 'VENTA COMPROMISO', '[#4002] VENTA COMPROMISO', 'VentC', 150, 2
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4003, 'PROYECCION DE VENTAS OBJETIVO', '[#4003] PROYECCION DE VENTAS OBJETIVO', 'POB', 160, 2
EXECUTE [dbo].[PG_CI_DATO_D0M4] 0, 0, 4004, 'INCREMENTO DE VENTAS %', '[#4004] INCREMENTO DE VENTAS %', 'Pincr', 160, 4



GO





-- ===============================================

SET NOCOUNT OFF



-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
