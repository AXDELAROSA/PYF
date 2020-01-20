-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			GEOGRAFIA
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////
/*

SELECT	PAIS.K_PAIS,		D_PAIS, 
		ESTADO.K_ESTADO,	D_ESTADO
FROM	PAIS, ESTADO
WHERE	PAIS.K_PAIS=ESTADO.K_PAIS


SELECT	PAIS.K_PAIS, D_PAIS, 
		ESTADO.K_ESTADO, D_ESTADO,
		REGION.K_REGION,   D_REGION
FROM	PAIS, ESTADO,
		REGION
WHERE	PAIS.K_PAIS=ESTADO.K_PAIS
AND		ESTADO.K_ESTADO=REGION.K_ESTADO


*/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[REGION]') AND type in (N'U'))
	DROP TABLE [dbo].[REGION]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTADO]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTADO]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PAIS]') AND type in (N'U'))
	DROP TABLE [dbo].[PAIS]
GO






-- //////////////////////////////////////////////////////////////
-- //						PAIS
-- //////////////////////////////////////////////////////////////
-- SELECT * FROM PAIS

CREATE TABLE [dbo].[PAIS] (
	[K_PAIS]	[INT] NOT NULL,
	[D_PAIS]	[VARCHAR] (100) NOT NULL,
	[S_PAIS]	[VARCHAR] (10) NOT NULL,
	[O_PAIS]	[INT] NOT NULL,
	[C_PAIS]	[VARCHAR] (255) NOT NULL,
	[L_PAIS]	[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[PAIS]
	ADD CONSTRAINT [PK_PAIS]
		PRIMARY KEY CLUSTERED ([K_PAIS])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_PAIS_01_DESCRIPCION] 
	   ON [dbo].[PAIS] ( [D_PAIS] )
GO


ALTER TABLE [dbo].[PAIS] ADD 
	CONSTRAINT [FK_PAIS_01] 
		FOREIGN KEY ( [L_PAIS] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PAIS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PAIS]
GO


CREATE PROCEDURE [dbo].[PG_CI_PAIS]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	-- ========================================
	@PP_K_PAIS		INT,
	@PP_D_PAIS		VARCHAR(100),
	@PP_S_PAIS		VARCHAR(10),
	@PP_O_PAIS		INT,
	@PP_C_PAIS		VARCHAR(255),
	@PP_L_PAIS		INT
AS
	
	INSERT INTO PAIS
		(	K_PAIS,			D_PAIS, 
			S_PAIS,			O_PAIS,
			C_PAIS,
			L_PAIS			)		
	VALUES	
		(	@PP_K_PAIS,		@PP_D_PAIS,	
			@PP_S_PAIS,		@PP_O_PAIS,
			@PP_C_PAIS,
			@PP_L_PAIS		)

	-- =========================================================
GO



-- CI_PAIS
EXECUTE [dbo].[PG_CI_PAIS] 0, 0, 0, '( PENDIENTE )',	'???', 10, '', 1
EXECUTE [dbo].[PG_CI_PAIS] 0, 0, 1, 'MEXICO',			'MX', 10, '', 1
EXECUTE [dbo].[PG_CI_PAIS] 0, 0, 2, 'ESTADOS UNIDOS',	'USA', 20, '', 1
EXECUTE [dbo].[PG_CI_PAIS] 0, 0, 3, 'AGREGAR CA',		'CA', 30, '', 1
/*
EXECUTE [dbo].[PG_CI_PAIS] 0, 0, 4, 'MANTENIMIENTO', 'MANTENIMIENTO', 40, '', 1
EXECUTE [dbo].[PG_CI_PAIS] 0, 0, 5, 'GASTOS GENERALES', 'GASTOS GENERALES', 50, '', 1
EXECUTE [dbo].[PG_CI_PAIS] 0, 0, 6, 'IMPUESTOS', 'IMPUESTOS', 60, '', 1
EXECUTE [dbo].[PG_CI_PAIS] 0, 0, 7, 'GASTOS TOTALES', 'GASTOS TOTALES', 70, '', 1
*/
GO



-- //////////////////////////////////////////////////////////////
-- //						ESTADO
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ESTADO] (
	[K_ESTADO]	[INT] NOT NULL,
	[D_ESTADO]	[VARCHAR] (100) NOT NULL,
	[S_ESTADO]	[VARCHAR] (10) NOT NULL,
	[O_ESTADO]	[INT] NOT NULL,
	[C_ESTADO]	[VARCHAR] (255) NOT NULL,
	[L_ESTADO]	[INT] NOT NULL,
	[K_PAIS]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[ESTADO]
	ADD CONSTRAINT [PK_ESTADO]
		PRIMARY KEY CLUSTERED ([K_ESTADO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTADO_01_DESCRIPCION] 
	   ON [dbo].[ESTADO] ( [D_ESTADO] )
GO


ALTER TABLE [dbo].[ESTADO] ADD 
	CONSTRAINT [FK_ESTADO_01] 
		FOREIGN KEY ( [L_ESTADO] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] ),
	CONSTRAINT [FK_ESTADO_02] 
		FOREIGN KEY ( [K_PAIS] ) 
		REFERENCES [dbo].[PAIS] ( [K_PAIS] )
GO



-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTADO]
GO


CREATE PROCEDURE [dbo].[PG_CI_ESTADO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	-- ========================================
	@PP_K_ESTADO			INT,
	@PP_D_ESTADO			VARCHAR(100),
	@PP_S_ESTADO			VARCHAR(10),
	@PP_O_ESTADO			INT,
	@PP_C_ESTADO			VARCHAR(255),
	@PP_L_ESTADO			INT,
	@PP_K_PAIS			INT		
AS

	INSERT INTO ESTADO
		(	K_ESTADO,				D_ESTADO, 
			S_ESTADO,				O_ESTADO,
			C_ESTADO,
			L_ESTADO,
			K_PAIS					)
	VALUES		
		(	@PP_K_ESTADO,			@PP_D_ESTADO,	
			@PP_S_ESTADO,			@PP_O_ESTADO,
			@PP_C_ESTADO,
			@PP_L_ESTADO,
			@PP_K_PAIS				)

	-- =========================================================
GO



-- // CI_ESTADO

EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 000, '( PENDIENTE )',	'???',   1010, '', 1, 0
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 101, 'BAJA CALIFORNIA',	'BAJAC', 1010, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 102, 'SONORA',			'SONRA', 1020, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 103, 'CHIHUAHUA',		'CHIHU', 1030, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 104, 'JALISCO',			'JALSC', 1040, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 105, 'CDMX',				'CDMEX', 1050, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 106, 'EDOMX',			'EDOMX', 1060, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 107, 'PUEBLA',			'PUBLA', 1070, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 108, 'YUCATAN',			'YUCTN', 1080, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 109, 'QUINTANA ROO',		'QUROO', 1090, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 110, 'SINALOA',			'SINLA', 1090, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 111, 'GUANAJUATO',		'GUANA', 1090, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 112, 'VERACRUZ',			'VERAC', 1090, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 113, 'AGUSCALIENTES',	'AGSCA', 1090, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 114, 'SAN LUIS POTOSI',	'SANLP', 1090, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 115, 'QUERETARO',		'QUERE', 1090, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 116, 'HIDALGO',			'HIDAL', 1090, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 117, 'GUERRERO',			'GUERR', 1090, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 118, 'MORELOS',			'MOREL', 1090, '', 1, 1
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 119, 'CAMPECHE',			'CMPCH', 1090, '', 1, 1

EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 201, 'CALIFORNIA',		'CALIF', 1010, '', 1, 2
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 202, 'TEXAS',			'TEXAS', 1020, '', 1, 2

EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 301, 'CENTRO 1',			'CENT1', 1010, '', 1, 3
EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 302, 'CENTRO 2',			'CENT2', 1020, '', 1, 3
GO




-- //////////////////////////////////////////////////////////////
-- //						REGION
-- //////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[REGION] (
	[K_REGION]	[INT] NOT NULL,
	[D_REGION]	[VARCHAR] (100) NOT NULL,
	[S_REGION]	[VARCHAR] (10) NOT NULL,
	[O_REGION]	[INT] NOT NULL,
	[C_REGION]	[VARCHAR] (255) NOT NULL,
	[L_REGION]	[INT] NOT NULL,
	[K_ESTADO]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[REGION]
	ADD CONSTRAINT [PK_REGION]
		PRIMARY KEY CLUSTERED ([K_REGION])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_REGION_01_DESCRIPCION] 
	   ON [dbo].[REGION] ( [D_REGION] )
GO


ALTER TABLE [dbo].[REGION] ADD 
	CONSTRAINT [FK_REGION_01] 
		FOREIGN KEY ( [L_REGION] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] ),
	CONSTRAINT [FK_REGION_02] 
		FOREIGN KEY ( [K_ESTADO] ) 
		REFERENCES [dbo].[ESTADO] ( [K_ESTADO] )
GO



-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_REGION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_REGION]
GO


CREATE PROCEDURE [dbo].[PG_CI_REGION]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	-- ========================================
	@PP_K_REGION			INT,
	@PP_D_REGION			VARCHAR(100),
	@PP_S_REGION			VARCHAR(10),
	@PP_O_REGION			INT,
	@PP_C_REGION			VARCHAR(255),
	@PP_L_REGION			INT,
	@PP_K_ESTADO			INT		
AS

	INSERT INTO REGION
		(	K_REGION,				D_REGION, 
			S_REGION,				O_REGION,
			C_REGION,
			L_REGION,
			K_ESTADO				)
	VALUES	
		(	@PP_K_REGION,			@PP_D_REGION,	
			@PP_S_REGION,			@PP_O_REGION,
			@PP_C_REGION,
			@PP_L_REGION,
			@PP_K_ESTADO			)

	-- =========================================================
GO



-- SELECT * FROM PAIS
-- SELECT * FROM ESTADO
-- SELECT * FROM REGION


-- CI_REGION
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 000, '( PENDIENTE )',		'???',   1010, '', 1, 0
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 0000, '( PENDIENTE )',		'?????', 10020, '', 1, 000
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 101, 'BAJA CALIFORNIA',	'BAJAC', 1010, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1010, 'BAJA CALIFORNIA',		'BJA',   10020, '', 1, 102
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 102, 'SONORA',			'SONRA', 1020, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1021, 'SONORA / NORTE',		'SON.NO', 10020, '', 1, 102
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1022, 'SONORA / CENTRO',		'SON.CE', 10020, '', 1, 102
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1023, 'SONORA / SUR',		'SON.SU', 10020, '', 1, 102
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 103, 'CHIHUAHUA',		'CHIHU', 1030, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1030, 'CHIHUAHUA',			'CHI', 10020, '', 1, 103
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 104, 'JALISCO',			'JALSC', 1040, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1041, 'JALISCO / NORTE',		'JAL.NO', 10020, '', 1, 104
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1042, 'JALISCO / CENTRO',	'JAL.CE', 10020, '', 1, 104
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1043, 'JALISCO / SUR',		'JAL.SU', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 105, 'CDMX',				'CDMEX', 1050, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1050, 'CDMX',				'CDMX', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 106, 'EDOMX',			'EDOMX', 1060, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1060, 'EDOMX',				'EDOMX', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 107, 'PUEBLA',			'PUBLA', 1070, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1070, 'PUEBLA',				'PUEBL', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 108, 'YUCATAN',			'YUCTN', 1080, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1080, 'YUCATAN',				'YUCAT', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 109, 'QUINTANA ROO',		'QUROO', 1090, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1090, 'QUINTANA ROO',		'QUROO', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 110, 'SINALOA',			'SINLA', 1090, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1100, 'SINALOA',				'SINAL', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 111, 'GUANAJUATO',		'GUANA', 1090, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1110, 'GUANAJUATO',			'GUANA', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 112, 'VERACRUZ',			'VERAC', 1090, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1120, 'VERACRUZ',			'VERAC', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 113, 'AGUSCALIENTES',	'AGSCA', 1090, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1130, 'AGUASCALIENTES',		'AGUAS', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 114, 'SAN LUIS POTOSI',	'SANLP', 1090, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1140, 'SAN LUIS POTOSI',		'SANLP', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 115, 'QUERETARO',		'QUERE', 1090, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1150, 'QUERETARO',			'QUERE', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 116, 'HIDALGO',			'HIDAL', 1090, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1160, 'HIDALGO',				'HIDLG', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 117, 'GUERRERO',			'GUERR', 1090, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1170, 'GUERREO',				'GUERR', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 118, 'MORELOS',			'MOREL', 1090, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1180, 'MORELOS',				'MORLS', 10020, '', 1, 104
-- EXECUTE [dbo].[PG_CI_ESTADO] 0, 0, 119, 'CAMPECHE',			'CMPCH', 1090, '', 1, 1
	EXECUTE [dbo].[PG_CI_REGION] 0, 0, 1190, 'CAMPECHE',			'CAMPE', 10020, '', 1, 104




GO





-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
