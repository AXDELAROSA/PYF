-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			FLUJO DIARIO
-- // OPERACIÓN:		LIBERACIÓN / REGLAS DE NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // Autor:			DANIEL PORTILLO ROMERO
-- // Fecha creación:	07/DIC/2018  (Por integración de RNs de Control)
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////





-- /////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_MOVIMIENTO_FLUJO_DIARIO X K TRASPASO
-- /////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_FLUJO_DIARIO_X_K_TRASPASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_FLUJO_DIARIO_X_K_TRASPASO]
GO

CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_FLUJO_DIARIO_X_K_TRASPASO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================			
	@PP_K_TRASPASO					INT,	 
	@PP_K_UNIDAD_OPERATIVA			INT, 
	@PP_F_MOVIMIENTO_FLUJO_DIARIO	DATE,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(300)		OUTPUT
AS
	
	DECLARE @VP_MENSAJE AS VARCHAR(300) = ''

	 -- ////////////////////////////////////////////////////

	DECLARE @VP_K_YYYY		INT
	DECLARE @VP_K_MM		INT

	SET @VP_K_YYYY =	YEAR(@PP_F_MOVIMIENTO_FLUJO_DIARIO)
	SET @VP_K_MM =		MONTH(@PP_F_MOVIMIENTO_FLUJO_DIARIO)

	-- ===============================

	DECLARE @VP_K_RAZON_SOCIAL			INT = -1

	SELECT	@VP_K_RAZON_SOCIAL =		UNIDAD_OPERATIVA.K_RAZON_SOCIAL
								FROM	UNIDAD_OPERATIVA
								WHERE	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA

	-- ////////////////////////////////////////////////////

	IF @VP_MENSAJE = ''
		EXECUTE [dbo].[PG_RN_CONTROL_L_07_PFD_TRASPASO_ADD]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																@PP_K_TRASPASO,
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE	OUTPUT

	-- ////////////////////////////////////////////////////

	IF @VP_MENSAJE = ''
		EXECUTE [dbo].[PG_RN_CONTROL_L_05_PFD_POLIZA_EDIT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- ////////////////////////////////////////////////////

	SET @OU_RESULTADO_VALIDACION = @VP_MENSAJE

	-- ////////////////////////////////////////////////////
GO	




-- /////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_MOVIMIENTO_FLUJO_DIARIO X K FACTURA CXP
-- /////////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_FLUJO_DIARIO_X_K_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_FLUJO_DIARIO_X_K_FACTURA_CXP]
GO

CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_FLUJO_DIARIO_X_K_FACTURA_CXP]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================	 
	@PP_K_UNIDAD_OPERATIVA			INT, 
	@PP_F_MOVIMIENTO_FLUJO_DIARIO	DATE,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(300)		OUTPUT
AS
	
	DECLARE @VP_MENSAJE AS VARCHAR(300) = ''

	 -- ////////////////////////////////////////////////////

	DECLARE @VP_K_YYYY		INT
	DECLARE @VP_K_MM		INT

	SET @VP_K_YYYY =	YEAR(@PP_F_MOVIMIENTO_FLUJO_DIARIO)
	SET @VP_K_MM =		MONTH(@PP_F_MOVIMIENTO_FLUJO_DIARIO)

	-- ===============================

	DECLARE @VP_K_RAZON_SOCIAL			INT = -1

	SELECT	@VP_K_RAZON_SOCIAL =		UNIDAD_OPERATIVA.K_RAZON_SOCIAL
								FROM	UNIDAD_OPERATIVA
								WHERE	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA

	-- ////////////////////////////////////////////////////

	IF @VP_MENSAJE = ''
		EXECUTE [dbo].[PG_RN_CONTROL_L_08_PFD_FACTURA_ADD]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE	OUTPUT

	-- ////////////////////////////////////////////////////

	SET @OU_RESULTADO_VALIDACION = @VP_MENSAJE

	-- ////////////////////////////////////////////////////
GO	




-- /////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_MOVIMIENTO_FLUJO_DIARIO INGRESOS
-- /////////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS]
GO


CREATE PROCEDURE [dbo].[PG_RN_MOVIMIENTO_FLUJO_DIARIO_INGRESOS]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================	
	@PP_K_UNIDAD_OPERATIVA			INT, 
	@PP_F_MOVIMIENTO_FLUJO_DIARIO	DATE,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(300)		OUTPUT
AS
	
	DECLARE @VP_MENSAJE AS VARCHAR(300) = ''

	 -- ////////////////////////////////////////////////////

	DECLARE @VP_K_YYYY		INT
	DECLARE @VP_K_MM		INT

	SET @VP_K_YYYY =	YEAR(@PP_F_MOVIMIENTO_FLUJO_DIARIO)
	SET @VP_K_MM =		MONTH(@PP_F_MOVIMIENTO_FLUJO_DIARIO)

	-- ===============================

	DECLARE @VP_K_RAZON_SOCIAL			INT = -1

	SELECT	@VP_K_RAZON_SOCIAL =		UNIDAD_OPERATIVA.K_RAZON_SOCIAL
								FROM	UNIDAD_OPERATIVA
								WHERE	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA

	-- ===============================

	IF @VP_MENSAJE = ''
		EXECUTE [dbo].[PG_RN_CONTROL_L_06_PFD_INGRESOS_ADD]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE	OUTPUT

	-- ////////////////////////////////////////////////////

	IF @VP_MENSAJE = ''
		EXECUTE [dbo].[PG_RN_CONTROL_L_05_PFD_POLIZA_EDIT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- ////////////////////////////////////////////////////

	SET @OU_RESULTADO_VALIDACION = @VP_MENSAJE

	-- ////////////////////////////////////////////////////
GO	


	