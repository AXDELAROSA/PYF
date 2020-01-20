-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			FACTURA_CXP
-- // OPERACION:		LIBERACION - CARGA_INICIAL
-- //////////////////////////////////////////////////////////////  
-- // Autor:			Alex de la Rosa
-- // Fecha creación:	18/09/2018
-- //////////////////////////////////////////////////////////////  

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////
-- SELECT * FROM	FACTURA_CXP

DECLARE @VP_FOLIO INT = 1001

DELETE	
FROM	FACTURA_CXP
WHERE	(@VP_FOLIO*1000)<=K_FACTURA_CXP AND K_FACTURA_CXP<=(@VP_FOLIO*1000+999) 

GO



-- //////////////////////////////////////////////////////////////
-- //				CI - FACTURA_CXP
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_FACTURA_CXP]
GO


CREATE PROCEDURE [dbo].[PG_CI_FACTURA_CXP]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- =======================
	@PP_K_FACTURA_CXP				INT,
	@PP_C_FACTURA_CXP				VARCHAR(255),
	@PP_K_TIPO_COMPROBANTE			INT,
	-- =======================
	@PP_RFC_EMISOR					VARCHAR (100),
	--@PP_K_PROVEEDOR					INT,
	@PP_RFC_RECEPTOR				VARCHAR (100), 		
	--@PP_K_RAZON_SOCIAL				INT,
	@PP_F_EMISION					DATE,
	@PP_SERIE						VARCHAR (100),
	@PP_FOLIO						VARCHAR (100),
	-- =======================
	@PP_SUBTOTAL					DECIMAL (19,4),		
	@PP_IVA							DECIMAL (19,4),
	@PP_OTROS_IMPUESTOS				DECIMAL (19,4),
	@PP_TOTAL						DECIMAL (16,2),	
	-- =======================
	@PP_K_CAPTURA_FACTURA_CXP		INT,	
	@PP_K_ESTATUS_FACTURA_CXP		INT	
AS			
	
	-- ===========================

	INSERT INTO FACTURA_CXP
			(	[K_FACTURA_CXP],[C_FACTURA_CXP],	
				[K_TIPO_COMPROBANTE],		
				-- =========================
				[RFC_EMISOR],	[RFC_RECEPTOR],	
				[K_PROVEEDOR],	[K_RAZON_SOCIAL],			
				[F_EMISION],	
				[SERIE], [FOLIO],
				[F_VENCIMIENTO],
				-- =========================
				[SUBTOTAL],			[IVA],						
				[OTROS_IMPUESTOS],	[TOTAL],						
				-- =========================
				[ABONOS], [SALDO],
				-- =========================
				[K_CAPTURA_FACTURA_CXP], 
				[K_ESTATUS_FACTURA_CXP],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@PP_K_FACTURA_CXP,	@PP_C_FACTURA_CXP,		
				@PP_K_TIPO_COMPROBANTE,
				-- =======================
				@PP_RFC_EMISOR,		@PP_RFC_RECEPTOR,		
				NULL,				NULL,		-- @PP_K_PROVEEDOR, @PP_K_RAZON_SOCIAL,			
				@PP_F_EMISION,		
				@PP_SERIE, @PP_FOLIO,
				@PP_F_EMISION,					
				-- =======================
				@PP_SUBTOTAL,		@PP_IVA,
				@PP_OTROS_IMPUESTOS,@PP_TOTAL,					
				-- =======================
				0, 0,
				-- =======================
				@PP_K_CAPTURA_FACTURA_CXP,
				@PP_K_ESTATUS_FACTURA_CXP,	
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )

	-- ========================================

	EXECUTE [dbo].[PG_UP_FACTURA_CXP_SALDO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_FACTURA_CXP
	
	EXECUTE [dbo].[PG_UP_FACTURA_CXP_K_RAZON_SOCIAL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_FACTURA_CXP

	EXECUTE [dbo].[PG_UP_FACTURA_CXP_K_PROVEEDOR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_FACTURA_CXP
	-- ========================================
GO





-- ===============================================
SET NOCOUNT ON
-- ===============================================
-- SELECT * FROM	FACTURA_CXP


-- ==========================================================
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001001, 'ABASTECIMIENTO GAS #1001001 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-14','GYP', '10-1001001' ,510677,81708.3199999999,0 ,592385.32 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001002, 'ABASTECIMIENTO GAS #1001002 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-14','GYP', '10-1001002' ,495734,79317.4399999999,0 ,575051.44 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001003, 'ABASTECIMIENTO GAS #1001003 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-14','GYP', '10-1001003' ,546928,87508.48,0 ,634436.48 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001004, 'ABASTECIMIENTO GAS #1001004 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-14','GYP', '10-1001004' ,509508,81521.2799999999,0 ,591029.28 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001005, 'ABASTECIMIENTO GAS #1001005 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-15','GYP', '10-1001005' ,459915,73586.3999999999,0 ,533501.4 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001006, 'ABASTECIMIENTO GAS #1001006 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-15','GYP', '10-1001006' ,499167,79866.72,0 ,579033.72 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001007, 'ABASTECIMIENTO GAS #1001007 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-15','GYP', '10-1001007' ,526578,84252.48,0 ,610830.48 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001008, 'ABASTECIMIENTO GAS #1001008 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-16','GYP', '10-1001008' ,537296,85967.36,0 ,623263.36 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001009, 'ABASTECIMIENTO GAS #1001009 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-16','GYP', '10-1001009' ,462647,74023.52,0 ,536670.52 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001010, 'ABASTECIMIENTO GAS #1001010 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-17','GYP', '10-1001010' ,498379,79740.64,0 ,578119.64 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001011, 'ABASTECIMIENTO GAS #1001011 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-17','GYP', '10-1001011' ,548843,87814.88,0 ,636657.88 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001012, 'ABASTECIMIENTO GAS #1001012 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-17','GYP', '10-1001012' ,546644,87463.0399999999,0 ,634107.04 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001013, 'ABASTECIMIENTO GAS #1001013 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-17','GYP', '10-1001013' ,457678,73228.48,0 ,530906.48 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001014, 'ABASTECIMIENTO GAS #1001014 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-17','GYP', '10-1001014' ,549135,87861.6,0 ,636996.6 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001015, 'ABASTECIMIENTO GAS #1001015 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-17','GYP', '10-1001015' ,531586,85053.76,0 ,616639.76 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001016, 'ABASTECIMIENTO GAS #1001016 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-18','GYP', '10-1001016' ,514418,82306.88,0 ,596724.88 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001017, 'ABASTECIMIENTO GAS #1001017 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-18','GYP', '10-1001017' ,483590,77374.3999999999,0 ,560964.4 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001018, 'ABASTECIMIENTO GAS #1001018 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-18','GYP', '10-1001018' ,539520,86323.2,0 ,625843.2 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001019, 'ABASTECIMIENTO GAS #1001019 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-19','GYP', '10-1001019' ,490568,78490.88,0 ,569058.88 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001020, 'ABASTECIMIENTO GAS #1001020 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-19','GYP', '10-1001020' ,534100,85456,0 ,619556 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001021, 'ABASTECIMIENTO GAS #1001021 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-20','GYP', '10-1001021' ,506878,81100.48,0 ,587978.48 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001022, 'ABASTECIMIENTO GAS #1001022 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-20','GYP', '10-1001022' ,484313,77490.08,0 ,561803.08 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001023, 'ABASTECIMIENTO GAS #1001023 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-20','GYP', '10-1001023' ,545911,87345.76,0 ,633256.76 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001024, 'ABASTECIMIENTO GAS #1001024 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-20','GYP', '10-1001024' ,461124,73779.84,0 ,534903.84 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001025, 'ABASTECIMIENTO GAS #1001025 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-20','GYP', '10-1001025' ,480551,76888.1599999999,0 ,557439.16 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001026, 'ABASTECIMIENTO GAS #1001026 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-20','GYP', '10-1001026' ,531282,85005.12,0 ,616287.12 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001027, 'ABASTECIMIENTO GAS #1001027 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-21','GYP', '10-1001027' ,532756,85240.96,0 ,617996.96 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001028, 'ABASTECIMIENTO GAS #1001028 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-21','GYP', '10-1001028' ,543793,87006.88,0 ,630799.88 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001029, 'ABASTECIMIENTO GAS #1001029 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-21','GYP', '10-1001029' ,520066,83210.5599999999,0 ,603276.56 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001030, 'ABASTECIMIENTO GAS #1001030 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-22','GYP', '10-1001030' ,518968,83034.88,0 ,602002.88 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001031, 'ABASTECIMIENTO GAS #1001031 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-22','GYP', '10-1001031' ,548573,87771.6799999999,0 ,636344.68 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001032, 'ABASTECIMIENTO GAS #1001032 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-23','GYP', '10-1001032' ,535196,85631.36,0 ,620827.36 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001033, 'ABASTECIMIENTO GAS #1001033 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-23','GYP', '10-1001033' ,498462,79753.9199999999,0 ,578215.92 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001034, 'ABASTECIMIENTO GAS #1001034 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-23','GYP', '10-1001034' ,470268,75242.88,0 ,545510.88 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001035, 'ABASTECIMIENTO GAS #1001035 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-23','GYP', '10-1001035' ,498775,79804,0 ,578579 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001036, 'ABASTECIMIENTO GAS #1001036 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-23','GYP', '10-1001036' ,546668,87466.88,0 ,634134.88 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001037, 'ABASTECIMIENTO GAS #1001037 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-23','GYP', '10-1001037' ,456155,72984.7999999999,0 ,529139.8 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001038, 'ABASTECIMIENTO GAS #1001038 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-24','GYP', '10-1001038' ,467615,74818.3999999999,0 ,542433.4 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001039, 'ABASTECIMIENTO GAS #1001039 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-24','GYP', '10-1001039' ,490387,78461.9199999999,0 ,568848.92 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001040, 'ABASTECIMIENTO GAS #1001040 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-24','GYP', '10-1001040' ,506207,80993.12,0 ,587200.12 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001041, 'ABASTECIMIENTO GAS #1001041 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-25','GYP', '10-1001041' ,520981,83356.96,0 ,604337.96 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001042, 'ABASTECIMIENTO GAS #1001042 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-25','GYP', '10-1001042' ,521749,83479.84,0 ,605228.84 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001043, 'ABASTECIMIENTO GAS #1001043 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-26','GYP', '10-1001043' ,547588,87614.08,0 ,635202.08 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001044, 'ABASTECIMIENTO GAS #1001044 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-26','GYP', '10-1001044' ,528537,84565.9199999999,0 ,613102.92 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001045, 'ABASTECIMIENTO GAS #1001045 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-26','GYP', '10-1001045' ,496900,79504,0 ,576404 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001046, 'ABASTECIMIENTO GAS #1001046 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-26','GYP', '10-1001046' ,519961,83193.76,0 ,603154.76 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001047, 'ABASTECIMIENTO GAS #1001047 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-26','GYP', '10-1001047' ,523428,83748.48,0 ,607176.48 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001048, 'ABASTECIMIENTO GAS #1001048 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-26','GYP', '10-1001048' ,479980,76796.7999999999,0 ,556776.8 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001049, 'ABASTECIMIENTO GAS #1001049 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-27','GYP', '10-1001049' ,454384,72701.4399999999,0 ,527085.44 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001050, 'ABASTECIMIENTO GAS #1001050 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-27','GYP', '10-1001050' ,495462,79273.9199999999,0 ,574735.92 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001051, 'ABASTECIMIENTO GAS #1001051 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-27','GYP', '10-1001051' ,500289,80046.24,0 ,580335.24 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001052, 'ABASTECIMIENTO GAS #1001052 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-28','GYP', '10-1001052' ,532960,85273.6,0 ,618233.6 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001053, 'ABASTECIMIENTO GAS #1001053 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-28','GYP', '10-1001053' ,547345,87575.2,0 ,634920.2 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001054, 'ABASTECIMIENTO GAS #1001054 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-29','GYP', '10-1001054' ,539091,86254.5599999999,0 ,625345.56 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001055, 'ABASTECIMIENTO GAS #1001055 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-29','GYP', '10-1001055' ,544358,87097.2799999999,0 ,631455.28 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001056, 'ABASTECIMIENTO GAS #1001056 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-29','GYP', '10-1001056' ,450348,72055.68,0 ,522403.68 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001057, 'ABASTECIMIENTO GAS #1001057 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-29','GYP', '10-1001057' ,527032,84325.12,0 ,611357.12 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001058, 'ABASTECIMIENTO GAS #1001058 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-29','GYP', '10-1001058' ,471323,75411.6799999999,0 ,546734.68 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001059, 'ABASTECIMIENTO GAS #1001059 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-29','GYP', '10-1001059' ,528240,84518.3999999999,0 ,612758.4 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001060, 'ABASTECIMIENTO GAS #1001060 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-30','GYP', '10-1001060' ,486947,77911.52,0 ,564858.52 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001061, 'ABASTECIMIENTO GAS #1001061 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-30','GYP', '10-1001061' ,492155,78744.7999999999,0 ,570899.8 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001062, 'ABASTECIMIENTO GAS #1001062 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-09-30','GYP', '10-1001062' ,450920,72147.2,0 ,523067.2 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001063, 'ABASTECIMIENTO GAS #1001063 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-01','GYP', '10-1001063' ,539214,86274.24,0 ,625488.24 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001064, 'ABASTECIMIENTO GAS #1001064 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-01','GYP', '10-1001064' ,536278,85804.48,0 ,622082.48 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001065, 'ABASTECIMIENTO GAS #1001065 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-02','GYP', '10-1001065' ,495360,79257.6,0 ,574617.6 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001066, 'ABASTECIMIENTO GAS #1001066 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-02','GYP', '10-1001066' ,502788,80446.08,0 ,583234.08 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001067, 'ABASTECIMIENTO GAS #1001067 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-02','GYP', '10-1001067' ,521460,83433.6,0 ,604893.6 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001068, 'ABASTECIMIENTO GAS #1001068 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-02','GYP', '10-1001068' ,536075,85772,0 ,621847 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001069, 'ABASTECIMIENTO GAS #1001069 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-02','GYP', '10-1001069' ,498843,79814.88,0 ,578657.88 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001070, 'ABASTECIMIENTO GAS #1001070 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-02','GYP', '10-1001070' ,530761,84921.76,0 ,615682.76 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001071, 'ABASTECIMIENTO GAS #1001071 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-03','GYP', '10-1001071' ,525747,84119.5199999999,0 ,609866.52 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001072, 'ABASTECIMIENTO GAS #1001072 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-03','GYP', '10-1001072' ,484751,77560.1599999999,0 ,562311.16 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001073, 'ABASTECIMIENTO GAS #1001073 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-03','GYP', '10-1001073' ,505855,80936.7999999999,0 ,586791.8 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001074, 'ABASTECIMIENTO GAS #1001074 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-04','GYP', '10-1001074' ,471389,75422.24,0 ,546811.24 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001075, 'ABASTECIMIENTO GAS #1001075 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-04','GYP', '10-1001075' ,454494,72719.0399999999,0 ,527213.04 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001076, 'ABASTECIMIENTO GAS #1001076 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-05','GYP', '10-1001076' ,518341,82934.5599999999,0 ,601275.56 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001077, 'ABASTECIMIENTO GAS #1001077 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-05','GYP', '10-1001077' ,510595,81695.2,0 ,592290.2 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001078, 'ABASTECIMIENTO GAS #1001078 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-05','GYP', '10-1001078' ,499100,79856,0 ,578956 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001079, 'ABASTECIMIENTO GAS #1001079 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-05','GYP', '10-1001079' ,543234,86917.4399999999,0 ,630151.44 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001080, 'ABASTECIMIENTO GAS #1001080 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-05','GYP', '10-1001080' ,494251,79080.1599999999,0 ,573331.16 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001081, 'ABASTECIMIENTO GAS #1001081 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-05','GYP', '10-1001081' ,485406,77664.96,0 ,563070.96 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001082, 'ABASTECIMIENTO GAS #1001082 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-06','GYP', '10-1001082' ,474913,75986.08,0 ,550899.08 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001083, 'ABASTECIMIENTO GAS #1001083 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-06','GYP', '10-1001083' ,516829,82692.64,0 ,599521.64 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001084, 'ABASTECIMIENTO GAS #1001084 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-06','GYP', '10-1001084' ,505875,80940,0 ,586815 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001085, 'ABASTECIMIENTO GAS #1001085 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-07','GYP', '10-1001085' ,492456,78792.96,0 ,571248.96 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001086, 'ABASTECIMIENTO GAS #1001086 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-07','GYP', '10-1001086' ,545965,87354.3999999999,0 ,633319.4 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001087, 'ABASTECIMIENTO GAS #1001087 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-08','GYP', '10-1001087' ,542445,86791.2,0 ,629236.2 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001088, 'ABASTECIMIENTO GAS #1001088 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-08','GYP', '10-1001088' ,523763,83802.08,0 ,607565.08 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001089, 'ABASTECIMIENTO GAS #1001089 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-08','GYP', '10-1001089' ,459135,73461.6,0 ,532596.6 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001090, 'ABASTECIMIENTO GAS #1001090 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-08','GYP', '10-1001090' ,473183,75709.2799999999,0 ,548892.28 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001091, 'ABASTECIMIENTO GAS #1001091 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-08','GYP', '10-1001091' ,499687,79949.9199999999,0 ,579636.92 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001092, 'ABASTECIMIENTO GAS #1001092 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-08','GYP', '10-1001092' ,506041,80966.5599999999,0 ,587007.56 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001093, 'ABASTECIMIENTO GAS #1001093 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-09','GYP', '10-1001093' ,527498,84399.6799999999,0 ,611897.68 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001094, 'ABASTECIMIENTO GAS #1001094 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-09','GYP', '10-1001094' ,467790,74846.3999999999,0 ,542636.4 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001095, 'ABASTECIMIENTO GAS #1001095 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-09','GYP', '10-1001095' ,537634,86021.4399999999,0 ,623655.44 ,1,2
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001096, 'ABASTECIMIENTO GAS #1001096 / [RFC] Gas Butep' , 2 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-10','GYP', '10-1001096' ,512297,81967.5199999999,0 ,594264.52 ,1,3
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001097, 'ABASTECIMIENTO GAS #1001097 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-10','GYP', '10-1001097' ,545484,87277.4399999999,0 ,632761.44 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001098, 'ABASTECIMIENTO GAS #1001098 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-11','GYP', '10-1001098' ,484858,77577.2799999999,0 ,562435.28 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001099, 'ABASTECIMIENTO GAS #1001099 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-11','GYP', '10-1001099' ,544260,87081.6,0 ,631341.6 ,1,1
EXECUTE [dbo].[PG_CI_FACTURA_CXP] 0, 0, 0, 1001100, 'ABASTECIMIENTO GAS #1001100 / [RFC] Gas Butep' , 1 , 'IGP160201NK5' , 'GBU7109148V4' , '2018-10-11','GYP', '10-1001100' ,459355,73496.7999999999,0 ,532851.8 ,1,1

GO



-- ===============================================
SET NOCOUNT OFF
-- ===============================================



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////



