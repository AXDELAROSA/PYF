-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			CUENTA_BANCO_UO
-- // OPERACION:		LIBERACION / TABLA+CARGA 
-- // Autor:			Alex de la Rosa
-- // Fecha creación:	04/09/18
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CUENTA_BANCO_UO]') AND type in (N'U'))
	DROP TABLE [dbo].[CUENTA_BANCO_UO]
GO



-- /////////////////////////////////////////////////////////////////
-- // TABLA
-- /////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[CUENTA_BANCO_UO] (
	[K_CUENTA_BANCO_UO]				[INT]			NOT NULL,
	[D_CUENTA_BANCO_UO]				VARCHAR(100)	NULL			DEFAULT '',
	[K_UNIDAD_OPERATIVA]			[INT]			NOT NULL,
	[K_TIPO_CUENTA_BANCO]			[INT]			NOT NULL,
	[K_CUENTA_BANCO]				[INT]			NULL			DEFAULT 0,
	[L_PRINCIPAL]					[INT]			NOT NULL		DEFAULT 0
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////



ALTER TABLE [dbo].[CUENTA_BANCO_UO]
	ADD CONSTRAINT [PK_CUENTA_BANCO_UO]
		PRIMARY KEY CLUSTERED ( [K_CUENTA_BANCO_UO] )
GO


/*

ALTER TABLE [dbo].[CUENTA_BANCO_UO]
	ADD CONSTRAINT [PK_CUENTA_BANCO_UO]
		PRIMARY KEY CLUSTERED ( [K_CUENTA_BANCO], [K_UNIDAD_OPERATIVA] )
GO

*/


/*

ALTER TABLE [dbo].[CUENTA_BANCO_UO] ADD
	CONSTRAINT [FK_CUENTA_BANCO_UO_01]  
		FOREIGN KEY ([K_CUENTA_BANCO]) 
		REFERENCES [dbo].[CUENTA_BANCO](K_CUENTA_BANCO),	
	CONSTRAINT [FK_CUENTA_BANCO_UO_02]  
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA])
GO

*/


-- //////////////////////////////////////////////////////
--///					CARGA INICIAL				 ////
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_CUENTA_BANCO_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_CUENTA_BANCO_UO]
GO


CREATE PROCEDURE [dbo].[PG_CI_CUENTA_BANCO_UO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- =============================
	@PP_K_CUENTA_BANCO			INT,
	@PP_K_UNIDAD_OPERATIVA		INT	
AS

	INSERT INTO CUENTA_BANCO_UO
		(	K_CUENTA_BANCO,
			K_UNIDAD_OPERATIVA			)	
	VALUES	
		(	@PP_K_CUENTA_BANCO,
			@PP_K_UNIDAD_OPERATIVA		)			

	-- ==============================================
GO



-- //////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////
