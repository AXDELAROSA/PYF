-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PRESUPUESTO GASTOS/PLANTA
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	24/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RUBRO_PRESUPUESTO]') AND type in (N'U'))
	DROP TABLE [dbo].[RUBRO_PRESUPUESTO]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NIVEL_RUBRO_PRESUPUESTO]') AND type in (N'U'))
	DROP TABLE [dbo].[NIVEL_RUBRO_PRESUPUESTO]
GO





-- ///////////////////////////////////////////////////////////////
-- //					NIVEL_RUBRO_PRESUPUESTO
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[NIVEL_RUBRO_PRESUPUESTO] (
	[K_NIVEL_RUBRO_PRESUPUESTO]	[INT] NOT NULL,
	[D_NIVEL_RUBRO_PRESUPUESTO]	[VARCHAR] (100) NOT NULL,
	[S_NIVEL_RUBRO_PRESUPUESTO]	[VARCHAR] (10) NOT NULL,
	[O_NIVEL_RUBRO_PRESUPUESTO]	[INT] NOT NULL,
	[C_NIVEL_RUBRO_PRESUPUESTO]	[VARCHAR] (255) NOT NULL,
	[L_NIVEL_RUBRO_PRESUPUESTO]	[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[NIVEL_RUBRO_PRESUPUESTO]
	ADD CONSTRAINT [PK_NIVEL_RUBRO_PRESUPUESTO]
		PRIMARY KEY CLUSTERED ([K_NIVEL_RUBRO_PRESUPUESTO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_NIVEL_RUBRO_PRESUPUESTO_01_DESCRIPCION] 
	   ON [dbo].[NIVEL_RUBRO_PRESUPUESTO] ( [D_NIVEL_RUBRO_PRESUPUESTO] )
GO


ALTER TABLE [dbo].[NIVEL_RUBRO_PRESUPUESTO] ADD 
	CONSTRAINT [FK_NIVEL_RUBRO_PRESUPUESTO_01] 
		FOREIGN KEY ( [L_NIVEL_RUBRO_PRESUPUESTO] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_NIVEL_RUBRO_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_NIVEL_RUBRO_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_CI_NIVEL_RUBRO_PRESUPUESTO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	-- ========================================
	@PP_K_NIVEL_RUBRO_PRESUPUESTO		INT,
	@PP_D_NIVEL_RUBRO_PRESUPUESTO		VARCHAR(100),
	@PP_S_NIVEL_RUBRO_PRESUPUESTO		VARCHAR(10),
	@PP_O_NIVEL_RUBRO_PRESUPUESTO		INT,
	@PP_C_NIVEL_RUBRO_PRESUPUESTO		VARCHAR(255),
	@PP_L_NIVEL_RUBRO_PRESUPUESTO		INT
AS
	
	INSERT INTO NIVEL_RUBRO_PRESUPUESTO
		(	K_NIVEL_RUBRO_PRESUPUESTO,			D_NIVEL_RUBRO_PRESUPUESTO, 
			S_NIVEL_RUBRO_PRESUPUESTO,			O_NIVEL_RUBRO_PRESUPUESTO,
			C_NIVEL_RUBRO_PRESUPUESTO,
			L_NIVEL_RUBRO_PRESUPUESTO			)		
	VALUES	
		(	@PP_K_NIVEL_RUBRO_PRESUPUESTO,		@PP_D_NIVEL_RUBRO_PRESUPUESTO,	
			@PP_S_NIVEL_RUBRO_PRESUPUESTO,		@PP_O_NIVEL_RUBRO_PRESUPUESTO,
			@PP_C_NIVEL_RUBRO_PRESUPUESTO,
			@PP_L_NIVEL_RUBRO_PRESUPUESTO		)

	-- =========================================================
GO



-- ///////////////////////////////////////////////////////////////
-- //				NIVEL_RUBRO_PRESUPUESTO
-- ///////////////////////////////////////////////////////////////
-- SELECT * FROM NIVEL_RUBRO_PRESUPUESTO

EXECUTE [dbo].[PG_CI_NIVEL_RUBRO_PRESUPUESTO] 0, 0, 0, 'NIVEL 0', 'ETIQUETAS // SIN DATOS', 10,				'N0', 1
EXECUTE [dbo].[PG_CI_NIVEL_RUBRO_PRESUPUESTO] 0, 0, 1, 'NIVEL 1', 'GRAN TOTAL (CALCULADO)', 10,				'N1', 1
EXECUTE [dbo].[PG_CI_NIVEL_RUBRO_PRESUPUESTO] 0, 0, 2, 'NIVEL 2', 'TOTAL CATEGORIA/RUBRO (CALCULADO)', 10,	'N2', 1
EXECUTE [dbo].[PG_CI_NIVEL_RUBRO_PRESUPUESTO] 0, 0, 3, 'NIVEL 3', 'NIVEL 3', 10,							'N3', 1
EXECUTE [dbo].[PG_CI_NIVEL_RUBRO_PRESUPUESTO] 0, 0, 4, 'NIVEL 4', 'SUBTOTAL RUBRO (CALCULADO)', 10,			'N4', 1
EXECUTE [dbo].[PG_CI_NIVEL_RUBRO_PRESUPUESTO] 0, 0, 5, 'NIVEL 5', 'RUBRO PRESUPUESTO (CAPTURA)', 10,		'N5', 1
GO




-- ///////////////////////////////////////////////////////////////
-- // RUBRO_PRESUPUESTO
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[RUBRO_PRESUPUESTO] (
	[K_RUBRO_PRESUPUESTO]	[INT] NOT NULL,
	[D_RUBRO_PRESUPUESTO]	[VARCHAR] (100) NOT NULL,
	[S_RUBRO_PRESUPUESTO]	[VARCHAR] (10) NOT NULL,
	[O_RUBRO_PRESUPUESTO]	[INT] NOT NULL,
	[C_RUBRO_PRESUPUESTO]	[VARCHAR] (255) NOT NULL,
	[L_RUBRO_PRESUPUESTO]	[INT] NOT NULL,
	-- =====================================
	[K_NIVEL_RUBRO_PRESUPUESTO]	[INT] NOT NULL,
	[K_RUBRO_PADRE]				[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[RUBRO_PRESUPUESTO]
	ADD CONSTRAINT [PK_RUBRO_PRESUPUESTO]
		PRIMARY KEY CLUSTERED ([K_RUBRO_PRESUPUESTO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_RUBRO_PRESUPUESTO_01_DESCRIPCION] 
	   ON [dbo].[RUBRO_PRESUPUESTO] ( [D_RUBRO_PRESUPUESTO] )
GO

-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[RUBRO_PRESUPUESTO] ADD 
	CONSTRAINT [FK_RUBRO_PRESUPUESTO_01] 
		FOREIGN KEY ( [K_RUBRO_PADRE] ) 
		REFERENCES [dbo].[RUBRO_PRESUPUESTO] ( [K_RUBRO_PRESUPUESTO] )
GO



ALTER TABLE [dbo].[RUBRO_PRESUPUESTO] ADD 
	CONSTRAINT [FK_RUBRO_PRESUPUESTO_02] 
		FOREIGN KEY ( [L_RUBRO_PRESUPUESTO] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] ),
	CONSTRAINT [FK_RUBRO_PRESUPUESTO_03] 
		FOREIGN KEY ( [K_NIVEL_RUBRO_PRESUPUESTO] ) 
		REFERENCES [dbo].[NIVEL_RUBRO_PRESUPUESTO] ( [K_NIVEL_RUBRO_PRESUPUESTO] )
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////

