-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:		PYF18_Finanzas
-- // MODULO:				RESUMEN FLUJO DIARIO / UNIDAD OPERATIVA
-- // OPERACION:			LIBERACION / REGLAS NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // Autor:				HGF
-- // Modificador:			DANIEL PORTILLO ROMERO (Por integración de RNs de Control)
-- // Fecha creación:		18/OCT/2018
-- // Fecha modificación:	07/DIC/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- ===========================================================================================
-- ===========================================================================================
-- == REGLAS DE NEGOCIO BASICAS (INSERT / UPDATE / DELETE)
-- ===========================================================================================
-- ===========================================================================================


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_PREEXISTENCIA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_PREEXISTENCIA]
GO


CREATE PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_PREEXISTENCIA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_F_OPERACION							DATE,
	@PP_K_UNIDAD_OPERATIVA					INT,
	-- =================================
	@OU_K_RESUMEN_FLUJO_DIARIO_X_UNO		INT		OUTPUT
AS			
	  
	DECLARE @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO		INT		

	SELECT	@VP_K_RESUMEN_FLUJO_DIARIO_X_UNO =		MAX(K_RESUMEN_FLUJO_DIARIO_X_UNO)
													FROM	RESUMEN_FLUJO_DIARIO_X_UNO
													WHERE	F_OPERACION=@PP_F_OPERACION
													AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
	-- ==================================
	
	IF @PP_L_DEBUG>0
		BEGIN
	
		PRINT @PP_F_OPERACION
		PRINT @PP_K_UNIDAD_OPERATIVA

		IF @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO IS NULL
			PRINT 'NO EXISTE <RESUMEN_FLUJO_DIARIO_X_UNO>'
		ELSE			
			PRINT 'SI EXISTE <RESUMEN_FLUJO_DIARIO_X_UNO>'
		
		PRINT @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO
		
		END

	-- ==================================

	IF @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO IS NULL
		EXECUTE [PG_IN_RESUMEN_FLUJO_DIARIO_X_UNO_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_OPERACION, @PP_K_UNIDAD_OPERATIVA,
															@OU_K_RESUMEN_FLUJO_DIARIO_X_UNO = @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO		OUTPUT 
	-- ==================================

	SET @OU_K_RESUMEN_FLUJO_DIARIO_X_UNO = @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO
		
	-- //////////////////////////////////////////////////////////////
GO




-- /////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_RESUMEN_FLUJO_DIARIO X UNO - INGRESOS INSERT
-- /////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_INSERT]
GO

CREATE PROCEDURE [dbo].[PG_RN_RESUMEN_FLUJO_DIARIO_X_UNO_INSERT]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_USUARIO_ACCION		[INT],
	-- ===========================		
	@PP_K_UNIDAD_OPERATIVA		[INT], 
	@PP_F_OPERACION				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		BEGIN

		DECLARE @VP_K_YYYY		INT
		DECLARE @VP_K_MM		INT

		SET @VP_K_YYYY =		YEAR(@PP_F_OPERACION)
		SET @VP_K_MM =			MONTH(@PP_F_OPERACION)

		-- ===============================

		DECLARE @VP_K_RAZON_SOCIAL			INT = -1

		SELECT	@VP_K_RAZON_SOCIAL =	UNIDAD_OPERATIVA.K_RAZON_SOCIAL
										FROM	UNIDAD_OPERATIVA
										WHERE	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA

		EXECUTE [dbo].[PG_RN_CONTROL_L_06_PFD_INGRESOS_ADD]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO	OUTPUT

		END
	-- //////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //INS//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
