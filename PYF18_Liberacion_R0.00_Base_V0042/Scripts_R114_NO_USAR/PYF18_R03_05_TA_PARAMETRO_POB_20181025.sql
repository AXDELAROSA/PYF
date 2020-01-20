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
-- //				PARAMETRO_POB 						
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PARAMETRO_POB]') AND type in (N'U'))
	DROP TABLE [dbo].[PARAMETRO_POB] 
GO

CREATE TABLE [dbo].[PARAMETRO_POB] (
	[K_PARAMETRO_POB]						[INT]				NOT NULL,    
    [D_PARAMETRO_POB]						[VARCHAR] (200)		NOT NULL,
	[O_PARAMETRO_POB]						[INT]				NOT NULL,
	-- ===========================
	[K_DOCUMENTO_D0M4]						[INT]				NOT NULL,
	[K_UNIDAD_OPERATIVA]		            [INT]				NOT NULL,
	[K_YYYY]					            [INT]				NOT NULL,
	[K_TEMPORADA]							[INT]				NOT NULL,
    -- ===================================				  
	[HISTORICO_CONSIDERABLE]				[INT]				DEFAULT 0,
	[INCREMENTO_COMPROMISO_KG]				[DECIMAL] (19,0)	DEFAULT 0,
	[K_TIPO_CALCULO]						[INT]			 	DEFAULT 0
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PARAMETRO_POB]
	ADD CONSTRAINT [PARAMETRO_POB_00]
		PRIMARY KEY CLUSTERED ( [K_PARAMETRO_POB] )
GO




-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[PARAMETRO_POB] ADD 
	 CONSTRAINT [FK_PARAMETRO_POB_00] 
		FOREIGN KEY ([K_DOCUMENTO_D0M4]) 
		REFERENCES [dbo].[DOCUMENTO_D0M4] ([K_DOCUMENTO_D0M4]),
	CONSTRAINT [FK_PARAMETRO_POB_01] 
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA]),
    CONSTRAINT [FK_PARAMETRO_POB_02] 
		FOREIGN KEY ([K_YYYY]) 
		REFERENCES [dbo].[FILTRO_YYYY] ([K_FILTRO_YYYY]),
	CONSTRAINT [FK_PARAMETRO_POB_03] 
		FOREIGN KEY ([K_TEMPORADA]) 
		REFERENCES [dbo].[TEMPORADA]([K_TEMPORADA])
GO



-- //////////////////////////////////////////////////////



ALTER TABLE [dbo].[PARAMETRO_POB] 
	ADD		[K_USUARIO_ALTA]	[INT]		NOT NULL,
			[F_ALTA]			[DATETIME]	NOT NULL,
			[K_USUARIO_CAMBIO]	[INT]		NOT NULL,
			[F_CAMBIO]			[DATETIME]	NOT NULL,
			[L_BORRADO]			[INT]		NOT NULL,
			[K_USUARIO_BAJA]	[INT]		NULL,
			[F_BAJA]			[DATETIME]	NULL;
GO


ALTER TABLE [dbo].[PARAMETRO_POB] ADD 
	CONSTRAINT [FK_PARAMETRO_POB_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PARAMETRO_POB_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_PARAMETRO_POB_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --> [PG_CI_PARAMETRO_POB]
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_PARAMETRO_POB]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_PARAMETRO_POB]
GO


CREATE PROCEDURE [dbo].[PG_CI_PARAMETRO_POB]
	@PP_L_DEBUG					    INT,
	@PP_K_SISTEMA_EXE			    INT,
	@PP_K_USUARIO_ACCION		    INT,	
	-- ===========================	
	@PP_K_PARAMETRO_POB				INT,    
    @PP_D_PARAMETRO_POB				VARCHAR (200),
	@PP_O_PARAMETRO_POB				INT,
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

	INSERT INTO PARAMETRO_POB
		(	
			[K_PARAMETRO_POB],		
			[O_PARAMETRO_POB],[D_PARAMETRO_POB],
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
			@PP_K_PARAMETRO_POB,
			@PP_O_PARAMETRO_POB,@PP_D_PARAMETRO_POB,
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

	-- ////////////////////////////////////////////////
GO


-- /////////////////////////////////////////////////////////////////////
-- // CARGA INICIAL PARAMETRO_POB
-- /////////////////////////////////////////////////////////////////////


	--	EXECUTE [dbo].[PG_CI_PARAMETRO_POB]		0,0,69,1,'LOLA',10,
	--										103084,13,2017,2,5,6000,2,0

	--	EXECUTE [dbo].[PG_CI_PARAMETRO_POB]		0,0,69,2,'LOLA',10,
	--										103085,13,2017,1,5,6000,2,0

-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////