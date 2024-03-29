-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / TABLA+CARGA 
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QA_DATA_PARTIDA_PLAN_GASTO]') AND type in (N'U'))
	DROP TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO]
GO



-- /////////////////////////////////////////////////////////////////
-- // [QA_DATA_PARTIDA_PLAN_GASTO]
-- /////////////////////////////////////////////////////////////////


/****** Object:  Table [dbo].[QA_DATA_PARTIDA_PLAN_GASTO]    Script Date: 01/11/2018 04:52:01 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO](
	[K_PLAN_GASTO] [int] NOT NULL,
	[K_RUBRO_PRESUPUESTO] [int] NOT NULL,
	[K_PROGRAMACION_PARTIDA] [int] NOT NULL,
	[MONTO_ESTIMADO] [decimal](19, 4) NOT NULL,
	[M00_MONTO_ESTIMADO] [decimal](19, 4) NOT NULL,
	[M01_MONTO_ESTIMADO] [decimal](19, 4) NOT NULL,
	[M02_MONTO_ESTIMADO] [decimal](19, 4) NOT NULL,
	[M03_MONTO_ESTIMADO] [decimal](19, 4) NOT NULL,
	[M04_MONTO_ESTIMADO] [decimal](19, 4) NOT NULL,
	[M05_MONTO_ESTIMADO] [decimal](19, 4) NOT NULL,
	[M06_MONTO_ESTIMADO] [decimal](19, 4) NOT NULL,
	[M07_MONTO_ESTIMADO] [decimal](19, 4) NOT NULL,
	[M08_MONTO_ESTIMADO] [decimal](19, 4) NOT NULL,
	[M09_MONTO_ESTIMADO] [decimal](19, 4) NOT NULL,
	[M10_MONTO_ESTIMADO] [decimal](19, 4) NOT NULL,
	[M11_MONTO_ESTIMADO] [decimal](19, 4) NOT NULL,
	[M12_MONTO_ESTIMADO] [decimal](19, 4) NOT NULL,
	[K_USUARIO_ALTA] [int] NOT NULL,
	[F_ALTA] [datetime] NOT NULL,
	[K_USUARIO_CAMBIO] [int] NOT NULL,
	[F_CAMBIO] [datetime] NOT NULL,
	[L_BORRADO] [int] NOT NULL,
	[K_USUARIO_BAJA] [int] NULL,
	[F_BAJA] [datetime] NULL,
 CONSTRAINT [PK_QA_DATA_PARTIDA_PLAN_GASTO] PRIMARY KEY CLUSTERED 
(
	[K_PLAN_GASTO] ASC,
	[K_RUBRO_PRESUPUESTO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [K_PROGRAMACION_PARTIDA]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [MONTO_ESTIMADO]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [M00_MONTO_ESTIMADO]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [M01_MONTO_ESTIMADO]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [M02_MONTO_ESTIMADO]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [M03_MONTO_ESTIMADO]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [M04_MONTO_ESTIMADO]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [M05_MONTO_ESTIMADO]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [M06_MONTO_ESTIMADO]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [M07_MONTO_ESTIMADO]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [M08_MONTO_ESTIMADO]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [M09_MONTO_ESTIMADO]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [M10_MONTO_ESTIMADO]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [M11_MONTO_ESTIMADO]
GO

ALTER TABLE [dbo].[QA_DATA_PARTIDA_PLAN_GASTO] ADD  DEFAULT ((0)) FOR [M12_MONTO_ESTIMADO]
GO






-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
