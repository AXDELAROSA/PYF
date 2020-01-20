-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			
-- // OPERACION:		LIBERACION // STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // [PG_SK_CATALOGO_N_CONSECUTIVO_MAX_GET]
-- //////////////////////////////////////////////////////////////

/*

DECLARE @VP_INT_N_RENGLON INT

EXECUTE [dbo].[PG_SK_CATALOGO_N_CONSECUTIVO_MAX_GET]	0, 0,
														'TABLA_AMORTIZACION',
														'K_SIMULACION', 1, 
														'N_PERIODO',
														@OU_N_CONSECUTIVO = @VP_INT_N_RENGLON		OUTPUT
SELECT @VP_INT_N_RENGLON

*/


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CATALOGO_N_CONSECUTIVO_MAX_GET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CATALOGO_N_CONSECUTIVO_MAX_GET]
GO


CREATE PROCEDURE [dbo].[PG_SK_CATALOGO_N_CONSECUTIVO_MAX_GET]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_NOMBRE_TABLA		VARCHAR(255),
	@PP_CAMPO_AGRUPADOR		VARCHAR(255),
	@PP_K_AGRUPADOR			INT,
	@PP_CAMPO_MAX			VARCHAR(255),
	@OU_N_CONSECUTIVO		INT		OUTPUT
AS

	DECLARE @VP_SQL		NVARCHAR(MAX)

	SET		@VP_SQL =	'SELECT' 
	SET		@VP_SQL =	@VP_SQL + ' '
	SET		@VP_SQL =	@VP_SQL + '  @OU_K_TABLA_MAX_SQL = MAX('+@PP_CAMPO_MAX + ')'
	SET		@VP_SQL =	@VP_SQL + ' '
	SET		@VP_SQL =	@VP_SQL + 'FROM '  + @PP_NOMBRE_TABLA + ' '
	SET		@VP_SQL =	@VP_SQL + 'WHERE ' + @PP_CAMPO_AGRUPADOR + '=' + CONVERT(VARCHAR(50),@PP_K_AGRUPADOR)+' '

	-- ===============================

	DECLARE @VP_DEFINICION_PARAMETROS		NVARCHAR(500)
	
	SET		@VP_DEFINICION_PARAMETROS =		N'@OU_K_TABLA_MAX_SQL INT OUTPUT'

	-- ===============================

	DECLARE @VP_K_TABLA_MAX			INT		
	DECLARE @VP_K_TABLA_SIGUIENTE	INT			

	EXECUTE sp_executesql	@VP_SQL, @VP_DEFINICION_PARAMETROS, 
							@OU_K_TABLA_MAX_SQL = @VP_K_TABLA_MAX		OUTPUT

	-- ===============================
 
	IF @VP_K_TABLA_MAX IS NULL 
		SET @VP_K_TABLA_SIGUIENTE = 1
	ELSE
		SET @VP_K_TABLA_SIGUIENTE = ( @VP_K_TABLA_MAX + 1 )
	
	-- ===============================

	SET @OU_N_CONSECUTIVO = @VP_K_TABLA_SIGUIENTE

	-- ===============================
GO



-- //////////////////////////////////////////////////////////////
-- // [PG_SK_CATALOGO_K_MAX_GET]	
-- //////////////////////////////////////////////////////////////

/*

DECLARE @VP_K_TABLA_DISPONIBLE INT

EXECUTE  [dbo].[PG_SK_CATALOGO_K_MAX_GET]	0, 1001, 'SIMULACION',
											@OU_K_TABLA_DISPONIBLE = @VP_K_TABLA_DISPONIBLE		OUTPUT

SELECT @VP_K_TABLA_DISPONIBLE

*/


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CATALOGO_K_MAX_GET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CATALOGO_K_MAX_GET]
GO


CREATE PROCEDURE [dbo].[PG_SK_CATALOGO_K_MAX_GET]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_NOMBRE_TABLA			VARCHAR(255),
	@OU_K_TABLA_DISPONIBLE		INT OUTPUT
AS

	DECLARE @VP_K_TABLA_MAX				INT		
	DECLARE @VP_K_TABLA_SIGUIENTE		INT			
	DECLARE @VP_SQL						NVARCHAR(MAX)
	DECLARE @VP_DEFINICION_PARAMETROS	NVARCHAR(500)
	
	-- ===============================

	SET @VP_SQL = 'SELECT' 
	SET @VP_SQL = @VP_SQL + ' '
	SET @VP_SQL = @VP_SQL + '  @OU_K_TABLA_MAX_SQL = MAX(K_'+@PP_NOMBRE_TABLA + ')'
	SET @VP_SQL = @VP_SQL + ' '
	SET @VP_SQL = @VP_SQL + 'FROM ' + @PP_NOMBRE_TABLA 
	
	SET @VP_DEFINICION_PARAMETROS = N'@OU_K_TABLA_MAX_SQL INT OUTPUT'
	
	-- ===============================

	EXECUTE sp_executesql	@VP_SQL, @VP_DEFINICION_PARAMETROS, 
							@OU_K_TABLA_MAX_SQL = @VP_K_TABLA_MAX		OUTPUT
	
	-- =============================== 

	IF @VP_K_TABLA_MAX IS NULL 
		SET @VP_K_TABLA_SIGUIENTE = 1
	ELSE
		SET @VP_K_TABLA_SIGUIENTE = ( @VP_K_TABLA_MAX + 1 )

	SET @OU_K_TABLA_DISPONIBLE = @VP_K_TABLA_SIGUIENTE

	-- ===============================
GO



-- //////////////////////////////////////////////////////////////
-- // [PG_SK_OBJETOS]
-- //////////////////////////////////////////////////////////////

-- EXECUTE [dbo].[PG_SK_OBJETOS] 'PG%sk_contenido'


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_OBJETOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_OBJETOS]
GO

CREATE PROCEDURE [dbo].[PG_SK_OBJETOS]
	@PP_L_DEBUG			INT,
	@PP_K_SISTEMA_EXE	INT,
	@PP_NOMBRE			VARCHAR(255)
AS

	SELECT	*
	FROM	SYS.sysobjects
	WHERE	NAME LIKE '%'+@PP_NOMBRE+'%'
	ORDER BY NAME

	-- ====================================
GO



-- //////////////////////////////////////////////////////////////
-- // [PG_PR_TEXTO_DEPURAR_GET]
-- //////////////////////////////////////////////////////////////
/*

	DECLARE @VP_TEXTO_ORIGINAL		VARCHAR(MAX) 
	
	SET @VP_TEXTO_ORIGINAL	= '123'+CHAR(13)+'456'

	PRINT @VP_TEXTO_ORIGINAL

	EXECUTE	[dbo].[PG_PR_TEXTO_DEPURAR]		@VP_TEXTO_ORIGINAL,
											@OU_TEXTO_LIMPIO = @VP_TEXTO_ORIGINAL	OUTPUT
	PRINT @VP_TEXTO_ORIGINAL

*/


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_TEXTO_DEPURAR_GET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_TEXTO_DEPURAR_GET]
GO


CREATE PROCEDURE [dbo].[PG_PR_TEXTO_DEPURAR_GET]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_TEXTO_ORIGINAL		VARCHAR(MAX),
	@OU_TEXTO_LIMPIO		VARCHAR(MAX)	OUTPUT
AS

	DECLARE @VP_TEXTO_LIMPIO	VARCHAR(MAX)

	SET		@VP_TEXTO_LIMPIO =	''

	-- ====================================
	
	DECLARE @VP_N_CARACTERES		INT

	IF @PP_TEXTO_ORIGINAL IS NULL
		SET	@VP_N_CARACTERES =		0
	ELSE
		SET	@VP_N_CARACTERES =		LEN(@PP_TEXTO_ORIGINAL)

	-- ====================================

	DECLARE @VP_IN_CICLO	INT = 0
	DECLARE @VP_CARACTER	VARCHAR(1)

	IF @VP_N_CARACTERES>0
		WHILE ( @VP_IN_CICLO<=@VP_N_CARACTERES )
			BEGIN

			SET @VP_CARACTER = SUBSTRING(@PP_TEXTO_ORIGINAL,@VP_IN_CICLO,1)

			-- ==============

			IF NOT ( ASCII(@VP_CARACTER) IN (13, 10) )
				SET @VP_TEXTO_LIMPIO = @VP_TEXTO_LIMPIO + @VP_CARACTER

			-- ==============

			SET @VP_IN_CICLO = @VP_IN_CICLO + 1 

			END
		
	-- ====================================

	SET @OU_TEXTO_LIMPIO = @VP_TEXTO_LIMPIO

	-- ====================================
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / ID
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]
GO


CREATE PROCEDURE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]
	@PP_REFERENCIA			VARCHAR(100),
	@OU_K_ELEMENTO			INT		OUTPUT
AS

	DECLARE @VP_TEXTO			VARCHAR(100)

	SET @VP_TEXTO = REPLACE(@PP_REFERENCIA,'+','')

	SET @VP_TEXTO = REPLACE(@VP_TEXTO,'-','')
	SET @VP_TEXTO = REPLACE(@VP_TEXTO,'.','')
	SET @VP_TEXTO = REPLACE(@VP_TEXTO,',','')
	SET @VP_TEXTO = REPLACE(@VP_TEXTO,'$','')
	SET @VP_TEXTO = REPLACE(@VP_TEXTO,'¢','')
	SET @VP_TEXTO = REPLACE(@VP_TEXTO,'€','')

	-- =============================================

	DECLARE @VP_K_ELEMENTO_TEMPORAL	INT

	SET @VP_K_ELEMENTO_TEMPORAL = -1

	-- =============================================

	IF LEN(@VP_TEXTO)=1
		BEGIN
		IF 0 = CHARINDEX ( @VP_TEXTO , '+-.$¢€' )
			IF ISNUMERIC(@VP_TEXTO)=1 
				SET @VP_K_ELEMENTO_TEMPORAL = CONVERT(INT, FLOOR( LEFT(@VP_TEXTO,9) ))
		END
	ELSE
		IF ISNUMERIC(@VP_TEXTO)=1 
			SET @VP_K_ELEMENTO_TEMPORAL = CONVERT(INT, FLOOR( LEFT(@VP_TEXTO,9) ))
	
	-- =============================================

	SET @OU_K_ELEMENTO = @VP_K_ELEMENTO_TEMPORAL

GO



-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
