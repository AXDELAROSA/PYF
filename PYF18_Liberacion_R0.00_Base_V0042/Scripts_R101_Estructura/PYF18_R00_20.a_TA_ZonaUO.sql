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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZONA_UO]') AND type in (N'U'))
	DROP TABLE [dbo].[ZONA_UO]
GO



-- /////////////////////////////////////////////////////////////////
-- // ZONA_UO
-- /////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[ZONA_UO] (
	[K_ZONA_UO]		[INT]			NOT NULL,
	[D_ZONA_UO]		[VARCHAR](100)	NOT NULL,
	[C_ZONA_UO]		[VARCHAR](500)	NOT NULL,
	[S_ZONA_UO]		[VARCHAR](10)	NOT NULL,
	[O_ZONA_UO]		[INT]			NOT NULL,
	[L_ZONA_UO]		[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[ZONA_UO]
	ADD CONSTRAINT [PK_ZONA_UO]
		PRIMARY KEY CLUSTERED ([K_ZONA_UO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ZONA_UO_01_DESCRIPCION] 
	   ON [dbo].[ZONA_UO] ( [D_ZONA_UO] )
GO



-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[ZONA_UO] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[ZONA_UO] ADD 
	CONSTRAINT [FK_ZONA_UO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_ZONA_UO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_ZONA_UO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --> [PG_CI_ZONA_UO]
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ZONA_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ZONA_UO]
GO


CREATE PROCEDURE [dbo].[PG_CI_ZONA_UO]
	@PP_K_ZONA_UO			INT,
	@PP_D_ZONA_UO			VARCHAR (100),	
	@PP_C_ZONA_UO			VARCHAR (100),
	@PP_S_ZONA_UO			VARCHAR (10),
	@PP_O_ZONA_UO			INT,
	@PP_L_ZONA_UO			INT,
	@PP_K_USUARIO_ALTA		INT,
	@PP_F_ALTA				DATETIME,
	@PP_K_USUARIO_CAMBIO	INT,
	@PP_F_CAMBIO			DATETIME,
	@PP_L_BORRADO			INT

AS

	INSERT INTO ZONA_UO
		(	
			[K_ZONA_UO],		[D_ZONA_UO],
			[C_ZONA_UO],		[S_ZONA_UO],
			[O_ZONA_UO],		[L_ZONA_UO],
			[K_USUARIO_ALTA],	[F_ALTA],
			[K_USUARIO_CAMBIO],	[F_CAMBIO],
			[L_BORRADO]		)	
	VALUES	
		(	 
			@PP_K_ZONA_UO,			@PP_D_ZONA_UO, 
			@PP_C_ZONA_UO,			@PP_S_ZONA_UO,
			@PP_O_ZONA_UO,			@PP_L_ZONA_UO,
			@PP_K_USUARIO_ALTA,		@PP_F_ALTA,
			@PP_K_USUARIO_CAMBIO,	@PP_F_CAMBIO,
			@PP_L_BORRADO	)

	-- ////////////////////////////////////////////////
GO



-- /////////////////////////////////////////////////////////////////////
-- // CARGA INICIAL ZONA_UO
-- /////////////////////////////////////////////////////////////////////


EXECUTE [dbo].[PG_CI_ZONA_UO]  0, '( PENDIENTE )', '( PENDIENTE )', 'N/A', 999, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_ZONA_UO]  10, 'BAJA CALIFORNIA', 'BAJA CALIFORNIA', 'BJA', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_ZONA_UO]  20, 'CENTRO', 'CENTRO', 'CEN', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_ZONA_UO]  30, 'CHIHUAHUA', 'CHIHUAHUA', 'CHI', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_ZONA_UO]  40, 'JALISCO', 'JALISCO', 'JAL', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_ZONA_UO]  50, 'SONORA', 'SONORA', 'SON', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_ZONA_UO]  60, 'SURESTE', 'SURESTE', 'SUR', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_ZONA_UO]  70, 'CDMX', 'CDMX', 'CDMX', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
