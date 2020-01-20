-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_R700_50.c_SP_Flujo-Firma_X_K_Usuario
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			AUTORIZACION_FIRMA
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			AX DE LA ROSA // HECTOR A. GONZALEZ 
-- // Fecha creación:	06/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////

/*

DELETE FROM FLUJO_FIRMA

DELETE FROM AUTORIZACION_FIRMA
-- SELECT * FROM AUTORIZACION_FIRMA

-- SELECT * FROM FLUJO_FIRMA


-- EXECUTE [dbo].[PG_AU_TRASPASO_INIT]	0,0,0,	31804103	-- @PP_K_TRASPASO


*/



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_AU_TRASPASO_INIT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_AU_TRASPASO_INIT]
GO


CREATE PROCEDURE [dbo].[PG_AU_TRASPASO_INIT] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================		
	@PP_K_TRASPASO					INT
AS			
	-- ===========================================

	DECLARE @VP_K_UNIDAD_OPERATIVA		INT
	DECLARE @VP_MONTO_AUTORIZAR			DECIMAL(19,4)

	SELECT	@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA,
			@VP_MONTO_AUTORIZAR =		MONTO_AUTORIZADO
										FROM	TRASPASO
										WHERE	K_TRASPASO=@PP_K_TRASPASO

	-- ===========================================
	
	DECLARE @VP_K_AUTORIZACION		INT
	
	SELECT	@VP_K_AUTORIZACION =	(	SELECT	TOP (1)
												K_AUTORIZACION
										FROM	AUTORIZACION
								---		WHERE	K_AUTORIZACION IN ( 1001, 1002, 1003, 1004 )
										WHERE	K_TIPO_AUTORIZACION=1
										AND		LIMITE_INFERIOR<@VP_MONTO_AUTORIZAR
										ORDER BY LIMITE_INFERIOR DESC		)

	-- ===========================================

	EXECUTE [dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_AUTORIZACION,
														@VP_K_UNIDAD_OPERATIVA, @PP_K_TRASPASO, @VP_MONTO_AUTORIZAR	

	-- ===========================================

	
--	@PP_K_UNIDAD_OPERATIVA			INT,
--	@PP_K_TRANSACCION				INT,
--	@PP_MONTO_AUTORIZAR				DECIMAL(19,4)
	
	
GO





-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////