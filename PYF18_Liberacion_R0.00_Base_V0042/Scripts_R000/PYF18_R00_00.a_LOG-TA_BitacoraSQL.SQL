-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			BITACORA / TRANSACCIONES-SQL 
-- // OPERACION:		LIBERACION / TABLA + STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			HECTOR A. GONZALEZ 
-- // Fecha creación:	26/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO



-- //////////////////////////////////////////////////////////////

-- SELECT * FROM [BITACORA_SQL]


-- //////////////////////////////////////////////////////////////
-- // DROPs 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BITACORA_SQL]') AND type in (N'U'))
	DROP TABLE [dbo].[BITACORA_SQL] 
GO



-- //////////////////////////////////////////////////////////////
-- // BITACORA_SQL
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[BITACORA_SQL] (
	[K_SISTEMA]					[INT] NOT NULL,
	[K_BITACORA_SQL]			[INT] IDENTITY(1,1),
	[F_BITACORA_SQL]			[DATE] NOT NULL,
	[F_BITACORA_SQL_EVENTO]		[DATETIME] NOT NULL,
	[K_USUARIO]					[INT] NULL,
	-- ===========================================
	[SENTENCIA_SQL]					[VARCHAR] (1000) NOT NULL,
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////

ALTER TABLE [dbo].[BITACORA_SQL]
	ADD CONSTRAINT [PK_BITACORA_SQL]
		PRIMARY KEY CLUSTERED ( [K_SISTEMA], [K_BITACORA_SQL] )
GO

-- //////////////////////////////////////////////////////////////

-- [PG_IN_BITACORA_SQL] 0,0,0, 'SQL INSERT'

-- SELECT * FROM BITACORA_SQL ORDER BY K_BITACORA_SQL DESC



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_BITACORA_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_BITACORA_SQL]
GO


CREATE PROCEDURE [dbo].[PG_IN_BITACORA_SQL]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO					[INT],
	-- ===========================================
	@PP_SENTENCIA_SQL				[VARCHAR] (1000)
AS

	DECLARE @VP_F_BITACORA_SQL			[DATETIME] 
	
	SET @VP_F_BITACORA_SQL = GETDATE()

	-- ========================================

	DECLARE @VP_REGISTRAR		INT = 1
	
	DECLARE @VP_TEXTO			[VARCHAR] (20) 
	
	SET @VP_TEXTO = LEFT(@PP_SENTENCIA_SQL,5)
	
	-- ========================================

	IF @PP_SENTENCIA_SQL LIKE '%PG_CB_%'
		SET @VP_REGISTRAR = 0

--	IF @PP_SENTENCIA_SQL LIKE '%PG_LI_%'
--		SET @VP_REGISTRAR = 0

	-- ========================================

	IF @VP_REGISTRAR=1
		INSERT INTO BITACORA_SQL
			(	[K_SISTEMA],
				[F_BITACORA_SQL], [F_BITACORA_SQL_EVENTO],
				[SENTENCIA_SQL]		)
		VALUES	
			(	@PP_K_SISTEMA_EXE,
				@VP_F_BITACORA_SQL, @VP_F_BITACORA_SQL,
				@PP_SENTENCIA_SQL	)
			
	-- ============================================
GO





-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
