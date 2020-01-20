-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////






-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DOCUMENTO_DOM4_RECALCULAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DOCUMENTO_DOM4_RECALCULAR]
GO


CREATE PROCEDURE [dbo].[PG_OP_DOCUMENTO_DOM4_RECALCULAR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS
	-- ==============================================
	
	DECLARE @VP_K_FORMATO_D0M4		INT

	SELECT @VP_K_FORMATO_D0M4 =		K_FORMATO_D0M4
									FROM	DOCUMENTO_D0M4
									WHERE 	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	-- ==========================

	EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_SET_PRECIO_COSTO_PERFIL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_DOCUMENTO_D0M4				
	-- ==========================================================	
	-- K_FORMATO_D0M4 = #101	C3M3 // COMPROMISO
	IF @VP_K_FORMATO_D0M4=101
		EXECUTE [dbo].[PG_OP_DATA_N1_101_COMPROMISO_RECALCULAR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_DOCUMENTO_D0M4
	-- ==========================================================	
	-- K_FORMATO_D0M4 = 102	PR3C // PRECIOS-COSTOS GAS
	IF @VP_K_FORMATO_D0M4=102
		EXECUTE [dbo].[PG_OP_DATA_N3_102_PRECIO_COSTO_RECALCULAR]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_DOCUMENTO_D0M4
	-- ==========================================================	
	-- K_FORMATO_D0M4 = #103	C3M3 // FLUJO PROYECTADO
	IF @VP_K_FORMATO_D0M4=103
		EXECUTE [dbo].[PG_OP_DATA_N1_103_FLUJO_PROYECTADO_RECALCULAR]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_DOCUMENTO_D0M4																			
	-- ==========================================================	


	-- //////////////////////////////////////////////////////////////
GO



-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
