-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CONFIGURACION - MANEJO DE FECHAS   		
-- // OPERACION:		LIBERACION    
-- //////////////////////////////////////////////////////////////

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // DROPs 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIEMPO_YYYY]') AND type in (N'U'))
	DROP TABLE [dbo].[TIEMPO_YYYY] 
GO



-- //////////////////////////////////////////////////////////////
-- // TIEMPO_YYYY 
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[TIEMPO_YYYY] (
	[K_TIEMPO_YYYY]	[INT] NOT NULL,
	[D_TIEMPO_YYYY]	[VARCHAR] (100) NOT NULL,
	[S_TIEMPO_YYYY]	[VARCHAR] (10) NOT NULL,
	[O_TIEMPO_YYYY]	[INT] NOT NULL,
	[C_TIEMPO_YYYY]	[VARCHAR] (255) NOT NULL,
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[TIEMPO_YYYY]
	ADD CONSTRAINT [PK_TIEMPO_YYYY]
	PRIMARY KEY CLUSTERED ( [K_TIEMPO_YYYY] )
GO

-- ===============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIEMPO_YYYY]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIEMPO_YYYY]
GO

CREATE PROCEDURE [dbo].[PG_CI_TIEMPO_YYYY]
	@PP_L_DEBUG			INT,
	@PP_K_SISTEMA_EXE	INT,
	@PP_K_TIEMPO_YYYY	INT,
	@PP_D_TIEMPO_YYYY	VARCHAR(100),
	@PP_S_TIEMPO_YYYY	VARCHAR(10),
	@PP_O_TIEMPO_YYYY	INT,
	@PP_C_TIEMPO_YYYY	VARCHAR(255)
AS

	INSERT INTO TIEMPO_YYYY
		(	K_TIEMPO_YYYY,		D_TIEMPO_YYYY, 
			S_TIEMPO_YYYY,		O_TIEMPO_YYYY,
			C_TIEMPO_YYYY		)
	VALUES	
		(	@PP_K_TIEMPO_YYYY,	@PP_D_TIEMPO_YYYY,	
			@PP_S_TIEMPO_YYYY,	@PP_O_TIEMPO_YYYY,
			@PP_C_TIEMPO_YYYY	)

GO

-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_TIEMPO_YYYY]	0, 0,  2010, '2010', '2010', 2010, ''
EXECUTE [dbo].[PG_CI_TIEMPO_YYYY]	0, 0,  2011, '2011', '2011', 2011, ''
EXECUTE [dbo].[PG_CI_TIEMPO_YYYY]	0, 0,  2012, '2012', '2012', 2012, ''
EXECUTE [dbo].[PG_CI_TIEMPO_YYYY]	0, 0,  2013, '2013', '2013', 2013, ''
EXECUTE [dbo].[PG_CI_TIEMPO_YYYY]	0, 0,  2014, '2014', '2014', 2014, ''
EXECUTE [dbo].[PG_CI_TIEMPO_YYYY]	0, 0,  2015, '2015', '2015', 2015, ''
EXECUTE [dbo].[PG_CI_TIEMPO_YYYY]	0, 0,  2016, '2016', '2016', 2016, ''
EXECUTE [dbo].[PG_CI_TIEMPO_YYYY]	0, 0,  2017, '2017', '2017', 2017, ''
EXECUTE [dbo].[PG_CI_TIEMPO_YYYY]	0, 0,  2018, '2018', '2018', 2018, ''
EXECUTE [dbo].[PG_CI_TIEMPO_YYYY]	0, 0,  2019, '2019', '2019', 2019, ''
EXECUTE [dbo].[PG_CI_TIEMPO_YYYY]	0, 0,  2020, '2020', '2020', 2020, ''
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================



-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////

