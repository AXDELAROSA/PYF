-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			RUBRO GASTO
-- // OPERACION:		LIBERACION / TABLAS
-- // AUTOR:			LBG
-- // FECHA:            20180911
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLASIFICACION_GASTO]') AND type in (N'U'))
	DROP TABLE [dbo].[CLASIFICACION_GASTO]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RUBRO_GASTO]') AND type in (N'U'))
	DROP TABLE [dbo].[RUBRO_GASTO]
GO




/****************************************************************/
/*							RUBRO_GASTO							*/
/****************************************************************/

CREATE TABLE [dbo].[RUBRO_GASTO] (
	[K_RUBRO_GASTO]	[INT] NOT NULL,
	[D_RUBRO_GASTO]	[VARCHAR] (100) NOT NULL,
	[S_RUBRO_GASTO]	[VARCHAR] (10) NOT NULL,
	[O_RUBRO_GASTO]	[INT] NOT NULL,
	[C_RUBRO_GASTO]	[VARCHAR] (255) NOT NULL,
	[L_RUBRO_GASTO]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[RUBRO_GASTO]
	ADD CONSTRAINT [PK_RUBRO_GASTO]
		PRIMARY KEY CLUSTERED ([K_RUBRO_GASTO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_RUBRO_GASTO_01_DESCRIPCION] 
	   ON [dbo].[RUBRO_GASTO] ( [D_RUBRO_GASTO] )
GO


ALTER TABLE [dbo].[RUBRO_GASTO] ADD 
	CONSTRAINT [FK_RUBRO_GASTO_01] 
		FOREIGN KEY ( [L_RUBRO_GASTO] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- ///////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[RUBRO_GASTO] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[RUBRO_GASTO] ADD 
	CONSTRAINT [FK_RUBRO_GASTO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_RUBRO_GASTO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_RUBRO_GASTO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO





/****************************************************************/
/*					CLASIFICACION_GASTO						*/
/****************************************************************/

CREATE TABLE [dbo].[CLASIFICACION_GASTO] (
	[K_CLASIFICACION_GASTO]	[INT] NOT NULL,
	[D_CLASIFICACION_GASTO]	[VARCHAR] (100) NOT NULL,
	[S_CLASIFICACION_GASTO]	[VARCHAR] (10) NOT NULL,
	[O_CLASIFICACION_GASTO]	[INT] NOT NULL,
	[C_CLASIFICACION_GASTO]	[VARCHAR] (255) NOT NULL,
	[L_CLASIFICACION_GASTO]	[INT] NOT NULL,
	[K_RUBRO_GASTO]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[CLASIFICACION_GASTO]
	ADD CONSTRAINT [PK_CLASIFICACION_GASTO]
		PRIMARY KEY CLUSTERED ([K_CLASIFICACION_GASTO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_CLASIFICACION_GASTO_01_DESCRIPCION] 
	   ON [dbo].[CLASIFICACION_GASTO] ( [D_CLASIFICACION_GASTO],[K_RUBRO_GASTO] )
GO


ALTER TABLE [dbo].[CLASIFICACION_GASTO] ADD 
	CONSTRAINT [FK_CLASIFICACION_GASTO_01] 
		FOREIGN KEY ( [L_CLASIFICACION_GASTO] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] ),
	CONSTRAINT [FK_CLASIFICACION_GASTO_02] 
		FOREIGN KEY ( [K_RUBRO_GASTO] ) 
		REFERENCES [dbo].[RUBRO_GASTO] ( [K_RUBRO_GASTO] )
GO

-- ///////////////////////////////////////////////////////////////

ALTER TABLE [dbo].[CLASIFICACION_GASTO] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[CLASIFICACION_GASTO] ADD 
	CONSTRAINT [FK_CLASIFICACION_GASTO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_CLASIFICACION_GASTO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_CLASIFICACION_GASTO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO


-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
