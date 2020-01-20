-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			CUENTA_BANCO / COMBOS
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

-- EXECUTE [PG_CB_CUENTA_BANCO_Load] 0,0,  0,  1,	-1,-1,	-1,-1,-1,-1,-1

-- EXECUTE [PG_CB_CUENTA_BANCO_Load] 0,0,300,  1,	10,-1,	-1,-1,-1,-1,-1

-- EXECUTE [PG_CB_CUENTA_BANCO_Load] 0,0,302,  1,	49,56,	-1,-1,-1,-1,-1
-- EXECUTE [PG_CB_CUENTA_BANCO_Load] 0,0,302,  1,	49,57,	-1,-1,-1,-1,-1


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_CUENTA_BANCO_Load]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_CUENTA_BANCO_Load]
GO


CREATE PROCEDURE [dbo].[PG_CB_CUENTA_BANCO_Load]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ======================================
	@PP_L_CON_TODOS				INT,
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_BANCO					INT,
	@PP_K_MONEDA				INT,
	@PP_K_ESTATUS_CUENTA_BANCO	INT,
	@PP_K_TIPO_CUENTA_BANCO		INT,
	@PP_K_ESTADO				INT
AS

	DECLARE @VP_INT_SHOW_K		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_COMBO_SHOW_K_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																@OU_SHOW_K = @VP_INT_SHOW_K			OUTPUT
	-- ==========================================
		
	CREATE TABLE	#VP_TA_CATALOGO	
					(	TA_K_CATALOGO		INT,
						TA_O_CATALOGO		INT,
						CUENTA				VARCHAR(200),
						-- =========================
						[D_CUENTA_BANCO]			VARCHAR(200),
						[D_RAZON_SOCIAL]			VARCHAR(200),
						[D_TIPO_RAZON_SOCIAL]		VARCHAR(200),
						[D_BANCO]					VARCHAR(200),
						[D_MONEDA]					VARCHAR(200),
						[D_ESTATUS_CUENTA_BANCO]	VARCHAR(200),
						[D_TIPO_CUENTA_BANCO]		VARCHAR(200),
						[D_ESTADO]					VARCHAR(200),
						-- =========================
						[S_CUENTA_BANCO]			VARCHAR(200),
						[S_RAZON_SOCIAL]			VARCHAR(200),
						[S_TIPO_RAZON_SOCIAL]		VARCHAR(200),
						[S_BANCO]					VARCHAR(200),
						[S_MONEDA]					VARCHAR(200),
						[S_ESTATUS_CUENTA_BANCO]	VARCHAR(200),
						[S_TIPO_CUENTA_BANCO]		VARCHAR(200),
						[S_ESTADO]					VARCHAR(200)		)
	
	-- ==========================================
	
	INSERT INTO #VP_TA_CATALOGO 
		(		TA_K_CATALOGO, TA_O_CATALOGO,
				CUENTA,
				-- =========================
				[D_CUENTA_BANCO], [D_RAZON_SOCIAL], [D_TIPO_RAZON_SOCIAL], [D_BANCO], [D_MONEDA], [D_ESTATUS_CUENTA_BANCO], [D_TIPO_CUENTA_BANCO], [D_ESTADO],
				[S_CUENTA_BANCO], [S_RAZON_SOCIAL], [S_TIPO_RAZON_SOCIAL], [S_BANCO], [S_MONEDA], [S_ESTATUS_CUENTA_BANCO], [S_TIPO_CUENTA_BANCO], [S_ESTADO]			)
		SELECT	K_CUENTA_BANCO, 0,
				CUENTA,
				[D_CUENTA_BANCO], [D_RAZON_SOCIAL], [D_TIPO_RAZON_SOCIAL], [D_BANCO], [D_MONEDA], [D_ESTATUS_CUENTA_BANCO], [D_TIPO_CUENTA_BANCO], [D_ESTADO],
				[S_CUENTA_BANCO], [S_RAZON_SOCIAL], [S_TIPO_RAZON_SOCIAL], [S_BANCO], [S_MONEDA], [S_ESTATUS_CUENTA_BANCO], [S_TIPO_CUENTA_BANCO], [S_ESTADO]	
				-- =========================
		FROM	CUENTA_BANCO, 
				[RAZON_SOCIAL], [TIPO_RAZON_SOCIAL], [BANCO], [MONEDA], [ESTATUS_CUENTA_BANCO], [TIPO_CUENTA_BANCO], [ESTADO]
				-- =========================
		WHERE	CUENTA_BANCO.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL 
		AND		RAZON_SOCIAL.K_TIPO_RAZON_SOCIAL=TIPO_RAZON_SOCIAL.K_TIPO_RAZON_SOCIAL
		AND		CUENTA_BANCO.K_BANCO=BANCO.K_BANCO
		AND		CUENTA_BANCO.K_MONEDA=MONEDA.K_MONEDA 
		AND		CUENTA_BANCO.K_ESTATUS_CUENTA_BANCO=ESTATUS_CUENTA_BANCO.K_ESTATUS_CUENTA_BANCO 
		AND		CUENTA_BANCO.K_TIPO_CUENTA_BANCO=TIPO_CUENTA_BANCO.K_TIPO_CUENTA_BANCO
		AND		CUENTA_BANCO.K_ESTADO=ESTADO.K_ESTADO
				-- =========================
		AND		( @PP_K_RAZON_SOCIAL=-1				OR		CUENTA_BANCO.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL )
		AND		( @PP_K_BANCO=-1					OR		CUENTA_BANCO.K_BANCO=@PP_K_BANCO )
		AND		( @PP_K_MONEDA=-1					OR		CUENTA_BANCO.K_MONEDA=@PP_K_MONEDA )
		AND		( @PP_K_ESTATUS_CUENTA_BANCO=-1		OR		CUENTA_BANCO.K_ESTATUS_CUENTA_BANCO=@PP_K_ESTATUS_CUENTA_BANCO )
		AND		( @PP_K_TIPO_CUENTA_BANCO=-1		OR		CUENTA_BANCO.K_TIPO_CUENTA_BANCO=@PP_K_TIPO_CUENTA_BANCO )
		AND		( @PP_K_ESTADO=-1					OR		CUENTA_BANCO.K_ESTADO=@PP_K_ESTADO )
		-- =================================

		AND		(	
/*				CUENTA_BANCO.K_RAZON_SOCIAL IN (	SELECT DISTINCT	RAZON_SOCIAL.K_RAZON_SOCIAL
													FROM	PERSONAL_ACCESO_ORGANIZACION, USUARIO,
															RAZON_SOCIAL
													WHERE	PERSONAL_ACCESO_ORGANIZACION.K_PERSONAL=USUARIO.K_PERSONAL_PREDEFINIDO
													AND		PERSONAL_ACCESO_ORGANIZACION.L_BORRADO=0
													AND		USUARIO.K_USUARIO=@PP_K_USUARIO_ACCION
													AND		( PERSONAL_ACCESO_ORGANIZACION.K_RAZON_SOCIAL=-1 OR PERSONAL_ACCESO_ORGANIZACION.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL)	
												)
				OR -- =================================
	*/
				CUENTA_BANCO.K_CUENTA_BANCO IN (	SELECT DISTINCT	K_CUENTA_BANCO
													FROM	PERSONAL_ACCESO_ORGANIZACION, USUARIO,
															UNIDAD_OPERATIVA, CUENTA_BANCO_UO
													WHERE	PERSONAL_ACCESO_ORGANIZACION.K_PERSONAL=USUARIO.K_PERSONAL_PREDEFINIDO
													AND		PERSONAL_ACCESO_ORGANIZACION.L_BORRADO=0
													AND		USUARIO.K_USUARIO=@PP_K_USUARIO_ACCION
													AND		PERSONAL_ACCESO_ORGANIZACION.K_ZONA_UO=UNIDAD_OPERATIVA.K_ZONA_UO
													AND		UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=CUENTA_BANCO_UO.K_UNIDAD_OPERATIVA
												)

				)

	-- ==========================================

	IF @PP_L_CON_TODOS=1
		INSERT INTO #VP_TA_CATALOGO
				(	TA_K_CATALOGO,	TA_O_CATALOGO,	
					CUENTA,
					-- =========================
					[D_CUENTA_BANCO], [D_RAZON_SOCIAL], [D_TIPO_RAZON_SOCIAL], [D_BANCO], [D_MONEDA], [D_ESTATUS_CUENTA_BANCO], [D_TIPO_CUENTA_BANCO], [D_ESTADO],
					[S_CUENTA_BANCO], [S_RAZON_SOCIAL], [S_TIPO_RAZON_SOCIAL], [S_BANCO], [S_MONEDA], [S_ESTATUS_CUENTA_BANCO], [S_TIPO_CUENTA_BANCO], [S_ESTADO]	
				)
			VALUES
				(	-1,				-999,
					'CTA',		 					
					'(TODOS)', '', '', '', '', '', '', '',		
					'(TODOS)', '', '', '', '', '', '', ''		  )

	-- ==========================================

	UPDATE		#VP_TA_CATALOGO
	SET			TA_O_CATALOGO = -100
	WHERE		D_TIPO_RAZON_SOCIAL LIKE '%GAS%'

	-- ==========================================
		
	SET @VP_INT_SHOW_K = 1

	SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
			[S_TIPO_CUENTA_BANCO] +'.'+ [S_BANCO] +'.'+ [CUENTA] 
			+ ( CASE WHEN @VP_INT_SHOW_K=1 
					THEN (' [#'+CONVERT(VARCHAR(100),TA_K_CATALOGO)+'] ') 
					ELSE '' END )
			+ ' ( '+[S_BANCO]+' - '+[S_MONEDA]+' ) ' + [S_TIPO_RAZON_SOCIAL]+ ' - '+ [D_RAZON_SOCIAL] +' - '+ [S_ESTATUS_CUENTA_BANCO]
							AS D_COMBOBOX
	FROM	#VP_TA_CATALOGO
	ORDER BY	TA_O_CATALOGO,
	-- [S_ZONA_UO], 
				[D_RAZON_SOCIAL], [S_ESTATUS_CUENTA_BANCO], [S_TIPO_CUENTA_BANCO] 
				
	-- ==========================================

	DROP TABLE #VP_TA_CATALOGO

	-- ==========================================
GO




-- EXECUTE [PG_CB_CUENTA_BANCO_Load] 0,0,0,  1, -1,-1,-1,-1,-1,-1





-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////

