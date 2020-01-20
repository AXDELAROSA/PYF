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

DELETE 
FROM	[dbo].[FORMATO_D0M4]

GO






-- ///////////////////////////////////////////////////////////////
-- //						FORMATO_D0M4 						
-- ///////////////////////////////////////////////////////////////


EXECUTE [dbo].[PG_CI_FORMATO_D0M4]	0, 0, 101, 'C3M3 // COMPROMISO',					'C3M3', 10, '', 1, 1
EXECUTE [dbo].[PG_CI_FORMATO_D0M4]	0, 0, 102, 'PR3C // PRECIOS-COSTOS GAS',			'PREC', 10, '', 1, 3
EXECUTE [dbo].[PG_CI_FORMATO_D0M4]	0, 0, 103, 'FLUP // FLUJO PROYECTADO',				'FLUP', 20, '', 1, 1

EXECUTE [dbo].[PG_CI_FORMATO_D0M4]	0, 0, 902, 'C3M3 // SEGUIMIENTO COMPROMISO',		'', 99, '', 1, 1
EXECUTE [dbo].[PG_CI_FORMATO_D0M4]	0, 0, 904, 'C3M3 // SEGUIMIENTO FLUJO',				'', 99, '', 1, 1
EXECUTE [dbo].[PG_CI_FORMATO_D0M4]	0, 0, 905, 'PRESUPUESTO',							'', 99, '', 1, 3
EXECUTE [dbo].[PG_CI_FORMATO_D0M4]	0, 0, 906, 'PLAN FINANCIERO',						'', 99, '', 1, 3

EXECUTE [dbo].[PG_CI_FORMATO_D0M4]	0, 0, 907, 'PROYECCION DE VENTAS OBJETIVO',			'POB', 30,	'', 1, 3


GO





-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
