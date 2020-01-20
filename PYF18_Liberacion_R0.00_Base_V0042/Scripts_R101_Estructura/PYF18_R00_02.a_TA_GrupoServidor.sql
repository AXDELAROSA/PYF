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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GRUPO_SERVIDOR]') AND type in (N'U'))
	DROP TABLE [dbo].[GRUPO_SERVIDOR]
GO



-- /////////////////////////////////////////////////////////////////
-- // GRUPO_SERVIDOR
-- /////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[GRUPO_SERVIDOR] (
	[K_GRUPO_SERVIDOR]	[INT]			NOT NULL,
	[D_GRUPO_SERVIDOR]	[VARCHAR](100)	NOT NULL,
	[C_GRUPO_SERVIDOR]	[VARCHAR](500)	NOT NULL,
	[S_GRUPO_SERVIDOR]	[VARCHAR](10)	NOT NULL,
	[O_GRUPO_SERVIDOR]	[INT]			NOT NULL,
	[L_GRUPO_SERVIDOR]	[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[GRUPO_SERVIDOR]
	ADD CONSTRAINT [PK_GRUPO_SERVIDOR]
		PRIMARY KEY CLUSTERED ([K_GRUPO_SERVIDOR])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_GRUPO_SERVIDOR_01_DESCRIPCION] 
	   ON [dbo].[GRUPO_SERVIDOR] ( [D_GRUPO_SERVIDOR] )
GO



-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[GRUPO_SERVIDOR] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[GRUPO_SERVIDOR] ADD 
	CONSTRAINT [FK_GRUPO_SERVIDOR_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_GRUPO_SERVIDOR_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_GRUPO_SERVIDOR_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --> [PG_CI_GRUPO_SERVIDOR]
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_GRUPO_SERVIDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_GRUPO_SERVIDOR]
GO


CREATE PROCEDURE [dbo].[PG_CI_GRUPO_SERVIDOR]
	@PP_K_GRUPO_SERVIDOR	INT,
	@PP_D_GRUPO_SERVIDOR	VARCHAR (100),	
	@PP_C_GRUPO_SERVIDOR	VARCHAR (100),
	@PP_S_GRUPO_SERVIDOR	VARCHAR (10),
	@PP_O_GRUPO_SERVIDOR	INT,
	@PP_L_GRUPO_SERVIDOR	INT,
	@PP_K_USUARIO_ALTA		INT,
	@PP_F_ALTA				DATETIME,
	@PP_K_USUARIO_CAMBIO	INT,
	@PP_F_CAMBIO			DATETIME,
	@PP_L_BORRADO			INT

AS

	INSERT INTO GRUPO_SERVIDOR
		(	
			[K_GRUPO_SERVIDOR],	[D_GRUPO_SERVIDOR],
			[C_GRUPO_SERVIDOR],	[S_GRUPO_SERVIDOR],
			[O_GRUPO_SERVIDOR],	[L_GRUPO_SERVIDOR],
			[K_USUARIO_ALTA],	[F_ALTA],
			[K_USUARIO_CAMBIO],	[F_CAMBIO],
			[L_BORRADO]		)	
	VALUES	
		(	 
			@PP_K_GRUPO_SERVIDOR,	@PP_D_GRUPO_SERVIDOR, 
			@PP_C_GRUPO_SERVIDOR,	@PP_S_GRUPO_SERVIDOR,
			@PP_O_GRUPO_SERVIDOR,	@PP_L_GRUPO_SERVIDOR,
			@PP_K_USUARIO_ALTA,		@PP_F_ALTA,
			@PP_K_USUARIO_CAMBIO,	@PP_F_CAMBIO,
			@PP_L_BORRADO	)

	-- ////////////////////////////////////////////////
GO



-- /////////////////////////////////////////////////////////////////////
-- // CARGA INICIAL GRUPO_SERVIDOR
-- /////////////////////////////////////////////////////////////////////


EXECUTE [dbo].[PG_CI_GRUPO_SERVIDOR]  0, '( PENDIENTE )', '( PENDIENTE )', 'N/A', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_GRUPO_SERVIDOR]  10, 'BAJA CALIFORNIA', 'BAJA CALIFORNIA', 'BJA', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_GRUPO_SERVIDOR]  20, 'CENTRO', 'CENTRO', 'CEN', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_GRUPO_SERVIDOR]  30, 'CHIHUAHUA', 'CHIHUAHUA', 'CHI', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_GRUPO_SERVIDOR]  40, 'JALISCO', 'JALISCO', 'JAL', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_GRUPO_SERVIDOR]  50, 'SONORA', 'SONORA', 'SON', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_GRUPO_SERVIDOR]  60, 'SURESTE', 'SURESTE', 'SUR', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_GRUPO_SERVIDOR]  70, 'CDMX', 'CDMX', 'CDMX', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0





-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
