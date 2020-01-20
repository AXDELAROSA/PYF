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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PARTIDA_PRESUPUESTO]') AND type in (N'U'))
	DROP TABLE [dbo].[PARTIDA_PRESUPUESTO] 
GO





-- ///////////////////////////////////////////////////////////////
-- //						PARTIDA_PRESUPUESTO 						
-- ///////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[PARTIDA_PRESUPUESTO] (
	[K_PRESUPUESTO]					[INT] NOT NULL,
	[K_RUBRO_PRESUPUESTO]			[INT] NOT NULL,
	[K_PROGRAMACION_PARTIDA]		[INT] NOT NULL DEFAULT 0,
	-- ===========================================		
	[MES_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W01_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W02_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W03_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W04_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W05_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	-- ===========================================	
	[MES_MONTO_EN_PROCESO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W01_MONTO_EN_PROCESO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W02_MONTO_EN_PROCESO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W03_MONTO_EN_PROCESO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W04_MONTO_EN_PROCESO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W05_MONTO_EN_PROCESO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	-- ===========================================	
	[MES_MONTO_EJERCIDO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W01_MONTO_EJERCIDO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W02_MONTO_EJERCIDO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W03_MONTO_EJERCIDO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W04_MONTO_EJERCIDO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W05_MONTO_EJERCIDO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	-- ===========================================	
	[MES_MONTO_REMANENTE]			DECIMAL(19,4) NOT NULL DEFAULT 0,	-- REMANENTE = ( ESTIMADO - EJERCIDO )
	[W01_MONTO_REMANENTE]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W02_MONTO_REMANENTE]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W03_MONTO_REMANENTE]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W04_MONTO_REMANENTE]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[W05_MONTO_REMANENTE]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	-- ===========================================	
	[MES_PORCENTAJE_REMANENTE]		[FLOAT] NOT NULL DEFAULT 0,
	[W01_PORCENTAJE_REMANENTE]		[FLOAT] NOT NULL DEFAULT 0,
	[W02_PORCENTAJE_REMANENTE]		[FLOAT] NOT NULL DEFAULT 0,
	[W03_PORCENTAJE_REMANENTE]		[FLOAT] NOT NULL DEFAULT 0,
	[W04_PORCENTAJE_REMANENTE]		[FLOAT] NOT NULL DEFAULT 0,
	[W05_PORCENTAJE_REMANENTE]		[FLOAT] NOT NULL DEFAULT 0
	-- ===========================================	
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////



ALTER TABLE [dbo].[PARTIDA_PRESUPUESTO]
	ADD CONSTRAINT [PK_PARTIDA_PRESUPUESTO]
		PRIMARY KEY CLUSTERED (	[K_PRESUPUESTO], [K_RUBRO_PRESUPUESTO]  )
GO



ALTER TABLE [dbo].[PARTIDA_PRESUPUESTO] ADD 
	CONSTRAINT [FK_PARTIDA_PRESUPUESTO_01] 
		FOREIGN KEY ([K_PRESUPUESTO]) 
		REFERENCES [dbo].[PRESUPUESTO] ( [K_PRESUPUESTO] ),
	CONSTRAINT [FK_PARTIDA_PRESUPUESTO_02] 
		FOREIGN KEY ([K_RUBRO_PRESUPUESTO]) 
		REFERENCES [dbo].[RUBRO_PRESUPUESTO] ( [K_RUBRO_PRESUPUESTO] )
GO




-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PARTIDA_PRESUPUESTO] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[PARTIDA_PRESUPUESTO] ADD 
	CONSTRAINT [FK_PARTIDA_PRESUPUESTO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PARTIDA_PRESUPUESTO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PARTIDA_PRESUPUESTO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO




-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
