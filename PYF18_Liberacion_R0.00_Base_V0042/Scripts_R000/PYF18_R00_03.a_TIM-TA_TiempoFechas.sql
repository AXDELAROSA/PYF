-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			SOPORTE - TABLAS DE FECHAS   				
-- // OPERACION:		LIBERACION    
-- //////////////////////////////////////////////////////////////

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FILTRO_YYYY]') AND type in (N'U'))
	DROP TABLE [dbo].[FILTRO_YYYY] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MES]') AND type in (N'U'))
	DROP TABLE [dbo].[MES] 
GO



/****************************************************************/
/*								MES								*/
/****************************************************************/

CREATE TABLE [dbo].[MES] (
	[K_MES]	[INT] NOT NULL,
	[D_MES]	[VARCHAR] (100) NOT NULL,
	[S_MES]	[VARCHAR] (10) NOT NULL,
	[O_MES]	[INT] NOT NULL,
	[C_MES]	[VARCHAR] (255) NOT NULL,
	[L_MES]	[INT] NOT NULL
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[MES]
	ADD CONSTRAINT [PK_MES]
	PRIMARY KEY CLUSTERED (K_MES)
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_MES_01_DESCRIPCION] 
	   ON [dbo].[MES] ( [D_MES] )
GO


ALTER TABLE [dbo].[MES] ADD 
	CONSTRAINT [FK_MES_01] 
		FOREIGN KEY ([L_MES]) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ([K_ESTATUS_ACTIVO])
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_MES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_MES]
GO


CREATE PROCEDURE [dbo].[PG_CI_MES]
	@PP_L_DEBUG			INT,
	@PP_K_SISTEMA_EXE	INT,
	@PP_K_MES			INT,
	@PP_D_MES			VARCHAR(100),
	@PP_S_MES			VARCHAR(10),
	@PP_O_MES			INT,
	@PP_C_MES			VARCHAR(255),
	@PP_L_MES			INT
AS

	INSERT INTO MES
		(	K_MES,			D_MES, 
			S_MES,			O_MES,
			C_MES,
			L_MES			)
	VALUES	
		(	@PP_K_MES,		@PP_D_MES,	
			@PP_S_MES,		@PP_O_MES,
			@PP_C_MES,
			@PP_L_MES		)

	-- ==========================================
GO


-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_MES] 0, 0,  1, 'ENERO',		'ENE', 101, '', 1 
EXECUTE [dbo].[PG_CI_MES] 0, 0,  2, 'FEBRERO',		'FEB', 102, '', 1 
EXECUTE [dbo].[PG_CI_MES] 0, 0,  3, 'MARZO',		'MAR', 103, '', 1 
EXECUTE [dbo].[PG_CI_MES] 0, 0,  4, 'ABRIL',		'ABR', 104, '', 1 
EXECUTE [dbo].[PG_CI_MES] 0, 0,  5, 'MAYO',			'MAY', 105, '', 1 
EXECUTE [dbo].[PG_CI_MES] 0, 0,  6, 'JUNIO',		'JUN', 106, '', 1 
EXECUTE [dbo].[PG_CI_MES] 0, 0,  7, 'JULIO',		'JUL', 107, '', 1 
EXECUTE [dbo].[PG_CI_MES] 0, 0,  8, 'AGOSTO',		'AGO', 108, '', 1 
EXECUTE [dbo].[PG_CI_MES] 0, 0,  9, 'SEPTIEMBRE',	'SEP', 109, '', 1 
EXECUTE [dbo].[PG_CI_MES] 0, 0, 10, 'OCTUBRE',		'OCT', 110, '', 1 
EXECUTE [dbo].[PG_CI_MES] 0, 0, 11, 'NOVIEMBRE',	'NOV', 111, '', 1 
EXECUTE [dbo].[PG_CI_MES] 0, 0, 12, 'DICIEMBRE',	'DIC', 112, '', 1 
GO


-- ===============================================
SET NOCOUNT OFF
-- ===============================================




/****************************************************************/
/*							FILTRO_YYYY							*/
/****************************************************************/

CREATE TABLE [dbo].[FILTRO_YYYY] (
	[K_FILTRO_YYYY]	[INT] NOT NULL,
	[D_FILTRO_YYYY]	[VARCHAR] (100) NOT NULL,
	[S_FILTRO_YYYY]	[VARCHAR] (10) NOT NULL,
	[O_FILTRO_YYYY]	[INT] NOT NULL,
	[C_FILTRO_YYYY]	[VARCHAR] (255) NOT NULL,
	[L_FILTRO_YYYY]	[INT] NOT NULL
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[FILTRO_YYYY]
	ADD CONSTRAINT [PK_FILTRO_YYYY]
	PRIMARY KEY CLUSTERED (K_FILTRO_YYYY)
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_FILTRO_YYYY_01_DESCRIPCION] 
	   ON [dbo].[FILTRO_YYYY] ( [D_FILTRO_YYYY] )
GO


ALTER TABLE [dbo].[FILTRO_YYYY] ADD 
	CONSTRAINT [FK_FILTRO_YYYY_01] 
		FOREIGN KEY ([L_FILTRO_YYYY]) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ([K_ESTATUS_ACTIVO])
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_FILTRO_YYYY]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_FILTRO_YYYY]
GO


CREATE PROCEDURE [dbo].[PG_CI_FILTRO_YYYY]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_FILTRO_YYYY		INT,
	@PP_D_FILTRO_YYYY		VARCHAR(100),
	@PP_S_FILTRO_YYYY		VARCHAR(10),
	@PP_O_FILTRO_YYYY		INT,
	@PP_C_FILTRO_YYYY		VARCHAR(255),
	@PP_L_FILTRO_YYYY		INT
AS

	INSERT INTO FILTRO_YYYY
		(	K_FILTRO_YYYY,			D_FILTRO_YYYY, 
			S_FILTRO_YYYY,			O_FILTRO_YYYY,
			C_FILTRO_YYYY,
			L_FILTRO_YYYY			)
	VALUES	
		(	@PP_K_FILTRO_YYYY,		@PP_D_FILTRO_YYYY,	
			@PP_S_FILTRO_YYYY,		@PP_O_FILTRO_YYYY,
			@PP_C_FILTRO_YYYY,
			@PP_L_FILTRO_YYYY		)

	-- ==========================================
GO



-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1980, '1980',	'', 1980, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1981, '1981',	'', 1981, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1982, '1982',	'', 1982, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1983, '1983',	'', 1983, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1984, '1984',	'', 1984, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1985, '1985',	'', 1985, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1986, '1986',	'', 1986, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1987, '1987',	'', 1987, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1988, '1988',	'', 1988, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1989, '1989',	'', 1989, '', 1 
GO


EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1990, '1990',	'', 1990, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1991, '1991',	'', 1991, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1992, '1992',	'', 1992, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1993, '1993',	'', 1993, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1994, '1994',	'', 1994, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1995, '1995',	'', 1995, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1996, '1996',	'', 1996, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1997, '1997',	'', 1997, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1998, '1998',	'', 1998, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 1999, '1999',	'', 1999, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 2000, '2000',	'', 2000, '', 1 
GO

EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 2001, '2001',	'', 2001, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 2002, '2002',	'', 2002, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 2003, '2003',	'', 2003, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 2004, '2004',	'', 2004, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 2005, '2005',	'', 2005, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 2006, '2006',	'', 2006, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 2007, '2007',	'', 2007, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 2008, '2008',	'', 2008, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]	0, 0, 2009, '2009',	'', 2009, '', 1 
GO

EXECUTE [dbo].[PG_CI_FILTRO_YYYY]  0, 0, 2010, '2010',	'', 2010, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]  0, 0, 2011, '2011',	'', 2011, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]  0, 0, 2012, '2012',	'', 2012, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]  0, 0, 2013, '2013',	'', 2013, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]  0, 0, 2014, '2014',	'', 2014, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]  0, 0, 2015, '2015',	'', 2015, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]  0, 0, 2016, '2016',	'', 2016, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]  0, 0, 2017, '2017',	'', 2017, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]  0, 0, 2018, '2018',	'', 2018, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]  0, 0, 2019, '2019',	'', 2019, '', 1 
EXECUTE [dbo].[PG_CI_FILTRO_YYYY]  0, 0, 2020, '2020',	'', 2020, '', 1 
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================



-- ///////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////
