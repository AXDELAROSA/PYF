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



-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTADO_SERVIDOR]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTADO_SERVIDOR]
GO



-- /////////////////////////////////////////////////////////////////
-- // ESTADO_SERVIDOR
-- /////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ESTADO_SERVIDOR] (
	[K_ESTADO_SERVIDOR]		[INT]			NOT NULL,
	[D_ESTADO_SERVIDOR]		[VARCHAR](100)	NOT NULL,
	[C_ESTADO_SERVIDOR]		[VARCHAR](500)	NOT NULL,
	[S_ESTADO_SERVIDOR]		[VARCHAR](10)	NOT NULL,
	[O_ESTADO_SERVIDOR]		[INT]			NOT NULL,
	[L_ESTADO_SERVIDOR]		[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[ESTADO_SERVIDOR]
	ADD CONSTRAINT [PK_ESTADO_SERVIDOR]
		PRIMARY KEY CLUSTERED ([K_ESTADO_SERVIDOR])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTADO_SERVIDOR_01_DESCRIPCION] 
	   ON [dbo].[ESTADO_SERVIDOR] ( [D_ESTADO_SERVIDOR] )
GO



-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[ESTADO_SERVIDOR] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[ESTADO_SERVIDOR] ADD 
	CONSTRAINT [FK_ESTADO_SERVIDOR_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_ESTADO_SERVIDOR_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_ESTADO_SERVIDOR_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --> [PG_CI_ESTADO_SERVIDOR]
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTADO_SERVIDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTADO_SERVIDOR]
GO


CREATE PROCEDURE [dbo].[PG_CI_ESTADO_SERVIDOR]
	@PP_K_ESTADO_SERVIDOR	INT,
	@PP_D_ESTADO_SERVIDOR	VARCHAR (100),	
	@PP_C_ESTADO_SERVIDOR	VARCHAR (100),
	@PP_S_ESTADO_SERVIDOR	VARCHAR (10),
	@PP_O_ESTADO_SERVIDOR	INT,
	@PP_L_ESTADO_SERVIDOR	INT,
	@PP_K_USUARIO_ALTA		INT,
	@PP_F_ALTA				DATETIME,
	@PP_K_USUARIO_CAMBIO	INT,
	@PP_F_CAMBIO			DATETIME,
	@PP_L_BORRADO			INT

AS

	INSERT INTO ESTADO_SERVIDOR
		(	
			[K_ESTADO_SERVIDOR],	[D_ESTADO_SERVIDOR],
			[C_ESTADO_SERVIDOR],	[S_ESTADO_SERVIDOR],
			[O_ESTADO_SERVIDOR],	[L_ESTADO_SERVIDOR],
			[K_USUARIO_ALTA],		[F_ALTA],
			[K_USUARIO_CAMBIO],		[F_CAMBIO],
			[L_BORRADO]		)	
	VALUES	
		(	 
			@PP_K_ESTADO_SERVIDOR,	@PP_D_ESTADO_SERVIDOR, 
			@PP_C_ESTADO_SERVIDOR,	@PP_S_ESTADO_SERVIDOR,
			@PP_O_ESTADO_SERVIDOR,	@PP_L_ESTADO_SERVIDOR,
			@PP_K_USUARIO_ALTA,		@PP_F_ALTA,
			@PP_K_USUARIO_CAMBIO,	@PP_F_CAMBIO,
			@PP_L_BORRADO	)

	-- ////////////////////////////////////////////////
GO



-- /////////////////////////////////////////////////////////////////////
-- // CARGA INICIAL ESTADO_SERVIDOR
-- /////////////////////////////////////////////////////////////////////


EXECUTE [dbo].[PG_CI_ESTADO_SERVIDOR] 0, 'NO EXISTE', 'NO EXISTE','N/E', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_ESTADO_SERVIDOR] 1, 'OPERACIONAL', 'OPERACIONAL','OPE', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_ESTADO_SERVIDOR] 2, 'LENTO', 'LENTO','LEN', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_ESTADO_SERVIDOR] 3, 'FRAGIL', 'FRAGIL','FRA', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_ESTADO_SERVIDOR] 4, 'INACTIVO', 'INACTIVO','INA', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
