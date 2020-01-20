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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MATRIZ_CONTROL_X_MES]') AND type in (N'U'))
	DROP TABLE [dbo].[MATRIZ_CONTROL_X_MES] 
GO



-- ///////////////////////////////////////////////////////////////
-- //						
-- ///////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[MATRIZ_CONTROL_X_MES] (
	[K_YYYY]				[INT] NOT NULL,
	-- =====================================
	[M01_ESTATUS]			VARCHAR(50) NOT NULL DEFAULT '-',
	[M02_ESTATUS]			VARCHAR(50) NOT NULL DEFAULT '-',
	[M03_ESTATUS]			VARCHAR(50) NOT NULL DEFAULT '-',
	[M04_ESTATUS]			VARCHAR(50) NOT NULL DEFAULT '-',
	[M05_ESTATUS]			VARCHAR(50) NOT NULL DEFAULT '-',
	[M06_ESTATUS]			VARCHAR(50) NOT NULL DEFAULT '-',
	[M07_ESTATUS]			VARCHAR(50) NOT NULL DEFAULT '-',
	[M08_ESTATUS]			VARCHAR(50) NOT NULL DEFAULT '-',
	[M09_ESTATUS]			VARCHAR(50) NOT NULL DEFAULT '-',
	[M10_ESTATUS]			VARCHAR(50) NOT NULL DEFAULT '-',
	[M11_ESTATUS]			VARCHAR(50) NOT NULL DEFAULT '-',
	[M12_ESTATUS]			VARCHAR(50) NOT NULL DEFAULT '-'
	-- ===========================================	
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[MATRIZ_CONTROL_X_MES]
	ADD CONSTRAINT [PK_MATRIZ_CONTROL_X_MES]
		PRIMARY KEY CLUSTERED (	[K_YYYY] )
GO




-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
