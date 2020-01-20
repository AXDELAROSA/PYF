-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_R700_40.a_CI_RolAsignacion
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			ROL_ASIGNACION
-- // OPERACION:		LIBERACION / TABLAS
-- //////////////////////////////////////////////////////////////
-- // Autor:			ALEX DE LA ROSA // HECTOR A. GONZALEZ 
-- // Fecha creación:	18/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////

/*
DELETE
FROM	ROL_ASIGNACION
GO
*/


-- ///////////////////////////////////////////////////////////////
-- //					CI - ROL_ASIGNACION					
-- ///////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- ===============================================
SET NOCOUNT ON
-- ===============================================
/*

EXECUTE	[dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT] 0,0,0, 1, 10123.11
EXECUTE	[dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT] 0,0,0, 2, 20123.22
EXECUTE	[dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT] 0,0,0, 3, 30123.33
EXECUTE	[dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT] 0,0,0, 4, 40123.44
EXECUTE	[dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT] 0,0,0, 5, 50123.55
EXECUTE	[dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT] 0,0,0, 6, 60123.66
EXECUTE	[dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT] 0,0,0, 7, 70123.77
EXECUTE	[dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT] 0,0,0, 8, 80123.88
EXECUTE	[dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT] 0,0,0, 9, 90123.99
GO
*/
-- SELECT * FROM AUTORIZACION_FIRMA

-- SELECT * FROM FLUJO_FIRMA



DELETE 
FROM	FLUJO_FIRMA
GO


DELETE 
FROM	AUTORIZACION_FIRMA
GO


EXECUTE	[dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT] 1,0,0, 1001, 77, 31804004,  20000.01	-- TESISTAN

EXECUTE	[dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT] 1,0,0, 1002, 83, 31804008,  45000.02	-- CUAUHTEMOC 

EXECUTE	[dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT] 1,0,0, 1003, 39, 31804020,  85000.03	-- CANANEA

EXECUTE	[dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT] 1,0,0, 1004, 64, 31804021, 110000.04	-- CAMPECHE


-- ===============================================
SET NOCOUNT OFF
-- ===============================================


/*

SELECT * 
FROM	AUTORIZACION_FIRMA
GO

SELECT * 
FROM	FLUJO_FIRMA
GO

*/


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
