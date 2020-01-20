-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas 
-- // MODULO:			UNIDAD OPERATIVA
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- ////////////////////////////////////////////////////////////// 

--USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////


DELETE 
FROM	[UNIDAD_OPERATIVA]
WHERE	K_UNIDAD_OPERATIVA>9999
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE -->	CI - CARGA INICIAL
-- //////////////////////////////////////////////////////////////
-- SELECT * FROM UNIDAD_OPERATIVA



-- //////////////////////////////////////////////////////////////
-- // CARGA INICIAL
-- //////////////////////////////////////////////////////////////

-- ===============================================
SET NOCOUNT ON
-- ===============================================



-- ====================================================================== CI_UNIDAD_OPERATIVA



-- ====================================================================== CI_UNIDAD_OPERATIVA
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10006, 'RZS - MEXICANA DE GAS', 'RZS - MEXICANA DE GAS', 'RZS - MEXI', 6000, 1, 50, 70, 0, 0, 6, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10010, 'RZS - BUTEP', 'RZS - BUTEP', 'RZS - BUTE', 10000, 1, 50, 40, 0, 0, 10, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10011, 'RZS - CHAPULTEPEC (GAS)', 'RZS - CHAPULTEPEC (GAS)', 'RZS - CHAP', 11000, 1, 50, 70, 0, 0, 11, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10012, 'RZS - GAS COMERCIAL / NUEVO CASAS GRANDES', 'RZS - GAS COMERCIAL / NUEVO CASAS GRANDES', 'RZS - GAS ', 12000, 1, 50, 30, 0, 0, 12, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10013, 'RZS - GAS COMERCIAL / VILLA AHUMADA', 'RZS - GAS COMERCIAL / VILLA AHUMADA', 'RZS - GAS ', 13000, 1, 50, 30, 0, 0, 13, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10053, 'RZS - TENABO (GAS)', 'RZS - TENABO (GAS)', 'RZS - TENA', 53000, 1, 50, 60, 0, 0, 53, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10016, 'RZS - SILZA (GAS)', 'RZS - SILZA (GAS)', 'RZS - SILZ', 16000, 1, 50, 10, 0, 0, 16, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10089, 'RZS - TITANIUM (GAS)', 'RZS - TITANIUM (GAS)', 'RZS - TITA', 89000, 1, 50, 20, 0, 0, 89, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10019, 'RZS - TOMZA / MEXICO (GAS)', 'RZS - TOMZA / MEXICO (GAS)', 'RZS - TOMZ', 19000, 1, 50, 20, 0, 0, 19, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10015, 'RZS - TOMZA / PUEBLA (GAS)', 'RZS - TOMZA / PUEBLA (GAS)', 'RZS - TOMZ', 15000, 1, 50, 20, 0, 0, 15, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10045, 'RZS - TOMZA / YUCATAN (GAS)', 'RZS - TOMZA / YUCATAN (GAS)', 'RZS - TOMZ', 45000, 1, 50, 60, 0, 0, 45, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10021, 'RZS - URIBE ACAPULCO (GAS)', 'RZS - URIBE ACAPULCO (GAS)', 'RZS - URIB', 21000, 1, 50, 20, 0, 0, 21, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10049, 'RZS - VULCANO (GAS)', 'RZS - VULCANO (GAS)', 'RZS - VULC', 49000, 1, 50, 40, 0, 0, 49, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10023, 'RZS - GAS Y SERVICIO', 'RZS - GAS Y SERVICIO', 'RZS - GAS ', 23000, 1, 50, 70, 0, 0, 23, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10024, 'RZS - ZARAGOZA OJINAGA (GAS)', 'RZS - ZARAGOZA OJINAGA (GAS)', 'RZS - ZARA', 24000, 1, 50, 30, 0, 0, 24, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10025, 'RZS - GASOMATICO', 'RZS - GASOMATICO', 'RZS - GASO', 25000, 1, 50, 70, 0, 0, 25, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10036, 'RZS - HIDROGAS / AGUA PRIETA', 'RZS - HIDROGAS / AGUA PRIETA', 'RZS - HIDR', 36000, 1, 50, 50, 0, 0, 36, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10026, 'RZS - HIDROGAS / ACAPULCO', 'RZS - HIDROGAS / ACAPULCO', 'RZS - HIDR', 26000, 1, 50, 20, 0, 0, 26, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10028, 'RZS - HIDROGAS / CHIHUAHUA', 'RZS - HIDROGAS / CHIHUAHUA', 'RZS - HIDR', 28000, 1, 50, 30, 0, 0, 28, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10047, 'RZS - HOLBOX ', 'RZS - HOLBOX ', 'RZS - HOLB', 47000, 1, 50, 60, 0, 0, 47, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10065, 'RZS - MAMEME (GAS)', 'RZS - MAMEME (GAS)', 'RZS - MAME', 65000, 1, 50, 40, 0, 0, 65, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10042, 'RZS - UNIGAS', 'RZS - UNIGAS', 'RZS - UNIG', 42000, 1, 50, 70, 0, 0, 42, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10007, 'RZS - COMPAÑIA MEXICANA DE GAS COMBUSTIBLE S.A. DE C.V. TEHUACAN', 'RZS - COMPAÑIA MEXICANA DE GAS COMBUSTIBLE S.A. DE C.V. TEHUACAN', 'RZS - COMP', 7000, 1, 50, 20, 0, 0, 7, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10054, 'RZS - TOMZA DE VERACRUZ (GAS)', 'RZS - TOMZA DE VERACRUZ (GAS)', 'RZS - TOMZ', 54000, 1, 50, 60, 0, 0, 54, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10090, 'RZS - TOMZA DE SINALOA (GAS)', 'RZS - TOMZA DE SINALOA (GAS)', 'RZS - TOMZ', 90000, 1, 50, 50, 0, 0, 90, 0, '', '', '', '', '', '', '', '', ''



-- ===============================================
SET NOCOUNT OFF
-- ===============================================


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
