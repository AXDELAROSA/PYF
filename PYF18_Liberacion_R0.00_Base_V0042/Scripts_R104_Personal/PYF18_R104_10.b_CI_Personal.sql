-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PERSONAL
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- //////////////////////////////////////////////////////////////
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	29/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////







-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PERSONAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PERSONAL]
GO


CREATE PROCEDURE [dbo].[PG_CI_PERSONAL]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ========================================
	@PP_K_PERSONAL		INT,
	@PP_D_PERSONAL		VARCHAR(100),
	@PP_S_PERSONAL		VARCHAR(10),
	@PP_O_PERSONAL		INT,
	@PP_C_PERSONAL		VARCHAR(500)
AS
	
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_PERSONAL
							FROM	[PERSONAL]
							WHERE	K_PERSONAL=@PP_K_PERSONAL

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO [PERSONAL]	
			(	K_PERSONAL,				D_PERSONAL, 
				S_PERSONAL,				O_PERSONAL,
				C_PERSONAL,			
				-- ============================================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )			
		VALUES	
			(	@PP_K_PERSONAL,			@PP_D_PERSONAL,	
				@PP_S_PERSONAL,			@PP_O_PERSONAL,
				@PP_C_PERSONAL,				
				-- ============================================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )		
	ELSE
		UPDATE	PERSONAL
		SET		D_PERSONAL	= @PP_D_PERSONAL,	
				S_PERSONAL	= @PP_S_PERSONAL,			
				O_PERSONAL	= @PP_O_PERSONAL,
				C_PERSONAL	= @PP_C_PERSONAL,	
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	K_PERSONAL=@PP_K_PERSONAL

	-- =========================================================
GO

-- //////////////////////////////////////////////////////////////


-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_PERSONAL] 0,0,0, 10300, 'TESO/QA > ALL',		'TQA#ALL', 100, 'TESORERIA'
EXECUTE [dbo].[PG_CI_PERSONAL] 0,0,0, 10301, 'TESO/QA > CHI',		'TQA#CHI', 100, 'TESORERIA'
EXECUTE [dbo].[PG_CI_PERSONAL] 0,0,0, 10302, 'TESO/QA > JAL',		'TQA#JAL', 100, 'TESORERIA'
EXECUTE [dbo].[PG_CI_PERSONAL] 0,0,0, 10303, 'TESO/QA > SUR',		'TQA#SUR', 100, 'TESORERIA'
EXECUTE [dbo].[PG_CI_PERSONAL] 0,0,0, 10304, 'TESO/QA > MEX',		'TQA#MEX', 100, 'TESORERIA'
EXECUTE [dbo].[PG_CI_PERSONAL] 0,0,0, 10305, 'TESO/QA > CEN',		'TQA#CEN', 100, 'TESORERIA'
EXECUTE [dbo].[PG_CI_PERSONAL] 0,0,0, 10306, 'TESO/QA > SON',		'TQA#SON', 100, 'TESORERIA'
EXECUTE [dbo].[PG_CI_PERSONAL] 0,0,0, 10307, 'TESO/QA > BJA',		'TQA#BJA', 100, 'TESORERIA'
GO
-- ===============================================
SET NOCOUNT OFF
-- ===============================================

-- SELECT * FROM PERSONAL_ACCESO_ORGANIZACION

-- SELECT * FROM USUARIO

DELETE 
FROM	USUARIO
WHERE	299<K_USUARIO AND K_USUARIO<399
GO



-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_USUARIO]	0,0,0, 300, 'ALL > QA/TESO', '', 'TQA#ALL', 140, 1, '', 'TALL', 'TALL', '01/NOV/2017',	1,	1,	10300
EXECUTE [dbo].[PG_CI_USUARIO]	0,0,0, 301, 'CHI > QA/TESO', '', 'TQA#CHI', 140, 1, '', 'TCHI', 'TCHI', '01/NOV/2017',	1,	1,	10301
EXECUTE [dbo].[PG_CI_USUARIO]	0,0,0, 302, 'JAL > QA/TESO', '', 'TQA#JAL', 140, 1, '', 'TJAL', 'TJAL', '01/NOV/2017',	1,	1,	10302
EXECUTE [dbo].[PG_CI_USUARIO]	0,0,0, 303, 'SUR > QA/TESO', '', 'TQA#SUR', 140, 1, '', 'TSUR', 'TSUR', '01/NOV/2017',	1,	1,	10303
EXECUTE [dbo].[PG_CI_USUARIO]	0,0,0, 304, 'MEX > QA/TESO', '', 'TQA#MEX', 140, 1, '', 'TMEX', 'TMEX', '01/NOV/2017',	1,	1,	10304
EXECUTE [dbo].[PG_CI_USUARIO]	0,0,0, 305, 'CEN > QA/TESO', '', 'TQA#CEN', 140, 1, '', 'TCEN', 'TCEN', '01/NOV/2017',	1,	1,	10305
EXECUTE [dbo].[PG_CI_USUARIO]	0,0,0, 306, 'SON > QA/TESO', '', 'TQA#SON', 140, 1, '', 'TSON', 'TSON', '01/NOV/2017',	1,	1,	10306
EXECUTE [dbo].[PG_CI_USUARIO]	0,0,0, 307, 'BJA > QA/TESO', '', 'TQA#BJA', 140, 1, '', 'TBJA', 'TBJA', '01/NOV/2017',	1,	1,	10307
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================





-- //////////////////////////////////////////////////////////////
-- //
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PERSONAL_ACCESO_ORGANIZACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PERSONAL_ACCESO_ORGANIZACION]
GO


CREATE PROCEDURE [dbo].[PG_CI_PERSONAL_ACCESO_ORGANIZACION]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ========================================
	@PP_K_PERSONAL_ACCESO_ORGANIZACION		INT,
	@PP_K_PERSONAL							INT,
	@PP_K_RAZON_SOCIAL						INT,
	@PP_K_ZONA_UO							INT,
	@PP_K_UNIDAD_OPERATIVA					INT
AS
	
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_PERSONAL_ACCESO_ORGANIZACION
							FROM	[PERSONAL_ACCESO_ORGANIZACION]
							WHERE	K_PERSONAL_ACCESO_ORGANIZACION=@PP_K_PERSONAL_ACCESO_ORGANIZACION

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO [PERSONAL_ACCESO_ORGANIZACION]	
			(	K_PERSONAL_ACCESO_ORGANIZACION,				K_PERSONAL, 
				K_RAZON_SOCIAL,				K_ZONA_UO,
				K_UNIDAD_OPERATIVA,			
				-- ============================================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )			
		VALUES	
			(	@PP_K_PERSONAL_ACCESO_ORGANIZACION,			@PP_K_PERSONAL,	
				@PP_K_RAZON_SOCIAL,			@PP_K_ZONA_UO,
				@PP_K_UNIDAD_OPERATIVA,				
				-- ============================================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )		
	ELSE
		UPDATE	PERSONAL_ACCESO_ORGANIZACION
		SET		K_PERSONAL	= @PP_K_PERSONAL,	
				K_RAZON_SOCIAL	= @PP_K_RAZON_SOCIAL,			
				K_ZONA_UO	= @PP_K_ZONA_UO,
				K_UNIDAD_OPERATIVA	= @PP_K_UNIDAD_OPERATIVA,	
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	K_PERSONAL_ACCESO_ORGANIZACION=@PP_K_PERSONAL_ACCESO_ORGANIZACION

	-- =========================================================
GO

-- //////////////////////////////////////////////////////////////






-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_PERSONAL_ACCESO_ORGANIZACION] 0,0,0, 0, 10300, -1, -1, -1
EXECUTE [dbo].[PG_CI_PERSONAL_ACCESO_ORGANIZACION] 0,0,0, 1, 10301, -7, 30, -7
EXECUTE [dbo].[PG_CI_PERSONAL_ACCESO_ORGANIZACION] 0,0,0, 2, 10302, -7, 40, -7
EXECUTE [dbo].[PG_CI_PERSONAL_ACCESO_ORGANIZACION] 0,0,0, 3, 10303, -7, 60, -7
EXECUTE [dbo].[PG_CI_PERSONAL_ACCESO_ORGANIZACION] 0,0,0, 4, 10304, -7, 70, -7
EXECUTE [dbo].[PG_CI_PERSONAL_ACCESO_ORGANIZACION] 0,0,0, 5, 10305, -7, 20, -7
EXECUTE [dbo].[PG_CI_PERSONAL_ACCESO_ORGANIZACION] 0,0,0, 6, 10306, -7, 50, -7
EXECUTE [dbo].[PG_CI_PERSONAL_ACCESO_ORGANIZACION] 0,0,0, 7, 10307, -7, 10, -7
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
