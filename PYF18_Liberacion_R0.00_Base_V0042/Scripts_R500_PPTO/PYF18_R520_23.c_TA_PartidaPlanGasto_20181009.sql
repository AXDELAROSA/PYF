-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PLAN_GASTO GASTOS/PLANTA
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	09/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PARTIDA_PLAN_GASTO]') AND type in (N'U'))
	DROP TABLE [dbo].[PARTIDA_PLAN_GASTO] 
GO








-- ///////////////////////////////////////////////////////////////
-- //						PARTIDA_PLAN_GASTO 						
-- ///////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[PARTIDA_PLAN_GASTO] (
	[K_PLAN_GASTO]					[INT] NOT NULL,
	[K_RUBRO_PRESUPUESTO]			[INT] NOT NULL,
	[K_PROGRAMACION_PARTIDA]		[INT] NOT NULL DEFAULT 0,
	-- ===========================================		
	[MONTO_ESTIMADO]				DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M00_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	-- ===========================================		
	[M01_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M02_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M03_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M04_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M05_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M06_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M07_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M08_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M09_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M10_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M11_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[M12_MONTO_ESTIMADO]			DECIMAL(19,4) NOT NULL DEFAULT 0
	-- ===========================================	
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////



ALTER TABLE [dbo].[PARTIDA_PLAN_GASTO]
	ADD CONSTRAINT [PK_PARTIDA_PLAN_GASTO]
		PRIMARY KEY CLUSTERED (	[K_PLAN_GASTO], [K_RUBRO_PRESUPUESTO]  )
GO



ALTER TABLE [dbo].[PARTIDA_PLAN_GASTO] ADD 
	CONSTRAINT [FK_PARTIDA_PLAN_GASTO_01] 
		FOREIGN KEY ([K_PLAN_GASTO]) 
		REFERENCES [dbo].[PLAN_GASTO] ( [K_PLAN_GASTO] ),
	CONSTRAINT [FK_PARTIDA_PLAN_GASTO_02] 
		FOREIGN KEY ([K_RUBRO_PRESUPUESTO]) 
		REFERENCES [dbo].[RUBRO_PRESUPUESTO] ( [K_RUBRO_PRESUPUESTO] ),
	CONSTRAINT [FK_PARTIDA_PLAN_GASTO_03] 
		FOREIGN KEY ([K_PROGRAMACION_PARTIDA]) 
		REFERENCES [dbo].[PROGRAMACION_PARTIDA] ( [K_PROGRAMACION_PARTIDA] )
GO



-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PARTIDA_PLAN_GASTO] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[PARTIDA_PLAN_GASTO] ADD 
	CONSTRAINT [FK_PARTIDA_PLAN_GASTO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PARTIDA_PLAN_GASTO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PARTIDA_PLAN_GASTO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO




-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
