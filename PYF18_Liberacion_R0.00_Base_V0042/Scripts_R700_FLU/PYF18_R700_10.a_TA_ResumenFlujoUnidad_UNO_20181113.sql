-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			RESUMEN FLUJO DIARIO / UNIDAD OPERATIVA
-- // OPERACION:		LIBERACION / TABLAS
-- //////////////////////////////////////////////////////////////
-- // Autor:			HGF
-- // Fecha creaci�n:	18/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- SELECT	*	FROM	[TIPO_RESUMEN_FLUJO_DIARIO_X_UNO] 


-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RESUMEN_FLUJO_DIARIO_X_UNO]') AND type in (N'U'))
	DROP TABLE [dbo].[RESUMEN_FLUJO_DIARIO_X_UNO] 
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_RESUMEN_FLUJO_DIARIO]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_RESUMEN_FLUJO_DIARIO]
GO





-- //////////////////////////////////////////////////////////////
-- // ESTATUS_RESUMEN_FLUJO_DIARIO
-- //////////////////////////////////////////////////////////////


CREATE TABLE [dbo].[ESTATUS_RESUMEN_FLUJO_DIARIO] (
	[K_ESTATUS_RESUMEN_FLUJO_DIARIO]	[INT] NOT NULL,
	[D_ESTATUS_RESUMEN_FLUJO_DIARIO]	[VARCHAR] (100) NOT NULL,
	[S_ESTATUS_RESUMEN_FLUJO_DIARIO]	[VARCHAR] (10) NOT NULL,
	[O_ESTATUS_RESUMEN_FLUJO_DIARIO]	[INT] NOT NULL,
	[C_ESTATUS_RESUMEN_FLUJO_DIARIO]	[VARCHAR] (255) NOT NULL,
	[L_ESTATUS_RESUMEN_FLUJO_DIARIO]	[INT] NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[ESTATUS_RESUMEN_FLUJO_DIARIO]
	ADD CONSTRAINT [PK_ESTATUS_RESUMEN_FLUJO_DIARIO]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_RESUMEN_FLUJO_DIARIO])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_RESUMEN_FLUJO_DIARIO_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_RESUMEN_FLUJO_DIARIO] ( [D_ESTATUS_RESUMEN_FLUJO_DIARIO] )
GO


ALTER TABLE [dbo].[ESTATUS_RESUMEN_FLUJO_DIARIO] ADD 
	CONSTRAINT [FK_ESTATUS_RESUMEN_FLUJO_DIARIO_01] 
		FOREIGN KEY ( [L_ESTATUS_RESUMEN_FLUJO_DIARIO] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_RESUMEN_FLUJO_DIARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_RESUMEN_FLUJO_DIARIO]
GO


CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_RESUMEN_FLUJO_DIARIO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	-- ========================================
	@PP_K_ESTATUS_RESUMEN_FLUJO_DIARIO		INT,
	@PP_D_ESTATUS_RESUMEN_FLUJO_DIARIO		VARCHAR(100),
	@PP_S_ESTATUS_RESUMEN_FLUJO_DIARIO		VARCHAR(10),
	@PP_O_ESTATUS_RESUMEN_FLUJO_DIARIO		INT,
	@PP_C_ESTATUS_RESUMEN_FLUJO_DIARIO		VARCHAR(255),
	@PP_L_ESTATUS_RESUMEN_FLUJO_DIARIO		INT
AS
	
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_ESTATUS_RESUMEN_FLUJO_DIARIO
							FROM	ESTATUS_RESUMEN_FLUJO_DIARIO
							WHERE	K_ESTATUS_RESUMEN_FLUJO_DIARIO=@PP_K_ESTATUS_RESUMEN_FLUJO_DIARIO

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO ESTATUS_RESUMEN_FLUJO_DIARIO	
			(	K_ESTATUS_RESUMEN_FLUJO_DIARIO,				D_ESTATUS_RESUMEN_FLUJO_DIARIO, 
				S_ESTATUS_RESUMEN_FLUJO_DIARIO,				O_ESTATUS_RESUMEN_FLUJO_DIARIO,
				C_ESTATUS_RESUMEN_FLUJO_DIARIO,
				L_ESTATUS_RESUMEN_FLUJO_DIARIO				)		
		VALUES	
			(	@PP_K_ESTATUS_RESUMEN_FLUJO_DIARIO,			@PP_D_ESTATUS_RESUMEN_FLUJO_DIARIO,	
				@PP_S_ESTATUS_RESUMEN_FLUJO_DIARIO,			@PP_O_ESTATUS_RESUMEN_FLUJO_DIARIO,
				@PP_C_ESTATUS_RESUMEN_FLUJO_DIARIO,
				@PP_L_ESTATUS_RESUMEN_FLUJO_DIARIO			)
	ELSE
		UPDATE	ESTATUS_RESUMEN_FLUJO_DIARIO
		SET		D_ESTATUS_RESUMEN_FLUJO_DIARIO	= @PP_D_ESTATUS_RESUMEN_FLUJO_DIARIO,	
				S_ESTATUS_RESUMEN_FLUJO_DIARIO	= @PP_S_ESTATUS_RESUMEN_FLUJO_DIARIO,			
				O_ESTATUS_RESUMEN_FLUJO_DIARIO	= @PP_O_ESTATUS_RESUMEN_FLUJO_DIARIO,
				C_ESTATUS_RESUMEN_FLUJO_DIARIO	= @PP_C_ESTATUS_RESUMEN_FLUJO_DIARIO,
				L_ESTATUS_RESUMEN_FLUJO_DIARIO	= @PP_L_ESTATUS_RESUMEN_FLUJO_DIARIO	
		WHERE	K_ESTATUS_RESUMEN_FLUJO_DIARIO=@PP_K_ESTATUS_RESUMEN_FLUJO_DIARIO

	-- =========================================================
GO

-- //////////////////////////////////////////////////////////////




-- ===============================================
SET NOCOUNT ON
-- ===============================================

EXECUTE [dbo].[PG_CI_ESTATUS_RESUMEN_FLUJO_DIARIO] 0, 0, 1, 'PREREGISTRO',		'PRERG', 1, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_RESUMEN_FLUJO_DIARIO] 0, 0, 2, 'EN PROCESO',		'PROCS', 2, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_RESUMEN_FLUJO_DIARIO] 0, 0, 3, 'CERRADO',			'CRRD',	 3, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_RESUMEN_FLUJO_DIARIO] 0, 0, 4, 'REACTIVADO',		'REACT', 4, '', 1
GO

-- ===============================================
SET NOCOUNT OFF
-- ===============================================





-- //////////////////////////////////////////////////////////////
-- // RESUMEN_FLUJO_DIARIO_X_UNO
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[RESUMEN_FLUJO_DIARIO_X_UNO] (
	-- =============================== 
	[K_RESUMEN_FLUJO_DIARIO_X_UNO]			[INT] NOT NULL,
	-- =============================== 
	[F_OPERACION]							[DATE] NOT NULL,	
	[K_UNIDAD_OPERATIVA]					[INT] NOT NULL,
	[K_ESTATUS_RESUMEN_FLUJO_DIARIO]		[INT] NOT NULL,
	[C_RESUMEN_FLUJO_DIARIO_X_UNO]			[VARCHAR] (500) NOT NULL,
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

ALTER TABLE [dbo].[RESUMEN_FLUJO_DIARIO_X_UNO]
	ADD CONSTRAINT [PK_RESUMEN_FLUJO_DIARIO_X_UNO]
		PRIMARY KEY CLUSTERED ( [K_RESUMEN_FLUJO_DIARIO_X_UNO] )
GO



CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_RESUMEN_FLUJO_DIARIO_X_UNO] 
	   ON [dbo].[RESUMEN_FLUJO_DIARIO_X_UNO] ( [F_OPERACION], [K_UNIDAD_OPERATIVA]	 )
GO




ALTER TABLE [dbo].[RESUMEN_FLUJO_DIARIO_X_UNO] ADD 
	CONSTRAINT [FK_RESUMEN_FLUJO_DIARIO_X_UNO_01] 
		FOREIGN KEY ([K_ESTATUS_RESUMEN_FLUJO_DIARIO]) 
		REFERENCES [dbo].[ESTATUS_RESUMEN_FLUJO_DIARIO] ([K_ESTATUS_RESUMEN_FLUJO_DIARIO]),
	CONSTRAINT [FK_RESUMEN_FLUJO_DIARIO_X_UNO_02] 
		FOREIGN KEY ([K_UNIDAD_OPERATIVA]) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ([K_UNIDAD_OPERATIVA])
GO




-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[RESUMEN_FLUJO_DIARIO_X_UNO] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO


ALTER TABLE [dbo].[RESUMEN_FLUJO_DIARIO_X_UNO] ADD 
	CONSTRAINT [FK_RESUMEN_FLUJO_DIARIO_X_UNO_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_RESUMEN_FLUJO_DIARIO_X_UNO_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_RESUMEN_FLUJO_DIARIO_X_UNO_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO


-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO]
GO


CREATE PROCEDURE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO]
	@PP_L_DEBUG									INT,
	@PP_K_SISTEMA_EXE							INT,
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO			INT,
	@PP_K_ESTATUS_RESUMEN_FLUJO_DIARIO			INT
AS

	INSERT INTO RESUMEN_FLUJO_DIARIO_X_UNO
		(	K_RESUMEN_FLUJO_DIARIO_X_UNO,				
			K_ESTATUS_RESUMEN_FLUJO_DIARIO			)
	VALUES	
		(	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO,			
			@PP_K_ESTATUS_RESUMEN_FLUJO_DIARIO		)
	
	-- ==============================================
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////