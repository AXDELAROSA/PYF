-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PERFORMANCE OPERATIVO
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////
-- [dbo].[PG_LI_PERFORMANCE_N3_X_ME] 0,0,0,		3, 2010, 2015


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PERFORMANCE_N3_X_ME]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PERFORMANCE_N3_X_ME]
GO



CREATE PROCEDURE [dbo].[PG_LI_PERFORMANCE_N3_X_ME]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_BUSCAR					VARCHAR(100),
	-- ===========================	
	@PP_K_ZONA_UO				INT,
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	-- ===========================	
	@PP_K_YYYY_INICIO			INT,
	@PP_K_YYYY_FIN				INT,
	@PP_K_METRICA				INT,
	@PP_K_DIVISOR				INT
	-- ===========================
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1

	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_INT_NUMERO_REGISTROS	INT
	
	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
	-- =========================================		

	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0
	
	SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
			PERFORMANCE_N3_X_ME.*,
			------------------------------------------
			S_METRICA,				D_METRICA, 			
			S_UNIDAD_OPERATIVA,		D_UNIDAD_OPERATIVA, 			
			S_ZONA_UO,				D_ZONA_UO ,
			S_REGION,				D_REGION,
			S_RAZON_SOCIAL,			D_RAZON_SOCIAL,
			------------------------------------------
			CONVERT( INT, ( VALOR_ACUMULADO / @PP_K_DIVISOR ) ) 	AS	DIV_VALOR_ACUMULADO,
			CONVERT( INT, ( M00_VALOR / @PP_K_DIVISOR ) ) 	AS	DIV_M00_VALOR,
			CONVERT( INT, ( M01_VALOR / @PP_K_DIVISOR ) ) 	AS	DIV_M01_VALOR,
			CONVERT( INT, ( M02_VALOR / @PP_K_DIVISOR ) ) 	AS	DIV_M02_VALOR,
			CONVERT( INT, ( M03_VALOR / @PP_K_DIVISOR ) ) 	AS	DIV_M03_VALOR,
			CONVERT( INT, ( M04_VALOR / @PP_K_DIVISOR ) ) 	AS	DIV_M04_VALOR,
			CONVERT( INT, ( M05_VALOR / @PP_K_DIVISOR ) ) 	AS	DIV_M05_VALOR,
			CONVERT( INT, ( M06_VALOR / @PP_K_DIVISOR ) ) 	AS	DIV_M06_VALOR,
			CONVERT( INT, ( M07_VALOR / @PP_K_DIVISOR ) ) 	AS	DIV_M07_VALOR,
			CONVERT( INT, ( M08_VALOR / @PP_K_DIVISOR ) ) 	AS	DIV_M08_VALOR,
			CONVERT( INT, ( M09_VALOR / @PP_K_DIVISOR ) ) 	AS	DIV_M09_VALOR,
			CONVERT( INT, ( M10_VALOR / @PP_K_DIVISOR ) ) 	AS	DIV_M10_VALOR,
			CONVERT( INT, ( M11_VALOR / @PP_K_DIVISOR ) ) 	AS	DIV_M11_VALOR,
			CONVERT( INT, ( M12_VALOR / @PP_K_DIVISOR ) ) 	AS	DIV_M12_VALOR,
			------------------------------------------
			USUARIO.D_USUARIO AS D_USUARIO_CAMBIO
			------------------------------------------
	FROM	PERFORMANCE_N3_X_ME, VI_UNIDAD_OPERATIVA_CATALOGOS,
			USUARIO,
			METRICA		
	WHERE	PERFORMANCE_N3_X_ME.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		PERFORMANCE_N3_X_ME.K_METRICA=METRICA.K_METRICA
	AND		PERFORMANCE_N3_X_ME.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
			-- =====================
	AND		(	D_ZONA_UO				LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_RAZON_SOCIAL			LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_UNIDAD_OPERATIVA		LIKE '%'+@PP_BUSCAR+'%' 
			OR	VALOR_ACUMULADO			LIKE '%'+@PP_BUSCAR+'%'		)	
			-- =====================
	AND		( @PP_K_ZONA_UO=-1				OR	@PP_K_ZONA_UO=VI_K_ZONA_UO )
	AND		( @PP_K_RAZON_SOCIAL=-1			OR	@PP_K_RAZON_SOCIAL=VI_K_RAZON_SOCIAL )
	AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR	@PP_K_UNIDAD_OPERATIVA=VI_K_UNIDAD_OPERATIVA )
			-- =====================
	AND		( @PP_K_YYYY_INICIO IS NULL		OR	PERFORMANCE_N3_X_ME.K_YYYY>=@PP_K_YYYY_INICIO )
	AND		( @PP_K_YYYY_FIN IS NULL		OR	PERFORMANCE_N3_X_ME.K_YYYY<=@PP_K_YYYY_FIN )
			-- =====================
	AND		( @PP_K_METRICA=-1				OR	@PP_K_METRICA=PERFORMANCE_N3_X_ME.K_METRICA )
	ORDER BY PERFORMANCE_N3_X_ME.K_YYYY

	-- ////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_PERFORMANCE_N3_X_ME]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_PERFORMANCE_N3_X_ME]
GO


CREATE PROCEDURE [dbo].[PG_SK_PERFORMANCE_N3_X_ME]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_YYYY		INT,
	@PP_XLS_UO					INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		SELECT	PERFORMANCE_N3_X_ME.*, PERFORMANCE_N3_X_ME.K_YYYY AS 'K_YYYY'
		FROM	PERFORMANCE_N3_X_ME
		WHERE	L_BORRADO=0
		AND		PERFORMANCE_N3_X_ME.K_YYYY=@PP_K_YYYY 
		AND     PERFORMANCE_N3_X_ME.XLS_UO=@PP_XLS_UO
		
		END

	-- ////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
