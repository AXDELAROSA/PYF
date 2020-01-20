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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRECIO_COSTO_PERFIL]') AND type in (N'U'))
	DROP TABLE [dbo].[PRECIO_COSTO_PERFIL]
GO



-- /////////////////////////////////////////////////////////////////
-- // PRECIO_COSTO_PERFIL
-- /////////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[PRECIO_COSTO_PERFIL] (
	[K_PRECIO_COSTO_PERFIL]		[INT] NOT NULL,	
	[O_PRECIO_COSTO_PERFIL]		[INT] NOT NULL,
	[L_PRECIO_COSTO_PERFIL]		[INT] NOT NULL,
	-- ===========================
	[K_UNIDAD_OPERATIVA]		[INT] NOT NULL,
	[K_YYYY]					[INT] NOT NULL,
	[K_MM]						[INT] NOT NULL,
	-- ===========================	
	[PV_PRECIO_VENTA]			DECIMAL(19,4) NOT NULL DEFAULT 0,
	[PC_PRECIO_COMPRA]			DECIMAL(19,4) NOT NULL DEFAULT 0,	-- PC = PV - (TODO)
	-- ===========================		
	[MC]						DECIMAL(19,4) NOT NULL DEFAULT 0,	-- (1) MARGEN CONGELADO
	[FLETE]						DECIMAL(19,4) NOT NULL DEFAULT 0,	-- (2) FLETE
	[CA]						DECIMAL(19,4) NOT NULL DEFAULT 0,	-- (3) CVS. ADIC. 
	[APG]						DECIMAL(19,4) NOT NULL DEFAULT 0,	-- (4) AMORT. PETROGAS 
	[MP_INB]					DECIMAL(19,4) NOT NULL DEFAULT 0,	-- (5) M.P. INBURSA
	[FG]						DECIMAL(19,4) NOT NULL DEFAULT 0,	-- (6) FIRAGAS
	[SMD]						DECIMAL(19,4) NOT NULL DEFAULT 0,	-- (7) SMD
	[SMP]						DECIMAL(19,4) NOT NULL DEFAULT 0,	-- (8) SMP
	[SMRU]						DECIMAL(19,4) NOT NULL DEFAULT 0,	-- (9) SMRU
	[SMPT]						DECIMAL(19,4) NOT NULL DEFAULT 0,	-- (10) SMPT
	-- ===========================
	[ASPTA]						DECIMAL(19,4) NOT NULL DEFAULT 0,	
	[OG]						DECIMAL(19,4) NOT NULL DEFAULT 0,
	[COOP]						DECIMAL(19,4) NOT NULL DEFAULT 0,
	[SMCNP]						DECIMAL(19,4) NOT NULL DEFAULT 0,
	[SMRI]						DECIMAL(19,4) NOT NULL DEFAULT 0,
	[PQ_D]						DECIMAL(19,4) NOT NULL DEFAULT 0,
	[P_IND]						DECIMAL(19,4) NOT NULL DEFAULT 0,
	[APG2]						DECIMAL(19,4) NOT NULL DEFAULT 0
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PRECIO_COSTO_PERFIL]
	ADD CONSTRAINT [PK_PRECIO_COSTO_PERFIL]
		PRIMARY KEY CLUSTERED ([K_PRECIO_COSTO_PERFIL])
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PRECIO_COSTO_PERFIL] ADD 
	CONSTRAINT [FK_PRECIO_COSTO_PERFIL_01] 
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA])
GO



-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[PRECIO_COSTO_PERFIL] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO



ALTER TABLE [dbo].[PRECIO_COSTO_PERFIL] ADD 
	CONSTRAINT [FK_PRECIO_COSTO_PERFIL_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PRECIO_COSTO_PERFIL_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PRECIO_COSTO_PERFIL_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////

