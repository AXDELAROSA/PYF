-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			TRASPASO
-- // OPERACION:		CARGA INICIAL / QA
-- //////////////////////////////////////////////////////////////
-- // Autor:			DANIEL PORTILLO	ROMERO
-- // Fecha creación:	18/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO


-- //////////////////////////////////////////////////////////////
-- SELECT * FROM TRASPASO


DELETE FROM TRASPASO


-- //////////////////////////////////////////////////////
-- // SP // CARGA INICIAL
-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TRASPASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TRASPASO]
GO


CREATE PROCEDURE [dbo].[PG_CI_TRASPASO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_TRASPASO				INT,
	@PP_D_TRASPASO				[VARCHAR] (255),
	@PP_K_TIPO_TRASPASO			INT,	
	@PP_K_ESTATUS_TRASPASO		INT,
	@PP_K_CONCEPTO_TRASPASO		INT,
	@PP_K_RUBRO_PRESUPUESTO		INT,	
	@PP_L_CAPTURA_MANUAL		INT,
	@PP_F_OPERACION				DATE,
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_C_TRASPASO				[VARCHAR] (255),
	@PP_MONTO_AUTORIZADO		DECIMAL(19,4),
	@PP_MONTO_APLICAR			DECIMAL(19,4)
AS			
	-- ==============================================
	
	DECLARE @VP_K_NIVEL_RUBRO_PRESUPUESTO		INT

	SELECT	@VP_K_NIVEL_RUBRO_PRESUPUESTO =		K_NIVEL_RUBRO_PRESUPUESTO		
												FROM	RUBRO_PRESUPUESTO
												WHERE	K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO

	-- ==============================================
	
	IF @PP_MONTO_AUTORIZADO>0 AND @VP_K_NIVEL_RUBRO_PRESUPUESTO=5
		BEGIN

		INSERT INTO TRASPASO
			(	[K_TRASPASO],	
				[D_TRASPASO],			
				[K_TIPO_TRASPASO], [K_ESTATUS_TRASPASO],	
				[K_CONCEPTO_TRASPASO], [K_RUBRO_PRESUPUESTO],
				[L_CAPTURA_MANUAL],
				-- =====================
				[F_OPERACION], [K_UNIDAD_OPERATIVA],	
				[C_TRASPASO],			
				[MONTO_AUTORIZADO], [MONTO_APLICAR],			
				-- ============================================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@PP_K_TRASPASO,	
				@PP_D_TRASPASO,			
				@PP_K_TIPO_TRASPASO, @PP_K_ESTATUS_TRASPASO,	
				@PP_K_CONCEPTO_TRASPASO, @PP_K_RUBRO_PRESUPUESTO,
				@PP_L_CAPTURA_MANUAL,
				-- =====================
				@PP_F_OPERACION, @PP_K_UNIDAD_OPERATIVA,	
				@PP_C_TRASPASO,			
				CONVERT(DECIMAL(19,2),@PP_MONTO_AUTORIZADO), CONVERT(DECIMAL(19,2),@PP_MONTO_APLICAR),			
				-- ============================================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )

		-- ==============================================
	
		UPDATE	TRASPASO
		SET		D_TRASPASO =	(
									SELECT	D_RUBRO_PRESUPUESTO
									FROM	RUBRO_PRESUPUESTO
									WHERE	K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
								)
		WHERE	K_TRASPASO=@PP_K_TRASPASO

		END

	-- ==============================================
GO


-- //////////////////////////////////////////////////////
-- // SP // CARGA INICIAL
-- //////////////////////////////////////////////////////

SET NOCOUNT ON

-- ===============================================


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TRASPASO]') AND type in (N'U'))
	DELETE	FROM [dbo].[TRASPASO] 
GO



-- [dbo].[PG_CI_TRASPASO] 0,0,0, @PP_K_TRASPASO, '', 100, 1, 2, @PP_K_TIPO_PRESUPUESTO, 1, @PP_F_OPERACION, @PP_K_UNIDAD_OPERATIVA, '', @PP_MONTO_AUTORIZADO, @PP_MONTO_APLICAR			


-- ====================== W1 //// [dbo].[PG_CI_TRASPASO] 
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804000, '', 1, 1, 2, 20, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804001, '', 1, 1, 2, 30, 1, '2018-04-02', 3, '', 7213, 7213
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804003, '', 1, 1, 2, 50, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804004, '', 1, 1, 2, 60, 1, '2018-04-02', 3, '', 13225.5, 13225.5
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804008, '', 1, 1, 2, 100, 1, '2018-04-02', 3, '', 12737, 12737
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804009, '', 1, 1, 2, 110, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804010, '', 1, 1, 2, 120, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804014, '', 1, 1, 2, 160, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804015, '', 1, 1, 2, 170, 1, '2018-04-02', 3, '', 864, 864
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804016, '', 1, 1, 2, 180, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804017, '', 1, 1, 2, 190, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804018, '', 1, 1, 2, 200, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804020, '', 1, 1, 2, 220, 1, '2018-04-02', 3, '', 8094, 8094
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804021, '', 1, 1, 2, 230, 1, '2018-04-02', 3, '', 5818, 5818
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804022, '', 1, 1, 2, 240, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804023, '', 1, 1, 2, 250, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804024, '', 1, 1, 2, 260, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804025, '', 1, 1, 2, 270, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804027, '', 1, 1, 2, 290, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804028, '', 1, 1, 2, 300, 1, '2018-04-02', 3, '', 1875, 1875
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804029, '', 1, 1, 2, 310, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804030, '', 1, 1, 2, 320, 1, '2018-04-02', 3, '', 5666.5, 5666.5
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804031, '', 1, 1, 2, 330, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804032, '', 1, 1, 2, 340, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804036, '', 1, 1, 2, 380, 1, '2018-04-02', 3, '', 3500, 3500
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804037, '', 1, 1, 2, 390, 1, '2018-04-02', 3, '', 1375, 1375
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804038, '', 1, 1, 2, 400, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804040, '', 1, 1, 2, 420, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804041, '', 1, 1, 2, 430, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804042, '', 1, 1, 2, 440, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804043, '', 1, 1, 2, 450, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804044, '', 1, 1, 2, 460, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804045, '', 1, 1, 2, 470, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804046, '', 1, 1, 2, 480, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804048, '', 1, 1, 2, 500, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804049, '', 1, 1, 2, 510, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804050, '', 1, 1, 2, 520, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804051, '', 1, 1, 2, 530, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804053, '', 1, 1, 2, 550, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804056, '', 1, 1, 2, 580, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804057, '', 1, 1, 2, 590, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804058, '', 1, 1, 2, 600, 1, '2018-04-02', 3, '', 363, 363
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804059, '', 1, 1, 2, 610, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804060, '', 1, 1, 2, 620, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804061, '', 1, 1, 2, 630, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804063, '', 1, 1, 2, 650, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804064, '', 1, 1, 2, 660, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804065, '', 1, 1, 2, 670, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804066, '', 1, 1, 2, 680, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804067, '', 1, 1, 2, 690, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804068, '', 1, 1, 2, 700, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804070, '', 1, 1, 2, 720, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804071, '', 1, 1, 2, 730, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804072, '', 1, 1, 2, 740, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804073, '', 1, 1, 2, 750, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804074, '', 1, 1, 2, 760, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804075, '', 1, 1, 2, 770, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804076, '', 1, 1, 2, 780, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804077, '', 1, 1, 2, 790, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804078, '', 1, 1, 2, 800, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804080, '', 1, 1, 2, 820, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804081, '', 1, 1, 2, 830, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804082, '', 1, 1, 2, 840, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804083, '', 1, 1, 2, 850, 1, '2018-04-02', 3, '', 169.5, 169.5
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804085, '', 1, 1, 2, 870, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804086, '', 1, 1, 2, 880, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804087, '', 1, 1, 2, 890, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804088, '', 1, 1, 2, 900, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804089, '', 1, 1, 2, 910, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804090, '', 1, 1, 2, 920, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804092, '', 1, 1, 2, 940, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804097, '', 1, 1, 2, 990, 1, '2018-04-02', 3, '', 6575, 6575
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804098, '', 1, 1, 2, 1000, 1, '2018-04-02', 3, '', 3303.5, 3303.5
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804099, '', 1, 1, 2, 1010, 1, '2018-04-02', 3, '', 2125, 2125
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804100, '', 1, 1, 2, 1020, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804102, '', 1, 1, 2, 1040, 1, '2018-04-02', 3, '', 1375, 1375
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804103, '', 1, 1, 2, 1050, 1, '2018-04-02', 3, '', 0, 0
EXECUTE [dbo].[PG_CI_TRASPASO]  0,0,0, 31804105, '', 1, 1, 2, 1070, 1, '2018-04-02', 3, '', 0, 0


GO

-- ===============================================

SET NOCOUNT OFF



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
