-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PLAN_GASTO GASTOS / PLANTA
-- // OPERACION:		LIBERACION / CARGA INICIAL / DATA
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	16/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- SELECT * FROM	[dbo].[PLAN_GASTO] 

DELETE 
FROM	[dbo].[PARTIDA_PLAN_GASTO] 
WHERE	K_PLAN_GASTO<>0
GO


DELETE 
FROM	[dbo].[PLAN_GASTO] 
WHERE	K_PLAN_GASTO<>0
GO


-- //////////////////////////////////////////////////////////////



-- ===============================================
SET NOCOUNT ON
-- ===============================================




-- ========================================= JAL

EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 30
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 51
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 52
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 53
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 54
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 55
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 56
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 57
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 70
GO

-- ========================================= CHIH

EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 02
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 03
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 07
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 09
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 11
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 12
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 15
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 17
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 83
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 84
GO

-- ========================================= CDMX

EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 13
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 18
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 20
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 21
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 23
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 24
GO

-- ========================================= CEN

EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 19
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 25
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 26
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 27
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 28
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 29
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 31
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 32
GO

-- ========================================= SON

EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 36
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 37
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 38
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 39
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 40
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 41
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 42
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 43
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 44
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 45
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 46
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 47
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 48
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 49
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 73
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 76
GO



-- ========================================= SUR

EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 59
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 60
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 61
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 62
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 63
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 64
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 65
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 67
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 71
GO



-- ========================================= BJA

EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 33
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 34
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 35
EXECUTE	[dbo].[PG_PR_PLAN_GASTO_CLONAR]		0,0,0,	0000, 69
GO




-- ===============================================
SET NOCOUNT OFF
-- ===============================================




-- //////////////////////////////////////////////////////////////
-- SELECT * FROM	[dbo].[PLAN_GASTO] 



DELETE 
FROM	[dbo].[PARTIDA_PLAN_GASTO] 
WHERE	K_PLAN_GASTO=0
GO


DELETE 
FROM	[dbo].[PLAN_GASTO] 
WHERE	K_PLAN_GASTO=0
GO


-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////


UPDATE	PLAN_GASTO
SET		K_ESTATUS_PLAN_GASTO = 5
WHERE	K_UNIDAD_OPERATIVA IN ( 30, 51, 53 ) 


-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////

