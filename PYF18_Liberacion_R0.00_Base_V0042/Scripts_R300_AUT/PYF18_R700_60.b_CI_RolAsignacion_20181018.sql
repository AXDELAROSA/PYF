-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_R700_40.a_CI_RolAsignacion
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			ROL_ASIGNACION
-- // OPERACION:		LIBERACION / TABLAS
-- //////////////////////////////////////////////////////////////
-- // Autor:			ALEX DE LA ROSA // HECTOR A. GONZALEZ 
-- // Fecha creación:	18/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////


DELETE
FROM	ROL_ASIGNACION
GO



-- ///////////////////////////////////////////////////////////////
-- //					CI - ROL_ASIGNACION					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ROL_ASIGNACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ROL_ASIGNACION]
GO


CREATE PROCEDURE [dbo].[PG_CI_ROL_ASIGNACION] 
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===============================
	@PP_K_ROL_ASIGNACION		INT,
	-- =============================== 
	@PP_K_ZONA_UO				INT,
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_ROL_AUTORIZACION		INT,
	@PP_K_USUARIO				INT
AS
	INSERT INTO ROL_ASIGNACION
			(	
			[K_ROL_ASIGNACION],
			-- =============================
			[K_ZONA_UO], [K_RAZON_SOCIAL], [K_UNIDAD_OPERATIVA],
			[K_ROL_AUTORIZACION], [K_USUARIO],				
			-- =====================
			[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]
			)
		VALUES
			(
			@PP_K_ROL_ASIGNACION,
			-- ===========================
			@PP_K_ZONA_UO, @PP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA,
			@PP_K_ROL_AUTORIZACION, @PP_K_USUARIO,
			-- ===========================
			@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL )

GO




-- //////////////////////////////////////////////////////////////
-- //
-- //////////////////////////////////////////////////////////////



-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 1, 0, 1 , 84 , 1 ,169
EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 2, 0, 2 , 74 , 1 ,169
EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 3, 0, 6 , 23 , 2 ,111
EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 4, 0, 16 , 13 , 0 ,122
EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 5, 0, 28 , 7 , 2 ,133

GO



EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 1010, 10, 0 , 0 , 1 ,307
EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 1020, 20, 0 , 0 , 1 ,305
EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 1030, 30, 0 , 0 , 1 ,301
EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 1040, 40, 0 , 0 , 1 ,302
EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 1050, 50, 0 , 0 , 1 ,306
EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 1060, 60, 0 , 0 , 1 ,303
EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 1070, 70, 0 , 0 , 1 ,304
EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 1101, 0, 0 , 0 , 2 ,402
EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 1102, 0, 0 , 0 , 3 ,177
EXECUTE [dbo].[PG_CI_ROL_ASIGNACION] 0, 0, 0, 1103, 0, 0 , 0 , 4 ,401
GO



-- ===============================================
SET NOCOUNT OFF
-- ===============================================


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
