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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QA_DATA_PLAN_GASTO]') AND type in (N'U'))
	DROP TABLE [dbo].[QA_DATA_PLAN_GASTO]
GO



-- /////////////////////////////////////////////////////////////////
-- // [QA_DATA_PLAN_GASTO]
-- /////////////////////////////////////////////////////////////////


/****** Object:  Table [dbo].[QA_DATA_PLAN_GASTO]    Script Date: 01/11/2018 04:52:21 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QA_DATA_PLAN_GASTO](
	[K_PLAN_GASTO] [int] NOT NULL,
	[D_PLAN_GASTO] [varchar](100) NOT NULL,
	[C_PLAN_GASTO] [varchar](255) NOT NULL,
	[S_PLAN_GASTO] [varchar](10) NOT NULL,
	[O_PLAN_GASTO] [int] NOT NULL,
	[K_UNIDAD_OPERATIVA] [int] NOT NULL,
	[K_ESCENARIO_PLAN] [int] NOT NULL,
	[K_YYYY] [int] NOT NULL,
	[K_ESTATUS_PLAN_GASTO] [int] NOT NULL,
	[L_RECALCULAR] [int] NOT NULL,
	[K_USUARIO_ALTA] [int] NOT NULL,
	[F_ALTA] [datetime] NOT NULL,
	[K_USUARIO_CAMBIO] [int] NOT NULL,
	[F_CAMBIO] [datetime] NOT NULL,
	[L_BORRADO] [int] NOT NULL,
	[K_USUARIO_BAJA] [int] NULL,
	[F_BAJA] [datetime] NULL,
 CONSTRAINT [PK_QA_DATA_PLAN_GASTO] PRIMARY KEY CLUSTERED 
(
	[K_PLAN_GASTO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO






-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
