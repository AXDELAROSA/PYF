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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PARAMETRO_DOCUMENTO_D0M4]') AND type in (N'U'))
	DROP TABLE [dbo].[PARAMETRO_DOCUMENTO_D0M4] 
GO



-- ///////////////////////////////////////////////////////////////
-- //				PARAMETRO_DOCUMENTO_D0M4 						
-- ///////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[PARAMETRO_DOCUMENTO_D0M4] (
	[K_DOCUMENTO_D0M4]						[INT] NOT NULL,
	-- ===================================				  
--	[P2001_PV_PRECIO_VENTA_X_KG]			DECIMAL(19,4) DEFAULT 0,
	[P2016_DTO_DESCUENTO_X_KG]				DECIMAL(19,4) DEFAULT 0,
	[DESCUENTO_CONTADO]						DECIMAL(19,4) DEFAULT 0,
	[DESCUENTO_CREDITO]						DECIMAL(19,4) DEFAULT 0,
	[P2023_PCN]								DECIMAL(19,4) DEFAULT 0,
	-- ===================================				  
	[VENTA_PORCENTAJE_CONTADO]				DECIMAL(19,4) DEFAULT 0,
	[VENTA_PORCENTAJE_CREDITO]				DECIMAL(19,4) DEFAULT 0,
	[P1003_VENTA_KG_CONTADO]				DECIMAL(19,4) DEFAULT 0,
	[P1004_VENTA_KG_CREDITO]				DECIMAL(19,4) DEFAULT 0,
	[P1012_CARTERA_CYC_INICIAL]				DECIMAL(19,4) DEFAULT 0,
	[P1013_CARTERA_CYC_FINAL]				DECIMAL(19,4) DEFAULT 0,
	[COBRANZA_HOLGURA]						DECIMAL(19,4) DEFAULT 0,
	-- ===================================				  
	[PERFIL_VENTA_CONTADO_1_LUNES]			DECIMAL(19,4) DEFAULT 0,
	[PERFIL_VENTA_CONTADO_2_MARTES]			DECIMAL(19,4) DEFAULT 0,
	[PERFIL_VENTA_CONTADO_3_MIERCOLES]		DECIMAL(19,4) DEFAULT 0,
	[PERFIL_VENTA_CONTADO_4_JUEVES]			DECIMAL(19,4) DEFAULT 0,
	[PERFIL_VENTA_CONTADO_5_VIERNES]		DECIMAL(19,4) DEFAULT 0,
	[PERFIL_VENTA_CONTADO_6_SABADO]			DECIMAL(19,4) DEFAULT 0,
	[PERFIL_VENTA_CONTADO_7_DOMINGO]		DECIMAL(19,4) DEFAULT 0,
	-- ===================================					  
	[PERFIL_VENTA_CREDITO_1_LUNES]			DECIMAL(19,4) DEFAULT 0,
	[PERFIL_VENTA_CREDITO_2_MARTES]			DECIMAL(19,4) DEFAULT 0,
	[PERFIL_VENTA_CREDITO_3_MIERCOLES]		DECIMAL(19,4) DEFAULT 0,
	[PERFIL_VENTA_CREDITO_4_JUEVES]			DECIMAL(19,4) DEFAULT 0,
	[PERFIL_VENTA_CREDITO_5_VIERNES]		DECIMAL(19,4) DEFAULT 0,
	[PERFIL_VENTA_CREDITO_6_SABADO]			DECIMAL(19,4) DEFAULT 0,
	[PERFIL_VENTA_CREDITO_7_DOMINGO]		DECIMAL(19,4) DEFAULT 0,
	-- ===================================					  
	[PERFIL_COBRANZA_1_LUNES]				DECIMAL(19,4) DEFAULT 0,
	[PERFIL_COBRANZA_2_MARTES]				DECIMAL(19,4) DEFAULT 0,
	[PERFIL_COBRANZA_3_MIERCOLES]			DECIMAL(19,4) DEFAULT 0,
	[PERFIL_COBRANZA_4_JUEVES]				DECIMAL(19,4) DEFAULT 0,
	[PERFIL_COBRANZA_5_VIERNES]				DECIMAL(19,4) DEFAULT 0,
	[PERFIL_COBRANZA_6_SABADO]				DECIMAL(19,4) DEFAULT 0,
	[PERFIL_COBRANZA_7_DOMINGO]				DECIMAL(19,4) DEFAULT 0
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PARAMETRO_DOCUMENTO_D0M4]
	ADD CONSTRAINT [PK_PARAMETRO_DOCUMENTO_D0M4]
		PRIMARY KEY CLUSTERED ( [K_DOCUMENTO_D0M4] )
GO




-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PARAMETRO_DOCUMENTO_D0M4] ADD 
	CONSTRAINT [FK_PARAMETRO_DOCUMENTO_D0M4_01] 
		FOREIGN KEY ([K_DOCUMENTO_D0M4]) 
		REFERENCES [dbo].[DOCUMENTO_D0M4] ([K_DOCUMENTO_D0M4])
GO




ALTER TABLE [dbo].[PARAMETRO_DOCUMENTO_D0M4] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[PARAMETRO_DOCUMENTO_D0M4] ADD 
	CONSTRAINT [FK_PARAMETRO_DOCUMENTO_D0M4_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PARAMETRO_DOCUMENTO_D0M4_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PARAMETRO_DOCUMENTO_D0M4_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO





-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PARAMETRO_DOCUMENTO_D0M4_DEFAULT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PARAMETRO_DOCUMENTO_D0M4_DEFAULT]
GO


CREATE PROCEDURE [dbo].[PG_CI_PARAMETRO_DOCUMENTO_D0M4_DEFAULT]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_DOCUMENTO_D0M4		INT
AS

	INSERT INTO PARAMETRO_DOCUMENTO_D0M4
		(	K_DOCUMENTO_D0M4			)	
	VALUES	
		(	@PP_K_DOCUMENTO_D0M4		)

	-- ==============================================
GO

-- //////////////////////////////////////////////////////






-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
