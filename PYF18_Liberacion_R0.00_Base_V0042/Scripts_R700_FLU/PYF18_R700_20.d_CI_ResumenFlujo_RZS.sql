-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			RESUMEN FLUJO DIARIO / RAZON SOCIAL
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- //////////////////////////////////////////////////////////////
-- // Autor:			HGF
-- // Fecha creación:	18/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////
-- SELECT * FROM RESUMEN_FLUJO_DIARIO_X_RZS ORDER BY F_OPERACION, K_RAZON_SOCIAL

-- EXECUTE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_RZS_GENERADOR_FULL] 0,0,0 


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_RZS_GENERADOR_FULL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_RZS_GENERADOR_FULL]
GO



CREATE PROCEDURE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_RZS_GENERADOR_FULL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT
AS			

	DELETE
	FROM	RESUMEN_FLUJO_DIARIO_X_RZS

	-- =======================================
	
	INSERT INTO [RESUMEN_FLUJO_DIARIO_X_RZS]
		(	
				[K_ESTATUS_RESUMEN_FLUJO_DIARIO], [C_RESUMEN_FLUJO_DIARIO_X_RZS],
				[SALDO_INICIAL], [SALDO_FINAL],
				-- =============================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA],
				-- =============================
				[F_OPERACION], [K_RAZON_SOCIAL],
				[K_RESUMEN_FLUJO_DIARIO_X_RZS],
				-- =============================
				[INGRESO_BANCO], [INGRESO_LIBRO], [INGRESO_CONCILIADO],
				[GAS], [FLETE], [OBLIGACIONES],
				[NOMINA], [CXP], [TRASPASOS],
				[GASTO_CORPORATIVO]					)
		SELECT	1, '', 
				0, 0,
				-- =============================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL,
				-- =============================
				[F_OPERACION], K_RAZON_SOCIAL, 
				MIN([K_RESUMEN_FLUJO_DIARIO_X_UNO]),
				-- =============================
				SUM([INGRESO_BANCO]), SUM([INGRESO_LIBRO]), SUM([INGRESO_CONCILIADO]), 
				SUM([GAS]), SUM([FLETE]), 
				SUM([OBLIGACIONES]), 
				SUM([NOMINA]), SUM([CXP]), SUM([TRASPASOS]), 
				SUM([GASTO_CORPORATIVO])
		FROM	[RESUMEN_FLUJO_DIARIO_X_UNO] AS FLU, UNIDAD_OPERATIVA
		WHERE	FLU.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
		GROUP BY 	[F_OPERACION], K_RAZON_SOCIAL

	-- =======================================



	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

EXECUTE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_RZS_GENERADOR_FULL] 0,0,0 



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
