-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CONTROL OPERACION / <UNIDAD_OPERATIVA>
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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CONTROL_X_MES_X_UNIDAD_OPERATIVA]') AND type in (N'U'))
	DROP TABLE [dbo].[CONTROL_X_MES_X_UNIDAD_OPERATIVA] 
GO



-- ///////////////////////////////////////////////////////////////
-- // CONTROL_X_MES_X_UNIDAD_OPERATIVA 						
-- ///////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[CONTROL_X_MES_X_UNIDAD_OPERATIVA] (
	[K_YYYY]						[INT] NOT NULL,
	[K_MM]							[INT] NOT NULL,
	[K_UNIDAD_OPERATIVA]			[INT] NOT NULL,
	-- =====================================
	[K_ESTATUS_CONTROL]				[INT] NOT NULL DEFAULT 0,  -- BASE
	[L_01_PPT_GENERAR]				[BIT] NOT NULL DEFAULT 0,
	[L_02_PPT_EDITAR]				[BIT] NOT NULL DEFAULT 0,
	[L_03_PPT_PROGRAMAR]			[BIT] NOT NULL DEFAULT 0,
	[L_04_PPT_GENERAR_TRASPASOS]	[BIT] NOT NULL DEFAULT 0,
	[L_05_PFD_POLIZA_EDIT]			[BIT] NOT NULL DEFAULT 0,
	[L_06_PFD_INGRESOS_ADD]			[BIT] NOT NULL DEFAULT 0,
	[L_07_PFD_TRASPASO_ADD]			[BIT] NOT NULL DEFAULT 0,
	[L_08_PFD_FACTURA_ADD]			[BIT] NOT NULL DEFAULT 0,
	[L_09_PFD_INSTRUCCION_NEW]		[BIT] NOT NULL DEFAULT 0,
	[L_10_ACCION]					[BIT] NOT NULL DEFAULT 0,
	-- =====================================
	[L_11_ACCION]					[BIT] NOT NULL DEFAULT 0,
	[L_12_ACCION]					[BIT] NOT NULL DEFAULT 0,
	[L_13_ACCION]					[BIT] NOT NULL DEFAULT 0,
	[L_14_ACCION]					[BIT] NOT NULL DEFAULT 0,
	[L_15_ACCION]					[BIT] NOT NULL DEFAULT 0,
	[L_16_ACCION]					[BIT] NOT NULL DEFAULT 0,
	[L_17_ACCION]					[BIT] NOT NULL DEFAULT 0,
	[L_18_ACCION]					[BIT] NOT NULL DEFAULT 0,
	[L_19_ACCION]					[BIT] NOT NULL DEFAULT 0,
	[L_20_ACCION]					[BIT] NOT NULL DEFAULT 0
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[CONTROL_X_MES_X_UNIDAD_OPERATIVA]
	ADD CONSTRAINT [PK_CONTROL_X_MES_X_UNIDAD_OPERATIVA]
		PRIMARY KEY CLUSTERED ( [K_YYYY], [K_MM], [K_UNIDAD_OPERATIVA] )
GO




-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[CONTROL_X_MES_X_UNIDAD_OPERATIVA] ADD 
	CONSTRAINT [FK_CONTROL_X_MES_X_UNIDAD_OPERATIVA_UO] 
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA])
GO


ALTER TABLE [dbo].[CONTROL_X_MES_X_UNIDAD_OPERATIVA] ADD 
	CONSTRAINT [FK_CONTROL_X_MES_X_UNIDAD_OPERATIVA_01] 
		FOREIGN KEY ([K_ESTATUS_CONTROL]) 
		REFERENCES [dbo].[ESTATUS_CONTROL] ([K_ESTATUS_CONTROL])
GO



-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[CONTROL_X_MES_X_UNIDAD_OPERATIVA] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[CONTROL_X_MES_X_UNIDAD_OPERATIVA] ADD 
	CONSTRAINT [FK_CONTROL_X_MES_X_UNIDAD_OPERATIVA_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_CONTROL_X_MES_X_UNIDAD_OPERATIVA_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_CONTROL_X_MES_X_UNIDAD_OPERATIVA_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
