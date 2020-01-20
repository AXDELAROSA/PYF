-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PRESUPUESTO GASTOS/PLANTA
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	24/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROGRAMACION_PARTIDA]') AND type in (N'U'))
	DROP TABLE [dbo].[PROGRAMACION_PARTIDA] 
GO





-- ///////////////////////////////////////////////////////////////
-- // PROGRAMACION_PARTIDA 						
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[PROGRAMACION_PARTIDA] (
	[K_PROGRAMACION_PARTIDA]		[INT] 			NOT NULL,
	[D_PROGRAMACION_PARTIDA]		[VARCHAR] (100) NOT NULL,
	[S_PROGRAMACION_PARTIDA]		[VARCHAR] (10) 	NOT NULL,
	[O_PROGRAMACION_PARTIDA]		[INT] 			NOT NULL,
	[C_PROGRAMACION_PARTIDA]		[VARCHAR] (255) NOT NULL,
	[L_PROGRAMACION_PARTIDA]		[INT] 			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PROGRAMACION_PARTIDA]
	ADD CONSTRAINT [PK_PROGRAMACION_PARTIDA]
		PRIMARY KEY CLUSTERED ([K_PROGRAMACION_PARTIDA])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_PROGRAMACION_PARTIDA_01_DESCRIPCION] 
	   ON [dbo].[PROGRAMACION_PARTIDA] ( [D_PROGRAMACION_PARTIDA] )
GO

-- //////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PROGRAMACION_PARTIDA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PROGRAMACION_PARTIDA]
GO



CREATE PROCEDURE [dbo].[PG_CI_PROGRAMACION_PARTIDA]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	-- =======================================
	@PP_K_PROGRAMACION_PARTIDA			INT,
	@PP_D_PROGRAMACION_PARTIDA			VARCHAR(100),
	@PP_S_PROGRAMACION_PARTIDA			VARCHAR(10),
	@PP_O_PROGRAMACION_PARTIDA			INT,
	@PP_C_PROGRAMACION_PARTIDA			VARCHAR(255),
	@PP_L_PROGRAMACION_PARTIDA			INT
AS

	INSERT INTO PROGRAMACION_PARTIDA
			(	K_PROGRAMACION_PARTIDA,			D_PROGRAMACION_PARTIDA, 
				S_PROGRAMACION_PARTIDA,			O_PROGRAMACION_PARTIDA,
				C_PROGRAMACION_PARTIDA,
				L_PROGRAMACION_PARTIDA				)	
	VALUES	
			(	@PP_K_PROGRAMACION_PARTIDA,		@PP_D_PROGRAMACION_PARTIDA,	
				@PP_S_PROGRAMACION_PARTIDA,		@PP_O_PROGRAMACION_PARTIDA,
				@PP_C_PROGRAMACION_PARTIDA,
				@PP_L_PROGRAMACION_PARTIDA			)

	-- ==============================================
GO





-- ///////////////////////////////////////////////////////////////
-- // PROGRAMACION_PARTIDA 						
-- ///////////////////////////////////////////////////////////////
--		SELECT * FROM PROGRAMACION_PARTIDA


EXECUTE [dbo].[PG_CI_PROGRAMACION_PARTIDA]	0, 0, 000, '',	'', 0, '', 1
-- ==========================
EXECUTE [dbo].[PG_CI_PROGRAMACION_PARTIDA]	0, 0, 101, 'W1000-',	'X----', 1, '', 1
EXECUTE [dbo].[PG_CI_PROGRAMACION_PARTIDA]	0, 0, 102, 'W0100-',	'-X---', 2, '', 1
EXECUTE [dbo].[PG_CI_PROGRAMACION_PARTIDA]	0, 0, 103, 'W0010-',	'--X--', 3, '', 1
EXECUTE [dbo].[PG_CI_PROGRAMACION_PARTIDA]	0, 0, 104, 'W0001-',	'---X-', 4, '', 1
-- ==========================
EXECUTE [dbo].[PG_CI_PROGRAMACION_PARTIDA]	0, 0, 201, 'W1010-',	'X-X--', 5, '', 1
EXECUTE [dbo].[PG_CI_PROGRAMACION_PARTIDA]	0, 0, 202, 'W0101-',	'-X-X-', 6, '', 1
-- ==========================
EXECUTE [dbo].[PG_CI_PROGRAMACION_PARTIDA]	0, 0, 401, 'W11110',	'XXXX-', 7, '', 1
-- ==========================
EXECUTE [dbo].[PG_CI_PROGRAMACION_PARTIDA]	0, 0, 501, 'W11111',	'XXXXX', 8, '', 1
GO






-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
