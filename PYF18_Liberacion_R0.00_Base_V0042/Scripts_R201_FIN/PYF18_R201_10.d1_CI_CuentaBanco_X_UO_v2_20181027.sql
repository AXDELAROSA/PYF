-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			CUENTA_BANCO_UO
-- // OPERACION:		LIBERACION / TABLA+CARGA 
-- // Autor:			Alex de la Rosa
-- // Fecha creaci�n:	04/09/18
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CUENTA_BANCO_UO]') AND type in (N'U'))
	DELETE FROM [dbo].[CUENTA_BANCO_UO]
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////

-- SELECT * FROM [CUENTA_BANCO_UO]


-- ===============================================
SET NOCOUNT ON
-- ===============================================


INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1035, 35, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1034, 34, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1069, 69, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1033, 33, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1018, 18, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1020, 20, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1021, 21, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1023, 23, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1013, 13, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1024, 24, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1026, 26, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1031, 31, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1032, 32, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1081, 81, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1028, 28, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1027, 27, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1019, 19, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1025, 25, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1029, 29, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1011, 11, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1016, 16, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1008, 8, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1084, 84, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1005, 5, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1006, 6, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1003, 3, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1001, 1, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1014, 14, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1015, 15, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1083, 83, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1009, 9, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1007, 7, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1017, 17, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1004, 4, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1002, 2, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1012, 12, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1075, 75, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1077, 77, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1068, 68, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1051, 51, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1054, 54, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1053, 53, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1052, 52, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1055, 55, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1030, 30, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1070, 70, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1080, 80, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1057, 57, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1056, 56, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1000, 0, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1072, 72, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1038, 38, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1044, 44, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1039, 39, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1050, 50, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1046, 46, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1036, 36, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1040, 40, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1041, 41, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1048, 48, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1042, 42, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1047, 47, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1045, 45, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1049, 49, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1043, 43, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1037, 37, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1076, 76, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1073, 73, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1071, 71, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1059, 59, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1061, 61, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1060, 60, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1064, 64, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1065, 65, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1082, 82, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1062, 62, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1067, 67, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1063, 63, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 1066, 66, 1 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2035, 35, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2034, 34, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2069, 69, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2033, 33, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2018, 18, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2020, 20, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2021, 21, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2023, 23, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2013, 13, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2024, 24, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2026, 26, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2031, 31, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2032, 32, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2081, 81, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2028, 28, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2027, 27, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2019, 19, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2025, 25, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2029, 29, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2011, 11, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2016, 16, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2008, 8, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2084, 84, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2005, 5, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2006, 6, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2003, 3, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2001, 1, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2014, 14, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2015, 15, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2083, 83, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2009, 9, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2007, 7, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2017, 17, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2004, 4, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2002, 2, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2012, 12, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2075, 75, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2077, 77, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2068, 68, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2051, 51, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2054, 54, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2053, 53, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2052, 52, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2055, 55, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2030, 30, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2070, 70, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2080, 80, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2057, 57, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2056, 56, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2000, 0, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2072, 72, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2038, 38, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2044, 44, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2039, 39, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2050, 50, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2046, 46, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2036, 36, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2040, 40, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2041, 41, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2048, 48, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2042, 42, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2047, 47, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2045, 45, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2049, 49, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2043, 43, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2037, 37, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2076, 76, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2073, 73, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2071, 71, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2059, 59, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2061, 61, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2060, 60, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2064, 64, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2065, 65, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2082, 82, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2062, 62, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2067, 67, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2063, 63, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 2066, 66, 2 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3035, 35, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3034, 34, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3069, 69, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3033, 33, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3018, 18, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3020, 20, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3021, 21, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3023, 23, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3013, 13, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3024, 24, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3026, 26, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3031, 31, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3032, 32, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3081, 81, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3028, 28, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3027, 27, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3019, 19, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3025, 25, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3029, 29, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3011, 11, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3016, 16, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3008, 8, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3084, 84, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3005, 5, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3006, 6, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3003, 3, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3001, 1, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3014, 14, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3015, 15, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3083, 83, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3009, 9, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3007, 7, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3017, 17, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3004, 4, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3002, 2, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3012, 12, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3075, 75, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3077, 77, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3068, 68, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3051, 51, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3054, 54, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3053, 53, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3052, 52, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3055, 55, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3030, 30, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3070, 70, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3080, 80, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3057, 57, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3056, 56, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3000, 0, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3072, 72, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3038, 38, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3044, 44, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3039, 39, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3050, 50, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3046, 46, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3036, 36, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3040, 40, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3041, 41, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3048, 48, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3042, 42, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3047, 47, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3045, 45, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3049, 49, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3043, 43, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3037, 37, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3076, 76, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3073, 73, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3071, 71, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3059, 59, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3061, 61, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3060, 60, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3064, 64, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3065, 65, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3082, 82, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3062, 62, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3067, 67, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3063, 63, 3 )
INSERT INTO [CUENTA_BANCO_UO] ( [K_CUENTA_BANCO_UO], [K_UNIDAD_OPERATIVA], [K_TIPO_CUENTA_BANCO] ) VALUES ( 3066, 66, 3 )


-- ===============================================
SET NOCOUNT OFF
-- ===============================================



-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////