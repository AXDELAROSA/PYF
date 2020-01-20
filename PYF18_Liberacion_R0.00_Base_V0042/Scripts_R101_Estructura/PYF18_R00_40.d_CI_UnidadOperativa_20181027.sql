-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas 
-- // MODULO:			UNIDAD OPERATIVA
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////

DELETE 
FROM	[UNIDAD_OPERATIVA]
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE -->	CI - CARGA INICIAL
-- //////////////////////////////////////////////////////////////
-- SELECT * FROM UNIDAD_OPERATIVA

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_UNIDAD_OPERATIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_UNIDAD_OPERATIVA]
GO


CREATE PROCEDURE [dbo].[PG_CI_UNIDAD_OPERATIVA]
	@PP_L_DEBUG             INT,					
	@PP_K_SISTEMA_EXE       INT,
	@PP_K_UNIDAD_OPERATIVA  INT,                
	@PP_D_UNIDAD_OPERATIVA  VARCHAR(100),	
	@PP_C_UNIDAD_OPERATIVA  VARCHAR(500),	
	@PP_S_UNIDAD_OPERATIVA  VARCHAR(10),	
	@PP_O_UNIDAD_OPERATIVA  INT,			
	@PP_L_UNIDAD_OPERATIVA  INT,			
	@PP_K_TIPO_UO			INT,			
	@PP_K_ZONA_UO			INT,			
	@PP_ICS_sucursalId		INT,			
	@PP_K_SERVIDOR			INT,			
	@PP_K_RAZON_SOCIAL		INT,			
	@PP_K_REGION			INT,			
	@PP_PERMISO_CRE			VARCHAR(100),
	@PP_TELEFONO			VARCHAR(20),
	@PP_CALLE				VARCHAR(100),
	@PP_NUMERO_EXTERIOR		VARCHAR(10),
	@PP_NUMERO_INTERIOR		VARCHAR(10)	,			
	@PP_COLONIA				VARCHAR(100),				
	@PP_POBLACION			VARCHAR(100),				
	@PP_CP					VARCHAR(10),				
	@PP_MUNICIPIO			VARCHAR(100)
		
AS

-- K_USUARIO // 0	SYS/SETUP
	DECLARE @VP_K_USUARIO_ACCION		INT = 0 

	INSERT INTO UNIDAD_OPERATIVA
		(	K_UNIDAD_OPERATIVA,		D_UNIDAD_OPERATIVA, 
			C_UNIDAD_OPERATIVA,		S_UNIDAD_OPERATIVA,
			O_UNIDAD_OPERATIVA,		L_UNIDAD_OPERATIVA,
			-- =========================================	
			K_TIPO_UO,				K_ZONA_UO,
			ICS_sucursalId,			K_SERVIDOR,	
			K_RAZON_SOCIAL,			K_REGION,			
			PERMISO_CRE,			
			-- =========================================	
			TELEFONO,			
			CALLE,					NUMERO_EXTERIOR,	
			NUMERO_INTERIOR,		COLONIA,		
			POBLACION,				CP,				
			MUNICIPIO,
			-- =========================================	
			K_USUARIO_ALTA,			F_ALTA,
			K_USUARIO_CAMBIO,		F_CAMBIO,
			L_BORRADO
		)	
	VALUES	
		(	@PP_K_UNIDAD_OPERATIVA,	@PP_D_UNIDAD_OPERATIVA,	
			@PP_C_UNIDAD_OPERATIVA,	@PP_S_UNIDAD_OPERATIVA,
			@PP_O_UNIDAD_OPERATIVA,	@PP_L_UNIDAD_OPERATIVA,
			-- =========================================	
			@PP_K_TIPO_UO,			@PP_K_ZONA_UO,
			@PP_ICS_sucursalId,		@PP_K_SERVIDOR,
			@PP_K_RAZON_SOCIAL,		@PP_K_REGION,			
			@PP_PERMISO_CRE,		
			-- =========================================	
			@PP_TELEFONO,	
			@PP_CALLE,				@PP_NUMERO_EXTERIOR,		
			@PP_NUMERO_INTERIOR,	@PP_COLONIA,				
			@PP_POBLACION,			@PP_CP,					
			@PP_MUNICIPIO,
			-- =========================================	
			@VP_K_USUARIO_ACCION,	GETDATE(),
			@VP_K_USUARIO_ACCION,	GETDATE(),
			0
		)

	-- ==============================================
	-- TERMINALES // K_UNIDAD_OPERATIVA // 22 GTM-TEPEJI // 74 TERMINAL JUAREZ // 81 GTM-TEPEJI-CDMX



	-- ==============================================
GO



-- //////////////////////////////////////////////////////////////
-- // CARGA INICIAL
-- //////////////////////////////////////////////////////////////

-- ===============================================
SET NOCOUNT ON
-- ===============================================



-- ====================================================================== CI_UNIDAD_OPERATIVA
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 0, 'Sin Asignar', 'Sin Asignar', 'S/A', 0, 1, 10, 0, 0, 0, 0, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 1, 'GUADALUPE', 'GUADALUPE', 'GDLPE', 10, 1, 10, 30, 23, 40, 13, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 2, 'PARRAL', 'PARRAL', 'PRRAL', 20, 1, 10, 30, 34, 65, 28, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 3, 'BIOGAS', 'BIOGAS', 'BIOGS', 30, 1, 10, 30, 22, 3, 13, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 4, 'LAS SIERRA', 'LAS SIERRA', 'SIERR', 40, 1, 10, 30, 35, 48, 28, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 5, 'PALOMAS', 'PALOMAS', 'PALMS', 50, 1, 10, 30, 28, 64, 12, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 6, 'PUEBLO', 'PUEBLO', 'PUBLO', 60, 1, 10, 30, 25, 69, 12, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 7, 'HIDRO I', 'HIDRO I', 'HID.1', 70, 1, 10, 30, 30, 45, 28, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 8, 'FLORES MAGON', 'FLORES MAGON', 'FMAGN', 80, 1, 10, 30, 27, 34, 12, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 9, 'DELICIAS', 'DELICIAS', 'DELCS', 90, 1, 10, 30, 36, 32, 28, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 10, 'MARKETING', 'MARKETING', 'MKTNG', 100, 1, 0, 0, 300, 50, 0, 0, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 11, 'ASCENSION', 'ASCENSION', 'ASCNS', 110, 1, 10, 30, 26, 17, 12, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 12, 'OJINAGA', 'OJINAGA', 'OJNGA', 120, 1, 10, 30, 38, 63, 24, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 13, 'UNIGAS MATRIZ', 'UNIGAS MATRIZ', 'UNISJ', 130, 1, 10, 70, 48, 4, 42, 1050, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 14, 'BUENAVENTURA', 'BUENAVENTURA', 'BNVTR', 140, 1, 10, 30, 33, 20, 28, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 15, 'CAMARGO', 'CAMARGO', 'CAMRG', 150, 1, 10, 30, 37, 22, 28, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 16, 'BENITO JUAREZ', 'BENITO JUAREZ', 'BJREZ', 160, 1, 10, 30, 29, 19, 12, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 17, 'HIDRO II', 'HIDRO II', 'HID.2', 170, 1, 10, 30, 31, 46, 28, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 18, 'GAS CHAPULTEPEC', 'GAS CHAPULTEPEC', 'GCHAP', 180, 1, 10, 70, 53, 6, 11, 1050, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 19, 'GAS TOMZA DE PUEBLA', 'GAS TOMZA DE PUEBLA', 'GTPUE', 190, 1, 10, 20, 81, 36, 15, 1070, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 20, 'GAS Y SERVICIO', 'GAS Y SERVICIO', 'GASYS', 200, 1, 10, 70, 51, 8, 23, 1050, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 21, 'GASOMATICO', 'GASOMATICO', 'GSOMT', 210, 1, 10, 70, 50, 11, 25, 1050, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 22, 'GTM-TEPEJI', 'GTM-TEPEJI', 'TEPJI', 220, 1, 20, 20, 58, 38, 19, 1160, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 23, 'MEXICANA DE GAS', 'MEXICANA DE GAS', 'MEXGS', 230, 1, 10, 70, 52, 13, 6, 1050, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 24, 'UNIGAS TLAHUAC', 'UNIGAS TLAHUAC', 'UNITL', 240, 1, 10, 70, 49, 14, 42, 1050, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 25, 'UNIGAS TOLUCA', 'UNIGAS TOLUCA', 'UNITO', 250, 1, 10, 20, 80, 10, 42, 1050, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 26, 'TEHUACAN', 'TEHUACAN', 'TEHCN', 260, 1, 10, 20, 55, 12, 7, 1070, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 27, 'SAN LUIS POTOSI', 'SAN LUIS POTOSI', 'SLPTS', 270, 1, 10, 20, 59, 72, 19, 1140, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 28, 'QUERETARO', 'QUERETARO', 'QRTRO', 280, 1, 10, 20, 60, 71, 19, 1150, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 29, 'GAS URIBE', 'GAS URIBE', 'URIBE', 290, 1, 10, 20, 56, 37, 21, 1170, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 30, 'ZAPOPAN', 'ZAPOPAN', 'ZAPPN', 300, 1, 10, 40, 39, 85, 10, 1042, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 31, 'HIDROGAS ACAPULCO', 'HIDROGAS ACAPULCO', 'HGACA', 310, 1, 10, 20, 57, 9, 26, 1170, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 32, 'MORELOS', 'MORELOS', 'MORLS', 320, 1, 10, 20, 105, 56, 91, 1180, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 33, 'TIJUANA', 'TIJUANA', 'TIJNA', 330, 1, 10, 10, 4, 80, 16, 1010, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 34, 'MEXICALI', 'MEXICALI', 'MXCLI', 340, 1, 10, 10, 5, 53, 16, 1010, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 35, 'ENSENADA', 'ENSENADA', 'ENSND', 350, 1, 10, 10, 6, 33, 16, 1010, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 36, 'HERMOSILLO', 'HERMOSILLO', 'HILLO', 360, 1, 10, 50, 7, 43, 36, 1022, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 37, 'URES', 'URES', 'URES_', 370, 1, 10, 50, 8, 82, 36, 1022, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 38, 'AGUAPRIETA', 'AGUAPRIETA', 'AGPRT', 380, 1, 10, 50, 9, 15, 36, 1021, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 39, 'CANANEA', 'CANANEA', 'CANNE', 390, 1, 10, 50, 10, 24, 36, 1021, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 40, 'NACO', 'NACO', 'NACO_', 400, 1, 10, 50, 11, 57, 36, 1021, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 41, 'NACOZARI', 'NACOZARI', 'NACZA', 410, 1, 10, 50, 12, 58, 36, 1021, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 42, 'NOGALES', 'NOGALES', 'NOGLS', 420, 1, 10, 50, 13, 60, 36, 1021, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 43, 'SANTA ANA', 'SANTA ANA', 'STANA', 430, 1, 10, 50, 14, 75, 36, 1022, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 44, 'CABORCA', 'CABORCA', 'CBRCA', 440, 1, 10, 50, 15, 21, 36, 1021, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 45, 'PUERTO PEÑASCO', 'PUERTO PEÑASCO', 'PEÑSC', 450, 1, 10, 50, 16, 70, 36, 1021, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 46, 'GUAYMAS', 'GUAYMAS', 'GUAYM', 460, 1, 10, 50, 17, 42, 36, 1023, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 47, 'OBREGON', 'OBREGON', 'OBRGN', 470, 1, 10, 50, 18, 61, 36, 1023, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 48, 'NAVOJOA', 'NAVOJOA', 'NAVOJ', 480, 1, 10, 50, 19, 59, 36, 1023, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 49, 'SAN LUIS RIO COLORADO', 'SAN LUIS RIO COLORADO', 'SNLRC', 490, 1, 10, 50, 20, 73, 36, 1021, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 50, 'FUNDICION', 'FUNDICION', 'FNDCN', 500, 1, 10, 50, 21, 35, 36, 1023, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 51, 'LA LAJA', 'LA LAJA', 'LALJA', 510, 1, 10, 40, 40, 47, 10, 1042, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 52, 'TLAJOMULCO', 'TLAJOMULCO', 'TLAJO', 520, 1, 10, 40, 42, 81, 10, 1042, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 53, 'TEPATITLAN', 'TEPATITLAN', 'TEPAT', 530, 1, 10, 40, 43, 76, 10, 1041, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 54, 'OCOTLAN', 'OCOTLAN', 'OCOTL', 540, 1, 10, 40, 44, 62, 10, 1042, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 55, 'YAHUALICA', 'YAHUALICA', 'YAHUA', 550, 1, 10, 40, 45, 84, 10, 1041, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 56, 'CD. GUZMAN', 'CD. GUZMAN', 'CDGZM', 560, 1, 10, 40, 46, 27, 49, 1043, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 57, 'AUTLAN', 'AUTLAN', 'AUTLN', 570, 1, 10, 40, 47, 18, 49, 1043, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 58, 'GAS PRONTO', 'GAS PRONTO', 'GSPTO', 580, 1, 10, 20, 54, 36, 15, 1070, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 59, 'CANCUN', 'CANCUN', 'CNCUN', 590, 1, 10, 60, 61, 25, 47, 1090, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 60, 'COZUMEL', 'COZUMEL', 'CZMEL', 600, 1, 10, 60, 62, 29, 47, 1090, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 61, 'CHETUMAL', 'CHETUMAL', 'CHTMA', 610, 1, 10, 60, 63, 28, 47, 1090, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 62, 'MERIDA', 'MERIDA', 'MERID', 620, 1, 10, 60, 64, 52, 45, 1080, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 63, 'TICUL', 'TICUL', 'TICUL', 630, 1, 10, 60, 65, 79, 45, 1080, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 64, 'CAMPECHE', 'CAMPECHE', 'CMPCH', 640, 1, 10, 60, 66, 23, 53, 1190, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 65, 'CD. DEL CARMEN', 'CD. DEL CARMEN', 'CDCAR', 650, 1, 10, 60, 67, 26, 53, 1190, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 66, 'MINATITLAN', 'MINATITLAN', 'MINAT', 660, 1, 10, 60, 68, 54, 54, 1120, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 67, 'PROGRESO', 'PROGRESO', 'PRGSO', 670, 1, 10, 60, 71, 68, 45, 1080, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 68, 'AGUASCALIENTES', 'AGUASCALIENTES', 'AGUAS', 680, 1, 10, 40, 72, 16, 10, 1130, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 69, 'SAN QUINTIN', 'SAN QUINTIN', 'SNQTN', 690, 1, 10, 10, 73, 74, 16, 1010, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 70, 'MAMEME GAS', 'MAMEME GAS', 'MAMEM', 700, 1, 10, 40, 74, 49, 65, 1042, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 71, 'PLAYA DEL CARMEN', 'PLAYA DEL CARMEN', 'PYACA', 710, 1, 10, 60, 78, 67, 0, 1090, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 72, 'HIDALGO', 'HIDALGO', 'HDLGO', 720, 1, 10, 0, 79, 44, 19, 1160, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 73, 'MOCHIS', 'MOCHIS', 'MOCHS', 730, 1, 10, 50, 84, 55, 90, 1100, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 74, 'TERMINAL JUAREZ', 'TERMINAL JUAREZ', 'JUARZ', 740, 1, 20, 30, 85, 77, 0, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 75, 'GUADALAJARA', 'GUADALAJARA', 'GUADA', 750, 1, 10, 40, 89, 39, 0, 1042, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 76, 'CULIACAN', 'CULIACAN', 'CULCN', 760, 1, 10, 50, 90, 31, 90, 1100, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 77, 'TESISTAN', 'TESISTAN', 'TESTN', 770, 1, 10, 40, 92, 78, 0, 1042, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 78, 'PEPSICO', 'PEPSICO', 'PEPSI', 780, 1, 0, 50, 93, 66, 36, 1042, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 79, 'VERACRUZ', 'VERACRUZ', 'VRCUZ', 790, 1, 20, 60, 94, 83, 54, 1120, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 80, 'GUANAJUATO', 'GUANAJUATO', 'GNJTO', 800, 1, 10, 40, 104, 41, 89, 1110, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 81, 'GTM-TEPEJI-CDMX', 'GTM-TEPEJI-CDMX', 'TEPJI', 810, 1, 10, 20, 106, 0, 19, 1050, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 82, 'KM80', 'KM80', 'KM.80', 820, 1, 10, 60, 107, 52, 45, 1080, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 83, 'CUAUHTEMOC', 'CUAUHTEMOC', 'CUAUH', 830, 1, 10, 30, 32, 30, 28, 1030, '', '', '', '', '', '', '', '', ''
EXECUTE [dbo].[PG_CI_UNIDAD_OPERATIVA] 0, 0, 84, 'MATRIZ', 'MATRIZ', 'NVOCG', 840, 1, 10, 30, 24, 51, 12, 1030, '', '', '', '', '', '', '', '', ''



-- ===============================================
SET NOCOUNT OFF
-- ===============================================


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
