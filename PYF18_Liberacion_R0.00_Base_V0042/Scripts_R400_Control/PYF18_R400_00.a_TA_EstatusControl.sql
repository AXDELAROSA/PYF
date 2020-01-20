-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CONTROL OPERACION / <GLOBAL>
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	03/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////




IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_CONTROL]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_CONTROL] 
GO





-- ///////////////////////////////////////////////////////////////
-- // ESTATUS_CONTROL 						
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ESTATUS_CONTROL] (
	[K_ESTATUS_CONTROL]		[INT] 			NOT NULL,
	[D_ESTATUS_CONTROL]		[VARCHAR] (100) NOT NULL,
	[S_ESTATUS_CONTROL]		[VARCHAR] (10) 	NOT NULL,
	[O_ESTATUS_CONTROL]		[INT] 			NOT NULL,
	[C_ESTATUS_CONTROL]		[VARCHAR] (255) NOT NULL,
	[L_ESTATUS_CONTROL]		[INT] 			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[ESTATUS_CONTROL]
	ADD CONSTRAINT [PK_ESTATUS_CONTROL]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_CONTROL])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_CONTROL_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_CONTROL] ( [D_ESTATUS_CONTROL] )
GO

-- //////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_CONTROL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_CONTROL]
GO



CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_CONTROL]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_ESTATUS_CONTROL		INT,
	@PP_D_ESTATUS_CONTROL		VARCHAR(100),
	@PP_S_ESTATUS_CONTROL		VARCHAR(10),
	@PP_O_ESTATUS_CONTROL		INT,
	@PP_C_ESTATUS_CONTROL		VARCHAR(255),
	@PP_L_ESTATUS_CONTROL		INT
AS

	INSERT INTO ESTATUS_CONTROL
		(	K_ESTATUS_CONTROL,			D_ESTATUS_CONTROL, 
			S_ESTATUS_CONTROL,			O_ESTATUS_CONTROL,
			C_ESTATUS_CONTROL,
			L_ESTATUS_CONTROL			)	
	VALUES	
		(	@PP_K_ESTATUS_CONTROL,		@PP_D_ESTATUS_CONTROL,	
			@PP_S_ESTATUS_CONTROL,		@PP_O_ESTATUS_CONTROL,
			@PP_C_ESTATUS_CONTROL,
			@PP_L_ESTATUS_CONTROL		)

	-- ==============================================
GO





-- ///////////////////////////////////////////////////////////////
-- // ESTATUS_CONTROL 						
-- ///////////////////////////////////////////////////////////////

EXECUTE [dbo].[PG_CI_ESTATUS_CONTROL]	0, 0, 0, 'BASE',			'BASE', 00, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CONTROL]	0, 0, 1, 'PROGRAMADO',		'PROG', 10, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CONTROL]	0, 0, 2, 'REVISION',		'VOBO', 20, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CONTROL]	0, 0, 3, 'PREPARACIÓN',		'PREP', 30, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CONTROL]	0, 0, 4, 'EJECUCIÓN',		'EJEC', 40, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CONTROL]	0, 0, 5, 'CERRADO',			'CERR', 50, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_CONTROL]	0, 0, 6, 'AJUSTES',			'AJUS', 60, '', 1
GO







-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
