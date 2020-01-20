-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DOCUMENTO_D0M4_TRACKING_X_MES]') AND type in (N'U'))
	DROP TABLE [dbo].[DOCUMENTO_D0M4_TRACKING_X_MES] 
GO




-- ///////////////////////////////////////////////////////////////
-- // DOCUMENTO_D0M4_TRACKING_X_MES 						
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[DOCUMENTO_D0M4_TRACKING_X_MES] (
	[K_YYYY]					[INT] NOT NULL,
	[K_FORMATO_D0M4]			[INT] NOT NULL,
	[K_UNIDAD_OPERATIVA]		[INT] NOT NULL,
	-- ===========================================	
	[M00_ESTATUS]				VARCHAR(50) NOT NULL DEFAULT '',
	[M01_ESTATUS]				VARCHAR(50) NOT NULL DEFAULT '',
	[M02_ESTATUS]				VARCHAR(50) NOT NULL DEFAULT '',
	[M03_ESTATUS]				VARCHAR(50) NOT NULL DEFAULT '',
	[M04_ESTATUS]				VARCHAR(50) NOT NULL DEFAULT '',
	[M05_ESTATUS]				VARCHAR(50) NOT NULL DEFAULT '',
	[M06_ESTATUS]				VARCHAR(50) NOT NULL DEFAULT '',
	[M07_ESTATUS]				VARCHAR(50) NOT NULL DEFAULT '',
	[M08_ESTATUS]				VARCHAR(50) NOT NULL DEFAULT '',
	[M09_ESTATUS]				VARCHAR(50) NOT NULL DEFAULT '',
	[M10_ESTATUS]				VARCHAR(50) NOT NULL DEFAULT '',
	[M11_ESTATUS]				VARCHAR(50) NOT NULL DEFAULT '',
	[M12_ESTATUS]				VARCHAR(50) NOT NULL DEFAULT ''
) ON [PRIMARY]
GO


-- /////////////////////////////////////

ALTER TABLE [dbo].[DOCUMENTO_D0M4_TRACKING_X_MES]
	ADD CONSTRAINT [PK_DOCUMENTO_D0M4_TRACKING_X_MES]
		PRIMARY KEY CLUSTERED (	[K_YYYY], [K_FORMATO_D0M4], [K_UNIDAD_OPERATIVA] )
GO

-- /////////////////////////////////////


ALTER TABLE [dbo].[DOCUMENTO_D0M4_TRACKING_X_MES] ADD 
	CONSTRAINT [FK_DOCUMENTO_D0M4_TRACKING_X_MES_01] 
		FOREIGN KEY ([K_FORMATO_D0M4]) 
		REFERENCES [dbo].[FORMATO_D0M4] ( [K_FORMATO_D0M4] ),
	CONSTRAINT [FK_DOCUMENTO_D0M4_TRACKING_X_MES_02] 
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ( [K_UNIDAD_OPERATIVA] )
GO





-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////


