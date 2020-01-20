-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / TABLA+CARGA 
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[DOCUMENTO_D0M4_TRACKING_X_MES] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL DEFAULT 0,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[DOCUMENTO_D0M4_TRACKING_X_MES] ADD 
	CONSTRAINT [FK_DOCUMENTO_D0M4_TRACKING_X_MES_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_DOCUMENTO_D0M4_TRACKING_X_MES_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_DOCUMENTO_D0M4_TRACKING_X_MES_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO
