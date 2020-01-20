-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			
-- // OPERACION:		LIBERACION / TABLA+CARGA 
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- /////////////////////////////////////////////////////////////////
-- // SISTEMA
-- /////////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SISTEMA]') AND type in (N'U'))
	DROP TABLE [dbo].[SISTEMA] 
GO





-- /////////////////////////////////////////////////////////////
-- // SISTEMA   	              
-- /////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[SISTEMA] (
	[K_SISTEMA]		[INT]			NOT NULL,
	[D_SISTEMA]		[VARCHAR](100)	NOT NULL,
	[C_SISTEMA]		[VARCHAR](500)	NOT NULL,
	[S_SISTEMA]		[VARCHAR](10)	NOT NULL,
	[O_SISTEMA]		[INT]			NOT NULL,
	[L_SISTEMA]		[INT]			NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[SISTEMA]
	ADD CONSTRAINT [PK_SISTEMA]
		PRIMARY KEY CLUSTERED ([K_SISTEMA])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_SISTEMA_01_DESCRIPCION] 
	   ON [dbo].[SISTEMA] ( [D_SISTEMA] )
GO



-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[SISTEMA] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --> [PG_CI_SISTEMA]
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_SISTEMA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_SISTEMA]
GO


CREATE PROCEDURE [dbo].[PG_CI_SISTEMA]
	@PP_K_SISTEMA			INT,
	@PP_D_SISTEMA			VARCHAR (100),	
	@PP_C_SISTEMA			VARCHAR (500),
	@PP_S_SISTEMA			VARCHAR (10),
	@PP_O_SISTEMA			INT,
	@PP_L_SISTEMA			INT,
	@PP_K_USUARIO_ALTA		INT,
	@PP_F_ALTA				DATETIME,
	@PP_K_USUARIO_CAMBIO	INT,
	@PP_F_CAMBIO			DATETIME,
	@PP_L_BORRADO			INT

AS

	INSERT INTO SISTEMA
		(	
			[K_SISTEMA],		[D_SISTEMA],
			[C_SISTEMA],		[S_SISTEMA],
			[O_SISTEMA],		[L_SISTEMA],
			[K_USUARIO_ALTA],	[F_ALTA],
			[K_USUARIO_CAMBIO],	[F_CAMBIO],
			[L_BORRADO]		)	
	VALUES	
		(	 
			@PP_K_SISTEMA,			@PP_D_SISTEMA, 
			@PP_C_SISTEMA,			@PP_S_SISTEMA,
			@PP_O_SISTEMA,			@PP_L_SISTEMA,
			@PP_K_USUARIO_ALTA,		@PP_F_ALTA,
			@PP_K_USUARIO_CAMBIO,	@PP_F_CAMBIO,
			@PP_L_BORRADO	)

	-- ////////////////////////////////////////////////
GO



-- /////////////////////////////////////////////////////////////////////
-- // CARGA INICIAL SISTEMA
-- /////////////////////////////////////////////////////////////////////


EXECUTE [dbo].[PG_CI_SISTEMA]  0, 'DEFAULT','DEFAULT','DEFAULT',0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_SISTEMA] 10, 'ICS', 'ICS','ICS', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_SISTEMA] 20, 'ERM', 'ERM','ERM', 0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_SISTEMA]  1001, 'prema','Pprema','prema',0, 1, 0, '2018-04-02', 0, '2018-04-02', 0
EXECUTE [dbo].[PG_CI_SISTEMA]  40, 'PPT0','PRESUPUESTOS','Presupuestos',0, 1, 0, '2018-08-06', 0, '2018-08-06', 0






-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
