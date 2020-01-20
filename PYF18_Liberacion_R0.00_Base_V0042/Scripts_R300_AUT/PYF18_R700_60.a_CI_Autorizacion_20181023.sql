-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_R700_30.a_CI_Autorizacion
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			AUTORIZACIONES
-- // OPERACION:		LIBERACION / TABLAS
-- //////////////////////////////////////////////////////////////
-- // Autor:			ALEX DE LA ROSA // HECTOR A. GONZALEZ 
-- // Fecha creación:	23/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- ///////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////


DELETE
FROM	AUTORIZACION
GO




-- ///////////////////////////////////////////////////////////////
-- //					CI - AUTORIZACION					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_AUTORIZACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_AUTORIZACION]
GO


CREATE PROCEDURE [dbo].[PG_CI_AUTORIZACION] 
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===============================
	@PP_K_AUTORIZACION				INT,
	@PP_D_AUTORIZACION				VARCHAR(100),		
	@PP_S_AUTORIZACION				VARCHAR(10),		
	@PP_C_AUTORIZACION				VARCHAR(500),				
	-- ===========================
	@PP_K_ESTATUS_AUTORIZACION		INT,
	@PP_K_TIPO_AUTORIZACION			INT,	
	@PP_LIMITE_INFERIOR				DECIMAL(19,4),		
	@PP_LIMITE_SUPERIOR				DECIMAL(19,4),				
	-- ===========================
	@PP_K_MODO_AUTORIZACION_P1		INT,
	@PP_N_DIAS_AUTORIZACION_P1		INT,
	@PP_K_ROL_AUTORIZACION_P1A		INT,
	@PP_K_ROL_AUTORIZACION_P1B		INT,
	@PP_K_ROL_AUTORIZACION_P1C		INT,
	-- ===========================
	@PP_K_MODO_AUTORIZACION_P2		INT,
	@PP_N_DIAS_AUTORIZACION_P2		INT,
	@PP_K_ROL_AUTORIZACION_P2A		INT,
	@PP_K_ROL_AUTORIZACION_P2B		INT,
	@PP_K_ROL_AUTORIZACION_P2C		INT,
	-- ===========================
	@PP_K_MODO_AUTORIZACION_P3		INT,
	@PP_N_DIAS_AUTORIZACION_P3		INT,
	@PP_K_ROL_AUTORIZACION_P3A		INT,
	@PP_K_ROL_AUTORIZACION_P3B		INT,
	@PP_K_ROL_AUTORIZACION_P3C		INT,
	-- ===========================
	@PP_K_MODO_AUTORIZACION_P4		INT,
	@PP_N_DIAS_AUTORIZACION_P4		INT,
	@PP_K_ROL_AUTORIZACION_P4A		INT,
	@PP_K_ROL_AUTORIZACION_P4B		INT,
	@PP_K_ROL_AUTORIZACION_P4C		INT,
	-- ===========================
	@PP_K_MODO_AUTORIZACION_P5		INT,
	@PP_N_DIAS_AUTORIZACION_P5		INT,
	@PP_K_ROL_AUTORIZACION_P5A		INT,
	@PP_K_ROL_AUTORIZACION_P5B		INT,
	@PP_K_ROL_AUTORIZACION_P5C		INT

AS
	INSERT INTO AUTORIZACION
			(	
			[K_AUTORIZACION], [D_AUTORIZACION],
			[S_AUTORIZACION], [C_AUTORIZACION],	
			-- =====================
			[K_ESTATUS_AUTORIZACION], [K_TIPO_AUTORIZACION],
			[LIMITE_INFERIOR],	[LIMITE_SUPERIOR],
			-- =====================
			[K_MODO_AUTORIZACION_P1], [N_DIAS_AUTORIZACION_P1],
			[K_ROL_AUTORIZACION_P1A], [K_ROL_AUTORIZACION_P1B],
			[K_ROL_AUTORIZACION_P1C],
			-- =====================
			[K_MODO_AUTORIZACION_P2], [N_DIAS_AUTORIZACION_P2],
			[K_ROL_AUTORIZACION_P2A], [K_ROL_AUTORIZACION_P2B],
			[K_ROL_AUTORIZACION_P2C],
			-- =====================
			[K_MODO_AUTORIZACION_P3], [N_DIAS_AUTORIZACION_P3],
			[K_ROL_AUTORIZACION_P3A], [K_ROL_AUTORIZACION_P3B],
			[K_ROL_AUTORIZACION_P3C],
			-- =====================
			[K_MODO_AUTORIZACION_P4], [N_DIAS_AUTORIZACION_P4],
			[K_ROL_AUTORIZACION_P4A], [K_ROL_AUTORIZACION_P4B],
			[K_ROL_AUTORIZACION_P4C],
			-- =====================
			[K_MODO_AUTORIZACION_P5], [N_DIAS_AUTORIZACION_P5],
			[K_ROL_AUTORIZACION_P5A], [K_ROL_AUTORIZACION_P5B],
			[K_ROL_AUTORIZACION_P5C],
			-- =====================
			[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]
			)
		VALUES
			(
			@PP_K_AUTORIZACION, @PP_D_AUTORIZACION,
			@PP_S_AUTORIZACION,	@PP_C_AUTORIZACION,
			-- ===========================
			@PP_K_ESTATUS_AUTORIZACION,	@PP_K_TIPO_AUTORIZACION,
			@PP_LIMITE_INFERIOR, @PP_LIMITE_SUPERIOR,
			-- ===========================
			@PP_K_MODO_AUTORIZACION_P1, @PP_N_DIAS_AUTORIZACION_P1,
			@PP_K_ROL_AUTORIZACION_P1A, @PP_K_ROL_AUTORIZACION_P1B,
			@PP_K_ROL_AUTORIZACION_P1C,
			-- ===========================
			@PP_K_MODO_AUTORIZACION_P2, @PP_N_DIAS_AUTORIZACION_P2,	
			@PP_K_ROL_AUTORIZACION_P2A, @PP_K_ROL_AUTORIZACION_P2B,	
			@PP_K_ROL_AUTORIZACION_P2C,		
			-- ===========================
			@PP_K_MODO_AUTORIZACION_P3, @PP_N_DIAS_AUTORIZACION_P3,
			@PP_K_ROL_AUTORIZACION_P3A, @PP_K_ROL_AUTORIZACION_P3B,
			@PP_K_ROL_AUTORIZACION_P3C,
			-- ===========================
			@PP_K_MODO_AUTORIZACION_P4, @PP_N_DIAS_AUTORIZACION_P4,
			@PP_K_ROL_AUTORIZACION_P4A, @PP_K_ROL_AUTORIZACION_P4B,
			@PP_K_ROL_AUTORIZACION_P4C,
			-- ===========================
			@PP_K_MODO_AUTORIZACION_P5, @PP_N_DIAS_AUTORIZACION_P5,
			@PP_K_ROL_AUTORIZACION_P5A, @PP_K_ROL_AUTORIZACION_P5B,
			@PP_K_ROL_AUTORIZACION_P5C,
			-- ===========================
			@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL )

GO



-- //////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////


-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_AUTORIZACION] 0, 0, 0, 1, 'LIC. F ROBLES' , 'FROBL' , 'QA   //  LIC. F ROBLES',1 ,0,7000,9000, 2 ,2,2,2 ,2 ,1,20,0,1,2,1,2,1,2,0,2,15,0,2,2,0,11,1,2,2
EXECUTE [dbo].[PG_CI_AUTORIZACION] 0, 0, 0, 2, 'LIC. O GONZALEZ' , 'OGLEZ' , 'QA   //  LIC. O GONZALEZ',1 ,0,800,1500, 2 ,20,1,2 ,1 ,1,1,0,0,2,3,17,1,2,0,2,16,0,2,2,1,20,1,1,2
EXECUTE [dbo].[PG_CI_AUTORIZACION] 0, 0, 0, 3, 'TESORERIA' , 'TESOR' , 'QA   //  TESORERIA',1 ,0,25000,38000, 1 ,17,1,0 ,1 ,0,15,0,1,2,2,14,1,1,2,2,13,1,2,1,2,5,2,1,2
EXECUTE [dbo].[PG_CI_AUTORIZACION] 0, 0, 0, 4, 'FINANCIAMIENTO' , 'FNCIM' , 'QA   //  FINANCIAMIENTO',1 ,0,35000,50000, 3 ,18,1,0 ,0 ,1,15,1,1,2,1,14,1,1,2,1,5,1,2,1,1,19,1,2,2
EXECUTE [dbo].[PG_CI_AUTORIZACION] 0, 0, 0, 5, 'PLANEACIÓN' , 'PLANE' , 'QA   //  PLANEACIÓN',1 ,0,100000,150000, 0 ,9,1,1 ,0 ,2,7,1,2,1,3,1,2,0,0,1,11,2,1,0,1,13,1,1,1
EXECUTE [dbo].[PG_CI_AUTORIZACION] 0, 0, 0, 6, 'EGRESOS' , 'EGRSO' , 'QA   //  EGRESOS',1 ,0,35000,60000, 0 ,3,0,0 ,0 ,0,12,2,2,1,2,19,2,2,2,2,17,1,1,2,1,4,1,1,2
EXECUTE [dbo].[PG_CI_AUTORIZACION] 0, 0, 0, 7, 'RECURSOS HUMANOS' , 'RH.RH' , 'QA   //  RECURSOS HUMANOS',1 ,0,40000,45000, 1 ,2,2,2 ,0 ,0,15,2,2,1,3,17,2,0,2,1,7,1,2,0,1,11,1,1,2

GO


-- ===============================================
SET NOCOUNT OFF
-- ===============================================


-- //////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////



-- ===============================================
SET NOCOUNT ON
-- ===============================================


DELETE
FROM	AUTORIZACION
WHERE	K_AUTORIZACION>1000
GO

EXECUTE [dbo].[PG_CI_AUTORIZACION] 0, 0, 0, 1001, 'RECURSO-PLANTA / 25$EXTRA' , 'EXT' , 'QA // RECURSO-PLANTA / 25$EXTRA #1001',1 ,1,0,25000, 2 ,1,1,0 ,0 ,0,2,0,0,0,0,3,0,0,0,0,4,0,0,0,0,0,0,0,0
EXECUTE [dbo].[PG_CI_AUTORIZACION] 0, 0, 0, 1002, 'RECURSO-PLANTA / 50$EXTRA' , 'EXT' , 'QA // RECURSO-PLANTA / 50$EXTRA #1002',1 ,1,25000,50000, 2 ,1,1,0 ,0 ,2,2,3,0,0,0,3,0,0,0,0,4,0,0,0,0,0,0,0,0
EXECUTE [dbo].[PG_CI_AUTORIZACION] 0, 0, 0, 1003, 'RECURSO-PLANTA / 100$EXTRA' , 'EXT' , 'QA // RECURSO-PLANTA / 100$EXTRA #1003',1 ,1,50000,100000, 2 ,1,1,0 ,0 ,2,2,3,0,0,2,3,2,0,0,0,4,0,0,0,0,0,0,0,0
EXECUTE [dbo].[PG_CI_AUTORIZACION] 0, 0, 0, 1004, 'RECURSO-PLANTA / +100$EXTRA' , 'EXT' , 'QA // RECURSO-PLANTA / +100$EXTRA #1004',1 ,1,100000,0, 2 ,1,1,0 ,0 ,2,2,3,0,0,2,3,2,0,0,2,4,4,0,0,0,0,0,0,0
GO


-- ===============================================
SET NOCOUNT OFF
-- ===============================================


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
