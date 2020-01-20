-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			DETALLE_INSTRUCCION/MOVIMIENTO TESORERIA
-- // OPERACION:		LIBERACION / TABLAS
-- //////////////////////////////////////////////////////////////
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	18/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DETALLE_INSTRUCCION]') AND type in (N'U'))
	DROP TABLE [dbo].[DETALLE_INSTRUCCION] 
GO





-- ///////////////////////////////////////////////////////////////
-- // DETALLE_INSTRUCCION					
-- ///////////////////////////////////////////////////////////////
	

CREATE TABLE [dbo].[DETALLE_INSTRUCCION] (
	-- =============================== CONTROL
	[K_DETALLE_INSTRUCCION]			[INT] NOT NULL,
	[K_INSTRUCCION]					[INT] NOT NULL,
	-- =============================== INFORMACION
	[K_TRASPASO]					[INT] NULL,
	[K_FACTURA_CXP]					[INT] NULL,
	[MONTO]							DECIMAL(19,4) NOT NULL DEFAULT 0
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[DETALLE_INSTRUCCION]
	ADD CONSTRAINT [PK_DETALLE_INSTRUCCION]
		PRIMARY KEY CLUSTERED ([K_DETALLE_INSTRUCCION])
GO
 

 
-- //////////////////////////////////////////////////////////////

/*
-- WIWI
ALTER TABLE [dbo].[DETALLE_INSTRUCCION] ADD 
	CONSTRAINT [FK_DETALLE_INSTRUCCION_01] 
		FOREIGN KEY ([K_INSTRUCCION])
		REFERENCES [dbo].[INSTRUCCION] ([K_INSTRUCCION])
GO
*/

ALTER TABLE [dbo].[DETALLE_INSTRUCCION] ADD 
	CONSTRAINT [FK_DETALLE_INSTRUCCION_02] 
		FOREIGN KEY ([K_TRASPASO])
		REFERENCES [dbo].[TRASPASO] ([K_TRASPASO]),
	CONSTRAINT [FK_DETALLE_INSTRUCCION_03] 
		FOREIGN KEY ([K_FACTURA_CXP]) 
		REFERENCES [dbo].[FACTURA_CXP] ([K_FACTURA_CXP])
GO



-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[DETALLE_INSTRUCCION] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO


ALTER TABLE [dbo].[DETALLE_INSTRUCCION] ADD 
	CONSTRAINT [FK_DETALLE_INSTRUCCION_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_DETALLE_INSTRUCCION_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_DETALLE_INSTRUCCION_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO


-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_DETALLE_INSTRUCCION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_DETALLE_INSTRUCCION]
GO


CREATE PROCEDURE [dbo].[PG_CI_DETALLE_INSTRUCCION]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_DETALLE_INSTRUCCION					INT,
	@PP_K_ESTATUS_DETALLE_INSTRUCCION			INT,
	@PP_K_TIPO_DETALLE_INSTRUCCION				INT
AS

	INSERT INTO DETALLE_INSTRUCCION
		(	K_DETALLE_INSTRUCCION			)
	VALUES	
		(	@PP_K_DETALLE_INSTRUCCION		)
	
	-- ==============================================
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
