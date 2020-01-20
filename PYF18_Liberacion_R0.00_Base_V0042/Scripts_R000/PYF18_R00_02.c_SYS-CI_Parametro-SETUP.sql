-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			SOPORTE - VALOR_PARAMETRO
-- // OPERACION:		LIBERACION / DATOS
-- //////////////////////////////////////////////////////////////
-- // AGREGAR @SISTEMA EN GET DE VALOR/PARAMETROS >>>> TIENE IMPACTOS EN OTROS SPS
-- // AGREGAR @AMBIENTE EN GET DE VALOR/PARAMETROS >>>> TIENE IMPACTOS EN OTROS SPS
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////





-- //////////////////////////////////////////////////////////////
-- SELECT * FROM [dbo].[VALOR_PARAMETRO] 

DELETE
FROM [dbo].[VALOR_PARAMETRO] 
GO

DELETE
FROM [dbo].[PARAMETRO] 
GO



/****************************************************************/
/*					PARAMETRO / VALOR_PARAMETRO					*/
/****************************************************************/

-- /////////////////////////////////////////////////////////////////
-- 11111111111111111111111111111111111111111111111111111111111111111
-- 11111111111111111111111111111111111111111111111111111111111111111
-- 11111111111111111111111111111111111111111111111111111111111111111
-- /////////////////////////////////////////////////////////////////


/****************************************************************/
/* #100 | SISTEMA												*/
/****************************************************************/
-- [PG_SK_CONFIGURACION_SISTEMA] 0, NULL	
-- [PG_SK_CONFIGURACION_SISTEMA] 0, 0
-- [PG_SK_CONFIGURACION_SISTEMA] 0, 123

EXECUTE [dbo].[PG_CF_PARAMETRO]			0, 0, 
										100, 'SISTEMA',	'SISTEMA', 10, 'SISTEMA = K_SISTEMA | #0000 DEFAULT | #0100 ICS/GENERAL | #0200 ERM/GENERAL | #1001 PRESTAMOS MAYORISTAS ', 1 
GO

-- SISTEMA = K_SISTEMA | #0000 DEFAULT | #0100 ICS/GENERAL | #0200 ERM/GENERAL | #1001 PRESTAMOS MAYORISTAS 
EXECUTE [dbo].[PG_CF_VALOR_PARAMETRO]	0, 0, 0,
										1000, 'SISTEMA', 'ENTERO_1 = K_SISTEMA | #0000 DEFAULT | #0100 ICS/GENERAL | #0200 ERM/GENERAL | #1001 PRESTAMOS MAYORISTAS ',
										0,	100, 
										'TXT_1', 'TXT_2', 'TXT_3', 
										 1001, -1, -1,			-- PRESTAMO MAYORISTAS
									  	   -1, -1, -1 
GO




/****************************************************************/
/*				[PG_SK_CONFIGURACION_SISTEMA]					*/
/****************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CONFIGURACION_SISTEMA_GET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CONFIGURACION_SISTEMA_GET]
GO


CREATE PROCEDURE [dbo].[PG_SK_CONFIGURACION_SISTEMA_GET]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@OU_SISTEMA				INT		OUTPUT
AS
	-- EXECUTE [dbo].[PG_CF_PARAMETRO]	100, 'SISTEMA',	'SISTEMA', 10, 'SISTEMA = K_SISTEMA | #0000 DEFAULT | #0100 ICS/GENERAL | #0200 ERM/GENERAL | #1001 PRESTAMOS MAYORISTAS ', 1 

	DECLARE	@VP_SISTEMA			INT

	IF NOT ( @PP_K_SISTEMA_EXE IS NULL ) 
		IF @PP_K_SISTEMA_EXE>0		-- #0000 DEFAULT
			SET @VP_SISTEMA = @PP_K_SISTEMA_EXE
	
	IF ( @VP_SISTEMA IS NULL ) 
		SELECT	@VP_SISTEMA =		[VALOR_PARAMETRO_INT_1]
									FROM	VALOR_PARAMETRO, PARAMETRO 
									WHERE	VALOR_PARAMETRO.K_PARAMETRO=PARAMETRO.K_PARAMETRO
									AND		VALOR_PARAMETRO.K_PARAMETRO=100
									AND		VALOR_PARAMETRO.K_SISTEMA=0			-- #0000 DEFAULT
									AND		VALOR_PARAMETRO.K_AMBIENTE=0		-- K_AMBIENTE = #0-NINGUNO
	-- =======================
	
	IF ( @VP_SISTEMA IS NULL ) 
		SET @VP_SISTEMA = 000		-- #0000 DEFAULT
	
	-- =======================

	SET @OU_SISTEMA = @VP_SISTEMA

	-- =======================
GO


/****************************************************************/
/*				[PG_SK_CONFIGURACION_SISTEMA]					*/
/****************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CONFIGURACION_SISTEMA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CONFIGURACION_SISTEMA]
GO


CREATE PROCEDURE [dbo].[PG_SK_CONFIGURACION_SISTEMA]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT
AS
	-- EXECUTE [dbo].[PG_CF_PARAMETRO]	100, 'SISTEMA',	'SISTEMA', 10, 'SISTEMA = K_SISTEMA | #0000 DEFAULT | #0100 ICS/GENERAL | #0200 ERM/GENERAL | #1001 PRESTAMOS MAYORISTAS', 1 

	DECLARE	@VP_SISTEMA		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_SISTEMA_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
														@OU_SISTEMA = @VP_SISTEMA		OUTPUT
	-- ======================

	DECLARE	@VP_K_PARAMETRO		INT

	SET		@VP_K_PARAMETRO =	100

	-- ======================
	
	IF ( @VP_SISTEMA IS NULL ) 
		SET @VP_SISTEMA = 000
	
	-- ======================
	
	SELECT	@VP_K_PARAMETRO		AS 'K_PARAMETRO', 
			@VP_SISTEMA			AS 'SISTEMA',
			'SISTEMA = K_SISTEMA | #0000 DEFAULT | #0100 ICS/GENERAL | #0200 ERM/GENERAL | #1001 PRESTAMOS MAYORISTAS'
								AS 'VALORES'
	-- ======================
GO



/****************************************************************/
/*					[PG_SK_SISTEMA_VALIDAR_GET]					*/
/****************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_SISTEMA_VALIDAR_GET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_SISTEMA_VALIDAR_GET]
GO


CREATE PROCEDURE [dbo].[PG_SK_SISTEMA_VALIDAR_GET]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@OU_SISTEMA_OK			INT		OUTPUT
AS
	-- EXECUTE [dbo].[PG_CF_PARAMETRO]	101, 'AMBIENTE',	'AMBIENTE', 10, '#0 N/A | #1 PROD | #2 PERF | #3 UAT | #4 CERT | #5 LAB | #6 UNIT | #7 DESA', 1 

	DECLARE	@VP_SISTEMA_OK		INT
	
	IF ( @PP_K_SISTEMA_EXE IS NULL )
		EXECUTE [dbo].[PG_SK_CONFIGURACION_SISTEMA_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															@OU_SISTEMA = @VP_SISTEMA_OK		OUTPUT
	ELSE
		SET @VP_SISTEMA_OK	= @PP_K_SISTEMA_EXE 
			
	-- =======================

	SET @OU_SISTEMA_OK = @VP_SISTEMA_OK

	-- =======================
GO




/****************************************************************/
/* #101 | AMBIENTE												*/
/****************************************************************/
-- [PG_SK_CONFIGURACION_AMBIENTE] 0, NULL	
-- [PG_SK_CONFIGURACION_AMBIENTE] 0, 1001	
-- [PG_SK_CONFIGURACION_AMBIENTE] 0, 0
-- [PG_SK_CONFIGURACION_AMBIENTE] 0, 123

EXECUTE [dbo].[PG_CF_PARAMETRO]			0, 0, 
										101, 'AMBIENTE',	'AMBIENTE', 10, '#0 N/A | #1 PROD | #2 PERF | #3 UAT | #4 CERT | #5 LAB | #6 UNIT | #7 DESA', 1 
GO

-- AMBIENTE = #0 N/A | #1 PROD | #2 PERF | #3 UAT | #4 CERT | #5 LAB | #6 UNIT | #7 DESA
EXECUTE [dbo].[PG_CF_VALOR_PARAMETRO]	0, 0, 1001,
										1010, 'AMBIENTE', 'ENTERO_1 = #0 N/A | #1 PROD | #2 PERF | #3 UAT | #4 CERT | #5 LAB | #6 UNIT | #7 DESA',
										0,	101, 
										'TXT_1', 'TXT_2', 'TXT_3', 
										 7, -1, -1,			-- DESARROLLO
										-1, -1, -1 
GO


/****************************************************************/
/*				[PG_SK_CONFIGURACION_AMBIENTE]					*/
/****************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CONFIGURACION_AMBIENTE_GET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CONFIGURACION_AMBIENTE_GET]
GO


CREATE PROCEDURE [dbo].[PG_SK_CONFIGURACION_AMBIENTE_GET]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@OU_AMBIENTE			INT		OUTPUT
AS

	DECLARE	@VP_SISTEMA_OK		INT
	
	EXECUTE [dbo].[PG_SK_SISTEMA_VALIDAR_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												@OU_SISTEMA_OK = @VP_SISTEMA_OK		OUTPUT
	-- ======================
	-- EXECUTE [dbo].[PG_CF_PARAMETRO]	101, 'AMBIENTE',	'AMBIENTE', 10, '#0 N/A | #1 PROD | #2 PERF | #3 UAT | #4 CERT | #5 LAB | #6 UNIT | #7 DESA', 1 

	DECLARE	@VP_AMBIENTE		INT

	SELECT	@VP_AMBIENTE =		[VALOR_PARAMETRO_INT_1]
								FROM	VALOR_PARAMETRO, PARAMETRO 
								WHERE	VALOR_PARAMETRO.K_PARAMETRO=PARAMETRO.K_PARAMETRO
								AND		VALOR_PARAMETRO.K_PARAMETRO=101
								AND		VALOR_PARAMETRO.K_AMBIENTE=0			-- K_AMBIENTE = #0-NINGUNO
								AND		VALOR_PARAMETRO.K_SISTEMA=@VP_SISTEMA_OK
	-- =======================
	
	IF ( @VP_AMBIENTE IS NULL ) 
		SET @VP_AMBIENTE = 000
	
	-- =======================

	SET @OU_AMBIENTE = @VP_AMBIENTE

	-- =======================
GO


/****************************************************************/
/*				[PG_SK_CONFIGURACION_AMBIENTE]					*/
/****************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CONFIGURACION_AMBIENTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CONFIGURACION_AMBIENTE]
GO


CREATE PROCEDURE [dbo].[PG_SK_CONFIGURACION_AMBIENTE]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT
AS
	-- EXECUTE [dbo].[PG_CF_PARAMETRO]	101, 'AMBIENTE',	'AMBIENTE', 10, '#0 N/A | #1 PROD | #2 PERF | #3 UAT | #4 CERT | #5 LAB | #6 UNIT | #7 DESA', 1 

	DECLARE	@VP_AMBIENTE	INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_AMBIENTE_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															@OU_AMBIENTE = @VP_AMBIENTE		OUTPUT
	-- ======================

	DECLARE	@VP_K_PARAMETRO		INT

	SET		@VP_K_PARAMETRO =	101

	-- ======================
	
	IF ( @VP_AMBIENTE IS NULL ) 
		SET @VP_AMBIENTE = 000
	
	-- ======================
	
	SELECT	@VP_K_PARAMETRO		AS	'K_PARAMETRO', 
			@VP_AMBIENTE		AS	'AMBIENTE',
									'#0 N/A | #1 PROD | #2 PERF | #3 UAT | #4 CERT | #5 LAB | #6 UNIT | #7 DESA'
								AS	'VALORES'
	-- ======================
GO



/****************************************************************/
/* #102 | [PG_SK_VIGENCIA_PASSWORD]								*/
/****************************************************************/

EXECUTE [dbo].[PG_CF_PARAMETRO]			0, 0,
										102, 'VIGENCIA CONTRASEÑA',	'PWD', 10, 'PARAMETRO = @PP_DIAS_VIGENCIA', 1 
GO

EXECUTE [dbo].[PG_CF_VALOR_PARAMETRO]	0, 0, 0,
										1020, 'VIGENCIA CONTRASEÑA', '(PP_DIAS_VIGENCIA=ENTERO_1)',
										0, 102, 
										'TXT_1', 'TXT_2', 'TXT_3', 
										90, -1, -1, 
										-1, -1, -1 
GO


/****************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_VIGENCIA_PASSWORD_GET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_VIGENCIA_PASSWORD_GET]
GO

CREATE PROCEDURE [dbo].[PG_SK_VIGENCIA_PASSWORD_GET]
	@PP_L_DEBUG			INT,
	@PP_K_SISTEMA_EXE	INT,
	@OU_DIAS_VIGENCIA	INT		OUTPUT
AS

	DECLARE	@VP_SISTEMA_OK		INT
	
	EXECUTE [dbo].[PG_SK_SISTEMA_VALIDAR_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												@OU_SISTEMA_OK = @VP_SISTEMA_OK		OUTPUT
	-- ======================
	-- EXECUTE PG_CF_PARAMETRO 102, 'VIGENCIA CONTRASEÑA',	'PWD', 10, 'PARAMETRO = @PP_DIAS_VIGENCIA', 1 

	DECLARE @VP_INT_DIAS_VIGENCIA		INT		
	
	SELECT	@VP_INT_DIAS_VIGENCIA =		VALOR_PARAMETRO_INT_1
										FROM	VALOR_PARAMETRO, PARAMETRO 
										WHERE	VALOR_PARAMETRO.K_PARAMETRO=PARAMETRO.K_PARAMETRO
										AND		VALOR_PARAMETRO.K_PARAMETRO=102
										AND		VALOR_PARAMETRO.K_SISTEMA=@VP_SISTEMA_OK
	-- ==============================
		
	SET @OU_DIAS_VIGENCIA = @VP_INT_DIAS_VIGENCIA

	-- ==============================
GO




/****************************************************************/
/* #103 | [PG_SK_DEFAULT_PASSWORD]								*/
/****************************************************************/

EXECUTE [dbo].[PG_CF_PARAMETRO]			0, 0,
										103, 'DEFAULT CONTRASEÑA',	'PWD', 10, 'PARAMETRO = @PP_DEFAULT_PASSWORD', 1 
GO

EXECUTE [dbo].[PG_CF_VALOR_PARAMETRO]	0, 0, 0,
										1030, 'DEFAULT CONTRASEÑA', '',
										0, 103, 
										'123456', 'TXT_2', 'TXT_3', 
										-1, -1, -1, 
										-1, -1, -1 
GO


/****************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_DEFAULT_PASSWORD_GET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_DEFAULT_PASSWORD_GET]
GO


CREATE PROCEDURE [dbo].[PG_SK_DEFAULT_PASSWORD_GET]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@OU_DEFAULT_PASSWORD	VARCHAR(100)	OUTPUT
AS
	
	DECLARE	@VP_SISTEMA_OK		INT
	
	EXECUTE [dbo].[PG_SK_SISTEMA_VALIDAR_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												@OU_SISTEMA_OK = @VP_SISTEMA_OK		OUTPUT
	-- ======================
	-- EXECUTE PG_CF_PARAMETRO 103, 'DEFAULT CONTRASEÑA','PWD', 10, 'PARAMETRO = @PP_DEFAULT_PASSWORD', 1 

	DECLARE @VP_DEFAULT_PASSWORD		VARCHAR(100)		
	
	SELECT	@VP_DEFAULT_PASSWORD =		VALOR_PARAMETRO_TXT_1
										FROM	VALOR_PARAMETRO, PARAMETRO 
										WHERE	VALOR_PARAMETRO.K_PARAMETRO=PARAMETRO.K_PARAMETRO
										AND		VALOR_PARAMETRO.K_PARAMETRO=103
										AND		VALOR_PARAMETRO.K_SISTEMA=@VP_SISTEMA_OK
	-- ==============================
	
	SET @OU_DEFAULT_PASSWORD = @VP_DEFAULT_PASSWORD
	
	-- ==============================
GO


/****************************************************************/
/* #104 | [PG_SK_ERROR_SQL_SHOW]								*/
/****************************************************************/

EXECUTE [dbo].[PG_CF_PARAMETRO]			0, 0,
										104, 'MOSTRAR ERROR DE SQL',	'SQLERR', 10, 'PARAMETRO = @PP_ERROR_SQL_SHOW', 1 
GO

EXECUTE [dbo].[PG_CF_VALOR_PARAMETRO]	0, 0, 1001,
										1040, 'MOSTRAR ERROR DE SQL', '(PP_ERROR_SQL_SHOW=ENTERO_1)',
										0, 104, 
										'TXT_3', 'TXT_2', 'TXT_3', 
										 0, -1, -1, 
										-1, -1, -1 
GO

/****************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_ERROR_SQL_SHOW_GET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_ERROR_SQL_SHOW_GET]
GO

CREATE PROCEDURE [dbo].[PG_SK_ERROR_SQL_SHOW_GET]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@OU_ERROR_SQL_SHOW		INT		OUTPUT
AS
	
	DECLARE	@VP_SISTEMA_OK		INT
	
	EXECUTE [dbo].[PG_SK_SISTEMA_VALIDAR_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												@OU_SISTEMA_OK = @VP_SISTEMA_OK		OUTPUT
	-- ==========================
	-- EXECUTE PG_CF_PARAMETRO 104, 'MOSTRAR ERROR DE SQL',	'SQLERR', 10, 'PARAMETRO = @PP_ERROR_SQL_SHOW', 1 

	DECLARE @VP_ERROR_SQL_SHOW		INT		

	SELECT	@VP_ERROR_SQL_SHOW =	VALOR_PARAMETRO_INT_1
									FROM	VALOR_PARAMETRO, PARAMETRO 
									WHERE	VALOR_PARAMETRO.K_PARAMETRO=PARAMETRO.K_PARAMETRO
									AND		VALOR_PARAMETRO.K_PARAMETRO=104
									AND		VALOR_PARAMETRO.K_SISTEMA=@VP_SISTEMA_OK
	-- ==========================
	
	SET @OU_ERROR_SQL_SHOW = @VP_ERROR_SQL_SHOW
	
	-- ==========================
GO


/****************************************************************/
/*								UPDATE							*/
/****************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SQ_MENSAJE_SQL_VALIDAR_GET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SQ_MENSAJE_SQL_VALIDAR_GET]
GO

CREATE PROCEDURE [dbo].[PG_SQ_MENSAJE_SQL_VALIDAR_GET]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_MENSAJE_SQL_ORIGINAL	VARCHAR(300),
	@OU_MENSAJE_SQL_AJUSTADO	VARCHAR(300)	OUTPUT
AS
	
	DECLARE	@VP_SISTEMA_OK		INT
	
	EXECUTE [dbo].[PG_SK_SISTEMA_VALIDAR_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												@OU_SISTEMA_OK = @VP_SISTEMA_OK		OUTPUT
	-- ====================================

	DECLARE @VP_ERROR_SQL_SHOW		INT		

	EXECUTE [dbo].[PG_SK_ERROR_SQL_SHOW_GET]	@PP_L_DEBUG, @VP_SISTEMA_OK,
												@OU_ERROR_SQL_SHOW = @VP_ERROR_SQL_SHOW		OUTPUT
	-- ====================================
	
	DECLARE @VP_MENSAJE_SQL	VARCHAR(300)

	-- ====================================
	
	IF @VP_ERROR_SQL_SHOW=1
		SET @VP_MENSAJE_SQL = '' + @PP_MENSAJE_SQL_ORIGINAL
	ELSE
		BEGIN
		IF @PP_MENSAJE_SQL_ORIGINAL LIKE '%REFERENCE%'
			SET @VP_MENSAJE_SQL = 'Existen registros relacionados [FK] en otras tablas.'
		ELSE
			SET @VP_MENSAJE_SQL = '' + @PP_MENSAJE_SQL_ORIGINAL
		END

	-- ====================================

	SET @OU_MENSAJE_SQL_AJUSTADO	= @VP_MENSAJE_SQL	

	-- ====================================
GO


/****************************************************************/
/* #105 | [PG_SK_CONFIGURACION_SHOW_DELETE]						*/
/****************************************************************/

EXECUTE [dbo].[PG_CF_PARAMETRO]			0, 0,
										105, 'MOSTRAR REGISTROS BORRADOS',	'MAXRW', 10, 'PARAMETRO = @PP_SHOW_DELETE', 1 
GO

EXECUTE [dbo].[PG_CF_VALOR_PARAMETRO]	0, 0, 0,
										1050, 'MOSTRAR REGISTROS BORRADOS', '(PP_SHOW_DELETE=ENTERO_1)',
										0, 105, 
										'TXT_1', 'TXT_2', 'TXT_3', 
										 0, -1, -1, 
										-1, -1, -1 
GO

/****************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CONFIGURACION_SHOW_DELETE_GET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CONFIGURACION_SHOW_DELETE_GET]
GO


CREATE PROCEDURE [dbo].[PG_SK_CONFIGURACION_SHOW_DELETE_GET]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@OU_SHOW_DELETE			INT			OUTPUT
AS
	
	DECLARE	@VP_SISTEMA_OK		INT
	
	EXECUTE [dbo].[PG_SK_SISTEMA_VALIDAR_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												@OU_SISTEMA_OK = @VP_SISTEMA_OK		OUTPUT
	-- ======================
	-- EXECUTE PG_CF_PARAMETRO 105, 'MOSTRAR REGISTROS BORRADOS',	'MAXRW', 10, 'PARAMETRO = @PP_SHOW_DELETE', 1 

	DECLARE @VP_INT_SHOW_DELETE		INT		

	SELECT	@VP_INT_SHOW_DELETE =	VALOR_PARAMETRO_INT_1
									FROM	VALOR_PARAMETRO, PARAMETRO 
									WHERE	VALOR_PARAMETRO.K_PARAMETRO=PARAMETRO.K_PARAMETRO
									AND		VALOR_PARAMETRO.K_PARAMETRO=105
									AND		VALOR_PARAMETRO.K_SISTEMA=@VP_SISTEMA_OK
	-- =======================
	
	IF @VP_INT_SHOW_DELETE IS NULL
		SET @VP_INT_SHOW_DELETE = 0
	
	-- =======================
	
	SET @OU_SHOW_DELETE = @VP_INT_SHOW_DELETE

	-- =======================
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CONFIGURACION_SHOW_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CONFIGURACION_SHOW_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_SK_CONFIGURACION_SHOW_DELETE]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT
AS
	
	DECLARE	@VP_SISTEMA_OK		INT
	
	EXECUTE [dbo].[PG_SK_SISTEMA_VALIDAR_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												@OU_SISTEMA_OK = @VP_SISTEMA_OK		OUTPUT
	-- ========================================

	DECLARE @VP_SHOW_DELETE		INT		

	EXECUTE [dbo].[PG_SK_CONFIGURACION_SHOW_DELETE_GET]		@PP_L_DEBUG, @VP_SISTEMA_OK,
															@OU_SHOW_DELETE = @VP_SHOW_DELETE	OUTPUT
	-- ========================================

	IF @VP_SHOW_DELETE IS NULL
		SET @VP_SHOW_DELETE = 0

	-- ========================================
	
	SELECT @VP_SHOW_DELETE AS L_SHOW_DELETE

	-- ========================================
GO



-- /////////////////////////////////////////////////////////////////
-- 22222222222222222222222222222222222222222222222222222222222222222
-- 22222222222222222222222222222222222222222222222222222222222222222
-- 22222222222222222222222222222222222222222222222222222222222222222
-- /////////////////////////////////////////////////////////////////


/****************************************************************/
/* #201 | [PG_SK_CONFIGURACION_COMBO_K_SHOW]					*/
/****************************************************************/

EXECUTE [dbo].[PG_CF_PARAMETRO]			0, 0,
										201, 'MOSTRAR [#KK]',	'KCMBX', 10, 'PARAMETRO = @PP_SHOW_K', 1 
GO

EXECUTE [dbo].[PG_CF_VALOR_PARAMETRO]	0, 0, 0,
										2010, 'CB_SHOW #KK', 'APLICA PARA TODOS LOS COMBOS',
										0, 201, 
										'TXT_1', 'TXT_2', 'TXT_3', 
										 1, -1, -1, 
										-1, -1, -1 
GO

/****************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CONFIGURACION_COMBO_SHOW_K_GET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CONFIGURACION_COMBO_SHOW_K_GET]
GO


CREATE PROCEDURE [dbo].[PG_SK_CONFIGURACION_COMBO_SHOW_K_GET]
	@PP_L_DEBUG			INT,
	@PP_K_SISTEMA_EXE	INT,
	@OU_SHOW_K			INT		OUTPUT
AS
	
	DECLARE	@VP_SISTEMA_OK		INT
	
	EXECUTE [dbo].[PG_SK_SISTEMA_VALIDAR_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												@OU_SISTEMA_OK = @VP_SISTEMA_OK		OUTPUT
	-- =========================
	-- EXECUTE PG_CF_PARAMETRO 201, 'MOSTRAR [#KK]',	'KCMBX', 10, 'PARAMETRO = @PP_SHOW_K', 1 

	DECLARE		@VP_INT_SHOW_K		INT		

	SELECT		@VP_INT_SHOW_K =	VALOR_PARAMETRO_INT_1
									FROM	VALOR_PARAMETRO, PARAMETRO 
									WHERE	VALOR_PARAMETRO.K_PARAMETRO=PARAMETRO.K_PARAMETRO
									AND		VALOR_PARAMETRO.K_PARAMETRO=201
									AND		VALOR_PARAMETRO.K_SISTEMA=@VP_SISTEMA_OK
	-- =========================
	
	SET @OU_SHOW_K = @VP_INT_SHOW_K

	-- =========================
GO



/****************************************************************/
/* #202 | [PG_SK_CONFIGURACION_LISTADO_MAX_ROWS]				*/
/****************************************************************/

EXECUTE [dbo].[PG_CF_PARAMETRO]			0, 0,
										202, 'RENGLONES EN LISTADO/LIGERO',	'MAXRW', 10, 'PARAMETRO = @PP_MAXROWS', 1 
GO

EXECUTE [dbo].[PG_CF_VALOR_PARAMETRO]	0, 0, 0,
										2020, 'TOP | MAX ROWS', '(PP_MAXROWS=ENTERO_1)',
										0, 202, 
										'TXT_1', 'TXT_2', 'TXT_3', 
										1234, -1, -1, 
										-1, -1, -1 
GO

/****************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]
GO


-- CREATE PROCEDURE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_GET]
CREATE PROCEDURE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_L_APLICAR_MAX_ROWS		INT,
	@OU_LI_N_REGISTROS			INT		OUTPUT
AS
	
	DECLARE	@VP_SISTEMA_OK		INT
	
	EXECUTE [dbo].[PG_SK_SISTEMA_VALIDAR_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												@OU_SISTEMA_OK = @VP_SISTEMA_OK		OUTPUT
	-- ====================================
	-- EXECUTE PG_CF_PARAMETRO 202, 'RENGLONES EN LISTADO',	'MAXRW', 10, 'PARAMETRO = @PP_MAXROWS', 1

	DECLARE @VP_INT_MAXROWS		INT		
	
	IF @PP_L_APLICAR_MAX_ROWS=1
		SELECT	@VP_INT_MAXROWS =	VALOR_PARAMETRO_INT_1
									FROM	VALOR_PARAMETRO, PARAMETRO 
									WHERE	VALOR_PARAMETRO.K_PARAMETRO=PARAMETRO.K_PARAMETRO
									AND		VALOR_PARAMETRO.K_PARAMETRO=202
									AND		VALOR_PARAMETRO.K_SISTEMA=@VP_SISTEMA_OK
	ELSE
		SET @VP_INT_MAXROWS = 50000

	-- ====================================
	
	SET @OU_LI_N_REGISTROS = @VP_INT_MAXROWS
	
	-- ====================================
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS]
GO


-- CREATE PROCEDURE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS]
CREATE PROCEDURE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT
AS
	
	DECLARE	@VP_SISTEMA_OK		INT
	
	EXECUTE [dbo].[PG_SK_SISTEMA_VALIDAR_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												@OU_SISTEMA_OK = @VP_SISTEMA_OK		OUTPUT
	-- ====================================

	DECLARE @VP_INT_MAXROWS		INT		

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]		@PP_L_DEBUG, @VP_SISTEMA_OK, 1,
																@OU_LI_N_REGISTROS = @VP_INT_MAXROWS	OUTPUT
	-- ====================================

	IF @VP_INT_MAXROWS IS NULL
		SET @VP_INT_MAXROWS = 100

	IF @VP_INT_MAXROWS = 0
		SET @VP_INT_MAXROWS = 100

	-- ====================================
	
	SELECT @VP_INT_MAXROWS AS N_MAXROWS

	-- ====================================
GO



/****************************************************************/
/* #203 | [PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO]			*/
/****************************************************************/

EXECUTE [dbo].[PG_CF_PARAMETRO]			0, 0,
										203, 'RENGLONES EN LISTADO/PESADO',	'MAXRW', 10, 'PARAMETRO = @PP_MAXROWS', 1 
GO

EXECUTE [dbo].[PG_CF_VALOR_PARAMETRO]	0, 0, 0,
										2030, 'TOP | MAX ROWS', '(PP_MAXROWS=ENTERO_1) | APLICA PARA TODOS CLIENTES/COLONIAS/EXPEDIENTES',
										0, 203, 
										'TXT_1', 'TXT_2', 'TXT_3', 
										1500, -1, -1, 
										-1, -1, -1 
GO




/****************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]
GO


CREATE PROCEDURE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_L_APLICAR_MAX_ROWS		INT,
	@OU_MAXROWS					INT		OUTPUT
AS
	
	DECLARE	@VP_SISTEMA_OK		INT
	
	EXECUTE [dbo].[PG_SK_SISTEMA_VALIDAR_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												@OU_SISTEMA_OK = @VP_SISTEMA_OK		OUTPUT
	-- ====================================
	-- EXECUTE PG_CF_PARAMETRO 203, 'RENGLONES EN LISTADO/PESADO',	'MAXRW', 10, 'PARAMETRO = @PP_MAXROWS', 1 

	DECLARE @VP_INT_MAXROWS		INT		
	
	IF @PP_L_APLICAR_MAX_ROWS=1
		SELECT	@VP_INT_MAXROWS =	VALOR_PARAMETRO_INT_1
									FROM	VALOR_PARAMETRO, PARAMETRO 
									WHERE	VALOR_PARAMETRO.K_PARAMETRO=PARAMETRO.K_PARAMETRO
									AND		VALOR_PARAMETRO.K_PARAMETRO=203
									AND		VALOR_PARAMETRO.K_SISTEMA=@VP_SISTEMA_OK
	ELSE
		SET @VP_INT_MAXROWS = 50000
	
	-- ====================================
	
	SET @OU_MAXROWS = @VP_INT_MAXROWS

	-- ====================================
GO





/****************************************************************/
/* #204 |   PASSWORD DE DESARROLLO		*/
/****************************************************************/

EXECUTE [dbo].[PG_CF_PARAMETRO]			0, 0,
										204, 'PASSWORD DESARROLLO',	'PWDDS', 10, 'VERIFY', 1 
GO

EXECUTE [dbo].[PG_CF_VALOR_PARAMETRO]	0, 0, 0,
										2040, 'PASSWORD DE DESARROLLO', 'PARA LOGIN',
										0, 204, 
										'FL5', '', '', 
										-1, -1, -1, 
										-1, -1, -1 
GO




-- ////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////

