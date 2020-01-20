-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			RESUMEN FLUJO DIARIO / RAZON SOCIAL
-- // OPERACION:		LIBERACION / TABLAS
-- //////////////////////////////////////////////////////////////
-- // Autor:			HGF
-- // Fecha creación:	18/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RESUMEN_FLUJO_DIARIO_X_RZS]') AND type in (N'U'))
	DROP TABLE [dbo].[RESUMEN_FLUJO_DIARIO_X_RZS] 
GO




-- //////////////////////////////////////////////////////////////
-- // RESUMEN_FLUJO_DIARIO_X_RZS
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[RESUMEN_FLUJO_DIARIO_X_RZS] (
	-- =============================== 
	[K_RESUMEN_FLUJO_DIARIO_X_RZS]			[INT] NOT NULL,
	-- =============================== 
	[F_OPERACION]							[DATE] NOT NULL,	
	[K_RAZON_SOCIAL]						[INT] NOT NULL,
	[K_ESTATUS_RESUMEN_FLUJO_DIARIO]		[INT] NOT NULL,
	[C_RESUMEN_FLUJO_DIARIO_X_RZS]			[VARCHAR] (500) NOT NULL,
	-- =============================== 	
	[SALDO_INICIAL]						DECIMAL(19,4) NOT NULL DEFAULT 0,
	[INGRESO_BANCO]						DECIMAL(19,4) NOT NULL DEFAULT 0,
	[INGRESO_LIBRO]						DECIMAL(19,4) NOT NULL DEFAULT 0,
	[INGRESO_CONCILIADO]				DECIMAL(19,4) NOT NULL DEFAULT 0,
	[GAS]								DECIMAL(19,4) NOT NULL DEFAULT 0,
	[FLETE]								DECIMAL(19,4) NOT NULL DEFAULT 0,
	[OBLIGACIONES]						DECIMAL(19,4) NOT NULL DEFAULT 0,
	[NOMINA]							DECIMAL(19,4) NOT NULL DEFAULT 0,
	[CXP]								DECIMAL(19,4) NOT NULL DEFAULT 0,
	[TRASPASOS]							DECIMAL(19,4) NOT NULL DEFAULT 0,
	[GASTO_CORPORATIVO]					DECIMAL(19,4) NOT NULL DEFAULT 0,
	[SALDO_FINAL]						DECIMAL(19,4) NOT NULL DEFAULT 0
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[RESUMEN_FLUJO_DIARIO_X_RZS]
	ADD CONSTRAINT [PK_RESUMEN_FLUJO_DIARIO_X_RZS]
		PRIMARY KEY CLUSTERED ( [K_RESUMEN_FLUJO_DIARIO_X_RZS] )
GO


-- //////////////////////////////////////////////////////////////

/*
WIWI
ALTER TABLE [dbo].[RESUMEN_FLUJO_DIARIO_X_RZS] ADD 
	CONSTRAINT [FK_RESUMEN_FLUJO_DIARIO_X_RZS_01] 
		FOREIGN KEY ([K_ESTATUS_RESUMEN_FLUJO_DIARIO]) 
		REFERENCES [dbo].[ESTATUS_RESUMEN_FLUJO_DIARIO] ([K_ESTATUS_RESUMEN_FLUJO_DIARIO])
GO
*/

ALTER TABLE [dbo].[RESUMEN_FLUJO_DIARIO_X_RZS] ADD 
	CONSTRAINT [FK_RESUMEN_FLUJO_DIARIO_X_RZS_02] 
		FOREIGN KEY ([K_RAZON_SOCIAL]) 
		REFERENCES [dbo].[RAZON_SOCIAL] ([K_RAZON_SOCIAL])
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[RESUMEN_FLUJO_DIARIO_X_RZS] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO


ALTER TABLE [dbo].[RESUMEN_FLUJO_DIARIO_X_RZS] ADD 
	CONSTRAINT [FK_RESUMEN_FLUJO_DIARIO_X_RZS_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_RESUMEN_FLUJO_DIARIO_X_RZS_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_RESUMEN_FLUJO_DIARIO_X_RZS_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO


-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_RZS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_RZS]
GO


CREATE PROCEDURE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_RZS]
	@PP_L_DEBUG									INT,
	@PP_K_SISTEMA_EXE							INT,
	@PP_K_RESUMEN_FLUJO_DIARIO_X_RZS			INT,
	@PP_K_ESTATUS_RESUMEN_FLUJO_DIARIO			INT
AS

	INSERT INTO RESUMEN_FLUJO_DIARIO_X_RZS
		(	K_RESUMEN_FLUJO_DIARIO_X_RZS,				
			K_ESTATUS_RESUMEN_FLUJO_DIARIO			)
	VALUES	
		(	@PP_K_RESUMEN_FLUJO_DIARIO_X_RZS,			
			@PP_K_ESTATUS_RESUMEN_FLUJO_DIARIO		)
	
	-- ==============================================
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
