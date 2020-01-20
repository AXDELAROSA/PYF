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


-- ///////////////////////////////////////////////////////////////
-- //				PLAN_POV 						
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PLAN_POV]') AND type in (N'U'))
	DROP TABLE [dbo].[PLAN_POV] 
GO


CREATE TABLE [dbo].[PLAN_POV] (
	[K_PLAN_POV]							[INT]				NOT NULL,    
    [D_PLAN_POV]							[VARCHAR] (200)		NOT NULL DEFAULT '',
	[O_PLAN_POV]							[INT]				NOT NULL DEFAULT 0,
	[K_ESTATUS_CALCULO]						[INT]				NOT NULL DEFAULT 1,
	-- ===========================
	[K_UNIDAD_OPERATIVA]		            [INT]				NOT NULL,
	[K_YYYY]					            [INT]				NOT NULL,
	[K_TEMPORADA]							[INT]				NOT NULL,
    -- ===================================				  
	[N_HISTORICOS]							[INT]				DEFAULT 0,		-- CANTIDAD DE AÑOS A CONSIDERAR PARA REFERENCIA
	-- ===================================				  
	[CRECIMIENTO_MERCADO]					[DECIMAL] (19,4)	DEFAULT 0,		-- PORCENTAJE SE GUARDA COMO VALOR ENTRE 0 Y 1
	[INCREMENTO_PARTICIPACION]				[DECIMAL] (19,4)	DEFAULT 0,		-- PORCENTAJE SE GUARDA COMO VALOR ENTRE 0 Y 1
	[COMPROMISO_KG_X_MES]					[DECIMAL] (19,4)	DEFAULT 0,
	-- ===================================				  
	[VENTAS_KG_H0]					[DECIMAL] (19,4)	DEFAULT 0,	-- HISTORIA // MISMA TEMPORADA DEL AÑO PASADO
	[VENTAS_KG_H1]					[DECIMAL] (19,4)	DEFAULT 0,	-- HISTORIA // TEMPORADA ANTERIOR
	[VENTAS_KG_PR]					[DECIMAL] (19,4)	DEFAULT 0,	-- TEMPORADA A PROYECTAR
	-- ===================================				  
	[VENTAS_KG_H0_01]				[DECIMAL] (19,4)	DEFAULT 0,	-- HISTORIA // MISMA TEMPORADA DEL AÑO PASADO
	[VENTAS_KG_H0_02]				[DECIMAL] (19,4)	DEFAULT 0,	
	[VENTAS_KG_H0_03]				[DECIMAL] (19,4)	DEFAULT 0,	
	[VENTAS_KG_H0_04]				[DECIMAL] (19,4)	DEFAULT 0,	
	[VENTAS_KG_H0_05]				[DECIMAL] (19,4)	DEFAULT 0,	
	[VENTAS_KG_H0_06]				[DECIMAL] (19,4)	DEFAULT 0,
	-- ===================================				  
	[VENTAS_KG_H1_01]				[DECIMAL] (19,4)	DEFAULT 0,	-- HISTORIA // TEMPORADA ANTERIOR
	[VENTAS_KG_H1_02]				[DECIMAL] (19,4)	DEFAULT 0,	
	[VENTAS_KG_H1_03]				[DECIMAL] (19,4)	DEFAULT 0,	
	[VENTAS_KG_H1_04]				[DECIMAL] (19,4)	DEFAULT 0,	
	[VENTAS_KG_H1_05]				[DECIMAL] (19,4)	DEFAULT 0,	
	[VENTAS_KG_H1_06]				[DECIMAL] (19,4)	DEFAULT 0,
	-- ===================================				  
	[VENTAS_KG_PR_01]				[DECIMAL] (19,4)	DEFAULT 0,	-- TEMPORADA A PROYECTAR X MES
	[VENTAS_KG_PR_02]				[DECIMAL] (19,4)	DEFAULT 0,	
	[VENTAS_KG_PR_03]				[DECIMAL] (19,4)	DEFAULT 0,	
	[VENTAS_KG_PR_04]				[DECIMAL] (19,4)	DEFAULT 0,	
	[VENTAS_KG_PR_05]				[DECIMAL] (19,4)	DEFAULT 0,	
	[VENTAS_KG_PR_06]				[DECIMAL] (19,4)	DEFAULT 0
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PLAN_POV]
	ADD CONSTRAINT [PLAN_POV_00]
		PRIMARY KEY CLUSTERED ( [K_PLAN_POV] )
GO




-- //////////////////////////////////////////////////////
/*
ALTER TABLE [dbo].[PLAN_POV] ADD 
	 CONSTRAINT [FK_PLAN_POV_00] 
		FOREIGN KEY ([K_DOCUMENTO_D0M4]) 
		REFERENCES [dbo].[DOCUMENTO_D0M4] ([K_DOCUMENTO_D0M4]),
	CONSTRAINT [FK_PLAN_POV_01] 
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA]),
    CONSTRAINT [FK_PLAN_POV_02] 
		FOREIGN KEY ([K_YYYY]) 
		REFERENCES [dbo].[FILTRO_YYYY] ([K_FILTRO_YYYY]),
	CONSTRAINT [FK_PLAN_POV_03] 
		FOREIGN KEY ([K_TEMPORADA]) 
		REFERENCES [dbo].[TEMPORADA]([K_TEMPORADA])
GO
*/


-- //////////////////////////////////////////////////////



ALTER TABLE [dbo].[PLAN_POV] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[PLAN_POV] ADD 
	CONSTRAINT [FK_PLAN_POV_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PLAN_POV_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PLAN_POV_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --> [PG_CI_PLAN_POV]
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PLAN_POV]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PLAN_POV]
GO


CREATE PROCEDURE [dbo].[PG_CI_PLAN_POV]
	@PP_L_DEBUG					    INT,
	@PP_K_SISTEMA_EXE			    INT,
	@PP_K_USUARIO_ACCION		    INT,	
	-- ===========================	
	@PP_K_PLAN_POV				INT,    
    @PP_D_PLAN_POV				VARCHAR (200),
	@PP_O_PLAN_POV				INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4			INT,
	@PP_K_UNIDAD_OPERATIVA		    INT,
	@PP_K_YYYY					    INT,	
	@PP_K_TEMPORADA						INT,
	-- ===========================
	@PP_HISTORICO_CONSIDERABLE		INT,
	@PP_INCREMENTO_COMPROMISO_KG	DECIMAL(19,0),
	@PP_K_TIPO_CALCULO				INT,
	-- ====================================
	@PP_L_BORRADO					INT
AS
/*
	INSERT INTO PLAN_POV
		(	
			[K_PLAN_POV],		
			[O_PLAN_POV],[D_PLAN_POV],
			-- ===========================
			[K_DOCUMENTO_D0M4],
			[K_UNIDAD_OPERATIVA], [K_YYYY], 
			[K_TEMPORADA],
			-- ===========================	
			[HISTORICO_CONSIDERABLE],
			[INCREMENTO_COMPROMISO_KG],
			[K_TIPO_CALCULO],
			-- ===========================		
			[K_USUARIO_ALTA],	[F_ALTA],
			[K_USUARIO_CAMBIO],	[F_CAMBIO],
			[L_BORRADO]		)	
	VALUES	
		(	 
			@PP_K_PLAN_POV,
			@PP_O_PLAN_POV,@PP_D_PLAN_POV,
			-- ===========================
			@PP_K_DOCUMENTO_D0M4,
			@PP_K_UNIDAD_OPERATIVA,	@PP_K_YYYY, 
			@PP_K_TEMPORADA,
			-- ===========================	
			@PP_HISTORICO_CONSIDERABLE,
			@PP_INCREMENTO_COMPROMISO_KG,
			@PP_K_TIPO_CALCULO,
			-- =============================			
			
			@PP_K_USUARIO_ACCION,		GETDATE(),
			@PP_K_USUARIO_ACCION,		GETDATE(),
			@PP_L_BORRADO
		)
*/
	-- ////////////////////////////////////////////////
GO


-- /////////////////////////////////////////////////////////////////////
-- // CARGA INICIAL PLAN_POV
-- /////////////////////////////////////////////////////////////////////






-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////