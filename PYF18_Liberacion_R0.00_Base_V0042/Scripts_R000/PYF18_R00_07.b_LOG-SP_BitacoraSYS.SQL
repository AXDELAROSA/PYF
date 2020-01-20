-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	[PYF18_Finanzas]
-- // MODULO:			
-- // OPERACION:		LIBERACION / 
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////



-- EXECUTE [dbo].[PG_LI_BITACORA_SYS] 0,0,0, '21/JUN/2018', -1, -1, -1, 'PORT'



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_BITACORA_SYS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_BITACORA_SYS]
GO


CREATE PROCEDURE [dbo].[PG_LI_BITACORA_SYS]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_L_APLICAR_MAX_ROWS				INT,
	@PP_F_BITACORA_SYS					DATE,
	@PP_K_CLASE_BITACORA_SYS			INT,
	@PP_K_IMPORTANCIA_BITACORA_SYS		INT,
	@PP_K_GRUPO_BITACORA_SYS			INT,
	@PP_D_BITACORA_SYS					VARCHAR(100)
AS
	
	DECLARE @VP_K_FOLIO	INT

	-- ===========================================

	DECLARE @VP_LI_N_REGISTROS		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															@PP_L_APLICAR_MAX_ROWS,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- ===========================================

	DECLARE @VP_YYYY	INT
	DECLARE @VP_MM		INT
	DECLARE @VP_DD		INT

	SET @VP_YYYY =		YEAR(@PP_F_BITACORA_SYS)
	SET @VP_MM =		MONTH(@PP_F_BITACORA_SYS)
	SET @VP_DD =		DAY(@PP_F_BITACORA_SYS)

	-- ===========================================

	SELECT	TOP (@VP_LI_N_REGISTROS)
			S_SISTEMA,
			S_IMPORTANCIA_BITACORA_SYS, S_CLASE_BITACORA_SYS, S_GRUPO_BITACORA_SYS,
			LOGIN_ID, 
			BITACORA_SYS.*
	FROM	SISTEMA,
			IMPORTANCIA_BITACORA_SYS, 
			CLASE_BITACORA_SYS, GRUPO_BITACORA_SYS,
			BITACORA_SYS LEFT JOIN USUARIO
				ON BITACORA_SYS.K_USUARIO=USUARIO.K_USUARIO
	WHERE	BITACORA_SYS.K_IMPORTANCIA_BITACORA_SYS=IMPORTANCIA_BITACORA_SYS.K_IMPORTANCIA_BITACORA_SYS
	AND		BITACORA_SYS.K_CLASE_BITACORA_SYS=CLASE_BITACORA_SYS.K_CLASE_BITACORA_SYS
	AND		BITACORA_SYS.K_GRUPO_BITACORA_SYS=GRUPO_BITACORA_SYS.K_GRUPO_BITACORA_SYS
	AND		BITACORA_SYS.K_SISTEMA=SISTEMA.K_SISTEMA
			-- ===========================================
	AND		(	D_BITACORA_SYS		LIKE '%'+@PP_D_BITACORA_SYS+'%' 
			OR  C_BITACORA_SYS		LIKE '%'+@PP_D_BITACORA_SYS+'%' 
			OR  STORED_PROCEDURE	LIKE '%'+@PP_D_BITACORA_SYS+'%' 	
				-- ===========================================
			OR  D_USUARIO			LIKE '%'+@PP_D_BITACORA_SYS+'%' 	
				-- ===========================================
			OR	K_FOLIO_1 = @VP_K_FOLIO 
			OR	K_FOLIO_2 = @VP_K_FOLIO			)
			-- ===========================================
	AND		( @PP_K_SISTEMA_EXE=-1				OR @PP_K_SISTEMA_EXE=BITACORA_SYS.K_SISTEMA )
	AND		( @PP_K_CLASE_BITACORA_SYS=-1		OR @PP_K_CLASE_BITACORA_SYS=BITACORA_SYS.K_CLASE_BITACORA_SYS )
	AND		( @PP_K_IMPORTANCIA_BITACORA_SYS=-1	OR @PP_K_IMPORTANCIA_BITACORA_SYS=BITACORA_SYS.K_IMPORTANCIA_BITACORA_SYS )
	AND		( @PP_K_GRUPO_BITACORA_SYS=-1		OR @PP_K_GRUPO_BITACORA_SYS=BITACORA_SYS.K_GRUPO_BITACORA_SYS )
			-- ===========================================
	AND		( @PP_F_BITACORA_SYS IS NULL		OR	(			@VP_YYYY=YEAR(F_BITACORA_SYS)
														AND		@VP_MM=MONTH(F_BITACORA_SYS)
														AND		@VP_DD=DAY(F_BITACORA_SYS)	)		)
			-- ===========================================
	ORDER BY K_SISTEMA, K_BITACORA_SYS

	-- ========================================
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_BITACORA_SYS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_BITACORA_SYS]
GO


CREATE PROCEDURE [dbo].[PG_IN_BITACORA_SYS]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO					[INT],
	-- ===========================================
	@PP_K_CLASE_BITACORA_SYS		[INT],
	@PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
	@PP_K_GRUPO_BITACORA_SYS		[INT],
	@PP_D_BITACORA_SYS				[VARCHAR] (100),
	@PP_C_BITACORA_SYS				[VARCHAR] (1000),
	-- ===========================================
	@PP_STORED_PROCEDURE			[VARCHAR] (100),
	@PP_K_FOLIO_1					[INT],
	@PP_K_FOLIO_2					[INT],
	-- ===========================================
	@PP_VALOR_1_INT				[INT],
	@PP_VALOR_2_INT				[INT],
	@PP_VALOR_3_STR				[VARCHAR] (100),
	@PP_VALOR_4_STR				[VARCHAR] (100),
	@PP_VALOR_5_DEC				DECIMAL(19,4),
	@PP_VALOR_6_DEC				DECIMAL(19,4),
	-- ===========================================
	@PP_VALOR_1_DATO			[VARCHAR] (20),
	@PP_VALOR_2_DATO			[VARCHAR] (20),
	@PP_VALOR_3_DATO			[VARCHAR] (20),
	@PP_VALOR_4_DATO			[VARCHAR] (20),
	@PP_VALOR_5_DATO			[VARCHAR] (20),
	@PP_VALOR_6_DATO			[VARCHAR] (20)
AS

	DECLARE @VP_F_BITACORA_SYS			[DATETIME] 
	
	SET @VP_F_BITACORA_SYS = GETDATE()

	-- ========================================

	INSERT INTO BITACORA_SYS
		(	K_SISTEMA,
			F_BITACORA_SYS, F_BITACORA_SYS_EVENTO,
			K_USUARIO,
			-- ===========================================
			K_CLASE_BITACORA_SYS, K_IMPORTANCIA_BITACORA_SYS, K_GRUPO_BITACORA_SYS,
			D_BITACORA_SYS, C_BITACORA_SYS,
			-- ===========================================
			STORED_PROCEDURE, K_FOLIO_1, K_FOLIO_2,
			-- ===========================================
			VALOR_1_INT,	VALOR_2_INT,
			VALOR_3_STR,	VALOR_4_STR,
			VALOR_5_DEC,	VALOR_6_DEC,
			-- ===========================================
			VALOR_1_DATO,	VALOR_2_DATO,
			VALOR_3_DATO,	VALOR_4_DATO,
			VALOR_5_DATO,	VALOR_6_DATO		)

	VALUES	
		(	@PP_K_SISTEMA_EXE,
			@VP_F_BITACORA_SYS, @VP_F_BITACORA_SYS, 
			@PP_K_USUARIO,
			-- ===========================================
			@PP_K_CLASE_BITACORA_SYS, @PP_K_IMPORTANCIA_BITACORA_SYS, @PP_K_GRUPO_BITACORA_SYS,
			@PP_D_BITACORA_SYS, @PP_C_BITACORA_SYS,
			-- ===========================================
			@PP_STORED_PROCEDURE, @PP_K_FOLIO_1, @PP_K_FOLIO_2,
			-- ===========================================
			@PP_VALOR_1_INT,	@PP_VALOR_2_INT,
			@PP_VALOR_3_STR,	@PP_VALOR_4_STR,
			@PP_VALOR_5_DEC,	@PP_VALOR_6_DEC,
			-- ===========================================
			@PP_VALOR_1_DATO,	@PP_VALOR_2_DATO,
			@PP_VALOR_3_DATO,	@PP_VALOR_4_DATO,
			@PP_VALOR_5_DATO,	@PP_VALOR_6_DATO		)

	-- ========================================
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_BITACORA_SYS_BASICO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_BITACORA_SYS_BASICO]
GO


CREATE PROCEDURE [dbo].[PG_IN_BITACORA_SYS_BASICO]
	@PP_L_DEBUG						[INT],
	-- ===========================================
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO					[INT],
	-- ===========================================
	@PP_K_CLASE_BITACORA_SYS		[INT],
	@PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
	@PP_K_GRUPO_BITACORA_SYS		[INT],
	@PP_D_BITACORA_SYS				[VARCHAR] (100),
	@PP_C_BITACORA_SYS				[VARCHAR] (1000),
	-- ===========================================
	@PP_STORED_PROCEDURE			[VARCHAR] (100),
	@PP_K_FOLIO_1					[INT],
	@PP_K_FOLIO_2					[INT]
AS

	DECLARE		@VP_VALOR_1_INT				[INT],
				@VP_VALOR_2_INT				[INT],
				@VP_VALOR_3_STR				[VARCHAR] (100),
				@VP_VALOR_4_STR				[VARCHAR] (100),
				@VP_VALOR_5_DEC				DECIMAL(19,4),
				@VP_VALOR_6_DEC				DECIMAL(19,4)
	
	SET			@VP_VALOR_1_INT				= 0
	SET			@VP_VALOR_2_INT				= 0
	SET			@VP_VALOR_3_STR				= ''
	SET			@VP_VALOR_4_STR				= ''
	SET			@VP_VALOR_5_DEC				= 0
	SET			@VP_VALOR_6_DEC				= 0
		
	-- ========================================
				
	DECLARE		@VP_VALOR_1_DATO			[VARCHAR] (20),
				@VP_VALOR_2_DATO			[VARCHAR] (20),
				@VP_VALOR_3_DATO			[VARCHAR] (20),
				@VP_VALOR_4_DATO			[VARCHAR] (20),
				@VP_VALOR_5_DATO			[VARCHAR] (20),
				@VP_VALOR_6_DATO			[VARCHAR] (20)
	
	SET			@VP_VALOR_1_DATO			= ''
	SET			@VP_VALOR_2_DATO			= ''
	SET			@VP_VALOR_3_DATO			= ''
	SET			@VP_VALOR_4_DATO			= ''
	SET			@VP_VALOR_5_DATO			= ''
	SET			@VP_VALOR_6_DATO			= ''

	-- ========================================

	EXECUTE [dbo].[PG_IN_BITACORA_SYS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO,
										-- ===========================================
										@PP_K_CLASE_BITACORA_SYS, @PP_K_IMPORTANCIA_BITACORA_SYS, @PP_K_GRUPO_BITACORA_SYS,
										@PP_D_BITACORA_SYS, @PP_C_BITACORA_SYS,
										-- ===========================================
										@PP_STORED_PROCEDURE, @PP_K_FOLIO_1, @PP_K_FOLIO_2,
										-- ===========================================
										@VP_VALOR_1_INT, @VP_VALOR_2_INT,
										@VP_VALOR_3_STR, @VP_VALOR_4_STR,
										@VP_VALOR_5_DEC, @VP_VALOR_6_DEC,
										-- ===========================================
										@VP_VALOR_1_DATO, @VP_VALOR_2_DATO,
										@VP_VALOR_3_DATO, @VP_VALOR_4_DATO, 
										@VP_VALOR_5_DATO, @VP_VALOR_6_DATO

	-- ========================================
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_BITACORA_SYS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_BITACORA_SYS]
GO


CREATE PROCEDURE [dbo].[PG_IN_BITACORA_SYS]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO					[INT],
	-- ===========================================
	@PP_K_CLASE_BITACORA_SYS		[INT],
	@PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
	@PP_K_GRUPO_BITACORA_SYS		[INT],
	@PP_D_BITACORA_SYS				[VARCHAR] (100),
	@PP_C_BITACORA_SYS				[VARCHAR] (1000),
	-- ===========================================
	@PP_STORED_PROCEDURE			[VARCHAR] (100),
	@PP_K_FOLIO_1					[INT],
	@PP_K_FOLIO_2					[INT],
	-- ===========================================
	@PP_VALOR_1_INT				[INT],
	@PP_VALOR_2_INT				[INT],
	@PP_VALOR_3_STR				[VARCHAR] (100),
	@PP_VALOR_4_STR				[VARCHAR] (100),
	@PP_VALOR_5_DEC				DECIMAL(19,4),
	@PP_VALOR_6_DEC				DECIMAL(19,4),
	-- ===========================================
	@PP_VALOR_1_DATO			[VARCHAR] (20),
	@PP_VALOR_2_DATO			[VARCHAR] (20),
	@PP_VALOR_3_DATO			[VARCHAR] (20),
	@PP_VALOR_4_DATO			[VARCHAR] (20),
	@PP_VALOR_5_DATO			[VARCHAR] (20),
	@PP_VALOR_6_DATO			[VARCHAR] (20)
AS

	DECLARE @VP_F_BITACORA_SYS			[DATETIME] 
	
	SET @VP_F_BITACORA_SYS = GETDATE()

	-- ========================================

	INSERT INTO BITACORA_SYS
		(	K_SISTEMA,
			F_BITACORA_SYS, F_BITACORA_SYS_EVENTO,
			K_USUARIO,
			-- ===========================================
			K_CLASE_BITACORA_SYS, K_IMPORTANCIA_BITACORA_SYS, K_GRUPO_BITACORA_SYS,
			D_BITACORA_SYS, C_BITACORA_SYS,
			-- ===========================================
			STORED_PROCEDURE, K_FOLIO_1, K_FOLIO_2,
			-- ===========================================
			VALOR_1_INT,	VALOR_2_INT,
			VALOR_3_STR,	VALOR_4_STR,
			VALOR_5_DEC,	VALOR_6_DEC,
			-- ===========================================
			VALOR_1_DATO,	VALOR_2_DATO,
			VALOR_3_DATO,	VALOR_4_DATO,
			VALOR_5_DATO,	VALOR_6_DATO		)

	VALUES	
		(	@PP_K_SISTEMA_EXE,
			@VP_F_BITACORA_SYS, @VP_F_BITACORA_SYS, 
			@PP_K_USUARIO,
			-- ===========================================
			@PP_K_CLASE_BITACORA_SYS, @PP_K_IMPORTANCIA_BITACORA_SYS, @PP_K_GRUPO_BITACORA_SYS,
			@PP_D_BITACORA_SYS, @PP_C_BITACORA_SYS,
			-- ===========================================
			@PP_STORED_PROCEDURE, @PP_K_FOLIO_1, @PP_K_FOLIO_2,
			-- ===========================================
			@PP_VALOR_1_INT,	@PP_VALOR_2_INT,
			@PP_VALOR_3_STR,	@PP_VALOR_4_STR,
			@PP_VALOR_5_DEC,	@PP_VALOR_6_DEC,
			-- ===========================================
			@PP_VALOR_1_DATO,	@PP_VALOR_2_DATO,
			@PP_VALOR_3_DATO,	@PP_VALOR_4_DATO,
			@PP_VALOR_5_DATO,	@PP_VALOR_6_DATO		)

	-- ========================================
GO






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_BITACORA_SYS_OPERACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_BITACORA_SYS_OPERACION]
GO


CREATE PROCEDURE [dbo].[PG_IN_BITACORA_SYS_OPERACION]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO					[INT],
	-- ===========================================
	@PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
	@PP_D_BITACORA_SYS				[VARCHAR] (100),
	@PP_C_BITACORA_SYS				[VARCHAR] (1000),
	-- ===========================================
	@PP_STORED_PROCEDURE			[VARCHAR] (100),
	@PP_K_FOLIO_1					[INT],
	@PP_K_FOLIO_2					[INT],
	-- ===========================================
	@PP_VALOR_1_INT				[INT],
	@PP_VALOR_2_INT				[INT],
	@PP_VALOR_3_STR				[VARCHAR] (100),
	@PP_VALOR_4_STR				[VARCHAR] (100),
	@PP_VALOR_5_DEC				DECIMAL(19,4),
	@PP_VALOR_6_DEC				DECIMAL(19,4),
	-- ===========================================
	@PP_VALOR_1_DATO			[VARCHAR] (20),
	@PP_VALOR_2_DATO			[VARCHAR] (20),
	@PP_VALOR_3_DATO			[VARCHAR] (20),
	@PP_VALOR_4_DATO			[VARCHAR] (20),
	@PP_VALOR_5_DATO			[VARCHAR] (20),
	@PP_VALOR_6_DATO			[VARCHAR] (20)
AS

	DECLARE @VP_F_BITACORA_SYS			[DATETIME] 
	
	SET @VP_F_BITACORA_SYS = GETDATE()

	-- ========================================
	
	DECLARE @VP_K_CLASE_BITACORA_SYS	[INT] = 6		-- #6, 'TRANSACCION/USR',	'TRANS'
	DECLARE @VP_K_GRUPO_BITACORA_SYS	[INT] = 3		-- #3, 'OPERACION',			'OPERA'

	-- ========================================

	IF @PP_C_BITACORA_SYS IS NULL
		SET @PP_C_BITACORA_SYS=''
	IF @PP_STORED_PROCEDURE IS NULL
		SET @PP_STORED_PROCEDURE=''
	IF @PP_VALOR_3_STR IS NULL
		SET @PP_VALOR_3_STR=''
	IF @PP_VALOR_4_STR IS NULL
		SET @PP_VALOR_4_STR=''
	IF @PP_VALOR_1_DATO IS NULL
		SET @PP_VALOR_1_DATO=''
	IF @PP_VALOR_2_DATO IS NULL
		SET @PP_VALOR_2_DATO=''
	IF @PP_VALOR_3_DATO IS NULL
		SET @PP_VALOR_3_DATO=''
	IF @PP_VALOR_4_DATO IS NULL
		SET @PP_VALOR_4_DATO=''
	IF @PP_VALOR_5_DATO IS NULL
		SET @PP_VALOR_5_DATO=''
	IF @PP_VALOR_6_DATO IS NULL
		SET @PP_VALOR_6_DATO=''

	INSERT INTO BITACORA_SYS
		(	K_SISTEMA,
			F_BITACORA_SYS, F_BITACORA_SYS_EVENTO,
			K_USUARIO,
			-- ===========================================
			K_CLASE_BITACORA_SYS, K_IMPORTANCIA_BITACORA_SYS, K_GRUPO_BITACORA_SYS,
			D_BITACORA_SYS, C_BITACORA_SYS,
			-- ===========================================
			STORED_PROCEDURE, K_FOLIO_1, K_FOLIO_2,
			-- ===========================================
			VALOR_1_INT,	VALOR_2_INT,
			VALOR_3_STR,	VALOR_4_STR,
			VALOR_5_DEC,	VALOR_6_DEC,
			-- ===========================================
			VALOR_1_DATO,	VALOR_2_DATO,
			VALOR_3_DATO,	VALOR_4_DATO,
			VALOR_5_DATO,	VALOR_6_DATO		)

	VALUES	
		(	@PP_K_SISTEMA_EXE,
			@VP_F_BITACORA_SYS, @VP_F_BITACORA_SYS, 
			@PP_K_USUARIO,
			-- ===========================================
			@VP_K_CLASE_BITACORA_SYS, @PP_K_IMPORTANCIA_BITACORA_SYS, @VP_K_GRUPO_BITACORA_SYS,
			@PP_D_BITACORA_SYS, @PP_C_BITACORA_SYS,
			-- ===========================================
			@PP_STORED_PROCEDURE, @PP_K_FOLIO_1, @PP_K_FOLIO_2,
			-- ===========================================
			@PP_VALOR_1_INT,	@PP_VALOR_2_INT,
			@PP_VALOR_3_STR,	@PP_VALOR_4_STR,
			@PP_VALOR_5_DEC,	@PP_VALOR_6_DEC,
			-- ===========================================
			@PP_VALOR_1_DATO,	@PP_VALOR_2_DATO,
			@PP_VALOR_3_DATO,	@PP_VALOR_4_DATO,
			@PP_VALOR_5_DATO,	@PP_VALOR_6_DATO		)

	-- ========================================
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_BITACORA_SYS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_BITACORA_SYS]
GO


CREATE PROCEDURE [dbo].[PG_DL_BITACORA_SYS]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_BITACORA_SYS		INT
AS
	
	DELETE	
	FROM	BITACORA_SYS
	WHERE	K_SISTEMA=@PP_K_SISTEMA_EXE
	AND		K_BITACORA_SYS=@PP_K_BITACORA_SYS

	-- =======================================
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_BITACORA_SYS_X_K_GRUPO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_BITACORA_SYS_X_K_GRUPO]
GO


CREATE PROCEDURE [dbo].[PG_DL_BITACORA_SYS_X_K_GRUPO]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_GRUPO_BITACORA_SYS	[INT] 
AS
	
	DELETE	
	FROM	BITACORA_SYS
	WHERE	K_SISTEMA=@PP_K_SISTEMA_EXE
	AND		K_GRUPO_BITACORA_SYS=@PP_K_GRUPO_BITACORA_SYS

	-- =======================================
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_BITACORA_SYS_X_K_USUARIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_BITACORA_SYS_X_K_USUARIO]
GO


CREATE PROCEDURE [dbo].[PG_DL_BITACORA_SYS_X_K_USUARIO]
	@PP_L_DEBUG			INT,
	@PP_K_SISTEMA_EXE	INT,
	@PP_K_USUARIO		INT
AS
	
	DELETE	
	FROM	BITACORA_SYS
	WHERE	K_SISTEMA=@PP_K_SISTEMA_EXE
	AND		K_USUARIO=@PP_K_USUARIO	

	-- ==========================================
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_BITACORA_SYS_LINEA_DIVISORIA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_BITACORA_SYS_LINEA_DIVISORIA]
GO


CREATE PROCEDURE [dbo].[PG_IN_BITACORA_SYS_LINEA_DIVISORIA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO					[INT],
	@PP_K_CLASE_BITACORA_SYS		[INT],
	@PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
	@PP_K_GRUPO_BITACORA_SYS		[INT]
AS
	
	EXECUTE [dbo].[PG_IN_BITACORA_SYS_BASICO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO,
												@PP_K_CLASE_BITACORA_SYS, @PP_K_IMPORTANCIA_BITACORA_SYS, @PP_K_GRUPO_BITACORA_SYS,
												-- ===========================================
												-- @PP_D_BITACORA_SYS, @PP_C_BITACORA_SYS,
												'------------------------------', '------------------------------------------------------------------------------------------',
												-- ===========================================
												-- @PP_STORED_PROCEDURE, @PP_K_FOLIO_1, @PP_K_FOLIO_2,
												'', -1, -1	
	-- =====================================
GO



-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////
