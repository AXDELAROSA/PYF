-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			INSTRUCCION / AUTOMATIZACION
-- // OPERACION:		LIBERACION / PRUEBAS
-- //////////////////////////////////////////////////////////////
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creaci�n:	24/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


-- ==========================================================


DELETE
FROM	MOVIMIENTO_FLUJO_DIARIO

DELETE
FROM	DETALLE_INSTRUCCION


DELETE
FROM	INSTRUCCION
WHERE	YEAR(F_INSTRUCCION)=2018
AND		MONTH(F_INSTRUCCION)=11


DELETE
FROM	RESUMEN_FLUJO_DIARIO_X_UNO 
WHERE	YEAR(F_OPERACION)=2018
AND		MONTH(F_OPERACION)=11



-- ==========================================================



-- == X K_TRASPASO =========================================================== 
-- ================================================== K_UNIDAD_OPERATIVA // 15

EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31815440, '30/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31815483, '30/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31815484, '30/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31815485, '30/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31815486, '30/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31815439, '30/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31815442, '30/NOV/2018'

GO



-- == X K_TRASPASO =========================================================== 
-- ================================================== K_UNIDAD_OPERATIVA // 23


EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31816145, '27/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31816146, '27/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31816099, '27/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31816102, '27/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31816103, '27/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31816110, '27/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31816114, '27/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31816115, '27/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31816119, '27/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31816123, '27/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_TRASPASO]	1,0,0,
												31816127, '27/NOV/2018'
GO



-- == X K_FACTURA_CXC ========================================================
-- ================================================== K_UNIDAD_OPERATIVA // 23


EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0,
													1, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0,
													2, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0,
													3, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0,
													4, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0,
													6, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0,
													8, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0,
													9, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0,
													11, '11/NOV/2018'

EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0,
													12, '11/NOV/2018'
GO


-- == X K_FACTURA_CXC ========================================================
-- ==================================================  ABASTECIMIENTO


EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0, 1001001, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0, 1001002, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0, 1001003, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0, 1001004, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0, 1001005, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0, 1001006, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0, 1001007, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0, 1001008, '11/NOV/2018'
EXECUTE	[dbo].[PG_PR_INSTRUCCION_X_K_FACTURA_CXP]	1,0,0, 1001009, '11/NOV/2018'

GO



-- ==========================================================
-- ==================================================  INGRESOS

EXECUTE [dbo].[PG_PR_INGRESOS_X_FECHA] 0,0,0,	'2018/NOV/11'
EXECUTE [dbo].[PG_PR_INGRESOS_X_FECHA] 0,0,0,	'2018/NOV/30'



-- ===========================================


SELECT	* 
FROM	RESUMEN_FLUJO_DIARIO_X_UNO 
WHERE	YEAR(F_OPERACION)=2018
AND		MONTH(F_OPERACION)=11
ORDER BY K_RESUMEN_FLUJO_DIARIO_X_UNO DESC


SELECT	* 
FROM	INSTRUCCION
WHERE	YEAR(F_INSTRUCCION)=2018
AND		MONTH(F_INSTRUCCION)=11
ORDER BY K_INSTRUCCION DESC


SELECT	* 
FROM	DETALLE_INSTRUCCION
ORDER BY K_DETALLE_INSTRUCCION DESC


SELECT	* 
FROM	MOVIMIENTO_FLUJO_DIARIO
ORDER BY K_MOVIMIENTO_FLUJO_DIARIO DESC



SELECT	D_RUBRO_FLUJO, MOVIMIENTO_FLUJO_DIARIO.* 
FROM	MOVIMIENTO_FLUJO_DIARIO, RUBRO_FLUJO
WHERE	MOVIMIENTO_FLUJO_DIARIO.K_RUBRO_FLUJO=RUBRO_FLUJO.K_RUBRO_FLUJO
AND		F_MOVIMIENTO_FLUJO_DIARIO='2018-11-30'
AND		K_UNIDAD_OPERATIVA=15
ORDER BY	-- K_RAZON_SOCIAL,	
			K_UNIDAD_OPERATIVA,	
			F_MOVIMIENTO_FLUJO_DIARIO, O_RUBRO_FLUJO, O_MOVIMIENTO_FLUJO_DIARIO ASC



-- ==========================================================





-- ===========================================

