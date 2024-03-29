-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			TIPO_CALCULO
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


-- USE [D4C3_Datamart_XLS_V0012_R0]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIPO_CALCULO]') AND type in (N'U'))
	DROP TABLE [dbo].[TIPO_CALCULO]
GO


CREATE TABLE [dbo].[TIPO_CALCULO](
	[K_TIPO_CALCULO]	[INT]				NOT NULL,
	[D_TIPO_CALCULO]	[VARCHAR](100)		NOT NULL,
	[C_TIPO_CALCULO]	[VARCHAR](200)		NOT NULL,
	
) ON [PRIMARY]
GO
 
-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[TIPO_CALCULO]
	ADD CONSTRAINT [K_TIPO_CALCULO]
		PRIMARY KEY CLUSTERED ([K_TIPO_CALCULO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TIPO_CALCULO_01_DESCRIPCION] 
	   ON [dbo].[TIPO_CALCULO] ( [D_TIPO_CALCULO] )
GO

-- //////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --> [PG_CI_TIPO_CALCULO]
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIPO_CALCULO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIPO_CALCULO]
GO



CREATE PROCEDURE [dbo].[PG_CI_TIPO_CALCULO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	@PP_K_TIPO_CALCULO				INT,
	@PP_D_TIPO_CALCULO				VARCHAR(100),
	@PP_C_TIPO_CALCULO				VARCHAR(255)
AS

	INSERT INTO TIPO_CALCULO
		(	
			[K_TIPO_CALCULO],			
			[D_TIPO_CALCULO],
			[C_TIPO_CALCULO]
		)	
	VALUES	
		(	 
			@PP_K_TIPO_CALCULO,
			@PP_D_TIPO_CALCULO,
			@PP_C_TIPO_CALCULO				
		)

	-- ////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- // [TIPO_CALCULO] 						
-- ///////////////////////////////////////////////////////////////

EXECUTE [dbo].[PG_CI_TIPO_CALCULO]	0, 0, 69, 1, 'POR PROMEDIO',		'TOMA EL PROMEDIO DE LAS VENTAS DE LOS AÑOS CONSIDERADOS'
EXECUTE [dbo].[PG_CI_TIPO_CALCULO]	0, 0, 69, 2, 'MINIMOS CUADRADOS',	'USA LA FORMULA DE MINIMOS CUADRADOS PARA DEFINIR LA RESTA DE  VENTAS'

GO

