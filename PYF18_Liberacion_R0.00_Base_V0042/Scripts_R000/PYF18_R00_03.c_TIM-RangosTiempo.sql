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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIEMPO_DIA_MES]') AND type in (N'U'))
	DROP TABLE [dbo].[TIEMPO_DIA_MES] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIEMPO_DIA_SEMANA]') AND type in (N'U'))
	DROP TABLE [dbo].[TIEMPO_DIA_SEMANA] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIEMPO_QUINCENA]') AND type in (N'U'))
	DROP TABLE [dbo].[TIEMPO_QUINCENA] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIEMPO_BIMESTRE]') AND type in (N'U'))
	DROP TABLE [dbo].[TIEMPO_BIMESTRE] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIEMPO_TRIMESTRE]') AND type in (N'U'))
	DROP TABLE [dbo].[TIEMPO_TRIMESTRE] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIEMPO_MES]') AND type in (N'U'))
	DROP TABLE [dbo].[TIEMPO_MES] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIEMPO_CUATRIMESTRE]') AND type in (N'U'))
	DROP TABLE [dbo].[TIEMPO_CUATRIMESTRE] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIEMPO_SEMESTRE]') AND type in (N'U'))
	DROP TABLE [dbo].[TIEMPO_SEMESTRE] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIEMPO_MES]') AND type in (N'U'))
	DROP TABLE [dbo].[TIEMPO_MES] 
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIEMPO_RANGO]') AND type in (N'U'))
	DROP TABLE [dbo].[TIEMPO_RANGO] 
GO

/****************************************************************/
/*						TIEMPO_RANGO	 						*/
/****************************************************************/

CREATE TABLE [dbo].[TIEMPO_RANGO] (
	[K_TIEMPO_RANGO]	[INT] NOT NULL,
	[D_TIEMPO_RANGO]	[VARCHAR] (100) NOT NULL,
	[S_TIEMPO_RANGO]	[VARCHAR] (10) NOT NULL,
	[O_TIEMPO_RANGO]	[INT] NOT NULL,
	[C_TIEMPO_RANGO]	[VARCHAR] (255) NOT NULL,
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[TIEMPO_RANGO]
	ADD CONSTRAINT [PK_TIEMPO_RANGO]
	PRIMARY KEY CLUSTERED ( [K_TIEMPO_RANGO] )
GO

-- ===============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIEMPO_RANGO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIEMPO_RANGO]
GO

CREATE PROCEDURE [dbo].[PG_CI_TIEMPO_RANGO]
	@PP_L_DEBUG			INT,
	@PP_K_SISTEMA_EXE	INT,
	@PP_K_TIEMPO_RANGO	INT,
	@PP_D_TIEMPO_RANGO	VARCHAR(100),
	@PP_S_TIEMPO_RANGO	VARCHAR(10),
	@PP_O_TIEMPO_RANGO	INT,
	@PP_C_TIEMPO_RANGO	VARCHAR(255)
AS

	INSERT INTO TIEMPO_RANGO
		(	K_TIEMPO_RANGO,		D_TIEMPO_RANGO, 
			S_TIEMPO_RANGO,		O_TIEMPO_RANGO,
			C_TIEMPO_RANGO		)
	VALUES	
		(	@PP_K_TIEMPO_RANGO,	@PP_D_TIEMPO_RANGO,	
			@PP_S_TIEMPO_RANGO,	@PP_O_TIEMPO_RANGO,
			@PP_C_TIEMPO_RANGO	)

GO

-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_TIEMPO_RANGO]	0, 0,  0, 'TODO',		'TDO', -1, ''
EXECUTE [dbo].[PG_CI_TIEMPO_RANGO]	0, 0,  1, 'HOY',		'HOY',  0, ''
EXECUTE [dbo].[PG_CI_TIEMPO_RANGO]	0, 0,  2, '1 SEMANA',	'1SE',  7, ''
EXECUTE [dbo].[PG_CI_TIEMPO_RANGO]	0, 0,  3, '2 SEMANAS',	'2SE', 14, ''
EXECUTE [dbo].[PG_CI_TIEMPO_RANGO]	0, 0,  4, '1 MES',		'1ME', 30, ''
EXECUTE [dbo].[PG_CI_TIEMPO_RANGO]	0, 0,  5, '2 MESES',	'2ME', 61, ''
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================







/****************************************************************/
/*						TIEMPO_DIA_SEMANA 						*/
/****************************************************************/

CREATE TABLE [dbo].[TIEMPO_DIA_SEMANA] (
	[K_TIEMPO_DIA_SEMANA]	[INT] NOT NULL,
	[D_TIEMPO_DIA_SEMANA]	[VARCHAR] (100) NOT NULL,
	[S_TIEMPO_DIA_SEMANA]	[VARCHAR] (10) NOT NULL,
	[O_TIEMPO_DIA_SEMANA]	[INT] NOT NULL,
	[C_TIEMPO_DIA_SEMANA]	[VARCHAR] (255) NOT NULL,
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[TIEMPO_DIA_SEMANA]
	ADD CONSTRAINT [PK_TIEMPO_DIA_SEMANA]
	PRIMARY KEY CLUSTERED ( [K_TIEMPO_DIA_SEMANA] )
GO

-- ===============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIEMPO_DIA_SEMANA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIEMPO_DIA_SEMANA]
GO

CREATE PROCEDURE [dbo].[PG_CI_TIEMPO_DIA_SEMANA]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_TIEMPO_DIA_SEMANA	INT,
	@PP_D_TIEMPO_DIA_SEMANA	VARCHAR(100),
	@PP_S_TIEMPO_DIA_SEMANA	VARCHAR(10),
	@PP_O_TIEMPO_DIA_SEMANA	INT,
	@PP_C_TIEMPO_DIA_SEMANA	VARCHAR(255)
AS

	INSERT INTO TIEMPO_DIA_SEMANA
		(	K_TIEMPO_DIA_SEMANA,		D_TIEMPO_DIA_SEMANA, 
			S_TIEMPO_DIA_SEMANA,		O_TIEMPO_DIA_SEMANA,
			C_TIEMPO_DIA_SEMANA		)
	VALUES	
		(	@PP_K_TIEMPO_DIA_SEMANA,	@PP_D_TIEMPO_DIA_SEMANA,	
			@PP_S_TIEMPO_DIA_SEMANA,	@PP_O_TIEMPO_DIA_SEMANA,
			@PP_C_TIEMPO_DIA_SEMANA	)

GO

-- ===============================================

-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_TIEMPO_DIA_SEMANA]		0, 0,  1, 'Lunes',			'LUN', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_SEMANA]		0, 0,  2, 'Martes',		'MAR', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_SEMANA]		0, 0,  3, 'Miercoles',		'MIE', 30, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_SEMANA]		0, 0,  4, 'Jueves',		'JUE', 40, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_SEMANA]		0, 0,  5, 'Viernes',		'VIE', 50, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_SEMANA]		0, 0,  6, 'Sábado',		'SAB', 60, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_SEMANA]		0, 0,  7, 'Domingo',		'DOM', 70, ''
GO


-- ===============================================
SET NOCOUNT OFF
-- ===============================================



/****************************************************************/
/*						TIEMPO_QUINCENA 						*/
/****************************************************************/

CREATE TABLE [dbo].[TIEMPO_QUINCENA] (
	[K_TIEMPO_QUINCENA]	[INT] NOT NULL,
	[D_TIEMPO_QUINCENA]	[VARCHAR] (100) NOT NULL,
	[S_TIEMPO_QUINCENA]	[VARCHAR] (10) NOT NULL,
	[O_TIEMPO_QUINCENA]	[INT] NOT NULL,
	[C_TIEMPO_QUINCENA]	[VARCHAR] (255) NOT NULL,
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[TIEMPO_QUINCENA]
	ADD CONSTRAINT [PK_TIEMPO_QUINCENA]
	PRIMARY KEY CLUSTERED ( [K_TIEMPO_QUINCENA] )
GO

-- ===============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIEMPO_QUINCENA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIEMPO_QUINCENA]
GO

CREATE PROCEDURE [dbo].[PG_CI_TIEMPO_QUINCENA]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_TIEMPO_QUINCENA	INT,
	@PP_D_TIEMPO_QUINCENA	VARCHAR(100),
	@PP_S_TIEMPO_QUINCENA	VARCHAR(10),
	@PP_O_TIEMPO_QUINCENA	INT,
	@PP_C_TIEMPO_QUINCENA	VARCHAR(255)
AS

	INSERT INTO TIEMPO_QUINCENA
		(	K_TIEMPO_QUINCENA,		D_TIEMPO_QUINCENA, 
			S_TIEMPO_QUINCENA,		O_TIEMPO_QUINCENA,
			C_TIEMPO_QUINCENA		)
	VALUES	
		(	@PP_K_TIEMPO_QUINCENA,	@PP_D_TIEMPO_QUINCENA,	
			@PP_S_TIEMPO_QUINCENA,	@PP_O_TIEMPO_QUINCENA,
			@PP_C_TIEMPO_QUINCENA	)

GO



-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_TIEMPO_QUINCENA]  0, 0, 0, 'N/A - Quincena ',	'QUI.0', 99, ''
EXECUTE [dbo].[PG_CI_TIEMPO_QUINCENA]  0, 0, 1, 'Quincena 1',		'QUI.1', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_QUINCENA]  0, 0, 2, 'Quincena 2',		'QUI.2', 20, ''
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================





/****************************************************************/
/*						TIEMPO_BIMESTRE 						*/
/****************************************************************/

CREATE TABLE [dbo].[TIEMPO_BIMESTRE] (
	[K_TIEMPO_BIMESTRE]	[INT] NOT NULL,
	[D_TIEMPO_BIMESTRE]	[VARCHAR] (100) NOT NULL,
	[S_TIEMPO_BIMESTRE]	[VARCHAR] (10) NOT NULL,
	[O_TIEMPO_BIMESTRE]	[INT] NOT NULL,
	[C_TIEMPO_BIMESTRE]	[VARCHAR] (255) NOT NULL,
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[TIEMPO_BIMESTRE]
	ADD CONSTRAINT [PK_TIEMPO_BIMESTRE]
	PRIMARY KEY CLUSTERED ( [K_TIEMPO_BIMESTRE] )
GO

-- ===============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIEMPO_BIMESTRE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIEMPO_BIMESTRE]
GO

CREATE PROCEDURE [dbo].[PG_CI_TIEMPO_BIMESTRE]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_TIEMPO_BIMESTRE	INT,
	@PP_D_TIEMPO_BIMESTRE	VARCHAR(100),
	@PP_S_TIEMPO_BIMESTRE	VARCHAR(10),
	@PP_O_TIEMPO_BIMESTRE	INT,
	@PP_C_TIEMPO_BIMESTRE	VARCHAR(255)
AS

	INSERT INTO TIEMPO_BIMESTRE
		(	K_TIEMPO_BIMESTRE,		D_TIEMPO_BIMESTRE, 
			S_TIEMPO_BIMESTRE,		O_TIEMPO_BIMESTRE,
			C_TIEMPO_BIMESTRE		)
	VALUES	
		(	@PP_K_TIEMPO_BIMESTRE,	@PP_D_TIEMPO_BIMESTRE,	
			@PP_S_TIEMPO_BIMESTRE,	@PP_O_TIEMPO_BIMESTRE,
			@PP_C_TIEMPO_BIMESTRE	)

GO


-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_TIEMPO_BIMESTRE]	0, 0,  1, 'Ene-Feb',	'BIM.1', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_BIMESTRE]	0, 0,  2, 'Mar-Abr',	'BIM.2', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_BIMESTRE]	0, 0,  3, 'May-Jun',	'BIM.3', 30, ''
EXECUTE [dbo].[PG_CI_TIEMPO_BIMESTRE]	0, 0,  4, 'Jul-Ago',	'BIM.4', 40, ''
EXECUTE [dbo].[PG_CI_TIEMPO_BIMESTRE]	0, 0,  5, 'Sep-Oct',	'BIM.5', 50, ''
EXECUTE [dbo].[PG_CI_TIEMPO_BIMESTRE]	0, 0,  6, 'Nov-Dic',	'BIM.6', 60, ''
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================





/****************************************************************/
/*						TIEMPO_TRIMESTRE 						*/
/****************************************************************/

CREATE TABLE [dbo].[TIEMPO_TRIMESTRE] (
	[K_TIEMPO_TRIMESTRE]	[INT] NOT NULL,
	[D_TIEMPO_TRIMESTRE]	[VARCHAR] (100) NOT NULL,
	[S_TIEMPO_TRIMESTRE]	[VARCHAR] (10) NOT NULL,
	[O_TIEMPO_TRIMESTRE]	[INT] NOT NULL,
	[C_TIEMPO_TRIMESTRE]	[VARCHAR] (255) NOT NULL,
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[TIEMPO_TRIMESTRE]
	ADD CONSTRAINT [PK_TIEMPO_TRIMESTRE]
		PRIMARY KEY CLUSTERED ( [K_TIEMPO_TRIMESTRE] )
GO

-- ===============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIEMPO_TRIMESTRE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIEMPO_TRIMESTRE]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIEMPO_TRIMESTRE]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_TIEMPO_TRIMESTRE	INT,
	@PP_D_TIEMPO_TRIMESTRE	VARCHAR(100),
	@PP_S_TIEMPO_TRIMESTRE	VARCHAR(10),
	@PP_O_TIEMPO_TRIMESTRE	INT,
	@PP_C_TIEMPO_TRIMESTRE	VARCHAR(255)
AS

	INSERT INTO TIEMPO_TRIMESTRE
		(	K_TIEMPO_TRIMESTRE,		D_TIEMPO_TRIMESTRE, 
			S_TIEMPO_TRIMESTRE,		O_TIEMPO_TRIMESTRE,
			C_TIEMPO_TRIMESTRE		)
	VALUES	
		(	@PP_K_TIEMPO_TRIMESTRE,	@PP_D_TIEMPO_TRIMESTRE,	
			@PP_S_TIEMPO_TRIMESTRE,	@PP_O_TIEMPO_TRIMESTRE,
			@PP_C_TIEMPO_TRIMESTRE	)

GO



-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_TIEMPO_TRIMESTRE]	0, 0,  1, 'Ene-Feb-Mar',	'TRI.1', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_TRIMESTRE]	0, 0,  2, 'Abr-May-Jun',	'TRI.2', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_TRIMESTRE]	0, 0,  3, 'Jul-Ago-Sep',	'TRI.3', 30, ''
EXECUTE [dbo].[PG_CI_TIEMPO_TRIMESTRE]	0, 0,  4, 'Oct-Nov-Dic',	'TRI.4', 40, ''
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================





/****************************************************************/
/*						TIEMPO_CUATRIMESTRE 					*/
/****************************************************************/

CREATE TABLE [dbo].[TIEMPO_CUATRIMESTRE] (
	[K_TIEMPO_CUATRIMESTRE]	[INT] NOT NULL,
	[D_TIEMPO_CUATRIMESTRE]	[VARCHAR] (100) NOT NULL,
	[S_TIEMPO_CUATRIMESTRE]	[VARCHAR] (10) NOT NULL,
	[O_TIEMPO_CUATRIMESTRE]	[INT] NOT NULL,
	[C_TIEMPO_CUATRIMESTRE]	[VARCHAR] (255) NOT NULL,
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[TIEMPO_CUATRIMESTRE]
	ADD CONSTRAINT [PK_TIEMPO_CUATRIMESTRE]
	PRIMARY KEY CLUSTERED ( [K_TIEMPO_CUATRIMESTRE] )
GO

-- ===============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIEMPO_CUATRIMESTRE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIEMPO_CUATRIMESTRE]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIEMPO_CUATRIMESTRE]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_TIEMPO_CUATRIMESTRE	INT,
	@PP_D_TIEMPO_CUATRIMESTRE	VARCHAR(100),
	@PP_S_TIEMPO_CUATRIMESTRE	VARCHAR(10),
	@PP_O_TIEMPO_CUATRIMESTRE	INT,
	@PP_C_TIEMPO_CUATRIMESTRE	VARCHAR(255)
AS

	INSERT INTO TIEMPO_CUATRIMESTRE
		(	K_TIEMPO_CUATRIMESTRE,		D_TIEMPO_CUATRIMESTRE, 
			S_TIEMPO_CUATRIMESTRE,		O_TIEMPO_CUATRIMESTRE,
			C_TIEMPO_CUATRIMESTRE		)
	VALUES	
		(	@PP_K_TIEMPO_CUATRIMESTRE,	@PP_D_TIEMPO_CUATRIMESTRE,	
			@PP_S_TIEMPO_CUATRIMESTRE,	@PP_O_TIEMPO_CUATRIMESTRE,
			@PP_C_TIEMPO_CUATRIMESTRE	)

GO



-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_TIEMPO_CUATRIMESTRE]	0, 0,  1, 'Ene-Feb-Mar-Abr',	'CUA.1', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_CUATRIMESTRE]	0, 0,  2, 'May-Jun-Jul-Ago',	'CUA.2', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_CUATRIMESTRE]	0, 0,  3, 'Sep-Oct-Nov-Dic',	'CUA.3', 30, ''
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================





/****************************************************************/
/*						TIEMPO_SEMESTRE 						*/
/****************************************************************/

CREATE TABLE [dbo].[TIEMPO_SEMESTRE] (
	[K_TIEMPO_SEMESTRE]	[INT] NOT NULL,
	[D_TIEMPO_SEMESTRE]	[VARCHAR] (100) NOT NULL,
	[S_TIEMPO_SEMESTRE]	[VARCHAR] (10) NOT NULL,
	[O_TIEMPO_SEMESTRE]	[INT] NOT NULL,
	[C_TIEMPO_SEMESTRE]	[VARCHAR] (255) NOT NULL,
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[TIEMPO_SEMESTRE]
	ADD CONSTRAINT [PK_TIEMPO_SEMESTRE]
	PRIMARY KEY CLUSTERED ( [K_TIEMPO_SEMESTRE] )
GO

-- ===============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIEMPO_SEMESTRE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIEMPO_SEMESTRE]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIEMPO_SEMESTRE]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_TIEMPO_SEMESTRE	INT,
	@PP_D_TIEMPO_SEMESTRE	VARCHAR(100),
	@PP_S_TIEMPO_SEMESTRE	VARCHAR(10),
	@PP_O_TIEMPO_SEMESTRE	INT,
	@PP_C_TIEMPO_SEMESTRE	VARCHAR(255)
AS

	INSERT INTO TIEMPO_SEMESTRE
		(	K_TIEMPO_SEMESTRE,		D_TIEMPO_SEMESTRE, 
			S_TIEMPO_SEMESTRE,		O_TIEMPO_SEMESTRE,
			C_TIEMPO_SEMESTRE		)
	VALUES	
		(	@PP_K_TIEMPO_SEMESTRE,	@PP_D_TIEMPO_SEMESTRE,	
			@PP_S_TIEMPO_SEMESTRE,	@PP_O_TIEMPO_SEMESTRE,
			@PP_C_TIEMPO_SEMESTRE	)

GO

-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_TIEMPO_SEMESTRE]	0, 0, 1, 'Ene-Feb-Mar-Abr-May-Jun',	'SEM.1', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_SEMESTRE]	0, 0, 2, 'Jul-Ago-Sep-Oct-Nov-Dic',	'SEM.3', 20, ''
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================






/****************************************************************/
/*							TIEMPO_MES 							*/
/****************************************************************/

CREATE TABLE [dbo].[TIEMPO_MES] (
	[K_TIEMPO_MES]	[INT] NOT NULL,
	[D_TIEMPO_MES]	[VARCHAR] (100) NOT NULL,
	[S_TIEMPO_MES]	[VARCHAR] (10) NOT NULL,
	[O_TIEMPO_MES]	[INT] NOT NULL,
	[C_TIEMPO_MES]	[VARCHAR] (255) NOT NULL,
	-- ================================
	[K_TIEMPO_BIMESTRE]		[INT] NULL,
	[K_TIEMPO_TRIMESTRE]	[INT] NULL,
	[K_TIEMPO_CUATRIMESTRE]	[INT] NULL,
	[K_TIEMPO_SEMESTRE]		[INT] NULL
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[TIEMPO_MES]
	ADD CONSTRAINT [PK_TIEMPO_MES]
	PRIMARY KEY CLUSTERED ( [K_TIEMPO_MES] )
GO

-- ===============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIEMPO_MES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIEMPO_MES]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIEMPO_MES]
	@PP_L_DEBUG			INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_TIEMPO_MES	INT,
	@PP_D_TIEMPO_MES	VARCHAR(100),
	@PP_S_TIEMPO_MES	VARCHAR(10),
	@PP_O_TIEMPO_MES	INT,
	@PP_C_TIEMPO_MES	VARCHAR(255),
	-- ================================
	@PP_K_TIEMPO_BIMESTRE		INT,
	@PP_K_TIEMPO_TRIMESTRE		INT,
	@PP_K_TIEMPO_CUATRIMESTRE	INT,
	@PP_K_TIEMPO_SEMESTRE		INT
AS

	INSERT INTO TIEMPO_MES
		(	K_TIEMPO_MES,		D_TIEMPO_MES, 
			S_TIEMPO_MES,		O_TIEMPO_MES,
			C_TIEMPO_MES,
			K_TIEMPO_BIMESTRE, K_TIEMPO_TRIMESTRE, K_TIEMPO_CUATRIMESTRE, K_TIEMPO_SEMESTRE						)
	VALUES	
		(	@PP_K_TIEMPO_MES,	@PP_D_TIEMPO_MES,	
			@PP_S_TIEMPO_MES,	@PP_O_TIEMPO_MES,
			@PP_C_TIEMPO_MES,
			@PP_K_TIEMPO_BIMESTRE, @PP_K_TIEMPO_TRIMESTRE, @PP_K_TIEMPO_CUATRIMESTRE, @PP_K_TIEMPO_SEMESTRE		)

GO



-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_TIEMPO_MES]	0, 0,  1, 'Enero',			'ENE', 01, '', 1, 1, 1, 1
EXECUTE [dbo].[PG_CI_TIEMPO_MES]	0, 0,  2, 'Febrero',		'FEB', 02, '', 1, 1, 1, 1 
EXECUTE [dbo].[PG_CI_TIEMPO_MES]	0, 0,  3, 'Marzo',			'MAR', 03, '', 2, 1, 1, 1
EXECUTE [dbo].[PG_CI_TIEMPO_MES]	0, 0,  4, 'Abril',			'ABR', 04, '', 2, 2, 1, 1
EXECUTE [dbo].[PG_CI_TIEMPO_MES]	0, 0,  5, 'Mayo',			'MAY', 05, '', 3, 2, 2, 1
EXECUTE [dbo].[PG_CI_TIEMPO_MES]	0, 0,  6, 'Junio',			'JUN', 06, '', 3, 2, 2, 1
EXECUTE [dbo].[PG_CI_TIEMPO_MES]	0, 0,  7, 'Julio',			'JUL', 07, '', 4, 3, 2, 2
EXECUTE [dbo].[PG_CI_TIEMPO_MES]	0, 0,  8, 'Agosto',			'AGO', 08, '', 4, 3, 2, 2
EXECUTE [dbo].[PG_CI_TIEMPO_MES]	0, 0,  9, 'Septiembre',		'SEP', 09, '', 5, 3, 3, 2
EXECUTE [dbo].[PG_CI_TIEMPO_MES]	0, 0, 10, 'Octubre',		'OCT', 10, '', 5, 4, 3, 2
EXECUTE [dbo].[PG_CI_TIEMPO_MES]	0, 0, 11, 'Noviembre',		'NOV', 11, '', 6, 4, 3, 2
EXECUTE [dbo].[PG_CI_TIEMPO_MES]	0, 0, 12, 'Diciembre',		'DIC', 12, '', 6, 4, 3, 2
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================







/****************************************************************/
/*							TIEMPO_DIA_MES 						*/
/****************************************************************/

CREATE TABLE [dbo].[TIEMPO_DIA_MES] (
	[K_TIEMPO_DIA_MES]	[INT] NOT NULL,
	[D_TIEMPO_DIA_MES]	[VARCHAR] (100) NOT NULL,
	[S_TIEMPO_DIA_MES]	[VARCHAR] (10) NOT NULL,
	[O_TIEMPO_DIA_MES]	[INT] NOT NULL,
	[C_TIEMPO_DIA_MES]	[VARCHAR] (255) NOT NULL,
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[TIEMPO_DIA_MES]
	ADD CONSTRAINT [PK_TIEMPO_DIA_MES]
	PRIMARY KEY CLUSTERED ( [K_TIEMPO_DIA_MES] )
GO

-- ===============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIEMPO_DIA_MES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIEMPO_DIA_MES]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIEMPO_DIA_MES]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_TIEMPO_DIA_MES	INT,
	@PP_D_TIEMPO_DIA_MES	VARCHAR(100),
	@PP_S_TIEMPO_DIA_MES	VARCHAR(10),
	@PP_O_TIEMPO_DIA_MES	INT,
	@PP_C_TIEMPO_DIA_MES	VARCHAR(255)
AS

	INSERT INTO TIEMPO_DIA_MES
		(	K_TIEMPO_DIA_MES,		D_TIEMPO_DIA_MES, 
			S_TIEMPO_DIA_MES,		O_TIEMPO_DIA_MES,
			C_TIEMPO_DIA_MES		)
	VALUES	
		(	@PP_K_TIEMPO_DIA_MES,	@PP_D_TIEMPO_DIA_MES,	
			@PP_S_TIEMPO_DIA_MES,	@PP_K_TIEMPO_DIA_MES,
			@PP_C_TIEMPO_DIA_MES	)

GO


-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,   1, '01',	'D.01', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,   2, '02',	'D.02', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,   3, '03',	'D.03', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,   4, '04',	'D.04', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,   5, '05',	'D.05', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,   6, '06',	'D.06', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,   7, '07',	'D.07', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,   8, '08',	'D.08', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,   9, '09',	'D.09', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  10, '10',	'D.10', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  11, '11',	'D.11', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  12, '12',	'D.12', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  13, '13',	'D.13', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  14, '14',	'D.14', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  15, '15',	'D.15', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  16, '16',	'D.16', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  17, '17',	'D.17', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  18, '18',	'D.18', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  19, '19',	'D.19', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  20, '20',	'D.20', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  21, '21',	'D.21', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  22, '22',	'D.22', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  23, '23',	'D.23', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  24, '24',	'D.24', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  25, '25',	'D.25', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  26, '26',	'D.26', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  27, '27',	'D.27', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  28, '28',	'D.28', 20, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  29, '29',	'D.29', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  30, '30',	'D.30', 10, ''
EXECUTE [dbo].[PG_CI_TIEMPO_DIA_MES] 0, 0,  31, '31',	'D.31', 10, ''
GO


-- ===============================================
SET NOCOUNT OFF
-- ===============================================






-- ===============================================

SET NOCOUNT OFF



-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////

