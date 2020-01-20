-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4				INT
AS

	UPDATE	[MR]
	SET		[MR].[VALOR_ACUMULADO] = (	[MR].[M01_VALOR] + [MR].[M02_VALOR] + [MR].[M03_VALOR] + [MR].[M04_VALOR] + [MR].[M05_VALOR] +
										[MR].[M06_VALOR] + [MR].[M07_VALOR] + [MR].[M08_VALOR] + [MR].[M09_VALOR] + [MR].[M10_VALOR] +
										[MR].[M11_VALOR] + [MR].[M12_VALOR]		)
	FROM	[DATA_N3_X_ME_D0M4] AS MR
	WHERE	[MR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[MR].[K_DATO_D0M4]=@PP_K_DATO_D0M4
	
	-- ================================================
GO



-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_FG_DATA_N3_DATO_ACUMULADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_FG_DATA_N3_DATO_ACUMULADO]
GO


CREATE PROCEDURE [dbo].[PG_FG_DATA_N3_DATO_ACUMULADO] 
		@PP_K_DOCUMENTO_D0M4		INT,
		@PP_K_DATO_D0M4				INT,
		@OU_VALOR					DECIMAL(19,4)		OUTPUT
AS 

	DECLARE @VP_COLUMNA		VARCHAR(50)

	SET		@VP_COLUMNA = 'VALOR_ACUMULADO'
	
	-- ===================

	DECLARE @VP_SQL		NVARCHAR(MAX) 
	
	SET		@VP_SQL =	'SELECT ' 
	SET		@VP_SQL =	@VP_SQL + ' @OU_VALOR = ' + @VP_COLUMNA
	SET		@VP_SQL =	@VP_SQL + ' FROM [DATA_N3_X_ME_D0M4] AS MR' 
	SET		@VP_SQL =	@VP_SQL + ' WHERE [MR].[K_DOCUMENTO_D0M4]=' + CONVERT(VARCHAR(100),@PP_K_DOCUMENTO_D0M4)
	SET		@VP_SQL =	@VP_SQL + ' AND   [MR].[K_DATO_D0M4]=' + CONVERT(VARCHAR(100),@PP_K_DATO_D0M4)

	-- ===============================

	DECLARE @VP_DEFINICION_PARAMETROS		NVARCHAR(500)
	
	SET		@VP_DEFINICION_PARAMETROS =		N'@OU_VALOR DECIMAL(19,4) OUTPUT'

	-- ===============================

	DECLARE @VP_VALOR		DECIMAL(19,4)

	EXECUTE sp_executesql	@VP_SQL, @VP_DEFINICION_PARAMETROS, 
							@OU_VALOR = @VP_VALOR		OUTPUT

	-- ===============================

    SET @OU_VALOR = @VP_VALOR

	-- ===============================
GO


-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_FG_DATA_N3_DATO_X_DIA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_FG_DATA_N3_DATO_X_DIA]
GO


CREATE PROCEDURE [dbo].[PG_FG_DATA_N3_DATO_X_DIA] 
		@PP_K_DOCUMENTO_D0M4		INT,
		@PP_K_DATO_D0M4				INT,
		@PP_N_DIA					INT,
		@OU_VALOR					DECIMAL(19,4)		OUTPUT
AS 

	DECLARE @VP_COLUMNA		VARCHAR(50)

	SET		@VP_COLUMNA = [dbo].[PG_FG_TEXTO_DIA] ( @PP_N_DIA )
	
	SET		@VP_COLUMNA = 'M'+@VP_COLUMNA+'_VALOR'

	-- ===================

	DECLARE @VP_SQL		NVARCHAR(MAX) 
	
	SET		@VP_SQL =	'SELECT ' 
	SET		@VP_SQL =	@VP_SQL + ' @OU_VALOR = ' + @VP_COLUMNA
	SET		@VP_SQL =	@VP_SQL + ' FROM [DATA_N3_X_ME_D0M4] AS MR' 
	SET		@VP_SQL =	@VP_SQL + ' WHERE [MR].[K_DOCUMENTO_D0M4]=' + CONVERT(VARCHAR(100),@PP_K_DOCUMENTO_D0M4)
	SET		@VP_SQL =	@VP_SQL + ' AND   [MR].[K_DATO_D0M4]=' + CONVERT(VARCHAR(100),@PP_K_DATO_D0M4)

	-- ===============================

	DECLARE @VP_DEFINICION_PARAMETROS		NVARCHAR(500)
	
	SET		@VP_DEFINICION_PARAMETROS =		N'@OU_VALOR DECIMAL(19,4) OUTPUT'

	-- ===============================

	DECLARE @VP_VALOR		DECIMAL(19,4)

	EXECUTE sp_executesql	@VP_SQL, @VP_DEFINICION_PARAMETROS, 
							@OU_VALOR = @VP_VALOR		OUTPUT

	-- ===============================

    SET @OU_VALOR = @VP_VALOR

	-- ===============================
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N3_01A_SUMAR_A_MAS_B]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N3_01A_SUMAR_A_MAS_B]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N3_01A_SUMAR_A_MAS_B]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	@PP_L_ACUMULAR				INT,
	@PP_K_DATO_D0M4_A			INT,
	@PP_K_DATO_D0M4_B			INT
AS

	UPDATE	[MR]
	SET		
	--		[MR].[MXX_VALOR] = ( [MA].[MXX_VALOR] + [MB].[MXX_VALOR] ),
	--		[MR].[MYY_VALOR] = ( [MA].[MYY_VALOR] + [MB].[MYY_VALOR] ),
	--		[MR].[MZZ_VALOR] = ( [MA].[MZZ_VALOR] + [MB].[MZZ_VALOR] ),		
			[MR].[M01_VALOR] = ( [MA].[M01_VALOR] + [MB].[M01_VALOR] ),
			[MR].[M02_VALOR] = ( [MA].[M02_VALOR] + [MB].[M02_VALOR] ),
			[MR].[M03_VALOR] = ( [MA].[M03_VALOR] + [MB].[M03_VALOR] ),
			[MR].[M04_VALOR] = ( [MA].[M04_VALOR] + [MB].[M04_VALOR] ),
			[MR].[M05_VALOR] = ( [MA].[M05_VALOR] + [MB].[M05_VALOR] ),
			[MR].[M06_VALOR] = ( [MA].[M06_VALOR] + [MB].[M06_VALOR] ),
			[MR].[M07_VALOR] = ( [MA].[M07_VALOR] + [MB].[M07_VALOR] ),
			[MR].[M08_VALOR] = ( [MA].[M08_VALOR] + [MB].[M08_VALOR] ),
			[MR].[M09_VALOR] = ( [MA].[M09_VALOR] + [MB].[M09_VALOR] ),
			[MR].[M10_VALOR] = ( [MA].[M10_VALOR] + [MB].[M10_VALOR] ),
			[MR].[M11_VALOR] = ( [MA].[M11_VALOR] + [MB].[M11_VALOR] ),
			[MR].[M12_VALOR] = ( [MA].[M12_VALOR] + [MB].[M12_VALOR] )	
	FROM	[DATA_N3_X_ME_D0M4] AS MR,
			[DATA_N3_X_ME_D0M4] AS MA, [DATA_N3_X_ME_D0M4] AS MB 
	WHERE	[MR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[MA].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[MB].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
			-- ===========================
	AND		[MR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO
	AND		[MA].[K_DATO_D0M4]=@PP_K_DATO_D0M4_A
	AND		[MB].[K_DATO_D0M4]=@PP_K_DATO_D0M4_B

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N3_02A_RESTAR_A_MENOS_B]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N3_02A_RESTAR_A_MENOS_B]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N3_02A_RESTAR_A_MENOS_B]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	@PP_L_ACUMULAR				INT,
	@PP_K_DATO_D0M4_A			INT,
	@PP_K_DATO_D0M4_B			INT
AS

	UPDATE	[MR]
	SET		
	--		[MR].[MXX_VALOR] = ( [MA].[MXX_VALOR] - [MB].[MXX_VALOR] ),
	--		[MR].[MYY_VALOR] = ( [MA].[MYY_VALOR] - [MB].[MYY_VALOR] ),
	--		[MR].[MZZ_VALOR] = ( [MA].[MZZ_VALOR] - [MB].[MZZ_VALOR] ),
			[MR].[M01_VALOR] = ( [MA].[M01_VALOR] - [MB].[M01_VALOR] ),
			[MR].[M02_VALOR] = ( [MA].[M02_VALOR] - [MB].[M02_VALOR] ),
			[MR].[M03_VALOR] = ( [MA].[M03_VALOR] - [MB].[M03_VALOR] ),
			[MR].[M04_VALOR] = ( [MA].[M04_VALOR] - [MB].[M04_VALOR] ),
			[MR].[M05_VALOR] = ( [MA].[M05_VALOR] - [MB].[M05_VALOR] ),
			[MR].[M06_VALOR] = ( [MA].[M06_VALOR] - [MB].[M06_VALOR] ),
			[MR].[M07_VALOR] = ( [MA].[M07_VALOR] - [MB].[M07_VALOR] ),
			[MR].[M08_VALOR] = ( [MA].[M08_VALOR] - [MB].[M08_VALOR] ),
			[MR].[M09_VALOR] = ( [MA].[M09_VALOR] - [MB].[M09_VALOR] ),
			[MR].[M10_VALOR] = ( [MA].[M10_VALOR] - [MB].[M10_VALOR] ),
			[MR].[M11_VALOR] = ( [MA].[M11_VALOR] - [MB].[M11_VALOR] ),
			[MR].[M12_VALOR] = ( [MA].[M12_VALOR] - [MB].[M12_VALOR] )
	FROM	[DATA_N3_X_ME_D0M4] AS MR,
			[DATA_N3_X_ME_D0M4] AS MA, [DATA_N3_X_ME_D0M4] AS MB 
	WHERE	[MR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[MA].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[MB].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
			-- ===========================
	AND		[MR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO
	AND		[MA].[K_DATO_D0M4]=@PP_K_DATO_D0M4_A
	AND		[MB].[K_DATO_D0M4]=@PP_K_DATO_D0M4_B

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N3_03A_MULTIPLICAR_A_X_B]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N3_03A_MULTIPLICAR_A_X_B]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N3_03A_MULTIPLICAR_A_X_B]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	@PP_L_ACUMULAR				INT,
	@PP_K_DATO_D0M4_A			INT,
	@PP_K_DATO_D0M4_B			INT
AS

	UPDATE	[MR]
	SET		
	--		[MR].[MXX_VALOR] = ( [MA].[MXX_VALOR] * [MB].[MXX_VALOR] ),
	--		[MR].[MYY_VALOR] = ( [MA].[MYY_VALOR] * [MB].[MYY_VALOR] ),
	--		[MR].[MZZ_VALOR] = ( [MA].[MZZ_VALOR] * [MB].[MZZ_VALOR] ),
			[MR].[M01_VALOR] = ( [MA].[M01_VALOR] * [MB].[M01_VALOR] ),
			[MR].[M02_VALOR] = ( [MA].[M02_VALOR] * [MB].[M02_VALOR] ),
			[MR].[M03_VALOR] = ( [MA].[M03_VALOR] * [MB].[M03_VALOR] ),
			[MR].[M04_VALOR] = ( [MA].[M04_VALOR] * [MB].[M04_VALOR] ),
			[MR].[M05_VALOR] = ( [MA].[M05_VALOR] * [MB].[M05_VALOR] ),
			[MR].[M06_VALOR] = ( [MA].[M06_VALOR] * [MB].[M06_VALOR] ),
			[MR].[M07_VALOR] = ( [MA].[M07_VALOR] * [MB].[M07_VALOR] ),
			[MR].[M08_VALOR] = ( [MA].[M08_VALOR] * [MB].[M08_VALOR] ),
			[MR].[M09_VALOR] = ( [MA].[M09_VALOR] * [MB].[M09_VALOR] ),
			[MR].[M10_VALOR] = ( [MA].[M10_VALOR] * [MB].[M10_VALOR] ),
			[MR].[M11_VALOR] = ( [MA].[M11_VALOR] * [MB].[M11_VALOR] ),
			[MR].[M12_VALOR] = ( [MA].[M12_VALOR] * [MB].[M12_VALOR] )
	FROM	[DATA_N3_X_ME_D0M4] AS MR,
			[DATA_N3_X_ME_D0M4] AS MA, [DATA_N3_X_ME_D0M4] AS MB 
	WHERE	[MR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[MA].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[MB].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
			-- ===========================
	AND		[MR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO
	AND		[MA].[K_DATO_D0M4]=@PP_K_DATO_D0M4_A
	AND		[MB].[K_DATO_D0M4]=@PP_K_DATO_D0M4_B

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO




-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N3_05A_ACUMULAR_MAS_A]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N3_05A_ACUMULAR_MAS_A]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N3_05A_ACUMULAR_MAS_A]
	@PP_K_DOCUMENTO_D0M4			INT,
	@PP_K_DATO_D0M4_RESULTADO		INT,
	@PP_L_ACUMULAR					INT,
	@PP_K_DATO_D0M4_A				INT
AS

	UPDATE	[MR]
	SET		
	--		[MR].[MXX_VALOR] = ( [MR].[MXX_VALOR] + [MA].[MXX_VALOR] ),
	--		[MR].[MYY_VALOR] = ( [MR].[MYY_VALOR] + [MA].[MYY_VALOR] ),
	--		[MR].[MZZ_VALOR] = ( [MR].[MZZ_VALOR] + [MA].[MZZ_VALOR] ),
			[MR].[M01_VALOR] = ( [MR].[M01_VALOR] + [MA].[M01_VALOR] ),
			[MR].[M02_VALOR] = ( [MR].[M02_VALOR] + [MA].[M02_VALOR] ),
			[MR].[M03_VALOR] = ( [MR].[M03_VALOR] + [MA].[M03_VALOR] ),
			[MR].[M04_VALOR] = ( [MR].[M04_VALOR] + [MA].[M04_VALOR] ),
			[MR].[M05_VALOR] = ( [MR].[M05_VALOR] + [MA].[M05_VALOR] ),
			[MR].[M06_VALOR] = ( [MR].[M06_VALOR] + [MA].[M06_VALOR] ),
			[MR].[M07_VALOR] = ( [MR].[M07_VALOR] + [MA].[M07_VALOR] ),
			[MR].[M08_VALOR] = ( [MR].[M08_VALOR] + [MA].[M08_VALOR] ),
			[MR].[M09_VALOR] = ( [MR].[M09_VALOR] + [MA].[M09_VALOR] ),
			[MR].[M10_VALOR] = ( [MR].[M10_VALOR] + [MA].[M10_VALOR] ),
			[MR].[M11_VALOR] = ( [MR].[M11_VALOR] + [MA].[M11_VALOR] ),
			[MR].[M12_VALOR] = ( [MR].[M12_VALOR] + [MA].[M12_VALOR] )
	FROM	[DATA_N3_X_ME_D0M4] AS MR,
			[DATA_N3_X_ME_D0M4] AS MA
	WHERE	[MR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[MA].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
			-- ===========================
	AND		[MR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO
	AND		[MA].[K_DATO_D0M4]=@PP_K_DATO_D0M4_A

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO



-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N3_05B_ACUMULAR_MENOS_A]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N3_05B_ACUMULAR_MENOS_A]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N3_05B_ACUMULAR_MENOS_A]
	@PP_K_DOCUMENTO_D0M4			INT,
	@PP_K_DATO_D0M4_RESULTADO		INT,
	@PP_L_ACUMULAR				INT,
	@PP_K_DATO_D0M4_A				INT
AS

	UPDATE	[MR]
	SET		
	--		[MR].[MXX_VALOR] = ( [MR].[MXX_VALOR] - [MA].[MXX_VALOR] ),
	--		[MR].[MYY_VALOR] = ( [MR].[MYY_VALOR] - [MA].[MYY_VALOR] ),
	--		[MR].[MZZ_VALOR] = ( [MR].[MZZ_VALOR] - [MA].[MZZ_VALOR] ),
			[MR].[M01_VALOR] = ( [MR].[M01_VALOR] - [MA].[M01_VALOR] ),
			[MR].[M02_VALOR] = ( [MR].[M02_VALOR] - [MA].[M02_VALOR] ),
			[MR].[M03_VALOR] = ( [MR].[M03_VALOR] - [MA].[M03_VALOR] ),
			[MR].[M04_VALOR] = ( [MR].[M04_VALOR] - [MA].[M04_VALOR] ),
			[MR].[M05_VALOR] = ( [MR].[M05_VALOR] - [MA].[M05_VALOR] ),
			[MR].[M06_VALOR] = ( [MR].[M06_VALOR] - [MA].[M06_VALOR] ),
			[MR].[M07_VALOR] = ( [MR].[M07_VALOR] - [MA].[M07_VALOR] ),
			[MR].[M08_VALOR] = ( [MR].[M08_VALOR] - [MA].[M08_VALOR] ),
			[MR].[M09_VALOR] = ( [MR].[M09_VALOR] - [MA].[M09_VALOR] ),
			[MR].[M10_VALOR] = ( [MR].[M10_VALOR] - [MA].[M10_VALOR] ),
			[MR].[M11_VALOR] = ( [MR].[M11_VALOR] - [MA].[M11_VALOR] ),
			[MR].[M12_VALOR] = ( [MR].[M12_VALOR] - [MA].[M12_VALOR] )
	FROM	[DATA_N3_X_ME_D0M4] AS MR,
			[DATA_N3_X_ME_D0M4] AS MA
	WHERE	[MR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[MA].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
			-- ===========================
	AND		[MR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO
	AND		[MA].[K_DATO_D0M4]=@PP_K_DATO_D0M4_A

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N3_10A_ASIGNAR_A]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N3_10A_ASIGNAR_A]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N3_10A_ASIGNAR_A]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	@PP_L_ACUMULAR				INT,
	@PP_K_DATO_D0M4_A			INT
AS

	UPDATE	[MR]
	SET		
	--		[MR].[MXX_VALOR] = ( [MA].[MXX_VALOR] ),
	--		[MR].[MYY_VALOR] = ( [MA].[MYY_VALOR] ),
	--		[MR].[MZZ_VALOR] = ( [MA].[MZZ_VALOR] ),
			[MR].[M01_VALOR] = ( [MA].[M01_VALOR] ),
			[MR].[M02_VALOR] = ( [MA].[M02_VALOR] ),
			[MR].[M03_VALOR] = ( [MA].[M03_VALOR] ),
			[MR].[M04_VALOR] = ( [MA].[M04_VALOR] ),
			[MR].[M05_VALOR] = ( [MA].[M05_VALOR] ),
			[MR].[M06_VALOR] = ( [MA].[M06_VALOR] ),
			[MR].[M07_VALOR] = ( [MA].[M07_VALOR] ),
			[MR].[M08_VALOR] = ( [MA].[M08_VALOR] ),
			[MR].[M09_VALOR] = ( [MA].[M09_VALOR] ),
			[MR].[M10_VALOR] = ( [MA].[M10_VALOR] ),
			[MR].[M11_VALOR] = ( [MA].[M11_VALOR] ),
			[MR].[M12_VALOR] = ( [MA].[M12_VALOR] )
	FROM	[DATA_N3_X_ME_D0M4] AS MR,
			[DATA_N3_X_ME_D0M4] AS MA 
	WHERE	[MR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[MA].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
			-- ===========================
	AND		[MR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO
	AND		[MA].[K_DATO_D0M4]=@PP_K_DATO_D0M4_A

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO




-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N3_10B_ASIGNAR_VALOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N3_10B_ASIGNAR_VALOR]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N3_10B_ASIGNAR_VALOR]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	@PP_L_ACUMULAR				INT,
	@PP_VALOR					DECIMAL(19,4)
AS

	UPDATE	[MR]
	SET		
	--		[MR].[MXX_VALOR] = ( @PP_VALOR ),
	--		[MR].[MYY_VALOR] = ( @PP_VALOR ),
	--		[MR].[MZZ_VALOR] = ( @PP_VALOR ),
			[MR].[M01_VALOR] = ( @PP_VALOR ),
			[MR].[M02_VALOR] = ( @PP_VALOR ),
			[MR].[M03_VALOR] = ( @PP_VALOR ),
			[MR].[M04_VALOR] = ( @PP_VALOR ),
			[MR].[M05_VALOR] = ( @PP_VALOR ),
			[MR].[M06_VALOR] = ( @PP_VALOR ),
			[MR].[M07_VALOR] = ( @PP_VALOR ),
			[MR].[M08_VALOR] = ( @PP_VALOR ),
			[MR].[M09_VALOR] = ( @PP_VALOR ),
			[MR].[M10_VALOR] = ( @PP_VALOR ),
			[MR].[M11_VALOR] = ( @PP_VALOR ),
			[MR].[M12_VALOR] = ( @PP_VALOR )
	FROM	[DATA_N3_X_ME_D0M4] AS MR 
	WHERE	[MR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[MR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO


-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N3_10B2_ASIGNAR_VALOR_X_DIA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N3_10B2_ASIGNAR_VALOR_X_DIA]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N3_10B2_ASIGNAR_VALOR_X_DIA]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	@PP_L_ACUMULAR				INT,
	@PP_VALOR					DECIMAL(19,4),
	@PP_N_DIA					INT
AS

	DECLARE @VP_COLUMNA		VARCHAR(50)

	SET		@VP_COLUMNA = [dbo].[PG_FG_TEXTO_DIA] ( @PP_N_DIA )
	
	SET		@VP_COLUMNA = 'D'+@VP_COLUMNA+'_VALOR'

	-- ===================

	DECLARE @VP_SQL		NVARCHAR(MAX) 
	
	SET @VP_SQL = ''
	SET @VP_SQL = @VP_SQL + 'UPDATE [MR] ' 
	SET @VP_SQL = @VP_SQL + ' SET'
	SET @VP_SQL = @VP_SQL + ' [MR].['+@VP_COLUMNA+'] = ( '+ CONVERT(VARCHAR(100),@PP_VALOR) + ' )'
	SET @VP_SQL = @VP_SQL + ' FROM	[DATA_N3_X_ME_D0M4] AS MR' 
	SET @VP_SQL = @VP_SQL + ' WHERE	[MR].[K_DOCUMENTO_D0M4]=' + CONVERT(VARCHAR(100),@PP_K_DOCUMENTO_D0M4)
	SET @VP_SQL = @VP_SQL + ' AND   [MR].[K_DATO_D0M4]=' + CONVERT(VARCHAR(100),@PP_K_DATO_D0M4_RESULTADO)

	EXECUTE sp_executesql @VP_SQL 

	-- ================================================
GO



-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
