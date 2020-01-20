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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_FG_TEXTO_DIA]') AND type in (N'F', N'FN'))
	DROP FUNCTION [dbo].[PG_FG_TEXTO_DIA]
GO

CREATE FUNCTION [dbo].[PG_FG_TEXTO_DIA] ( @PP_N_DIA INT )
RETURNS VARCHAR(100)
AS 
BEGIN

	
    DECLARE @VP_TEXTO_DIA	VARCHAR(250)
	
	IF @PP_N_DIA>0
		BEGIN
		SET @VP_TEXTO_DIA =		CONVERT(VARCHAR(50),@PP_N_DIA)
		SET @VP_TEXTO_DIA =		( '000' + @VP_TEXTO_DIA )
		SET @VP_TEXTO_DIA =		RIGHT(@VP_TEXTO_DIA,2)
		END
	ELSE
		IF @PP_N_DIA=0
			SET @VP_TEXTO_DIA =		'ZZ'
		ELSE
			IF @PP_N_DIA=-1
				SET @VP_TEXTO_DIA =		'YY'
			ELSE
				SET @VP_TEXTO_DIA =		'XX'

	-- =========================

    RETURN @VP_TEXTO_DIA
END
GO


-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4				INT
AS

	UPDATE	[DR]
	SET		[DR].[VALOR_ACUMULADO] = (	[DR].[D01_VALOR] + [DR].[D02_VALOR] + [DR].[D03_VALOR] + [DR].[D04_VALOR] + [DR].[D05_VALOR] +
										[DR].[D06_VALOR] + [DR].[D07_VALOR] + [DR].[D08_VALOR] + [DR].[D09_VALOR] + [DR].[D10_VALOR] +
										[DR].[D11_VALOR] + [DR].[D12_VALOR] + [DR].[D13_VALOR] + [DR].[D14_VALOR] + [DR].[D15_VALOR] +
										[DR].[D16_VALOR] + [DR].[D17_VALOR] + [DR].[D18_VALOR] + [DR].[D19_VALOR] + [DR].[D20_VALOR] +
										[DR].[D21_VALOR] + [DR].[D22_VALOR] + [DR].[D23_VALOR] + [DR].[D24_VALOR] + [DR].[D25_VALOR] +
										[DR].[D26_VALOR] + [DR].[D27_VALOR] + [DR].[D28_VALOR] + [DR].[D29_VALOR] + [DR].[D30_VALOR] +
										[DR].[D31_VALOR]		)
	FROM	[DATA_N1_X_DI_D0M4] AS DR
	WHERE	[DR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[DR].[K_DATO_D0M4]=@PP_K_DATO_D0M4
	
	-- ================================================
GO




-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_BADA_N1_NN_CLONAR_RENGLON]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_BADA_N1_NN_CLONAR_RENGLON]
GO


CREATE PROCEDURE [dbo].[PG_CA_BADA_N1_NN_CLONAR_RENGLON]
	@PP_K_DOCUMENTO_D0M4_FUENTE		INT,
	@PP_K_DATO_D0M4_FUENTE			INT,
	@PP_K_DOCUMENTO_D0M4_DESTINO	INT,
	@PP_K_DATO_D0M4_DESTINO			INT,
	@PP_L_ACUMULAR					INT
AS

	-- ========================================================
/*	WIWI // DEBUG
	PRINT	'DELETE // DESTINO'
	PRINT	@PP_K_DOCUMENTO_D0M4_DESTINO
	PRINT	@PP_K_DATO_D0M4_DESTINO
*/
	DELETE
	FROM	DATA_N1_X_DI_D0M4
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4_DESTINO
	AND		K_DATO_D0M4=@PP_K_DATO_D0M4_DESTINO
	
	-- ========================================================
/*	WIWI // DEBUG
	PRINT 'INSERT // FUENTE'
	PRINT	@PP_K_DOCUMENTO_D0M4_FUENTE
	PRINT	@PP_K_DATO_D0M4_FUENTE
*/
	INSERT INTO	DATA_N1_X_DI_D0M4
			(	[K_DOCUMENTO_D0M4],
				[K_DATO_D0M4],
				[VALOR_ACUMULADO],[D00_VALOR],[DXX_VALOR],[DYY_VALOR],[DZZ_VALOR],
				[D01_VALOR],[D02_VALOR],[D03_VALOR],[D04_VALOR],[D05_VALOR],[D06_VALOR],[D07_VALOR],[D08_VALOR],[D09_VALOR],[D10_VALOR],
				[D11_VALOR],[D12_VALOR],[D13_VALOR],[D14_VALOR],[D15_VALOR],[D16_VALOR],[D17_VALOR],[D18_VALOR],[D19_VALOR],[D20_VALOR],
				[D21_VALOR],[D22_VALOR],[D23_VALOR],[D24_VALOR],[D25_VALOR],[D26_VALOR],[D27_VALOR],[D28_VALOR],[D29_VALOR],[D30_VALOR],
				[D31_VALOR]			)
		SELECT	@PP_K_DOCUMENTO_D0M4_DESTINO,
				@PP_K_DATO_D0M4_DESTINO,
				[VALOR_ACUMULADO],[D00_VALOR],[DXX_VALOR],[DYY_VALOR],[DZZ_VALOR],
				[D01_VALOR],[D02_VALOR],[D03_VALOR],[D04_VALOR],[D05_VALOR],[D06_VALOR],[D07_VALOR],[D08_VALOR],[D09_VALOR],[D10_VALOR],
				[D11_VALOR],[D12_VALOR],[D13_VALOR],[D14_VALOR],[D15_VALOR],[D16_VALOR],[D17_VALOR],[D18_VALOR],[D19_VALOR],[D20_VALOR],
				[D21_VALOR],[D22_VALOR],[D23_VALOR],[D24_VALOR],[D25_VALOR],[D26_VALOR],[D27_VALOR],[D28_VALOR],[D29_VALOR],[D30_VALOR],
				[D31_VALOR]			
		FROM	DATA_N1_X_DI_D0M4
		WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4_FUENTE
		AND		K_DATO_D0M4=@PP_K_DATO_D0M4_FUENTE

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4_DESTINO, @PP_K_DATO_D0M4_DESTINO

	-- ================================================
GO



-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N1_10C_BORRAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N1_10C_BORRAR]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N1_10C_BORRAR]
	@PP_K_DOCUMENTO_D0M4			INT,
	@PP_K_DATO_D0M4_RESULTADO		INT,
	@PP_L_ACUMULAR					INT
AS
	
	UPDATE	[DR]
	SET		
			[DR].[DXX_VALOR] = ( 0 ),
			[DR].[DYY_VALOR] = ( 0 ),
			[DR].[DZZ_VALOR] = ( 0 ),
											
			-- WIWI				
								
			[DR].[D01_VALOR] = ( 0 ),
			[DR].[D02_VALOR] = ( 0 ),
			[DR].[D03_VALOR] = ( 0 ),
			[DR].[D04_VALOR] = ( 0 ),
			[DR].[D05_VALOR] = ( 0 ),
			[DR].[D06_VALOR] = ( 0 ),
			[DR].[D07_VALOR] = ( 0 ),
			[DR].[D08_VALOR] = ( 0 ),
			[DR].[D09_VALOR] = ( 0 ),
			[DR].[D10_VALOR] = ( 0 ),
			[DR].[D11_VALOR] = ( 0 ),
			[DR].[D12_VALOR] = ( 0 ),
			[DR].[D13_VALOR] = ( 0 ),
			[DR].[D14_VALOR] = ( 0 ),
			[DR].[D15_VALOR] = ( 0 ),
			[DR].[D16_VALOR] = ( 0 ),
			[DR].[D17_VALOR] = ( 0 ),
			[DR].[D18_VALOR] = ( 0 ),
			[DR].[D19_VALOR] = ( 0 ),
			[DR].[D20_VALOR] = ( 0 ),
			[DR].[D21_VALOR] = ( 0 ),
			[DR].[D22_VALOR] = ( 0 ),
			[DR].[D23_VALOR] = ( 0 ),
			[DR].[D24_VALOR] = ( 0 ),
			[DR].[D25_VALOR] = ( 0 ),
			[DR].[D26_VALOR] = ( 0 ),
			[DR].[D27_VALOR] = ( 0 ),
			[DR].[D28_VALOR] = ( 0 ),
			[DR].[D29_VALOR] = ( 0 ),
			[DR].[D30_VALOR] = ( 0 ),
			[DR].[D31_VALOR] = ( 0 )
	FROM	[DATA_N1_X_DI_D0M4] AS DR
	WHERE	[DR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[DR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO



-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N1_05A_ACUMULAR_MAS_A]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N1_05A_ACUMULAR_MAS_A]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N1_05A_ACUMULAR_MAS_A]
	@PP_K_DOCUMENTO_D0M4			INT,
	@PP_K_DATO_D0M4_RESULTADO		INT,
	@PP_L_ACUMULAR					INT,
	@PP_K_DATO_D0M4_A				INT
AS
	
	UPDATE	[DR]
	SET		
			[DR].[DXX_VALOR] = ( [DR].[DXX_VALOR] + [DA].[DXX_VALOR] ),
			[DR].[DYY_VALOR] = ( [DR].[DYY_VALOR] + [DA].[DYY_VALOR] ),
			[DR].[DZZ_VALOR] = ( [DR].[DZZ_VALOR] + [DA].[DZZ_VALOR] ),
												  
			-- WIWI								  
												  
			[DR].[D01_VALOR] = ( [DR].[D01_VALOR] + [DA].[D01_VALOR] ),
			[DR].[D02_VALOR] = ( [DR].[D02_VALOR] + [DA].[D02_VALOR] ),
			[DR].[D03_VALOR] = ( [DR].[D03_VALOR] + [DA].[D03_VALOR] ),
			[DR].[D04_VALOR] = ( [DR].[D04_VALOR] + [DA].[D04_VALOR] ),
			[DR].[D05_VALOR] = ( [DR].[D05_VALOR] + [DA].[D05_VALOR] ),
			[DR].[D06_VALOR] = ( [DR].[D06_VALOR] + [DA].[D06_VALOR] ),
			[DR].[D07_VALOR] = ( [DR].[D07_VALOR] + [DA].[D07_VALOR] ),
			[DR].[D08_VALOR] = ( [DR].[D08_VALOR] + [DA].[D08_VALOR] ),
			[DR].[D09_VALOR] = ( [DR].[D09_VALOR] + [DA].[D09_VALOR] ),
			[DR].[D10_VALOR] = ( [DR].[D10_VALOR] + [DA].[D10_VALOR] ),
			[DR].[D11_VALOR] = ( [DR].[D11_VALOR] + [DA].[D11_VALOR] ),
			[DR].[D12_VALOR] = ( [DR].[D12_VALOR] + [DA].[D12_VALOR] ),
			[DR].[D13_VALOR] = ( [DR].[D13_VALOR] + [DA].[D13_VALOR] ),
			[DR].[D14_VALOR] = ( [DR].[D14_VALOR] + [DA].[D14_VALOR] ),
			[DR].[D15_VALOR] = ( [DR].[D15_VALOR] + [DA].[D15_VALOR] ),
			[DR].[D16_VALOR] = ( [DR].[D16_VALOR] + [DA].[D16_VALOR] ),
			[DR].[D17_VALOR] = ( [DR].[D17_VALOR] + [DA].[D17_VALOR] ),
			[DR].[D18_VALOR] = ( [DR].[D18_VALOR] + [DA].[D18_VALOR] ),
			[DR].[D19_VALOR] = ( [DR].[D19_VALOR] + [DA].[D19_VALOR] ),
			[DR].[D20_VALOR] = ( [DR].[D20_VALOR] + [DA].[D20_VALOR] ),
			[DR].[D21_VALOR] = ( [DR].[D21_VALOR] + [DA].[D21_VALOR] ),
			[DR].[D22_VALOR] = ( [DR].[D22_VALOR] + [DA].[D22_VALOR] ),
			[DR].[D23_VALOR] = ( [DR].[D23_VALOR] + [DA].[D23_VALOR] ),
			[DR].[D24_VALOR] = ( [DR].[D24_VALOR] + [DA].[D24_VALOR] ),
			[DR].[D25_VALOR] = ( [DR].[D25_VALOR] + [DA].[D25_VALOR] ),
			[DR].[D26_VALOR] = ( [DR].[D26_VALOR] + [DA].[D26_VALOR] ),
			[DR].[D27_VALOR] = ( [DR].[D27_VALOR] + [DA].[D27_VALOR] ),
			[DR].[D28_VALOR] = ( [DR].[D28_VALOR] + [DA].[D28_VALOR] ),
			[DR].[D29_VALOR] = ( [DR].[D29_VALOR] + [DA].[D29_VALOR] ),
			[DR].[D30_VALOR] = ( [DR].[D30_VALOR] + [DA].[D30_VALOR] ),
			[DR].[D31_VALOR] = ( [DR].[D31_VALOR] + [DA].[D31_VALOR] )
	FROM	[DATA_N1_X_DI_D0M4] AS DR,
			[DATA_N1_X_DI_D0M4] AS DA
	WHERE	[DR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[DA].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
			-- ===========================
	AND		[DR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO
	AND		[DA].[K_DATO_D0M4]=@PP_K_DATO_D0M4_A

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO





-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_FG_DATA_N1_DATO_ACUMULADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_FG_DATA_N1_DATO_ACUMULADO]
GO


CREATE PROCEDURE [dbo].[PG_FG_DATA_N1_DATO_ACUMULADO] 
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
	SET		@VP_SQL =	@VP_SQL + ' FROM [DATA_N1_X_DI_D0M4] AS DR' 
	SET		@VP_SQL =	@VP_SQL + ' WHERE [DR].[K_DOCUMENTO_D0M4]=' + CONVERT(VARCHAR(100),@PP_K_DOCUMENTO_D0M4)
	SET		@VP_SQL =	@VP_SQL + ' AND   [DR].[K_DATO_D0M4]=' + CONVERT(VARCHAR(100),@PP_K_DATO_D0M4)

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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_FG_DATA_N1_DATO_X_DIA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_FG_DATA_N1_DATO_X_DIA]
GO


CREATE PROCEDURE [dbo].[PG_FG_DATA_N1_DATO_X_DIA] 
		@PP_K_DOCUMENTO_D0M4		INT,
		@PP_K_DATO_D0M4				INT,
		@PP_N_DIA					INT,
		@OU_VALOR					DECIMAL(19,4)		OUTPUT
AS 

	DECLARE @VP_COLUMNA		VARCHAR(50)

	IF @PP_N_DIA= 99
		SET		@VP_COLUMNA = 'VALOR_ACUMULADO'
	ELSE
		BEGIN
	
		SET		@VP_COLUMNA = [dbo].[PG_FG_TEXTO_DIA] ( @PP_N_DIA )
	
		SET		@VP_COLUMNA = 'D'+@VP_COLUMNA+'_VALOR'
	
		END

	-- ===================

	DECLARE @VP_SQL		NVARCHAR(MAX) 
	
	SET		@VP_SQL =	'SELECT ' 
	SET		@VP_SQL =	@VP_SQL + ' @OU_VALOR = ' + @VP_COLUMNA
	SET		@VP_SQL =	@VP_SQL + ' FROM [DATA_N1_X_DI_D0M4] AS DR' 
	SET		@VP_SQL =	@VP_SQL + ' WHERE [DR].[K_DOCUMENTO_D0M4]=' + CONVERT(VARCHAR(100),@PP_K_DOCUMENTO_D0M4)
	SET		@VP_SQL =	@VP_SQL + ' AND   [DR].[K_DATO_D0M4]=' + CONVERT(VARCHAR(100),@PP_K_DATO_D0M4)

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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N1_01A_SUMAR_A_MAS_B]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N1_01A_SUMAR_A_MAS_B]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N1_01A_SUMAR_A_MAS_B]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	@PP_L_ACUMULAR				INT,
	@PP_K_DATO_D0M4_A			INT,
	@PP_K_DATO_D0M4_B			INT
AS

	UPDATE	[DR]
	SET		
			[DR].[DXX_VALOR] = ( [DA].[DXX_VALOR] + [DB].[DXX_VALOR] ),
			[DR].[DYY_VALOR] = ( [DA].[DYY_VALOR] + [DB].[DYY_VALOR] ),
			[DR].[DZZ_VALOR] = ( [DA].[DZZ_VALOR] + [DB].[DZZ_VALOR] ),

			-- WIWI
			
			[DR].[D01_VALOR] = ( [DA].[D01_VALOR] + [DB].[D01_VALOR] ),
			[DR].[D02_VALOR] = ( [DA].[D02_VALOR] + [DB].[D02_VALOR] ),
			[DR].[D03_VALOR] = ( [DA].[D03_VALOR] + [DB].[D03_VALOR] ),
			[DR].[D04_VALOR] = ( [DA].[D04_VALOR] + [DB].[D04_VALOR] ),
			[DR].[D05_VALOR] = ( [DA].[D05_VALOR] + [DB].[D05_VALOR] ),
			[DR].[D06_VALOR] = ( [DA].[D06_VALOR] + [DB].[D06_VALOR] ),
			[DR].[D07_VALOR] = ( [DA].[D07_VALOR] + [DB].[D07_VALOR] ),
			[DR].[D08_VALOR] = ( [DA].[D08_VALOR] + [DB].[D08_VALOR] ),
			[DR].[D09_VALOR] = ( [DA].[D09_VALOR] + [DB].[D09_VALOR] ),
			[DR].[D10_VALOR] = ( [DA].[D10_VALOR] + [DB].[D10_VALOR] ),
			[DR].[D11_VALOR] = ( [DA].[D11_VALOR] + [DB].[D11_VALOR] ),
			[DR].[D12_VALOR] = ( [DA].[D12_VALOR] + [DB].[D12_VALOR] ),
			[DR].[D13_VALOR] = ( [DA].[D13_VALOR] + [DB].[D13_VALOR] ),
			[DR].[D14_VALOR] = ( [DA].[D14_VALOR] + [DB].[D14_VALOR] ),
			[DR].[D15_VALOR] = ( [DA].[D15_VALOR] + [DB].[D15_VALOR] ),
			[DR].[D16_VALOR] = ( [DA].[D16_VALOR] + [DB].[D16_VALOR] ),
			[DR].[D17_VALOR] = ( [DA].[D17_VALOR] + [DB].[D17_VALOR] ),
			[DR].[D18_VALOR] = ( [DA].[D18_VALOR] + [DB].[D18_VALOR] ),
			[DR].[D19_VALOR] = ( [DA].[D19_VALOR] + [DB].[D19_VALOR] ),
			[DR].[D20_VALOR] = ( [DA].[D20_VALOR] + [DB].[D20_VALOR] ),
			[DR].[D21_VALOR] = ( [DA].[D21_VALOR] + [DB].[D21_VALOR] ),
			[DR].[D22_VALOR] = ( [DA].[D22_VALOR] + [DB].[D22_VALOR] ),
			[DR].[D23_VALOR] = ( [DA].[D23_VALOR] + [DB].[D23_VALOR] ),
			[DR].[D24_VALOR] = ( [DA].[D24_VALOR] + [DB].[D24_VALOR] ),
			[DR].[D25_VALOR] = ( [DA].[D25_VALOR] + [DB].[D25_VALOR] ),
			[DR].[D26_VALOR] = ( [DA].[D26_VALOR] + [DB].[D26_VALOR] ),
			[DR].[D27_VALOR] = ( [DA].[D27_VALOR] + [DB].[D27_VALOR] ),
			[DR].[D28_VALOR] = ( [DA].[D28_VALOR] + [DB].[D28_VALOR] ),
			[DR].[D29_VALOR] = ( [DA].[D29_VALOR] + [DB].[D29_VALOR] ),
			[DR].[D30_VALOR] = ( [DA].[D30_VALOR] + [DB].[D30_VALOR] ),
			[DR].[D31_VALOR] = ( [DA].[D31_VALOR] + [DB].[D31_VALOR] )
	FROM	[DATA_N1_X_DI_D0M4] AS DR,
			[DATA_N1_X_DI_D0M4] AS DA, [DATA_N1_X_DI_D0M4] AS DB 
	WHERE	[DR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[DA].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[DB].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
			-- ===========================
	AND		[DR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO
	AND		[DA].[K_DATO_D0M4]=@PP_K_DATO_D0M4_A
	AND		[DB].[K_DATO_D0M4]=@PP_K_DATO_D0M4_B

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO




-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N1_01C_SUMAR_RANGO_D1_D9]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N1_01C_SUMAR_RANGO_D1_D9]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N1_01C_SUMAR_RANGO_D1_D9]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	@PP_L_ACUMULAR				INT,
	@PP_K_DATO_D0M4_1			INT,
	@PP_K_DATO_D0M4_2			INT,
	@PP_K_DATO_D0M4_3			INT = NULL,
	@PP_K_DATO_D0M4_4			INT = NULL,
	@PP_K_DATO_D0M4_5			INT = NULL,
	@PP_K_DATO_D0M4_6			INT = NULL,
	@PP_K_DATO_D0M4_7			INT = NULL,
	@PP_K_DATO_D0M4_8			INT = NULL,
	@PP_K_DATO_D0M4_9			INT = NULL
AS

	EXECUTE [PG_CA_MATE_N1_10C_BORRAR]		@PP_K_DOCUMENTO_D0M4,	@PP_K_DATO_D0M4_RESULTADO,0 
	
	-- ================================================
	
	EXECUTE	[dbo].[PG_CA_MATE_N1_01A_SUMAR_A_MAS_B]		@PP_K_DOCUMENTO_D0M4,
														@PP_K_DATO_D0M4_RESULTADO, 0,
														@PP_K_DATO_D0M4_1, @PP_K_DATO_D0M4_2
	-- ================================================

	IF NOT ( @PP_K_DATO_D0M4_3 IS NULL )
		EXECUTE [PG_CA_MATE_N1_05A_ACUMULAR_MAS_A]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO, 0, @PP_K_DATO_D0M4_3

	IF NOT ( @PP_K_DATO_D0M4_4 IS NULL )
		EXECUTE [PG_CA_MATE_N1_05A_ACUMULAR_MAS_A]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO, 0, @PP_K_DATO_D0M4_4

	IF NOT ( @PP_K_DATO_D0M4_5 IS NULL )
		EXECUTE [PG_CA_MATE_N1_05A_ACUMULAR_MAS_A]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO, 0, @PP_K_DATO_D0M4_5

	IF NOT ( @PP_K_DATO_D0M4_6 IS NULL )
		EXECUTE [PG_CA_MATE_N1_05A_ACUMULAR_MAS_A]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO, 0, @PP_K_DATO_D0M4_6

	IF NOT ( @PP_K_DATO_D0M4_7 IS NULL )
		EXECUTE [PG_CA_MATE_N1_05A_ACUMULAR_MAS_A]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO, 0, @PP_K_DATO_D0M4_7

	IF NOT ( @PP_K_DATO_D0M4_8 IS NULL )
		EXECUTE [PG_CA_MATE_N1_05A_ACUMULAR_MAS_A]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO, 0, @PP_K_DATO_D0M4_8

	IF NOT ( @PP_K_DATO_D0M4_9 IS NULL )
		EXECUTE [PG_CA_MATE_N1_05A_ACUMULAR_MAS_A]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO, 0, @PP_K_DATO_D0M4_9

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N1_02A_RESTAR_A_MENOS_B]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N1_02A_RESTAR_A_MENOS_B]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N1_02A_RESTAR_A_MENOS_B]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	@PP_L_ACUMULAR				INT,
	@PP_K_DATO_D0M4_A			INT,
	@PP_K_DATO_D0M4_B			INT
AS

	UPDATE	[DR]
	SET		
			[DR].[DXX_VALOR] = ( [DA].[DXX_VALOR] - [DB].[DXX_VALOR] ),
			[DR].[DYY_VALOR] = ( [DA].[DYY_VALOR] - [DB].[DYY_VALOR] ),
			[DR].[DZZ_VALOR] = ( [DA].[DZZ_VALOR] - [DB].[DZZ_VALOR] ),

			-- WIWI

			[DR].[D01_VALOR] = ( [DA].[D01_VALOR] - [DB].[D01_VALOR] ),
			[DR].[D02_VALOR] = ( [DA].[D02_VALOR] - [DB].[D02_VALOR] ),
			[DR].[D03_VALOR] = ( [DA].[D03_VALOR] - [DB].[D03_VALOR] ),
			[DR].[D04_VALOR] = ( [DA].[D04_VALOR] - [DB].[D04_VALOR] ),
			[DR].[D05_VALOR] = ( [DA].[D05_VALOR] - [DB].[D05_VALOR] ),
			[DR].[D06_VALOR] = ( [DA].[D06_VALOR] - [DB].[D06_VALOR] ),
			[DR].[D07_VALOR] = ( [DA].[D07_VALOR] - [DB].[D07_VALOR] ),
			[DR].[D08_VALOR] = ( [DA].[D08_VALOR] - [DB].[D08_VALOR] ),
			[DR].[D09_VALOR] = ( [DA].[D09_VALOR] - [DB].[D09_VALOR] ),
			[DR].[D10_VALOR] = ( [DA].[D10_VALOR] - [DB].[D10_VALOR] ),
			[DR].[D11_VALOR] = ( [DA].[D11_VALOR] - [DB].[D11_VALOR] ),
			[DR].[D12_VALOR] = ( [DA].[D12_VALOR] - [DB].[D12_VALOR] ),
			[DR].[D13_VALOR] = ( [DA].[D13_VALOR] - [DB].[D13_VALOR] ),
			[DR].[D14_VALOR] = ( [DA].[D14_VALOR] - [DB].[D14_VALOR] ),
			[DR].[D15_VALOR] = ( [DA].[D15_VALOR] - [DB].[D15_VALOR] ),
			[DR].[D16_VALOR] = ( [DA].[D16_VALOR] - [DB].[D16_VALOR] ),
			[DR].[D17_VALOR] = ( [DA].[D17_VALOR] - [DB].[D17_VALOR] ),
			[DR].[D18_VALOR] = ( [DA].[D18_VALOR] - [DB].[D18_VALOR] ),
			[DR].[D19_VALOR] = ( [DA].[D19_VALOR] - [DB].[D19_VALOR] ),
			[DR].[D20_VALOR] = ( [DA].[D20_VALOR] - [DB].[D20_VALOR] ),
			[DR].[D21_VALOR] = ( [DA].[D21_VALOR] - [DB].[D21_VALOR] ),
			[DR].[D22_VALOR] = ( [DA].[D22_VALOR] - [DB].[D22_VALOR] ),
			[DR].[D23_VALOR] = ( [DA].[D23_VALOR] - [DB].[D23_VALOR] ),
			[DR].[D24_VALOR] = ( [DA].[D24_VALOR] - [DB].[D24_VALOR] ),
			[DR].[D25_VALOR] = ( [DA].[D25_VALOR] - [DB].[D25_VALOR] ),
			[DR].[D26_VALOR] = ( [DA].[D26_VALOR] - [DB].[D26_VALOR] ),
			[DR].[D27_VALOR] = ( [DA].[D27_VALOR] - [DB].[D27_VALOR] ),
			[DR].[D28_VALOR] = ( [DA].[D28_VALOR] - [DB].[D28_VALOR] ),
			[DR].[D29_VALOR] = ( [DA].[D29_VALOR] - [DB].[D29_VALOR] ),
			[DR].[D30_VALOR] = ( [DA].[D30_VALOR] - [DB].[D30_VALOR] ),
			[DR].[D31_VALOR] = ( [DA].[D31_VALOR] - [DB].[D31_VALOR] )
	FROM	[DATA_N1_X_DI_D0M4] AS DR,
			[DATA_N1_X_DI_D0M4] AS DA, [DATA_N1_X_DI_D0M4] AS DB 
	WHERE	[DR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[DA].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[DB].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
			-- ===========================
	AND		[DR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO
	AND		[DA].[K_DATO_D0M4]=@PP_K_DATO_D0M4_A
	AND		[DB].[K_DATO_D0M4]=@PP_K_DATO_D0M4_B

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N1_03A_MULTIPLICAR_A_X_B]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N1_03A_MULTIPLICAR_A_X_B]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N1_03A_MULTIPLICAR_A_X_B]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	@PP_L_ACUMULAR				INT,
	@PP_K_DATO_D0M4_A			INT,
	@PP_K_DATO_D0M4_B			INT
AS

	UPDATE	[DR]
	SET		
			[DR].[DXX_VALOR] = ( [DA].[DXX_VALOR] * [DB].[DXX_VALOR] ),
			[DR].[DYY_VALOR] = ( [DA].[DYY_VALOR] * [DB].[DYY_VALOR] ),
			[DR].[DZZ_VALOR] = ( [DA].[DZZ_VALOR] * [DB].[DZZ_VALOR] ),

			-- WIWI 

			[DR].[D01_VALOR] = ( [DA].[D01_VALOR] * [DB].[D01_VALOR] ),
			[DR].[D02_VALOR] = ( [DA].[D02_VALOR] * [DB].[D02_VALOR] ),
			[DR].[D03_VALOR] = ( [DA].[D03_VALOR] * [DB].[D03_VALOR] ),
			[DR].[D04_VALOR] = ( [DA].[D04_VALOR] * [DB].[D04_VALOR] ),
			[DR].[D05_VALOR] = ( [DA].[D05_VALOR] * [DB].[D05_VALOR] ),
			[DR].[D06_VALOR] = ( [DA].[D06_VALOR] * [DB].[D06_VALOR] ),
			[DR].[D07_VALOR] = ( [DA].[D07_VALOR] * [DB].[D07_VALOR] ),
			[DR].[D08_VALOR] = ( [DA].[D08_VALOR] * [DB].[D08_VALOR] ),
			[DR].[D09_VALOR] = ( [DA].[D09_VALOR] * [DB].[D09_VALOR] ),
			[DR].[D10_VALOR] = ( [DA].[D10_VALOR] * [DB].[D10_VALOR] ),
			[DR].[D11_VALOR] = ( [DA].[D11_VALOR] * [DB].[D11_VALOR] ),
			[DR].[D12_VALOR] = ( [DA].[D12_VALOR] * [DB].[D12_VALOR] ),
			[DR].[D13_VALOR] = ( [DA].[D13_VALOR] * [DB].[D13_VALOR] ),
			[DR].[D14_VALOR] = ( [DA].[D14_VALOR] * [DB].[D14_VALOR] ),
			[DR].[D15_VALOR] = ( [DA].[D15_VALOR] * [DB].[D15_VALOR] ),
			[DR].[D16_VALOR] = ( [DA].[D16_VALOR] * [DB].[D16_VALOR] ),
			[DR].[D17_VALOR] = ( [DA].[D17_VALOR] * [DB].[D17_VALOR] ),
			[DR].[D18_VALOR] = ( [DA].[D18_VALOR] * [DB].[D18_VALOR] ),
			[DR].[D19_VALOR] = ( [DA].[D19_VALOR] * [DB].[D19_VALOR] ),
			[DR].[D20_VALOR] = ( [DA].[D20_VALOR] * [DB].[D20_VALOR] ),
			[DR].[D21_VALOR] = ( [DA].[D21_VALOR] * [DB].[D21_VALOR] ),
			[DR].[D22_VALOR] = ( [DA].[D22_VALOR] * [DB].[D22_VALOR] ),
			[DR].[D23_VALOR] = ( [DA].[D23_VALOR] * [DB].[D23_VALOR] ),
			[DR].[D24_VALOR] = ( [DA].[D24_VALOR] * [DB].[D24_VALOR] ),
			[DR].[D25_VALOR] = ( [DA].[D25_VALOR] * [DB].[D25_VALOR] ),
			[DR].[D26_VALOR] = ( [DA].[D26_VALOR] * [DB].[D26_VALOR] ),
			[DR].[D27_VALOR] = ( [DA].[D27_VALOR] * [DB].[D27_VALOR] ),
			[DR].[D28_VALOR] = ( [DA].[D28_VALOR] * [DB].[D28_VALOR] ),
			[DR].[D29_VALOR] = ( [DA].[D29_VALOR] * [DB].[D29_VALOR] ),
			[DR].[D30_VALOR] = ( [DA].[D30_VALOR] * [DB].[D30_VALOR] ),
			[DR].[D31_VALOR] = ( [DA].[D31_VALOR] * [DB].[D31_VALOR] )
	FROM	[DATA_N1_X_DI_D0M4] AS DR,
			[DATA_N1_X_DI_D0M4] AS DA, [DATA_N1_X_DI_D0M4] AS DB 
	WHERE	[DR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[DA].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[DB].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
			-- ===========================
	AND		[DR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO
	AND		[DA].[K_DATO_D0M4]=@PP_K_DATO_D0M4_A
	AND		[DB].[K_DATO_D0M4]=@PP_K_DATO_D0M4_B

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO



-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N1_03B_MULTIPLICAR_X_VALOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N1_03B_MULTIPLICAR_X_VALOR]
GO

CREATE PROCEDURE [dbo].[PG_CA_MATE_N1_03B_MULTIPLICAR_X_VALOR]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	@PP_L_ACUMULAR				INT,
	@PP_VALOR					DECIMAL(19,4) 
AS

	UPDATE	[DR]
	SET		
			[DR].[DXX_VALOR] = ( [DR].[DXX_VALOR] * @PP_VALOR ),
			[DR].[DYY_VALOR] = ( [DR].[DYY_VALOR] * @PP_VALOR ),
			[DR].[DZZ_VALOR] = ( [DR].[DZZ_VALOR] * @PP_VALOR ),
													
			-- WIWI 								
												
			[DR].[D01_VALOR] = ( [DR].[D01_VALOR] * @PP_VALOR ),
			[DR].[D02_VALOR] = ( [DR].[D02_VALOR] * @PP_VALOR ),
			[DR].[D03_VALOR] = ( [DR].[D03_VALOR] * @PP_VALOR ),
			[DR].[D04_VALOR] = ( [DR].[D04_VALOR] * @PP_VALOR ),
			[DR].[D05_VALOR] = ( [DR].[D05_VALOR] * @PP_VALOR ),
			[DR].[D06_VALOR] = ( [DR].[D06_VALOR] * @PP_VALOR ),
			[DR].[D07_VALOR] = ( [DR].[D07_VALOR] * @PP_VALOR ),
			[DR].[D08_VALOR] = ( [DR].[D08_VALOR] * @PP_VALOR ),
			[DR].[D09_VALOR] = ( [DR].[D09_VALOR] * @PP_VALOR ),
			[DR].[D10_VALOR] = ( [DR].[D10_VALOR] * @PP_VALOR ),
			[DR].[D11_VALOR] = ( [DR].[D11_VALOR] * @PP_VALOR ),
			[DR].[D12_VALOR] = ( [DR].[D12_VALOR] * @PP_VALOR ),
			[DR].[D13_VALOR] = ( [DR].[D13_VALOR] * @PP_VALOR ),
			[DR].[D14_VALOR] = ( [DR].[D14_VALOR] * @PP_VALOR ),
			[DR].[D15_VALOR] = ( [DR].[D15_VALOR] * @PP_VALOR ),
			[DR].[D16_VALOR] = ( [DR].[D16_VALOR] * @PP_VALOR ),
			[DR].[D17_VALOR] = ( [DR].[D17_VALOR] * @PP_VALOR ),
			[DR].[D18_VALOR] = ( [DR].[D18_VALOR] * @PP_VALOR ),
			[DR].[D19_VALOR] = ( [DR].[D19_VALOR] * @PP_VALOR ),
			[DR].[D20_VALOR] = ( [DR].[D20_VALOR] * @PP_VALOR ),
			[DR].[D21_VALOR] = ( [DR].[D21_VALOR] * @PP_VALOR ),
			[DR].[D22_VALOR] = ( [DR].[D22_VALOR] * @PP_VALOR ),
			[DR].[D23_VALOR] = ( [DR].[D23_VALOR] * @PP_VALOR ),
			[DR].[D24_VALOR] = ( [DR].[D24_VALOR] * @PP_VALOR ),
			[DR].[D25_VALOR] = ( [DR].[D25_VALOR] * @PP_VALOR ),
			[DR].[D26_VALOR] = ( [DR].[D26_VALOR] * @PP_VALOR ),
			[DR].[D27_VALOR] = ( [DR].[D27_VALOR] * @PP_VALOR ),
			[DR].[D28_VALOR] = ( [DR].[D28_VALOR] * @PP_VALOR ),
			[DR].[D29_VALOR] = ( [DR].[D29_VALOR] * @PP_VALOR ),
			[DR].[D30_VALOR] = ( [DR].[D30_VALOR] * @PP_VALOR ),
			[DR].[D31_VALOR] = ( [DR].[D31_VALOR] * @PP_VALOR )
	FROM	[DATA_N1_X_DI_D0M4] AS DR
	WHERE	[DR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
			-- ===========================
	AND		[DR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO





-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N1_05B_ACUMULAR_MENOS_A]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N1_05B_ACUMULAR_MENOS_A]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N1_05B_ACUMULAR_MENOS_A]
	@PP_K_DOCUMENTO_D0M4			INT,
	@PP_K_DATO_D0M4_RESULTADO		INT,
	@PP_L_ACUMULAR					INT,
	@PP_K_DATO_D0M4_A				INT
AS
	
	UPDATE	[DR]
	SET		
			[DR].[DXX_VALOR] = ( [DR].[DXX_VALOR] - [DA].[DXX_VALOR] ),
			[DR].[DYY_VALOR] = ( [DR].[DYY_VALOR] - [DA].[DYY_VALOR] ),
			[DR].[DZZ_VALOR] = ( [DR].[DZZ_VALOR] - [DA].[DZZ_VALOR] ),

			-- WIWI

			[DR].[D01_VALOR] = ( [DR].[D01_VALOR] - [DA].[D01_VALOR] ),
			[DR].[D02_VALOR] = ( [DR].[D02_VALOR] - [DA].[D02_VALOR] ),
			[DR].[D03_VALOR] = ( [DR].[D03_VALOR] - [DA].[D03_VALOR] ),
			[DR].[D04_VALOR] = ( [DR].[D04_VALOR] - [DA].[D04_VALOR] ),
			[DR].[D05_VALOR] = ( [DR].[D05_VALOR] - [DA].[D05_VALOR] ),
			[DR].[D06_VALOR] = ( [DR].[D06_VALOR] - [DA].[D06_VALOR] ),
			[DR].[D07_VALOR] = ( [DR].[D07_VALOR] - [DA].[D07_VALOR] ),
			[DR].[D08_VALOR] = ( [DR].[D08_VALOR] - [DA].[D08_VALOR] ),
			[DR].[D09_VALOR] = ( [DR].[D09_VALOR] - [DA].[D09_VALOR] ),
			[DR].[D10_VALOR] = ( [DR].[D10_VALOR] - [DA].[D10_VALOR] ),
			[DR].[D11_VALOR] = ( [DR].[D11_VALOR] - [DA].[D11_VALOR] ),
			[DR].[D12_VALOR] = ( [DR].[D12_VALOR] - [DA].[D12_VALOR] ),
			[DR].[D13_VALOR] = ( [DR].[D13_VALOR] - [DA].[D13_VALOR] ),
			[DR].[D14_VALOR] = ( [DR].[D14_VALOR] - [DA].[D14_VALOR] ),
			[DR].[D15_VALOR] = ( [DR].[D15_VALOR] - [DA].[D15_VALOR] ),
			[DR].[D16_VALOR] = ( [DR].[D16_VALOR] - [DA].[D16_VALOR] ),
			[DR].[D17_VALOR] = ( [DR].[D17_VALOR] - [DA].[D17_VALOR] ),
			[DR].[D18_VALOR] = ( [DR].[D18_VALOR] - [DA].[D18_VALOR] ),
			[DR].[D19_VALOR] = ( [DR].[D19_VALOR] - [DA].[D19_VALOR] ),
			[DR].[D20_VALOR] = ( [DR].[D20_VALOR] - [DA].[D20_VALOR] ),
			[DR].[D21_VALOR] = ( [DR].[D21_VALOR] - [DA].[D21_VALOR] ),
			[DR].[D22_VALOR] = ( [DR].[D22_VALOR] - [DA].[D22_VALOR] ),
			[DR].[D23_VALOR] = ( [DR].[D23_VALOR] - [DA].[D23_VALOR] ),
			[DR].[D24_VALOR] = ( [DR].[D24_VALOR] - [DA].[D24_VALOR] ),
			[DR].[D25_VALOR] = ( [DR].[D25_VALOR] - [DA].[D25_VALOR] ),
			[DR].[D26_VALOR] = ( [DR].[D26_VALOR] - [DA].[D26_VALOR] ),
			[DR].[D27_VALOR] = ( [DR].[D27_VALOR] - [DA].[D27_VALOR] ),
			[DR].[D28_VALOR] = ( [DR].[D28_VALOR] - [DA].[D28_VALOR] ),
			[DR].[D29_VALOR] = ( [DR].[D29_VALOR] - [DA].[D29_VALOR] ),
			[DR].[D30_VALOR] = ( [DR].[D30_VALOR] - [DA].[D30_VALOR] ),
			[DR].[D31_VALOR] = ( [DR].[D31_VALOR] - [DA].[D31_VALOR] )
	FROM	[DATA_N1_X_DI_D0M4] AS DR,
			[DATA_N1_X_DI_D0M4] AS DA
	WHERE	[DR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[DA].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
			-- ===========================
	AND		[DR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO
	AND		[DA].[K_DATO_D0M4]=@PP_K_DATO_D0M4_A

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N1_10A_ASIGNAR_A]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N1_10A_ASIGNAR_A]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N1_10A_ASIGNAR_A]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	@PP_L_ACUMULAR				INT,
	@PP_K_DATO_D0M4_A			INT
AS

	UPDATE	[DR]
	SET		
			[DR].[DXX_VALOR] = ( [DA].[DXX_VALOR] ),
			[DR].[DYY_VALOR] = ( [DA].[DYY_VALOR] ),
			[DR].[DZZ_VALOR] = ( [DA].[DZZ_VALOR] ),
			
			-- WIWI 

			[DR].[D01_VALOR] = ( [DA].[D01_VALOR] ),
			[DR].[D02_VALOR] = ( [DA].[D02_VALOR] ),
			[DR].[D03_VALOR] = ( [DA].[D03_VALOR] ),
			[DR].[D04_VALOR] = ( [DA].[D04_VALOR] ),
			[DR].[D05_VALOR] = ( [DA].[D05_VALOR] ),
			[DR].[D06_VALOR] = ( [DA].[D06_VALOR] ),
			[DR].[D07_VALOR] = ( [DA].[D07_VALOR] ),
			[DR].[D08_VALOR] = ( [DA].[D08_VALOR] ),
			[DR].[D09_VALOR] = ( [DA].[D09_VALOR] ),
			[DR].[D10_VALOR] = ( [DA].[D10_VALOR] ),
			[DR].[D11_VALOR] = ( [DA].[D11_VALOR] ),
			[DR].[D12_VALOR] = ( [DA].[D12_VALOR] ),
			[DR].[D13_VALOR] = ( [DA].[D13_VALOR] ),
			[DR].[D14_VALOR] = ( [DA].[D14_VALOR] ),
			[DR].[D15_VALOR] = ( [DA].[D15_VALOR] ),
			[DR].[D16_VALOR] = ( [DA].[D16_VALOR] ),
			[DR].[D17_VALOR] = ( [DA].[D17_VALOR] ),
			[DR].[D18_VALOR] = ( [DA].[D18_VALOR] ),
			[DR].[D19_VALOR] = ( [DA].[D19_VALOR] ),
			[DR].[D20_VALOR] = ( [DA].[D20_VALOR] ),
			[DR].[D21_VALOR] = ( [DA].[D21_VALOR] ),
			[DR].[D22_VALOR] = ( [DA].[D22_VALOR] ),
			[DR].[D23_VALOR] = ( [DA].[D23_VALOR] ),
			[DR].[D24_VALOR] = ( [DA].[D24_VALOR] ),
			[DR].[D25_VALOR] = ( [DA].[D25_VALOR] ),
			[DR].[D26_VALOR] = ( [DA].[D26_VALOR] ),
			[DR].[D27_VALOR] = ( [DA].[D27_VALOR] ),
			[DR].[D28_VALOR] = ( [DA].[D28_VALOR] ),
			[DR].[D29_VALOR] = ( [DA].[D29_VALOR] ),
			[DR].[D30_VALOR] = ( [DA].[D30_VALOR] ),
			[DR].[D31_VALOR] = ( [DA].[D31_VALOR] )
	FROM	[DATA_N1_X_DI_D0M4] AS DR,
			[DATA_N1_X_DI_D0M4] AS DA 
	WHERE	[DR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[DA].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
			-- ===========================
	AND		[DR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO
	AND		[DA].[K_DATO_D0M4]=@PP_K_DATO_D0M4_A

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO




-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N1_10B_ASIGNAR_VALOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N1_10B_ASIGNAR_VALOR]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N1_10B_ASIGNAR_VALOR]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	@PP_L_ACUMULAR				INT,
	@PP_VALOR					DECIMAL(19,4)
AS

	UPDATE	[DR]
	SET		
			[DR].[DXX_VALOR] = ( @PP_VALOR ),
			[DR].[DYY_VALOR] = ( @PP_VALOR ),
			[DR].[DZZ_VALOR] = ( @PP_VALOR ),
			
		--	WIWI

			[DR].[D01_VALOR] = ( @PP_VALOR ),
			[DR].[D02_VALOR] = ( @PP_VALOR ),
			[DR].[D03_VALOR] = ( @PP_VALOR ),
			[DR].[D04_VALOR] = ( @PP_VALOR ),
			[DR].[D05_VALOR] = ( @PP_VALOR ),
			[DR].[D06_VALOR] = ( @PP_VALOR ),
			[DR].[D07_VALOR] = ( @PP_VALOR ),
			[DR].[D08_VALOR] = ( @PP_VALOR ),
			[DR].[D09_VALOR] = ( @PP_VALOR ),
			[DR].[D10_VALOR] = ( @PP_VALOR ),
			[DR].[D11_VALOR] = ( @PP_VALOR ),
			[DR].[D12_VALOR] = ( @PP_VALOR ),
			[DR].[D13_VALOR] = ( @PP_VALOR ),
			[DR].[D14_VALOR] = ( @PP_VALOR ),
			[DR].[D15_VALOR] = ( @PP_VALOR ),
			[DR].[D16_VALOR] = ( @PP_VALOR ),
			[DR].[D17_VALOR] = ( @PP_VALOR ),
			[DR].[D18_VALOR] = ( @PP_VALOR ),
			[DR].[D19_VALOR] = ( @PP_VALOR ),
			[DR].[D20_VALOR] = ( @PP_VALOR ),
			[DR].[D21_VALOR] = ( @PP_VALOR ),
			[DR].[D22_VALOR] = ( @PP_VALOR ),
			[DR].[D23_VALOR] = ( @PP_VALOR ),
			[DR].[D24_VALOR] = ( @PP_VALOR ),
			[DR].[D25_VALOR] = ( @PP_VALOR ),
			[DR].[D26_VALOR] = ( @PP_VALOR ),
			[DR].[D27_VALOR] = ( @PP_VALOR ),
			[DR].[D28_VALOR] = ( @PP_VALOR ),
			[DR].[D29_VALOR] = ( @PP_VALOR ),
			[DR].[D30_VALOR] = ( @PP_VALOR ),
			[DR].[D31_VALOR] = ( @PP_VALOR )
	FROM	[DATA_N1_X_DI_D0M4] AS DR 
	WHERE	[DR].[K_DOCUMENTO_D0M4]=@PP_K_DOCUMENTO_D0M4
	AND		[DR].[K_DATO_D0M4]=@PP_K_DATO_D0M4_RESULTADO

	-- ================================================

	IF @PP_L_ACUMULAR=1
		EXECUTE [dbo].[PG_CA_MATE_N1_XX_VALOR_ACUMULADO]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_RESULTADO

	-- ================================================
GO



-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]
GO


CREATE PROCEDURE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4_RESULTADO	INT,
	@PP_VALOR					DECIMAL(19,4),
	@PP_N_DIA					INT
AS

	DECLARE @VP_COLUMNA		VARCHAR(50)

	SET		@VP_COLUMNA = [dbo].[PG_FG_TEXTO_DIA] ( @PP_N_DIA )
	
	SET		@VP_COLUMNA = 'D'+@VP_COLUMNA+'_VALOR'

	-- ===================

	DECLARE @VP_SQL		NVARCHAR(MAX) 
	
	SET @VP_SQL = ''
	SET @VP_SQL = @VP_SQL + 'UPDATE [DR] ' 
	SET @VP_SQL = @VP_SQL + ' SET'
	SET @VP_SQL = @VP_SQL + ' [DR].['+@VP_COLUMNA+'] = ( '+ CONVERT(VARCHAR(100),@PP_VALOR) + ' )'
	SET @VP_SQL = @VP_SQL + ' FROM	[DATA_N1_X_DI_D0M4] AS DR' 
	SET @VP_SQL = @VP_SQL + ' WHERE	[DR].[K_DOCUMENTO_D0M4]=' + CONVERT(VARCHAR(100),@PP_K_DOCUMENTO_D0M4)
	SET @VP_SQL = @VP_SQL + ' AND   [DR].[K_DATO_D0M4]=' + CONVERT(VARCHAR(100),@PP_K_DATO_D0M4_RESULTADO)

	EXECUTE sp_executesql @VP_SQL 

	-- ================================================
GO






-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
