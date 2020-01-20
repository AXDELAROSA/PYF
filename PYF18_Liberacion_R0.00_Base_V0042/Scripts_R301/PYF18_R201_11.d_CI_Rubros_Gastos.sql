-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			RUBRO GASTO
-- // OPERACION:		LIBERACION / TABLAS
-- // AUTOR:			LBG
-- // FECHA:            20180911
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RUBRO_GASTO]') AND type in (N'U'))
	DELETE	FROM [dbo].[RUBRO_GASTO]
GO





-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_RUBRO_GASTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_RUBRO_GASTO]
GO


CREATE PROCEDURE [dbo].[PG_CI_RUBRO_GASTO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	@PP_K_RUBRO_GASTO		INT,
	@PP_D_RUBRO_GASTO		VARCHAR(100),
	@PP_S_RUBRO_GASTO		VARCHAR(10),
	@PP_O_RUBRO_GASTO		INT,
	@PP_C_RUBRO_GASTO		VARCHAR(255),
	@PP_L_RUBRO_GASTO		INT
AS
	
	INSERT INTO RUBRO_GASTO
		(	K_RUBRO_GASTO,			D_RUBRO_GASTO, 
			S_RUBRO_GASTO,			O_RUBRO_GASTO,
			C_RUBRO_GASTO,
			L_RUBRO_GASTO,
			K_USUARIO_ALTA,			F_ALTA,
			K_USUARIO_CAMBIO,		F_CAMBIO,
			L_BORRADO					)		
	VALUES	
		(	@PP_K_RUBRO_GASTO,		@PP_D_RUBRO_GASTO,	
			@PP_S_RUBRO_GASTO,		@PP_O_RUBRO_GASTO,
			@PP_C_RUBRO_GASTO,
			@PP_L_RUBRO_GASTO,
			@PP_K_USUARIO_ACCION,	GETDATE(),
			@PP_K_USUARIO_ACCION,	GETDATE(),
			0		)

	-- =========================================================
GO





-- ===============================================

SET NOCOUNT ON

-- ===============================================



EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 1, 'PETROGAS / INGRESOS / TRASPASOS', 'PTR', 10, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 2, 'PRESUPUESTO', 'PRE', 20, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 3, 'IMPUESTOS', 'IMP', 30, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 4, 'EXTRAORDINARIOS DISCRECIONALES', 'EXTD', 40, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 5, 'INVERSION EQUIPO TRANSPORTE', 'INVET', 50, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 6, 'APORTACION FOINVER GAS / UTILIDAD', 'FOIN', 60, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 7, 'CORPORATIVO OTROS GASTOS', 'COGA', 70, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 8, 'CORPORATIVO ASPTA', 'COAS', 80, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 9, 'EXTRAORDINARIOS NO DISCRECIONALES', 'EXTN', 90, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 10, 'COOPERACIONES OTORGADAS', 'COOP', 100, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 11, 'GASTOS FINANCIEROS', 'GAFI', 110, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 12, 'FLETES', 'FLT', 120, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 13, 'APORTACION CENTAVOS 0.38 Y 0.27 Y 0.16 Y SMRU', 'SMRU', 130, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 14, 'INZA PAGO DE CILINDROS', 'INZA', 140, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 15, 'INTERESES PEMEX', 'PEMEX', 150, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 16, 'INVERSION PLANTA', 'INVPL', 160, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 17, 'PRESTAMOS FONDO EMERGENTE', 'PREFE', 170, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 18, 'BANCARIOS', 'BANC', 180, 'S/C', 1
EXECUTE [dbo].[PG_CI_RUBRO_GASTO] 0, 0, 0, 19, 'PRESTAMOS INTERCOMPANIAS', 'PRINT', 190, 'S/C', 1


GO



-- ===============================================

SET NOCOUNT OFF



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
