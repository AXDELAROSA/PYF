-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION // STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////

--//////////////////////////////////////////////////////////////


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
--											DOCUMENTO_D0M4_TRACKING_X_MES		
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////P

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_DOCUMENTO_D0M4_TRACKING_PRE_REGISTRO_X_K_DOCUMENTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_DOCUMENTO_D0M4_TRACKING_PRE_REGISTRO_X_K_DOCUMENTO]
GO


CREATE PROCEDURE [dbo].[PG_IN_DOCUMENTO_D0M4_TRACKING_PRE_REGISTRO_X_K_DOCUMENTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	DECLARE @VP_K_YYYY					INT
	DECLARE @VP_K_FORMATO_D0M4			INT
	DECLARE @VP_K_UNIDAD_OPERATIVA		INT
				
	SELECT	@VP_K_YYYY =				K_YYYY,
			@VP_K_FORMATO_D0M4 =		K_FORMATO_D0M4,
			@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA
										FROM	DOCUMENTO_D0M4
										WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	-- ===============================

	DECLARE @VP_TRACKING_EXISTE			INT

	SELECT	@VP_TRACKING_EXISTE =		DOCUMENTO_D0M4_TRACKING_X_MES.K_FORMATO_D0M4
										FROM	DOCUMENTO_D0M4, DOCUMENTO_D0M4_TRACKING_X_MES
										WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
										AND		DOCUMENTO_D0M4.K_YYYY=DOCUMENTO_D0M4_TRACKING_X_MES.K_YYYY
										AND		DOCUMENTO_D0M4.K_FORMATO_D0M4=DOCUMENTO_D0M4_TRACKING_X_MES.K_FORMATO_D0M4
										AND		DOCUMENTO_D0M4.K_UNIDAD_OPERATIVA=DOCUMENTO_D0M4_TRACKING_X_MES.K_UNIDAD_OPERATIVA
	-- ===============================

	IF @VP_TRACKING_EXISTE IS NULL
		INSERT INTO DOCUMENTO_D0M4_TRACKING_X_MES
				(	[K_YYYY], [K_FORMATO_D0M4], [K_UNIDAD_OPERATIVA],
					[K_USUARIO_ALTA],[F_ALTA],
					[K_USUARIO_CAMBIO],[F_CAMBIO]	)	
		VALUES
				(	@VP_K_YYYY, @VP_K_FORMATO_D0M4, @VP_K_UNIDAD_OPERATIVA,
					@PP_K_USUARIO_ACCION, GETDATE(), 
					@PP_K_USUARIO_ACCION, GETDATE()		)
	GO							

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE
-- //////////////////////////////////////////////////////////////P

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_DOCUMENTO_D0M4_TRACKING_X_MES_ESTATUS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_DOCUMENTO_D0M4_TRACKING_X_MES_ESTATUS]
GO

CREATE PROCEDURE [dbo].[PG_UP_DOCUMENTO_D0M4_TRACKING_X_MES_ESTATUS]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_YYYY						INT,
	@PP_K_FORMATO_D0M4				INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_MM						INT,
	@PP_D_ESTATUS_DOCUMENTO_D0M4	VARCHAR(100)		
AS

	-- ==========================================

	DECLARE @VP_NN_MES		VARCHAR(MAX)

	SET @VP_NN_MES = RIGHT(('000'+CONVERT(VARCHAR(10),@PP_K_MM)),2)

	-- ==========================================
	
	DECLARE @VP_STR_SQL		NVARCHAR(MAX)

	SET @VP_STR_SQL =               ' UPDATE DOCUMENTO_D0M4_TRACKING_X_MES' 	
	SET @VP_STR_SQL = @VP_STR_SQL + ' SET M'+@VP_NN_MES+'_ESTATUS='+''''+@PP_D_ESTATUS_DOCUMENTO_D0M4+''''
	SET @VP_STR_SQL = @VP_STR_SQL + ' WHERE K_YYYY='+CONVERT(VARCHAR(20),@PP_K_YYYY)
	SET @VP_STR_SQL = @VP_STR_SQL +   ' AND K_FORMATO_D0M4='+CONVERT(VARCHAR(20),@PP_K_FORMATO_D0M4)
	SET @VP_STR_SQL = @VP_STR_SQL +   ' AND K_UNIDAD_OPERATIVA='+CONVERT(VARCHAR(20),@PP_K_UNIDAD_OPERATIVA)
	SET @VP_STR_SQL = @VP_STR_SQL +   ' AND K_USUARIO_CAMBIO='+CONVERT(VARCHAR(20),@PP_K_USUARIO_ACCION)
	SET @VP_STR_SQL = @VP_STR_SQL +   ' AND F_CAMBIO='+ CONVERT(VARCHAR(20),CAST(GETDATE() AS DATE)) 
	PRINT @VP_STR_SQL
	-- ==========================================

	IF @PP_L_DEBUG>1
		PRINT	@VP_STR_SQL

	-- ==========================================

	EXECUTE sp_executesql @VP_STR_SQL 

	-- ==========================================

GO							
-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> LISTADO
-- //////////////////////////////////////////////////////////////P


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_DOCUMENTO_D0M4_TRACKING_X_MES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_DOCUMENTO_D0M4_TRACKING_X_MES]
GO


CREATE PROCEDURE [dbo].[PG_LI_DOCUMENTO_D0M4_TRACKING_X_MES]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_BUSCAR					VARCHAR(100),
	@PP_K_TIEMPO_YYYY			INT,
	@PP_K_FORMATO_D0M4			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_ZONA_UO				INT
AS
	-- ==============================================
	
	SELECT	
			D_ZONA_UO,
			S_ZONA_UO,
			D_UNIDAD_OPERATIVA,
			S_FORMATO_D0M4,
			DOCUMENTO_D0M4_TRACKING_X_MES.K_YYYY	AS D_YYYY, 		
			DOCUMENTO_D0M4_TRACKING_X_MES.*,
			' /// ',
	--		================================			
			
	--		================================
			USUARIO.D_USUARIO AS 'D_USUARIO_CAMBIO'
	--		================================
	FROM	DOCUMENTO_D0M4_TRACKING_X_MES,
			TIEMPO_YYYY, FORMATO_D0M4,
			UNIDAD_OPERATIVA, ZONA_UO,
			USUARIO
	--		================================		
	WHERE	DOCUMENTO_D0M4_TRACKING_X_MES.K_YYYY=TIEMPO_YYYY.K_TIEMPO_YYYY
	AND		DOCUMENTO_D0M4_TRACKING_X_MES.K_FORMATO_D0M4=FORMATO_D0M4.K_FORMATO_D0M4
	AND		DOCUMENTO_D0M4_TRACKING_X_MES.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND		UNIDAD_OPERATIVA.K_ZONA_UO=ZONA_UO.K_ZONA_UO
	AND		DOCUMENTO_D0M4_TRACKING_X_MES.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	--		================================		
	AND		(	@PP_BUSCAR= ''
			OR	D_FORMATO_D0M4				LIKE '%'+@PP_BUSCAR+'%'	
			OR	D_ZONA_UO					LIKE '%'+@PP_BUSCAR+'%'
			OR	D_UNIDAD_OPERATIVA			LIKE '%'+@PP_BUSCAR+'%'		)
	--		================================
	AND		( @PP_K_TIEMPO_YYYY=-1		OR	DOCUMENTO_D0M4_TRACKING_X_MES.K_YYYY=@PP_K_TIEMPO_YYYY		)
	AND		( @PP_K_FORMATO_D0M4=-1		OR	DOCUMENTO_D0M4_TRACKING_X_MES.K_FORMATO_D0M4=@PP_K_FORMATO_D0M4		)
	AND		( @PP_K_UNIDAD_OPERATIVA=-1	OR	DOCUMENTO_D0M4_TRACKING_X_MES.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA		)
	AND		( @PP_K_ZONA_UO=-1			OR	UNIDAD_OPERATIVA.K_ZONA_UO=@PP_K_ZONA_UO	)
	--		================================
	ORDER BY	O_ZONA_UO,
				D_UNIDAD_OPERATIVA,
				O_FORMATO_D0M4,
				DOCUMENTO_D0M4_TRACKING_X_MES.K_YYYY

	-- //////////////////////////////////////////////////////////////


	-- //////////////////////////////////////////////////////////////
	-- //////////////////////////////////////////////////////////////