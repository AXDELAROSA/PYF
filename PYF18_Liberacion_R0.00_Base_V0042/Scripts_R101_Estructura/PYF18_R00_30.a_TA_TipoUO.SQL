-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			TIPO UNIDAD OPERATIVA
-- // OPERACION:		LIBERACION / TABLA+CARGA 
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIPO_UO]') AND type in (N'U'))
	DROP TABLE [dbo].[TIPO_UO]
GO



-- /////////////////////////////////////////////////////////////////
-- // TIPO_UO
-- /////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[TIPO_UO] (
	[K_TIPO_UO]		[INT]			NOT NULL,
	[D_TIPO_UO]		[VARCHAR](100)	NOT NULL,
	[C_TIPO_UO]		[VARCHAR](500)	NOT NULL,
	[S_TIPO_UO]		[VARCHAR](10)	NOT NULL,
	[O_TIPO_UO]		[INT]			NOT NULL,
	[L_TIPO_UO]		[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[TIPO_UO]
	ADD CONSTRAINT [PK_TIPO_UO]
		PRIMARY KEY CLUSTERED ([K_TIPO_UO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TIPO_UO_01_DESCRIPCION] 
	   ON [dbo].[TIPO_UO] ( [D_TIPO_UO] )
GO



-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[TIPO_UO] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[TIPO_UO] ADD 
	CONSTRAINT [FK_TIPO_UO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_TIPO_UO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_TIPO_UO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --> [PG_CI_TIPO_UO]
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIPO_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIPO_UO]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIPO_UO]
	@PP_K_TIPO_UO			INT,
	@PP_D_TIPO_UO			VARCHAR (100),	
	@PP_C_TIPO_UO			VARCHAR (100),
	@PP_S_TIPO_UO			VARCHAR (10),
	@PP_O_TIPO_UO			INT,
	@PP_L_TIPO_UO			INT,
	@PP_K_USUARIO_ALTA		INT,
	@PP_F_ALTA				DATETIME,
	@PP_K_USUARIO_CAMBIO	INT,
	@PP_F_CAMBIO			DATETIME,
	@PP_L_BORRADO			INT

AS

	INSERT INTO TIPO_UO
		(		
			[K_TIPO_UO],		[D_TIPO_UO],
			[C_TIPO_UO],		[S_TIPO_UO],
			[O_TIPO_UO],		[L_TIPO_UO],
			[K_USUARIO_ALTA],	[F_ALTA],
			[K_USUARIO_CAMBIO],	[F_CAMBIO],
			[L_BORRADO]		)	
	VALUES	
		(	 
			@PP_K_TIPO_UO,			@PP_D_TIPO_UO, 
			@PP_C_TIPO_UO,			@PP_S_TIPO_UO,
			@PP_O_TIPO_UO,			@PP_L_TIPO_UO,
			@PP_K_USUARIO_ALTA,		@PP_F_ALTA,
			@PP_K_USUARIO_CAMBIO,	@PP_F_CAMBIO,
			@PP_L_BORRADO	)

	-- ////////////////////////////////////////////////
GO



-- /////////////////////////////////////////////////////////////////////
-- // CARGA INICIAL TIPO_UO
-- /////////////////////////////////////////////////////////////////////


EXECUTE [dbo].[PG_CI_TIPO_UO]  0, '( PENDIENTE )', '( PENDIENTE )', 'N/A', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_TIPO_UO]  10, 'PLANTA', 'PLANTA', 'PTA', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_TIPO_UO]  20, 'TERMINAL', 'TERMINAL', 'TER', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_TIPO_UO]  30, 'TRANSPORTADORA', 'TRANSPORTADORA', 'TRA', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_TIPO_UO]  40, 'IMPORTADORA', 'IMPORTADORA', 'IMP', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0

EXECUTE [dbo].[PG_CI_TIPO_UO]  50, 'RAZON SOCIAL', 'RASON SOCIAL', 'RAS', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
