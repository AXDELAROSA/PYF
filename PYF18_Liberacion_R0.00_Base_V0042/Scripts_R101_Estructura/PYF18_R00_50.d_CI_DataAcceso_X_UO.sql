-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			GRUPO_RELACION
-- // OPERACION:		LIBERACION / TABLA+CARGA 
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATA_ACCESO_UO]') AND type in (N'U'))
	DELETE	FROM [dbo].[DATA_ACCESO_UO]
GO


-- //////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_DATA_ACCESO_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_DATA_ACCESO_UO]
GO


CREATE PROCEDURE [dbo].[PG_CI_DATA_ACCESO_UO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- =============================
	@PP_K_USUARIO				INT,
	@PP_K_UNIDAD_OPERATIVA		INT	
AS

	INSERT INTO DATA_ACCESO_UO
		(	K_USUARIO,
			K_UNIDAD_OPERATIVA			)	
	VALUES	
		(	@PP_K_USUARIO,
			@PP_K_UNIDAD_OPERATIVA		)			

	-- ==============================================
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////



-- ===============================================
SET NOCOUNT ON
-- ===============================================



EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 0
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 1
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 2
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 3
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 4
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 5
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 6
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 7
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 8
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 9
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 10
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 11
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 12
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 13
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 14
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 15
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 16
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 17
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 18
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 19
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 20
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 41
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 42
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 43
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 44
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 45
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 46
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 47
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 48
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 49
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 50
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 51
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 52
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 53
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 54
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 55
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 61
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 62
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 63
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 64
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 65
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 66
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 67
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 68
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 69
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 70
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 76
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 77
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 78
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 79
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 80
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 81
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 82
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 83
EXECUTE [dbo].[PG_CI_DATA_ACCESO_UO] 0, 0, 0, 169, 75

GO


-- ===============================================
SET NOCOUNT OFF
-- ===============================================




