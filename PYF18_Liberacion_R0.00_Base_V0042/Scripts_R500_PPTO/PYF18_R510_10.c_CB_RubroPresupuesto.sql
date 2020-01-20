-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			RUBROS PRESUPUESTO / COMBOS
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

-- EXECUTE [PG_CB_RUBRO_PRESUPUESTO_Load] 0,0,0,  1

-- EXECUTE [PG_CB_RUBRO_PRESUPUESTO_Load] 0,0,0,  0


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_RUBRO_PRESUPUESTO_Load]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_RUBRO_PRESUPUESTO_Load]
GO



CREATE PROCEDURE [dbo].[PG_CB_RUBRO_PRESUPUESTO_Load]
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
						D_RUBRO_PRESUPUESTO			VARCHAR(200),
						S_RUBRO_PRESUPUESTO			VARCHAR(200),
						K_NIVEL_RUBRO_PRESUPUESTO	INT		)
	
	-- ==========================================
	
	INSERT INTO #VP_TA_CATALOGO 
		(		TA_K_CATALOGO, TA_O_CATALOGO,
				D_RUBRO_PRESUPUESTO, S_RUBRO_PRESUPUESTO, K_NIVEL_RUBRO_PRESUPUESTO		)
				-- =========================
		SELECT	K_RUBRO_PRESUPUESTO, O_RUBRO_PRESUPUESTO, 
				D_RUBRO_PRESUPUESTO, S_RUBRO_PRESUPUESTO, K_NIVEL_RUBRO_PRESUPUESTO
				-- =========================
		FROM	RUBRO_PRESUPUESTO
		WHERE	K_NIVEL_RUBRO_PRESUPUESTO IN ( 0, 5 )
		AND		K_RUBRO_PRESUPUESTO<>0

	-- ==========================================

	IF @PP_L_CON_TODOS=1 
		INSERT INTO #VP_TA_CATALOGO
				(	TA_K_CATALOGO,	TA_O_CATALOGO,	
					-- =========================
					D_RUBRO_PRESUPUESTO, S_RUBRO_PRESUPUESTO	)
			VALUES
				(	-1,				-999,		 					
					'(TODOS)', '(TODOS)'	)

	-- ==========================================

	UPDATE	#VP_TA_CATALOGO 
	SET		TA_K_CATALOGO		= 0, 
			D_RUBRO_PRESUPUESTO = ( '- - - - - - - - - - - '+D_RUBRO_PRESUPUESTO ) 
	WHERE	K_NIVEL_RUBRO_PRESUPUESTO=0
	
	-- ==========================================

	SET @VP_INT_SHOW_K = 1

	SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
			[D_RUBRO_PRESUPUESTO] 
			+ ( CASE WHEN @VP_INT_SHOW_K=1 
					THEN (' [#'+CONVERT(VARCHAR(100),TA_K_CATALOGO)+'] ') 
					ELSE '' END )
							AS D_COMBOBOX
	FROM	#VP_TA_CATALOGO
	ORDER BY	TA_O_CATALOGO,
				[S_RUBRO_PRESUPUESTO], 
				[D_RUBRO_PRESUPUESTO] 

	-- ==========================================

	DROP TABLE #VP_TA_CATALOGO

	-- ==========================================
GO




-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
