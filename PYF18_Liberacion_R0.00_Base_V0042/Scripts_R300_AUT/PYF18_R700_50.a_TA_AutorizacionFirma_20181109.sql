-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			AUTORIZACIONES / FLUJO FIRMAS
-- // OPERACION:		LIBERACION / TABLAS
-- //////////////////////////////////////////////////////////////
-- // Autor:			ALEX DE LA ROSA
-- // Fecha creación:	09/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FLUJO_FIRMA]') AND type in (N'U'))
	DROP TABLE [dbo].[FLUJO_FIRMA] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AUTORIZACION_FIRMA]') AND type in (N'U'))
	DROP TABLE [dbo].[AUTORIZACION_FIRMA] 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESTATUS_FIRMA]') AND type in (N'U'))
	DROP TABLE [dbo].[ESTATUS_FIRMA]
GO



-- ///////////////////////////////////////////////////////////////
-- //				ESTATUS_FIRMA				
-- ///////////////////////////////////////////////////////////////
			

CREATE TABLE [dbo].[ESTATUS_FIRMA] (
	[K_ESTATUS_FIRMA]			INT NOT NULL,
	[D_ESTATUS_FIRMA]			VARCHAR (100) NOT NULL,
	[S_ESTATUS_FIRMA]			VARCHAR (10) NOT NULL,
	[O_ESTATUS_FIRMA]			INT NOT NULL,
	[C_ESTATUS_FIRMA]			VARCHAR (255) NOT NULL,
	[L_ESTATUS_FIRMA]			INT NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[ESTATUS_FIRMA]
	ADD CONSTRAINT [PK_ESTATUS_FIRMA]
		PRIMARY KEY CLUSTERED ([K_ESTATUS_FIRMA])
GO


CREATE UNIQUE NONCLUSTERED 
	INDEX [UN_ESTATUS_FIRMA_01_DESCRIPCION] 
	   ON [dbo].[ESTATUS_FIRMA] ( [D_ESTATUS_FIRMA] )
GO


ALTER TABLE [dbo].[ESTATUS_FIRMA] ADD 
	CONSTRAINT [FK_ESTATUS_FIRMA_01] 
		FOREIGN KEY ( [L_ESTATUS_FIRMA] ) 
		REFERENCES [dbo].[ESTATUS_ACTIVO] ( [K_ESTATUS_ACTIVO] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_ESTATUS_FIRMA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_ESTATUS_FIRMA]
GO


CREATE PROCEDURE [dbo].[PG_CI_ESTATUS_FIRMA]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_ESTATUS_FIRMA		INT,
	@PP_D_ESTATUS_FIRMA		VARCHAR(100),
	@PP_S_ESTATUS_FIRMA		VARCHAR(10),
	@PP_O_ESTATUS_FIRMA		INT,
	@PP_C_ESTATUS_FIRMA		VARCHAR(255),
	@PP_L_ESTATUS_FIRMA		INT
AS
	
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_ESTATUS_FIRMA
							FROM	ESTATUS_FIRMA
							WHERE	K_ESTATUS_FIRMA=@PP_K_ESTATUS_FIRMA

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO ESTATUS_FIRMA
		(	K_ESTATUS_FIRMA,			D_ESTATUS_FIRMA, 
			S_ESTATUS_FIRMA,			O_ESTATUS_FIRMA,
			C_ESTATUS_FIRMA,
			L_ESTATUS_FIRMA			)		
		VALUES	
		(	@PP_K_ESTATUS_FIRMA,		@PP_D_ESTATUS_FIRMA,	
			@PP_S_ESTATUS_FIRMA,		@PP_O_ESTATUS_FIRMA,
			@PP_C_ESTATUS_FIRMA,
			@PP_L_ESTATUS_FIRMA		)
	ELSE
		UPDATE	ESTATUS_FIRMA
		SET		D_ESTATUS_FIRMA	= @PP_D_ESTATUS_FIRMA,	
				S_ESTATUS_FIRMA	= @PP_S_ESTATUS_FIRMA,			
				O_ESTATUS_FIRMA	= @PP_O_ESTATUS_FIRMA,
				C_ESTATUS_FIRMA	= @PP_C_ESTATUS_FIRMA,
				L_ESTATUS_FIRMA	= @PP_L_ESTATUS_FIRMA	
		WHERE	K_ESTATUS_FIRMA=@PP_K_ESTATUS_FIRMA

	-- =========================================================
GO

-- ///////////////////////////////////////////////////////////////


-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_ESTATUS_FIRMA] 0,0,0, 1, 'PENDIENTE',		'PENDI', 1, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_FIRMA] 0,0,0, 2, 'REVISION',		'REVSN', 2, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_FIRMA] 0,0,0, 3, 'AUTORIZADO',		'AUTOR', 3, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_FIRMA] 0,0,0, 4, 'RECHAZADO',		'RECHZ', 4, '', 1
EXECUTE [dbo].[PG_CI_ESTATUS_FIRMA] 0,0,0, 5, 'CANCELADO',		'CANCL', 5, '', 1 
GO


-- ===============================================
SET NOCOUNT OFF
-- ===============================================





-- ///////////////////////////////////////////////////////////////
-- // AUTORIZACION_FIRMA					
-- ///////////////////////////////////////////////////////////////
	

CREATE TABLE [dbo].[AUTORIZACION_FIRMA] (
	-- =============================== CONTROL
	[K_AUTORIZACION_FIRMA]				INT NOT NULL,
	[D_AUTORIZACION_FIRMA]				VARCHAR(100) NOT NULL,
	[S_AUTORIZACION_FIRMA]				VARCHAR(10) NOT NULL,
	[C_AUTORIZACION_FIRMA]				VARCHAR(500) NOT NULL,
	-- =============================== 
	[K_ESTATUS_FIRMA]					INT NOT NULL,
	[F_APERTURA]						DATE NULL,
	[F_CIERRE]							DATE NULL,
	-- =============================== 
	[L_AUTORIZACION_DIRECTA]			INT NOT NULL,
	[K_USUARIO_AUTORIZACION_DIRECTA]	INT NULL,
	-- =============================== 
	[K_AUTORIZACION]					INT NOT NULL,
	[K_UNIDAD_OPERATIVA]				INT NOT NULL,
	[K_TRANSACCION]						INT NOT NULL,
	[MONTO_AUTORIZAR]					DECIMAL(19,4) NOT NULL,
	[MONTO_AUTORIZADO]					DECIMAL(19,4) NOT NULL
) ON [PRIMARY]
GO

-- //////////////////////////////////////////////////////

ALTER TABLE [dbo].[AUTORIZACION_FIRMA]
	ADD CONSTRAINT [PK_AUTORIZACION_FIRMA]
		PRIMARY KEY CLUSTERED ([K_AUTORIZACION_FIRMA])
GO

-- //////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[AUTORIZACION_FIRMA] ADD 
	CONSTRAINT [FK_AUTORIZACION_FIRMA_01] 
		FOREIGN KEY ([K_ESTATUS_FIRMA]) 
		REFERENCES [dbo].[ESTATUS_FIRMA] ([K_ESTATUS_FIRMA]),
	CONSTRAINT [FK_AUTORIZACION_FIRMA_02] 
		FOREIGN KEY ([K_AUTORIZACION]) 
		REFERENCES [dbo].[AUTORIZACION] ([K_AUTORIZACION])
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[AUTORIZACION_FIRMA] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO



ALTER TABLE [dbo].[AUTORIZACION_FIRMA] ADD 
	CONSTRAINT [FK_AUTORIZACION_FIRMA_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_AUTORIZACION_FIRMA_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_AUTORIZACION_FIRMA_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO






-- ///////////////////////////////////////////////////////////////
-- // FLUJO_FIRMA				
-- ///////////////////////////////////////////////////////////////
	

CREATE TABLE [dbo].[FLUJO_FIRMA] (
	-- =============================== CONTROL
	[K_FLUJO_FIRMA]					INT NOT NULL,
	-- =============================== 
	[K_AUTORIZACION_FIRMA]			INT NOT NULL,
	[N_PASO]						INT NOT NULL,
	[K_MODO_AUTORIZACION]			INT NOT NULL	DEFAULT 0,
	[N_DIAS_FLUJO_FIRMA]			INT NOT NULL	DEFAULT 0,
	[K_ESTATUS_FIRMA]				INT NOT NULL,
	[L_PROCESAR]					INT NOT NULL	DEFAULT 0,
	-- =============================== 
	[K_ROL_AUTORIZACION_A]			INT NOT NULL	DEFAULT 0,
	[K_ROL_AUTORIZACION_B]			INT NOT NULL	DEFAULT 0,
	[K_ROL_AUTORIZACION_C]			INT NOT NULL	DEFAULT 0,
	-- =============================== 
	[K_USUARIO_FIRMA_A]				INT NOT NULL	DEFAULT 0,
	[K_USUARIO_FIRMA_B]				INT NOT NULL	DEFAULT 0,
	[K_USUARIO_FIRMA_C]				INT NOT NULL	DEFAULT 0,
	-- =============================== 	
	[K_ESTATUS_FIRMA_A]				INT NOT NULL,
	[K_ESTATUS_FIRMA_B]				INT NOT NULL,
	[K_ESTATUS_FIRMA_C]				INT NOT NULL,
	-- =============================== 
	[OBSERVACIONES_FIRMA_A]			VARCHAR(500) NOT NULL,
	[OBSERVACIONES_FIRMA_B]			VARCHAR(500) NOT NULL,
	[OBSERVACIONES_FIRMA_C]			VARCHAR(500) NOT NULL
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////


ALTER TABLE [dbo].[FLUJO_FIRMA]
	ADD CONSTRAINT [PK_FLUJO_FIRMA]
		PRIMARY KEY CLUSTERED ([K_FLUJO_FIRMA])
GO


-- //////////////////////////////////////////////////////


CREATE UNIQUE NONCLUSTERED 
	INDEX [IX_FLUJO_FIRMA_K_AUTORIZACION_FIRMA_N_PASO] 
	   ON [dbo].[FLUJO_FIRMA] ( [K_AUTORIZACION_FIRMA], [N_PASO] )
GO


-- //////////////////////////////////////////////////////



ALTER TABLE [dbo].[FLUJO_FIRMA] ADD 
	CONSTRAINT [FK_FLUJO_FIRMA_01] 
		FOREIGN KEY ([K_AUTORIZACION_FIRMA]) 
		REFERENCES [dbo].[AUTORIZACION_FIRMA] ([K_AUTORIZACION_FIRMA]),
	CONSTRAINT [FK_FLUJO_FIRMA_02] 
		FOREIGN KEY ([K_MODO_AUTORIZACION]) 
		REFERENCES [dbo].[MODO_AUTORIZACION] ([K_MODO_AUTORIZACION]),
	CONSTRAINT [FK_FLUJO_FIRMA_03] 
		FOREIGN KEY ([K_ESTATUS_FIRMA]) 
		REFERENCES [dbo].[ESTATUS_FIRMA] ([K_ESTATUS_FIRMA])
GO


-- //////////////////////////////////////////////////////



ALTER TABLE [dbo].[FLUJO_FIRMA] ADD 
	CONSTRAINT [FK_FLUJO_FIRMA_K_ROL_AUTORIZACION_A] 
		FOREIGN KEY (K_ROL_AUTORIZACION_A) 
		REFERENCES [dbo].ROL_AUTORIZACION (K_ROL_AUTORIZACION),
	CONSTRAINT [FK_FLUJO_FIRMA_K_ROL_AUTORIZACION_B] 
		FOREIGN KEY (K_ROL_AUTORIZACION_B) 
		REFERENCES [dbo].ROL_AUTORIZACION (K_ROL_AUTORIZACION),
	CONSTRAINT [FK_FLUJO_FIRMA_K_ROL_AUTORIZACION_C] 
		FOREIGN KEY (K_ROL_AUTORIZACION_C) 
		REFERENCES [dbo].ROL_AUTORIZACION (K_ROL_AUTORIZACION)
GO


-- //////////////////////////////////////////////////////



ALTER TABLE [dbo].[FLUJO_FIRMA] ADD 
	CONSTRAINT [FK_FLUJO_FIRMA_K_ESTATUS_FIRMA_A] 
		FOREIGN KEY (K_ESTATUS_FIRMA_A) 
		REFERENCES [dbo].ESTATUS_FIRMA (K_ESTATUS_FIRMA),
	CONSTRAINT [FK_FLUJO_FIRMA_K_ESTATUS_FIRMA_B] 
		FOREIGN KEY (K_ESTATUS_FIRMA_B) 
		REFERENCES [dbo].ESTATUS_FIRMA (K_ESTATUS_FIRMA),
	CONSTRAINT [FK_FLUJO_FIRMA_K_ESTATUS_FIRMA_C] 
		FOREIGN KEY (K_ESTATUS_FIRMA_C) 
		REFERENCES [dbo].ESTATUS_FIRMA (K_ESTATUS_FIRMA)
GO




-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[FLUJO_FIRMA] 
	ADD		[K_USUARIO_ALTA]				[INT] NOT NULL,
			[F_ALTA]						[DATETIME] NOT NULL,
			[K_USUARIO_CAMBIO]				[INT] NOT NULL,
			[F_CAMBIO]						[DATETIME] NOT NULL,
			[L_BORRADO]						[INT] NOT NULL,
			[K_USUARIO_BAJA]				[INT] NULL,
			[F_BAJA]						[DATETIME] NULL;
GO



ALTER TABLE [dbo].[FLUJO_FIRMA] ADD 
	CONSTRAINT [FK_FLUJO_FIRMA_USUARIO_ALTA]  
		FOREIGN KEY ([K_USUARIO_ALTA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_FLUJO_FIRMA_USUARIO_CAMBIO]  
		FOREIGN KEY ([K_USUARIO_CAMBIO]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO]),
	CONSTRAINT [FK_FLUJO_FIRMA_USUARIO_BAJA]  
		FOREIGN KEY ([K_USUARIO_BAJA]) 
		REFERENCES [dbo].[USUARIO] ([K_USUARIO])
GO







-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
