-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PERFORMANCE_N3_X_ME]') AND type in (N'U'))
	DROP TABLE [dbo].[PERFORMANCE_N3_X_ME]
GO



-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////



CREATE TABLE [dbo].[PERFORMANCE_N3_X_ME](
	[K_YYYY]				[int]				NOT NULL,
	[XLS_UO]				[int]				NOT NULL,
	[XLS_UNIDAD_OPERATIVA]	[varchar](100)		NOT NULL,
	[K_UNIDAD_OPERATIVA]	[int]				NOT NULL,
	[K_METRICA]				[int]				NOT NULL,
	[VALOR_ACUMULADO]		[decimal](19, 4)	NOT NULL,
	[M00_VALOR]				[decimal](19, 4)	NOT NULL,
	[M01_VALOR]				[decimal](19, 4)	NOT NULL,
	[M02_VALOR]				[decimal](19, 4)	NOT NULL,
	[M03_VALOR]				[decimal](19, 4)	NOT NULL,
	[M04_VALOR]				[decimal](19, 4)	NOT NULL,
	[M05_VALOR]				[decimal](19, 4)	NOT NULL,
	[M06_VALOR]				[decimal](19, 4)	NOT NULL,
	[M07_VALOR]				[decimal](19, 4)	NOT NULL,
	[M08_VALOR]				[decimal](19, 4)	NOT NULL,
	[M09_VALOR]				[decimal](19, 4)	NOT NULL,
	[M10_VALOR]				[decimal](19, 4)	NOT NULL,
	[M11_VALOR]				[decimal](19, 4)	NOT NULL,
	[M12_VALOR]				[decimal](19, 4)	NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [K_UNIDAD_OPERATIVA]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((-1)) FOR [K_METRICA]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [VALOR_ACUMULADO]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [M00_VALOR]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [M01_VALOR]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [M02_VALOR]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [M03_VALOR]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [M04_VALOR]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [M05_VALOR]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [M06_VALOR]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [M07_VALOR]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [M08_VALOR]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [M09_VALOR]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [M10_VALOR]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [M11_VALOR]
GO
ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD  DEFAULT ((0)) FOR [M12_VALOR]
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME]
	ADD CONSTRAINT [PK_PERFORMANCE_N3_X_ME]
		PRIMARY KEY CLUSTERED ([K_YYYY], [XLS_UO] )
GO



-- //////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL DEFAULT 0,
			[F_ALTA]			[DATETIME]	NOT NULL DEFAULT 0,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL DEFAULT 0,
			[F_CAMBIO]			[DATETIME]	NOT NULL DEFAULT 0,
			[L_BORRADO]			[INT]		NOT NULL DEFAULT 0,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[PERFORMANCE_N3_X_ME] ADD 
	CONSTRAINT [FK_PERFORMANCE_N3_X_ME_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PERFORMANCE_N3_X_ME_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PERFORMANCE_N3_X_ME_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO

