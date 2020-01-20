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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DOCUMENTO_D0M4]') AND type in (N'U'))
	DELETE 
	FROM	[dbo].[DOCUMENTO_D0M4]

-- ======================

DELETE 
FROM	[dbo].[DEFINICION_D0M4] 
GO





-- ///////////////////////////////////////////////////////////////
-- //					DEFINICION_D0M4
-- ///////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- ===============================================



-- =======================================================
-- K_DOCUMENTO_D0M4 // #101 // C3M3 // COMPROMISO
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1020, '(P@) DIA DE LA SEMANA / CEME', 0, 1, 0, 0, 1, 0, 1, 10, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1027, '(P@) ASUETO / CEME', 0, 1, 0, 0, 1, 0, 1, 20, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1021, '(P@) PERFIL - VENTA (KG) / CONTADO', 0, 1, 0, 0, 1, 0, 1, 30, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1022, '(P@) PERFIL - VENTA (KG) / CREDITO', 0, 1, 0, 0, 1, 0, 1, 40, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1023, '(P@) PERFIL - COBRANZA ($) / CREDITO', 0, 1, 0, 0, 1, 0, 1, 50, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1001, '(P@) PRECIO VENTA ($PV)', 0, 1, 0, 0, 1, 0, 1, 60, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1014, '(F[x]) DESCUENTO PV ($) / CONTADO', 0, 1, 0, 0, 0, 0, 3, 70, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1015, '(F[x]) DESCUENTO PV ($) / CREDITO', 0, 1, 0, 0, 0, 0, 3, 80, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1003, 'VENTA (KG) / CONTADO', 1, 1, 0, 0, 0, 1, 1, 90, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1004, 'VENTA (KG) / CREDITO', 1, 1, 0, 0, 0, 1, 1, 100, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1002, 'VENTA (KG)', 1, 1, 0, 1, 0, 0, 3, 110, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1005, 'VENTA BRUTA ($) / CONTADO', 1, 1, 0, 0, 0, 0, 1, 120, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1016, 'DESCUENTO S/VENTA ($) / CONTADO', 1, 1, 0, 0, 0, 0, 1, 130, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1018, 'VENTA NETA ($) / CONTADO', 1, 1, 0, 1, 0, 0, 3, 140, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1006, 'VENTA BRUTA ($) / CREDITO', 1, 1, 0, 0, 0, 0, 1, 150, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1017, 'DESCUENTO S/VENTA ($) / CREDITO', 1, 1, 0, 0, 0, 0, 1, 160, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1019, 'VENTA NETA ($) / CREDITO', 1, 1, 0, 1, 0, 0, 3, 170, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1007, 'COBRANZA ($)', 1, 1, 0, 0, 0, 0, 1, 180, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1009, 'INGRESOS X VENTA ($)', 1, 1, 0, 0, 0, 0, 1, 190, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1010, 'INGRESOS X COBRANZA ($)', 1, 1, 0, 0, 0, 0, 1, 200, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1008, 'NOMINA ($) / TOMA', 1, 1, 0, 0, 0, 0, 1, 210, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1011, 'INGRESOS TOTALES ($)', 1, 1, 0, 1, 0, 0, 3, 220, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1012, 'CARTERA CYC ($) / INICIAL', 1, 1, 0, 0, 0, 0, 1, 230, 101
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 1013, 'CARTERA CYC ($) / FINAL', 1, 1, 0, 0, 0, 0, 1, 240, 101



GO
-- =======================================================
-- K_DOCUMENTO_D0M4 // #102 // PRECIOS COSTOS GAS
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2001, 'S#1 - PV', 1, 1, 0, 0, 0, 0, 1, 10, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2002, 'S#2 - PC', 1, 1, 0, 0, 0, 0, 1, 20, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2003, 'S#2 - MG', 1, 1, 0, 0, 0, 0, 1, 30, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2004, 'S#2 - FLETE', 1, 1, 0, 0, 0, 0, 1, 40, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2005, 'S#2 - MGD', 1, 1, 0, 1, 0, 0, 3, 50, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2006, 'S#3 - ¢MC', 1, 1, 0, 0, 0, 0, 1, 60, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2007, 'S#3 - ¢CA', 1, 1, 0, 0, 0, 0, 1, 70, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2008, 'S#3 - ¢FG', 1, 1, 0, 0, 0, 0, 1, 80, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2009, 'S#3 - ¢MP INB', 1, 1, 0, 0, 0, 0, 1, 90, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2010, 'S#3 - ¢SMD', 1, 1, 0, 0, 0, 0, 1, 100, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2011, 'S#3 - ¢SMP', 1, 1, 0, 0, 0, 0, 1, 110, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2012, 'S#3 - ¢SMRU', 1, 1, 0, 0, 0, 0, 1, 120, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2013, 'S#3 - ¢APG', 1, 1, 0, 0, 0, 0, 1, 130, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2014, 'S#3 - TOT', 1, 1, 0, 1, 0, 0, 3, 140, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2015, 'S#4 - PV', 1, 1, 0, 0, 0, 0, 1, 150, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2016, 'S#4 - Dto', 1, 1, 0, 0, 0, 0, 1, 160, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2017, 'S#4 - Com', 1, 1, 0, 0, 0, 0, 1, 170, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2018, 'S#4 - PVN', 1, 1, 0, 1, 0, 0, 3, 180, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2019, 'S#5 - PC', 1, 1, 0, 0, 0, 0, 1, 190, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2020, 'S#5 - HGN', 1, 1, 0, 0, 0, 0, 1, 200, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2021, 'S#5 - PCN', 1, 1, 0, 1, 0, 0, 3, 210, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2022, 'S#6 - PVN', 1, 1, 0, 0, 0, 0, 1, 220, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2023, 'S#6 - PCN', 1, 1, 0, 0, 0, 0, 1, 230, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2024, 'S#6 - MGN', 1, 1, 0, 1, 0, 0, 3, 240, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2025, 'S#6 - FLETE', 1, 1, 0, 0, 0, 0, 1, 250, 102
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 2026, 'S#6 - MDN', 1, 1, 0, 1, 0, 0, 3, 260, 102
GO
-- =======================================================
-- K_DOCUMENTO_D0M4 // #3 // C3M3 // FLUJO PROYECTADO
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3043, '(P@) DIA DE LA SEMANA / FLUP', 0, 1, 0, 0, 1, 0, 1, 10, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3044, '(P@) ASUETOS / FLUP', 0, 1, 0, 0, 1, 0, 1, 20, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3042, '(P@) PCN ($)', 0, 1, 0, 0, 1, 0, 1, 30, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3045, '(P@) FLETE ($)', 0, 1, 0, 0, 1, 0, 1, 40, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3046, '(P@) ¢ APG', 0, 1, 0, 0, 1, 0, 1, 50, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3047, '(P@) ¢ SMRU', 0, 1, 0, 0, 1, 0, 1, 60, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3048, '(P@) ¢ FG', 0, 1, 0, 0, 1, 0, 1, 70, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3049, '(P@) ¢ MP INB', 0, 1, 0, 0, 1, 0, 1, 80, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3050, '(P@) ¢ SMD', 0, 1, 0, 0, 1, 0, 1, 90, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3051, '(P@) ¢ SMP', 0, 1, 0, 0, 1, 0, 1, 100, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3040, '[CEME] >>> VENTA (KG)', 0, 1, 0, 0, 0, 0, 1, 110, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3041, 'INVENTARIO (KG) / REPOSICION', 0, 1, 0, 0, 0, 0, 1, 120, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3001, 'S.INICIAL', 1, 1, 0, 1, 0, 0, 1, 130, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3002, 'ING / VTA. CONTADO', 1, 1, 0, 0, 0, 0, 1, 140, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3003, 'ING / COBRANZA', 1, 1, 0, 0, 0, 0, 1, 150, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3004, '(1) ING / INGRESO TOTAL', 1, 1, 0, 1, 0, 0, 3, 160, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3005, 'GAS / ATRASO', 1, 0, 1, 0, 0, 0, 1, 170, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3006, 'GAS / FACTURA', 1, 1, 0, 0, 0, 0, 1, 180, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3007, 'PPTO / NÓMINA', 1, 0, 1, 0, 0, 0, 1, 190, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3008, 'PPTO / GASTOS', 1, 0, 1, 0, 0, 0, 1, 200, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3009, 'OTROS / FLETE', 1, 1, 0, 0, 0, 0, 1, 210, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3010, 'OTROS / NÓM. CORP. ZULE', 1, 0, 1, 0, 0, 0, 1, 220, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3011, '(2) TOTAL', 1, 1, 0, 1, 0, 0, 3, 230, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3012, 'IMP. FEDERALES', 1, 0, 1, 0, 0, 0, 1, 240, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3013, 'IMP. PLANTA', 1, 0, 1, 0, 0, 0, 1, 250, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3014, 'COOP. IMPUESTOS', 1, 0, 1, 0, 0, 0, 1, 260, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3015, '(3) IMPUESTOS / TOTAL', 1, 1, 0, 1, 0, 0, 3, 270, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3016, 'CRED. TERC.', 1, 0, 1, 0, 0, 0, 1, 280, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3017, 'PQ. INV. PLANTA', 1, 0, 1, 0, 0, 0, 1, 290, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3018, 'INTERESES', 1, 0, 1, 0, 0, 0, 1, 300, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3019, 'AMORT. PETRO.', 1, 1, 0, 0, 0, 0, 1, 310, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3020, '(4) OBLIG. BANCARIAS / TOTAL', 1, 1, 0, 1, 0, 0, 3, 320, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3021, 'EXTRAORDINARIOS', 1, 0, 1, 0, 0, 0, 1, 330, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3022, 'INVERSIONES', 1, 0, 1, 0, 0, 0, 1, 340, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3023, 'NO GESTIONABLES', 1, 0, 1, 0, 0, 0, 1, 350, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3024, '(5) EXTR. Y OTROS / TOTAL', 1, 1, 0, 1, 0, 0, 3, 360, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3025, 'ASPTA', 1, 0, 1, 0, 0, 0, 1, 370, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3026, 'OTROS GASTOS', 1, 0, 1, 0, 0, 0, 1, 380, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3027, 'COOPERACIONES', 1, 0, 1, 0, 0, 0, 1, 390, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3028, '(6) CORPORATIVOS / TOTAL', 1, 1, 0, 1, 0, 0, 3, 400, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3029, 'SMRU', 1, 1, 0, 0, 0, 0, 1, 410, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3030, 'FIRAGAS', 1, 1, 0, 0, 0, 0, 1, 420, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3031, 'MP INBURSA', 1, 1, 0, 0, 0, 0, 1, 430, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3032, 'SMD', 1, 1, 0, 0, 0, 0, 1, 440, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3033, 'SMP', 1, 1, 0, 0, 0, 0, 1, 450, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3034, '(7) RESERVAS / TOTAL', 1, 1, 0, 1, 0, 0, 3, 460, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3035, 'EGRESO TOTAL', 1, 1, 0, 0, 0, 0, 1, 470, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3036, 'RDO. DEL DIA', 1, 1, 0, 0, 0, 1, 1, 480, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3037, 'RDO. ACUM.', 1, 1, 0, 0, 0, 1, 1, 490, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3038, 'PRÉSTAMO (+/-)', 1, 0, 1, 0, 0, 1, 1, 500, 103
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 3039, 'SALDO FINAL', 1, 1, 0, 1, 0, 0, 1, 510, 103
GO



-- =======================================================
-- K_DOCUMENTO_D0M4 // #907 // PROYECCION DE OBJETIVOS

EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4043, '(P@) PARAMETRO DE TIEMPO YYYY', 0, 1, 0, 0, 1, 0, 1, 10, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4044, '(P@) PARAMETRO MES MM', 0, 1, 0, 0, 1, 0, 1, 20, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4045, '(P@) PARAMETRO MES ', 0, 1, 0, 0, 1, 0, 1, 20, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4046, '(P@) NUMERO DE VIERNES DEL MES', 0, 1, 0, 0, 1, 0, 1, 30, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4047, '(P@) TEMPORADA', 0, 1, 0, 0, 1, 0, 1, 40, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4048, '(P@) VENTAS N-5', 0, 1, 0, 0, 1, 0, 1, 60, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4049, '(P@) VENTAS N-4', 0, 1, 0, 0, 1, 0, 1, 70, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4050, '(P@) VENTAS N-3', 0, 1, 0, 0, 1, 0, 1, 80, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4051, '(P@) VENTAS N-2', 0, 1, 0, 0, 1, 0, 1, 90, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4052, '(P@) VENTAS N-1', 0, 1, 0, 0, 1, 0, 1, 100, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4053, '(P@) PERFIL DE VENTA', 0, 1, 1, 0, 1, 0, 1, 110, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4055, '(P@) INCREMENTO COMPROMISO KG', 0, 1, 1, 0, 1, 0, 1, 120, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4001, 'PRONOSTICO DE VENTA ESTIMADA', 1, 1, 0, 0, 0, 0, 1, 130, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4002, 'VENTA COMPROMISO', 1, 1, 0, 0, 0, 0, 1, 140, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4003, 'PROYECCION DE VENTAS OBJETIVO', 1, 1, 0, 0, 0, 0, 1, 150, 907
EXECUTE [dbo].[PG_CI_DEFINICION_D0M4] 0, 0, 4004, 'INCREMENTO DE VENTAS %', 1, 1, 0, 0, 0, 0, 1, 160, 907





-- ===============================================

SET NOCOUNT OFF




-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
