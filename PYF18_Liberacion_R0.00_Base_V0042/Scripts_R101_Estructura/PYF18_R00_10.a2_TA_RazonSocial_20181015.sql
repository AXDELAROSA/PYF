-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			ORGANIZACION / RAZON_SOCIAL 
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RAZON_SOCIAL]') AND type in (N'U'))
	DROP TABLE [dbo].[RAZON_SOCIAL]
GO




IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_RAZON_SOCIAL]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_RAZON_SOCIAL]
GO



-- /////////////////////////////////////////////////////////////////
-- // ESTATUS_RAZON_SOCIAL
-- /////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ESTATUS_RAZON_SOCIAL] (
	[K_ESTATUS_RAZON_SOCIAL]		[INT]			NOT NULL,
	[D_ESTATUS_RAZON_SOCIAL]		[VARCHAR](100)	NOT NULL,
	[C_ESTATUS_RAZON_SOCIAL]		[VARCHAR](500)	NOT NULL,
	[S_ESTATUS_RAZON_SOCIAL]		[VARCHAR](10)	NOT NULL,
	[O_ESTATUS_RAZON_SOCIAL]		[INT]			NOT NULL,
	[L_ESTATUS_RAZON_SOCIAL]		[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[ESTATUS_RAZON_SOCIAL]
	ADD CONSTRAINT [PK_ESTATUS_RAZON_SOCIAL]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_RAZON_SOCIAL])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_RAZON_SOCIAL_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_RAZON_SOCIAL] ( [D_ESTATUS_RAZON_SOCIAL] )
GO



-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[ESTATUS_RAZON_SOCIAL] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[ESTATUS_RAZON_SOCIAL] ADD 
	CONSTRAINT [FK_ESTATUS_RAZON_SOCIAL_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_ESTATUS_RAZON_SOCIAL_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_ESTATUS_RAZON_SOCIAL_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --> [PG_CI_ESTATUS_RAZON_SOCIAL]
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_RAZON_SOCIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_RAZON_SOCIAL]
GO


CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_RAZON_SOCIAL]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- =============================== CONTROL
	@PP_K_ESTATUS_RAZON_SOCIAL			INT,
	@PP_D_ESTATUS_RAZON_SOCIAL			VARCHAR (100),	
	@PP_C_ESTATUS_RAZON_SOCIAL			VARCHAR (100),
	@PP_S_ESTATUS_RAZON_SOCIAL			VARCHAR (10),
	@PP_O_ESTATUS_RAZON_SOCIAL			INT,
	@PP_L_ESTATUS_RAZON_SOCIAL			INT
AS

	INSERT INTO ESTATUS_RAZON_SOCIAL
		(	
			[K_ESTATUS_RAZON_SOCIAL],	[D_ESTATUS_RAZON_SOCIAL],
			[C_ESTATUS_RAZON_SOCIAL],	[S_ESTATUS_RAZON_SOCIAL],
			[O_ESTATUS_RAZON_SOCIAL],	[L_ESTATUS_RAZON_SOCIAL],
			-- =============================== 
			[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )	
	VALUES	
		(	 
			@PP_K_ESTATUS_RAZON_SOCIAL,	@PP_D_ESTATUS_RAZON_SOCIAL, 
			@PP_C_ESTATUS_RAZON_SOCIAL,	@PP_S_ESTATUS_RAZON_SOCIAL,
			@PP_O_ESTATUS_RAZON_SOCIAL,	@PP_L_ESTATUS_RAZON_SOCIAL,
			-- =============================== 
			@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL )

	-- ////////////////////////////////////////////////
GO



-- /////////////////////////////////////////////////////////////////////
-- // CARGA INICIAL ESTATUS_RAZON_SOCIAL
-- /////////////////////////////////////////////////////////////////////


EXECUTE [dbo].[PG_CI_ESTATUS_RAZON_SOCIAL] 0,0,0, 0, 'INACTIVA', '',		'INAC', 0, 1
EXECUTE [dbo].[PG_CI_ESTATUS_RAZON_SOCIAL] 0,0,0, 1, 'ACTIVA', '',			'ACTV', 0, 1
EXECUTE [dbo].[PG_CI_ESTATUS_RAZON_SOCIAL] 0,0,0, 2, 'SUSPENDIDA', '',		'SUSP', 0, 1
EXECUTE [dbo].[PG_CI_ESTATUS_RAZON_SOCIAL] 0,0,0, 3, 'CERRADA', '',			'CERR', 0, 1
GO







-- //////////////////////////////////////////////////////////////
-- // RAZON_SOCIAL
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[RAZON_SOCIAL] (
	[K_RAZON_SOCIAL]			[INT]			NOT NULL,
	[D_RAZON_SOCIAL]			[VARCHAR](100)	NOT NULL,
	[S_RAZON_SOCIAL]			[VARCHAR](10)	NOT NULL,
	[O_RAZON_SOCIAL]			[INT]			NOT NULL,
	[K_ESTATUS_RAZON_SOCIAL]	[INT]			NOT NULL,
	[K_TIPO_RAZON_SOCIAL]		[INT]			NOT NULL,
	-- ============================
	[RAZON_SOCIAL]			[VARCHAR](100)	NOT NULL, 
	[RFC_RAZON_SOCIAL]		[VARCHAR](100)	NOT NULL,
	[CURP]					[VARCHAR](100)	NOT NULL DEFAULT '',
	[CORREO]				[VARCHAR](100)	NOT NULL DEFAULT '',
	[TELEFONO]				[VARCHAR](100)	NOT NULL DEFAULT '',
	-- ============================
	[CALLE]					[VARCHAR](255)	NOT NULL,
	[NUMERO_EXTERIOR]		[VARCHAR](10)	NOT NULL DEFAULT '',
	[NUMERO_INTERIOR]		[VARCHAR](10)	NOT NULL DEFAULT '',
	[COLONIA]				[VARCHAR](100)	NOT NULL,
	[POBLACION]				[VARCHAR](100)	NOT NULL,
	[CP]					[VARCHAR](10)	NOT NULL DEFAULT '',
	[MUNICIPIO]				[VARCHAR](100)	NOT NULL,
	[K_REGION]				[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[RAZON_SOCIAL]
	ADD CONSTRAINT [PK_RAZON_SOCIAL]
		PRIMARY KEY CLUSTERED ([K_RAZON_SOCIAL])
GO


ALTER TABLE [dbo].[RAZON_SOCIAL] ADD 
	CONSTRAINT [FK_RAZON_SOCIAL_01]  
		FOREIGN KEY ([K_ESTATUS_RAZON_SOCIAL]) 
		REFERENCES [dbo].[ESTATUS_RAZON_SOCIAL] ([K_ESTATUS_RAZON_SOCIAL])
GO

/*
ALTER TABLE [dbo].[RAZON_SOCIAL] ADD 
	CONSTRAINT [FK_RAZON_SOCIAL_02]  
		FOREIGN KEY ([K_ESTATUS_RAZON_SOCIAL]) 
		REFERENCES [dbo].[ESTATUS_RAZON_SOCIAL] ([K_ESTATUS_RAZON_SOCIAL])
GO
*/

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[RAZON_SOCIAL] 
	ADD		[K_USUARIO_ALTA]				[INT]		NOT NULL,
			[F_ALTA]						[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]				[INT]		NOT NULL,
			[F_CAMBIO]						[DATETIME]	NOT NULL,
			[L_BORRADO]						[INT]		NOT NULL,
			[K_USUARIO_BAJA]				[INT]		NULL,
			[F_BAJA]						[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[RAZON_SOCIAL] ADD 
	CONSTRAINT [FK_RAZON_SOCIAL_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_RAZON_SOCIAL_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_RAZON_SOCIAL_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
