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





-- ///////////////////////////////////////////////////////////////
-- //						MONEDA								//
-- ///////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MONEDA]') AND type in (N'U'))
	DROP TABLE [dbo].[MONEDA]
GO



CREATE TABLE [dbo].[MONEDA] (
	[K_MONEDA]	[INT] NOT NULL,
	[D_MONEDA]	[VARCHAR] (100) NOT NULL,
	[S_MONEDA]	[VARCHAR] (10) NOT NULL,
	[O_MONEDA]	[INT] NOT NULL,
	[C_MONEDA]	[VARCHAR] (255) NOT NULL,
	[L_MONEDA]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[MONEDA]
	ADD CONSTRAINT [PK_MONEDA]
		PRIMARY KEY CLUSTERED ([K_MONEDA])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_MONEDA_01_DESCRIPCION] 
	   ON [dbo].[MONEDA] ( [D_MONEDA] )
GO


ALTER TABLE [dbo].[MONEDA] ADD 
	CONSTRAINT [FK_MONEDA_01] 
		FOREIGN KEY ( [L_MONEDA] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_MONEDA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_MONEDA]
GO


CREATE PROCEDURE [dbo].[PG_CI_MONEDA]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	-- ==================================
	@PP_K_MONEDA		INT,
	@PP_D_MONEDA		VARCHAR(100),
	@PP_S_MONEDA		VARCHAR(10),
	@PP_O_MONEDA		INT,
	@PP_C_MONEDA		VARCHAR(255),
	@PP_L_MONEDA		INT
AS
	
	INSERT INTO MONEDA
		(	K_MONEDA,			D_MONEDA, 
			S_MONEDA,			O_MONEDA,
			C_MONEDA,
			L_MONEDA			)		
	VALUES	
		(	@PP_K_MONEDA,		@PP_D_MONEDA,	
			@PP_S_MONEDA,		@PP_O_MONEDA,
			@PP_C_MONEDA,
			@PP_L_MONEDA		)

	-- =========================================================
GO



EXECUTE [dbo].[PG_CI_MONEDA] 0, 0,  0, '( PENDIENTE )',		'???',  8, '', 1
EXECUTE [dbo].[PG_CI_MONEDA] 0, 0,  1, 'PESOS',				'MXP',  7, '', 1
EXECUTE [dbo].[PG_CI_MONEDA] 0, 0,  2, 'DOLARES',			'USD',  6, '', 1
GO
