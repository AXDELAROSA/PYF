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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATA_N1_X_DI_D0M4]') AND type in (N'U'))
	DELETE 
	FROM	[dbo].[DATA_N1_X_DI_D0M4]

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DOCUMENTO_D0M4]') AND type in (N'U'))
	DELETE 
	FROM	[dbo].[DOCUMENTO_D0M4]

-- ======================




-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////


-- ===============================================
SET NOCOUNT ON
-- ===============================================


DELETE 
FROM	[dbo].[DEFINICION_D0M4]

DELETE 
FROM	[dbo].[FORMATO_D0M4]

DELETE 
FROM	[dbo].[NIVEL_DETALLE] 

DELETE 
FROM	[dbo].[DATO_D0M4] 

DELETE 
FROM	[dbo].[UNIDAD_DATO_D0M4] 

GO



-- ///////////////////////////////////////////////////////////////
-- //						UNIDAD_DATO_D0M4 						
-- ///////////////////////////////////////////////////////////////

EXECUTE [dbo].[PG_CI_UNIDAD_DATO_D0M4]	0, 0, 1, 'PESOS',		'$', 10, '', 1
EXECUTE [dbo].[PG_CI_UNIDAD_DATO_D0M4]	0, 0, 2, 'KILOS',		'KG', 20, '', 1
EXECUTE [dbo].[PG_CI_UNIDAD_DATO_D0M4]	0, 0, 3, 'LITROS',		'LT', 20, '', 1
EXECUTE [dbo].[PG_CI_UNIDAD_DATO_D0M4]	0, 0, 4, 'PORCENTAJE',	'%', 30, '', 1
EXECUTE [dbo].[PG_CI_UNIDAD_DATO_D0M4]	0, 0, 5, 'UNIDADES',	'UNI', 30, '', 1
EXECUTE [dbo].[PG_CI_UNIDAD_DATO_D0M4]	0, 0, 6, 'CIFRA',		'###', 30, '', 1
GO



-- ///////////////////////////////////////////////////////////////
-- //						NIVEL_DETALLE 						
-- ///////////////////////////////////////////////////////////////

EXECUTE [dbo].[PG_CI_NIVEL_DETALLE]	0, 0, 1, 'DIARIO',		'DIA', 10, '', 1
EXECUTE [dbo].[PG_CI_NIVEL_DETALLE]	0, 0, 2, 'SEMANAL',		'SEM', 20, '', 1
EXECUTE [dbo].[PG_CI_NIVEL_DETALLE]	0, 0, 3, 'MENSUAL',		'MEN', 20, '', 1
EXECUTE [dbo].[PG_CI_NIVEL_DETALLE]	0, 0, 4, 'ANUAL',		'ANU', 30, '', 1
EXECUTE [dbo].[PG_CI_NIVEL_DETALLE] 0, 0, 5, 'TEMPORADA',   'TEM', 40, '', 1
GO



-- ===============================================
SET NOCOUNT OFF
-- ===============================================




-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
