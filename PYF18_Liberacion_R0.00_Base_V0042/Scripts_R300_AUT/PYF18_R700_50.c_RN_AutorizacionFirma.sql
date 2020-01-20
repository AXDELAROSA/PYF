-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			AUTORIZACIONES
-- // OPERACION:		LIBERACION / REGLAS NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // Autor:			ALEX DE LA ROSA // HECTOR A. GONZALEZ 
-- // Fecha creación:	15/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FIRMANTE_X_UNO_X_ROL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FIRMANTE_X_UNO_X_ROL]
GO


CREATE PROCEDURE [dbo].[PG_RN_FIRMANTE_X_UNO_X_ROL] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================		
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_ROL_AUTORIZACION			INT,
	@OU_K_USUARIO					INT		OUTPUT
AS	
	
	DECLARE @VP_K_USUARIO INT

	-- =======================================

	DECLARE @VP_K_RAZON_SOCIAL		INT = -1
	DECLARE @VP_K_ZONA_UO			INT = -1
	
	IF @PP_K_ROL_AUTORIZACION<>0
		BEGIN

		SELECT	@VP_K_RAZON_SOCIAL =	K_RAZON_SOCIAL,
				@VP_K_ZONA_UO =			K_ZONA_UO
										FROM	UNIDAD_OPERATIVA
										WHERE	K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
		-- ===========================
		
		IF @VP_K_USUARIO IS NULL
			SELECT	@VP_K_USUARIO =		K_USUARIO		
										FROM	ROL_ASIGNACION
										WHERE	K_ROL_AUTORIZACION=@PP_K_ROL_AUTORIZACION
										AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
		-- ===========================

		IF @VP_K_USUARIO IS NULL
			SELECT	@VP_K_USUARIO =		K_USUARIO		
										FROM	ROL_ASIGNACION
										WHERE	K_ROL_AUTORIZACION=@PP_K_ROL_AUTORIZACION
										AND		K_ZONA_UO=@VP_K_ZONA_UO
		-- ===========================	

		IF @VP_K_USUARIO IS NULL
			SELECT	@VP_K_USUARIO =		K_USUARIO		
										FROM	ROL_ASIGNACION
										WHERE	K_ROL_AUTORIZACION=@PP_K_ROL_AUTORIZACION
										AND		K_RAZON_SOCIAL=@VP_K_RAZON_SOCIAL
		-- ===========================

		IF @VP_K_USUARIO IS NULL
			SELECT	@VP_K_USUARIO =		MIN(K_USUARIO)
										FROM	ROL_ASIGNACION
										WHERE	K_ROL_AUTORIZACION=@PP_K_ROL_AUTORIZACION
										AND		K_ZONA_UO=0
										AND		K_RAZON_SOCIAL=0
										AND		K_UNIDAD_OPERATIVA=0
		END

	-- ===========================

	IF @VP_K_USUARIO IS NULL
		SET	@VP_K_USUARIO =	0
		
	-- ===========================

	IF @PP_L_DEBUG>0
		BEGIN

		PRINT '>>>>>>>> [PG_RN_FIRMANTE_X_UNO_X_ROL]'
		
		PRINT '@PP_K_ROL_AUTORIZACION = '+CONVERT(VARCHAR(100),@PP_K_ROL_AUTORIZACION)
		PRINT '@PP_K_UNIDAD_OPERATIVA = '+CONVERT(VARCHAR(100),@PP_K_UNIDAD_OPERATIVA)
		PRINT '@VP_K_RAZON_SOCIAL     = '+CONVERT(VARCHAR(100),@VP_K_RAZON_SOCIAL)	
		PRINT '@VP_K_ZONA_UO          = '+CONVERT(VARCHAR(100),@VP_K_ZONA_UO)		
		PRINT '@VP_K_USUARIO ========== '+CONVERT(VARCHAR(100),@VP_K_USUARIO)
		
		END

	-- ===========================

	SET @OU_K_USUARIO = @VP_K_USUARIO

	-- =======================================
GO





-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
