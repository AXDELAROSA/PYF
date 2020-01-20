-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DEFINICION_D0M4]') AND type in (N'U'))
	DROP TABLE [dbo].[DEFINICION_D0M4]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FORMATO_D0M4]') AND type in (N'U'))
	DROP TABLE [dbo].[FORMATO_D0M4]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NIVEL_DETALLE]') AND type in (N'U'))
	DROP TABLE [dbo].[NIVEL_DETALLE] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATO_D0M4]') AND type in (N'U'))
	DROP TABLE [dbo].[DATO_D0M4] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UNIDAD_DATO_D0M4]') AND type in (N'U'))
	DROP TABLE [dbo].[UNIDAD_DATO_D0M4] 
GO





-- ///////////////////////////////////////////////////////////////
-- //						UNIDAD_DATO_D0M4 						
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[UNIDAD_DATO_D0M4] (
	[K_UNIDAD_DATO_D0M4]		[INT] NOT NULL,
	[D_UNIDAD_DATO_D0M4]		[VARCHAR] (100) NOT NULL,
	[S_UNIDAD_DATO_D0M4]		[VARCHAR] (10) NOT NULL,
	[O_UNIDAD_DATO_D0M4]		[INT] NOT NULL,
	[C_UNIDAD_DATO_D0M4]		[VARCHAR] (255) NOT NULL,
	[L_UNIDAD_DATO_D0M4]		[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[UNIDAD_DATO_D0M4]
	ADD CONSTRAINT [PK_UNIDAD_DATO_D0M4]
		PRIMARY KEY CLUSTERED ([K_UNIDAD_DATO_D0M4])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_UNIDAD_DATO_D0M4_01_DESCRIPCION] 
	   ON [dbo].[UNIDAD_DATO_D0M4] ( [D_UNIDAD_DATO_D0M4] )
GO

-- //////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_UNIDAD_DATO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_UNIDAD_DATO_D0M4]
GO



CREATE PROCEDURE [dbo].[PG_CI_UNIDAD_DATO_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_UNIDAD_DATO_D0M4		INT,
	@PP_D_UNIDAD_DATO_D0M4		VARCHAR(100),
	@PP_S_UNIDAD_DATO_D0M4		VARCHAR(10),
	@PP_O_UNIDAD_DATO_D0M4		INT,
	@PP_C_UNIDAD_DATO_D0M4		VARCHAR(255),
	@PP_L_UNIDAD_DATO_D0M4		INT
AS

	INSERT INTO UNIDAD_DATO_D0M4
		(	K_UNIDAD_DATO_D0M4,			D_UNIDAD_DATO_D0M4, 
			S_UNIDAD_DATO_D0M4,			O_UNIDAD_DATO_D0M4,
			C_UNIDAD_DATO_D0M4,
			L_UNIDAD_DATO_D0M4				)	
	VALUES	
		(	@PP_K_UNIDAD_DATO_D0M4,		@PP_D_UNIDAD_DATO_D0M4,	
			@PP_S_UNIDAD_DATO_D0M4,		@PP_O_UNIDAD_DATO_D0M4,
			@PP_C_UNIDAD_DATO_D0M4,
			@PP_L_UNIDAD_DATO_D0M4			)

	-- ==============================================
GO




-- ///////////////////////////////////////////////////////////////
-- //						DATO_D0M4 						
-- ///////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[DATO_D0M4] (
	[K_DATO_D0M4]				[INT] NOT NULL,
	[D_DATO_D0M4]				[VARCHAR] (100) NOT NULL,
	[C_DATO_D0M4]				[VARCHAR] (255) NOT NULL,
	[S_DATO_D0M4]				[VARCHAR] (10) NOT NULL,
	[O_DATO_D0M4]				[INT] NOT NULL,  
	[K_UNIDAD_DATO_D0M4]		[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[DATO_D0M4]
	ADD CONSTRAINT [PK_DATO_D0M4]
		PRIMARY KEY CLUSTERED ([K_DATO_D0M4])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_DATO_D0M4_01_DESCRIPCION] 
	   ON [dbo].[DATO_D0M4] ( [D_DATO_D0M4] )
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[DATO_D0M4] ADD 
	CONSTRAINT [FK_DATO_D0M4_01] 
		FOREIGN KEY ([K_UNIDAD_DATO_D0M4]) 
		REFERENCES [dbo].[UNIDAD_DATO_D0M4] ([K_UNIDAD_DATO_D0M4])
GO


-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_DATO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_DATO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_CI_DATO_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_DATO_D0M4				INT,
	@PP_D_DATO_D0M4				VARCHAR(100),
	@PP_C_DATO_D0M4				VARCHAR(255),
	@PP_S_DATO_D0M4				VARCHAR(10),
	@PP_O_DATO_D0M4				INT,
	@PP_K_UNIDAD_DATO_D0M4		INT
AS

	INSERT INTO DATO_D0M4
		(	K_DATO_D0M4,			
			D_DATO_D0M4,			C_DATO_D0M4,
			S_DATO_D0M4,			O_DATO_D0M4,
			K_UNIDAD_DATO_D0M4		)	
	VALUES	
		(	@PP_K_DATO_D0M4,
			@PP_D_DATO_D0M4,		@PP_C_DATO_D0M4,
			@PP_S_DATO_D0M4,		@PP_O_DATO_D0M4,
			@PP_K_UNIDAD_DATO_D0M4	)

	-- ==============================================
GO


-- ///////////////////////////////////////////////////////////////
-- //						NIVEL_DETALLE 						
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[NIVEL_DETALLE] (
	[K_NIVEL_DETALLE]		[INT] NOT NULL,
	[D_NIVEL_DETALLE]		[VARCHAR] (100) NOT NULL,
	[S_NIVEL_DETALLE]		[VARCHAR] (10) NOT NULL,
	[O_NIVEL_DETALLE]		[INT] NOT NULL,
	[C_NIVEL_DETALLE]		[VARCHAR] (255) NOT NULL,
	[L_NIVEL_DETALLE]		[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[NIVEL_DETALLE]
	ADD CONSTRAINT [PK_NIVEL_DETALLE]
		PRIMARY KEY CLUSTERED ([K_NIVEL_DETALLE])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_NIVEL_DETALLE_01_DESCRIPCION] 
	   ON [dbo].[NIVEL_DETALLE] ( [D_NIVEL_DETALLE] )
GO

-- //////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_NIVEL_DETALLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_NIVEL_DETALLE]
GO



CREATE PROCEDURE [dbo].[PG_CI_NIVEL_DETALLE]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_NIVEL_DETALLE		INT,
	@PP_D_NIVEL_DETALLE		VARCHAR(100),
	@PP_S_NIVEL_DETALLE		VARCHAR(10),
	@PP_O_NIVEL_DETALLE		INT,
	@PP_C_NIVEL_DETALLE		VARCHAR(255),
	@PP_L_NIVEL_DETALLE		INT
AS

	INSERT INTO NIVEL_DETALLE
		(	K_NIVEL_DETALLE,			D_NIVEL_DETALLE, 
			S_NIVEL_DETALLE,			O_NIVEL_DETALLE,
			C_NIVEL_DETALLE,
			L_NIVEL_DETALLE				)	
	VALUES	
		(	@PP_K_NIVEL_DETALLE,		@PP_D_NIVEL_DETALLE,	
			@PP_S_NIVEL_DETALLE,		@PP_O_NIVEL_DETALLE,
			@PP_C_NIVEL_DETALLE,
			@PP_L_NIVEL_DETALLE			)

	-- ==============================================
GO





-- ///////////////////////////////////////////////////////////////
-- //						FORMATO_D0M4 						
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[FORMATO_D0M4] (
	[K_FORMATO_D0M4]		[INT] NOT NULL,
	[D_FORMATO_D0M4]		[VARCHAR] (100) NOT NULL,
	[S_FORMATO_D0M4]		[VARCHAR] (10) NOT NULL,
	[O_FORMATO_D0M4]		[INT] NOT NULL,
	[C_FORMATO_D0M4]		[VARCHAR] (255) NOT NULL,
	[L_FORMATO_D0M4]		[INT] NOT NULL,
	[K_NIVEL_DETALLE]		[INT] NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[FORMATO_D0M4]
	ADD CONSTRAINT [PK_FORMATO_D0M4]
		PRIMARY KEY CLUSTERED ([K_FORMATO_D0M4])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_FORMATO_D0M4_01_DESCRIPCION] 
	   ON [dbo].[FORMATO_D0M4] ( [D_FORMATO_D0M4] )
GO

-- //////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_FORMATO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_FORMATO_D0M4]
GO



CREATE PROCEDURE [dbo].[PG_CI_FORMATO_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_FORMATO_D0M4		INT,
	@PP_D_FORMATO_D0M4		VARCHAR(100),
	@PP_S_FORMATO_D0M4		VARCHAR(10),
	@PP_O_FORMATO_D0M4		INT,
	@PP_C_FORMATO_D0M4		VARCHAR(255),
	@PP_L_FORMATO_D0M4		INT,
	@PP_K_NIVEL_DETALLE			INT
AS

	INSERT INTO FORMATO_D0M4
		(	K_FORMATO_D0M4,			D_FORMATO_D0M4, 
			S_FORMATO_D0M4,			O_FORMATO_D0M4,
			C_FORMATO_D0M4,
			L_FORMATO_D0M4,
			[K_NIVEL_DETALLE]			)	
	VALUES	
		(	@PP_K_FORMATO_D0M4,		@PP_D_FORMATO_D0M4,	
			@PP_S_FORMATO_D0M4,		@PP_O_FORMATO_D0M4,
			@PP_C_FORMATO_D0M4,
			@PP_L_FORMATO_D0M4,
			@PP_K_NIVEL_DETALLE			)

	-- ==============================================
GO




-- ///////////////////////////////////////////////////////////////
-- //					DEFINICION_D0M4
-- ///////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[DEFINICION_D0M4] (
	[K_FORMATO_D0M4]			[INT] NOT NULL,
	[K_DATO_D0M4]				[INT] NOT NULL,
	[L_VISIBLE]					[INT] NOT NULL,  
	[L_CALCULADO]				[INT] NOT NULL,  
	[L_EDITABLE]				[INT] NOT NULL,  
	[L_BOLD]					[INT] NOT NULL,	
	[L_ITALICA]					[INT] NOT NULL,	
	[N_INDENTAR]				[INT] NOT NULL,	
	[K_ALIGN]					[INT] NOT NULL,
	[O_DEFINICION_D0M4]			[INT] NOT NULL,  
	[C_DEFINICION_D0M4]			[VARCHAR] (255) NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[DEFINICION_D0M4]
	ADD CONSTRAINT [PK_DEFINICION_D0M4]
		PRIMARY KEY CLUSTERED ( [K_FORMATO_D0M4], [K_DATO_D0M4] )
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[DEFINICION_D0M4] ADD 
	CONSTRAINT [FK_DEFINICION_D0M4_01] 
		FOREIGN KEY ([K_FORMATO_D0M4]) 
		REFERENCES [dbo].[FORMATO_D0M4] ([K_FORMATO_D0M4]),
	CONSTRAINT [FK_DEFINICION_D0M4_02] 
		FOREIGN KEY ([K_DATO_D0M4]) 
		REFERENCES [dbo].[DATO_D0M4] ([K_DATO_D0M4])
GO



-- //////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_DEFINICION_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_DEFINICION_D0M4]
GO



CREATE PROCEDURE [dbo].[PG_CI_DEFINICION_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_DATO_D0M4				INT,
	@PP_C_DEFINICION_D0M4		VARCHAR(255),
	@PP_L_VISIBLE				INT,
	@PP_L_CALCULADO				INT,
	@PP_L_EDITABLE				INT,
	@PP_L_BOLD					INT,
	@PP_L_ITALICA				INT,
	@PP_N_INDENTAR				INT,
	@PP_K_ALIGN					INT,
	@PP_O_DEFINICION_D0M4		INT,
	@PP_K_FORMATO_D0M4			INT
AS

	INSERT INTO DEFINICION_D0M4
		(	[K_DATO_D0M4], [C_DEFINICION_D0M4],	
			[L_VISIBLE], [L_CALCULADO], [L_EDITABLE],
			[L_BOLD], [L_ITALICA], [N_INDENTAR], [K_ALIGN],
			[O_DEFINICION_D0M4],
			[K_FORMATO_D0M4]						)	
	VALUES	
		(	@PP_K_DATO_D0M4, @PP_C_DEFINICION_D0M4,
			@PP_L_VISIBLE, @PP_L_CALCULADO, @PP_L_EDITABLE,
			@PP_L_BOLD, @PP_L_ITALICA, @PP_N_INDENTAR, @PP_K_ALIGN,
			@PP_O_DEFINICION_D0M4,	
			@PP_K_FORMATO_D0M4						)

	-- ==============================================
GO








-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
