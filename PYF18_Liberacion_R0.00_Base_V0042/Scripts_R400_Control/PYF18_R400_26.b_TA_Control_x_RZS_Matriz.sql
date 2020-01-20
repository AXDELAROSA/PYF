-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CONTROL OPERACION / <RAZON_SOCIAL>
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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL]') AND type in (N'U'))
	DROP TABLE [dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
GO



-- ///////////////////////////////////////////////////////////////
-- //						
-- ///////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] (
	[K_YYYY]				[INT] NOT NULL,
	[K_RAZON_SOCIAL]		[INT] NOT NULL,
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


ALTER TABLE [dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL]
	ADD CONSTRAINT [PK_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL]
		PRIMARY KEY CLUSTERED (	[K_YYYY], [K_RAZON_SOCIAL] )
GO


ALTER TABLE [dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] ADD 
	CONSTRAINT [FK_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL_RZ] 
		FOREIGN KEY ([K_RAZON_SOCIAL]) 
		REFERENCES [dbo].[RAZON_SOCIAL] ([K_RAZON_SOCIAL])
GO



-- //////////////////////////////////////////////////////
-- SELECT * FROM [MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL]


INSERT INTO  [dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
		( [K_YYYY], [K_RAZON_SOCIAL] )
	VALUES
--		( 2020 ), ( 2019 ), ( 2018 ), ( 2017 ),
		( 2016, 1 )
		


-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
