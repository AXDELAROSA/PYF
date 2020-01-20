-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:		PYF18_Finanzas
-- // MODULO:				RESUMEN FLUJO DIARIO / UNIDAD OPERATIVA
-- // OPERACION:			LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:				HGF
-- // Fecha creación:		17/DIC/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_RESUMEN_FLUJO_DIARIO_X_UNO_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_RESUMEN_FLUJO_DIARIO_X_UNO_SQL]
GO


CREATE PROCEDURE [dbo].[PG_IN_RESUMEN_FLUJO_DIARIO_X_UNO_SQL]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_F_OPERACION							DATE,
	@PP_K_UNIDAD_OPERATIVA					INT,
	-- =================================
	@OU_K_RESUMEN_FLUJO_DIARIO_X_UNO		INT		OUTPUT
AS			
	  
	DECLARE @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO	INT = 0
	
	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'RESUMEN_FLUJO_DIARIO_X_UNO', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO			OUTPUT	
	-- ==================================
	
	DECLARE @VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO		INT = 1
	DECLARE @VP_C_RESUMEN_FLUJO_DIARIO_X_UNO		VARCHAR(500) = ''

	-- ==================================

	INSERT INTO RESUMEN_FLUJO_DIARIO_X_UNO
		(	[K_RESUMEN_FLUJO_DIARIO_X_UNO],
			[F_OPERACION],
			[K_UNIDAD_OPERATIVA], [K_ESTATUS_RESUMEN_FLUJO_DIARIO],
			[C_RESUMEN_FLUJO_DIARIO_X_UNO],
			-- ============================================
			[K_USUARIO_ALTA], [F_ALTA], 
			[K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
	VALUES	
		(	@VP_K_RESUMEN_FLUJO_DIARIO_X_UNO,
			@PP_F_OPERACION,
			@PP_K_UNIDAD_OPERATIVA, @VP_K_ESTATUS_RESUMEN_FLUJO_DIARIO,	
			@VP_C_RESUMEN_FLUJO_DIARIO_X_UNO,
			-- ============================================
			@PP_K_USUARIO_ACCION, GETDATE(), 
			@PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL )

	-- ==================================

	SET @OU_K_RESUMEN_FLUJO_DIARIO_X_UNO = @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO
		
	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
