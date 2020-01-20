-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CUENTA CONTABLE UO
-- // OPERACION:		LIBERACION / TABLAS
-- // AUTOR:			LBG
-- // FECHA:            20181203
-- ////////////////////////////////////////////////////////////// 



USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CUENTA_CONTABLE_UO]') AND type in (N'U'))
	DROP TABLE [dbo].[CUENTA_CONTABLE_UO]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FORMATO_CUENTA]') AND type in (N'U'))
	DROP TABLE [dbo].[FORMATO_CUENTA]
GO


/****************************************************************/
/*						FORMATO_CUENTA							*/
/****************************************************************/

CREATE TABLE [dbo].[FORMATO_CUENTA] (
	[K_FORMATO_CUENTA]	[INT] NOT NULL,
	[D_FORMATO_CUENTA]	[VARCHAR] (100) NOT NULL,
	[S_FORMATO_CUENTA]	[VARCHAR] (10) NOT NULL,
	[O_FORMATO_CUENTA]	[INT] NOT NULL,
	[C_FORMATO_CUENTA]	[VARCHAR] (255) NOT NULL,
	[L_FORMATO_CUENTA]	[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////

ALTER TABLE [dbo].[FORMATO_CUENTA]
	ADD CONSTRAINT [PK_FORMATO_CUENTA]
		PRIMARY KEY CLUSTERED ([K_FORMATO_CUENTA])
GO

CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_FORMATO_CUENTA_01_DESCRIPCION] 
	   ON [dbo].[FORMATO_CUENTA] ( [D_FORMATO_CUENTA] )
GO

ALTER TABLE [dbo].[FORMATO_CUENTA] ADD 
	CONSTRAINT [FK_FORMATO_CUENTA_01] 
		FOREIGN KEY ( [L_FORMATO_CUENTA] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO

-- ///////////////////////////////////////////////////////////////

ALTER TABLE [dbo].[FORMATO_CUENTA] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[FORMATO_CUENTA] ADD 
	CONSTRAINT [FK_FORMATO_CUENTA_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_FORMATO_CUENTA_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_FORMATO_CUENTA_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



/****************************************************************/
/*					CUENTA_CONTABLE_UO							*/
/****************************************************************/

CREATE TABLE [dbo].[CUENTA_CONTABLE_UO] (
	[K_CUENTA_CONTABLE_UO]		[INT]	NOT NULL,
	[K_CUENTA_CONTABLE]			[INT]	NOT NULL,
	[K_UNIDAD_OPERATIVA]		[INT]	NOT NULL,
	[K_FORMATO_CUENTA]			[INT]	NOT NULL,
	[O_CUENTA_CONTABLE_UO]		[INT]	NOT NULL	
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////

ALTER TABLE [dbo].[CUENTA_CONTABLE_UO]
	ADD CONSTRAINT [PK_CUENTA_CONTABLE_UO]
		PRIMARY KEY CLUSTERED ([K_CUENTA_CONTABLE_UO])
GO

CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_CUENTA_CONTABLE_UO_01_UNIQUE] 
	   ON [dbo].[CUENTA_CONTABLE_UO] ( [K_UNIDAD_OPERATIVA],[K_CUENTA_CONTABLE],[K_FORMATO_CUENTA] )
GO


ALTER TABLE [dbo].[CUENTA_CONTABLE_UO] ADD 
	CONSTRAINT [FK_CUENTA_CONTABLE_UO_01] 
		FOREIGN KEY ( [K_FORMATO_CUENTA] ) 
		REFERENCES [dbo].[FORMATO_CUENTA] ( [K_FORMATO_CUENTA] ),
	CONSTRAINT [FK_CUENTA_CONTABLE_UO_02] 
		FOREIGN KEY ( [K_UNIDAD_OPERATIVA] ) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ( [K_UNIDAD_OPERATIVA] ),
	CONSTRAINT [FK_CUENTA_CONTABLE_UO_03] 
		FOREIGN KEY ( [K_CUENTA_CONTABLE] ) 
		REFERENCES [dbo].[CUENTA_CONTABLE] ( [K_CUENTA_CONTABLE] )
	
GO

-- ///////////////////////////////////////////////////////////////

ALTER TABLE [dbo].[CUENTA_CONTABLE_UO] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO

ALTER TABLE [dbo].[CUENTA_CONTABLE_UO] ADD 
	CONSTRAINT [FK_CUENTA_CONTABLE_UO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_CUENTA_CONTABLE_UO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_CUENTA_CONTABLE_UO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO

-- //////////////////////////////////////////////////////////////


