-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			ORGANIZACION / COMBOS
-- // OPERACION:		LIBERACION / STORED PROCEDURES
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	17/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////






-- ////////////////////////////////////////////////////////////////
-- // 
-- ////////////////////////////////////////////////////////////////

-- EXECUTE [PG_CB_ZONA_UO_Load] 0,0,306,  1

-- EXECUTE [PG_CB_ZONA_UO_Load] 0,0,305,  1


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_ZONA_UO_Load]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_ZONA_UO_Load]
GO


CREATE PROCEDURE [dbo].[PG_CB_ZONA_UO_Load]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ======================================
	@PP_L_CON_TODOS				INT
AS

	DECLARE @VP_INT_SHOW_K		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_COMBO_SHOW_K_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																@OU_SHOW_K = @VP_INT_SHOW_K			OUTPUT
	-- ==========================================
		
	CREATE TABLE	#VP_TA_CATALOGO	
					(	TA_K_CATALOGO		INT,
						TA_O_CATALOGO		INT,
						-- =========================
						D_ZONA_UO			VARCHAR(200),
						S_ZONA_UO			VARCHAR(200)		)
	
	-- ==========================================
	
	INSERT INTO #VP_TA_CATALOGO 
		(		TA_K_CATALOGO, TA_O_CATALOGO,
				-- =========================
				D_ZONA_UO, S_ZONA_UO		)
		SELECT	K_ZONA_UO, O_ZONA_UO,
				-- =========================
				D_ZONA_UO, S_ZONA_UO
		FROM	ZONA_UO
		WHERE	(	
					ZONA_UO.K_ZONA_UO IN (		SELECT DISTINCT	ZONA_UO.K_ZONA_UO
												FROM	PERSONAL_ACCESO_ORGANIZACION, USUARIO,
														ZONA_UO
												WHERE	PERSONAL_ACCESO_ORGANIZACION.K_PERSONAL=USUARIO.K_PERSONAL_PREDEFINIDO
												AND		USUARIO.K_USUARIO=@PP_K_USUARIO_ACCION	
												AND		( PERSONAL_ACCESO_ORGANIZACION.K_ZONA_UO=-1 OR PERSONAL_ACCESO_ORGANIZACION.K_ZONA_UO=ZONA_UO.K_ZONA_UO)	)
				)

	-- ==========================================

	IF @PP_L_CON_TODOS=1 
		INSERT INTO #VP_TA_CATALOGO
				(	TA_K_CATALOGO,	TA_O_CATALOGO,	
					-- =========================
					D_ZONA_UO, S_ZONA_UO	)
			VALUES
				(	-1,				-999,		 					
					'(TODOS)', '(TODOS)'	)

	-- ==========================================
	
	SET @VP_INT_SHOW_K = 1

	SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
			[D_ZONA_UO] 
			+ ( CASE WHEN @VP_INT_SHOW_K=1 
					THEN (' [#'+CONVERT(VARCHAR(100),TA_K_CATALOGO)+'] ') 
					ELSE '' END )
							AS D_COMBOBOX
	FROM	#VP_TA_CATALOGO
	ORDER BY	TA_O_CATALOGO,
				[S_ZONA_UO], 
				[D_ZONA_UO] 

	-- ==========================================

	DROP TABLE #VP_TA_CATALOGO

	-- ==========================================
GO





-- ////////////////////////////////////////////////////////////////
-- // 
-- ////////////////////////////////////////////////////////////////

-- EXECUTE [PG_CB_RAZON_SOCIAL_Load] 0,0,300,  1, -1, -1, -1


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_RAZON_SOCIAL_Load]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_RAZON_SOCIAL_Load]
GO


CREATE PROCEDURE [dbo].[PG_CB_RAZON_SOCIAL_Load]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ======================================
	@PP_L_CON_TODOS				INT,
	@PP_K_ESTATUS_RAZON_SOCIAL	INT,
	@PP_K_TIPO_RAZON_SOCIAL		INT,
	@PP_K_REGION				INT
AS

	DECLARE @VP_INT_SHOW_K		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_COMBO_SHOW_K_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																@OU_SHOW_K = @VP_INT_SHOW_K			OUTPUT
	-- ==========================================
		
	CREATE TABLE	#VP_TA_CATALOGO	
					(	TA_K_CATALOGO		INT,
						TA_O_CATALOGO		INT,
						-- =========================
						D_RAZON_SOCIAL				VARCHAR(200),
						D_ESTATUS_RAZON_SOCIAL		VARCHAR(200),
						D_TIPO_RAZON_SOCIAL			VARCHAR(200),
						D_REGION					VARCHAR(200),
						S_RAZON_SOCIAL				VARCHAR(200),
						S_ESTATUS_RAZON_SOCIAL		VARCHAR(200),
						S_TIPO_RAZON_SOCIAL			VARCHAR(200),
						S_REGION					VARCHAR(200)			)
	
	-- ==========================================
	
	INSERT INTO #VP_TA_CATALOGO 
		(		TA_K_CATALOGO, TA_O_CATALOGO,
				-- =========================
				D_RAZON_SOCIAL, D_ESTATUS_RAZON_SOCIAL, D_TIPO_RAZON_SOCIAL, D_REGION,
				S_RAZON_SOCIAL, S_ESTATUS_RAZON_SOCIAL, S_TIPO_RAZON_SOCIAL, S_REGION		)
		SELECT	K_RAZON_SOCIAL, O_RAZON_SOCIAL,
				-- =========================
				D_RAZON_SOCIAL, D_ESTATUS_RAZON_SOCIAL, D_TIPO_RAZON_SOCIAL, D_REGION,
				S_RAZON_SOCIAL, S_ESTATUS_RAZON_SOCIAL, S_TIPO_RAZON_SOCIAL, S_REGION
		FROM	RAZON_SOCIAL,
				ESTATUS_RAZON_SOCIAL, TIPO_RAZON_SOCIAL, REGION
		WHERE	RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL=ESTATUS_RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL
		AND		RAZON_SOCIAL.K_TIPO_RAZON_SOCIAL=TIPO_RAZON_SOCIAL.K_TIPO_RAZON_SOCIAL
		AND		RAZON_SOCIAL.K_REGION=REGION.K_REGION
		AND		( @PP_K_ESTATUS_RAZON_SOCIAL=-1		OR		RAZON_SOCIAL.K_ESTATUS_RAZON_SOCIAL=@PP_K_ESTATUS_RAZON_SOCIAL )
		AND		( @PP_K_TIPO_RAZON_SOCIAL=-1		OR		RAZON_SOCIAL.K_TIPO_RAZON_SOCIAL=@PP_K_TIPO_RAZON_SOCIAL )
		AND		( @PP_K_REGION=-1					OR		RAZON_SOCIAL.K_REGION=@PP_K_REGION )
		-- =================================
		AND		(	
				
				RAZON_SOCIAL.K_RAZON_SOCIAL IN (		SELECT DISTINCT	RAZON_SOCIAL.K_RAZON_SOCIAL
														FROM	PERSONAL_ACCESO_ORGANIZACION, USUARIO,
																RAZON_SOCIAL
														WHERE	PERSONAL_ACCESO_ORGANIZACION.K_PERSONAL=USUARIO.K_PERSONAL_PREDEFINIDO
														AND		PERSONAL_ACCESO_ORGANIZACION.L_BORRADO=0
														AND		USUARIO.K_USUARIO=@PP_K_USUARIO_ACCION	
														AND		( PERSONAL_ACCESO_ORGANIZACION.K_RAZON_SOCIAL=-1 OR PERSONAL_ACCESO_ORGANIZACION.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL)	)
				OR -- =================================
				RAZON_SOCIAL.K_RAZON_SOCIAL IN (		SELECT DISTINCT	UNIDAD_OPERATIVA.K_RAZON_SOCIAL
														FROM	PERSONAL_ACCESO_ORGANIZACION, USUARIO,
																UNIDAD_OPERATIVA
														WHERE	PERSONAL_ACCESO_ORGANIZACION.K_PERSONAL=USUARIO.K_PERSONAL_PREDEFINIDO
														AND		USUARIO.K_USUARIO=@PP_K_USUARIO_ACCION
														AND		PERSONAL_ACCESO_ORGANIZACION.L_BORRADO=0
														AND		PERSONAL_ACCESO_ORGANIZACION.K_ZONA_UO=UNIDAD_OPERATIVA.K_ZONA_UO	)
				)

	-- ==========================================

	UPDATE		#VP_TA_CATALOGO
	SET			TA_O_CATALOGO = -100
	WHERE		D_TIPO_RAZON_SOCIAL LIKE '%GAS%'

	-- ==========================================

	IF @PP_L_CON_TODOS=1 
		INSERT INTO #VP_TA_CATALOGO
				(	TA_K_CATALOGO,	TA_O_CATALOGO,	
					-- =========================
					D_RAZON_SOCIAL, D_ESTATUS_RAZON_SOCIAL, D_TIPO_RAZON_SOCIAL, D_REGION,
					S_RAZON_SOCIAL, S_ESTATUS_RAZON_SOCIAL, S_TIPO_RAZON_SOCIAL, S_REGION		)
			VALUES
				(	-1,				-999,		 					
					'(TODOS)', '', '', '',		
					'(TODOS)', '', '', ''		)

	-- ==========================================
	
	SET @VP_INT_SHOW_K = 1

	SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
			[D_RAZON_SOCIAL] 
			+ ( CASE WHEN @VP_INT_SHOW_K=1 
					THEN (' [#'+CONVERT(VARCHAR(100),TA_K_CATALOGO)+'] ') 
					ELSE '' END )
			+ ' ( '+[S_ESTATUS_RAZON_SOCIAL]+' - '+[D_TIPO_RAZON_SOCIAL]+' )'
							AS D_COMBOBOX
	FROM	#VP_TA_CATALOGO
	ORDER BY	TA_O_CATALOGO,
				[S_TIPO_RAZON_SOCIAL], 
				[D_RAZON_SOCIAL] 

	-- ==========================================

	DROP TABLE #VP_TA_CATALOGO

	-- ==========================================
GO




-- ////////////////////////////////////////////////////////////////
-- // 
-- ////////////////////////////////////////////////////////////////

-- EXECUTE [PG_CB_UNIDAD_OPERATIVA_Load] 0,0,300,  1,0,  -1, -1

-- EXECUTE [PG_CB_UNIDAD_OPERATIVA_Load] 0,0,300,  1,1,  -1, -1

-- EXECUTE [PG_CB_UNIDAD_OPERATIVA_Load] 0,0,301,  0,1,  30, -1


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_UNIDAD_OPERATIVA_Load]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_UNIDAD_OPERATIVA_Load]
GO


CREATE PROCEDURE [dbo].[PG_CB_UNIDAD_OPERATIVA_Load]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ======================================
	@PP_L_CON_TODOS				INT,
	@PP_L_CON_RAZON_SOCIAL		INT,
	@PP_K_ZONA_UO				INT,
	@PP_K_RAZON_SOCIAL			INT
AS

	DECLARE @VP_INT_SHOW_K		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_COMBO_SHOW_K_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																@OU_SHOW_K = @VP_INT_SHOW_K			OUTPUT
	-- ==========================================
		
	CREATE TABLE	#VP_TA_CATALOGO	
					(	TA_K_CATALOGO		INT,
						TA_O_CATALOGO		INT,
						-- =========================
						[D_UNIDAD_OPERATIVA]	VARCHAR(200),
						[D_TIPO_UO]				VARCHAR(200),
						[D_ZONA_UO]				VARCHAR(200),
						[D_RAZON_SOCIAL]		VARCHAR(200),
						[D_REGION]				VARCHAR(200),
						[S_UNIDAD_OPERATIVA]	VARCHAR(200),
						[S_TIPO_UO]				VARCHAR(200),
						[S_ZONA_UO]				VARCHAR(200),
						[S_RAZON_SOCIAL]		VARCHAR(200),
						[S_REGION]				VARCHAR(200)			)
	
	-- ==========================================
	
	INSERT INTO #VP_TA_CATALOGO 
		(		TA_K_CATALOGO, TA_O_CATALOGO,
				-- =========================
				[D_UNIDAD_OPERATIVA], [D_TIPO_UO], [D_ZONA_UO], [D_RAZON_SOCIAL], [D_REGION],
				[S_UNIDAD_OPERATIVA], [S_TIPO_UO], [S_ZONA_UO], [S_RAZON_SOCIAL], [S_REGION]		)
		SELECT	K_UNIDAD_OPERATIVA, O_UNIDAD_OPERATIVA,
				-- =========================
				UNIDAD_OPERATIVA.[D_UNIDAD_OPERATIVA], [D_TIPO_UO], [D_ZONA_UO], [D_RAZON_SOCIAL], [D_REGION],
				UNIDAD_OPERATIVA.[S_UNIDAD_OPERATIVA], [S_TIPO_UO], [S_ZONA_UO], [S_RAZON_SOCIAL], [S_REGION]
		FROM	UNIDAD_OPERATIVA, [VI_UNIDAD_OPERATIVA_CATALOGOS]
		WHERE	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=[VI_UNIDAD_OPERATIVA_CATALOGOS].VI_K_UNIDAD_OPERATIVA
		AND		( @PP_K_ZONA_UO=-1			OR		UNIDAD_OPERATIVA.K_ZONA_UO=@PP_K_ZONA_UO )
		AND		( @PP_K_RAZON_SOCIAL=-1		OR		UNIDAD_OPERATIVA.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL )
		AND		( @PP_L_CON_RAZON_SOCIAL=1	OR		UNIDAD_OPERATIVA.K_TIPO_UO<>50)
		-- =================================
		AND		(	
				UNIDAD_OPERATIVA.K_RAZON_SOCIAL IN (		SELECT DISTINCT	K_RAZON_SOCIAL
															FROM	PERSONAL_ACCESO_ORGANIZACION, USUARIO
															WHERE	PERSONAL_ACCESO_ORGANIZACION.K_PERSONAL=USUARIO.K_PERSONAL_PREDEFINIDO
															AND		PERSONAL_ACCESO_ORGANIZACION.L_BORRADO=0
															AND		USUARIO.K_USUARIO=@PP_K_USUARIO_ACCION		)
				OR -- =================================
				UNIDAD_OPERATIVA.K_ZONA_UO IN (				SELECT	DISTINCT	K_ZONA_UO
															FROM	PERSONAL_ACCESO_ORGANIZACION, USUARIO
															WHERE	PERSONAL_ACCESO_ORGANIZACION.K_PERSONAL=USUARIO.K_PERSONAL_PREDEFINIDO
															AND		PERSONAL_ACCESO_ORGANIZACION.L_BORRADO=0
															AND		USUARIO.K_USUARIO=@PP_K_USUARIO_ACCION		)
				OR -- =================================
				UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA IN (	SELECT	DISTINCT	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
															FROM	PERSONAL_ACCESO_ORGANIZACION, USUARIO,
																	UNIDAD_OPERATIVA
															WHERE	PERSONAL_ACCESO_ORGANIZACION.K_PERSONAL=USUARIO.K_PERSONAL_PREDEFINIDO
															AND		PERSONAL_ACCESO_ORGANIZACION.L_BORRADO=0
															AND		USUARIO.K_USUARIO=@PP_K_USUARIO_ACCION	
															AND		( PERSONAL_ACCESO_ORGANIZACION.K_UNIDAD_OPERATIVA=-1 OR PERSONAL_ACCESO_ORGANIZACION.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA)	)
														
																
				)

	-- ==========================================

	UPDATE	#VP_TA_CATALOGO
	SET		TA_O_CATALOGO = 0


	UPDATE	#VP_TA_CATALOGO
	SET		TA_O_CATALOGO = 99999
	WHERE	TA_K_CATALOGO>999

	-- ==========================================

	IF @PP_L_CON_TODOS=1
		INSERT INTO #VP_TA_CATALOGO
				(	TA_K_CATALOGO,	TA_O_CATALOGO,	
					-- =========================
					[D_UNIDAD_OPERATIVA], [D_TIPO_UO], [D_ZONA_UO], [D_RAZON_SOCIAL], [D_REGION],
					[S_UNIDAD_OPERATIVA], [S_TIPO_UO], [S_ZONA_UO], [S_RAZON_SOCIAL], [S_REGION]		)
			VALUES
				(	-1,				-999,		 					
					'(TODOS)', '', '', '', '',		
					'(TODOS)', '', '', '', ''		  )

	-- ==========================================
	
	SET @VP_INT_SHOW_K = 1

	SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
			[D_UNIDAD_OPERATIVA] 
			+ ( CASE WHEN @VP_INT_SHOW_K=1 
					THEN (' [#'+CONVERT(VARCHAR(100),TA_K_CATALOGO)+'] ') 
					ELSE '' END )
			+ ' ( '+[S_ZONA_UO]+' - '+[D_RAZON_SOCIAL]+' )'
							AS D_COMBOBOX
	FROM	#VP_TA_CATALOGO
	ORDER BY	[S_ZONA_UO], 
				TA_O_CATALOGO,
				[D_RAZON_SOCIAL], [D_UNIDAD_OPERATIVA] 

	-- ==========================================

	DROP TABLE #VP_TA_CATALOGO

	-- ==========================================
GO



-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
