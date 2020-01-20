-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			AUTORIZACIONES / FLUJO FIRMAS
-- // OPERACION:		LIBERACION / TABLAS
-- //////////////////////////////////////////////////////////////
-- // Autor:			ALEX DE LA ROSA // HECTOR A. GONZALEZ 
-- // Fecha creación:	18/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ROL_ASIGNACION]') AND type in (N'U'))
	DROP TABLE [dbo].[ROL_ASIGNACION] 
GO





-- ///////////////////////////////////////////////////////////////
-- // ROL_ASIGNACION				
-- ///////////////////////////////////////////////////////////////
	

CREATE TABLE [dbo].[ROL_ASIGNACION] (
	-- =============================== CONTROL
	[K_ROL_ASIGNACION]				INT NOT NULL,
	-- =============================== 
	[K_ZONA_UO]						INT NOT NULL	DEFAULT 0,
	[K_RAZON_SOCIAL]				INT NOT NULL	DEFAULT 0,
	[K_UNIDAD_OPERATIVA]			INT NOT NULL	DEFAULT 0,
	[K_ROL_AUTORIZACION]			INT NOT NULL	DEFAULT 0,
	[K_USUARIO]						INT NOT NULL	DEFAULT 0
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[ROL_ASIGNACION]
	ADD CONSTRAINT [PK_ROL_ASIGNACION]
		PRIMARY KEY CLUSTERED ([K_ROL_ASIGNACION])
GO


-- //////////////////////////////////////////////////////

/*
CREATE UNIQUE NONCLUSTERED 
	INDEX [IX_ROL_ASIGNACION_K_AUTORIZACION_FIRMA_N_PASO] 
	   ON [dbo].[ROL_ASIGNACION] ( [K_AUTORIZACION_FIRMA], [N_PASO] )
GO
*/

-- //////////////////////////////////////////////////////



ALTER TABLE [dbo].[ROL_ASIGNACION] ADD 
	CONSTRAINT [FK_ROL_ASIGNACION_01] 
		FOREIGN KEY ([K_RAZON_SOCIAL]) 
		REFERENCES [dbo].[RAZON_SOCIAL] ([K_RAZON_SOCIAL]),
	CONSTRAINT [FK_ROL_ASIGNACION_02] 
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA]),
	CONSTRAINT [FK_ROL_ASIGNACION_03] 
		FOREIGN KEY ([K_ROL_AUTORIZACION]) 
		REFERENCES [dbo].[ROL_AUTORIZACION] ([K_ROL_AUTORIZACION]),
	CONSTRAINT [FK_ROL_ASIGNACION_04] 
		FOREIGN KEY ([K_USUARIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO

-- //////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[ROL_ASIGNACION] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO



ALTER TABLE [dbo].[ROL_ASIGNACION] ADD 
	CONSTRAINT [FK_ROL_ASIGNACION_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_ROL_ASIGNACION_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_ROL_ASIGNACION_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO







-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
