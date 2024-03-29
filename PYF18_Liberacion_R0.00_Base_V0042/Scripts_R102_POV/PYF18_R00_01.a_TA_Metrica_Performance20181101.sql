-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[METRICA]') AND type in (N'U'))
	DROP TABLE [dbo].[METRICA]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIPO_METRICA]') AND type in (N'U'))
	DROP TABLE [dbo].[TIPO_METRICA]
GO




-- ///////////////////////////////////////////////////////////////
-- //					TIPO_METRICA
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[TIPO_METRICA] (
	[K_TIPO_METRICA]				[INT] NOT NULL,
	[D_TIPO_METRICA]				[VARCHAR] (100) NOT NULL,
	[S_TIPO_METRICA]				[VARCHAR] (10) NOT NULL,
	[O_TIPO_METRICA]				[INT] NOT NULL,
	[C_TIPO_METRICA]				[VARCHAR] (255) NOT NULL,
	[L_TIPO_METRICA]				[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[TIPO_METRICA]
	ADD CONSTRAINT [PK_TIPO_METRICA]
		PRIMARY KEY CLUSTERED ([K_TIPO_METRICA])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_TIPO_METRICA_01_DESCRIPCION] 
	   ON [dbo].[TIPO_METRICA] ( [D_TIPO_METRICA] )
GO


ALTER TABLE [dbo].[TIPO_METRICA] ADD 
	CONSTRAINT [FK_TIPO_METRICA_01] 
		FOREIGN KEY ( [L_TIPO_METRICA] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIPO_METRICA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIPO_METRICA]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIPO_METRICA]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	-- ========================================
	@PP_K_TIPO_METRICA		INT,
	@PP_D_TIPO_METRICA		VARCHAR(100),
	@PP_S_TIPO_METRICA		VARCHAR(10),
	@PP_O_TIPO_METRICA		INT,
	@PP_C_TIPO_METRICA		VARCHAR(255),
	@PP_L_TIPO_METRICA		INT
AS
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_TIPO_METRICA
							FROM	TIPO_METRICA
							WHERE	K_TIPO_METRICA=@PP_K_TIPO_METRICA

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO TIPO_METRICA
		(	K_TIPO_METRICA,			D_TIPO_METRICA, 
			S_TIPO_METRICA,			O_TIPO_METRICA,
			C_TIPO_METRICA,
			L_TIPO_METRICA			)		
		VALUES	
		(	@PP_K_TIPO_METRICA,		@PP_D_TIPO_METRICA,	
			@PP_S_TIPO_METRICA,		@PP_O_TIPO_METRICA,
			@PP_C_TIPO_METRICA,
			@PP_L_TIPO_METRICA		)
	ELSE
		UPDATE	TIPO_METRICA
		SET		D_TIPO_METRICA	= @PP_D_TIPO_METRICA,	
				S_TIPO_METRICA	= @PP_S_TIPO_METRICA,			
				O_TIPO_METRICA	= @PP_O_TIPO_METRICA,
				C_TIPO_METRICA	= @PP_C_TIPO_METRICA,
				L_TIPO_METRICA	= @PP_L_TIPO_METRICA	
		WHERE	K_TIPO_METRICA=@PP_K_TIPO_METRICA

	-- =========================================================
GO




EXECUTE [dbo].[PG_CI_TIPO_METRICA] 0, 0,   1, 'VENTA',		'VTA', 10, '', 1
EXECUTE [dbo].[PG_CI_TIPO_METRICA] 0, 0,   2, 'INVENTARIO',	'INV', 20, '', 1
GO





-- ///////////////////////////////////////////////////////////////
-- //					METRICA
-- ///////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[METRICA] (
	[K_METRICA]			[INT] NOT NULL,
	[D_METRICA]			[VARCHAR] (100) NOT NULL,
	[S_METRICA]			[VARCHAR] (10) NOT NULL,
	[O_METRICA]			[INT] NOT NULL,
	[C_METRICA]			[VARCHAR] (255) NOT NULL,
	[L_METRICA]			[INT] NOT NULL,
	[K_TIPO_METRICA]			[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[METRICA]
	ADD CONSTRAINT [PK_METRICA]
		PRIMARY KEY CLUSTERED ([K_METRICA])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_METRICA_01_DESCRIPCION] 
	   ON [dbo].[METRICA] ( [D_METRICA] )
GO


ALTER TABLE [dbo].[METRICA] ADD 
	CONSTRAINT [FK_METRICA_01] 
		FOREIGN KEY ( [L_METRICA] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] ),
	CONSTRAINT [FK_METRICA_02] 
		FOREIGN KEY ( [K_TIPO_METRICA] ) 
		REFERENCES [dbo].[TIPO_METRICA] ( [K_TIPO_METRICA] )
GO



-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_METRICA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_METRICA]
GO


CREATE PROCEDURE [dbo].[PG_CI_METRICA]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	-- ========================================
	@PP_K_METRICA			INT,
	@PP_D_METRICA			VARCHAR(100),
	@PP_S_METRICA			VARCHAR(10),
	@PP_O_METRICA			INT,
	@PP_C_METRICA			VARCHAR(255),
	@PP_L_METRICA			INT,
	@PP_K_TIPO_METRICA			INT		
AS
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_METRICA
							FROM	METRICA
							WHERE	K_METRICA=@PP_K_METRICA

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO METRICA
			(	K_METRICA,				D_METRICA, 
				S_METRICA,				O_METRICA,
				C_METRICA,
				L_METRICA,
				K_TIPO_METRICA				)
		VALUES	
			(	@PP_K_METRICA,			@PP_D_METRICA,	
				@PP_S_METRICA,			@PP_O_METRICA,
				@PP_C_METRICA,
				@PP_L_METRICA,
				@PP_K_TIPO_METRICA			)
	ELSE
		UPDATE	METRICA
		SET		D_METRICA	= @PP_D_METRICA,	
				S_METRICA	= @PP_S_METRICA,			
				O_METRICA	= @PP_O_METRICA,
				C_METRICA	= @PP_C_METRICA,
				L_METRICA	= @PP_L_METRICA,
				K_TIPO_METRICA	= @PP_K_TIPO_METRICA	
		WHERE	K_METRICA=@PP_K_METRICA

	-- =========================================================
GO

-- //////////////////////////////////////////////////////////////


-- ===============================================
SET NOCOUNT ON
-- =============================================== 


EXECUTE [dbo].[PG_CI_METRICA] 0, 0,  1, 'VENTA (KG)',				'V.Tot', 1, '', 1,   1
EXECUTE [dbo].[PG_CI_METRICA] 0, 0,  2, 'VENTA CREDITO (KG)',		'V.Cre', 2, '', 1,   1
EXECUTE [dbo].[PG_CI_METRICA] 0, 0,  3, 'VENTA CONTADO (KG)',		'V.Con', 2, '', 1,   1
EXECUTE [dbo].[PG_CI_METRICA] 0, 0,  4, 'INVENTARIO (KG)',			'INV',   3, '', 1,   2
GO

-- ===============================================
SET NOCOUNT OFF
-- =============================================== 








-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////
