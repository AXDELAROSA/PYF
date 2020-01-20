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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATA_N3_X_ME_D0M4]') AND type in (N'U'))
	DROP TABLE [dbo].[DATA_N3_X_ME_D0M4] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATA_N1_X_DI_D0M4]') AND type in (N'U'))
	DROP TABLE [dbo].[DATA_N1_X_DI_D0M4] 
GO








-- ///////////////////////////////////////////////////////////////
-- //						DATA_N1_X_DI_D0M4 						
-- ///////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[DATA_N1_X_DI_D0M4] (
	[K_DOCUMENTO_D0M4]			[INT] NOT NULL,
	[K_DATO_D0M4]				[INT] NOT NULL,
	-- ===========================================	
	[VALOR_ACUMULADO]	DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D00_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	-- ===========================================	
	[DXX_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[DYY_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[DZZ_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	-- ===========================================	
	[D01_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D02_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D03_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D04_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D05_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D06_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D07_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D08_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D09_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D10_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D11_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D12_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D13_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D14_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D15_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D16_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D17_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D18_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D19_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D20_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D21_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D22_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D23_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D24_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D25_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D26_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D27_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D28_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D29_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D30_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[D31_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[DATA_N1_X_DI_D0M4]
	ADD CONSTRAINT [PK_DATA_N1_X_DI_D0M4]
		PRIMARY KEY CLUSTERED (	[K_DOCUMENTO_D0M4], [K_DATO_D0M4] )
GO



ALTER TABLE [dbo].[DATA_N1_X_DI_D0M4] ADD 
	CONSTRAINT [FK_DATA_N1_X_DI_D0M4_01] 
		FOREIGN KEY ([K_DOCUMENTO_D0M4]) 
		REFERENCES [dbo].[DOCUMENTO_D0M4] ( [K_DOCUMENTO_D0M4] ),
	CONSTRAINT [FK_DATA_N1_X_DI_D0M4_02] 
		FOREIGN KEY ([K_DATO_D0M4]) 
		REFERENCES [dbo].[DATO_D0M4] ( [K_DATO_D0M4] )
GO




-- ///////////////////////////////////////////////////////////////
-- //						DATA_N3_X_ME_D0M4 						
-- ///////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[DATA_N3_X_ME_D0M4] (
	[K_DOCUMENTO_D0M4]			[INT] NOT NULL,
	[K_DATO_D0M4]				[INT] NOT NULL,
	-- ===========================================	
	[VALOR_ACUMULADO]	DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M00_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M01_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M02_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M03_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M04_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M05_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M06_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M07_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M08_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M09_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M10_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M11_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M12_VALOR]			DECIMAL(19,4) NOT NULL DEFAULT 0
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[DATA_N3_X_ME_D0M4]
	ADD CONSTRAINT [PK_DATA_N3_X_ME_D0M4]
		PRIMARY KEY CLUSTERED (	[K_DOCUMENTO_D0M4], [K_DATO_D0M4] )
GO



ALTER TABLE [dbo].[DATA_N3_X_ME_D0M4] ADD 
	CONSTRAINT [FK_DATA_N3_X_ME_D0M4_01] 
		FOREIGN KEY ([K_DOCUMENTO_D0M4]) 
		REFERENCES [dbo].[DOCUMENTO_D0M4] ( [K_DOCUMENTO_D0M4] ),
	CONSTRAINT [FK_DATA_N3_X_ME_D0M4_02] 
		FOREIGN KEY ([K_DATO_D0M4]) 
		REFERENCES [dbo].[DATO_D0M4] ( [K_DATO_D0M4] )
GO





-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
