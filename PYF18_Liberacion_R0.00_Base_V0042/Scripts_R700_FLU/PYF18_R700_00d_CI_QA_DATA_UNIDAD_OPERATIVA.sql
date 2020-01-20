-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / CARGA INICIAL / DATA
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	16/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////

-- //////////////////////////////////////////////////////////////
-- SELECT * FROM	[dbo].[PLAN_GASTO] 


-- //////////////////////////////////////////////////////////////
-- // DROPs
-- //////////////////////////////////////////////////////////////




IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QA_DATA_UNIDAD_OPERATIVA]') AND type in (N'U'))
	DROP TABLE [dbo].[QA_DATA_UNIDAD_OPERATIVA]
GO





-- //////////////////////////////////////////////////////////////
-- // QA_DATA_UNIDAD_OPERATIVA
-- //////////////////////////////////////////////////////////////
-- SELECT * FROM [QA_DATA_UNIDAD_OPERATIVA]


CREATE TABLE [dbo].[QA_DATA_UNIDAD_OPERATIVA] (
	[K_UNIDAD_OPERATIVA]	[INT] NOT NULL,
	[FACTOR]				DECIMAL(19,4) DEFAULT 1
) ON [PRIMARY]
GO


-- //////////////////////////////////////////////////////////////


ALTER TABLE [dbo].[QA_DATA_UNIDAD_OPERATIVA]
	ADD CONSTRAINT [PK_QA_DATA_UNIDAD_OPERATIVA]
		PRIMARY KEY CLUSTERED ([K_UNIDAD_OPERATIVA])
GO



ALTER TABLE [dbo].[QA_DATA_UNIDAD_OPERATIVA] ADD 
	CONSTRAINT [FK_QA_DATA_UNIDAD_OPERATIVA_01] 
		FOREIGN KEY ( [K_UNIDAD_OPERATIVA] ) 
		REFERENCES [dbo].[UNIDAD_OPERATIVA] ( [K_UNIDAD_OPERATIVA] )
GO


-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]
GO


CREATE PROCEDURE [dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ========================================
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_FACTOR						DECIMAL(19,4)
AS
	
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_UNIDAD_OPERATIVA
							FROM	QA_DATA_UNIDAD_OPERATIVA
							WHERE	K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO QA_DATA_UNIDAD_OPERATIVA	
			(	K_UNIDAD_OPERATIVA,			FACTOR		)		
		VALUES	
			(	@PP_K_UNIDAD_OPERATIVA,		@PP_FACTOR	)
	ELSE
		UPDATE	QA_DATA_UNIDAD_OPERATIVA
		SET		FACTOR	= @PP_FACTOR
		WHERE	K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA

	-- =========================================================
GO



-- //////////////////////////////////////////////////////////////
-- SELECT * FROM QA_DATA_UNIDAD_OPERATIVA


-- ===============================================
SET NOCOUNT ON
-- ===============================================



-- ========================================= JAL
-- ============================================================
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	30, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	51, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	52, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	53, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	54, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	55, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	56, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	57, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	70, 1
GO

-- ========================================= CHIH
-- ============================================================
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	02, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	03, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	07, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	09, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	11, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	12, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	15, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	17, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	83, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	84, 1
GO

-- ========================================= CDMX
-- ============================================================
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	13, 2
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	18, 2
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	20, 2
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	21, 2
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	23, 2
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	24, 2
GO

-- ========================================= CEN
-- ============================================================
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	19, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	25, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	26, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	27, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	28, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	29, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	31, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	32, 1
GO

-- ========================================= SON
-- ============================================================
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	36, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	37, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	38, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	39, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	40, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	41, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	42, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	43, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	44, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	45, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	46, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	47, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	48, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	49, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	73, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	76, 1
GO



-- ========================================= SUR
-- ============================================================
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	59, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	60, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	61, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	62, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	63, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	64, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	65, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	67, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	71, 1
GO

-- ========================================= BJA
-- ============================================================
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	33, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	34, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	35, 1
EXECUTE	[dbo].[PG_CI_QA_DATA_UNIDAD_OPERATIVA]		0,0,0,	69, 1
GO


-- ===============================================
SET NOCOUNT OFF
-- ===============================================




-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////

