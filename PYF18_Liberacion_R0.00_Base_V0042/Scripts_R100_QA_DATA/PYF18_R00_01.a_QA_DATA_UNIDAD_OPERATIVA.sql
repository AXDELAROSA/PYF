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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QA_DATA_UNIDAD_OPERATIVA]') AND type in (N'U'))
	DROP TABLE [dbo].[QA_DATA_UNIDAD_OPERATIVA]
GO



-- /////////////////////////////////////////////////////////////////
-- // QA_DATA_UNIDAD_OPERATIVA
-- /////////////////////////////////////////////////////////////////


/****** Object:  Table [dbo].[QA_DATA_UNIDAD_OPERATIVA]    Script Date: 01/11/2018 04:52:37 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QA_DATA_UNIDAD_OPERATIVA](
	[K_UNIDAD_OPERATIVA] [int] NOT NULL,
	[FACTOR] [decimal](19, 4) NULL,
 CONSTRAINT [PK_QA_DATA_UNIDAD_OPERATIVA] PRIMARY KEY CLUSTERED 
(
	[K_UNIDAD_OPERATIVA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[QA_DATA_UNIDAD_OPERATIVA] ADD  DEFAULT ((1)) FOR [FACTOR]
GO


/*

ALTER TABLE [dbo].[QA_DATA_UNIDAD_OPERATIVA]  WITH CHECK ADD  CONSTRAINT [FK_QA_DATA_UNIDAD_OPERATIVA_01] FOREIGN KEY([K_UNIDAD_OPERATIVA])
REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA])
GO

ALTER TABLE [dbo].[QA_DATA_UNIDAD_OPERATIVA] CHECK CONSTRAINT [FK_QA_DATA_UNIDAD_OPERATIVA_01]
GO

*/





-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
