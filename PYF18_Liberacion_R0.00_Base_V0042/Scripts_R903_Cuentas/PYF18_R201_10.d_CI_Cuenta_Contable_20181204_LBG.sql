-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CUENTA CONTABLE
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- // AUTOR:			LBG
-- // FECHA:            20181203
-- ////////////////////////////////////////////////////////////// 


USE [PYF18_Finanzas_V9999_R0]
GO



-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CUENTA_CONTABLE]') AND type in (N'U'))
	DELETE	FROM [dbo].[CUENTA_CONTABLE]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NIVEL_CUENTA_CONTABLE]') AND type in (N'U'))
	DELETE	FROM [dbo].[NIVEL_CUENTA_CONTABLE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SAT_AGRUPADOR]') AND type in (N'U'))
	DELETE	FROM [dbo].[SAT_AGRUPADOR]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIPO_CUENTA_CONTABLE]') AND type in (N'U'))
	DELETE	FROM [dbo].[TIPO_CUENTA_CONTABLE]
GO





-- //////////////////////////////////////////////////////////////
--				SP  CARGA INICIAL	NIVEL							
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_NIVEL_CUENTA_CONTABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_NIVEL_CUENTA_CONTABLE]
GO


CREATE PROCEDURE [dbo].[PG_CI_NIVEL_CUENTA_CONTABLE]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	@PP_K_NIVEL_CUENTA_CONTABLE		INT,
	@PP_D_NIVEL_CUENTA_CONTABLE		VARCHAR(100),
	@PP_S_NIVEL_CUENTA_CONTABLE		VARCHAR(10),
	@PP_O_NIVEL_CUENTA_CONTABLE		INT,
	@PP_C_NIVEL_CUENTA_CONTABLE		VARCHAR(255),
	@PP_L_NIVEL_CUENTA_CONTABLE		INT
AS
	
	INSERT INTO NIVEL_CUENTA_CONTABLE
		(	K_NIVEL_CUENTA_CONTABLE,			D_NIVEL_CUENTA_CONTABLE, 
			S_NIVEL_CUENTA_CONTABLE,			O_NIVEL_CUENTA_CONTABLE,
			C_NIVEL_CUENTA_CONTABLE,
			L_NIVEL_CUENTA_CONTABLE,
			K_USUARIO_ALTA,			F_ALTA,
			K_USUARIO_CAMBIO,		F_CAMBIO,
			L_BORRADO					)		
	VALUES	
		(	@PP_K_NIVEL_CUENTA_CONTABLE,		@PP_D_NIVEL_CUENTA_CONTABLE,	
			@PP_S_NIVEL_CUENTA_CONTABLE,		@PP_O_NIVEL_CUENTA_CONTABLE,
			@PP_C_NIVEL_CUENTA_CONTABLE,
			@PP_L_NIVEL_CUENTA_CONTABLE,
			@PP_K_USUARIO_ACCION,	GETDATE(),
			@PP_K_USUARIO_ACCION,	GETDATE(),
			0		)

	-- =========================================================
GO

-- ===============================================

SET NOCOUNT ON

-- ===============================================
EXECUTE [dbo].[PG_CI_NIVEL_CUENTA_CONTABLE] 0, 0, 0, 1, 'NIVEL 1', 'NVL1', 10, 'S/C', 1
EXECUTE [dbo].[PG_CI_NIVEL_CUENTA_CONTABLE] 0, 0, 0, 2, 'NIVEL 2', 'NVL2', 20, 'S/C', 1
EXECUTE [dbo].[PG_CI_NIVEL_CUENTA_CONTABLE] 0, 0, 0, 3, 'NIVEL 3', 'NVL3', 30, 'S/C', 1
EXECUTE [dbo].[PG_CI_NIVEL_CUENTA_CONTABLE] 0, 0, 0, 4, 'NIVEL 4', 'NVL4', 40, 'S/C', 1
EXECUTE [dbo].[PG_CI_NIVEL_CUENTA_CONTABLE] 0, 0, 0, 5, 'NIVEL 5', 'NVL5', 50, 'S/C', 1


GO

-- ===============================================

SET NOCOUNT OFF



-- //////////////////////////////////////////////////////////////
--				SP  CARGA INICIAL	TIPO							
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIPO_CUENTA_CONTABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIPO_CUENTA_CONTABLE]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIPO_CUENTA_CONTABLE]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	@PP_K_TIPO_CUENTA_CONTABLE		INT,
	@PP_D_TIPO_CUENTA_CONTABLE		VARCHAR(100),
	@PP_S_TIPO_CUENTA_CONTABLE		VARCHAR(10),
	@PP_O_TIPO_CUENTA_CONTABLE		INT,
	@PP_C_TIPO_CUENTA_CONTABLE		VARCHAR(255),
	@PP_L_TIPO_CUENTA_CONTABLE		INT
AS
	
	INSERT INTO TIPO_CUENTA_CONTABLE
		(	K_TIPO_CUENTA_CONTABLE,			D_TIPO_CUENTA_CONTABLE, 
			S_TIPO_CUENTA_CONTABLE,			O_TIPO_CUENTA_CONTABLE,
			C_TIPO_CUENTA_CONTABLE,
			L_TIPO_CUENTA_CONTABLE,
			K_USUARIO_ALTA,			F_ALTA,
			K_USUARIO_CAMBIO,		F_CAMBIO,
			L_BORRADO					)		
	VALUES	
		(	@PP_K_TIPO_CUENTA_CONTABLE,		@PP_D_TIPO_CUENTA_CONTABLE,	
			@PP_S_TIPO_CUENTA_CONTABLE,		@PP_O_TIPO_CUENTA_CONTABLE,
			@PP_C_TIPO_CUENTA_CONTABLE,
			@PP_L_TIPO_CUENTA_CONTABLE,
			@PP_K_USUARIO_ACCION,	GETDATE(),
			@PP_K_USUARIO_ACCION,	GETDATE(),
			0		)

	-- =========================================================
GO

-- ===============================================

SET NOCOUNT ON

-- ===============================================

EXECUTE [dbo].[PG_CI_TIPO_CUENTA_CONTABLE] 0, 0, 0, 1, 'A Activo Deudora', '1.ACT', 10, 'S/C', 1
EXECUTE [dbo].[PG_CI_TIPO_CUENTA_CONTABLE] 0, 0, 0, 2, 'B Activo Acreedora', '2.ACT', 20, 'S/C', 1
EXECUTE [dbo].[PG_CI_TIPO_CUENTA_CONTABLE] 0, 0, 0, 3, 'D Pasivo Acreedora', '3.PAS', 30, 'S/C', 1
EXECUTE [dbo].[PG_CI_TIPO_CUENTA_CONTABLE] 0, 0, 0, 4, 'F Capital Acreedora', '4.CAP', 40, 'S/C', 1
EXECUTE [dbo].[PG_CI_TIPO_CUENTA_CONTABLE] 0, 0, 0, 5, 'H Resultados Acreedora', '5.ING', 50, 'S/C', 1
EXECUTE [dbo].[PG_CI_TIPO_CUENTA_CONTABLE] 0, 0, 0, 6, 'G Resultados Deudora', '6.EGR', 60, 'S/C', 1


GO

-- ===============================================

SET NOCOUNT OFF




-- //////////////////////////////////////////////////////////////
--				SP  CARGA INICIAL	TIPO							
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_SAT_AGRUPADOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_SAT_AGRUPADOR]
GO


-- //////////////////////////////////////////////////////////////
--				SP  CARGA INICIAL	SAT AGRUPADOR							
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_SAT_AGRUPADOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_SAT_AGRUPADOR]
GO


CREATE PROCEDURE [dbo].[PG_CI_SAT_AGRUPADOR]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	@PP_K_SAT_AGRUPADOR		INT,
	@PP_CLAVE				DECIMAL (19,2),
	@PP_D_SAT_AGRUPADOR		VARCHAR(100),
	@PP_S_SAT_AGRUPADOR		VARCHAR(10),
	@PP_O_SAT_AGRUPADOR		INT,
	@PP_C_SAT_AGRUPADOR		VARCHAR(255),
	@PP_L_SAT_AGRUPADOR		INT,
	@PP_K_NIVEL_AGRUPADOR	INT
AS
	
	INSERT INTO SAT_AGRUPADOR
		(	K_SAT_AGRUPADOR,		D_SAT_AGRUPADOR, 
			CLAVE,
			S_SAT_AGRUPADOR,		O_SAT_AGRUPADOR,
			C_SAT_AGRUPADOR,
			L_SAT_AGRUPADOR,		K_NIVEL_AGRUPADOR,
			K_USUARIO_ALTA,			F_ALTA,
			K_USUARIO_CAMBIO,		F_CAMBIO,
			L_BORRADO					)		
	VALUES	
		(	@PP_K_SAT_AGRUPADOR,	@PP_D_SAT_AGRUPADOR,	
			@PP_CLAVE,
			@PP_S_SAT_AGRUPADOR,	@PP_O_SAT_AGRUPADOR,
			@PP_C_SAT_AGRUPADOR,
			@PP_L_SAT_AGRUPADOR,	@PP_K_NIVEL_AGRUPADOR,
			@PP_K_USUARIO_ACCION,	GETDATE(),
			@PP_K_USUARIO_ACCION,	GETDATE(),
			0		)

	-- =========================================================
GO

-- ===============================================

SET NOCOUNT ON

-- ===============================================

EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 0, 0, 'sin cuenta', '0', 0, 'S/C', 0, 0
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1, 100, 'Activo', '100Ac', 10, 'S/C', 1, 0
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 2, 100.01, 'Activo a corto plazo', '100.01Ac', 20, 'S/C', 1, 0
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 3, 101, 'Caja', '101Ca', 30, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 4, 101.01, 'Caja y efectivo', '101.01Ca', 40, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 5, 102, 'Bancos', '102Ba', 50, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 6, 102.01, 'Bancos nacionales', '102.01Ba', 60, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 7, 102.02, 'Bancos extranjeros', '102.02Ba', 70, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 8, 103, 'Inversiones', '103In', 80, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 9, 103.01, 'Inversiones temporales', '103.01In', 90, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 10, 103.02, 'Inversiones en fideicomisos', '103.02In', 100, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 11, 103.03, 'Otras inversiones', '103.03Ot', 110, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 12, 104, 'Otros instrumentos financieros', '104Ot', 120, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 13, 104.01, 'Otros instrumentos financieros', '104.01Ot', 130, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 14, 105, 'Clientes', '105Cl', 140, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 15, 105.01, 'Clientes nacionales', '105.01Cl', 150, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 16, 105.02, 'Clientes extranjeros', '105.02Cl', 160, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 17, 105.03, 'Clientes nacionales parte relacionada', '105.03Cl', 170, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 18, 105.04, 'Clientes extranjeros parte relacionada', '105.04Cl', 180, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 19, 106, 'Cuentas y documentos por cobrar a corto plazo', '106Cu', 190, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 20, 106.01, 'Cuentas y documentos por cobrar a corto plazo nacional', '106.01Cu', 200, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 21, 106.02, 'Cuentas y documentos por cobrar a corto plazo extranjero', '106.02Cu', 210, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 22, 106.03, 'Cuentas y documentos por cobrar a corto plazo nacional parte relacionada', '106.03Cu', 220, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 23, 106.04, 'Cuentas y documentos por cobrar a corto plazo extranjero parte relacionada', '106.04Cu', 230, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 24, 106.05, 'Intereses por cobrar a corto plazo nacional', '106.05In', 240, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 25, 106.06, 'Intereses por cobrar a corto plazo extranjero', '106.06In', 250, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 26, 106.07, 'Intereses por cobrar a corto plazo nacional parte relacionada', '106.07In', 260, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 27, 106.08, 'Intereses por cobrar a corto plazo extranjero parte relacionada', '106.08In', 270, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 28, 106.09, 'Otras cuentas y documentos por cobrar a corto plazo', '106.09Ot', 280, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 29, 106.1, 'Otras cuentas y documentos por cobrar a corto plazo parte relacionada', '106.1Ot', 290, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 30, 107, 'Deudores diversos', '107De', 300, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 31, 107.01, 'Funcionarios y empleados', '107.01Fu', 310, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 32, 107.02, 'Socios y accionistas', '107.02So', 320, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 33, 107.03, 'Partes relacionadas nacionales', '107.03Pa', 330, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 34, 107.04, 'Partes relacionadas extranjeros', '107.04Pa', 340, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 35, 107.05, 'Otros deudores diversos', '107.05Ot', 350, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 36, 108, 'Estimación de cuentas incobrables', '108Es', 360, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 37, 108.01, 'Estimación de cuentas incobrables nacional', '108.01Es', 370, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 38, 108.02, 'Estimación de cuentas incobrables extranjero', '108.02Es', 380, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 39, 108.03, 'Estimación de cuentas incobrables nacional parte relacionada', '108.03Es', 390, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 40, 108.04, 'Estimación de cuentas incobrables extranjero parte relacionada', '108.04Es', 400, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 41, 109, 'Pagos anticipados', '109Pa', 410, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 42, 109.01, 'Seguros y fianzas pagados por anticipado nacional', '109.01Se', 420, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 43, 109.02, 'Seguros y fianzas pagados por anticipado extranjero', '109.02Se', 430, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 44, 109.03, 'Seguros y fianzas pagados por anticipado nacional parte relacionada', '109.03Se', 440, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 45, 109.04, 'Seguros y fianzas pagados por anticipado extranjero parte relacionada', '109.04Se', 450, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 46, 109.05, 'Rentas pagadas por anticipado nacional', '109.05Re', 460, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 47, 109.06, 'Rentas pagadas por anticipado extranjero', '109.06Re', 470, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 48, 109.07, 'Rentas pagadas por anticipado nacional parte relacionada', '109.07Re', 480, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 49, 109.08, 'Rentas pagadas por anticipado extranjero parte relacionada', '109.08Re', 490, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 50, 109.09, 'Intereses pagados por anticipado nacional', '109.09In', 500, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 51, 109.1, 'Intereses pagados por anticipado extranjero', '109.1In', 510, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 52, 109.11, 'Intereses pagados por anticipado nacional parte relacionada', '109.11In', 520, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 53, 109.12, 'Intereses pagados por anticipado extranjero parte relacionada', '109.12In', 530, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 54, 109.13, 'Factoraje financiero pagado por anticipado nacional', '109.13Fa', 540, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 55, 109.14, 'Factoraje financiero pagado por anticipado extranjero', '109.14Fa', 550, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 56, 109.15, 'Factoraje financiero pagado por anticipado nacional parte relacionada', '109.15Fa', 560, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 57, 109.16, 'Factoraje financiero pagado por anticipado extranjero parte relacionada', '109.16Fa', 570, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 58, 109.17, 'Arrendamiento financiero pagado por anticipado nacional', '109.17Ar', 580, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 59, 109.18, 'Arrendamiento financiero pagado por anticipado extranjero', '109.18Ar', 590, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 60, 109.19, 'Arrendamiento financiero pagado por anticipado nacional parte relacionada', '109.19Ar', 600, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 61, 109.2, 'Arrendamiento financiero pagado por anticipado extranjero parte relacionada', '109.2Ar', 610, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 62, 109.21, 'Pérdida por deterioro de pagos anticipados', '109.21Pé', 620, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 63, 109.22, 'Derechos fiduciarios', '109.22De', 630, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 64, 109.23, 'Otros pagos anticipados', '109.23Ot', 640, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 65, 110, 'Subsidio al empleo por aplicar', '110Su', 650, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 66, 110.01, 'Subsidio al empleo por aplicar', '110.01Su', 660, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 67, 111, 'Crédito al diesel por acreditar', '111Cr', 670, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 68, 111.01, 'Crédito al diesel por acreditar', '111.01Cr', 680, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 69, 112, 'Otros estímulos', '112Ot', 690, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 70, 112.01, 'Otros estímulos', '112.01Ot', 700, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 71, 113, 'Impuestos a favor', '113Im', 710, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 72, 113.01, 'IVA a favor', '113.01IV', 720, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 73, 113.02, 'ISR a favor', '113.02IS', 730, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 74, 113.03, 'IETU a favor', '113.03IE', 740, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 75, 113.04, 'IDE a favor', '113.04ID', 750, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 76, 113.05, 'IA a favor', '113.05IA', 760, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 77, 113.06, 'Subsidio al empleo', '113.06Su', 770, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 78, 113.07, 'Pago de lo indebido', '113.07Pa', 780, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 79, 113.08, 'Otros impuestos a favor', '113.08Ot', 790, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 80, 114, 'Pagos provisionales', '114Pa', 800, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 81, 114.01, 'Pagos provisionales de ISR', '114.01Pa', 810, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 82, 115, 'Inventario', '115In', 820, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 83, 115.01, 'Inventario', '115.01In', 830, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 84, 115.02, 'Materia prima y materiales', '115.02Ma', 840, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 85, 115.03, 'Producción en proceso', '115.03Pr', 850, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 86, 115.04, 'Productos terminados', '115.04Pr', 860, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 87, 115.05, 'Mercancías en tránsito', '115.05Me', 870, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 88, 115.06, 'Mercancías en poder de terceros', '115.06Me', 880, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 89, 115.07, 'Otros', '115.07Ot', 890, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 90, 116, 'Estimación de inventarios obsoletos y de lento movimiento', '116Es', 900, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 91, 116.01, 'Estimación de inventarios obsoletos y de lento movimiento', '116.01Es', 910, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 92, 117, 'Obras en proceso de inmuebles', '117Ob', 920, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 93, 117.01, 'Obras en proceso de inmuebles', '117.01Ob', 930, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 94, 118, 'Impuestos acreditables pagados', '118Im', 940, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 95, 118.01, 'IVA acreditable pagado', '118.01IV', 950, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 96, 118.02, 'IVA acreditable de importación pagado', '118.02IV', 960, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 97, 118.03, 'IEPS acreditable pagado', '118.03IE', 970, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 98, 118.04, 'IEPS pagado en importación', '118.04IE', 980, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 99, 119, 'Impuestos acreditables por pagar', '119Im', 990, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 100, 119.01, 'IVA pendiente de pago', '119.01IV', 1000, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 101, 119.02, 'IVA de importación pendiente de pago', '119.02IV', 1010, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 102, 119.03, 'IEPS pendiente de pago', '119.03IE', 1020, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 103, 119.04, 'IEPS pendiente de pago en importación', '119.04IE', 1030, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 104, 120, 'Anticipo a proveedores', '120An', 1040, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 105, 120.01, 'Anticipo a proveedores nacional', '120.01An', 1050, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 106, 120.02, 'Anticipo a proveedores extranjero', '120.02An', 1060, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 107, 120.03, 'Anticipo a proveedores nacional parte relacionada', '120.03An', 1070, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 108, 120.04, 'Anticipo a proveedores extranjero parte relacionada', '120.04An', 1080, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 109, 121, 'Otros activos a corto plazo', '121Ot', 1090, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 110, 121.01, 'Otros activos a corto plazo', '121.01Ot', 1100, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 111, 100.02 , 'Activo a largo plazo', '100.02 Ac', 1110, 'S/C', 1, 0
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 112, 151, 'Terrenos', '151Te', 1120, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 113, 151.01, 'Terrenos', '151.01Te', 1130, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 114, 152, 'Edificios', '152Ed', 1140, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 115, 152.01, 'Edificios', '152.01Ed', 1150, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 116, 153, 'Maquinaria y equipo', '153Ma', 1160, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 117, 153.01, 'Maquinaria y equipo', '153.01Ma', 1170, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 118, 154, 'Automóviles, autobuses, camiones de carga, tractocamiones, montacargas y remolques', '154Au', 1180, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 119, 154.01, 'Automóviles, autobuses, camiones de carga, tractocamiones, montacargas y remolques', '154.01Au', 1190, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 120, 155, 'Mobiliario y equipo de oficina', '155Mo', 1200, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 121, 155.01, 'Mobiliario y equipo de oficina', '155.01Mo', 1210, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 122, 156, 'Equipo de cómputo', '156Eq', 1220, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 123, 156.01, 'Equipo de cómputo', '156.01Eq', 1230, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 124, 157, 'Equipo de comunicación', '157Eq', 1240, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 125, 157.01, 'Equipo de comunicación', '157.01Eq', 1250, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 126, 158, 'Activos biológicos, vegetales y semovientes', '158Ac', 1260, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 127, 158.01, 'Activos biológicos, vegetales y semovientes', '158.01Ac', 1270, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 128, 159, 'Obras en proceso de activos fijos', '159Ob', 1280, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 129, 159.01, 'Obras en proceso de activos fijos', '159.01Ob', 1290, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 130, 160, 'Otros activos fijos', '160Ot', 1300, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 131, 160.01, 'Otros activos fijos', '160.01Ot', 1310, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 132, 161, 'Ferrocarriles', '161Fe', 1320, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 133, 161.01, 'Ferrocarriles', '161.01Fe', 1330, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 134, 162, 'Embarcaciones', '162Em', 1340, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 135, 162.01, 'Embarcaciones', '162.01Em', 1350, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 136, 163, 'Aviones', '163Av', 1360, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 137, 163.01, 'Aviones', '163.01Av', 1370, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 138, 164, 'Troqueles, moldes, matrices y herramental', '164Tr', 1380, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 139, 164.01, 'Troqueles, moldes, matrices y herramental', '164.01Tr', 1390, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 140, 165, 'Equipo de comunicaciones telefónicas', '165Eq', 1400, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 141, 165.01, 'Equipo de comunicaciones telefónicas', '165.01Eq', 1410, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 142, 166, 'Equipo de comunicación satelital', '166Eq', 1420, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 143, 166.01, 'Equipo de comunicación satelital', '166.01Eq', 1430, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 144, 167, 'Equipo de adaptaciones para personas con capacidades diferentes', '167Eq', 1440, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 145, 167.01, 'Equipo de adaptaciones para personas con capacidades diferentes', '167.01Eq', 1450, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 146, 168, 'Maquinaria y equipo de generación de energía de fuentes renovables o de sistemas decogeneración de electricidad eficiente', '168Ma', 1460, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 147, 168.01, 'Maquinaria y equipo de generación de energía de fuentes renovables o de sistemas decogeneración de electricidad eficiente', '168.01Ma', 1470, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 148, 169, 'Otra maquinaria y equipo', '169Ot', 1480, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 149, 169.01, 'Otra maquinaria y equipo', '169.01Ot', 1490, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 150, 170, 'Adaptaciones y mejoras', '170Ad', 1500, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 151, 170.01, 'Adaptaciones y mejoras', '170.01Ad', 1510, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 152, 171, 'Depreciación acumulada de activos fijos', '171De', 1520, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 153, 171.01, 'Depreciación acumulada de edificios', '171.01De', 1530, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 154, 171.02, 'Depreciación acumulada de maquinaria y equipo', '171.02De', 1540, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 155, 171.03, 'Depreciación acumulada de automóviles, autobuses, camiones de carga, tractocamiones,montacargas y remolques', '171.03De', 1550, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 156, 171.04, 'Depreciación acumulada de mobiliario y equipo de oficina', '171.04De', 1560, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 157, 171.05, 'Depreciación acumulada de equipo de cómputo', '171.05De', 1570, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 158, 171.06, 'Depreciación acumulada de equipo de comunicación', '171.06De', 1580, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 159, 171.07, 'Depreciación acumulada de activos biológicos, vegetales y semovientes', '171.07De', 1590, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 160, 171.08, 'Depreciación acumulada de otros activos fijos', '171.08De', 1600, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 161, 171.09, 'Depreciación acumulada de ferrocarriles', '171.09De', 1610, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 162, 171.1, 'Depreciación acumulada de embarcaciones', '171.1De', 1620, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 163, 171.11, 'Depreciación acumulada de aviones', '171.11De', 1630, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 164, 171.12, 'Depreciación acumulada de troqueles, moldes, matrices y herramental', '171.12De', 1640, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 165, 171.13, 'Depreciación acumulada de equipo de comunicaciones telefónicas', '171.13De', 1650, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 166, 171.14, 'Depreciación acumulada de equipo de comunicación satelital', '171.14De', 1660, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 167, 171.15, 'Depreciación acumulada de equipo de adaptaciones para personas con capacidades diferentes', '171.15De', 1670, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 168, 171.16, 'Depreciación acumulada de maquinaria y equipo de generación de energía de fuentes renovables o de sistemas de cogeneración de electricidad eficiente', '171.16De', 1680, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 169, 171.17, 'Depreciación acumulada de adaptaciones y mejoras', '171.17De', 1690, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 170, 171.18, 'Depreciación acumulada de otra maquinaria y equipo', '171.18De', 1700, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 171, 172, 'Pérdida por deterioro acumulado de activos fijos', '172Pé', 1710, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 172, 172.01, 'Pérdida por deterioro acumulado de edificios', '172.01Pé', 1720, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 173, 172.02, 'Pérdida por deterioro acumulado de maquinaria y equipo', '172.02Pé', 1730, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 174, 172.03, 'Pérdida por deterioro acumulado de automóviles, autobuses, camiones de carga, tractocamiones, montacargas y remolques', '172.03Pé', 1740, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 175, 172.04, 'Pérdida por deterioro acumulado de mobiliario y equipo de oficina', '172.04Pé', 1750, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 176, 172.05, 'Pérdida por deterioro acumulado de equipo de cómputo', '172.05Pé', 1760, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 177, 172.06, 'Pérdida por deterioro acumulado de equipo de comunicación', '172.06Pé', 1770, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 178, 172.07, 'Pérdida por deterioro acumulado de activos biológicos, vegetales y semovientes', '172.07Pé', 1780, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 179, 172.08, 'Pérdida por deterioro acumulado de otros activos fijos', '172.08Pé', 1790, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 180, 172.09, 'Pérdida por deterioro acumulado de ferrocarriles', '172.09Pé', 1800, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 181, 172.1, 'Pérdida por deterioro acumulado de embarcaciones', '172.1Pé', 1810, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 182, 172.11, 'Pérdida por deterioro acumulado de aviones', '172.11Pé', 1820, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 183, 172.12, 'Pérdida por deterioro acumulado de troqueles, moldes, matrices y herramental', '172.12Pé', 1830, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 184, 172.13, 'Pérdida por deterioro acumulado de equipo de comunicaciones telefónicas', '172.13Pé', 1840, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 185, 172.14, 'Pérdida por deterioro acumulado de equipo de comunicación satelital', '172.14Pé', 1850, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 186, 172.15, 'Pérdida por deterioro acumulado de equipo de adaptaciones para personas con capacidadesdiferentes', '172.15Pé', 1860, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 187, 172.16, 'Pérdida por deterioro acumulado de maquinaria y equipo de generación de energía de fuentesrenovables o de sistemas de cogeneración de electricidad eficiente', '172.16Pé', 1870, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 188, 172.17, 'Pérdida por deterioro acumulado de adaptaciones y mejoras', '172.17Pé', 1880, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 189, 172.18, 'Pérdida por deterioro acumulado de otra maquinaria y equipo', '172.18Pé', 1890, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 190, 173, 'Gastos diferidos', '173Ga', 1900, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 191, 173.01, 'Gastos diferidos', '173.01Ga', 1910, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 192, 174, 'Gastos pre operativos', '174Ga', 1920, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 193, 174.01, 'Gastos pre operativos', '174.01Ga', 1930, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 194, 175, 'Regalías, asistencia técnica y otros gastos diferidos', '175Re', 1940, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 195, 175.01, 'Regalías, asistencia técnica y otros gastos diferidos', '175.01Re', 1950, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 196, 176, 'Activos intangibles', '176Ac', 1960, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 197, 176.01, 'Activos intangibles', '176.01Ac', 1970, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 198, 177, 'Gastos de organización', '177Ga', 1980, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 199, 177.01, 'Gastos de organización', '177.01Ga', 1990, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 200, 178, 'Investigación y desarrollo de mercado', '178In', 2000, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 201, 178.01, 'Investigación y desarrollo de mercado', '178.01In', 2010, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 202, 179, 'Marcas y patentes', '179Ma', 2020, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 203, 179.01, 'Marcas y patentes', '179.01Ma', 2030, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 204, 180, 'Crédito mercantil', '180Cr', 2040, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 205, 180.01, 'Crédito mercantil', '180.01Cr', 2050, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 206, 181, 'Gastos de instalación', '181Ga', 2060, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 207, 181.01, 'Gastos de instalación', '181.01Ga', 2070, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 208, 182, 'Otros activos diferidos', '182Ot', 2080, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 209, 182.01, 'Otros activos diferidos', '182.01Ot', 2090, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 210, 183, 'Amortización acumulada de activos diferidos', '183Am', 2100, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 211, 183.01, 'Amortización acumulada de gastos diferidos', '183.01Am', 2110, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 212, 183.02, 'Amortización acumulada de gastos pre operativos', '183.02Am', 2120, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 213, 183.03, 'Amortización acumulada de regalías, asistencia técnica y otros gastos diferidos', '183.03Am', 2130, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 214, 183.04, 'Amortización acumulada de activos intangibles', '183.04Am', 2140, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 215, 183.05, 'Amortización acumulada de gastos de organización', '183.05Am', 2150, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 216, 183.06, 'Amortización acumulada de investigación y desarrollo de mercado', '183.06Am', 2160, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 217, 183.07, 'Amortización acumulada de marcas y patentes', '183.07Am', 2170, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 218, 183.08, 'Amortización acumulada de crédito mercantil', '183.08Am', 2180, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 219, 183.09, 'Amortización acumulada de gastos de instalación', '183.09Am', 2190, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 220, 183.1, 'Amortización acumulada de otros activos diferidos', '183.1Am', 2200, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 221, 184, 'Depósitos en garantía', '184De', 2210, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 222, 184.01, 'Depósitos de fianzas', '184.01De', 2220, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 223, 184.02, 'Depósitos de arrendamiento de bienes inmuebles', '184.02De', 2230, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 224, 184.03, 'Otros depósitos en garantía', '184.03Ot', 2240, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 225, 185, 'Impuestos diferidos', '185Im', 2250, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 226, 185.01, 'Impuestos diferidos ISR', '185.01Im', 2260, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 227, 186, 'Cuentas y documentos por cobrar a largo plazo', '186Cu', 2270, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 228, 186.01, 'Cuentas y documentos por cobrar a largo plazo nacional', '186.01Cu', 2280, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 229, 186.02, 'Cuentas y documentos por cobrar a largo plazo extranjero', '186.02Cu', 2290, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 230, 186.03, 'Cuentas y documentos por cobrar a largo plazo nacional parte relacionada', '186.03Cu', 2300, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 231, 186.04, 'Cuentas y documentos por cobrar a largo plazo extranjero parte relacionada', '186.04Cu', 2310, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 232, 186.05, 'Intereses por cobrar a largo plazo nacional', '186.05In', 2320, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 233, 186.06, 'Intereses por cobrar a largo plazo extranjero', '186.06In', 2330, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 234, 186.07, 'Intereses por cobrar a largo plazo nacional parte relacionada', '186.07In', 2340, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 235, 186.08, 'Intereses por cobrar a largo plazo extranjero parte relacionada', '186.08In', 2350, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 236, 186.09, 'Otras cuentas y documentos por cobrar a largo plazo', '186.09Ot', 2360, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 237, 186.1, 'Otras cuentas y documentos por cobrar a largo plazo parte relacionada', '186.1Ot', 2370, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 238, 187, 'Participación de los trabajadores en las utilidades diferidas', '187Pa', 2380, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 239, 187.01, 'Participación de los trabajadores en las utilidades diferidas', '187.01Pa', 2390, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 240, 188, 'Inversiones permanentes en acciones', '188In', 2400, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 241, 188.01, 'Inversiones a largo plazo en subsidiarias', '188.01In', 2410, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 242, 188.02, 'Inversiones a largo plazo en asociadas', '188.02In', 2420, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 243, 188.03, 'Otras inversiones permanentes en acciones', '188.03Ot', 2430, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 244, 189, 'Estimación por deterioro de inversiones permanentes en acciones', '189Es', 2440, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 245, 189.01, 'Estimación por deterioro de inversiones permanentes en acciones', '189.01Es', 2450, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 246, 190, 'Otros instrumentos financieros', '190Ot', 2460, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 247, 190.01, 'Otros instrumentos financieros', '190.01Ot', 2470, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 248, 191, 'Otros activos a largo plazo', '191Ot', 2480, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 249, 191.01, 'Otros activos a largo plazo', '191.01Ot', 2490, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 250, 200, 'Pasivo', '200Pa', 2500, 'S/C', 1, 0
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 251, 200.01, 'Pasivo a corto plazo', '200.01Pa', 2510, 'S/C', 1, 0
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 252, 201, 'Proveedores', '201Pr', 2520, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 253, 201.01, 'Proveedores nacionales', '201.01Pr', 2530, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 254, 201.02, 'Proveedores extranjeros', '201.02Pr', 2540, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 255, 201.03, 'Proveedores nacionales parte relacionada', '201.03Pr', 2550, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 256, 201.04, 'Proveedores extranjeros parte relacionada', '201.04Pr', 2560, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 257, 202, 'Cuentas por pagar a corto plazo', '202Cu', 2570, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 258, 202.01, 'Documentos por pagar bancario y financiero nacional', '202.01Do', 2580, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 259, 202.02, 'Documentos por pagar bancario y financiero extranjero', '202.02Do', 2590, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 260, 202.03, 'Documentos y cuentas por pagar a corto plazo nacional', '202.03Do', 2600, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 261, 202.04, 'Documentos y cuentas por pagar a corto plazo extranjero', '202.04Do', 2610, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 262, 202.05, 'Documentos y cuentas por pagar a corto plazo nacional parte relacionada', '202.05Do', 2620, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 263, 202.06, 'Documentos y cuentas por pagar a corto plazo extranjero parte relacionada', '202.06Do', 2630, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 264, 202.07, 'Intereses por pagar a corto plazo nacional', '202.07In', 2640, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 265, 202.08, 'Intereses por pagar a corto plazo extranjero', '202.08In', 2650, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 266, 202.09, 'Intereses por pagar a corto plazo nacional parte relacionada', '202.09In', 2660, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 267, 202.1, 'Intereses por pagar a corto plazo extranjero parte relacionada', '202.1In', 2670, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 268, 202.11, 'Dividendo por pagar nacional', '202.11Di', 2680, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 269, 202.12, 'Dividendo por pagar extranjero', '202.12Di', 2690, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 270, 203, 'Cobros anticipados a corto plazo', '203Co', 2700, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 271, 203.01, 'Rentas cobradas por anticipado a corto plazo nacional', '203.01Re', 2710, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 272, 203.02, 'Rentas cobradas por anticipado a corto plazo extranjero', '203.02Re', 2720, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 273, 203.03, 'Rentas cobradas por anticipado a corto plazo nacional parte relacionada', '203.03Re', 2730, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 274, 203.04, 'Rentas cobradas por anticipado a corto plazo extranjero parte relacionada', '203.04Re', 2740, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 275, 203.05, 'Intereses cobrados por anticipado a corto plazo nacional', '203.05In', 2750, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 276, 203.06, 'Intereses cobrados por anticipado a corto plazo extranjero', '203.06In', 2760, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 277, 203.07, 'Intereses cobrados por anticipado a corto plazo nacional parte relacionada', '203.07In', 2770, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 278, 203.08, 'Intereses cobrados por anticipado a corto plazo extranjero parte relacionada', '203.08In', 2780, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 279, 203.09, 'Factoraje financiero cobrados por anticipado a corto plazo nacional', '203.09Fa', 2790, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 280, 203.1, 'Factoraje financiero cobrados por anticipado a corto plazo extranjero', '203.1Fa', 2800, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 281, 203.11, 'Factoraje financiero cobrados por anticipado a corto plazo nacional parte relacionada', '203.11Fa', 2810, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 282, 203.12, 'Factoraje financiero cobrados por anticipado a corto plazo extranjero parte relacionada', '203.12Fa', 2820, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 283, 203.13, 'Arrendamiento financiero cobrados por anticipado a corto plazo nacional', '203.13Ar', 2830, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 284, 203.14, 'Arrendamiento financiero cobrados por anticipado a corto plazo extranjero', '203.14Ar', 2840, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 285, 203.15, 'Arrendamiento financiero cobrados por anticipado a corto plazo nacional parte relacionada', '203.15Ar', 2850, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 286, 203.16, 'Arrendamiento financiero cobrados por anticipado a corto plazo extranjero parte relacionada', '203.16Ar', 2860, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 287, 203.17, 'Derechos fiduciarios', '203.17De', 2870, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 288, 203.18, 'Otros cobros anticipados', '203.18Ot', 2880, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 289, 204, 'Instrumentos financieros a corto plazo', '204In', 2890, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 290, 204.01, 'Instrumentos financieros a corto plazo', '204.01In', 2900, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 291, 205, 'Acreedores diversos a corto plazo', '205Ac', 2910, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 292, 205.01, 'Socios, accionistas o representante legal', '205.01So', 2920, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 293, 205.02, 'Acreedores diversos a corto plazo nacional', '205.02Ac', 2930, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 294, 205.03, 'Acreedores diversos a corto plazo extranjero', '205.03Ac', 2940, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 295, 205.04, 'Acreedores diversos a corto plazo nacional parte relacionada', '205.04Ac', 2950, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 296, 205.05, 'Acreedores diversos a corto plazo extranjero parte relacionada', '205.05Ac', 2960, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 297, 205.06, 'Otros acreedores diversos a corto plazo', '205.06Ot', 2970, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 298, 206, 'Anticipo de cliente', '206An', 2980, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 299, 206.01, 'Anticipo de cliente nacional', '206.01An', 2990, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 300, 206.02, 'Anticipo de cliente extranjero', '206.02An', 3000, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 301, 206.03, 'Anticipo de cliente nacional parte relacionada', '206.03An', 3010, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 302, 206.04, 'Anticipo de cliente extranjero parte relacionada', '206.04An', 3020, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 303, 206.05, 'Otros anticipos de clientes', '206.05Ot', 3030, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 304, 207, 'Impuestos trasladados', '207Im', 3040, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 305, 207.01, 'IVA trasladado', '207.01IV', 3050, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 306, 207.02, 'IEPS trasladado', '207.02IE', 3060, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 307, 208, 'Impuestos trasladados cobrados', '208Im', 3070, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 308, 208.01, 'IVA trasladado cobrado', '208.01IV', 3080, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 309, 208.02, 'IEPS trasladado cobrado', '208.02IE', 3090, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 310, 209, 'Impuestos trasladados no cobrados', '209Im', 3100, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 311, 209.01, 'IVA trasladado no cobrado', '209.01IV', 3110, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 312, 209.02, 'IEPS trasladado no cobrado', '209.02IE', 3120, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 313, 210, 'Provisión de sueldos y salarios por pagar', '210Pr', 3130, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 314, 210.01, 'Provisión de sueldos y salarios por pagar', '210.01Pr', 3140, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 315, 210.02, 'Provisión de vacaciones por pagar', '210.02Pr', 3150, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 316, 210.03, 'Provisión de aguinaldo por pagar', '210.03Pr', 3160, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 317, 210.04, 'Provisión de fondo de ahorro por pagar', '210.04Pr', 3170, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 318, 210.05, 'Provisión de asimilados a salarios por pagar', '210.05Pr', 3180, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 319, 210.06, 'Provisión de anticipos o remanentes por distribuir', '210.06Pr', 3190, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 320, 210.07, 'Provisión de otros sueldos y salarios por pagar', '210.07Pr', 3200, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 321, 211, 'Provisión de contribuciones de seguridad social por pagar', '211Pr', 3210, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 322, 211.01, 'Provisión de IMSS patronal por pagar', '211.01Pr', 3220, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 323, 211.02, 'Provisión de SAR por pagar', '211.02Pr', 3230, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 324, 211.03, 'Provisión de infonavit por pagar', '211.03Pr', 3240, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 325, 212, 'Provisión de impuesto estatal sobre nómina por pagar', '212Pr', 3250, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 326, 212.01, 'Provisión de impuesto estatal sobre nómina por pagar', '212.01Pr', 3260, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 327, 213, 'Impuestos y derechos por pagar', '213Im', 3270, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 328, 213.01, 'IVA por pagar', '213.01IV', 3280, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 329, 213.02, 'IEPS por pagar', '213.02IE', 3290, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 330, 213.03, 'ISR por pagar', '213.03IS', 3300, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 331, 213.04, 'Impuesto estatal sobre nómina por pagar', '213.04Im', 3310, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 332, 213.05, 'Impuesto estatal y municipal por pagar', '213.05Im', 3320, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 333, 213.06, 'Derechos por pagar', '213.06De', 3330, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 334, 213.07, 'Otros impuestos por pagar', '213.07Ot', 3340, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 335, 214, 'Dividendos por pagar', '214Di', 3350, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 336, 214.01, 'Dividendos por pagar', '214.01Di', 3360, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 337, 215, 'PTU por pagar', '215PT', 3370, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 338, 215.01, 'PTU por pagar', '215.01PT', 3380, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 339, 215.02, 'PTU por pagar de ejercicios anteriores', '215.02PT', 3390, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 340, 215.03, 'Provisión de PTU por pagar', '215.03Pr', 3400, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 341, 216, 'Impuestos retenidos', '216Im', 3410, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 342, 216.01, 'Impuestos retenidos de ISR por sueldos y salarios', '216.01Im', 3420, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 343, 216.02, 'Impuestos retenidos de ISR por asimilados a salarios', '216.02Im', 3430, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 344, 216.03, 'Impuestos retenidos de ISR por arrendamiento', '216.03Im', 3440, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 345, 216.04, 'Impuestos retenidos de ISR por servicios profesionales', '216.04Im', 3450, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 346, 216.05, 'Impuestos retenidos de ISR por dividendos', '216.05Im', 3460, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 347, 216.06, 'Impuestos retenidos de ISR por intereses', '216.06Im', 3470, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 348, 216.07, 'Impuestos retenidos de ISR por pagos al extranjero', '216.07Im', 3480, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 349, 216.08, 'Impuestos retenidos de ISR por venta de acciones', '216.08Im', 3490, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 350, 216.09, 'Impuestos retenidos de ISR por venta de partes sociales', '216.09Im', 3500, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 351, 216.1, 'Impuestos retenidos de IVA', '216.1Im', 3510, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 352, 216.11, 'Retenciones de IMSS a los trabajadores', '216.11Re', 3520, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 353, 216.12, 'Otras impuestos retenidos', '216.12Ot', 3530, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 354, 217, 'Pagos realizados por cuenta de terceros', '217Pa', 3540, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 355, 217.01, 'Pagos realizados por cuenta de terceros', '217.01Pa', 3550, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 356, 218, 'Otros pasivos a corto plazo', '218Ot', 3560, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 357, 218.01, 'Otros pasivos a corto plazo', '218.01Ot', 3570, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 358, 200.02, 'Pasivo a largo plazo', '200.02Pa', 3580, 'S/C', 1, 0
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 359, 251, 'Acreedores diversos a largo plazo', '251Ac', 3590, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 360, 251.01, 'Socios, accionistas o representante legal', '251.01So', 3600, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 361, 251.02, 'Acreedores diversos a largo plazo nacional', '251.02Ac', 3610, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 362, 251.03, 'Acreedores diversos a largo plazo extranjero', '251.03Ac', 3620, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 363, 251.04, 'Acreedores diversos a largo plazo nacional parte relacionada', '251.04Ac', 3630, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 364, 251.05, 'Acreedores diversos a largo plazo extranjero parte relacionada', '251.05Ac', 3640, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 365, 251.06, 'Otros acreedores diversos a largo plazo', '251.06Ot', 3650, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 366, 252, 'Cuentas por pagar a largo plazo', '252Cu', 3660, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 367, 252.01, 'Documentos bancarios y financieros por pagar a largo plazo nacional', '252.01Do', 3670, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 368, 252.02, 'Documentos bancarios y financieros por pagar a largo plazo extranjero', '252.02Do', 3680, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 369, 252.03, 'Documentos y cuentas por pagar a largo plazo nacional', '252.03Do', 3690, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 370, 252.04, 'Documentos y cuentas por pagar a largo plazo extranjero', '252.04Do', 3700, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 371, 252.05, 'Documentos y cuentas por pagar a largo plazo nacional parte relacionada', '252.05Do', 3710, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 372, 252.06, 'Documentos y cuentas por pagar a largo plazo extranjero parte relacionada', '252.06Do', 3720, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 373, 252.07, 'Hipotecas por pagar a largo plazo nacional', '252.07Hi', 3730, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 374, 252.08, 'Hipotecas por pagar a largo plazo extranjero', '252.08Hi', 3740, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 375, 252.09, 'Hipotecas por pagar a largo plazo nacional parte relacionada', '252.09Hi', 3750, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 376, 252.1, 'Hipotecas por pagar a largo plazo extranjero parte relacionada', '252.1Hi', 3760, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 377, 252.11, 'Intereses por pagar a largo plazo nacional', '252.11In', 3770, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 378, 252.12, 'Intereses por pagar a largo plazo extranjero', '252.12In', 3780, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 379, 252.13, 'Intereses por pagar a largo plazo nacional parte relacionada', '252.13In', 3790, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 380, 252.14, 'Intereses por pagar a largo plazo extranjero parte relacionada', '252.14In', 3800, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 381, 252.15, 'Dividendos por pagar nacionales', '252.15Di', 3810, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 382, 252.16, 'Dividendos por pagar extranjeros', '252.16Di', 3820, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 383, 252.17, 'Otras cuentas y documentos por pagar a largo plazo', '252.17Ot', 3830, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 384, 253, 'Cobros anticipados a largo plazo', '253Co', 3840, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 385, 253.01, 'Rentas cobradas por anticipado a largo plazo nacional', '253.01Re', 3850, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 386, 253.02, 'Rentas cobradas por anticipado a largo plazo extranjero', '253.02Re', 3860, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 387, 253.03, 'Rentas cobradas por anticipado a largo plazo nacional parte relacionada', '253.03Re', 3870, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 388, 253.04, 'Rentas cobradas por anticipado a largo plazo extranjero parte relacionada', '253.04Re', 3880, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 389, 253.05, 'Intereses cobrados por anticipado a largo plazo nacional', '253.05In', 3890, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 390, 253.06, 'Intereses cobrados por anticipado a largo plazo extranjero', '253.06In', 3900, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 391, 253.07, 'Intereses cobrados por anticipado a largo plazo nacional parte relacionada', '253.07In', 3910, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 392, 253.08, 'Intereses cobrados por anticipado a largo plazo extranjero parte relacionada', '253.08In', 3920, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 393, 253.09, 'Factoraje financiero cobrados por anticipado a largo plazo nacional', '253.09Fa', 3930, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 394, 253.1, 'Factoraje financiero cobrados por anticipado a largo plazo extranjero', '253.1Fa', 3940, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 395, 253.11, 'Factoraje financiero cobrados por anticipado a largo plazo nacional parte relacionada', '253.11Fa', 3950, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 396, 253.12, 'Factoraje financiero cobrados por anticipado a largo plazo extranjero parte relacionada', '253.12Fa', 3960, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 397, 253.13, 'Arrendamiento financiero cobrados por anticipado a largo plazo nacional', '253.13Ar', 3970, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 398, 253.14, 'Arrendamiento financiero cobrados por anticipado a largo plazo extranjero', '253.14Ar', 3980, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 399, 253.15, 'Arrendamiento financiero cobrados por anticipado a largo plazo nacional parte relacionada', '253.15Ar', 3990, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 400, 253.16, 'Arrendamiento financiero cobrados por anticipado a largo plazo extranjero parte relacionada', '253.16Ar', 4000, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 401, 253.17, 'Derechos fiduciarios', '253.17De', 4010, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 402, 253.18, 'Otros cobros anticipados', '253.18Ot', 4020, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 403, 254, 'Instrumentos financieros a largo plazo', '254In', 4030, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 404, 254.01, 'Instrumentos financieros a largo plazo', '254.01In', 4040, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 405, 255, 'Pasivos por beneficios a los empleados a largo plazo', '255Pa', 4050, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 406, 255.01, 'Pasivos por beneficios a los empleados a largo plazo', '255.01Pa', 4060, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 407, 256, 'Otros pasivos a largo plazo', '256Ot', 4070, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 408, 256.01, 'Otros pasivos a largo plazo', '256.01Ot', 4080, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 409, 257, 'Participación de los trabajadores en las utilidades diferida', '257Pa', 4090, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 410, 257.01, 'Participación de los trabajadores en las utilidades diferida', '257.01Pa', 4100, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 411, 258, 'Obligaciones contraídas de fideicomisos', '258Ob', 4110, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 412, 258.01, 'Obligaciones contraídas de fideicomisos', '258.01Ob', 4120, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 413, 259, 'Impuestos diferidos', '259Im', 4130, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 414, 259.01, 'ISR diferido', '259.01IS', 4140, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 415, 259.02, 'ISR por dividendo diferido', '259.02IS', 4150, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 416, 259.03, 'Otros impuestos diferidos', '259.03Ot', 4160, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 417, 260, 'Pasivos diferidos', '260Pa', 4170, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 418, 260.01, 'Pasivos diferidos', '260.01Pa', 4180, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 419, 300, 'Capital contable', '300Ca', 4190, 'S/C', 1, 0
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 420, 301, 'Capital social', '301Ca', 4200, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 421, 301.01, 'Capital fijo', '301.01Ca', 4210, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 422, 301.02, 'Capital variable', '301.02Ca', 4220, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 423, 301.03, 'Aportaciones para futuros aumentos de capital', '301.03Ap', 4230, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 424, 301.04, 'Prima en suscripción de acciones', '301.04Pr', 4240, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 425, 301.05, 'Prima en suscripción de partes sociales', '301.05Pr', 4250, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 426, 302, 'Patrimonio', '302Pa', 4260, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 427, 302.01, 'Patrimonio', '302.01Pa', 4270, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 428, 302.02, 'Aportación patrimonial', '302.02Ap', 4280, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 429, 302.03, 'Déficit o remanente del ejercicio', '302.03Dé', 4290, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 430, 303, 'Reserva legal', '303Re', 4300, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 431, 303.01, 'Reserva legal', '303.01Re', 4310, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 432, 304, 'Resultado de ejercicios anteriores', '304Re', 4320, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 433, 304.01, 'Utilidad de ejercicios anteriores', '304.01Ut', 4330, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 434, 304.02, 'Pérdida de ejercicios anteriores', '304.02Pé', 4340, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 435, 304.03, 'Resultado integral de ejercicios anteriores', '304.03Re', 4350, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 436, 304.04, 'Déficit o remanente de ejercicio anteriores', '304.04Dé', 4360, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 437, 305, 'Resultado del ejercicio', '305Re', 4370, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 438, 305.01, 'Utilidad del ejercicio', '305.01Ut', 4380, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 439, 305.02, 'Pérdida del ejercicio', '305.02Pé', 4390, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 440, 305.03, 'Resultado integral', '305.03Re', 4400, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 441, 306, 'Otras cuentas de capital', '306Ot', 4410, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 442, 306.01, 'Otras cuentas de capital', '306.01Ot', 4420, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 443, 400, 'Ingresos', '400In', 4430, 'S/C', 1, 0
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 444, 401, 'Ingresos', '401In', 4440, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 445, 401.01, 'Ventas y/o servicios gravados a la tasa general', '401.01Ve', 4450, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 446, 401.02, 'Ventas y/o servicios gravados a la tasa general de contado', '401.02Ve', 4460, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 447, 401.03, 'Ventas y/o servicios gravados a la tasa general a crédito', '401.03Ve', 4470, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 448, 401.04, 'Ventas y/o servicios gravados al 0%', '401.04Ve', 4480, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 449, 401.05, 'Ventas y/o servicios gravados al 0% de contado', '401.05Ve', 4490, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 450, 401.06, 'Ventas y/o servicios gravados al 0% a crédito', '401.06Ve', 4500, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 451, 401.07, 'Ventas y/o servicios exentos', '401.07Ve', 4510, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 452, 401.08, 'Ventas y/o servicios exentos de contado', '401.08Ve', 4520, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 453, 401.09, 'Ventas y/o servicios exentos a crédito', '401.09Ve', 4530, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 454, 401.1, 'Ventas y/o servicios gravados a la tasa general nacionales partes relacionadas', '401.1Ve', 4540, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 455, 401.11, 'Ventas y/o servicios gravados a la tasa general extranjeros partes relacionadas', '401.11Ve', 4550, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 456, 401.12, 'Ventas y/o servicios gravados al 0% nacionales partes relacionadas', '401.12Ve', 4560, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 457, 401.13, 'Ventas y/o servicios gravados al 0% extranjeros partes relacionadas', '401.13Ve', 4570, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 458, 401.14, 'Ventas y/o servicios exentos nacionales partes relacionadas', '401.14Ve', 4580, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 459, 401.15, 'Ventas y/o servicios exentos extranjeros partes relacionadas', '401.15Ve', 4590, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 460, 401.16, 'Ingresos por servicios administrativos', '401.16In', 4600, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 461, 401.17, 'Ingresos por servicios administrativos nacionales partes relacionadas', '401.17In', 4610, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 462, 401.18, 'Ingresos por servicios administrativos extranjeros partes relacionadas', '401.18In', 4620, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 463, 401.19, 'Ingresos por servicios profesionales', '401.19In', 4630, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 464, 401.2, 'Ingresos por servicios profesionales nacionales partes relacionadas', '401.2In', 4640, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 465, 401.21, 'Ingresos por servicios profesionales extranjeros partes relacionadas', '401.21In', 4650, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 466, 401.22, 'Ingresos por arrendamiento', '401.22In', 4660, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 467, 401.23, 'Ingresos por arrendamiento nacionales partes relacionadas', '401.23In', 4670, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 468, 401.24, 'Ingresos por arrendamiento extranjeros partes relacionadas', '401.24In', 4680, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 469, 401.25, 'Ingresos por exportación', '401.25In', 4690, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 470, 401.26, 'Ingresos por comisiones', '401.26In', 4700, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 471, 401.27, 'Ingresos por maquila', '401.27In', 4710, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 472, 401.28, 'Ingresos por coordinados', '401.28In', 4720, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 473, 401.29, 'Ingresos por regalías', '401.29In', 4730, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 474, 401.3, 'Ingresos por asistencia técnica', '401.3In', 4740, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 475, 401.31, 'Ingresos por donativos', '401.31In', 4750, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 476, 401.32, 'Ingresos por intereses (actividad propia)', '401.32In', 4760, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 477, 401.33, 'Ingresos de copropiedad', '401.33In', 4770, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 478, 401.34, 'Ingresos por fideicomisos', '401.34In', 4780, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 479, 401.35, 'Ingresos por factoraje financiero', '401.35In', 4790, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 480, 401.36, 'Ingresos por arrendamiento financiero', '401.36In', 4800, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 481, 401.37, 'Ingresos de extranjeros con establecimiento en el país', '401.37In', 4810, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 482, 401.38, 'Otros ingresos propios', '401.38Ot', 4820, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 483, 402, 'Devoluciones, descuentos o bonificaciones sobre ingresos', '402De', 4830, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 484, 402.01, 'Devoluciones, descuentos o bonificaciones sobre ventas y/o servicios a la tasa general', '402.01De', 4840, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 485, 402.02, 'Devoluciones, descuentos o bonificaciones sobre ventas y/o servicios al 0%', '402.02De', 4850, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 486, 402.03, 'Devoluciones, descuentos o bonificaciones sobre ventas y/o servicios exentos', '402.03De', 4860, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 487, 402.04, 'Devoluciones, descuentos o bonificaciones de otros ingresos', '402.04De', 4870, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 488, 403, 'Otros ingresos', '403Ot', 4880, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 489, 403.01, 'Otros Ingresos', '403.01Ot', 4890, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 490, 403.02, 'Otros ingresos nacionales parte relacionada', '403.02Ot', 4900, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 491, 403.03, 'Otros ingresos extranjeros parte relacionada', '403.03Ot', 4910, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 492, 403.04, 'Ingresos por operaciones discontinuas', '403.04In', 4920, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 493, 403.05, 'Ingresos por condonación de adeudo', '403.05In', 4930, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 494, 500, 'Costos', '500Co', 4940, 'S/C', 1, 0
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 495, 501, 'Costo de venta y/o servicio', '501Co', 4950, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 496, 501.01, 'Costo de venta', '501.01Co', 4960, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 497, 501.02, 'Costo de servicios (Mano de obra)', '501.02Co', 4970, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 498, 501.03, 'Materia prima directa utilizada para la producción', '501.03Ma', 4980, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 499, 501.04, 'Materia prima consumida en el proceso productivo', '501.04Ma', 4990, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 500, 501.05, 'Mano de obra directa consumida', '501.05Ma', 5000, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 501, 501.06, 'Mano de obra directa', '501.06Ma', 5010, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 502, 501.07, 'Cargos indirectos de producción', '501.07Ca', 5020, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 503, 501.08, 'Otros conceptos de costo', '501.08Ot', 5030, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 504, 502, 'Compras', '502Co', 5040, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 505, 502.01, 'Compras nacionales', '502.01Co', 5050, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 506, 502.02, 'Compras nacionales parte relacionada', '502.02Co', 5060, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 507, 502.03, 'Compras de Importación', '502.03Co', 5070, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 508, 502.04, 'Compras de Importación partes relacionadas', '502.04Co', 5080, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 509, 503, 'Devoluciones, descuentos o bonificaciones sobre compras', '503De', 5090, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 510, 503.01, 'Devoluciones, descuentos o bonificaciones sobre compras', '503.01De', 5100, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 511, 504, 'Otras cuentas de costos', '504Ot', 5110, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 512, 504.01, 'Gastos indirectos de fabricación', '504.01Ga', 5120, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 513, 504.02, 'Gastos indirectos de fabricación de partes relacionadas nacionales', '504.02Ga', 5130, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 514, 504.03, 'Gastos indirectos de fabricación de partes relacionadas extranjeras', '504.03Ga', 5140, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 515, 504.04, 'Otras cuentas de costos incurridos', '504.04Ot', 5150, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 516, 504.05, 'Otras cuentas de costos incurridos con partes relacionadas nacionales', '504.05Ot', 5160, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 517, 504.06, 'Otras cuentas de costos incurridos con partes relacionadas extranjeras', '504.06Ot', 5170, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 518, 504.07, 'Depreciación de edificios', '504.07De', 5180, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 519, 504.08, 'Depreciación de maquinaria y equipo', '504.08De', 5190, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 520, 504.09, 'Depreciación de automóviles, autobuses, camiones de carga, tractocamiones, montacargas yremolques', '504.09De', 5200, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 521, 504.1, 'Depreciación de mobiliario y equipo de oficina', '504.1De', 5210, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 522, 504.11, 'Depreciación de equipo de cómputo', '504.11De', 5220, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 523, 504.12, 'Depreciación de equipo de comunicación', '504.12De', 5230, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 524, 504.13, 'Depreciación de activos biológicos, vegetales y semovientes', '504.13De', 5240, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 525, 504.14, 'Depreciación de otros activos fijos', '504.14De', 5250, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 526, 504.15, 'Depreciación de ferrocarriles', '504.15De', 5260, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 527, 504.16, 'Depreciación de embarcaciones', '504.16De', 5270, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 528, 504.17, 'Depreciación de aviones', '504.17De', 5280, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 529, 504.18, 'Depreciación de troqueles, moldes, matrices y herramental', '504.18De', 5290, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 530, 504.19, 'Depreciación de equipo de comunicaciones telefónicas', '504.19De', 5300, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 531, 504.2, 'Depreciación de equipo de comunicación satelital', '504.2De', 5310, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 532, 504.21, 'Depreciación de equipo de adaptaciones para personas con capacidades diferentes', '504.21De', 5320, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 533, 504.22, 'Depreciación de maquinaria y equipo de generación de energía de fuentes renovables o desistemas de cogeneración de electricidad eficiente', '504.22De', 5330, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 534, 504.23, 'Depreciación de adaptaciones y mejoras', '504.23De', 5340, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 535, 504.24, 'Depreciación de otra maquinaria y equipo', '504.24De', 5350, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 536, 504.25, 'Otras cuentas de costos', '504.25Ot', 5360, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 537, 505, 'Costo de activo fijo', '505Co', 5370, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 538, 505.01, 'Costo por venta de activo fijo', '505.01Co', 5380, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 539, 505.02, 'Costo por baja de activo fijo', '505.02Co', 5390, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 540, 600, 'Gastos', '600Ga', 5400, 'S/C', 1, 0
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 541, 601, 'Gastos generales', '601Ga', 5410, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 542, 601.01, 'Sueldos y salarios', '601.01Su', 5420, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 543, 601.02, 'Compensaciones', '601.02Co', 5430, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 544, 601.03, 'Tiempos extras', '601.03Ti', 5440, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 545, 601.04, 'Premios de asistencia', '601.04Pr', 5450, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 546, 601.05, 'Premios de puntualidad', '601.05Pr', 5460, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 547, 601.06, 'Vacaciones', '601.06Va', 5470, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 548, 601.07, 'Prima vacacional', '601.07Pr', 5480, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 549, 601.08, 'Prima dominical', '601.08Pr', 5490, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 550, 601.09, 'Días festivos', '601.09Dí', 5500, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 551, 601.1, 'Gratificaciones', '601.1Gr', 5510, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 552, 601.11, 'Primas de antigüedad', '601.11Pr', 5520, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 553, 601.12, 'Aguinaldo', '601.12Ag', 5530, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 554, 601.13, 'Indemnizaciones', '601.13In', 5540, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 555, 601.14, 'Destajo', '601.14De', 5550, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 556, 601.15, 'Despensa', '601.15De', 5560, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 557, 601.16, 'Transporte', '601.16Tr', 5570, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 558, 601.17, 'Servicio médico', '601.17Se', 5580, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 559, 601.18, 'Ayuda en gastos funerarios', '601.18Ay', 5590, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 560, 601.19, 'Fondo de ahorro', '601.19Fo', 5600, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 561, 601.2, 'Cuotas sindicales', '601.2Cu', 5610, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 562, 601.21, 'PTU', '601.21PT', 5620, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 563, 601.22, 'Estímulo al personal', '601.22Es', 5630, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 564, 601.23, 'Previsión social', '601.23Pr', 5640, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 565, 601.24, 'Aportaciones para el plan de jubilación', '601.24Ap', 5650, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 566, 601.25, 'Otras prestaciones al personal', '601.25Ot', 5660, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 567, 601.26, 'Cuotas al IMSS', '601.26Cu', 5670, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 568, 601.27, 'Aportaciones al infonavit', '601.27Ap', 5680, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 569, 601.28, 'Aportaciones al SAR', '601.28Ap', 5690, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 570, 601.29, 'Impuesto estatal sobre nóminas', '601.29Im', 5700, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 571, 601.3, 'Otras aportaciones', '601.3Ot', 5710, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 572, 601.31, 'Asimilados a salarios', '601.31As', 5720, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 573, 601.32, 'Servicios administrativos', '601.32Se', 5730, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 574, 601.33, 'Servicios administrativos partes relacionadas', '601.33Se', 5740, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 575, 601.34, 'Honorarios a personas físicas residentes nacionales', '601.34Ho', 5750, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 576, 601.35, 'Honorarios a personas físicas residentes nacionales partes relacionadas', '601.35Ho', 5760, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 577, 601.36, 'Honorarios a personas físicas residentes del extranjero', '601.36Ho', 5770, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 578, 601.37, 'Honorarios a personas físicas residentes del extranjero partes relacionadas', '601.37Ho', 5780, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 579, 601.38, 'Honorarios a personas morales residentes nacionales', '601.38Ho', 5790, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 580, 601.39, 'Honorarios a personas morales residentes nacionales partes relacionadas', '601.39Ho', 5800, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 581, 601.4, 'Honorarios a personas morales residentes del extranjero', '601.4Ho', 5810, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 582, 601.41, 'Honorarios a personas morales residentes del extranjero partes relacionadas', '601.41Ho', 5820, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 583, 601.42, 'Honorarios aduanales personas físicas', '601.42Ho', 5830, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 584, 601.43, 'Honorarios aduanales personas morales', '601.43Ho', 5840, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 585, 601.44, 'Honorarios al consejo de administración', '601.44Ho', 5850, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 586, 601.45, 'Arrendamiento a personas físicas residentes nacionales', '601.45Ar', 5860, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 587, 601.46, 'Arrendamiento a personas morales residentes nacionales', '601.46Ar', 5870, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 588, 601.47, 'Arrendamiento a residentes del extranjero', '601.47Ar', 5880, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 589, 601.48, 'Combustibles y lubricantes', '601.48Co', 5890, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 590, 601.49, 'Viáticos y gastos de viaje', '601.49Vi', 5900, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 591, 601.5, 'Teléfono, internet', '601.5Te', 5910, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 592, 601.51, 'Agua', '601.51Ag', 5920, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 593, 601.52, 'Energía eléctrica', '601.52En', 5930, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 594, 601.53, 'Vigilancia y seguridad', '601.53Vi', 5940, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 595, 601.54, 'Limpieza', '601.54Li', 5950, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 596, 601.55, 'Papelería y artículos de oficina', '601.55Pa', 5960, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 597, 601.56, 'Mantenimiento y conservación', '601.56Ma', 5970, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 598, 601.57, 'Seguros y fianzas', '601.57Se', 5980, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 599, 601.58, 'Otros impuestos y derechos', '601.58Ot', 5990, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 600, 601.59, 'Recargos fiscales', '601.59Re', 6000, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 601, 601.6, 'Cuotas y suscripciones', '601.6Cu', 6010, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 602, 601.61, 'Propaganda y publicidad', '601.61Pr', 6020, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 603, 601.62, 'Capacitación al personal', '601.62Ca', 6030, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 604, 601.63, 'Donativos y ayudas', '601.63Do', 6040, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 605, 601.64, 'Asistencia técnica', '601.64As', 6050, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 606, 601.65, 'Regalías sujetas a otros porcentajes', '601.65Re', 6060, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 607, 601.66, 'Regalías sujetas al 5%', '601.66Re', 6070, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 608, 601.67, 'Regalías sujetas al 10%', '601.67Re', 6080, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 609, 601.68, 'Regalías sujetas al 15%', '601.68Re', 6090, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 610, 601.69, 'Regalías sujetas al 25%', '601.69Re', 6100, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 611, 601.7, 'Regalías sujetas al 30%', '601.7Re', 6110, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 612, 601.71, 'Regalías sin retención', '601.71Re', 6120, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 613, 601.72, 'Fletes y acarreos', '601.72Fl', 6130, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 614, 601.73, 'Gastos de importación', '601.73Ga', 6140, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 615, 601.74, 'Comisiones sobre ventas', '601.74Co', 6150, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 616, 601.75, 'Comisiones por tarjetas de crédito', '601.75Co', 6160, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 617, 601.76, 'Patentes y marcas', '601.76Pa', 6170, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 618, 601.77, 'Uniformes', '601.77Un', 6180, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 619, 601.78, 'Prediales', '601.78Pr', 6190, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 620, 601.79, 'Gastos generales de urbanización', '601.79Ga', 6200, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 621, 601.8, 'Gastos generales de construcción', '601.8Ga', 6210, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 622, 601.81, 'Fletes del extranjero', '601.81Fl', 6220, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 623, 601.82, 'Recolección de bienes del sector agropecuario y/o ganadero', '601.82Re', 6230, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 624, 601.83, 'Gastos no deducibles (sin requisitos fiscales)', '601.83Ga', 6240, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 625, 601.84, 'Otros gastos generales', '601.84Ot', 6250, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 626, 602, 'Gastos de venta', '602Ga', 6260, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 627, 602.01, 'Sueldos y salarios', '602.01Su', 6270, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 628, 602.02, 'Compensaciones', '602.02Co', 6280, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 629, 602.03, 'Tiempos extras', '602.03Ti', 6290, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 630, 602.04, 'Premios de asistencia', '602.04Pr', 6300, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 631, 602.05, 'Premios de puntualidad', '602.05Pr', 6310, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 632, 602.06, 'Vacaciones', '602.06Va', 6320, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 633, 602.07, 'Prima vacacional', '602.07Pr', 6330, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 634, 602.08, 'Prima dominical', '602.08Pr', 6340, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 635, 602.09, 'Días festivos', '602.09Dí', 6350, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 636, 602.1, 'Gratificaciones', '602.1Gr', 6360, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 637, 602.11, 'Primas de antigüedad', '602.11Pr', 6370, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 638, 602.12, 'Aguinaldo', '602.12Ag', 6380, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 639, 602.13, 'Indemnizaciones', '602.13In', 6390, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 640, 602.14, 'Destajo', '602.14De', 6400, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 641, 602.15, 'Despensa', '602.15De', 6410, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 642, 602.16, 'Transporte', '602.16Tr', 6420, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 643, 602.17, 'Servicio médico', '602.17Se', 6430, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 644, 602.18, 'Ayuda en gastos funerarios', '602.18Ay', 6440, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 645, 602.19, 'Fondo de ahorro', '602.19Fo', 6450, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 646, 602.2, 'Cuotas sindicales', '602.2Cu', 6460, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 647, 602.21, 'PTU', '602.21PT', 6470, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 648, 602.22, 'Estímulo al personal', '602.22Es', 6480, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 649, 602.23, 'Previsión social', '602.23Pr', 6490, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 650, 602.24, 'Aportaciones para el plan de jubilación', '602.24Ap', 6500, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 651, 602.25, 'Otras prestaciones al personal', '602.25Ot', 6510, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 652, 602.26, 'Cuotas al IMSS', '602.26Cu', 6520, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 653, 602.27, 'Aportaciones al infonavit', '602.27Ap', 6530, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 654, 602.28, 'Aportaciones al SAR', '602.28Ap', 6540, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 655, 602.29, 'Impuesto estatal sobre nóminas', '602.29Im', 6550, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 656, 602.3, 'Otras aportaciones', '602.3Ot', 6560, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 657, 602.31, 'Asimilados a salarios', '602.31As', 6570, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 658, 602.32, 'Servicios administrativos', '602.32Se', 6580, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 659, 602.33, 'Servicios administrativos partes relacionadas', '602.33Se', 6590, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 660, 602.34, 'Honorarios a personas físicas residentes nacionales', '602.34Ho', 6600, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 661, 602.35, 'Honorarios a personas físicas residentes nacionales partes relacionadas', '602.35Ho', 6610, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 662, 602.36, 'Honorarios a personas físicas residentes del extranjero', '602.36Ho', 6620, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 663, 602.37, 'Honorarios a personas físicas residentes del extranjero partes relacionadas', '602.37Ho', 6630, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 664, 602.38, 'Honorarios a personas morales residentes nacionales', '602.38Ho', 6640, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 665, 602.39, 'Honorarios a personas morales residentes nacionales partes relacionadas', '602.39Ho', 6650, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 666, 602.4, 'Honorarios a personas morales residentes del extranjero', '602.4Ho', 6660, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 667, 602.41, 'Honorarios a personas morales residentes del extranjero partes relacionadas', '602.41Ho', 6670, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 668, 602.42, 'Honorarios aduanales personas físicas', '602.42Ho', 6680, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 669, 602.43, 'Honorarios aduanales personas morales', '602.43Ho', 6690, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 670, 602.44, 'Honorarios al consejo de administración', '602.44Ho', 6700, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 671, 602.45, 'Arrendamiento a personas físicas residentes nacionales', '602.45Ar', 6710, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 672, 602.46, 'Arrendamiento a personas morales residentes nacionales', '602.46Ar', 6720, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 673, 602.47, 'Arrendamiento a residentes del extranjero', '602.47Ar', 6730, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 674, 602.48, 'Combustibles y lubricantes', '602.48Co', 6740, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 675, 602.49, 'Viáticos y gastos de viaje', '602.49Vi', 6750, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 676, 602.5, 'Teléfono, internet', '602.5Te', 6760, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 677, 602.51, 'Agua', '602.51Ag', 6770, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 678, 602.52, 'Energía eléctrica', '602.52En', 6780, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 679, 602.53, 'Vigilancia y seguridad', '602.53Vi', 6790, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 680, 602.54, 'Limpieza', '602.54Li', 6800, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 681, 602.55, 'Papelería y artículos de oficina', '602.55Pa', 6810, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 682, 602.56, 'Mantenimiento y conservación', '602.56Ma', 6820, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 683, 602.57, 'Seguros y fianzas', '602.57Se', 6830, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 684, 602.58, 'Otros impuestos y derechos', '602.58Ot', 6840, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 685, 602.59, 'Recargos fiscales', '602.59Re', 6850, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 686, 602.6, 'Cuotas y suscripciones', '602.6Cu', 6860, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 687, 602.61, 'Propaganda y publicidad', '602.61Pr', 6870, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 688, 602.62, 'Capacitación al personal', '602.62Ca', 6880, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 689, 602.63, 'Donativos y ayudas', '602.63Do', 6890, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 690, 602.64, 'Asistencia técnica', '602.64As', 6900, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 691, 602.65, 'Regalías sujetas a otros porcentajes', '602.65Re', 6910, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 692, 602.66, 'Regalías sujetas al 5%', '602.66Re', 6920, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 693, 602.67, 'Regalías sujetas al 10%', '602.67Re', 6930, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 694, 602.68, 'Regalías sujetas al 15%', '602.68Re', 6940, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 695, 602.69, 'Regalías sujetas al 25%', '602.69Re', 6950, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 696, 602.7, 'Regalías sujetas al 30%', '602.7Re', 6960, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 697, 602.71, 'Regalías sin retención', '602.71Re', 6970, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 698, 602.72, 'Fletes y acarreos', '602.72Fl', 6980, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 699, 602.73, 'Gastos de importación', '602.73Ga', 6990, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 700, 602.74, 'Comisiones sobre ventas', '602.74Co', 7000, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 701, 602.75, 'Comisiones por tarjetas de crédito', '602.75Co', 7010, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 702, 602.76, 'Patentes y marcas', '602.76Pa', 7020, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 703, 602.77, 'Uniformes', '602.77Un', 7030, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 704, 602.78, 'Prediales', '602.78Pr', 7040, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 705, 602.79, 'Gastos de venta de urbanización', '602.79Ga', 7050, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 706, 602.8, 'Gastos de venta de construcción', '602.8Ga', 7060, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 707, 602.81, 'Fletes del extranjero', '602.81Fl', 7070, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 708, 602.82, 'Recolección de bienes del sector agropecuario y/o ganadero', '602.82Re', 7080, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 709, 602.83, 'Gastos no deducibles (sin requisitos fiscales)', '602.83Ga', 7090, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 710, 602.84, 'Otros gastos de venta', '602.84Ot', 7100, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 711, 603, 'Gastos de administración', '603Ga', 7110, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 712, 603.01, 'Sueldos y salarios', '603.01Su', 7120, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 713, 603.02, 'Compensaciones', '603.02Co', 7130, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 714, 603.03, 'Tiempos extras', '603.03Ti', 7140, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 715, 603.04, 'Premios de asistencia', '603.04Pr', 7150, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 716, 603.05, 'Premios de puntualidad', '603.05Pr', 7160, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 717, 603.06, 'Vacaciones', '603.06Va', 7170, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 718, 603.07, 'Prima vacacional', '603.07Pr', 7180, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 719, 603.08, 'Prima dominical', '603.08Pr', 7190, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 720, 603.09, 'Días festivos', '603.09Dí', 7200, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 721, 603.1, 'Gratificaciones', '603.1Gr', 7210, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 722, 603.11, 'Primas de antigüedad', '603.11Pr', 7220, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 723, 603.12, 'Aguinaldo', '603.12Ag', 7230, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 724, 603.13, 'Indemnizaciones', '603.13In', 7240, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 725, 603.14, 'Destajo', '603.14De', 7250, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 726, 603.15, 'Despensa', '603.15De', 7260, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 727, 603.16, 'Transporte', '603.16Tr', 7270, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 728, 603.17, 'Servicio médico', '603.17Se', 7280, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 729, 603.18, 'Ayuda en gastos funerarios', '603.18Ay', 7290, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 730, 603.19, 'Fondo de ahorro', '603.19Fo', 7300, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 731, 603.2, 'Cuotas sindicales', '603.2Cu', 7310, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 732, 603.21, 'PTU', '603.21PT', 7320, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 733, 603.22, 'Estímulo al personal', '603.22Es', 7330, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 734, 603.23, 'Previsión social', '603.23Pr', 7340, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 735, 603.24, 'Aportaciones para el plan de jubilación', '603.24Ap', 7350, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 736, 603.25, 'Otras prestaciones al personal', '603.25Ot', 7360, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 737, 603.26, 'Cuotas al IMSS', '603.26Cu', 7370, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 738, 603.27, 'Aportaciones al infonavit', '603.27Ap', 7380, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 739, 603.28, 'Aportaciones al SAR', '603.28Ap', 7390, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 740, 603.29, 'Impuesto estatal sobre nóminas', '603.29Im', 7400, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 741, 603.3, 'Otras aportaciones', '603.3Ot', 7410, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 742, 603.31, 'Asimilados a salarios', '603.31As', 7420, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 743, 603.32, 'Servicios administrativos', '603.32Se', 7430, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 744, 603.33, 'Servicios administrativos partes relacionadas', '603.33Se', 7440, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 745, 603.34, 'Honorarios a personas físicas residentes nacionales', '603.34Ho', 7450, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 746, 603.35, 'Honorarios a personas físicas residentes nacionales partes relacionadas', '603.35Ho', 7460, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 747, 603.36, 'Honorarios a personas físicas residentes del extranjero', '603.36Ho', 7470, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 748, 603.37, 'Honorarios a personas físicas residentes del extranjero partes relacionadas', '603.37Ho', 7480, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 749, 603.38, 'Honorarios a personas morales residentes nacionales', '603.38Ho', 7490, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 750, 603.39, 'Honorarios a personas morales residentes nacionales partes relacionadas', '603.39Ho', 7500, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 751, 603.4, 'Honorarios a personas morales residentes del extranjero', '603.4Ho', 7510, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 752, 603.41, 'Honorarios a personas morales residentes del extranjero partes relacionadas', '603.41Ho', 7520, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 753, 603.42, 'Honorarios aduanales personas físicas', '603.42Ho', 7530, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 754, 603.43, 'Honorarios aduanales personas morales', '603.43Ho', 7540, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 755, 603.44, 'Honorarios al consejo de administración', '603.44Ho', 7550, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 756, 603.45, 'Arrendamiento a personas físicas residentes nacionales', '603.45Ar', 7560, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 757, 603.46, 'Arrendamiento a personas morales residentes nacionales', '603.46Ar', 7570, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 758, 603.47, 'Arrendamiento a residentes del extranjero', '603.47Ar', 7580, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 759, 603.48, 'Combustibles y lubricantes', '603.48Co', 7590, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 760, 603.49, 'Viáticos y gastos de viaje', '603.49Vi', 7600, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 761, 603.5, 'Teléfono, internet', '603.5Te', 7610, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 762, 603.51, 'Agua', '603.51Ag', 7620, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 763, 603.52, 'Energía eléctrica', '603.52En', 7630, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 764, 603.53, 'Vigilancia y seguridad', '603.53Vi', 7640, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 765, 603.54, 'Limpieza', '603.54Li', 7650, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 766, 603.55, 'Papelería y artículos de oficina', '603.55Pa', 7660, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 767, 603.56, 'Mantenimiento y conservación', '603.56Ma', 7670, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 768, 603.57, 'Seguros y fianzas', '603.57Se', 7680, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 769, 603.58, 'Otros impuestos y derechos', '603.58Ot', 7690, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 770, 603.59, 'Recargos fiscales', '603.59Re', 7700, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 771, 603.6, 'Cuotas y suscripciones', '603.6Cu', 7710, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 772, 603.61, 'Propaganda y publicidad', '603.61Pr', 7720, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 773, 603.62, 'Capacitación al personal', '603.62Ca', 7730, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 774, 603.63, 'Donativos y ayudas', '603.63Do', 7740, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 775, 603.64, 'Asistencia técnica', '603.64As', 7750, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 776, 603.65, 'Regalías sujetas a otros porcentajes', '603.65Re', 7760, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 777, 603.66, 'Regalías sujetas al 5%', '603.66Re', 7770, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 778, 603.67, 'Regalías sujetas al 10%', '603.67Re', 7780, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 779, 603.68, 'Regalías sujetas al 15%', '603.68Re', 7790, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 780, 603.69, 'Regalías sujetas al 25%', '603.69Re', 7800, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 781, 603.7, 'Regalías sujetas al 30%', '603.7Re', 7810, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 782, 603.71, 'Regalías sin retención', '603.71Re', 7820, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 783, 603.72, 'Fletes y acarreos', '603.72Fl', 7830, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 784, 603.73, 'Gastos de importación', '603.73Ga', 7840, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 785, 603.74, 'Patentes y marcas', '603.74Pa', 7850, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 786, 603.75, 'Uniformes', '603.75Un', 7860, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 787, 603.76, 'Prediales', '603.76Pr', 7870, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 788, 603.77, 'Gastos de administración de urbanización', '603.77Ga', 7880, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 789, 603.78, 'Gastos de administración de construcción', '603.78Ga', 7890, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 790, 603.79, 'Fletes del extranjero', '603.79Fl', 7900, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 791, 603.8, 'Recolección de bienes del sector agropecuario y/o ganadero', '603.8Re', 7910, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 792, 603.81, 'Gastos no deducibles (sin requisitos fiscales)', '603.81Ga', 7920, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 793, 603.82, 'Otros gastos de administración', '603.82Ot', 7930, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 794, 604, 'Gastos de fabricación', '604Ga', 7940, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 795, 604.01, 'Sueldos y salarios', '604.01Su', 7950, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 796, 604.02, 'Compensaciones', '604.02Co', 7960, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 797, 604.03, 'Tiempos extras', '604.03Ti', 7970, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 798, 604.04, 'Premios de asistencia', '604.04Pr', 7980, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 799, 604.05, 'Premios de puntualidad', '604.05Pr', 7990, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 800, 604.06, 'Vacaciones', '604.06Va', 8000, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 801, 604.07, 'Prima vacacional', '604.07Pr', 8010, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 802, 604.08, 'Prima dominical', '604.08Pr', 8020, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 803, 604.09, 'Días festivos', '604.09Dí', 8030, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 804, 604.1, 'Gratificaciones', '604.1Gr', 8040, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 805, 604.11, 'Primas de antigüedad', '604.11Pr', 8050, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 806, 604.12, 'Aguinaldo', '604.12Ag', 8060, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 807, 604.13, 'Indemnizaciones', '604.13In', 8070, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 808, 604.14, 'Destajo', '604.14De', 8080, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 809, 604.15, 'Despensa', '604.15De', 8090, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 810, 604.16, 'Transporte', '604.16Tr', 8100, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 811, 604.17, 'Servicio médico', '604.17Se', 8110, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 812, 604.18, 'Ayuda en gastos funerarios', '604.18Ay', 8120, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 813, 604.19, 'Fondo de ahorro', '604.19Fo', 8130, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 814, 604.2, 'Cuotas sindicales', '604.2Cu', 8140, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 815, 604.21, 'PTU', '604.21PT', 8150, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 816, 604.22, 'Estímulo al personal', '604.22Es', 8160, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 817, 604.23, 'Previsión social', '604.23Pr', 8170, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 818, 604.24, 'Aportaciones para el plan de jubilación', '604.24Ap', 8180, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 819, 604.25, 'Otras prestaciones al personal', '604.25Ot', 8190, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 820, 604.26, 'Cuotas al IMSS', '604.26Cu', 8200, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 821, 604.27, 'Aportaciones al infonavit', '604.27Ap', 8210, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 822, 604.28, 'Aportaciones al SAR', '604.28Ap', 8220, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 823, 604.29, 'Impuesto estatal sobre nóminas', '604.29Im', 8230, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 824, 604.3, 'Otras aportaciones', '604.3Ot', 8240, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 825, 604.31, 'Asimilados a salarios', '604.31As', 8250, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 826, 604.32, 'Servicios administrativos', '604.32Se', 8260, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 827, 604.33, 'Servicios administrativos partes relacionadas', '604.33Se', 8270, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 828, 604.34, 'Honorarios a personas físicas residentes nacionales', '604.34Ho', 8280, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 829, 604.35, 'Honorarios a personas físicas residentes nacionales partes relacionadas', '604.35Ho', 8290, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 830, 604.36, 'Honorarios a personas físicas residentes del extranjero', '604.36Ho', 8300, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 831, 604.37, 'Honorarios a personas físicas residentes del extranjero partes relacionadas', '604.37Ho', 8310, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 832, 604.38, 'Honorarios a personas morales residentes nacionales', '604.38Ho', 8320, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 833, 604.39, 'Honorarios a personas morales residentes nacionales partes relacionadas', '604.39Ho', 8330, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 834, 604.4, 'Honorarios a personas morales residentes del extranjero', '604.4Ho', 8340, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 835, 604.41, 'Honorarios a personas morales residentes del extranjero partes relacionadas', '604.41Ho', 8350, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 836, 604.42, 'Honorarios aduanales personas físicas', '604.42Ho', 8360, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 837, 604.43, 'Honorarios aduanales personas morales', '604.43Ho', 8370, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 838, 604.44, 'Honorarios al consejo de administración', '604.44Ho', 8380, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 839, 604.45, 'Arrendamiento a personas físicas residentes nacionales', '604.45Ar', 8390, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 840, 604.46, 'Arrendamiento a personas morales residentes nacionales', '604.46Ar', 8400, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 841, 604.47, 'Arrendamiento a residentes del extranjero', '604.47Ar', 8410, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 842, 604.48, 'Combustibles y lubricantes', '604.48Co', 8420, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 843, 604.49, 'Viáticos y gastos de viaje', '604.49Vi', 8430, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 844, 604.5, 'Teléfono, internet', '604.5Te', 8440, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 845, 604.51, 'Agua', '604.51Ag', 8450, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 846, 604.52, 'Energía eléctrica', '604.52En', 8460, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 847, 604.53, 'Vigilancia y seguridad', '604.53Vi', 8470, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 848, 604.54, 'Limpieza', '604.54Li', 8480, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 849, 604.55, 'Papelería y artículos de oficina', '604.55Pa', 8490, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 850, 604.56, 'Mantenimiento y conservación', '604.56Ma', 8500, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 851, 604.57, 'Seguros y fianzas', '604.57Se', 8510, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 852, 604.58, 'Otros impuestos y derechos', '604.58Ot', 8520, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 853, 604.59, 'Recargos fiscales', '604.59Re', 8530, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 854, 604.6, 'Cuotas y suscripciones', '604.6Cu', 8540, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 855, 604.61, 'Propaganda y publicidad', '604.61Pr', 8550, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 856, 604.62, 'Capacitación al personal', '604.62Ca', 8560, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 857, 604.63, 'Donativos y ayudas', '604.63Do', 8570, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 858, 604.64, 'Asistencia técnica', '604.64As', 8580, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 859, 604.65, 'Regalías sujetas a otros porcentajes', '604.65Re', 8590, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 860, 604.66, 'Regalías sujetas al 5%', '604.66Re', 8600, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 861, 604.67, 'Regalías sujetas al 10%', '604.67Re', 8610, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 862, 604.68, 'Regalías sujetas al 15%', '604.68Re', 8620, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 863, 604.69, 'Regalías sujetas al 25%', '604.69Re', 8630, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 864, 604.7, 'Regalías sujetas al 30%', '604.7Re', 8640, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 865, 604.71, 'Regalías sin retención', '604.71Re', 8650, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 866, 604.72, 'Fletes y acarreos', '604.72Fl', 8660, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 867, 604.73, 'Gastos de importación', '604.73Ga', 8670, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 868, 604.74, 'Patentes y marcas', '604.74Pa', 8680, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 869, 604.75, 'Uniformes', '604.75Un', 8690, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 870, 604.76, 'Prediales', '604.76Pr', 8700, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 871, 604.77, 'Gastos de fabricación de urbanización', '604.77Ga', 8710, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 872, 604.78, 'Gastos de fabricación de construcción', '604.78Ga', 8720, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 873, 604.79, 'Fletes del extranjero', '604.79Fl', 8730, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 874, 604.8, 'Recolección de bienes del sector agropecuario y/o ganadero', '604.8Re', 8740, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 875, 604.81, 'Gastos no deducibles (sin requisitos fiscales)', '604.81Ga', 8750, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 876, 604.82, 'Otros gastos de fabricación', '604.82Ot', 8760, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 877, 605, 'Mano de obra directa', '605Ma', 8770, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 878, 605.01, 'Mano de obra', '605.01Ma', 8780, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 879, 605.02, 'Sueldos y Salarios', '605.02Su', 8790, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 880, 605.03, 'Compensaciones', '605.03Co', 8800, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 881, 605.04, 'Tiempos extras', '605.04Ti', 8810, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 882, 605.05, 'Premios de asistencia', '605.05Pr', 8820, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 883, 605.06, 'Premios de puntualidad', '605.06Pr', 8830, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 884, 605.07, 'Vacaciones', '605.07Va', 8840, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 885, 605.08, 'Prima vacacional', '605.08Pr', 8850, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 886, 605.09, 'Prima dominical', '605.09Pr', 8860, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 887, 605.1, 'Días festivos', '605.1Dí', 8870, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 888, 605.11, 'Gratificaciones', '605.11Gr', 8880, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 889, 605.12, 'Primas de antigüedad', '605.12Pr', 8890, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 890, 605.13, 'Aguinaldo', '605.13Ag', 8900, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 891, 605.14, 'Indemnizaciones', '605.14In', 8910, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 892, 605.15, 'Destajo', '605.15De', 8920, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 893, 605.16, 'Despensa', '605.16De', 8930, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 894, 605.17, 'Transporte', '605.17Tr', 8940, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 895, 605.18, 'Servicio médico', '605.18Se', 8950, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 896, 605.19, 'Ayuda en gastos funerarios', '605.19Ay', 8960, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 897, 605.2, 'Fondo de ahorro', '605.2Fo', 8970, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 898, 605.21, 'Cuotas sindicales', '605.21Cu', 8980, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 899, 605.22, 'PTU', '605.22PT', 8990, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 900, 605.23, 'Estímulo al personal', '605.23Es', 9000, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 901, 605.24, 'Previsión social', '605.24Pr', 9010, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 902, 605.25, 'Aportaciones para el plan de jubilación', '605.25Ap', 9020, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 903, 605.26, 'Otras prestaciones al personal', '605.26Ot', 9030, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 904, 605.27, 'Asimilados a salarios', '605.27As', 9040, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 905, 605.28, 'Cuotas al IMSS', '605.28Cu', 9050, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 906, 605.29, 'Aportaciones al infonavit', '605.29Ap', 9060, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 907, 605.3, 'Aportaciones al SAR', '605.3Ap', 9070, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 908, 605.31, 'Otros costos de mano de obra directa', '605.31Ot', 9080, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 909, 606, 'Facilidades administrativas fiscales', '606Fa', 9090, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 910, 606.01, 'Facilidades administrativas fiscales', '606.01Fa', 9100, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 911, 607, 'Participación de los trabajadores en las utilidades', '607Pa', 9110, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 912, 607.01, 'Participación de los trabajadores en las utilidades', '607.01Pa', 9120, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 913, 608, 'Participación en resultados de subsidiarias', '608Pa', 9130, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 914, 608.01, 'Participación en resultados de subsidiarias', '608.01Pa', 9140, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 915, 609, 'Participación en resultados de asociadas', '609Pa', 9150, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 916, 609.01, 'Participación en resultados de asociadas', '609.01Pa', 9160, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 917, 610, 'Participación de los trabajadores en las utilidades diferida', '610Pa', 9170, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 918, 610.01, 'Participación de los trabajadores en las utilidades diferida', '610.01Pa', 9180, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 919, 611, 'Impuesto Sobre la renta', '611Im', 9190, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 920, 611.01, 'Impuesto Sobre la renta', '611.01Im', 9200, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 921, 611.02, 'Impuesto Sobre la renta por remanente distribuible', '611.02Im', 9210, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 922, 612, 'Gastos no deducibles para CUFIN', '612Ga', 9220, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 923, 612.01, 'Gastos no deducibles para CUFIN', '612.01Ga', 9230, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 924, 613, 'Depreciación contable', '613De', 9240, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 925, 613.01, 'Depreciación de edificios', '613.01De', 9250, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 926, 613.02, 'Depreciación de maquinaria y equipo', '613.02De', 9260, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 927, 613.03, 'Depreciación de automóviles, autobuses, camiones de carga, tractocamiones, montacargas yremolques', '613.03De', 9270, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 928, 613.04, 'Depreciación de mobiliario y equipo de oficina', '613.04De', 9280, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 929, 613.05, 'Depreciación de equipo de cómputo', '613.05De', 9290, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 930, 613.06, 'Depreciación de equipo de comunicación', '613.06De', 9300, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 931, 613.07, 'Depreciación de activos biológicos, vegetales y semovientes', '613.07De', 9310, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 932, 613.08, 'Depreciación de otros activos fijos', '613.08De', 9320, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 933, 613.09, 'Depreciación de ferrocarriles', '613.09De', 9330, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 934, 613.1, 'Depreciación de embarcaciones', '613.1De', 9340, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 935, 613.11, 'Depreciación de aviones', '613.11De', 9350, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 936, 613.12, 'Depreciación de troqueles, moldes, matrices y herramental', '613.12De', 9360, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 937, 613.13, 'Depreciación de equipo de comunicaciones telefónicas', '613.13De', 9370, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 938, 613.14, 'Depreciación de equipo de comunicación satelital', '613.14De', 9380, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 939, 613.15, 'Depreciación de equipo de adaptaciones para personas con capacidades diferentes', '613.15De', 9390, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 940, 613.16, 'Depreciación de maquinaria y equipo de generación de energía de fuentes renovables o desistemas de cogeneración de electricidad eficiente', '613.16De', 9400, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 941, 613.17, 'Depreciación de adaptaciones y mejoras', '613.17De', 9410, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 942, 613.18, 'Depreciación de otra maquinaria y equipo', '613.18De', 9420, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 943, 614, 'Amortización contable', '614Am', 9430, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 944, 614.01, 'Amortización de gastos diferidos', '614.01Am', 9440, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 945, 614.02, 'Amortización de gastos pre operativos', '614.02Am', 9450, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 946, 614.03, 'Amortización de regalías, asistencia técnica y otros gastos diferidos', '614.03Am', 9460, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 947, 614.04, 'Amortización de activos intangibles', '614.04Am', 9470, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 948, 614.05, 'Amortización de gastos de organización', '614.05Am', 9480, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 949, 614.06, 'Amortización de investigación y desarrollo de mercado', '614.06Am', 9490, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 950, 614.07, 'Amortización de marcas y patentes', '614.07Am', 9500, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 951, 614.08, 'Amortización de crédito mercantil', '614.08Am', 9510, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 952, 614.09, 'Amortización de gastos de instalación', '614.09Am', 9520, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 953, 614.1, 'Amortización de otros activos diferidos', '614.1Am', 9530, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 954, 700, 'Resultado integral de financiamiento', '700Re', 9540, 'S/C', 1, 0
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 955, 701, 'Gastos financieros', '701Ga', 9550, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 956, 701.01, 'Pérdida cambiaria', '701.01Pé', 9560, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 957, 701.02, 'Pérdida cambiaria nacional parte relacionada', '701.02Pé', 9570, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 958, 701.03, 'Pérdida cambiaria extranjero parte relacionada', '701.03Pé', 9580, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 959, 701.04, 'Intereses a cargo bancario nacional', '701.04In', 9590, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 960, 701.05, 'Intereses a cargo bancario extranjero', '701.05In', 9600, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 961, 701.06, 'Intereses a cargo de personas físicas nacional', '701.06In', 9610, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 962, 701.07, 'Intereses a cargo de personas físicas extranjero', '701.07In', 9620, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 963, 701.08, 'Intereses a cargo de personas morales nacional', '701.08In', 9630, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 964, 701.09, 'Intereses a cargo de personas morales extranjero', '701.09In', 9640, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 965, 701.1, 'Comisiones bancarias', '701.1Co', 9650, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 966, 701.11, 'Otros gastos financieros', '701.11Ot', 9660, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 967, 702, 'Productos financieros', '702Pr', 9670, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 968, 702.01, 'Utilidad cambiaria', '702.01Ut', 9680, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 969, 702.02, 'Utilidad cambiaria nacional parte relacionada', '702.02Ut', 9690, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 970, 702.03, 'Utilidad cambiaria extranjero parte relacionada', '702.03Ut', 9700, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 971, 702.04, 'Intereses a favor bancarios nacional', '702.04In', 9710, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 972, 702.05, 'Intereses a favor bancarios extranjero', '702.05In', 9720, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 973, 702.06, 'Intereses a favor de personas físicas nacional', '702.06In', 9730, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 974, 702.07, 'Intereses a favor de personas físicas extranjero', '702.07In', 9740, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 975, 702.08, 'Intereses a favor de personas morales nacional', '702.08In', 9750, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 976, 702.09, 'Intereses a favor de personas morales extranjero', '702.09In', 9760, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 977, 702.1, 'Otros productos financieros', '702.1Ot', 9770, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 978, 703, 'Otros gastos', '703Ot', 9780, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 979, 703.01, 'Pérdida en venta y/o baja de terrenos', '703.01Pé', 9790, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 980, 703.02, 'Pérdida en venta y/o baja de edificios', '703.02Pé', 9800, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 981, 703.03, 'Pérdida en venta y/o baja de maquinaria y equipo', '703.03Pé', 9810, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 982, 703.04, 'Pérdida en venta y/o baja de automóviles, autobuses, camiones de carga, tractocamiones,montacargas y remolques', '703.04Pé', 9820, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 983, 703.05, 'Pérdida en venta y/o baja de mobiliario y equipo de oficina', '703.05Pé', 9830, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 984, 703.06, 'Pérdida en venta y/o baja de equipo de cómputo', '703.06Pé', 9840, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 985, 703.07, 'Pérdida en venta y/o baja de equipo de comunicación', '703.07Pé', 9850, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 986, 703.08, 'Pérdida en venta y/o baja de activos biológicos, vegetales y semovientes', '703.08Pé', 9860, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 987, 703.09, 'Pérdida en venta y/o baja de otros activos fijos', '703.09Pé', 9870, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 988, 703.1, 'Pérdida en venta y/o baja de ferrocarriles', '703.1Pé', 9880, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 989, 703.11, 'Pérdida en venta y/o baja de embarcaciones', '703.11Pé', 9890, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 990, 703.12, 'Pérdida en venta y/o baja de aviones', '703.12Pé', 9900, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 991, 703.13, 'Pérdida en venta y/o baja de troqueles, moldes, matrices y herramental', '703.13Pé', 9910, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 992, 703.14, 'Pérdida en venta y/o baja de equipo de comunicaciones telefónicas', '703.14Pé', 9920, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 993, 703.15, 'Pérdida en venta y/o baja de equipo de comunicación satelital', '703.15Pé', 9930, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 994, 703.16, 'Pérdida en venta y/o baja de equipo de adaptaciones para personas con capacidades diferentes', '703.16Pé', 9940, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 995, 703.17, 'Pérdida en venta y/o baja de maquinaria y equipo de generación de energía de fuentes renovables o de sistemas de cogeneración de electricidad eficiente', '703.17Pé', 9950, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 996, 703.18, 'Pérdida en venta y/o baja de otra maquinaria y equipo', '703.18Pé', 9960, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 997, 703.19, 'Pérdida por enajenación de acciones', '703.19Pé', 9970, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 998, 703.2, 'Pérdida por enajenación de partes sociales', '703.2Pé', 9980, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 999, 703.21, 'Otros gastos', '703.21Ot', 9990, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1000, 704, 'Otros productos', '704Ot', 10000, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1001, 704.01, 'Ganancia en venta y/o baja de terrenos', '704.01Ga', 10010, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1002, 704.02, 'Ganancia en venta y/o baja de edificios', '704.02Ga', 10020, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1003, 704.03, 'Ganancia en venta y/o baja de maquinaria y equipo', '704.03Ga', 10030, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1004, 704.04, 'Ganancia en venta y/o baja de automóviles, autobuses, camiones de carga, tractocamiones,montacargas y remolques', '704.04Ga', 10040, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1005, 704.05, 'Ganancia en venta y/o baja de mobiliario y equipo de oficina', '704.05Ga', 10050, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1006, 704.06, 'Ganancia en venta y/o baja de equipo de cómputo', '704.06Ga', 10060, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1007, 704.07, 'Ganancia en venta y/o baja de equipo de comunicación', '704.07Ga', 10070, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1008, 704.08, 'Ganancia en venta y/o baja de activos biológicos, vegetales y semovientes', '704.08Ga', 10080, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1009, 704.09, 'Ganancia en venta y/o baja de otros activos fijos', '704.09Ga', 10090, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1010, 704.1, 'Ganancia en venta y/o baja de ferrocarriles', '704.1Ga', 10100, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1011, 704.11, 'Ganancia en venta y/o baja de embarcaciones', '704.11Ga', 10110, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1012, 704.12, 'Ganancia en venta y/o baja de aviones', '704.12Ga', 10120, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1013, 704.13, 'Ganancia en venta y/o baja de troqueles, moldes, matrices y herramental', '704.13Ga', 10130, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1014, 704.14, 'Ganancia en venta y/o baja de equipo de comunicaciones telefónicas', '704.14Ga', 10140, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1015, 704.15, 'Ganancia en venta y/o baja de equipo de comunicación satelital', '704.15Ga', 10150, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1016, 704.16, 'Ganancia en venta y/o baja de equipo de adaptaciones para personas con capacidades diferentes', '704.16Ga', 10160, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1017, 704.17, 'Ganancia en venta de maquinaria y equipo de generación de energía de fuentes renovables o de sistemas de cogeneración de electricidad eficiente', '704.17Ga', 10170, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1018, 704.18, 'Ganancia en venta y/o baja de otra maquinaria y equipo', '704.18Ga', 10180, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1019, 704.19, 'Ganancia por enajenación de acciones', '704.19Ga', 10190, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1020, 704.2, 'Ganancia por enajenación de partes sociales', '704.2Ga', 10200, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1021, 704.21, 'Ingresos por estímulos fiscales', '704.21In', 10210, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1022, 704.22, 'Ingresos por condonación de adeudo', '704.22In', 10220, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1023, 704.23, 'Otros productos', '704.23Ot', 10230, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1024, 800, 'Cuentas de orden', '800Cu', 10240, 'S/C', 1, 0
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1025, 801, 'UFIN del ejercicio', '801UF', 10250, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1026, 801.01, 'UFIN', '801.01UF', 10260, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1027, 801.02, 'Contra cuenta UFIN', '801.02Co', 10270, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1028, 802, 'CUFIN del ejercicio', '802CU', 10280, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1029, 802.01, 'CUFIN', '802.01CU', 10290, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1030, 802.02, 'Contra cuenta CUFIN', '802.02Co', 10300, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1031, 803, 'CUFIN de ejercicios anteriores', '803CU', 10310, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1032, 803.01, 'CUFIN de ejercicios anteriores', '803.01CU', 10320, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1033, 803.02, 'Contra cuenta CUFIN de ejercicios anteriores', '803.02Co', 10330, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1034, 804, 'CUFINRE del ejercicio', '804CU', 10340, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1035, 804.01, 'CUFINRE', '804.01CU', 10350, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1036, 804.02, 'Contra cuenta CUFINRE', '804.02Co', 10360, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1037, 805, 'CUFINRE de ejercicios anteriores', '805CU', 10370, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1038, 805.01, 'CUFINRE de ejercicios anteriores', '805.01CU', 10380, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1039, 805.02, 'Contra cuenta CUFINRE de ejercicios anteriores', '805.02Co', 10390, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1040, 806, 'CUCA del ejercicio', '806CU', 10400, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1041, 806.01, 'CUCA', '806.01CU', 10410, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1042, 806.02, 'Contra cuenta CUCA', '806.02Co', 10420, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1043, 807, 'CUCA de ejercicios anteriores', '807CU', 10430, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1044, 807.01, 'CUCA de ejercicios anteriores', '807.01CU', 10440, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1045, 807.02, 'Contra cuenta CUCA de ejercicios anteriores', '807.02Co', 10450, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1046, 808, 'Ajuste anual por inflación acumulable', '808Aj', 10460, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1047, 808.01, 'Ajuste anual por inflación acumulable', '808.01Aj', 10470, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1048, 808.02, 'Acumulación del ajuste anual inflacionario', '808.02Ac', 10480, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1049, 809, 'Ajuste anual por inflación deducible', '809Aj', 10490, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1050, 809.01, 'Ajuste anual por inflación deducible', '809.01Aj', 10500, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1051, 809.02, 'Deducción del ajuste anual inflacionario', '809.02De', 10510, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1052, 810, 'Deducción de inversión', '810De', 10520, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1053, 810.01, 'Deducción de inversión', '810.01De', 10530, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1054, 810.02, 'Contra cuenta deducción de inversiones', '810.02Co', 10540, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1055, 811, 'Utilidad o pérdida fiscal en venta y/o baja de activo fijo', '811Ut', 10550, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1056, 811.01, 'Utilidad o pérdida fiscal en venta y/o baja de activo fijo', '811.01Ut', 10560, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1057, 811.02, 'Contra cuenta utilidad o pérdida fiscal en venta y/o baja de activo fijo', '811.02Co', 10570, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1058, 812, 'Utilidad o pérdida fiscal en venta acciones o partes sociales', '812Ut', 10580, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1059, 812.01, 'Utilidad o pérdida fiscal en venta acciones o partes sociales', '812.01Ut', 10590, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1060, 812.02, 'Contra cuenta utilidad o pérdida fiscal en venta acciones o partes sociales', '812.02Co', 10600, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1061, 813, 'Pérdidas fiscales pendientes de amortizar actualizadas de ejercicios anteriores', '813Pé', 10610, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1062, 813.01, 'Pérdidas fiscales pendientes de amortizar actualizadas de ejercicios anteriores', '813.01Pé', 10620, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1063, 813.02, 'Actualización de pérdidas fiscales pendientes de amortizar de ejercicios anteriores', '813.02Ac', 10630, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1064, 814, 'Mercancías recibidas en consignación', '814Me', 10640, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1065, 814.01, 'Mercancías recibidas en consignación', '814.01Me', 10650, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1066, 814.02, 'Consignación de mercancías recibidas', '814.02Co', 10660, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1067, 815, 'Crédito fiscal de IVA e IEPS por la importación de mercancías para empresas certificadas', '815Cr', 10670, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1068, 815.01, 'Crédito fiscal de IVA e IEPS por la importación de mercancías', '815.01Cr', 10680, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1069, 815.02, 'Importación de mercancías con aplicación de crédito fiscal de IVA e IEPS', '815.02Im', 10690, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1070, 816, 'Crédito fiscal de IVA e IEPS por la importación de activos fijos para empresas certificadas', '816Cr', 10700, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1071, 816.01, 'Crédito fiscal de IVA e IEPS por la importación de activo fijo', '816.01Cr', 10710, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1072, 816.02, 'Importación de activo fijo con aplicación de crédito fiscal de IVA e IEPS', '816.02Im', 10720, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1073, 899, 'Otras cuentas de orden', '899Ot', 10730, 'S/C', 1, 1
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1074, 899.01, 'Otras cuentas de orden', '899.01Ot', 10740, 'S/C', 1, 2
EXECUTE [dbo].[PG_CI_SAT_AGRUPADOR] 0, 0, 0, 1075, 899.02, 'Contra cuenta otras cuentas de orden', '899.02Co', 10750, 'S/C', 1, 2


GO

-- ===============================================

SET NOCOUNT OFF







-- //////////////////////////////////////////////////////////////
--				SP  CARGA INICIAL	CUENTA CONTABLE							
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_CUENTA_CONTABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_CUENTA_CONTABLE]
GO


CREATE PROCEDURE [dbo].[PG_CI_CUENTA_CONTABLE]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==================================
	@PP_K_CUENTA_CONTABLE		INT,
	@PP_D_CUENTA_CONTABLE		VARCHAR(100),
	@PP_S_CUENTA_CONTABLE		VARCHAR(10),
	@PP_O_CUENTA_CONTABLE		INT,
	@PP_C_CUENTA_CONTABLE		VARCHAR(255),
	-- ==================================
	@PP_D_CUENTA_CONTABLE_2		VARCHAR (200),
	@PP_D_CUENTA_CONTABLE_3		VARCHAR (200), 
	-- ==================================
	@PP_CODIGO					VARCHAR (50),	
	@PP_L_AFECTABLE				INT,			
	@PP_L_PRESUPUESTO			INT,		
	@PP_L_ES_CUENTA_CONTABLE		INT,		
	@PP_K_NIVEL_CUENTA_CONTABLE	INT,	
	@PP_K_TIPO_CUENTA_CONTABLE	INT,	
	@PP_K_SAT_AGRUPADOR			INT
AS
	
	INSERT INTO CUENTA_CONTABLE
		(	K_CUENTA_CONTABLE,			D_CUENTA_CONTABLE, 			
			S_CUENTA_CONTABLE,			O_CUENTA_CONTABLE,
			C_CUENTA_CONTABLE,
			D_CUENTA_CONTABLE_2,		D_CUENTA_CONTABLE_3,
			CODIGO,						L_AFECTABLE,				
			L_PRESUPUESTO,				L_ES_CUENTA_CONTABLE,		
			K_NIVEL_CUENTA_CONTABLE,	K_TIPO_CUENTA_CONTABLE,
			K_SAT_AGRUPADOR,			
			K_USUARIO_CAMBIO,		F_CAMBIO,
			K_USUARIO_ALTA,			F_ALTA,
			L_BORRADO)							
	VALUES		
		(	@PP_K_CUENTA_CONTABLE,		@PP_D_CUENTA_CONTABLE,	
			@PP_S_CUENTA_CONTABLE,		@PP_O_CUENTA_CONTABLE,
			@PP_C_CUENTA_CONTABLE,
			@PP_D_CUENTA_CONTABLE_2,	@PP_D_CUENTA_CONTABLE_3,
			@PP_CODIGO,					@PP_L_AFECTABLE,
			@PP_L_PRESUPUESTO,			@PP_L_ES_CUENTA_CONTABLE,
			@PP_K_NIVEL_CUENTA_CONTABLE,@PP_K_TIPO_CUENTA_CONTABLE,
			@PP_K_SAT_AGRUPADOR,		
			@PP_K_USUARIO_ACCION,	GETDATE(),
			@PP_K_USUARIO_ACCION,	GETDATE(),
			0		)

	-- =========================================================
GO

-- ===============================================

SET NOCOUNT ON

-- ===============================================
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 1, 'A C T I V O', 'A C T', 10, 'S/C', '', '', '0001-00-0000', 0, 0, 1, 1, 1,0
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 2, 'C I R C U L A N T E', 'C I R', 20, 'S/C', '', '', '0010-00-0000', 0, 0, 1, 2, 1,0
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 3, 'CAJA', 'CAJA', 30, 'S/C', '', '', '1000-00-0000', 0, 0, 1, 3, 1,3
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 4, 'CAJA   M. N.', 'CAJA ', 40, 'S/C', '', '', '1000-01-0000', 0, 0, 1, 4, 1,3
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 5, 'CAJA CHICA', 'CAJA ', 50, 'S/C', '', '', '1000-01-0001', 1, 0, 1, 5, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 6, 'BANCOS', 'BANCO', 60, 'S/C', '', '', '1100-00-0000', 0, 0, 1, 3, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 7, 'BANCOMER S.A.', 'BANCO', 70, 'S/C', '', '', '1100-01-0000', 0, 0, 1, 4, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 8, 'CTA 010436662 DLLS', 'CTA 0', 80, 'S/C', '', '', '1100-01-0002', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 9, 'CTA 0447730-934', 'CTA 0', 90, 'S/C', '', '', '1100-01-0003', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 10, 'CTA - 0447730-985 Foinver', 'CTA -', 100, 'S/C', '', '', '1100-01-0004', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 11, 'CTA 0447730-926 (1025303-7)', 'CTA 0', 110, 'S/C', '', '', '1100-01-0005', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 12, 'CTA 0447730-969 (851279-0)', 'CTA 0', 120, 'S/C', '', '', '1100-01-0007', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 13, 'CTA 0447730-977 (Dlls)', 'CTA 0', 130, 'S/C', '', '', '1100-01-0008', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 14, 'CTA 0447730-993', 'CTA 0', 140, 'S/C', '', '', '1100-01-0009', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 15, 'CTA 0140539-953', 'CTA 0', 150, 'S/C', '', '', '1100-01-0010', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 16, 'CTA 0162231689', 'CTA 0', 160, 'S/C', '', '', '1100-01-0011', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 17, 'CTA 0160879703', 'CTA 0', 170, 'S/C', '', '', '1100-01-0012', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 18, 'CTA 0195973546', 'CTA 0', 180, 'S/C', '', '', '1100-01-0013', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 19, 'CTA. 0104249348', 'CTA. ', 190, 'S/C', '', '', '1100-01-0014', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 20, 'CTA. 0104356772', 'CTA. ', 200, 'S/C', '', '', '1100-01-0015', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 21, 'CTA 0106597750', 'CTA 0', 210, 'S/C', '', '', '1100-01-0016', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 22, 'CTA 0107755155', 'CTA 0', 220, 'S/C', '', '', '1100-01-0017', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 23, 'CTA 0110631043', 'CTA 0', 230, 'S/C', '', '', '1100-01-0018', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 24, 'CTA 0111333291', 'CTA 0', 240, 'S/C', '', '', '1100-01-0019', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 25, 'BANCO BILBAO VIZCAYA', 'BANCO', 250, 'S/C', '', '', '1100-03-0000', 0, 0, 1, 4, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 26, 'CTA 18116775-8  (Ingr)', 'CTA 1', 260, 'S/C', '', '', '1100-03-0007', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 27, 'BANCO INVERLAT', 'BANCO', 270, 'S/C', '', '', '1100-04-0000', 0, 0, 1, 4, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 28, 'CTA 0010190672-0  (Ingr)', 'CTA 0', 280, 'S/C', '', '', '1100-04-0001', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 29, 'CTA 0010190701-8  (Gastos)', 'CTA 0', 290, 'S/C', '', '', '1100-04-0002', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 30, 'CTA 2260332197-5 (Gtos Jrz)', 'CTA 2', 300, 'S/C', '', '', '1100-04-0003', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 31, 'CTA 768863 (Est.Carbn)', 'CTA 7', 310, 'S/C', '', '', '1100-04-0006', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 32, 'CTA 2260386802-8 (Gtos Tlahuac)', 'CTA 2', 320, 'S/C', '', '', '1100-04-0007', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 33, 'CTA 2260386838-9', 'CTA 2', 330, 'S/C', '', '', '1100-04-0008', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 34, 'CTA 106880665', 'CTA 1', 340, 'S/C', '', '', '1100-04-0010', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 35, 'CTA 2260363727-1  Pelicanos', 'CTA 2', 350, 'S/C', '', '', '1100-04-0011', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 36, 'CTA-22603837068', 'CTA-2', 360, 'S/C', '', '', '1100-04-0012', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 37, 'CTA 22603138968 (Gtos Toluca Jrz)', 'CTA 2', 370, 'S/C', '', '', '1100-04-0013', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 38, 'CTA 106880835 Toluca', 'CTA 1', 380, 'S/C', '', '', '1100-04-0014', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 39, 'CTA 101950439', 'CTA 1', 390, 'S/C', '', '', '1100-04-0015', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 40, 'CTA 22606343422', 'CTA 2', 400, 'S/C', '', '', '1100-04-0016', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 41, 'CTA 2595639', 'CTA 2', 410, 'S/C', '', '', '1100-04-0017', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 42, 'CTA 2595647', 'CTA 2', 420, 'S/C', '', '', '1100-04-0018', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 43, 'CTA 2595688', 'CTA 2', 430, 'S/C', '', '', '1100-04-0019', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 44, 'CTA. 2595696', 'CTA. ', 440, 'S/C', '', '', '1100-04-0020', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 45, 'CTA. 4005244', 'CTA. ', 450, 'S/C', '', '', '1100-04-0021', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 46, 'CTA. 4005260', 'CTA. ', 460, 'S/C', '', '', '1100-04-0022', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 47, 'CTA.226040126718', 'CTA.2', 470, 'S/C', '', '', '1100-04-0023', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 48, 'CTA.22604126955', 'CTA.2', 480, 'S/C', '', '', '1100-04-0024', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 49, 'CTA.22604126971', 'CTA.2', 490, 'S/C', '', '', '1100-04-0025', 1, 0, 1, 5, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 50, 'JPMORGAN - CHASE BANK', 'JPMOR', 500, 'S/C', '', '', '1100-05-0000', 0, 0, 1, 4, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 51, 'CTA 720-6115628-7  (Dlls)', 'CTA 7', 510, 'S/C', '', '', '1100-05-0001', 1, 0, 1, 5, 1,7
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 52, 'BANCO INTERNACIONAL', 'BANCO', 520, 'S/C', '', '', '1100-06-0000', 0, 0, 1, 4, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 53, 'FOINVER 402961147-2 (HSBC)', 'FOINV', 530, 'S/C', '', '', '1100-06-0003', 1, 0, 1, 5, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 54, 'BANAMEX - CITIBANK', 'BANAM', 540, 'S/C', '', '', '1100-09-0000', 0, 0, 1, 4, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 55, 'CTA 664365-2', 'CTA 6', 550, 'S/C', '', '', '1100-09-0004', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 56, 'SANTANDER MEXICANO', 'SANTA', 560, 'S/C', '', '', '1100-10-0000', 0, 0, 1, 4, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 57, 'CTA 51-90809775-3', 'CTA 5', 570, 'S/C', '', '', '1100-10-0001', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 58, 'CTA 65-50227135-5', 'CTA 6', 580, 'S/C', '', '', '1100-10-0002', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 59, 'CTA. 65-50321713-1', 'CTA. ', 590, 'S/C', '', '', '1100-10-0003', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 60, 'CTA .65503628-300', 'CTA .', 600, 'S/C', '', '', '1100-10-0004', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 61, 'BANK OF THE WEST', 'BANK ', 610, 'S/C', '', '', '1100-11-0000', 0, 0, 1, 4, 1,7
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 62, 'CTA 4085027', 'CTA 4', 620, 'S/C', '', '', '1100-11-0001', 1, 0, 1, 5, 1,7
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 63, 'UNITED BANK of El Paso del Norte', 'UNITE', 630, 'S/C', '', '', '1100-12-0000', 0, 0, 1, 4, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 64, 'CTA 5507504 DLLS', 'CTA 5', 640, 'S/C', '', '', '1100-12-0001', 1, 0, 1, 5, 1,7
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 65, 'U.B.S.  HOUSTON', 'U.B.S', 650, 'S/C', '', '', '1100-13-0000', 0, 0, 1, 4, 1,7
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 66, 'CTA SB 01814 CT', 'CTA S', 660, 'S/C', '', '', '1100-13-0001', 1, 0, 1, 5, 1,7
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 67, 'BANORTE', 'BANOR', 670, 'S/C', '', '', '1100-14-0000', 0, 0, 1, 4, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 68, 'CTA 056520798-2', 'CTA 0', 680, 'S/C', '', '', '1100-14-0001', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 69, 'CTA 0568850222', 'CTA 0', 690, 'S/C', '', '', '1100-14-0002', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 70, 'CTA 0266924960', 'CTA 0', 700, 'S/C', '', '', '1100-14-0003', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 71, 'COMPASS BANK', 'COMPA', 710, 'S/C', '', '', '1100-15-0000', 0, 0, 1, 4, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 72, 'CTA 2512212-665', 'CTA 2', 720, 'S/C', '', '', '1100-15-0001', 1, 0, 1, 5, 1,7
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 73, 'INBURSA', 'INBUR', 730, 'S/C', '', '', '1100-16-0000', 0, 0, 1, 4, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 74, 'CTA 50001083591', 'CTA 5', 740, 'S/C', '', '', '1100-16-0001', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 75, 'CTA 50015365135 Dlls', 'CTA 5', 750, 'S/C', '', '', '1100-16-0002', 1, 0, 1, 5, 1,7
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 76, 'WEST STAR BANK', 'WEST ', 760, 'S/C', '', '', '1100-18-0000', 0, 0, 1, 4, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 77, 'CTA  4156455', 'CTA  ', 770, 'S/C', '', '', '1100-18-0001', 1, 0, 1, 5, 1,7
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 78, 'CTA 4185978', 'CTA 4', 780, 'S/C', '', '', '1100-18-0002', 1, 0, 1, 5, 1,7
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 79, 'BANCO INTERACCIONES', 'BANCO', 790, 'S/C', '', '', '1100-19-0000', 0, 0, 1, 4, 1,5
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 80, 'CTA 100047730', 'CTA 1', 800, 'S/C', '', '', '1100-19-0001', 1, 0, 1, 5, 1,6
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 81, 'INTERNATIONAL BANK', 'INTER', 810, 'S/C', '', '', '1100-20-0000', 0, 0, 1, 4, 1,7
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 82, 'INTERNATIONAL BANK CTA.2218348', 'INTER', 820, 'S/C', '', '', '1100-20-0001', 1, 0, 1, 5, 1,7
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 83, 'BBVA COMPASS', 'BBVA ', 830, 'S/C', '', '', '1100-21-0000', 0, 0, 1, 4, 1,7
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 84, 'CTA. 6749416821', 'CTA. ', 840, 'S/C', '', '', '1100-21-0001', 1, 0, 1, 5, 1,7
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 85, 'CLIENTES', 'CLIEN', 850, 'S/C', '', '', '1200-00-0000', 0, 0, 1, 3, 1,14
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 86, 'CLIENTES GAS', 'CLIEN', 860, 'S/C', '', '', '1200-01-0000', 0, 0, 1, 4, 1,14
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 87, 'CLIENTES VARIOS', 'CLIEN', 870, 'S/C', '', '', '1200-01-0001', 1, 0, 1, 5, 1,15
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 88, 'GAS TOMZA DE MEXICO', 'GAS T', 880, 'S/C', '', '', '1200-01-0002', 1, 0, 1, 5, 1,15
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 89, 'GASOMATICO S.A. DE C.V.', 'GASOM', 890, 'S/C', '', '', '1200-01-0003', 1, 0, 1, 5, 1,15
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 90, 'GAS Y SERVICIO S.A. DE C.V.', 'GAS Y', 900, 'S/C', '', '', '1200-01-0004', 1, 0, 1, 5, 1,15
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 91, 'GAS CHAPULTEPEC', 'GAS C', 910, 'S/C', '', '', '1200-01-0005', 1, 0, 1, 5, 1,15
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 92, 'CIA. MEXICANA DE GAS COMBUSTIBLE SA', 'CIA. ', 920, 'S/C', '', '', '1200-01-0006', 1, 0, 1, 5, 1,15
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 93, 'HOLBOX GAS SA DE CV', 'HOLBO', 930, 'S/C', '', '', '1200-01-0007', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 94, 'GAS TOMZA LIMITED BELICE', 'GAS T', 940, 'S/C', '', '', '1200-01-0008', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 95, 'INDUSTRIAS ZARAGOZA DIVISION PRODUCTOS METALICOS', 'INDUS', 950, 'S/C', '', '', '1200-01-0009', 1, 0, 1, 5, 1,15
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 96, 'GAS TOMZA DE PUEBLA SA DE CV', 'GAS T', 960, 'S/C', '', '', '1200-01-0010', 1, 0, 1, 5, 1,15
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 97, 'GAS URIBE DE ACAPULCO S.A. DE C.V.', 'GAS U', 970, 'S/C', '', '', '1200-01-0011', 1, 0, 1, 5, 1,15
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 98, 'GAS BUTEP S.A. DE C.V.', 'GAS B', 980, 'S/C', '', '', '1200-01-0012', 1, 0, 1, 5, 1,15
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 99, 'MAMEME GAS S.A. DE C.V.', 'MAMEM', 990, 'S/C', '', '', '1200-01-0013', 1, 0, 1, 5, 1,15
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 100, 'GAS EXPRESS NIETO DE MEXICO SA DE CV', 'GAS E', 1000, 'S/C', '', '', '1200-01-0014', 1, 0, 1, 5, 1,15
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 101, 'GAS TITANIUM S.A. DE C.V.', 'GAS T', 1010, 'S/C', '', '', '1200-01-0015', 1, 0, 1, 5, 1,30
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 102, 'DEUDORES', 'DEUDO', 1020, 'S/C', '', '', '1300-00-0000', 0, 0, 1, 3, 1,30
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 103, 'FUNCIONARIOS Y EMPLEADOS', 'FUNCI', 1030, 'S/C', '', '', '1300-01-0000', 0, 0, 1, 4, 1,30
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 104, 'PRESTAMOS AL PERSONAL', 'PREST', 1040, 'S/C', '', '', '1300-01-0001', 1, 0, 1, 5, 1,31
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 105, 'OTROS', 'OTROS', 1050, 'S/C', '', '', '1300-02-0000', 0, 0, 1, 4, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 106, 'CHEQUES DEVUELTOS', 'CHEQU', 1060, 'S/C', '', '', '1300-02-0001', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 107, 'DAVID ALMARAZ LOPEZ', 'DAVID', 1070, 'S/C', '', '', '1300-02-0002', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 108, 'VARIOS', 'VARIO', 1080, 'S/C', '', '', '1300-02-0003', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 109, 'VARIOS PROVEEDORES', 'VARIO', 1090, 'S/C', '', '', '1300-02-0004', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 110, 'JORGE VILLARREAL PALOMO', 'JORGE', 1100, 'S/C', '', '', '1300-02-0018', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 111, 'JULIO CESAR ANAYA JIMENEZ', 'JULIO', 1110, 'S/C', '', '', '1300-02-0030', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 112, 'LEONEL REQUENES RIVERA', 'LEONE', 1120, 'S/C', '', '', '1300-02-0041', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 113, 'RAMIRO RODRIGUEZ M.', 'RAMIR', 1130, 'S/C', '', '', '1300-02-0243', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 114, 'PALEMON SOLORZANO', 'PALEM', 1140, 'S/C', '', '', '1300-02-0314', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 115, 'XOCHITL NAVARRO OLMEDO', 'XOCHI', 1150, 'S/C', '', '', '1300-02-0322', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 116, 'FRANCISCO RODRIGUEZ ARJON', 'FRANC', 1160, 'S/C', '', '', '1300-02-0323', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 117, 'DANIEL BELLO CAMACHO', 'DANIE', 1170, 'S/C', '', '', '1300-02-0327', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 118, 'JUAN LUIS JIMENEZ', 'JUAN ', 1180, 'S/C', '', '', '1300-02-0328', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 119, 'ANA BRENDA ORTEGA NOLASCO', 'ANA B', 1190, 'S/C', '', '', '1300-02-0329', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 120, 'MAMEME GAS S.A. DE C.V.', 'MAMEM', 1200, 'S/C', '', '', '1300-02-0330', 1, 0, 1, 5, 1,35
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 121, 'DOCUMENTOS POR COBRAR C/PLAZO', 'DOCUM', 1210, 'S/C', '', '', '1400-00-0000', 0, 0, 1, 3, 1,19
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 122, 'DOCUMENTOS POR COBRAR C/PLAZO', 'DOCUM', 1220, 'S/C', '', '', '1400-01-0000', 0, 0, 1, 4, 1,19
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 123, 'GASOMATICO, S.A. de C.V.', 'GASOM', 1230, 'S/C', '', '', '1400-01-0001', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 124, 'GAS Y SERVICIO, S.A.', 'GAS Y', 1240, 'S/C', '', '', '1400-01-0002', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 125, 'CIA. MEXICANA DE GAS COMB., S.A.', 'CIA. ', 1250, 'S/C', '', '', '1400-01-0003', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 126, 'GAS CHAPULTEPEC, S.A.', 'GAS C', 1260, 'S/C', '', '', '1400-01-0004', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 127, 'GAS VEHICULAR SILZA, S.A. DE C.V.', 'GAS V', 1270, 'S/C', '', '', '1400-01-0005', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 128, 'HIDROGAS DE AGUA PRIETA, S.A.', 'HIDRO', 1280, 'S/C', '', '', '1400-01-0006', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 129, 'GAS SILZA, S.A. DE C.V.', 'GAS S', 1290, 'S/C', '', '', '1400-01-0007', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 130, 'GAS URIBE DE ACAPULCO, S.A. DE C.V.', 'GAS U', 1300, 'S/C', '', '', '1400-01-0008', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 131, 'HIDROGAS DE ACAPULCO, S.A. DE C.V.', 'HIDRO', 1310, 'S/C', '', '', '1400-01-0009', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 132, 'GAS DEL PACIFICO EN GRO. S.A.', 'GAS D', 1320, 'S/C', '', '', '1400-01-0010', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 133, 'HIDROGAS DE CHIHUAHUA, S.A.', 'HIDRO', 1330, 'S/C', '', '', '1400-01-0011', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 134, 'GAS COM DE VILLA AHUMADA, S.A.', 'GAS C', 1340, 'S/C', '', '', '1400-01-0012', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 135, 'GAS COM DE NVO CASAS GDES. S.A.', 'GAS C', 1350, 'S/C', '', '', '1400-01-0013', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 136, 'HIDROGAS DE OJINAGA, S.A. DE C.V.', 'HIDRO', 1360, 'S/C', '', '', '1400-01-0014', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 137, 'GAS ZARAGOZA DE OJINAGA, S.A. DE C.V.', 'GAS Z', 1370, 'S/C', '', '', '1400-01-0015', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 138, 'INDS. ZARAGOZA DIV. PRODUCTOS MET., S.A.', 'INDS.', 1380, 'S/C', '', '', '1400-01-0016', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 139, 'TRANSPORTADORA SILZA, S.A. DE C.V.', 'TRANS', 1390, 'S/C', '', '', '1400-01-0017', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 140, 'DESARROLLOS ESMERALDA, S.A. DE C.V.', 'DESAR', 1400, 'S/C', '', '', '1400-01-0018', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 141, 'CALIFORNIA COMPANY INC.', 'CALIF', 1410, 'S/C', '', '', '1400-01-0019', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 142, 'ASES. DE SERV. PROF. TECN. Y ADMVOS. S.A.', 'ASES.', 1420, 'S/C', '', '', '1400-01-0020', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 143, 'INMOBILIARIA TOMZA, S.A. DE C.V.', 'INMOB', 1430, 'S/C', '', '', '1400-01-0021', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 144, 'BIAM, S.A. DE C.V.', 'BIAM,', 1440, 'S/C', '', '', '1400-01-0022', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 145, 'AEROSILZA, S.A. DE C.V.', 'AEROS', 1450, 'S/C', '', '', '1400-01-0023', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 146, 'COLECCION ARTISTICA SILZA, S. A.', 'COLEC', 1460, 'S/C', '', '', '1400-01-0024', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 147, 'PETROLEO Y GAS DEL GOLFO S.A. DE C.V.', 'PETRO', 1470, 'S/C', '', '', '1400-01-0025', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 148, 'PETROLEO Y GAS DEL NORTE S.A.  DE C.V.', 'PETRO', 1480, 'S/C', '', '', '1400-01-0026', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 149, 'INMOBILIARIA LOS MEDANOS S.A. DE C.V.', 'INMOB', 1490, 'S/C', '', '', '1400-01-0027', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 150, 'GAS TOMZA DE PUEBLA S.A. DE C.V.', 'GAS T', 1500, 'S/C', '', '', '1400-01-0028', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 151, 'GAS TOMZA DE YUCATAN', 'GAS T', 1510, 'S/C', '', '', '1400-01-0031', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 152, 'GAS PRONTO, S.A. DE C.V.', 'GAS P', 1520, 'S/C', '', '', '1400-01-0033', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 153, 'GAS TOMZA DE CARIBE, S.A. DE C.V.', 'GAS T', 1530, 'S/C', '', '', '1400-01-0034', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 154, 'GAS DEL CARIBE, S.A. (HON)', 'GAS D', 1540, 'S/C', '', '', '1400-01-0035', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 155, 'GAS BUTEP, S.A. DE C.V.', 'GAS B', 1550, 'S/C', '', '', '1400-01-0036', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 156, 'AERO TOMZA, S.A. DE C.V.', 'AERO ', 1560, 'S/C', '', '', '1400-01-0037', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 157, 'INMOBILIARIA ZARAGOZA ITO', 'INMOB', 1570, 'S/C', '', '', '1400-01-0038', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 158, 'GAS TOMZA DE MEXICO, S.A. de C.V.', 'GAS T', 1580, 'S/C', '', '', '1400-01-0040', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 159, 'HOLBOX GAS, S.A. DE C.V.', 'HOLBO', 1590, 'S/C', '', '', '1400-01-0041', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 160, 'GAS VULCANO', 'GAS V', 1600, 'S/C', '', '', '1400-01-0042', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 161, 'GAS TENABO SA DE CV', 'GAS T', 1610, 'S/C', '', '', '1400-01-0043', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 162, 'TERMINAL MARITIMA GAS TOMZA S.A. DE C.V.', 'TERMI', 1620, 'S/C', '', '', '1400-01-0044', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 163, 'UNIVERSAL GAS', 'UNIVE', 1630, 'S/C', '', '', '1400-01-0045', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 164, 'APPLEMEX, SA', 'APPLE', 1640, 'S/C', '', '', '1400-01-0046', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 165, 'INMOBILIARIA UNIGAS S.A  DE C.V.', 'INMOB', 1650, 'S/C', '', '', '1400-01-0047', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 166, 'INMOBILIARIA ERNESIL S.A. DE C.V.', 'INMOB', 1660, 'S/C', '', '', '1400-01-0048', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 167, 'GAS TOMZA DE VERACRUZ S.A. DE C.V.', 'GAS T', 1670, 'S/C', '', '', '1400-01-0049', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 168, 'MAMEME GAS, S.A. DE C.V.', 'MAMEM', 1680, 'S/C', '', '', '1400-01-0052', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 169, 'TOMZA JET SA', 'TOMZA', 1690, 'S/C', '', '', '1400-01-0054', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 170, 'GAS TOMZA LIMITED', 'GAS T', 1700, 'S/C', '', '', '1400-01-0055', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 171, 'GINZA HOLDING', 'GINZA', 1710, 'S/C', '', '', '1400-01-0056', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 172, 'CIA. IMPORTADORA DE GAS Y PETROLEO DEL GOLFO SA DE', 'CIA. ', 1720, 'S/C', '', '', '1400-01-0057', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 173, 'GAS TOMZA DE OJINAGA SA DE CV', 'GAS T', 1730, 'S/C', '', '', '1400-01-0058', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 174, 'GAS TITANIUM S.A. DE C.V.', 'GAS T', 1740, 'S/C', '', '', '1400-01-0059', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 175, 'TRANPORTADORA TOMZA S.A. DE C.V.', 'TRANP', 1750, 'S/C', '', '', '1400-01-0061', 1, 0, 1, 5, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 176, 'HELITOMZA S.A. DE C.V.', 'HELIT', 1760, 'S/C', '', '', '1400-01-0060', 1, 0, 1, 4, 1,20
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 177, 'ALMACEN', 'ALMAC', 1770, 'S/C', '', '', '1500-00-0000', 0, 0, 1, 3, 1,82
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 178, 'ALMACEN', 'ALMAC', 1780, 'S/C', '', '', '1500-01-0000', 0, 0, 1, 4, 1,82
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 179, 'DE GAS L.P.', 'DE GA', 1790, 'S/C', '', '', '1500-01-0001', 1, 0, 1, 5, 1,84
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 180, 'DE TANQUES ESTACIONARIOS', 'DE TA', 1800, 'S/C', '', '', '1500-01-0002', 1, 0, 1, 5, 1,84
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 181, 'DE REFACCIONES', 'DE RE', 1810, 'S/C', '', '', '1500-01-0003', 1, 0, 1, 5, 1,84
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 182, 'DE EQUIPO DE INSTALACIONES', 'DE EQ', 1820, 'S/C', '', '', '1500-01-0004', 1, 0, 1, 5, 1,84
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 183, 'DE TANQUES PARA CARBURACION', 'DE TA', 1830, 'S/C', '', '', '1500-01-0005', 1, 0, 1, 5, 1,84
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 184, 'AUTOTANQUES', 'AUTOT', 1840, 'S/C', '', '', '1500-01-0006', 1, 0, 1, 5, 1,83
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 185, 'CILINDRERAS', 'CILIN', 1850, 'S/C', '', '', '1500-01-0007', 1, 0, 1, 5, 1,83
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 186, 'PLATAFORMAS PARA CILINDRERAS', 'PLATA', 1860, 'S/C', '', '', '1500-01-0008', 1, 0, 1, 5, 1,83
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 187, 'PAGOS PROVISIONALES', 'PAGOS', 1870, 'S/C', '', '', '1550-00-0000', 0, 0, 1, 3, 1,80
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 188, 'PAGOS PROVISIONALES DE ISR', 'PAGOS', 1880, 'S/C', '', '', '1550-01-0000', 0, 0, 1, 4, 1,80
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 189, 'PAGOS PROVISIONALES DE ISR', 'PAGOS', 1890, 'S/C', '', '', '1550-01-0001', 1, 0, 1, 5, 1,41
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 190, 'PAGOS ANTICIPADOS', 'PAGOS', 1900, 'S/C', '', '', '1600-00-0000', 0, 0, 1, 3, 1,41
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 191, 'PAGOS ANTICIPADOS', 'PAGOS', 1910, 'S/C', '', '', '1600-01-0000', 0, 0, 1, 4, 1,41
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 192, 'IVA PAGO DE LO INDEBIDO', 'IVA P', 1920, 'S/C', '', '', '1600-01-0002', 1, 0, 1, 5, 1,42
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 193, 'SEGUROS PAGADOS POR ANTICIPADO', 'SEGUR', 1930, 'S/C', '', '', '1600-01-0004', 1, 0, 1, 5, 1,50
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 194, 'INTS PAGADOS POR ANTICIPADO', 'INTS ', 1940, 'S/C', '', '', '1600-01-0006', 1, 0, 1, 5, 1,50
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 195, 'IMPUESTOS A FAVOR', 'IMPUE', 1950, 'S/C', '', '', '1650-00-0000', 0, 0, 1, 3, 1,71
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 196, 'IMPUESTOS A FAVOR', 'IMPUE', 1960, 'S/C', '', '', '1650-01-0000', 0, 0, 1, 4, 1,71
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 197, '10% RETENCIONES', '10% R', 1970, 'S/C', '', '', '1650-01-0001', 1, 0, 1, 5, 1,75
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 198, 'IDE RECAUDADO', 'IDE R', 1980, 'S/C', '', '', '1650-01-0002', 1, 0, 1, 5, 1,75
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 199, 'ISR ARRENDAMIENTO', 'ISR A', 1990, 'S/C', '', '', '1650-01-0004', 1, 0, 1, 5, 1,78
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 200, 'RETENCION IVA', 'RETEN', 2000, 'S/C', '', '', '1650-01-0005', 1, 0, 1, 5, 1,78
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 201, 'IVA  A FAVOR DEL EJERCICIO', 'IVA  ', 2010, 'S/C', '', '', '1650-01-0006', 1, 0, 1, 5, 1,78
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 202, 'ISPT', 'ISPT', 2020, 'S/C', '', '', '1650-01-0007', 1, 0, 1, 5, 1,78
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 203, 'OTROS IMPUESTOS A FAVOR', 'OTROS', 2030, 'S/C', '', '', '1650-01-0008', 1, 0, 1, 5, 1,79
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 204, 'IEPS', 'IEPS', 2040, 'S/C', '', '', '1650-01-0009', 1, 0, 1, 5, 1,78
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 205, 'RETENCIONES', 'RETEN', 2050, 'S/C', '', '', '1650-02-0000', 0, 0, 1, 4, 1,79
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 206, 'RETENCION I.S.R. BANCARIO', 'RETEN', 2060, 'S/C', '', '', '1650-02-0001', 1, 0, 1, 5, 1,79
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 207, 'RETENCIONES IVA', 'RETEN', 2070, 'S/C', '', '', '1650-02-0002', 1, 0, 1, 5, 1,79
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 208, 'I. V. A. ACREDITABLE PAGADO', 'I. V.', 2080, 'S/C', '', '', '1700-00-0000', 0, 0, 1, 3, 1,94
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 209, 'I.  V.  A.  ACREDITABLE PAGADO', 'I.  V', 2090, 'S/C', '', '', '1700-01-0000', 0, 0, 1, 4, 1,95
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 210, 'IVA al 15%', 'IVA a', 2100, 'S/C', '', '', '1700-01-0002', 1, 0, 1, 5, 1,95
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 211, 'IVA al 11%', 'IVA a', 2110, 'S/C', '', '', '1700-01-0005', 1, 0, 1, 5, 1,95
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 212, 'IVA al 16%', 'IVA a', 2120, 'S/C', '', '', '1700-01-0006', 1, 0, 1, 5, 1,95
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 213, 'IVA ACREDITABLE DE IMPORTACION PAGADO', 'IVA A', 2130, 'S/C', '', '', '1700-02-0000', 0, 0, 1, 4, 1,96
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 214, 'IVA  AL 16%', 'IVA  ', 2140, 'S/C', '', '', '1700-02-0006', 1, 0, 1, 5, 1,96
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 215, 'I.V.A. ACREDITABLE PEND DE PAGO', 'I.V.A', 2150, 'S/C', '', '', '1730-00-0000', 0, 0, 1, 3, 1,99
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 216, 'I.V.A. ACREDITABLE PEND DE PAGO', 'I.V.A', 2160, 'S/C', '', '', '1730-01-0000', 0, 0, 1, 4, 1,99
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 217, 'IVA PENDIENTE DE PAGO', 'IVA P', 2170, 'S/C', '', '', '1730-01-0001', 1, 0, 1, 5, 1,65
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 218, 'SUBSIDIO AL EMPLEO POR APLICAR', 'SUBSI', 2180, 'S/C', '', '', '1740-00-0000', 0, 0, 1, 3, 1,65
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 219, 'SUBSIDIO AL EMPLEO POR APLICAR', 'SUBSI', 2190, 'S/C', '', '', '1740-01-0000', 0, 0, 1, 4, 1,65
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 220, 'SUBSIDIO AL EMPLEO POR APLICAR', 'SUBSI', 2200, 'S/C', '', '', '1740-01-0001', 1, 0, 1, 5, 1,66
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 221, 'ANTICIPO A PROVEEDORES', 'ANTIC', 2210, 'S/C', '', '', '1750-00-0000', 0, 0, 1, 3, 1,104
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 222, 'PLANTA', 'PLANT', 2220, 'S/C', '', '', '1750-01-0000', 0, 0, 1, 4, 1,104
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 223, 'VARIOS PROVEEDORES', 'VARIO', 2230, 'S/C', '', '', '1750-01-0001', 1, 0, 1, 5, 1,105
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 224, 'INDUSTRIAS ZARAGOZA DIV. PROD. METALICOS SA DE CV', 'INDUS', 2240, 'S/C', '', '', '1750-01-0002', 1, 0, 1, 5, 1,105
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 225, 'IVA ACREDITABLE NO PAGADO', 'IVA A', 2250, 'S/C', '', '', '1760-00-0000', 0, 0, 1, 3, 1,100
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 226, 'IVA ACREDITABLE NO PAGADO', 'IVA A', 2260, 'S/C', '', '', '1760-01-0000', 1, 0, 1, 4, 1,100
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 227, 'INVERSIONES', 'INVER', 2270, 'S/C', '', '', '1900-00-0000', 0, 0, 1, 3, 1,8
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 228, 'INVERSION BANCOMER', 'INVER', 2280, 'S/C', '', '', '1900-01-0000', 0, 0, 1, 4, 1,8
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 229, 'BANCOMER, S.A. Cta 1000415-0', 'BANCO', 2290, 'S/C', '', '', '1900-01-0001', 1, 0, 1, 5, 1,8
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 230, 'INVN EN HSBC', 'INVN ', 2300, 'S/C', '', '', '1900-06-0000', 0, 0, 1, 4, 1,8
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 231, 'Invn en HSBC', 'Invn ', 2310, 'S/C', '', '', '1900-06-0001', 1, 0, 1, 5, 1,9
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 232, 'WEST STAR BANK', 'WEST ', 2320, 'S/C', '', '', '1900-18-0001', 1, 0, 1, 4, 1,9
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 233, 'NATIONAL BANK', 'NATIO', 2330, 'S/C', '', '', '1900-20-0001', 1, 0, 1, 4, 1,240
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 234, 'ACCIONES Y VALORES', 'ACCIO', 2340, 'S/C', '', '', '2000-00-0000', 0, 0, 1, 3, 1,240
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 235, 'ACCIONES Y VALORES', 'ACCIO', 2350, 'S/C', '', '', '2000-01-0000', 0, 0, 1, 4, 1,240
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 236, 'ACCIONES Y VALORES', 'ACCIO', 2360, 'S/C', '', '', '2000-01-0001', 1, 0, 1, 5, 1,243
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 237, 'ACCIONES -GAS BUTEP, S.A.', 'ACCIO', 2370, 'S/C', '', '', '2000-01-0002', 1, 0, 1, 5, 1,243
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 238, 'F  I  J  O', 'F  I ', 2380, 'S/C', '', '', '0020-00-0000', 0, 0, 1, 2, 1,0
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 239, 'EQUIPO DE COMPUTO', 'EQUIP', 2390, 'S/C', '', '', '2100-00-0000', 0, 0, 1, 3, 1,122
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 240, 'EQUIPO DE COMPUTO', 'EQUIP', 2400, 'S/C', '', '', '2100-01-0000', 0, 0, 1, 4, 1,122
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 241, 'EQUIPO DE COMPUTO', 'EQUIP', 2410, 'S/C', '', '', '2100-01-0011', 1, 0, 1, 5, 1,114
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 242, 'EDIFICIO Y CONSTRUCCION', 'EDIFI', 2420, 'S/C', '', '', '2110-00-0000', 0, 0, 1, 3, 1,114
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 243, 'EDIFICIO Y CONSTRUCCION', 'EDIFI', 2430, 'S/C', '', '', '2110-01-0000', 0, 0, 1, 4, 1,114
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 244, 'EDIFICIO Y CONSTRUCCION', 'EDIFI', 2440, 'S/C', '', '', '2110-01-0001', 1, 0, 1, 5, 1,115
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 245, 'EQUIPO DE TRANSPORTE', 'EQUIP', 2450, 'S/C', '', '', '2120-00-0000', 0, 0, 1, 3, 1,118
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 246, 'EQUIPO DE TRANSPORTE', 'EQUIP', 2460, 'S/C', '', '', '2120-01-0000', 0, 0, 1, 4, 1,118
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 247, 'EQUIPO DE TRANSPORTE', 'EQUIP', 2470, 'S/C', '', '', '2120-01-0001', 1, 0, 1, 5, 1,119
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 248, 'EQUIPO DE TRANSPORTE USADO', 'EQUIP', 2480, 'S/C', '', '', '2130-00-0000', 0, 0, 1, 3, 1,118
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 249, 'EQUIPO DE TRANSPORTE USADO', 'EQUIP', 2490, 'S/C', '', '', '2130-01-0000', 0, 0, 1, 4, 1,119
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 250, 'EQUIPO DE TRANSPORTE USADO', 'EQUIP', 2500, 'S/C', '', '', '2130-01-0001', 1, 0, 1, 5, 1,119
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 251, 'EQUIPO DE PLANTA', 'EQUIP', 2510, 'S/C', '', '', '2140-00-0000', 0, 0, 1, 3, 1,130
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 252, 'EQUIPO DE PLANTA', 'EQUIP', 2520, 'S/C', '', '', '2140-01-0000', 0, 0, 1, 4, 1,130
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 253, 'EQUIPO DE PLANTA', 'EQUIP', 2530, 'S/C', '', '', '2140-01-0001', 1, 0, 1, 5, 1,116
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 254, 'MAQUINAS Y HERRAMIENTAS', 'MAQUI', 2540, 'S/C', '', '', '2150-00-0000', 0, 0, 1, 3, 1,116
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 255, 'MAQUINAS Y HERRAMIENTAS', 'MAQUI', 2550, 'S/C', '', '', '2150-01-0000', 0, 0, 1, 4, 1,116
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 256, 'MAQUINAS Y HERRAMIENTAS', 'MAQUI', 2560, 'S/C', '', '', '2150-01-0001', 1, 0, 1, 5, 1,117
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 257, 'TANQUES DE ALMACEN', 'TANQU', 2570, 'S/C', '', '', '2160-00-0000', 0, 0, 1, 3, 1,130
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 258, 'TANQUES DE ALMACEN', 'TANQU', 2580, 'S/C', '', '', '2160-01-0000', 0, 0, 1, 4, 1,130
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 259, 'TANQUES DE ALMACEN', 'TANQU', 2590, 'S/C', '', '', '2160-01-0001', 1, 0, 1, 5, 1,131
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 260, 'TANQUES EN SERVICIO', 'TANQU', 2600, 'S/C', '', '', '2170-00-0000', 0, 0, 1, 3, 1,130
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 261, 'TANQUES EN SERVICIO', 'TANQU', 2610, 'S/C', '', '', '2170-01-0000', 0, 0, 1, 4, 1,131
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 262, 'TANQUES EN SERVICIO', 'TANQU', 2620, 'S/C', '', '', '2170-01-0001', 1, 0, 1, 5, 1,131
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 263, 'MOBILIARIO Y EQUIPO DE OFICINA', 'MOBIL', 2630, 'S/C', '', '', '2180-00-0000', 0, 0, 1, 3, 1,120
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 264, 'MOBILIARIO Y EQUIPO DE OFICINA', 'MOBIL', 2640, 'S/C', '', '', '2180-01-0000', 0, 0, 1, 4, 1,120
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 265, 'MOBILIARIO Y EQUIPO DE OFICINA', 'MOBIL', 2650, 'S/C', '', '', '2180-01-0001', 1, 0, 1, 5, 1,130
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 266, 'EQUIPO TELEFONICO', 'EQUIP', 2660, 'S/C', '', '', '2190-00-0000', 0, 0, 1, 3, 1,130
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 267, 'EQUIPO TELEFONICO', 'EQUIP', 2670, 'S/C', '', '', '2190-01-0000', 0, 0, 1, 4, 1,130
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 268, 'EQUIPO TELEFONICO', 'EQUIP', 2680, 'S/C', '', '', '2190-01-0001', 1, 0, 1, 5, 1,131
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 269, 'DEPRECIACIONES', 'DEPRE', 2690, 'S/C', '', '', '2200-00-0000', 0, 0, 1, 3, 2,152
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 270, 'DEPRECIACION ACUMULADA', 'DEPRE', 2700, 'S/C', '', '', '2200-01-0000', 0, 0, 1, 4, 2,152
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 271, 'Depn Acum Edificio y Construcción', 'Depn ', 2710, 'S/C', '', '', '2200-01-0002', 1, 0, 1, 5, 2,153
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 272, 'Depn Acum Equipo de Transporte', 'Depn ', 2720, 'S/C', '', '', '2200-01-0003', 1, 0, 1, 5, 2,155
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 273, 'Depn Acum Equipo Transporte Usado', 'Depn ', 2730, 'S/C', '', '', '2200-01-0004', 1, 0, 1, 5, 2,160
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 274, 'Depn Acum Equipo de Planta', 'Depn ', 2740, 'S/C', '', '', '2200-01-0005', 1, 0, 1, 5, 2,160
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 275, 'Depn Acum Maquinaria y Herramientas', 'Depn ', 2750, 'S/C', '', '', '2200-01-0006', 1, 0, 1, 5, 2,154
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 276, 'Depn Acum Tanques de Almacén', 'Depn ', 2760, 'S/C', '', '', '2200-01-0007', 1, 0, 1, 5, 2,160
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 277, 'Depn Acum Tanques en Servicio', 'Depn ', 2770, 'S/C', '', '', '2200-01-0008', 1, 0, 1, 5, 2,156
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 278, 'Depn Acum Mobiliario y Equipo', 'Depn ', 2780, 'S/C', '', '', '2200-01-0009', 1, 0, 1, 5, 2,156
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 279, 'Depn Acum Equipo Telefónico', 'Depn ', 2790, 'S/C', '', '', '2200-01-0010', 1, 0, 1, 5, 2,160
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 280, 'Depn Acum Equipo de Cómputo', 'Depn ', 2800, 'S/C', '', '', '2200-01-0011', 1, 0, 1, 5, 2,157
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 281, 'Depn Acum Equipo de Radios', 'Depn ', 2810, 'S/C', '', '', '2200-01-0012', 1, 0, 1, 5, 2,158
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 282, 'Depn Acum Eq  Comunciacion', 'Depn ', 2820, 'S/C', '', '', '2200-01-0014', 1, 0, 1, 5, 2,158
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 283, 'OTROS ACTIVOS FIJOS', 'OTROS', 2830, 'S/C', '', '', '2200-01-0013', 1, 0, 1, 4, 2,130
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 284, 'EQUIPO DE RADIO', 'EQUIP', 2840, 'S/C', '', '', '2210-00-0000', 0, 0, 1, 3, 1,130
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 285, 'EQUIPO DE RADIO', 'EQUIP', 2850, 'S/C', '', '', '2210-01-0000', 0, 0, 1, 4, 1,131
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 286, 'EQUIPO DE RADIO', 'EQUIP', 2860, 'S/C', '', '', '2210-01-0001', 1, 0, 1, 5, 1,131
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 287, 'EQUIPO DE COMUNICACION', 'EQUIP', 2870, 'S/C', '', '', '2220-00-0000', 0, 0, 1, 3, 1,124
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 288, 'EQUIPO DE COMUNICACION', 'EQUIP', 2880, 'S/C', '', '', '2220-01-0000', 0, 0, 1, 4, 1,124
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 289, 'EQUIPO DE COMUNICACION', 'EQUIP', 2890, 'S/C', '', '', '2220-01-0001', 1, 0, 1, 5, 1,112
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 290, 'TERRENOS', 'TERRE', 2900, 'S/C', '', '', '2230-00-0000', 0, 0, 1, 3, 1,112
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 291, 'TERRENOS', 'TERRE', 2910, 'S/C', '', '', '2230-01-0000', 0, 0, 1, 4, 1,112
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 292, 'TERRENOS', 'TERRE', 2920, 'S/C', '', '', '2230-01-0001', 1, 0, 1, 5, 1,113
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 293, 'OTROS ACTIVOS FIJOS', 'OTROS', 2930, 'S/C', '', '', '2240-00-0000', 0, 0, 1, 3, 1,130
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 294, 'OTROS ACTIVOS FIJOS', 'OTROS', 2940, 'S/C', '', '', '2240-01-0000', 0, 0, 1, 4, 1,130
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 295, 'OTROS ACTIVOS FIJOS', 'OTROS', 2950, 'S/C', '', '', '2240-01-0001', 1, 0, 1, 5, 1,131
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 296, 'D I F E R I D O', 'D I F', 2960, 'S/C', '', '', '0030-00-0000', 0, 0, 1, 2, 1,0
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 297, 'GASTOS DE INSTALACION', 'GASTO', 2970, 'S/C', '', '', '2300-00-0000', 0, 0, 1, 3, 1,206
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 298, 'GASTOS DE INSTALACION', 'GASTO', 2980, 'S/C', '', '', '2300-01-0000', 0, 0, 1, 4, 1,206
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 299, 'GASTOS DE INSTALACION', 'GASTO', 2990, 'S/C', '', '', '2300-01-0001', 1, 0, 1, 5, 1,207
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 300, 'AMORTIZACION GTOS. INSTALACION', 'AMORT', 3000, 'S/C', '', '', '2400-00-0000', 0, 0, 1, 3, 2,210
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 301, 'AMORTIZACION GTOS. INSTALACION', 'AMORT', 3010, 'S/C', '', '', '2400-01-0000', 0, 0, 1, 4, 2,211
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 302, 'AMORTIZACION DE GTOS DE INSTALACION', 'AMORT', 3020, 'S/C', '', '', '2400-01-0001', 1, 0, 1, 5, 2,211
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 303, 'DEPOSITOS EN GARANTIA', 'DEPOS', 3030, 'S/C', '', '', '2450-00-0000', 0, 0, 1, 3, 1,221
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 304, 'DEPOSITOS EN GARANTIA', 'DEPOS', 3040, 'S/C', '', '', '2450-01-0000', 0, 0, 1, 4, 1,221
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 305, 'DEPOSITOS EN GARANTIA', 'DEPOS', 3050, 'S/C', '', '', '2450-01-0001', 1, 0, 1, 5, 1,0
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 306, 'P A S I V O', 'P A S', 3060, 'S/C', '', '', '0002-00-0000', 0, 0, 1, 1, 3,0
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 307, 'C I R C U L A N T E', 'C I R', 3070, 'S/C', '', '', '0040-00-0000', 0, 0, 1, 2, 3,0
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 308, 'P R O V E E D O R E S', 'P R O', 3080, 'S/C', '', '', '2500-00-0000', 0, 0, 1, 3, 3,252
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 309, 'P R O V E E D O R E S', 'P R O', 3090, 'S/C', '', '', '2500-01-0000', 0, 0, 1, 4, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 310, 'P  E  M  E  X', 'P  E ', 3100, 'S/C', '', '', '2500-01-0001', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 311, 'GASOMATICO, SA DE C V', 'GASOM', 3110, 'S/C', '', '', '2500-01-0002', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 312, 'GAS Y SERVICIO S.A. DE C.V.', 'GAS Y', 3120, 'S/C', '', '', '2500-01-0004', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 313, 'GAS TOMZA DE MEXICO S.A. DE C.V.', 'GAS T', 3130, 'S/C', '', '', '2500-01-0005', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 314, 'CIA MEXICANA DE GAS COMBUSTIBLE SA', 'CIA M', 3140, 'S/C', '', '', '2500-01-0006', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 315, 'GAS PRONTO SA DE CV', 'GAS P', 3150, 'S/C', '', '', '2500-01-0007', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 316, 'GAS CHAPULTEPEC SA', 'GAS C', 3160, 'S/C', '', '', '2500-01-0008', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 317, 'GAS URIBE DE ACAPULCO SA', 'GAS U', 3170, 'S/C', '', '', '2500-01-0009', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 318, 'GAS TOMZA DE VERACRUZ SA', 'GAS T', 3180, 'S/C', '', '', '2500-01-0010', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 319, 'HIDROGAS DE ACAPULCO SA', 'HIDRO', 3190, 'S/C', '', '', '2500-01-0011', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 320, 'GAS TOMZA DE MEXICO INTERESES', 'GAS T', 3200, 'S/C', '', '', '2500-01-0012', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 321, 'PETROLEOS Y GAS DEL GOLFO S.A. DE C.V.', 'PETRO', 3210, 'S/C', '', '', '2500-01-0013', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 322, 'INDUSTRIAS ZARAGOZA DIV. PROD METALICOS SA DE CV', 'INDUS', 3220, 'S/C', '', '', '2500-01-0014', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 323, 'CIA. IMPORTADORA DE PETROLEOS Y GAS DEL GOLFO SA D', 'CIA. ', 3230, 'S/C', '', '', '2500-01-0015', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 324, 'AEROSILZA S.A. DE C.V.', 'AEROS', 3240, 'S/C', '', '', '2500-01-0016', 1, 0, 1, 5, 3,253
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 325, 'PROVEEDORES DLLS', 'PROVE', 3250, 'S/C', '', '', '2500-02-0000', 0, 0, 1, 4, 3,254
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 326, 'PETREDEC', 'PETRE', 3260, 'S/C', '', '', '2500-02-0001', 1, 0, 1, 5, 3,254
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 327, 'A C R E E D O R E S', 'A C R', 3270, 'S/C', '', '', '2600-00-0000', 0, 0, 1, 3, 3,291
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 328, 'D I V E R S O S', 'D I V', 3280, 'S/C', '', '', '2600-01-0000', 0, 0, 1, 4, 3,291
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 329, 'MAURILIO RAMOS SEIJAS', 'MAURI', 3290, 'S/C', '', '', '2600-01-0728', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 330, 'SARACHO JUAREZ, SA', 'SARAC', 3300, 'S/C', '', '', '2600-01-1061', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 331, 'VARIOS PROV. CIERRE DE EJERCICIO', 'VARIO', 3310, 'S/C', '', '', '2600-01-1275', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 332, 'AUTOSAT DE MEXICO SA DE CV', 'AUTOS', 3320, 'S/C', '', '', '2600-01-1278', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 333, 'CIA MEXICANA DE GAS COMB', 'CIA M', 3330, 'S/C', '', '', '2600-01-1281', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 334, 'GAS TOMZA DE MEXICO SA DE CV', 'GAS T', 3340, 'S/C', '', '', '2600-01-1282', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 335, 'INDUSTRIAS ZARAGOZA DIVISION', 'INDUS', 3350, 'S/C', '', '', '2600-01-1283', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 336, 'GAS TOMZA DE MEXICO SA DE CV', 'GAS T', 3360, 'S/C', '', '', '2600-01-1284', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 337, 'TOMAS ZARAGOZA FUENTES', 'TOMAS', 3370, 'S/C', '', '', '2600-01-1285', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 338, 'DAVID ALMARAZ LOPEZ', 'DAVID', 3380, 'S/C', '', '', '2600-01-1286', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 339, 'EURO VEHICULOS SA DE  CV', 'EURO ', 3390, 'S/C', '', '', '2600-01-1287', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 340, 'TRACTOCAMIONES KENWORTH DE CHIHUAHUA SA DE CV', 'TRACT', 3400, 'S/C', '', '', '2600-01-1288', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 341, 'TRANSPORTADORA SILZA S.A DE C.V.', 'TRANS', 3410, 'S/C', '', '', '2600-01-1289', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 342, 'VAMSA NIÑOS HEROES SA DE CV', 'VAMSA', 3420, 'S/C', '', '', '2600-01-1290', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 343, 'AEROPLASA DE OCCIDENTE SA DE CV', 'AEROP', 3430, 'S/C', '', '', '2600-01-1291', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 344, 'R E T E N C I O N E S', 'R E T', 3440, 'S/C', '', '', '2600-02-0000', 0, 0, 1, 4, 3,291
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 345, 'FONACOT', 'FONAC', 3450, 'S/C', '', '', '2600-02-0002', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 346, 'FONDO DE AHORRO', 'FONDO', 3460, 'S/C', '', '', '2600-02-0003', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 347, 'CUOTA SINDICAL', 'CUOTA', 3470, 'S/C', '', '', '2600-02-0004', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 348, 'PENSION ALIMENTICIA', 'PENSI', 3480, 'S/C', '', '', '2600-02-0005', 1, 0, 1, 5, 3,293
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 349, 'IMPUESTOS POR PAGAR', 'IMPUE', 3490, 'S/C', '', '', '2700-00-0000', 0, 0, 1, 3, 3,327
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 350, 'IMPUESTOS POR PAGAR', 'IMPUE', 3500, 'S/C', '', '', '2700-01-0000', 0, 0, 1, 4, 3,327
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 351, 'ISR POR PAGAR (ANUAL)', 'ISR P', 3510, 'S/C', '', '', '2700-01-0001', 1, 0, 1, 5, 3,330
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 352, 'ISR POR PAGAR MENSUAL', 'ISR P', 3520, 'S/C', '', '', '2700-01-0002', 1, 0, 1, 5, 3,330
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 353, 'IMPUESTOS RETENIDOS', 'IMPUE', 3530, 'S/C', '', '', '2710-00-0000', 0, 0, 1, 3, 3,341
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 354, 'IMPUESTOS RETENIDOS', 'IMPUE', 3540, 'S/C', '', '', '2710-01-0000', 0, 0, 1, 4, 3,341
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 355, 'RETENCION ISPT', 'RETEN', 3550, 'S/C', '', '', '2710-01-0001', 1, 0, 1, 5, 3,342
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 356, '10% ISR S/HONORARIOS', '10% I', 3560, 'S/C', '', '', '2710-01-0002', 1, 0, 1, 5, 3,345
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 357, '10% ISR S/ARRENDAMIENTO', '10% I', 3570, 'S/C', '', '', '2710-01-0003', 1, 0, 1, 5, 3,346
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 358, 'RETN ISR DIVIDENDOS', 'RETN ', 3580, 'S/C', '', '', '2710-01-0004', 1, 0, 1, 5, 3,346
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 359, 'RETENCIONES DE IVA', 'RETEN', 3590, 'S/C', '', '', '2710-01-0005', 1, 0, 1, 5, 3,351
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 360, 'RET-IVA (FLETES Y ACARREOS)', 'RET-I', 3600, 'S/C', '', '', '2710-01-0006', 1, 0, 1, 5, 3,351
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 361, 'IEPS POR PAGAR', 'IEPS ', 3610, 'S/C', '', '', '2710-01-0007', 1, 0, 1, 4, 3,325
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 362, 'PROVISION IMPTO S/NOMINA POR PAGAR', 'PROVI', 3620, 'S/C', '', '', '2720-00-0000', 0, 0, 1, 3, 3,325
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 363, 'PROVISION IMPTO S/NOMINA POR PAGAR', 'PROVI', 3630, 'S/C', '', '', '2720-01-0000', 0, 0, 1, 4, 3,325
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 364, 'PROVISION ISN POR PAGAR', 'PROVI', 3640, 'S/C', '', '', '2720-01-0001', 1, 0, 1, 5, 3,326
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 365, 'PROVISION DE SEGURIDAD SOCIAL POR PAGAR', 'PROVI', 3650, 'S/C', '', '', '2730-00-0000', 0, 0, 1, 3, 3,321
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 366, 'PROVISION DE SEGURIDAD SOCIAL POR PAGAR', 'PROVI', 3660, 'S/C', '', '', '2730-01-0000', 0, 0, 1, 4, 3,321
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 367, 'PROVISION DE IMSS', 'PROVI', 3670, 'S/C', '', '', '2730-01-0001', 1, 0, 1, 5, 3,322
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 368, 'PROVISION DE SAR', 'PROVI', 3680, 'S/C', '', '', '2730-01-0002', 1, 0, 1, 5, 3,323
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 369, 'PROVISION DE INFONAVIT', 'PROVI', 3690, 'S/C', '', '', '2730-01-0003', 1, 0, 1, 5, 3,304
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 370, 'IVA TRASLADADO', 'IVA T', 3700, 'S/C', '', '', '2740-00-0000', 0, 0, 1, 3, 3,304
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 371, 'IVA TRASLADADO', 'IVA T', 3710, 'S/C', '', '', '2740-01-0000', 0, 0, 1, 4, 3,304
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 372, 'IVA TRASLADADO', 'IVA T', 3720, 'S/C', '', '', '2740-01-0001', 1, 0, 1, 5, 3,305
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 373, 'IVA TRASLADADO COBRADO', 'IVA T', 3730, 'S/C', '', '', '2750-00-0000', 0, 0, 1, 3, 3,307
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 374, 'IVA TRASLADADO COBRADO', 'IVA T', 3740, 'S/C', '', '', '2750-01-0000', 0, 0, 1, 4, 3,307
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 375, 'IVA TRASLADADO COBRADO', 'IVA T', 3750, 'S/C', '', '', '2750-01-0001', 1, 0, 1, 5, 3,308
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 376, 'IVA TRASLADADO NO COBRADO', 'IVA T', 3760, 'S/C', '', '', '2760-00-0000', 0, 0, 1, 3, 3,310
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 377, 'IVA TRASLADADO NO COBRADO', 'IVA T', 3770, 'S/C', '', '', '2760-01-0000', 0, 0, 1, 4, 3,311
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 378, 'IVA TRASLADADO NO COBRADO', 'IVA T', 3780, 'S/C', '', '', '2760-01-0001', 1, 0, 1, 5, 3,311
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 379, 'DOCUMENTOS POR PAGAR C/PLAZO', 'DOCUM', 3790, 'S/C', '', '', '2800-00-0000', 0, 0, 1, 3, 3,257
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 380, 'DOCUMENTOS POR PAGAR C/PLZAO', 'DOCUM', 3800, 'S/C', '', '', '2800-01-0000', 0, 0, 1, 4, 3,257
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 381, 'GASOMATICO, S.A. DE C.V.', 'GASOM', 3810, 'S/C', '', '', '2800-01-0001', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 382, 'GAS Y SERVICIO, S.A.', 'GAS Y', 3820, 'S/C', '', '', '2800-01-0002', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 383, 'CIA. MEXICANA COMB. S.A.', 'CIA. ', 3830, 'S/C', '', '', '2800-01-0003', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 384, 'GAS CHAPULTEPEC, S.A.', 'GAS C', 3840, 'S/C', '', '', '2800-01-0004', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 385, 'GAS VEHICULAR SILZA, S.A. DE C.V.', 'GAS V', 3850, 'S/C', '', '', '2800-01-0005', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 386, 'HIDROGAS DE AGUAPRIETA, S.A.', 'HIDRO', 3860, 'S/C', '', '', '2800-01-0006', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 387, 'GAS SILZA, S.A. DE C.V.', 'GAS S', 3870, 'S/C', '', '', '2800-01-0007', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 388, 'GAS URIBE DE ACAPULCO, S.A. de C.V.', 'GAS U', 3880, 'S/C', '', '', '2800-01-0008', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 389, 'HIDROGAS DE ACAPULCO, S.A. de  C.V.', 'HIDRO', 3890, 'S/C', '', '', '2800-01-0009', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 390, 'GAS DEL PACIFICO EN GRO. S.A. DE C.V.', 'GAS D', 3900, 'S/C', '', '', '2800-01-0010', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 391, 'HIDROGAS DE CHIHUAHUA, S.A.', 'HIDRO', 3910, 'S/C', '', '', '2800-01-0011', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 392, 'GAS COM. DE VILLA  AHUMADA, S.A.', 'GAS C', 3920, 'S/C', '', '', '2800-01-0012', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 393, 'GAS COM. DE NVO. CASAS GRANDES. S.A.', 'GAS C', 3930, 'S/C', '', '', '2800-01-0013', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 394, 'HIDROGAS DE OJINAGA, S.A. DE C.V.', 'HIDRO', 3940, 'S/C', '', '', '2800-01-0014', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 395, 'GAS ZARAGOZA DE OJINAGA, S.A. de C.V.', 'GAS Z', 3950, 'S/C', '', '', '2800-01-0015', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 396, 'INDS. ZARAGOZA DIV. PRODS. MET. S.A.', 'INDS.', 3960, 'S/C', '', '', '2800-01-0016', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 397, 'TRANSPORTADORA Silza, S.A. DE C.V.', 'TRANS', 3970, 'S/C', '', '', '2800-01-0017', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 398, 'DESARROLLOS ESMERALDA, S.A. DE C.V.', 'DESAR', 3980, 'S/C', '', '', '2800-01-0018', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 399, 'CALOFORNIA COMAPNY, INC.', 'CALOF', 3990, 'S/C', '', '', '2800-01-0019', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 400, 'AERO SILZA, S.A. de C.V.', 'AERO ', 4000, 'S/C', '', '', '2800-01-0020', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 401, 'INMOBILIARIA TOMZA, S.A. DE C.V.', 'INMOB', 4010, 'S/C', '', '', '2800-01-0021', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 402, 'GAS TOMZA DE MEXICO', 'GAS T', 4020, 'S/C', '', '', '2800-01-0022', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 403, 'GAS PRONTO S.A.', 'GAS P', 4030, 'S/C', '', '', '2800-01-0023', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 404, 'UNIVERSAL GAS', 'UNIVE', 4040, 'S/C', '', '', '2800-01-0024', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 405, 'GAS TOMZA DE YUCATAN', 'GAS T', 4050, 'S/C', '', '', '2800-01-0025', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 406, 'HOLBOX GAS', 'HOLBO', 4060, 'S/C', '', '', '2800-01-0026', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 407, 'TERMINAL MARITIMA GAS TOMZA', 'TERMI', 4070, 'S/C', '', '', '2800-01-0027', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 408, 'GAS TENABO, SA DE CV', 'GAS T', 4080, 'S/C', '', '', '2800-01-0028', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 409, 'GAS BUTEP, SA DE CV', 'GAS B', 4090, 'S/C', '', '', '2800-01-0029', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 410, 'GAS VULCANO , SA DE CV', 'GAS V', 4100, 'S/C', '', '', '2800-01-0030', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 411, 'GAS TOMZA DE VERACRUZ S. A.', 'GAS T', 4110, 'S/C', '', '', '2800-01-0032', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 412, 'AEROSILZA SA', 'AEROS', 4120, 'S/C', '', '', '2800-01-0033', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 413, 'PETROLEO Y GAS DEL GOLFO S.A. DE C.V.', 'PETRO', 4130, 'S/C', '', '', '2800-01-0034', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 414, 'AEROTOMZA S.A.', 'AEROT', 4140, 'S/C', '', '', '2800-01-0037', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 415, 'MAMEME GAS S.A. DE C.V:', 'MAMEM', 4150, 'S/C', '', '', '2800-01-0040', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 416, 'GAS TOMZA DE PUEBLA SA DE CV', 'GAS T', 4160, 'S/C', '', '', '2800-01-0041', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 417, 'INMOBILIARIA SILZA SA DE CV', 'INMOB', 4170, 'S/C', '', '', '2800-01-0042', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 418, 'CIA. IMPORTADORA DE GAS Y PETROLEO DEL GOLFO SA DE', 'CIA. ', 4180, 'S/C', '', '', '2800-01-0043', 1, 0, 1, 5, 3,260
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 419, 'APPEMEX DE MEXICO S.A. DE C.V.', 'APPEM', 4190, 'S/C', '', '', '2800-01-0046', 1, 0, 1, 5, 3,257
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 420, 'PRESTAMOS BANCARIOS', 'PREST', 4200, 'S/C', '', '', '2850-00-0000', 0, 0, 1, 3, 3,257
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 421, 'PRESTAMOS BANCARIOS', 'PREST', 4210, 'S/C', '', '', '2850-01-0000', 0, 0, 1, 4, 3,258
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 422, 'BANCOMER, S.A.                 (M. N. )', 'BANCO', 4220, 'S/C', '', '', '2850-01-0001', 1, 0, 1, 5, 3,258
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 423, 'BANCOMER, S.A.                 (DLLS)', 'BANCO', 4230, 'S/C', '', '', '2850-01-0003', 1, 0, 1, 5, 3,258
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 424, 'CHASE BANK', 'CHASE', 4240, 'S/C', '', '', '2850-01-0005', 1, 0, 1, 5, 3,261
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 425, 'BANK OF AMERICA', 'BANK ', 4250, 'S/C', '', '', '2850-01-0006', 1, 0, 1, 5, 3,258
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 426, 'SANTANDER SERFIN', 'SANTA', 4260, 'S/C', '', '', '2850-01-0007', 1, 0, 1, 5, 3,258
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 427, 'BANK OF THE WEST -Cta 4085027', 'BANK ', 4270, 'S/C', '', '', '2850-01-0008', 1, 0, 1, 5, 3,261
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 428, 'HSBC', 'HSBC', 4280, 'S/C', '', '', '2850-01-0009', 1, 0, 1, 5, 3,258
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 429, 'INBURSA', 'INBUR', 4290, 'S/C', '', '', '2850-01-0010', 1, 0, 1, 5, 3,261
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 430, 'COMPASS BANK', 'COMPA', 4300, 'S/C', '', '', '2850-01-0011', 1, 0, 1, 5, 3,261
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 431, 'UNITED BANK', 'UNITE', 4310, 'S/C', '', '', '2850-01-0012', 1, 0, 1, 5, 3,261
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 432, 'BANAMEX', 'BANAM', 4320, 'S/C', '', '', '2850-01-0013', 1, 0, 1, 5, 3,258
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 433, 'WEST STAR BANK', 'WEST ', 4330, 'S/C', '', '', '2850-01-0014', 1, 0, 1, 5, 3,258
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 434, 'BANORTE', 'BANOR', 4340, 'S/C', '', '', '2850-01-0015', 1, 0, 1, 5, 3,258
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 435, 'OTROS PASIVOS', 'OTROS', 4350, 'S/C', '', '', '2900-00-0000', 0, 0, 1, 3, 3,298
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 436, 'ANTICIPO CLIENTES', 'ANTIC', 4360, 'S/C', '', '', '2900-01-0000', 0, 0, 1, 4, 3,298
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 437, 'VARIOS', 'VARIO', 4370, 'S/C', '', '', '2900-01-0001', 1, 0, 1, 5, 3,0
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 438, 'IVA FISCAL', 'IVA F', 4380, 'S/C', '', '', '2950-00-0000', 0, 0, 1, 3, 3,0
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 439, 'IVA FISCAL', 'IVA F', 4390, 'S/C', '', '', '2950-01-0000', 1, 0, 1, 4, 3,1074
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 440, 'PTU POR PAGAR', 'PTU P', 4400, 'S/C', '', '', '2960-00-0000', 0, 0, 1, 3, 3,337
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 441, 'PTU POR PAGAR', 'PTU P', 4410, 'S/C', '', '', '2960-01-0001', 1, 0, 1, 4, 3,339
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 442, 'PTU POR PAGAR DE EJERCICIOS ANTERIORES', 'PTU P', 4420, 'S/C', '', '', '2960-01-0002', 1, 0, 1, 4, 3,339
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 443, 'PROVISION DE PTU POR PAGAR', 'PROVI', 4430, 'S/C', '', '', '2960-01-0003', 1, 0, 1, 4, 3,340
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 444, 'CAPITAL CONTABLE', 'CAPIT', 4440, 'S/C', '', '', '0003-00-0000', 0, 0, 1, 1, 4,0
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 445, 'CAPITAL SOCIAL', 'CAPIT', 4450, 'S/C', '', '', '3000-00-0000', 0, 0, 1, 2, 4,420
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 446, 'CAPITAL SOCIAL', 'CAPIT', 4460, 'S/C', '', '', '3000-01-0000', 0, 0, 1, 3, 4,420
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 447, 'CAPITAL SOCIAL', 'CAPIT', 4470, 'S/C', '', '', '3000-01-0001', 1, 0, 1, 4, 4,421
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 448, 'APORTACION DE CAPITAL', 'APORT', 4480, 'S/C', '', '', '3000-01-0002', 1, 0, 1, 4, 4,421
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 449, 'CAPITAL VARIABLE', 'CAPIT', 4490, 'S/C', '', '', '3000-01-0003', 1, 0, 1, 4, 4,430
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 450, 'RESERVA LEGAL', 'RESER', 4500, 'S/C', '', '', '3100-00-0000', 0, 0, 1, 2, 4,430
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 451, 'RESERVA LEGAL', 'RESER', 4510, 'S/C', '', '', '3100-01-0000', 0, 0, 1, 3, 4,430
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 452, 'RESERVA LEGAL', 'RESER', 4520, 'S/C', '', '', '3100-01-0001', 1, 0, 1, 4, 4,431
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 453, 'RESERVA DE REINVERSION', 'RESER', 4530, 'S/C', '', '', '3200-00-0000', 0, 0, 1, 2, 4,441
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 454, 'RESERVA DE REINVERSION', 'RESER', 4540, 'S/C', '', '', '3200-01-0000', 0, 0, 1, 3, 4,441
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 455, 'RESERVA DE REINVERSION', 'RESER', 4550, 'S/C', '', '', '3200-01-0001', 1, 0, 1, 4, 4,442
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 456, 'APORTACION PENDIENTE CAPITALIZAR', 'APORT', 4560, 'S/C', '', '', '3300-00-0000', 0, 0, 1, 2, 4,420
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 457, 'APORTACION PENDIENTE CAPITALIZAR', 'APORT', 4570, 'S/C', '', '', '3300-01-0000', 0, 0, 1, 3, 4,423
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 458, 'APORTACION PENDIENTE DE CAPITALIZAR', 'APORT', 4580, 'S/C', '', '', '3300-01-0001', 1, 0, 1, 4, 4,423
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 459, 'ACCIONISTAS', 'ACCIO', 4590, 'S/C', '', '', '3400-00-0000', 0, 0, 1, 2, 4,441
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 460, 'ACCIONISTAS', 'ACCIO', 4600, 'S/C', '', '', '3400-01-0000', 0, 0, 1, 3, 4,441
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 461, 'ACCIONISTAS', 'ACCIO', 4610, 'S/C', '', '', '3400-01-0001', 1, 0, 1, 4, 4,432
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 462, 'RESULTADO EJERCICIOS ANTERIORES', 'RESUL', 4620, 'S/C', '', '', '3500-00-0000', 0, 0, 1, 2, 4,432
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 463, 'RESULTADO EJERCICIOS ANTERIORES', 'RESUL', 4630, 'S/C', '', '', '3500-01-0000', 0, 0, 1, 3, 4,432
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 464, 'RESULTADO DE EJERCICIOS ANTERIORES', 'RESUL', 4640, 'S/C', '', '', '3500-01-0001', 1, 0, 1, 4, 4,435
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 465, 'I N G R E S O S', 'I N G', 4650, 'S/C', '', '', '0004-00-0000', 0, 0, 1, 1, 5,0
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 466, 'I N G R E S O S', 'I N G', 4660, 'S/C', '', '', '4000-00-0000', 0, 0, 1, 2, 5,444
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 467, 'V E N T A S', 'V E N', 4670, 'S/C', '', '', '4000-01-0000', 0, 0, 1, 3, 5,444
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 468, 'DE GAS LP', 'DE GA', 4680, 'S/C', '', '', '4000-01-0001', 1, 0, 1, 4, 5,446
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 469, 'DE TANQUES ESTACIONARIOS', 'DE TA', 4690, 'S/C', '', '', '4000-01-0002', 1, 0, 1, 4, 5,445
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 470, 'DE ACTIVO FIJO', 'DE AC', 4700, 'S/C', '', '', '4000-01-0003', 1, 0, 1, 4, 5,445
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 471, 'DE INSTALACIONES', 'DE IN', 4710, 'S/C', '', '', '4000-01-0004', 1, 0, 1, 4, 5,446
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 472, 'GAS LP CREDITO', 'GAS L', 4720, 'S/C', '', '', '4000-01-0005', 1, 0, 1, 4, 5,447
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 473, 'INTERCOMPAÑIAS CONTADO', 'INTER', 4730, 'S/C', '', '', '4000-01-0006', 1, 0, 1, 4, 5,447
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 474, 'INTERCOMPAÑIAS CREDITO', 'INTER', 4740, 'S/C', '', '', '4000-01-0007', 1, 0, 1, 4, 5,447
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 475, 'VENTA PRODUCTO CHATARRA', 'VENTA', 4750, 'S/C', '', '', '4000-01-0008', 1, 0, 1, 4, 5,482
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 476, 'PRODUCTOS FINANCIEROS', 'PRODU', 4760, 'S/C', '', '', '8000-00-0000', 0, 0, 1, 2, 5,967
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 477, 'PRODUCTOS FINANCIEROS', 'PRODU', 4770, 'S/C', '', '', '8000-01-0000', 0, 0, 1, 3, 5,971
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 478, 'INTERESES GANADOS', 'INTER', 4780, 'S/C', '', '', '8000-01-0001', 1, 0, 1, 4, 5,971
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 479, 'RENDIMIENTO DE INVERSIONES', 'RENDI', 4790, 'S/C', '', '', '8000-01-0002', 1, 0, 1, 4, 5,971
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 480, 'GANANCIA CAMBIARIA', 'GANAN', 4800, 'S/C', '', '', '8000-01-0003', 1, 0, 1, 4, 5,968
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 481, 'INTERESES COBRADOS INTERCOMPAÑIAS', 'INTER', 4810, 'S/C', '', '', '8000-01-0004', 1, 0, 1, 4, 5,488
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 482, 'OTROS INGRESOS', 'OTROS', 4820, 'S/C', '', '', '9000-00-0000', 0, 0, 1, 2, 5,488
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 483, 'OTROS INGRESOS', 'OTROS', 4830, 'S/C', '', '', '9000-01-0000', 0, 0, 1, 3, 5,488
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 484, 'DIFERENCIA EN DEPOSITOS', 'DIFER', 4840, 'S/C', '', '', '9000-01-0001', 1, 0, 1, 4, 5,489
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 485, 'VENTA DE CAMIONES', 'VENTA', 4850, 'S/C', '', '', '9000-01-0002', 1, 0, 1, 4, 5,489
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 486, 'UTILIDAD EN VENTA DE ACTIVO', 'UTILI', 4860, 'S/C', '', '', '9000-01-0003', 1, 0, 1, 4, 5,489
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 487, 'DESCUENTOS SOBRE COMPRAS', 'DESCU', 4870, 'S/C', '', '', '9000-01-0004', 1, 0, 1, 4, 5,489
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 488, 'OTROS', 'OTROS', 4880, 'S/C', '', '', '9000-01-0005', 1, 0, 1, 4, 5,489
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 489, 'PENALIZACION CH. DEVUELTOS', 'PENAL', 4890, 'S/C', '', '', '9000-01-0006', 1, 0, 1, 4, 5,0
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 490, 'E G R E S O S', 'E G R', 4900, 'S/C', '', '', '0005-00-0000', 0, 0, 1, 1, 6,0
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 491, 'DESCTOS. Y BONIF. S/VENTAS', 'DESCT', 4910, 'S/C', '', '', '5000-00-0000', 0, 0, 1, 2, 6,483
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 492, 'DESCTOS. Y BONIF. S/VENTAS', 'DESCT', 4920, 'S/C', '', '', '5000-01-0000', 0, 0, 1, 3, 6,483
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 493, 'DESCTOS Y BONIF. S/VENTAS', 'DESCT', 4930, 'S/C', '', '', '5000-01-0001', 1, 0, 1, 4, 6,495
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 494, 'COSTO DE VENTA', 'COSTO', 4940, 'S/C', '', '', '6000-00-0000', 0, 0, 1, 2, 6,495
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 495, 'COSTO DE VENTA', 'COSTO', 4950, 'S/C', '', '', '6000-01-0000', 0, 0, 1, 3, 6,495
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 496, 'DE GAS L.P.', 'DE GA', 4960, 'S/C', '', '', '6000-01-0001', 1, 0, 1, 4, 6,496
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 497, 'DE TANQUES ESTACIONARIOS', 'DE TA', 4970, 'S/C', '', '', '6000-01-0002', 1, 0, 1, 4, 6,496
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 498, 'DE INSTALACIONES', 'DE IN', 4980, 'S/C', '', '', '6000-01-0003', 1, 0, 1, 4, 6,496
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 499, 'DE REFACCIONES', 'DE RE', 4990, 'S/C', '', '', '6000-01-0004', 1, 0, 1, 4, 6,496
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 500, 'DE TANQUES DE CARBURACION', 'DE TA', 5000, 'S/C', '', '', '6000-01-0005', 1, 0, 1, 4, 6,496
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 501, 'DE AUTOTANQUES', 'DE AU', 5010, 'S/C', '', '', '6000-01-0006', 1, 0, 1, 4, 6,496
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 502, 'DE CILINDRERAS', 'DE CI', 5020, 'S/C', '', '', '6000-01-0007', 1, 0, 1, 4, 6,496
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 503, 'DE PLATAFORMAS PARA CILINDRERA', 'DE PL', 5030, 'S/C', '', '', '6000-01-0008', 1, 0, 1, 4, 6,496
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 504, 'GASTOS ADMON Y VENTA', 'GASTO', 5040, 'S/C', '', '', '7000-00-0000', 0, 1, 1, 2, 6,541
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 505, 'SUELDO Y SALARIOS', 'SUELD', 5050, 'S/C', '', '', '7000-01-0000', 0, 1, 1, 3, 6,542
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 506, 'SUELDO A EMPLEADOS', 'SUELD', 5060, 'S/C', '', '', '7000-01-0001', 1, 1, 1, 4, 6,542
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 507, 'SUELDO A OBREROS', 'SUELD', 5070, 'S/C', '', '', '7000-01-0002', 1, 1, 1, 4, 6,542
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 508, 'SUELDO A VIGILANTES', 'SUELD', 5080, 'S/C', '', '', '7000-01-0003', 1, 1, 1, 4, 6,542
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 509, 'TIEMPO EXTRA', 'TIEMP', 5090, 'S/C', '', '', '7000-01-0004', 1, 1, 1, 4, 6,547
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 510, 'VACACIONES', 'VACAC', 5100, 'S/C', '', '', '7000-01-0005', 1, 1, 1, 4, 6,547
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 511, 'PRIMA VACACIONAL', 'PRIMA', 5110, 'S/C', '', '', '7000-01-0006', 1, 1, 1, 4, 6,548
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 512, 'PRIMA DOMINICAL', 'PRIMA', 5120, 'S/C', '', '', '7000-01-0007', 1, 1, 1, 4, 6,549
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 513, 'AGUINALDO', 'AGUIN', 5130, 'S/C', '', '', '7000-01-0008', 1, 1, 1, 4, 6,554
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 514, 'INDEMNIZACIONES', 'INDEM', 5140, 'S/C', '', '', '7000-01-0009', 1, 1, 1, 4, 6,554
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 515, 'PRIMA DE ANTIGUEDAD', 'PRIMA', 5150, 'S/C', '', '', '7000-01-0010', 1, 1, 1, 4, 6,552
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 516, 'GRATIFICACIONES', 'GRATI', 5160, 'S/C', '', '', '7000-01-0011', 1, 1, 1, 4, 6,551
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 517, 'FONDO DE AHORRO', 'FONDO', 5170, 'S/C', '', '', '7000-01-0012', 1, 1, 1, 4, 6,542
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 518, 'COMISIONES', 'COMIS', 5180, 'S/C', '', '', '7000-01-0013', 1, 1, 1, 4, 6,542
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 519, 'COMPENSACIONES', 'COMPE', 5190, 'S/C', '', '', '7000-01-0014', 1, 1, 1, 4, 6,551
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 520, 'PREMIO POR ASISTENCIA', 'PREMI', 5200, 'S/C', '', '', '7000-01-0020', 1, 1, 1, 4, 6,545
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 521, 'DESPENSAS', 'DESPE', 5210, 'S/C', '', '', '7000-01-0021', 1, 1, 1, 4, 6,541
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 522, 'PREVISION SOCIAL', 'PREVI', 5220, 'S/C', '', '', '7000-02-0000', 0, 1, 1, 3, 6,541
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 523, 'SERVICIOS MEDICOS Y MEDICINAS', 'SERVI', 5230, 'S/C', '', '', '7000-02-0001', 1, 1, 1, 4, 6,558
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 524, 'AYUDA PARA DESPENSA', 'AYUDA', 5240, 'S/C', '', '', '7000-02-0003', 1, 1, 1, 4, 6,556
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 525, 'AYUDA PARA GAS', 'AYUDA', 5250, 'S/C', '', '', '7000-02-0004', 1, 1, 1, 4, 6,559
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 526, 'AYUDA PARA FUNERALES', 'AYUDA', 5260, 'S/C', '', '', '7000-02-0005', 1, 1, 1, 4, 6,559
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 527, 'BECAS Y COLEGIATURAS', 'BECAS', 5270, 'S/C', '', '', '7000-02-0006', 1, 1, 1, 4, 6,564
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 528, 'CONSUMOS PARA OFICINAS', 'CONSU', 5280, 'S/C', '', '', '7000-02-0007', 1, 1, 1, 4, 6,564
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 529, 'UNIFORMES', 'UNIFO', 5290, 'S/C', '', '', '7000-02-0008', 1, 1, 1, 4, 6,564
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 530, 'CONSUMOS Y ARTS P/COMEDOR', 'CONSU', 5300, 'S/C', '', '', '7000-02-0010', 1, 1, 1, 4, 6,564
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 531, 'IMPUESTOS', 'IMPUE', 5310, 'S/C', '', '', '7000-03-0000', 0, 1, 1, 3, 6,541
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 532, 'CUOTAS DE SEGURIDAD SOCIAL', 'CUOTA', 5320, 'S/C', '', '', '7000-03-0001', 1, 1, 1, 4, 6,567
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 533, 'APORTACIONES AL  INFONAVIT', 'APORT', 5330, 'S/C', '', '', '7000-03-0002', 1, 1, 1, 4, 6,569
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 534, 'APORTACIONES AL RETIRO', 'APORT', 5340, 'S/C', '', '', '7000-03-0003', 1, 1, 1, 4, 6,569
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 535, 'IMPUESTO ESTATAL', 'IMPUE', 5350, 'S/C', '', '', '7000-03-0004', 1, 1, 1, 4, 6,570
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 536, 'APORTACIONES DE CESANTIA Y VEJEZ', 'APORT', 5360, 'S/C', '', '', '7000-03-0005', 1, 1, 1, 4, 6,571
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 537, 'SERVICIOS', 'SERVI', 5370, 'S/C', '', '', '7000-04-0000', 0, 1, 1, 3, 6,592
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 538, 'AGUA', 'AGUA', 5380, 'S/C', '', '', '7000-04-0001', 1, 1, 1, 4, 6,592
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 539, 'ENERGIA ELECTRICA', 'ENERG', 5390, 'S/C', '', '', '7000-04-0002', 1, 1, 1, 4, 6,593
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 540, 'TELEFONO', 'TELEF', 5400, 'S/C', '', '', '7000-04-0004', 1, 1, 1, 4, 6,591
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 541, 'VIGILANCIA', 'VIGIL', 5410, 'S/C', '', '', '7000-04-0005', 1, 1, 1, 4, 6,595
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 542, 'RECOLECCION DE BASURA', 'RECOL', 5420, 'S/C', '', '', '7000-04-0006', 1, 1, 1, 4, 6,595
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 543, 'ASESORIA Y SERVS. PROFESIONALES', 'ASESO', 5430, 'S/C', '', '', '7000-04-0007', 1, 1, 1, 4, 6,573
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 544, 'INTERNET', 'INTER', 5440, 'S/C', '', '', '7000-04-0008', 1, 1, 1, 4, 6,591
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 545, 'MANTENIMIENTOS', 'MANTE', 5450, 'S/C', '', '', '7000-05-0000', 0, 1, 1, 3, 6,597
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 546, 'A EDIFICIO', 'A EDI', 5460, 'S/C', '', '', '7000-05-0001', 1, 1, 1, 4, 6,597
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 547, 'A EQUIPO DE TRANSPORTE', 'A EQU', 5470, 'S/C', '', '', '7000-05-0002', 1, 1, 1, 4, 6,597
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 548, 'A EQUIPO DE PLANTA', 'A EQU', 5480, 'S/C', '', '', '7000-05-0003', 1, 1, 1, 4, 6,597
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 549, 'A TANQUES EN SERVICIO', 'A TAN', 5490, 'S/C', '', '', '7000-05-0004', 1, 1, 1, 4, 6,597
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 550, 'A MOBILIARIO Y EQUIPO DE OFICINA', 'A MOB', 5500, 'S/C', '', '', '7000-05-0005', 1, 1, 1, 4, 6,597
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 551, 'E EQUIPO TELEFONICO', 'E EQU', 5510, 'S/C', '', '', '7000-05-0006', 1, 1, 1, 4, 6,597
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 552, 'A EQUIPO DE COMPUTACION', 'A EQU', 5520, 'S/C', '', '', '7000-05-0007', 1, 1, 1, 4, 6,597
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 553, 'E EQUIPO DE RADIOCOMUNICACIONES', 'E EQU', 5530, 'S/C', '', '', '7000-05-0008', 1, 1, 1, 4, 6,597
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 554, 'A MAQUINAS Y HERRAMIENTAS', 'A MAQ', 5540, 'S/C', '', '', '7000-05-0009', 1, 1, 1, 4, 6,597
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 555, 'A CONSERVACION DE PLANTA', 'A CON', 5550, 'S/C', '', '', '7000-05-0010', 1, 1, 1, 4, 6,597
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 556, 'FLETES Y ACARREOS', 'FLETE', 5560, 'S/C', '', '', '7000-06-0000', 0, 1, 1, 3, 6,541
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 557, 'FLETES, ACARREOS Y MANIOBRAS', 'FLETE', 5570, 'S/C', '', '', '7000-06-0001', 1, 1, 1, 4, 6,613
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 558, 'MENSAJERIA', 'MENSA', 5580, 'S/C', '', '', '7000-06-0002', 1, 1, 1, 4, 6,613
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 559, 'TRASLADO DE VALORES', 'TRASL', 5590, 'S/C', '', '', '7000-06-0003', 1, 1, 1, 4, 6,613
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 560, 'OTROS IMPTOS Y DERECHOS', 'OTROS', 5600, 'S/C', '', '', '7000-07-0000', 0, 1, 1, 3, 6,541
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 561, 'IMPUESTO PREDIAL', 'IMPUE', 5610, 'S/C', '', '', '7000-07-0001', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 562, 'PLACAS Y TENENCIAS', 'PLACA', 5620, 'S/C', '', '', '7000-07-0002', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 563, 'RECARGOS', 'RECAR', 5630, 'S/C', '', '', '7000-07-0003', 1, 1, 1, 4, 6,600
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 564, 'PUENTES Y CAMINOS', 'PUENT', 5640, 'S/C', '', '', '7000-07-0005', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 565, 'REVISTAS Y VERIFICACIONES', 'REVIS', 5650, 'S/C', '', '', '7000-07-0006', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 566, 'OTROS DERECHOS', 'OTROS', 5660, 'S/C', '', '', '7000-07-0007', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 567, 'GASTOS VARIOS', 'GASTO', 5670, 'S/C', '', '', '7000-08-0000', 0, 1, 1, 3, 6,541
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 568, 'PAPELERIA Y ARTS DE OFICINA', 'PAPEL', 5680, 'S/C', '', '', '7000-08-0001', 1, 1, 1, 4, 6,596
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 569, 'ARTICULOS DE LIMPIEZA', 'ARTIC', 5690, 'S/C', '', '', '7000-08-0002', 1, 1, 1, 4, 6,601
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 570, 'CUOTAS Y SUSCRIPCIONES', 'CUOTA', 5700, 'S/C', '', '', '7000-08-0003', 1, 1, 1, 4, 6,601
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 571, 'HONORARIOS', 'HONOR', 5710, 'S/C', '', '', '7000-08-0004', 1, 1, 1, 4, 6,575
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 572, 'ARRENDAMIENTO', 'ARREN', 5720, 'S/C', '', '', '7000-08-0005', 1, 1, 1, 4, 6,586
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 573, 'DONATIVOS', 'DONAT', 5730, 'S/C', '', '', '7000-08-0006', 1, 1, 1, 4, 6,590
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 574, 'GASTOS DE VIAJE', 'GASTO', 5740, 'S/C', '', '', '7000-08-0007', 1, 1, 1, 4, 6,590
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 575, 'SEGUROS Y FIANZAS', 'SEGUR', 5750, 'S/C', '', '', '7000-08-0008', 1, 1, 1, 4, 6,598
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 576, 'PUBLICIDAD Y PROPAGANDA', 'PUBLI', 5760, 'S/C', '', '', '7000-08-0009', 1, 1, 1, 4, 6,602
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 577, 'COMBUSTIBLES Y LUBRICANTES', 'COMBU', 5770, 'S/C', '', '', '7000-08-0010', 1, 1, 1, 4, 6,603
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 578, 'CAPACITACION Y ADIESTRAMIENTO', 'CAPAC', 5780, 'S/C', '', '', '7000-08-0011', 1, 1, 1, 4, 6,603
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 579, 'PERDIDAS POR CASO FORTUITO', 'PERDI', 5790, 'S/C', '', '', '7000-08-0012', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 580, 'RESPONSIVAS TECNICAS', 'RESPO', 5800, 'S/C', '', '', '7000-08-0013', 1, 1, 1, 4, 6,605
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 581, 'ATENCION A CLIENTES', 'ATENC', 5810, 'S/C', '', '', '7000-08-0014', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 582, 'SERVICIO DE BASCULAS', 'SERVI', 5820, 'S/C', '', '', '7000-08-0015', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 583, 'HERRAMIENTAS', 'HERRA', 5830, 'S/C', '', '', '7000-08-0016', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 584, 'PASAJES LOCALES', 'PASAJ', 5840, 'S/C', '', '', '7000-08-0017', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 585, 'CONSERV. CLIENTES DE INSTALACION', 'CONSE', 5850, 'S/C', '', '', '7000-08-0018', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 586, 'OBSEQUIOS Y PROMOCIONES', 'OBSEQ', 5860, 'S/C', '', '', '7000-08-0019', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 587, 'GASTOS DE FIN DE AÑO', 'GASTO', 5870, 'S/C', '', '', '7000-08-0020', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 588, 'PENSIONES Y ESTACIONAMIENTOS', 'PENSI', 5880, 'S/C', '', '', '7000-08-0021', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 589, 'DAÑOS A TERCEROS', 'DAÑOS', 5890, 'S/C', '', '', '7000-08-0023', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 590, 'GASTOS DE REPRESENTACION', 'GASTO', 5900, 'S/C', '', '', '7000-08-0024', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 591, 'COMIDAS EN FUNCION DE TRABAJO', 'COMID', 5910, 'S/C', '', '', '7000-08-0025', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 592, 'GASTOS CONTRACTUALES', 'GASTO', 5920, 'S/C', '', '', '7000-08-0030', 1, 1, 1, 4, 6,625
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 593, 'RECARGOS', 'RECAR', 5930, 'S/C', '', '', '7000-08-0032', 1, 1, 1, 4, 6,579
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 594, 'HONORARIOS PERSONAS MORALES', 'HONOR', 5940, 'S/C', '', '', '7000-08-0033', 1, 1, 1, 4, 6,579
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 595, 'ARRENDAMIENTO SIN RETENCION', 'ARREN', 5950, 'S/C', '', '', '7000-08-0034', 1, 1, 1, 4, 6,587
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 596, 'GASTOS NO DEDUCIBLES', 'GASTO', 5960, 'S/C', '', '', '7000-09-0000', 0, 1, 1, 3, 6,541
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 597, 'NO DEDUCIBLES', 'NO DE', 5970, 'S/C', '', '', '7000-09-0001', 1, 1, 1, 4, 6,624
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 598, 'ASALTOS', 'ASALT', 5980, 'S/C', '', '', '7000-09-0003', 1, 1, 1, 4, 6,624
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 599, 'MULTAS, SANCIONES Y ACTN DE IMPTOS', 'MULTA', 5990, 'S/C', '', '', '7000-09-0004', 1, 1, 1, 4, 6,624
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 600, 'DEPRECIACIONES', 'DEPRE', 6000, 'S/C', '', '', '7100-00-0000', 0, 0, 1, 2, 6,924
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 601, 'DEPRECIACIONES', 'DEPRE', 6010, 'S/C', '', '', '7100-01-0000', 0, 0, 1, 3, 6,925
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 602, 'EDIFICIOS Y CONSTRUCCIONES', 'EDIFI', 6020, 'S/C', '', '', '7100-01-0001', 1, 0, 1, 4, 6,925
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 603, 'EQUIPO DE TRANSPORTE', 'EQUIP', 6030, 'S/C', '', '', '7100-01-0002', 1, 0, 1, 4, 6,927
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 604, 'EQUIPO DE TRANSPORTE USADO', 'EQUIP', 6040, 'S/C', '', '', '7100-01-0003', 1, 0, 1, 4, 6,927
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 605, 'EQUIPO DE PLANTA', 'EQUIP', 6050, 'S/C', '', '', '7100-01-0004', 1, 0, 1, 4, 6,926
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 606, 'MAQUINARIA Y HERRAMIENTAS', 'MAQUI', 6060, 'S/C', '', '', '7100-01-0005', 1, 0, 1, 4, 6,926
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 607, 'TANQUES DE ALMACENAMIENTO', 'TANQU', 6070, 'S/C', '', '', '7100-01-0006', 1, 0, 1, 4, 6,932
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 608, 'TANQUES EN SERVICIO', 'TANQU', 6080, 'S/C', '', '', '7100-01-0007', 1, 0, 1, 4, 6,932
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 609, 'MOBILIARIO Y EQUIPO DE OFICINA', 'MOBIL', 6090, 'S/C', '', '', '7100-01-0008', 1, 0, 1, 4, 6,932
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 610, 'EQUIPO TELEFONICO', 'EQUIP', 6100, 'S/C', '', '', '7100-01-0009', 1, 0, 1, 4, 6,932
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 611, 'EQUIPO DE COMPUTO', 'EQUIP', 6110, 'S/C', '', '', '7100-01-0010', 1, 0, 1, 4, 6,929
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 612, 'EQUIPO DE RADIO', 'EQUIP', 6120, 'S/C', '', '', '7100-01-0011', 1, 0, 1, 4, 6,932
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 613, 'EQUIPO DE COMUNICACION', 'EQUIP', 6130, 'S/C', '', '', '7100-01-0012', 1, 0, 1, 4, 6,943
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 614, 'AMORTIZACIONES', 'AMORT', 6140, 'S/C', '', '', '7200-00-0000', 0, 0, 1, 2, 6,943
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 615, 'AMORTIZACIONES', 'AMORT', 6150, 'S/C', '', '', '7200-01-0000', 0, 0, 1, 3, 6,943
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 616, 'AMORTIZACION', 'AMORT', 6160, 'S/C', '', '', '7200-01-0001', 1, 0, 1, 4, 6,944
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 617, 'GASTOS DE I.S.R.', 'GASTO', 6170, 'S/C', '', '', '7300-00-0000', 0, 0, 1, 2, 6,919
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 618, 'IMPUESTO SOBRE LA RENTA', 'IMPUE', 6180, 'S/C', '', '', '7300-01-0000', 0, 0, 1, 3, 6,919
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 619, 'I.S.R. DEL EJERCICIO', 'I.S.R', 6190, 'S/C', '', '', '7300-01-0001', 1, 0, 1, 4, 6,920
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 620, 'GASTOS DE P.T.U.', 'GASTO', 6200, 'S/C', '', '', '7400-00-0000', 0, 0, 1, 2, 6,911
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 621, 'PARTICIPACION DE UTILIDADES', 'PARTI', 6210, 'S/C', '', '', '7400-01-0000', 0, 0, 1, 3, 6,912
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 622, 'P.T.U. DEL EJERCICIO', 'P.T.U', 6220, 'S/C', '', '', '7400-01-0001', 1, 0, 1, 4, 6,912
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 623, 'GASTOS FINANCIEROS', 'GASTO', 6230, 'S/C', '', '', '9100-00-0000', 0, 0, 1, 2, 6,955
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 624, 'GASTOS FINANCIEROS', 'GASTO', 6240, 'S/C', '', '', '9100-01-0000', 0, 0, 1, 3, 6,955
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 625, 'COMISIONES Y SITUAC BANCARIAS', 'COMIS', 6250, 'S/C', '', '', '9100-01-0001', 1, 0, 1, 4, 6,959
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 626, 'INTERESES S/PMOS BANCARIOS', 'INTER', 6260, 'S/C', '', '', '9100-01-0002', 1, 0, 1, 4, 6,959
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 627, 'INTERESES PAGADOS A PEMEX', 'INTER', 6270, 'S/C', '', '', '9100-01-0003', 1, 0, 1, 4, 6,963
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 628, 'PERDIDA CAMBIARIA', 'PERDI', 6280, 'S/C', '', '', '9100-01-0004', 1, 0, 1, 4, 6,956
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 629, 'GASTOS POR FINANCIAMIENTOS', 'GASTO', 6290, 'S/C', '', '', '9100-01-0007', 1, 0, 1, 4, 6,963
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 630, 'INTERESES PAGADOS A TERMINAL TOMZA', 'INTER', 6300, 'S/C', '', '', '9100-01-0009', 1, 0, 1, 4, 6,963
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 631, 'COMISIONES BANCARIAS', 'COMIS', 6310, 'S/C', '', '', '9100-02-0000', 0, 0, 1, 3, 6,955
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 632, 'BANCOMER CTA 010436662 DLLS', 'BANCO', 6320, 'S/C', '', '', '9100-02-0001', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 633, 'BANCOMER CTA 0447730985', 'BANCO', 6330, 'S/C', '', '', '9100-02-0002', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 634, 'BANCOMER CTA 0447730926', 'BANCO', 6340, 'S/C', '', '', '9100-02-0003', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 635, 'BANCOMER CTA 0447730969', 'BANCO', 6350, 'S/C', '', '', '9100-02-0004', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 636, 'BANCOMER CTA 0447730977 DLLS', 'BANCO', 6360, 'S/C', '', '', '9100-02-0005', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 637, 'BANCOMER CTA 0447730993', 'BANCO', 6370, 'S/C', '', '', '9100-02-0006', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 638, 'BANCOMER CTA 0140539953', 'BANCO', 6380, 'S/C', '', '', '9100-02-0007', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 639, 'BANCOMER CTA 0162231689', 'BANCO', 6390, 'S/C', '', '', '9100-02-0008', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 640, 'BANCOMER CTA 016089703', 'BANCO', 6400, 'S/C', '', '', '9100-02-0009', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 641, 'BANCOMER CTA 0195973546', 'BANCO', 6410, 'S/C', '', '', '9100-02-0010', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 642, 'BANCOMER CTA 01043546772', 'BANCO', 6420, 'S/C', '', '', '9100-02-0011', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 643, 'BANCOMER CTA 0106597750', 'BANCO', 6430, 'S/C', '', '', '9100-02-0012', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 644, 'BANCOMER CTA 0107755155', 'BANCO', 6440, 'S/C', '', '', '9100-02-0013', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 645, 'BANCOMER CTA 0104249348', 'BANCO', 6450, 'S/C', '', '', '9100-02-0014', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 646, 'BANCOMER CTA 0110631043', 'BANCO', 6460, 'S/C', '', '', '9100-02-0015', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 647, 'SCOTIA CTA 101906720', 'SCOTI', 6470, 'S/C', '', '', '9100-02-0020', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 648, 'SCOTIA CTA 00101907018', 'SCOTI', 6480, 'S/C', '', '', '9100-02-0021', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 649, 'SCOTIA CTA 22603321975', 'SCOTI', 6490, 'S/C', '', '', '9100-02-0022', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 650, 'SCOTIA CTA 768863', 'SCOTI', 6500, 'S/C', '', '', '9100-02-0023', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 651, 'SCOTIA CTA 22603868028', 'SCOTI', 6510, 'S/C', '', '', '9100-02-0024', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 652, 'SCOTIA CTA 22603868389', 'SCOTI', 6520, 'S/C', '', '', '9100-02-0025', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 653, 'SCOTIA CTA 106880665', 'SCOTI', 6530, 'S/C', '', '', '9100-02-0026', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 654, 'SCOTIA CTA 22603637271', 'SCOTI', 6540, 'S/C', '', '', '9100-02-0027', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 655, 'SCOTIA CTA 22603837068', 'SCOTI', 6550, 'S/C', '', '', '9100-02-0028', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 656, 'SCOTIA CTA 22603138968', 'SCOTI', 6560, 'S/C', '', '', '9100-02-0029', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 657, 'SCOTIA CTA 106880835', 'SCOTI', 6570, 'S/C', '', '', '9100-02-0030', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 658, 'SCOTIA CTA 101950439', 'SCOTI', 6580, 'S/C', '', '', '9100-02-0031', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 659, 'SCOTIA CTA 22606343422', 'SCOTI', 6590, 'S/C', '', '', '9100-02-0032', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 660, 'SCOTIA CTA 2595639', 'SCOTI', 6600, 'S/C', '', '', '9100-02-0033', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 661, 'SCOTIA CTA 2595647', 'SCOTI', 6610, 'S/C', '', '', '9100-02-0034', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 662, 'SCOTIA CTA 2595688', 'SCOTI', 6620, 'S/C', '', '', '9100-02-0035', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 663, 'SCOTIA CTA 2595696', 'SCOTI', 6630, 'S/C', '', '', '9100-02-0036', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 664, 'SCOTIA CTA 4005244', 'SCOTI', 6640, 'S/C', '', '', '9100-02-0037', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 665, 'SCOTIA CTA 4005260', 'SCOTI', 6650, 'S/C', '', '', '9100-02-0038', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 666, 'SCOTIA CTA 22604126718', 'SCOTI', 6660, 'S/C', '', '', '9100-02-0039', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 667, 'SCOTIABANK CTA 4126955', 'SCOTI', 6670, 'S/C', '', '', '9100-02-0040', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 668, 'SCOTIABANK CTA 4126971', 'SCOTI', 6680, 'S/C', '', '', '9100-02-0041', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 669, 'HSBC CTA 4029611472', 'HSBC ', 6690, 'S/C', '', '', '9100-02-0050', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 670, 'HSBC INVERSION', 'HSBC ', 6700, 'S/C', '', '', '9100-02-0051', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 671, 'BANAMEX CTA 6643652', 'BANAM', 6710, 'S/C', '', '', '9100-02-0052', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 672, 'SANTANDER CTA 7753', 'SANTA', 6720, 'S/C', '', '', '9100-02-0053', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 673, 'SANTANDER CTA 271355', 'SANTA', 6730, 'S/C', '', '', '9100-02-0054', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 674, 'SANTANDER CTA 31217131', 'SANTA', 6740, 'S/C', '', '', '9100-02-0055', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 675, 'SANTANDER CTA 3628300', 'SANTA', 6750, 'S/C', '', '', '9100-02-0056', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 676, 'BANORTE CTA 266924960', 'BANOR', 6760, 'S/C', '', '', '9100-02-0057', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 677, 'INBURSA CTA 50001083591', 'INBUR', 6770, 'S/C', '', '', '9100-02-0058', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 678, 'INBURSA CTA 50015365135', 'INBUR', 6780, 'S/C', '', '', '9100-02-0059', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 679, 'WEST STAR BANK CTA 4156455', 'WEST ', 6790, 'S/C', '', '', '9100-02-0060', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 680, 'WEST STAR BANK CTA 4185978', 'WEST ', 6800, 'S/C', '', '', '9100-02-0061', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 681, 'INTERNATIONAL BANK CTA 2218348', 'INTER', 6810, 'S/C', '', '', '9100-02-0062', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 682, 'BBVA COMPASS BANK CTA 6749416821', 'BBVA ', 6820, 'S/C', '', '', '9100-02-0063', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 683, 'INTERACCIONES 100047730', 'INTER', 6830, 'S/C', '', '', '9100-02-0064', 1, 0, 1, 4, 6,965
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 684, 'OTROS GASTOS', 'OTROS', 6840, 'S/C', '', '', '9200-00-0000', 0, 0, 1, 2, 6,978
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 685, 'OTROS GASTOS', 'OTROS', 6850, 'S/C', '', '', '9200-01-0000', 0, 0, 1, 3, 6,999
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 686, 'DIFERENCIA EN DEPOSITOS', 'DIFER', 6860, 'S/C', '', '', '9200-01-0001', 1, 0, 1, 4, 6,999
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 687, 'DIFERENCIA EN CHEQUES', 'DIFER', 6870, 'S/C', '', '', '9200-01-0002', 1, 0, 1, 4, 6,999
EXECUTE [dbo].[PG_CI_CUENTA_CONTABLE] 0, 0, 0, 688, 'OTROS', 'OTROS', 6880, 'S/C', '', '', '9200-01-0004', 1, 0, 1, 4, 6,999


GO

-- ===============================================

SET NOCOUNT OFF





-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
