-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CATALOGOS SISTEMAS
-- // OPERACION:		LIBERACION / TABLA+CARGA 
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERVIDOR]') AND type in (N'U'))
	DROP TABLE [dbo].[SERVIDOR] 
GO


/**************************************************************/
/*		            TABLA: SERVIDORES    		              */
/**************************************************************/


CREATE TABLE [dbo].[SERVIDOR] (
  [K_SERVIDOR]	     	[INT]				NOT NULL, 
  [D_SERVIDOR]		 	[VARCHAR](100)		NOT NULL, 
  [C_SERVIDOR]		 	[VARCHAR](100)		NOT NULL,
  [S_SERVIDOR]			[VARCHAR](10)		NOT NULL,
  [O_SERVIDOR]			[INT]				NOT NULL,
  [L_SERVIDOR]			[INT]				NOT NULL,
  [D_DRIVER]			[VARCHAR](100)		NOT NULL,
  [USUARIO]			 	[VARCHAR](100)		NOT NULL,
  [PASSWORD]		 	[VARCHAR](100)		NOT NULL, 
  [DOMINIO]				[VARCHAR](200)				 DEFAULT '', --esto debido a que algunos serv no tienen de momento dominio
  [K_ESTADO_SERVIDOR]	[INT]				NOT NULL,
  [K_GRUPO_SERVIDOR]	[INT]		
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////

ALTER TABLE [dbo].[SERVIDOR]
	ADD CONSTRAINT [PK_SERVIDOR]
		PRIMARY KEY ([K_SERVIDOR])
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[SERVIDOR] ADD 
	CONSTRAINT [FK_SERVIDOR_01]  
		FOREIGN KEY ( [K_ESTADO_SERVIDOR] ) 
		REFERENCES [dbo].[ESTADO_SERVIDOR] ( [K_ESTADO_SERVIDOR] ),
	CONSTRAINT [FK_SERVIDOR_02]  
		FOREIGN KEY ( [K_GRUPO_SERVIDOR] ) 
		REFERENCES [dbo].[GRUPO_SERVIDOR] ( [K_GRUPO_SERVIDOR] )
GO



-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[SERVIDOR] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[SERVIDOR] ADD 
	CONSTRAINT [FK_SERVIDOR_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_SERVIDOR_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_SERVIDOR_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --> [PG_CI_SERVIDOR]
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_SERVIDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_SERVIDOR]
GO


CREATE PROCEDURE [dbo].[PG_CI_SERVIDOR]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_SERVIDOR		    INT,
	@PP_D_SERVIDOR			VARCHAR (100),
	@PP_C_SERVIDOR			VARCHAR	(100),
	@PP_S_SERVIDOR			VARCHAR (10),
	@PP_O_SERVIDOR			INT,
	@PP_L_SERVIDOR			INT,
	@PP_D_DRIVER			VARCHAR (100),
	@PP_USUARIO				VARCHAR (100),
	@PP_PASSWORD			VARCHAR (100),
	@PP_DOMINIO				VARCHAR(100),
	@PP_K_ESTADO_SERVIDOR	INT,
	@PP_K_GRUPO_SERVIDOR	INT

AS

	INSERT INTO SERVIDOR
		(	
			[K_SERVIDOR],			[D_SERVIDOR], 
			[C_SERVIDOR],			[S_SERVIDOR],
			[O_SERVIDOR],			[L_SERVIDOR],
			[D_DRIVER],				[USUARIO],
			[PASSWORD],				[DOMINIO],
			[K_ESTADO_SERVIDOR],	[K_GRUPO_SERVIDOR],
			-- ===========================
			[K_USUARIO_ALTA],	[F_ALTA],
			[K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], 
			[K_USUARIO_BAJA],	[F_BAJA]
		)	
	VALUES	
		(	 
			@PP_K_SERVIDOR,			@PP_D_SERVIDOR, 
			@PP_C_SERVIDOR,			@PP_S_SERVIDOR,
			@PP_O_SERVIDOR,			@PP_L_SERVIDOR,
			@PP_D_DRIVER,			@PP_USUARIO,
			@PP_PASSWORD,			@PP_DOMINIO,
			@PP_K_ESTADO_SERVIDOR,	@PP_K_GRUPO_SERVIDOR,
			-- ===========================
			@PP_K_USUARIO_ACCION, GETDATE(),
			@PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL
		)

	-- ////////////////////////////////////////////////
GO
		





-- /////////////////////////////////////////////////////////////////////
-- CRAGA INICIAL SERVIDORES
-- /////////////////////////////////////////////////////////////////////


-- ===============================================
SET NOCOUNT ON
-- ===============================================




EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 0, 'PENDIENTE', 'PENDIENTE', 'PEN' , 0, 1, 'SERVIDOR PENDIENTE' , '', '', '', 0, 0
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 1, 'CHIHUAHUA', 'CHIHUAHUA', 'CHIH' , 10, 1, 'SERVIDOR CHIHUAHUA' , 'accesoJRZ', 'fXe98', 'tomzachihuahua.grupotomza.net', 1, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 2, 'CASASGRANDES', 'CASASGRANDES', 'CSG' , 20, 1, 'SERVIDOR CASASGRANDES' , 'accesoJRZ', 'fXe98', 'tomzancg.grupotomza.net', 1, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 3, 'BIOGAS', 'BIOGAS', 'BIO' , 30, 1, 'SERVIDOR BIOGAS' , 'accesoJRZ', 'fXe98', 'tomzabiogas.grupotomza.net', 1, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 4, 'UNIGAS', 'UNIGAS', '' , 40, 1, 'SERVIDOR UNIGAS' , 'accesoJRZ', 'fXe98', 'Unigasmatriz.grupotomza.net', 1, 70
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 5, 'ICSVENTA2', 'ICSVENTA2', 'VTA2' , 50, 1, 'SERVIDOR ICSVENTA2' , 'accesoJRZ', 'fXe98', '148.244.65.69', 1, 70
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 6, 'CHAPULTEPEC', 'CHAPULTEPEC', 'CHAP' , 60, 1, 'SERVIDOR CHAPULTEPEC' , 'accesoJRZ', 'fXe98', 'tomzagaschapultepec.grupotomza.net', 1, 70
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 7, 'GASYPETROLEOS', 'GASYPETROLEOS', 'GYP' , 70, 1, 'SERVIDOR GASYPETROLEOS' , 'accesoJRZ', 'fXe98', 'portal.gasypetroleos.com', 1, 0
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 8, 'GASYSERVICIO', 'GASYSERVICIO', 'GYS' , 80, 1, 'SERVIDOR GASYSERVICIO' , 'accesoJRZ', 'fXe98', 'tomzagys.grupotomza.net', 4, 70
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 9, 'ACAPULCO', 'ACAPULCO', 'ACA' , 90, 1, 'SERVIDOR ACAPULCO' , 'accesoJRZ', 'fXe98', 'tomzaacapulco.grupotomza.net', 1, 20
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 10, 'TOLUCA', 'TOLUCA', 'TOL' , 100, 1, 'SERVIDOR TOLUCA' , 'accesoJRZ', 'fXe98', 'unigastoluca.grupotomza.net', 1, 20
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 11, 'GASOMATICO', 'GASOMATICO', 'GASO' , 110, 1, 'SERVIDOR GASOMATICO' , 'accesoJRZ', 'fXe98', 'tomzagasomatico.grupotomza.net', 1, 70
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 12, 'TEHUACAN', 'TEHUACAN', 'TEHU' , 120, 1, 'SERVIDOR TEHUACAN' , 'accesoJRZ', 'fXe98', 'tomzaciamextehuacan.grupotomza.net', 1, 20
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 13, 'TOMZAMEXICANA', 'TOMZAMEXICANA', 'TMEX' , 130, 1, 'SERVIDOR TOMZAMEXICANA' , 'accesoJRZ', 'fXe98', 'tomzaciamextlahuac.grupotomza.net', 1, 70
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 14, 'TLAHUAC', 'TLAHUAC', 'TLA' , 140, 1, 'SERVIDOR TLAHUAC' , 'accesoJRZ', 'fXe98', 'unigastlahuac.grupotomza.net', 1, 70
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 15, 'AGUAPRIETA', 'AGUAPRIETA', 'AGUAPR' , 150, 1, 'SERVIDOR AGUAPRIETA' , 'accesoJRZ', 'fXe98', 'tomzaaguaprieta.grupotomza.net', 1, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 16, 'AGUASCALIENTES', 'AGUASCALIENTES', 'AGS' , 160, 1, 'SERVIDOR AGUASCALIENTES' , 'accesoJRZ', 'fXe98', 'tomzatepa.grupotomza.net', 0, 40
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 17, 'ASCENSION', 'ASCENSION', 'ASCE' , 170, 1, 'SERVIDOR ASCENSION' , 'accesoJRZ', 'fXe98', 'tomzabiogas.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 18, 'AUTLAN', 'AUTLAN', 'ATLAN' , 180, 1, 'SERVIDOR AUTLAN' , 'accesoJRZ', 'fXe98', 'tomzaguzman.grupotomza.net', 0, 40
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 19, 'BENITOJUAREZ', 'BENITOJUAREZ', 'BJUA' , 190, 1, 'SERVIDOR BENITOJUAREZ' , 'accesoJRZ', 'fXe98', 'tomzancg.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 20, 'BUENAVENTURA', 'BUENAVENTURA', 'BVENT' , 200, 1, 'SERVIDOR BUENAVENTURA' , 'accesoJRZ', 'fXe98', '', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 21, 'CABORCA', 'CABORCA', 'CAB' , 210, 1, 'SERVIDOR CABORCA' , 'accesoJRZ', 'fXe98', 'tomzacaborca.grupotomza.net', 1, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 22, 'CAMARGO', 'CAMARGO', 'CMG' , 220, 1, 'SERVIDOR CAMARGO' , 'accesoJRZ', 'fXe98', 'tomzachihuahua.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 23, 'CAMPECHE', 'CAMPECHE', 'CPCHE' , 230, 1, 'SERVIDOR CAMPECHE' , 'accesoJRZ', 'fXe98', 'tomzacampeche.grupotomza.net', 1, 60
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 24, 'CANANEA', 'CANANEA', 'CAN' , 240, 1, 'SERVIDOR CANANEA' , 'accesoJRZ', 'fXe98', 'tomzacananea.grupotomza.net', 1, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 25, 'CANCUN', 'CANCUN', 'CNCUN' , 250, 1, 'SERVIDOR CANCUN' , 'accesoJRZ', 'fXe98', 'tomzacancun.grupotomza.net', 1, 60
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 26, 'CDDELCARMEN', 'CDDELCARMEN', 'CDCR' , 260, 1, 'SERVIDOR CDDELCARMEN' , 'accesoJRZ', 'fXe98', 'tomzaciudaddelcarmen.grupotomza.net', 1, 60
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 27, 'CDGUZMAN', 'CDGUZMAN', 'CGMA' , 270, 1, 'SERVIDOR CDGUZMAN' , 'accesoJRZ', 'fXe98', 'tomzaguzman.grupotomza.net', 1, 40
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 28, 'CHETUMAL', 'CHETUMAL', 'CHTMA' , 280, 1, 'SERVIDOR CHETUMAL' , 'accesoJRZ', 'fXe98', 'tomzachetumal.grupotomza.net', 1, 60
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 29, 'COZUMEL', 'COZUMEL', 'CZMEL' , 290, 1, 'SERVIDOR COZUMEL' , 'accesoJRZ', 'fXe98', 'tomzacozumel.grupotomza.net', 1, 60
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 30, 'CUAUHTEMOC', 'CUAUHTEMOC', 'CUAUH' , 300, 1, 'SERVIDOR CUAUHTEMOC' , 'accesoJRZ', 'fXe98', 'tomzachihuahua.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 31, 'CULIACAN', 'CULIACAN', 'CULIACAN' , 310, 1, 'SERVIDOR CULIACAN' , 'accesoJRZ', 'fXe98', 'tomzaculiacan.grupotomza.net', 1, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 32, 'DELICIAS', 'DELICIAS', 'DLCI' , 320, 1, 'SERVIDOR DELICIAS' , 'accesoJRZ', 'fXe98', 'tomzachihuahua.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 33, 'ENSENADA', 'ENSENADA', 'ENS' , 330, 1, 'SERVIDOR ENSENADA' , 'accesoJRZ', 'fXe98', 'tomzaensenada.grupotomza.net', 1, 10
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 34, 'FLORESMAGON', 'FLORESMAGON', 'FMAG' , 340, 1, 'SERVIDOR FLORESMAGON' , 'accesoJRZ', 'fXe98', 'tomzancg.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 35, 'FUNDICION', 'FUNDICION', 'FUND' , 350, 1, 'SERVIDOR FUNDICION' , 'accesoJRZ', 'fXe98', 'tomzanacozari.grupotomza.net', 0, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 36, 'GASPRONTO', 'GASPRONTO', 'GPNTO' , 360, 1, 'SERVIDOR GASPRONTO' , 'accesoJRZ', 'fXe98', 'tomzagaspronto.grupotomza.net', 4, 20
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 37, 'GASURIBE', 'GASURIBE', 'GUBE' , 370, 1, 'SERVIDOR GASURIBE' , 'accesoJRZ', 'fXe98', 'tomzaacapulco.grupotomza.net', 0, 20
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 38, 'GTM-TEPEJI', 'GTM-TEPEJI', 'GTM-TEPEJI' , 380, 1, 'SERVIDOR GTM-TEPEJI' , 'accesoJRZ', 'fXe98', 'tomzatepeji.grupotomza.net', 0, 20
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 39, 'GUADALAJARA', 'GUADALAJARA', 'GDL' , 390, 1, 'SERVIDOR GUADALAJARA' , 'accesoJRZ', 'fXe98', 'tomzagdl.grupotomza.net', 1, 40
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 40, 'GUADALUPE', 'GUADALUPE', 'GUAD' , 400, 1, 'SERVIDOR GUADALUPE' , 'accesoJRZ', 'fXe98', 'tomzabiogas.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 41, 'GUANAJUATO', 'GUANAJUATO', 'GJTO' , 410, 1, 'SERVIDOR GUANAJUATO' , 'accesoJRZ', 'fXe98', 'tomzaleon.grupotomza.net', 1, 40
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 42, 'GUAYMAS', 'GUAYMAS', 'GUAY' , 420, 1, 'SERVIDOR GUAYMAS' , 'accesoJRZ', 'fXe98', 'tomzaguaymas.grupotomza.net', 0, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 43, 'HERMOSILLO', 'HERMOSILLO', 'HER' , 430, 1, 'SERVIDOR HERMOSILLO' , 'accesoJRZ', 'fXe98', 'tomzahermosillo.grupotomza.net', 1, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 44, 'HIDALGO', 'HIDALGO', 'HDGO' , 440, 1, 'SERVIDOR HIDALGO' , 'accesoJRZ', 'fXe98', 'terminalgtm.grupotomza.net', 0, 0
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 45, 'HIDROI', 'HIDROI', 'HIDRO I' , 450, 1, 'SERVIDOR HIDROI' , 'accesoJRZ', 'fXe98', 'tomzachihuahua.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 46, 'HIDROII', 'HIDROII', 'HIDRO II' , 460, 1, 'SERVIDOR HIDROII' , 'accesoJRZ', 'fXe98', 'tomzachihuahua.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 47, 'LALAJA', 'LALAJA', 'LLJA' , 470, 1, 'SERVIDOR LALAJA' , 'accesoJRZ', 'fXe98', 'tomzagdl.grupotomza.net', 0, 40
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 48, 'LASSIERRA', 'LASSIERRA', 'LSIER' , 480, 1, 'SERVIDOR LASSIERRA' , 'accesoJRZ', 'fXe98', 'tomzancg.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 49, 'MAMEMEGAS', 'MAMEMEGAS', 'MGAS' , 490, 1, 'SERVIDOR MAMEMEGAS' , 'accesoJRZ', 'fXe98', 'tomzamameme.grupotomza.net', 1, 40
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 50, 'MARKETING', 'MARKETING', 'MKT' , 500, 1, 'SERVIDOR MARKETING' , 'accesoJRZ', 'fXe98', '', 0, 0
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 51, 'MATRIZ', 'MATRIZ', 'MAT' , 510, 1, 'SERVIDOR MATRIZ' , 'accesoJRZ', 'fXe98', 'tomzancg.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 52, 'MERIDA', 'MERIDA', 'MRDA' , 520, 1, 'SERVIDOR MERIDA' , 'accesoJRZ', 'fXe98', 'tomzamerida.grupotomza.net', 1, 60
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 53, 'MEXICALI', 'MEXICALI', 'MEXI' , 530, 1, 'SERVIDOR MEXICALI' , 'accesoJRZ', 'fXe98', 'tomzamexicali.grupotomza.net', 1, 10
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 54, 'MINATITLAN', 'MINATITLAN', 'MNTLAN' , 540, 1, 'SERVIDOR MINATITLAN' , 'accesoJRZ', 'fXe98', 'tomzaminatitlan.grupotomza.net', 1, 60
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 55, 'MOCHIS', 'MOCHIS', 'MOCHIS' , 550, 1, 'SERVIDOR MOCHIS' , 'accesoJRZ', 'fXe98', 'tomzamochis.grupotomza.net', 1, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 56, 'MORELOS', 'MORELOS', 'MOR' , 560, 1, 'SERVIDOR MORELOS' , 'accesoJRZ', 'fXe98', 'tomzamorelos.grupotomza.net', 1, 20
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 57, 'NACO', 'NACO', 'NACO' , 570, 1, 'SERVIDOR NACO' , 'accesoJRZ', 'fXe98', 'tomzanaco.grupotomza.net', 1, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 58, 'NACOZARI', 'NACOZARI', 'NACOZ' , 580, 1, 'SERVIDOR NACOZARI' , 'accesoJRZ', 'fXe98', 'tomzanacozari.grupotomza.net', 1, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 59, 'NAVOJOA', 'NAVOJOA', 'NAVO' , 590, 1, 'SERVIDOR NAVOJOA' , 'accesoJRZ', 'fXe98', 'tomzanavojoa.grupotomza.net', 0, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 60, 'NOGALES', 'NOGALES', 'NOG' , 600, 1, 'SERVIDOR NOGALES' , 'accesoJRZ', 'fXe98', 'tomzanogales.grupotomza.net', 1, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 61, 'OBREGON', 'OBREGON', 'OBRE' , 610, 1, 'SERVIDOR OBREGON' , 'accesoJRZ', 'fXe98', 'tomzaobregon.grupotomza.net', 1, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 62, 'OCOTLAN', 'OCOTLAN', 'OCTAN' , 620, 1, 'SERVIDOR OCOTLAN' , 'accesoJRZ', 'fXe98', 'tomzaocotlan.grupotomza.net', 1, 40
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 63, 'OJINAGA', 'OJINAGA', 'OJNA' , 630, 1, 'SERVIDOR OJINAGA' , 'accesoJRZ', 'fXe98', 'tomzachihuahua.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 64, 'PALOMAS', 'PALOMAS', 'PALM' , 640, 1, 'SERVIDOR PALOMAS' , 'accesoJRZ', 'fXe98', 'tomzancg.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 65, 'PARRAL', 'PARRAL', 'PARRAL' , 650, 1, 'SERVIDOR PARRAL' , 'accesoJRZ', 'fXe98', 'tomzachihuahua.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 66, 'PEPSICO', 'PEPSICO', 'PEP' , 660, 1, 'SERVIDOR PEPSICO' , 'accesoJRZ', 'fXe98', 'tomzaobregon.grupotomza.net', 0, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 67, 'PLAYADELCARMEN', 'PLAYADELCARMEN', 'PCAME' , 670, 1, 'SERVIDOR PLAYADELCARMEN' , 'accesoJRZ', 'fXe98', 'tomzaplayadelcarmen.grupotomza.net', 1, 60
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 68, 'PROGRESO', 'PROGRESO', 'PGSO' , 680, 1, 'SERVIDOR PROGRESO' , 'accesoJRZ', 'fXe98', 'tomzaprogreso.grupotomza.net', 0, 60
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 69, 'PUEBLO', 'PUEBLO', 'PUEB' , 690, 1, 'SERVIDOR PUEBLO' , 'accesoJRZ', 'fXe98', 'tomzancg.grupotomza.net', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 70, 'PUERTOPENASCO', 'PUERTOPENASCO', 'PPEÑASCO' , 700, 1, 'SERVIDOR PUERTOPENASCO' , 'accesoJRZ', 'fXe98', 'tomzapenasco.grupotomza.net', 1, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 71, 'QUERETARO', 'QUERETARO', 'QRTRO' , 710, 1, 'SERVIDOR QUERETARO' , 'accesoJRZ', 'fXe98', 'tomzaqueretaro.grupotomza.net', 1, 20
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 72, 'SANLUISPOTOSI', 'SANLUISPOTOSI', 'SLPTS' , 720, 1, 'SERVIDOR SANLUISPOTOSI' , 'accesoJRZ', 'fXe98', 'tomzaslp.grupotomza.net', 1, 20
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 73, 'SANLUISRIOCOLORADO', 'SANLUISRIOCOLORADO', 'SLRC' , 730, 1, 'SERVIDOR SANLUISRIOCOLORADO' , 'accesoJRZ', 'fXe98', 'tomzaslrc.grupotomza.net', 0, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 74, 'SANQUINTIN', 'SANQUINTIN', 'SQTIN' , 740, 1, 'SERVIDOR SANQUINTIN' , 'accesoJRZ', 'fXe98', 'tomzasanquintin.grupotomza.net', 1, 10
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 75, 'SANTAANA', 'SANTAANA', 'SANTA ANA' , 750, 1, 'SERVIDOR SANTAANA' , 'accesoJRZ', 'fXe98', 'tomzasantaana.grupotomza.net', 1, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 76, 'TEPATITLAN', 'TEPATITLAN', 'TPLA' , 760, 1, 'SERVIDOR TEPATITLAN' , 'accesoJRZ', 'fXe98', 'tomzatepa.grupotomza.net', 1, 40
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 77, 'TERMINALJUAREZ', 'TERMINALJUAREZ', '' , 770, 1, 'SERVIDOR TERMINALJUAREZ' , 'accesoJRZ', 'fXe98', '', 0, 30
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 78, 'TESISTAN', 'TESISTAN', 'TESISTAN' , 780, 1, 'SERVIDOR TESISTAN' , 'accesoJRZ', 'fXe98', 'tomzamameme.grupotomza.net', 0, 40
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 79, 'TICUL', 'TICUL', 'TICUL' , 790, 1, 'SERVIDOR TICUL' , 'accesoJRZ', 'fXe98', 'tomzaticul.grupotomza.net', 1, 60
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 80, 'TIJUANA', 'TIJUANA', 'TIJ' , 800, 1, 'SERVIDOR TIJUANA' , 'accesoJRZ', 'fXe98', 'tomzatijuana.grupotomza.net', 1, 10
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 81, 'TLAJOMULCO', 'TLAJOMULCO', 'TJCO' , 810, 1, 'SERVIDOR TLAJOMULCO' , 'accesoJRZ', 'fXe98', '', 0, 40
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 82, 'URES', 'URES', 'URES' , 820, 1, 'SERVIDOR URES' , 'accesoJRZ', 'fXe98', 'tomzaures.grupotomza.net', 0, 50
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 83, 'VERACRUZ', 'VERACRUZ', 'VRCUZ' , 830, 1, 'SERVIDOR VERACRUZ' , 'accesoJRZ', 'fXe98', 'tomzaminatitlan.grupotomza.net', 0, 60
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 84, 'YAHUALICA', 'YAHUALICA', 'YHCA' , 840, 1, 'SERVIDOR YAHUALICA' , 'accesoJRZ', 'fXe98', 'tomzayahualica.grupotomza.net', 1, 40
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 85, 'ZAPOPAN', 'ZAPOPAN', 'ZPNA' , 850, 1, 'SERVIDOR ZAPOPAN' , 'accesoJRZ', 'fXe98', 'tomzagdl.grupotomza.net', 0, 40
EXECUTE [dbo].[PG_CI_SERVIDOR]  0, 0, 0, 86, 'BRUNO', 'BRUNO', 'BRUNO' , 860, 1, 'SERVIDOR BRUNO' , 'accesoJRZ', 'fXe98', '10.0.5.34', 0, 30



GO


-- ===============================================
SET NOCOUNT OFF
-- ===============================================



-- /////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////
