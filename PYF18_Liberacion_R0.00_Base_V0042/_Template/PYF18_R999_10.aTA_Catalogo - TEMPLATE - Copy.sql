-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	ADG18_AdministradoraGas
-- // MODULO:			
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 

USE [ADG18_AdministradoraGas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////





-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NOMBRE_TABLA]') AND type in (N'U'))
	DROP TABLE [dbo].[NOMBRE_TABLA]
GO





-- //////////////////////////////////////////////////////////////
-- // NOMBRE_TABLA
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[NOMBRE_TABLA] (
	[K_NOMBRE_TABLA]	[INT] NOT NULL,
	[D_NOMBRE_TABLA]	[VARCHAR] (100) NOT NULL,
	[S_NOMBRE_TABLA]	[VARCHAR] (10) NOT NULL,
	[O_NOMBRE_TABLA]	[INT] NOT NULL,
	[C_NOMBRE_TABLA]	[VARCHAR] (255) NOT NULL,
	[L_NOMBRE_TABLA]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[NOMBRE_TABLA]
	ADD CONSTRAINT [PK_NOMBRE_TABLA]
		PRIMARY KEY CLUSTERED ([K_NOMBRE_TABLA])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_NOMBRE_TABLA_01_DESCRIPCION] 
	   ON [dbo].[NOMBRE_TABLA] ( [D_NOMBRE_TABLA] )
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[NOMBRE_TABLA] ADD 
	CONSTRAINT [FK_NOMBRE_TABLA_01] 
		FOREIGN KEY ( [L_NOMBRE_TABLA] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_NOMBRE_TABLA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_NOMBRE_TABLA]
GO


CREATE PROCEDURE [dbo].[PG_CI_NOMBRE_TABLA]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	-- ========================================
	@PP_K_NOMBRE_TABLA		INT,
	@PP_D_NOMBRE_TABLA		VARCHAR(100),
	@PP_S_NOMBRE_TABLA		VARCHAR(10),
	@PP_O_NOMBRE_TABLA		INT,
	@PP_C_NOMBRE_TABLA		VARCHAR(255),
	@PP_L_NOMBRE_TABLA		INT
AS
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_NOMBRE_TABLA
							FROM	NOMBRE_TABLA
							WHERE	K_NOMBRE_TABLA=@PP_K_NOMBRE_TABLA

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO NOMBRE_TABLA
			(	K_NOMBRE_TABLA,			D_NOMBRE_TABLA, 
				S_NOMBRE_TABLA,			O_NOMBRE_TABLA,
				C_NOMBRE_TABLA,
				L_NOMBRE_TABLA			)		
		VALUES	
			(	@PP_K_NOMBRE_TABLA,		@PP_D_NOMBRE_TABLA,	
				@PP_S_NOMBRE_TABLA,		@PP_O_NOMBRE_TABLA,
				@PP_C_NOMBRE_TABLA,
				@PP_L_NOMBRE_TABLA		)
	ELSE
		UPDATE	NOMBRE_TABLA
		SET		D_NOMBRE_TABLA	= @PP_D_NOMBRE_TABLA,	
				S_NOMBRE_TABLA	= @PP_S_NOMBRE_TABLA,			
				O_NOMBRE_TABLA	= @PP_O_NOMBRE_TABLA,
				C_NOMBRE_TABLA	= @PP_C_NOMBRE_TABLA,
				L_NOMBRE_TABLA	= @PP_L_NOMBRE_TABLA	
		WHERE	K_NOMBRE_TABLA=@PP_K_NOMBRE_TABLA

	-- =========================================================
GO

-- //////////////////////////////////////////////////////////////





-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_NOMBRE_TABLA] 0, 0,  1, 'NOMBRE_TABLA 1',		'NOM1', 1, '', 1
EXECUTE [dbo].[PG_CI_NOMBRE_TABLA] 0, 0,  2, 'NOMBRE_TABLA 2',		'NOM2', 1, '', 1
EXECUTE [dbo].[PG_CI_NOMBRE_TABLA] 0, 0,  3, 'NOMBRE_TABLA 3',		'NOM3', 1, '', 1
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
