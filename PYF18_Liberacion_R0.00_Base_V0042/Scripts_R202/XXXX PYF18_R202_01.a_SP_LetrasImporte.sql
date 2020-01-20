-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION /STORED PROCEDURES
-- //////////////////////////////////////////////////////////////


USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // PRUEBAS
-- //////////////////////////////////////////////////////////////
-- PG_PR_NUM_CONVERSION_A_TEXTO 1234567891.34
-- PG_PR_NUM_CONVERSION_A_TEXTO 1000000056.34
-- PG_PR_NUM_CONVERSION_A_TEXTO 1234567000.34
-- PG_PR_NUM_CONVERSION_A_TEXTO 1000000.11
-- PG_PR_NUM_CONVERSION_A_TEXTO 5000000.11
-- PG_PR_NUM_CONVERSION_A_TEXTO 295738.00
-- PG_PR_NUM_CONVERSION_A_TEXTO 11.11


-- //////////////////////////////////////////////////////////////
-- // PRUEBAS
-- //////////////////////////////////////////////////////////////
/*
	DECLARE @VP_IMPORTE_LETRA		VARCHAR(200)
	
	EXECUTE [dbo].[PG_PR_NUM_CONVERSION_A_TEXTO_OUT]		@PP_NUMERO_ORIGINAL,
															@OU_IMPORTE_LETRA = @VP_IMPORTE_LETRA		OUTPUT
*/



-- ///////////////////////////////////////////////////////////////////////
-- //
-- ///////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_LEYENDA_UNIDADES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_LEYENDA_UNIDADES]
GO


CREATE PROCEDURE [dbo].[PG_PR_LEYENDA_UNIDADES]
	@PP_IDENTIFICADOR			INT,
	@OU_LEYENDA_UNIDADES 		VARCHAR(100)		OUTPUT
AS
	DECLARE @VP_LEYENDA_UNIDADES		VARCHAR(100)
	
	-- ===========================

	SELECT @VP_LEYENDA_UNIDADES =	CASE	WHEN @PP_IDENTIFICADOR=1		THEN  'UN'
											WHEN @PP_IDENTIFICADOR=2		THEN  'DOS'
											WHEN @PP_IDENTIFICADOR=3		THEN  'TRES'
											WHEN @PP_IDENTIFICADOR=4		THEN  'CUATRO'
											WHEN @PP_IDENTIFICADOR=5		THEN  'CINCO'
											WHEN @PP_IDENTIFICADOR=6		THEN  'SEIS'
											WHEN @PP_IDENTIFICADOR=7		THEN  'SIETE'
											WHEN @PP_IDENTIFICADOR=8		THEN  'OCHO'
											WHEN @PP_IDENTIFICADOR=9		THEN  'NUEVE'
										ELSE ''
										END
	-- ===========================

	SET @OU_LEYENDA_UNIDADES = @VP_LEYENDA_UNIDADES

	-- ///////////////////////////
GO



-- ///////////////////////////////////////////////////////////////////////
-- //
-- ///////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_LEYENDA_DECENAS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_LEYENDA_DECENAS]
GO


CREATE PROCEDURE [dbo].[PG_PR_LEYENDA_DECENAS]
	@PP_IDENTIFICADOR		INT,
	@OU_LEYENDA_DECENAS 	VARCHAR(100)		OUTPUT
AS
	DECLARE @VP_LEYENDA_DECENAS			VARCHAR(100)

	-- ===========================

	SELECT @VP_LEYENDA_DECENAS =		CASE	WHEN @PP_IDENTIFICADOR=01		THEN  'DIEZ'
												WHEN @PP_IDENTIFICADOR=02		THEN  'ONCE'
												WHEN @PP_IDENTIFICADOR=03		THEN  'DOCE'
												WHEN @PP_IDENTIFICADOR=04		THEN  'TRECE'
												WHEN @PP_IDENTIFICADOR=05		THEN  'CATORCE'
												WHEN @PP_IDENTIFICADOR=06		THEN  'QUINCE'
												WHEN @PP_IDENTIFICADOR=07		THEN  'VEINTE'
												WHEN @PP_IDENTIFICADOR=08		THEN  'TREINTA'
												WHEN @PP_IDENTIFICADOR=09		THEN  'CUARENTA'
												WHEN @PP_IDENTIFICADOR=10		THEN  'CINCUENTA'
												WHEN @PP_IDENTIFICADOR=11		THEN  'SESENTA'
												WHEN @PP_IDENTIFICADOR=12		THEN  'SETENTA'
												WHEN @PP_IDENTIFICADOR=13		THEN  'OCHENTA'
												WHEN @PP_IDENTIFICADOR=14		THEN  'NOVENTA'
										ELSE ''
										END
	-- ===========================

	SET @OU_LEYENDA_DECENAS = @VP_LEYENDA_DECENAS

	-- ///////////////////////////
GO



-- ///////////////////////////////////////////////////////////////////////
-- //
-- ///////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_LEYENDA_CENTENAS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_LEYENDA_CENTENAS]
GO


CREATE PROCEDURE [dbo].[PG_PR_LEYENDA_CENTENAS]
	@PP_IDENTIFICADOR		INT,
	@OU_LEYENDA_CENTENAS 	VARCHAR(100)		OUTPUT
AS
	DECLARE @VP_LEYENDA_CENTENAS		VARCHAR(100)

	-- ===========================

	SELECT @VP_LEYENDA_CENTENAS =	CASE	WHEN @PP_IDENTIFICADOR=1		THEN  'CIEN'
											WHEN @PP_IDENTIFICADOR=2		THEN  'DOSCIENTOS'
											WHEN @PP_IDENTIFICADOR=3		THEN  'TRESCIENTOS'
											WHEN @PP_IDENTIFICADOR=4		THEN  'CUATROCIENTOS'
											WHEN @PP_IDENTIFICADOR=5		THEN  'QUINIENTOS'
											WHEN @PP_IDENTIFICADOR=6		THEN  'SEISCIENTOS'
											WHEN @PP_IDENTIFICADOR=7		THEN  'SETECIENTOS'
											WHEN @PP_IDENTIFICADOR=8		THEN  'OCHOCIENTOS'
											WHEN @PP_IDENTIFICADOR=9		THEN  'NOVECIENTOS'
										ELSE ''
										END
	-- ===========================

	SET @OU_LEYENDA_CENTENAS = @VP_LEYENDA_CENTENAS

	-- ///////////////////////////
GO



-- ///////////////////////////////////////////////////////////////////////
-- //
-- ///////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_NUM_OBTEN_CANTIDAD_X_3_DIGITOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_NUM_OBTEN_CANTIDAD_X_3_DIGITOS]
GO


CREATE PROCEDURE [dbo].[PG_PR_NUM_OBTEN_CANTIDAD_X_3_DIGITOS]
	@PP_DATO_3_DIGITOS			VARCHAR(3),
	@OU_CANTIDAD_X_3_DIGITOS 	VARCHAR(100)		OUTPUT
AS

	DECLARE @VP_DIGITO_UNIDADES			INT
    DECLARE @VP_DIGITO_DECENAS			INT
    DECLARE @VP_DIGITO_CENTENAS			INT
    DECLARE @VP_LEYENDA_UNIDADES		VARCHAR(100) = ''
    DECLARE @VP_LEYENDA_DECENAS			VARCHAR(100) = ''
    DECLARE @VP_LEYENDA_CENTENAS		VARCHAR(100) = ''
    DECLARE @VP_DATO_3_DIGITOS			INT
    DECLARE @VP_LEYENDA_RESULTADO		VARCHAR(300) = ''

	SET @VP_DATO_3_DIGITOS = CONVERT(INT, @PP_DATO_3_DIGITOS)

	IF @VP_DATO_3_DIGITOS = 0
		SET @VP_LEYENDA_UNIDADES = ''
	ELSE
		BEGIN
			SET @VP_DIGITO_UNIDADES = CONVERT(INT, SUBSTRING(@PP_DATO_3_DIGITOS,3,1))
			SET @VP_DIGITO_DECENAS = CONVERT(INT, SUBSTRING(@PP_DATO_3_DIGITOS,2,1))
			SET @VP_DIGITO_CENTENAS = CONVERT(INT, SUBSTRING(@PP_DATO_3_DIGITOS,1,1))

			------ PROCESAR UNIDADES
			IF @VP_DIGITO_UNIDADES = 0
				SET @VP_LEYENDA_UNIDADES = ''
			ELSE
				BEGIN

				EXECUTE [dbo].[PG_PR_LEYENDA_UNIDADES]	@VP_DIGITO_UNIDADES, 
														@OU_LEYENDA_UNIDADES = @VP_LEYENDA_UNIDADES		OUTPUT
				
				END

			------ PROCESAR DECENAS
			DECLARE @VP_IDENTIFICADOR_DECENAS	INT


			IF @VP_DIGITO_DECENAS <> 0
				BEGIN
				
				IF @VP_DIGITO_DECENAS = 1
					BEGIN

					DECLARE @VP_DATO_2_DIGITOS		INT

					SET @VP_DATO_2_DIGITOS = CONVERT(INT, SUBSTRING(LTRIM(RTRIM(STR(@VP_DATO_3_DIGITOS))),LEN(LTRIM(RTRIM(STR(@VP_DATO_3_DIGITOS)))) - 1, 2))
					
					SELECT @VP_IDENTIFICADOR_DECENAS = CASE 
							WHEN @VP_DATO_2_DIGITOS = 10 THEN  1
							WHEN @VP_DATO_2_DIGITOS = 11 THEN  2
							WHEN @VP_DATO_2_DIGITOS = 12 THEN  3
							WHEN @VP_DATO_2_DIGITOS = 13 THEN  4
							WHEN @VP_DATO_2_DIGITOS = 14 THEN  5
							WHEN @VP_DATO_2_DIGITOS = 15 THEN  6
							ELSE -1
							END

					IF @VP_IDENTIFICADOR_DECENAS > 0
						EXECUTE [dbo].[PG_PR_LEYENDA_DECENAS]	@VP_IDENTIFICADOR_DECENAS, 
																@OU_LEYENDA_DECENAS = @VP_LEYENDA_DECENAS		OUTPUT
					ELSE
						SET @VP_LEYENDA_DECENAS = 'DIECI' + @VP_LEYENDA_UNIDADES

					SET @VP_LEYENDA_UNIDADES = ''

					END
				ELSE
					BEGIN
					
					SET @VP_IDENTIFICADOR_DECENAS = @VP_DIGITO_DECENAS + 5

					EXECUTE [dbo].[PG_PR_LEYENDA_DECENAS]	@VP_IDENTIFICADOR_DECENAS, 
															@OU_LEYENDA_DECENAS = @VP_LEYENDA_DECENAS		OUTPUT

					IF @VP_DIGITO_UNIDADES <> 0
						BEGIN
						IF @VP_DIGITO_DECENAS = 2
							SET @VP_LEYENDA_DECENAS = SUBSTRING(@VP_LEYENDA_DECENAS,0,LEN(@VP_LEYENDA_DECENAS)) + 'I'
						ELSE
							SET @VP_LEYENDA_DECENAS = @VP_LEYENDA_DECENAS + ' Y '
						END
					END
				END	
			------ PROCESAR CENTENAS
			IF @VP_DIGITO_CENTENAS <> 0
				BEGIN

				EXECUTE [dbo].[PG_PR_LEYENDA_CENTENAS]	@VP_DIGITO_CENTENAS, 
														@OU_LEYENDA_CENTENAS = @VP_LEYENDA_CENTENAS		OUTPUT

				IF @VP_DATO_3_DIGITOS > 100
					BEGIN

					IF @VP_DIGITO_CENTENAS = 1
						SET @VP_LEYENDA_CENTENAS = @VP_LEYENDA_CENTENAS + 'TO '
					ELSE
						SET @VP_LEYENDA_CENTENAS = @VP_LEYENDA_CENTENAS + ' '
					END
				END
			SET @VP_LEYENDA_RESULTADO = @VP_LEYENDA_CENTENAS + @VP_LEYENDA_DECENAS + @VP_LEYENDA_UNIDADES
		END	
	
	--==============================================================

	SET @OU_CANTIDAD_X_3_DIGITOS = @VP_LEYENDA_RESULTADO

	-- ///////////////////////////
GO



-- ///////////////////////////////////////////////////////////////////////
-- //
-- ///////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_NUM_OBTENER_CENTAVOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_NUM_OBTENER_CENTAVOS]
GO


CREATE PROCEDURE [dbo].[PG_PR_NUM_OBTENER_CENTAVOS]
	@PP_NUMERO_ORIGINAL			DECIMAL(19,4),
	@OU_OBTENER_CENTAVOS		VARCHAR(50)			OUTPUT
AS
	DECLARE @VP_CENTAVOS			VARCHAR(50) = ''
	DECLARE @VP_NUMERO_ORIGINAL		INT

	-- ===========================

	SET @VP_CENTAVOS = CONVERT(VARCHAR(25),@PP_NUMERO_ORIGINAL)
	
	SET @VP_CENTAVOS = 	RIGHT(@VP_CENTAVOS,4) 
	SET @VP_CENTAVOS = 	LEFT(@VP_CENTAVOS,2) 
	
	SET @VP_CENTAVOS = ' ' + @VP_CENTAVOS + '/100 M.N.'

	-- ===========================

	SELECT @OU_OBTENER_CENTAVOS = @VP_CENTAVOS

	-- ///////////////////////////
GO



-- ///////////////////////////////////////////////////////////////////////
-- //
-- ///////////////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_NUM_CONVERSION_A_TEXTO_OUT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_NUM_CONVERSION_A_TEXTO_OUT]
GO


CREATE PROCEDURE [dbo].[PG_PR_NUM_CONVERSION_A_TEXTO_OUT]
	@PP_NUMERO_ORIGINAL		DECIMAL(19,4),
	@OU_IMPORTE_LETRA		VARCHAR(200)		OUTPUT
AS

	DECLARE @VP_IMPORTE_LETRA	VARCHAR(200)
    
	-- ///////////////////////////////////////////////////////////////////////

	DECLARE @VP_NUMERO_ORIGINAL_SIN_DECIMALES		VARCHAR(100)
    DECLARE @VP_LEYENDA_CIENTOS						VARCHAR(100)
    DECLARE @VP_LEYENDA_MILES						VARCHAR(100)
    DECLARE @VP_LEYENDA_MILLONES					VARCHAR(100)
    DECLARE @VP_LEYENDA_MILES_DE_MILLONES			VARCHAR(100)
	DECLARE @VP_NUMERO_EN_LETRAS					VARCHAR(500)

	SET @VP_NUMERO_ORIGINAL_SIN_DECIMALES = '000000000000' + LTRIM(RTRIM(CONVERT(VARCHAR(30),@PP_NUMERO_ORIGINAL)))

	SET @VP_NUMERO_ORIGINAL_SIN_DECIMALES = LEFT(@VP_NUMERO_ORIGINAL_SIN_DECIMALES,(LEN(@VP_NUMERO_ORIGINAL_SIN_DECIMALES)-5))
	
	SET @VP_NUMERO_ORIGINAL_SIN_DECIMALES = RIGHT(@VP_NUMERO_ORIGINAL_SIN_DECIMALES,12)

	--==============================================================

	DECLARE @VP_NUMERO_ORIGINAL INT

	SET @VP_NUMERO_ORIGINAL = CONVERT(INT, @VP_NUMERO_ORIGINAL_SIN_DECIMALES)

	IF @VP_NUMERO_ORIGINAL = 0
		SET @VP_NUMERO_EN_LETRAS = 'CERO PESOS'
	ELSE IF @VP_NUMERO_ORIGINAL = 1
		SET @VP_NUMERO_EN_LETRAS = 'UN PESO'
	ELSE
		BEGIN 
		
		DECLARE @VP_DATO_3_DIGITOS_CIENTOS					VARCHAR(3)
		DECLARE @VP_DATO_3_DIGITOS_MILES					VARCHAR(3)
		DECLARE @VP_DATO_3_DIGITOS_MILLONES					VARCHAR(3)
		DECLARE @VP_DATO_3_DIGITOS_MILES_DE_MILLONES		VARCHAR(3)

		SET @VP_DATO_3_DIGITOS_CIENTOS =			SUBSTRING(@VP_NUMERO_ORIGINAL_SIN_DECIMALES, 10,3)
		SET @VP_DATO_3_DIGITOS_MILES =				SUBSTRING(@VP_NUMERO_ORIGINAL_SIN_DECIMALES, 7,3)
		SET @VP_DATO_3_DIGITOS_MILLONES =			SUBSTRING(@VP_NUMERO_ORIGINAL_SIN_DECIMALES, 4,3)
		SET @VP_DATO_3_DIGITOS_MILES_DE_MILLONES =	SUBSTRING(@VP_NUMERO_ORIGINAL_SIN_DECIMALES, 1,3)

		--==============================================================

		EXECUTE [dbo].[PG_PR_NUM_OBTEN_CANTIDAD_X_3_DIGITOS]	@VP_DATO_3_DIGITOS_CIENTOS,	
																@OU_CANTIDAD_X_3_DIGITOS = @VP_LEYENDA_CIENTOS			OUTPUT
		
		EXECUTE [dbo].[PG_PR_NUM_OBTEN_CANTIDAD_X_3_DIGITOS]	@VP_DATO_3_DIGITOS_MILES,	
																@OU_CANTIDAD_X_3_DIGITOS = @VP_LEYENDA_MILES			OUTPUT
		
		EXECUTE [dbo].[PG_PR_NUM_OBTEN_CANTIDAD_X_3_DIGITOS]	@VP_DATO_3_DIGITOS_MILLONES,	
																@OU_CANTIDAD_X_3_DIGITOS = @VP_LEYENDA_MILLONES			OUTPUT
		
		EXECUTE [dbo].[PG_PR_NUM_OBTEN_CANTIDAD_X_3_DIGITOS]	@VP_DATO_3_DIGITOS_MILES_DE_MILLONES,	
																@OU_CANTIDAD_X_3_DIGITOS = @VP_LEYENDA_MILES_DE_MILLONES  OUTPUT
		
		--==============================================================

		IF @VP_LEYENDA_MILES <> ''
			IF @VP_LEYENDA_MILES = 'UN'
				SET @VP_LEYENDA_MILES = ' MIL '
			ELSE
				IF @VP_LEYENDA_CIENTOS = ''
					SET @VP_LEYENDA_MILES = @VP_LEYENDA_MILES + ' MIL'
				ELSE
					SET @VP_LEYENDA_MILES = @VP_LEYENDA_MILES + ' MIL '

		IF @VP_LEYENDA_MILLONES <> ''
			SET @VP_LEYENDA_MILLONES = @VP_LEYENDA_MILLONES + ' MILLON' + (CASE WHEN @VP_LEYENDA_MILLONES = 'UN' THEN ' ' ELSE 'ES ' END) + (CASE WHEN (@VP_LEYENDA_MILES + @VP_LEYENDA_CIENTOS) = '' THEN 'DE' ELSE '' END)

		IF @VP_LEYENDA_MILES_DE_MILLONES <> ''
			SET @VP_LEYENDA_MILES_DE_MILLONES = (CASE WHEN @VP_LEYENDA_MILES_DE_MILLONES = 'UN' THEN '' ELSE @VP_LEYENDA_MILES_DE_MILLONES END) + 'MIL ' + (CASE WHEN @VP_LEYENDA_MILLONES = '' THEN 'MILLONES ' ELSE '' END) + (CASE WHEN (@VP_LEYENDA_MILLONES + @VP_LEYENDA_MILES + @VP_LEYENDA_CIENTOS) = '' THEN 'DE' ELSE '' END)

		--==============================================================
		
		SET @VP_NUMERO_EN_LETRAS = @VP_LEYENDA_MILES_DE_MILLONES
		SET @VP_NUMERO_EN_LETRAS = @VP_NUMERO_EN_LETRAS + @VP_LEYENDA_MILLONES
		SET @VP_NUMERO_EN_LETRAS = @VP_NUMERO_EN_LETRAS + @VP_LEYENDA_MILES
		SET @VP_NUMERO_EN_LETRAS = @VP_NUMERO_EN_LETRAS + @VP_LEYENDA_CIENTOS
		SET @VP_NUMERO_EN_LETRAS = @VP_NUMERO_EN_LETRAS + ' PESOS'

		END

	--==============================================================

	DECLARE @VP_CENTAVOS VARCHAR(50)
	
	EXECUTE [dbo].[PG_PR_NUM_OBTENER_CENTAVOS]	@PP_NUMERO_ORIGINAL, 
												@OU_OBTENER_CENTAVOS = @VP_CENTAVOS		OUTPUT

	SET @VP_IMPORTE_LETRA =	@VP_NUMERO_EN_LETRAS + @VP_CENTAVOS

	-- ///////////////////////////////////////////////////////////////////////

	SET @OU_IMPORTE_LETRA =	@VP_IMPORTE_LETRA

	-- ///////////////////////////
GO



-- ///////////////////////////////////////////////////////////////////////
-- //
-- ///////////////////////////////////////////////////////////////////////

-- PG_PR_NUM_CONVERSION_A_TEXTO 1887.12

-- PG_PR_NUM_CONVERSION_A_TEXTO 1234567891.34
-- PG_PR_NUM_CONVERSION_A_TEXTO 1000000056.34
-- PG_PR_NUM_CONVERSION_A_TEXTO 1234567000.94
-- PG_PR_NUM_CONVERSION_A_TEXTO 1000000.11
-- PG_PR_NUM_CONVERSION_A_TEXTO 5000000.11
-- PG_PR_NUM_CONVERSION_A_TEXTO 295738.00
-- PG_PR_NUM_CONVERSION_A_TEXTO 11.11

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_NUM_CONVERSION_A_TEXTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_NUM_CONVERSION_A_TEXTO]
GO


CREATE PROCEDURE [dbo].[PG_PR_NUM_CONVERSION_A_TEXTO]
	@PP_NUMERO_ORIGINAL			DECIMAL(19,4)
AS
	--==============================================================

	DECLARE @VP_IMPORTE_LETRA		VARCHAR(200)
	
	EXECUTE [dbo].[PG_PR_NUM_CONVERSION_A_TEXTO_OUT]		@PP_NUMERO_ORIGINAL,
															@OU_IMPORTE_LETRA = @VP_IMPORTE_LETRA		OUTPUT

	--==============================================================

	SELECT @VP_IMPORTE_LETRA AS ST_IMPORTE_LETRA

	--==============================================================
GO





-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
