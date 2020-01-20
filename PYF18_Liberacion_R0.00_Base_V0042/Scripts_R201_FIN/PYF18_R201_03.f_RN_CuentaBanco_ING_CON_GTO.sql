-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CUENTA_BANCO
-- // OPERACION:		LIBERACION / REGLAS NEGOCIO
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- /////////////////////////////////////////////////////////////






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CUENTA_INGRESO_X_K_UNIDAD_OPERATIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CUENTA_INGRESO_X_K_UNIDAD_OPERATIVA]
GO	


CREATE PROCEDURE [dbo].[PG_RN_CUENTA_INGRESO_X_K_UNIDAD_OPERATIVA]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_UNIDAD_OPERATIVA		INT,
	@OU_K_CUENTA_BANCO			INT			OUTPUT
AS

	DECLARE @VP_K_CUENTA_BANCO			INT			

	SELECT	@VP_K_CUENTA_BANCO =		MIN([K_CUENTA_BANCO])
										FROM	CUENTA_BANCO_UO
										WHERE	CUENTA_BANCO_UO.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
										AND		CUENTA_BANCO_UO.K_TIPO_CUENTA_BANCO=1	-- K_TIPO_CUENTA_BANCO == 1 INGRESO // 2 CONCENTRADORA // 3 EGRESO
										AND		CUENTA_BANCO_UO.L_PRINCIPAL=1
	-- ===============================
										
	IF @VP_K_CUENTA_BANCO IS NULL
		SET @VP_K_CUENTA_BANCO = 0

	-- ============================================
	
	IF @PP_L_DEBUG>0
		BEGIN
		PRINT	'============================ [PG_RN_CUENTA_INGRESO_X_K_UNIDAD_OPERATIVA]'
		PRINT	'@PP_K_UNIDAD_OPERATIVA = '+CONVERT(VARCHAR(100),@PP_K_UNIDAD_OPERATIVA)
		PRINT	'@VP_K_CUENTA_BANCO     = '+CONVERT(VARCHAR(100),@VP_K_CUENTA_BANCO)
		END

	-- ============================================

	SET @OU_K_CUENTA_BANCO = @VP_K_CUENTA_BANCO 

	-- ============================================
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CUENTA_CONCENTRADORA_X_K_UNIDAD_OPERATIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CUENTA_CONCENTRADORA_X_K_UNIDAD_OPERATIVA]
GO	


CREATE PROCEDURE [dbo].[PG_RN_CUENTA_CONCENTRADORA_X_K_UNIDAD_OPERATIVA]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_UNIDAD_OPERATIVA		INT,
	@OU_K_CUENTA_BANCO			INT			OUTPUT
AS

	DECLARE @VP_K_CUENTA_BANCO			INT			

	SELECT	@VP_K_CUENTA_BANCO =		MIN([K_CUENTA_BANCO])
										FROM	CUENTA_BANCO_UO
										WHERE	CUENTA_BANCO_UO.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
										AND		CUENTA_BANCO_UO.K_TIPO_CUENTA_BANCO=2	-- K_TIPO_CUENTA_BANCO == 1 INGRESO // 2 CONCENTRADORA // 3 EGRESO
										AND		CUENTA_BANCO_UO.L_PRINCIPAL=1
	-- ===============================
										
	IF @VP_K_CUENTA_BANCO IS NULL
		SET @VP_K_CUENTA_BANCO = 0

	-- ============================================
	
	IF @PP_L_DEBUG>0
		BEGIN
		PRINT	'============================ [PG_RN_CUENTA_CONCENTRADORA_X_K_UNIDAD_OPERATIVA]'
		PRINT	'@PP_K_UNIDAD_OPERATIVA = '+CONVERT(VARCHAR(100),@PP_K_UNIDAD_OPERATIVA)
		PRINT	'@VP_K_CUENTA_BANCO     = '+CONVERT(VARCHAR(100),@VP_K_CUENTA_BANCO)
		END

	-- ============================================

	SET @OU_K_CUENTA_BANCO = @VP_K_CUENTA_BANCO 

	-- ============================================
GO



-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////

