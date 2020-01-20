-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			STORED PROCEDURES - CATALOGO T1xx
-- // OPERACION:		LIBERACION
-- //////////////////////////////////////////////////////////////

USE [PYF18_Finanzas_V9999_R0]  
GO

-- //////////////////////////////////////////////////////////////



/****************************************************************/
/*					COMBO DIRECTO DE TABLA						*/
/****************************************************************/


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_TABLA_N1]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_TABLA_N1]
GO

CREATE PROCEDURE [dbo].[PG_CB_TABLA_N1]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_NOMBRE_TABLA			VARCHAR(255)
AS

	DECLARE @VP_INT_SHOW_K		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_COMBO_SHOW_K_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																@OU_SHOW_K = @VP_INT_SHOW_K					OUTPUT
	-- ==========================================

	DECLARE @PP_L_APLICAR_MAX_ROWS		INT
	
	SET @PP_L_APLICAR_MAX_ROWS = 0
	
	DECLARE @VP_LI_N_REGISTROS		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															@PP_L_APLICAR_MAX_ROWS,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- =========================================	

	DECLARE @VP_STR_SQL					NVARCHAR(MAX)

	IF @PP_L_APLICAR_MAX_ROWS=1 
		SET @VP_STR_SQL = 'SELECT TOP ('+ CONVERT(VARCHAR(100),@VP_LI_N_REGISTROS) +')' 
	ELSE
		SET @VP_STR_SQL = 'SELECT ' 
	
	SET @VP_STR_SQL = @VP_STR_SQL + ' '
	SET @VP_STR_SQL = @VP_STR_SQL + ' K_'+@PP_NOMBRE_TABLA + ' AS K_CATALOGO'
	
	IF @VP_INT_SHOW_K=1
		SET @VP_STR_SQL = @VP_STR_SQL + ', (D_'+@PP_NOMBRE_TABLA + '+' + '''' + ' [#' + '''' + ' + CONVERT(VARCHAR(100), K_'+@PP_NOMBRE_TABLA+')+' + '''' + ']' + '''' + ') AS D_CATALOGO'
	ELSE
		SET @VP_STR_SQL = @VP_STR_SQL + ', D_'+@PP_NOMBRE_TABLA + ' AS D_CATALOGO'
	
	SET @VP_STR_SQL = @VP_STR_SQL + ' '		
	SET @VP_STR_SQL = @VP_STR_SQL + 'FROM ' + @PP_NOMBRE_TABLA 

	SET @VP_STR_SQL = @VP_STR_SQL + ' '			
	SET @VP_STR_SQL = @VP_STR_SQL + 'ORDER BY D_'+@PP_NOMBRE_TABLA + ''
	
	-- ==========================================

	--SELECT @VP_STR_SQL AS 'SQL'
	EXECUTE sp_executesql @VP_STR_SQL 

	-- ==========================================
GO


-- ///////////////////////////////////////////////////////////////
-- //
-- ///////////////////////////////////////////////////////////////
-- [PG_CB_TABLA_N1_X_ORDEN_Select] 0, 0, 'EMPRESA'
-- [PG_CB_TABLA_N1_X_ORDEN_Select] 0, 0, 'SEMAFORO_ENTREGA'
-- [PG_CB_TABLA_N1_X_ORDEN_Select] 0, 0, 'CATALOGO_T1'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_TABLA_N1_X_ORDEN_Select]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_TABLA_N1_X_ORDEN_Select]
GO

CREATE PROCEDURE [dbo].[PG_CB_TABLA_N1_X_ORDEN_Select]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_NOMBRE_TABLA			VARCHAR(255)
AS

	DECLARE @VP_L_BORRADO	INT

	IF  0=(		SELECT	COUNT(*) 
				FROM	INFORMATION_SCHEMA.COLUMNS AS COLUMNAS
				WHERE	COLUMNAS.TABLE_NAME=@PP_NOMBRE_TABLA
				AND		COLUMNAS.COLUMN_NAME='L_BORRADO'		) 
		SET @VP_L_BORRADO = 0
	ELSE
		SET @VP_L_BORRADO = 1

	-- ==========================================

	DECLARE @VP_L_TABLA		INT = 0

	IF  0=(		SELECT	COUNT(*) 
				FROM	INFORMATION_SCHEMA.COLUMNS AS COLUMNAS
				WHERE	COLUMNAS.TABLE_NAME=@PP_NOMBRE_TABLA
				AND		COLUMNAS.COLUMN_NAME='L_'+@PP_NOMBRE_TABLA		) 
		SET @VP_L_TABLA = 0
	ELSE
		SET @VP_L_TABLA = 1

	-- //////////////////////////////////////////

	DECLARE @PP_L_APLICAR_MAX_ROWS		INT
	
	SET @PP_L_APLICAR_MAX_ROWS = 0
	
	DECLARE @VP_LI_N_REGISTROS		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															@PP_L_APLICAR_MAX_ROWS,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- =========================================	

	DECLARE @VP_STR_SQL					NVARCHAR(MAX)

	IF @PP_L_APLICAR_MAX_ROWS=1 
		SET @VP_STR_SQL = 'SELECT TOP ('+ CONVERT(VARCHAR(100),@VP_LI_N_REGISTROS) +')' 
	ELSE
		SET @VP_STR_SQL = 'SELECT ' 
	
	SET @VP_STR_SQL = @VP_STR_SQL + ' '

	SET @VP_STR_SQL = @VP_STR_SQL +  ' K_'+@PP_NOMBRE_TABLA + ' AS K_CATALOGO'	
	SET @VP_STR_SQL = @VP_STR_SQL + ', D_'+@PP_NOMBRE_TABLA + ' AS D_CATALOGO'

	SET @VP_STR_SQL = @VP_STR_SQL + ', O_'+@PP_NOMBRE_TABLA + ' AS O_CATALOGO'	
-- WIWI ORDEN
--	SET @VP_STR_SQL = @VP_STR_SQL + ', 123  AS O_CATALOGO'

	IF @VP_L_BORRADO=1
		SET @VP_STR_SQL = @VP_STR_SQL + ', L_BORRADO AS L_DELETED'
	ELSE
		SET @VP_STR_SQL = @VP_STR_SQL + ', 0 AS L_DELETED'

	IF @VP_L_TABLA=1
		SET @VP_STR_SQL = @VP_STR_SQL + ', L_'+@PP_NOMBRE_TABLA+' AS L_ACTIVO'		
	ELSE
		SET @VP_STR_SQL = @VP_STR_SQL + ', 1 AS L_ACTIVO'		

	SET @VP_STR_SQL = @VP_STR_SQL + ' '		
	SET @VP_STR_SQL = @VP_STR_SQL + 'FROM ' + @PP_NOMBRE_TABLA  	

	-- ==========================================

	EXECUTE sp_executesql @VP_STR_SQL 

	-- ==========================================
GO


-- /////////////////////////////////////////////////////////////////
-- //
-- /////////////////////////////////////////////////////////////////
-- [PG_CB_TABLA_N1_X_ORDEN_Load] 1, 0, 0, 'CUENTA_BANCO', 1
---- [PG_CB_TABLA_N1_X_ORDEN_Load] 0, 0, 'EMPRESA', 0
-- [PG_CB_TABLA_N1_X_ORDEN_Load] 0, 0, 'ESTATUS_CLIENTE', 0
-- [PG_CB_TABLA_N1_X_ORDEN_Load] 0, 0, 'CONTRATO', 1


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APG_CB_TABLA_N1_X_ORDEN_Load]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[APG_CB_TABLA_N1_X_ORDEN_Load]
GO


CREATE PROCEDURE [dbo].[APG_CB_TABLA_N1_X_ORDEN_Load]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	@PP_NOMBRE_TABLA			VARCHAR(255),
	@PP_L_CON_TODOS				INT
AS

	DECLARE @VP_INT_SHOW_K		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_COMBO_SHOW_K_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																@OU_SHOW_K = @VP_INT_SHOW_K			OUTPUT
	-- ==========================================
		
	CREATE TABLE	#VP_TA_CATALOGO	
					(	TA_K_CATALOGO		INT,
						TA_D_CATALOGO		VARCHAR(200),
						TA_O_CATALOGO		INT,
						TA_L_DELETED		INT,	
						TA_L_ACTIVO			INT			 )

	DECLARE @VP_STR_SQL		NVARCHAR(MAX)

	SET @VP_STR_SQL = 'INSERT INTO #VP_TA_CATALOGO EXEC [dbo].[PG_CB_TABLA_N1_X_ORDEN_Select] 0, 0, '+ '''' +@PP_NOMBRE_TABLA+ '''' 

	-- ==========================================
									
	EXECUTE sp_executesql @VP_STR_SQL 
	
	-- ==========================================

	IF @PP_L_CON_TODOS=1
		INSERT INTO #VP_TA_CATALOGO
				( TA_K_CATALOGO,	TA_D_CATALOGO,	TA_O_CATALOGO, TA_L_DELETED, TA_L_ACTIVO	)
			VALUES
				( -1,				'( TODOS )',	-999,		   0,			 1				)

	-- ==========================================
	
	IF @VP_INT_SHOW_K=1
		SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
			  ( (CASE WHEN (TA_L_ACTIVO=1 AND TA_L_DELETED=0) THEN '' ELSE '<X> ' END ) +
				TA_D_CATALOGO + ' [#' + CONVERT(VARCHAR(100), TA_K_CATALOGO) + ']' ) 
								AS D_COMBOBOX
		FROM	#VP_TA_CATALOGO
		ORDER BY TA_O_CATALOGO, TA_D_CATALOGO 
	ELSE
		SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
				TA_D_CATALOGO	AS D_COMBOBOX
		FROM	#VP_TA_CATALOGO
		ORDER BY TA_O_CATALOGO, TA_D_CATALOGO 

	-- ==========================================

	DROP TABLE #VP_TA_CATALOGO

	-- ==========================================
GO






/****************************************************************/
/*					COMBO DIRECTO DE TABLA						*/
/****************************************************************/

-- EXECUTE [dbo].[PG_CB_TABLA_N2] 'CLIENTE_CONTACTO', 'CLIENTE', 1


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_TABLA_N2]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_TABLA_N2]
GO

CREATE PROCEDURE [dbo].[PG_CB_TABLA_N2]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_NOMBRE_TABLA		VARCHAR(255),
	@PP_TABLA_PADRE			VARCHAR(255),
	@PP_K_PADRE				INT
AS

	DECLARE @VP_STR_SQL					NVARCHAR(MAX)
	DECLARE @VP_INT_SHOW_K				INT

	DECLARE @VP_LI_N_REGISTROS			INT
	DECLARE @PP_L_APLICAR_MAX_ROWS		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_COMBO_SHOW_K_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																@OU_SHOW_K = @VP_INT_SHOW_K					OUTPUT
	
	-- ==========================================

	SET @PP_L_APLICAR_MAX_ROWS = 1

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															@PP_L_APLICAR_MAX_ROWS,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- ==========================================

	IF @PP_L_APLICAR_MAX_ROWS=1 
		SET @VP_STR_SQL = 'SELECT TOP ('+ CONVERT(VARCHAR(100),@VP_LI_N_REGISTROS) +')' 
	ELSE
		SET @VP_STR_SQL = 'SELECT ' 
	
	SET @VP_STR_SQL = @VP_STR_SQL + ' '
	SET @VP_STR_SQL = @VP_STR_SQL + ' K_'+@PP_NOMBRE_TABLA + ' AS K_CATALOGO'
	
	IF @VP_INT_SHOW_K=1
		SET @VP_STR_SQL = @VP_STR_SQL + ', (D_'+@PP_NOMBRE_TABLA + '+' + '''' + ' [#' + '''' + ' + CONVERT(VARCHAR(100), K_'+@PP_NOMBRE_TABLA+')+' + '''' + ']' + '''' + ') AS D_CATALOGO'
	ELSE
		SET @VP_STR_SQL = @VP_STR_SQL + ', D_'+@PP_NOMBRE_TABLA + ' AS D_CATALOGO'
	
	SET @VP_STR_SQL = @VP_STR_SQL + ' '		
	SET @VP_STR_SQL = @VP_STR_SQL + 'FROM ' + @PP_NOMBRE_TABLA 

	SET @VP_STR_SQL = @VP_STR_SQL + ' '		
	SET @VP_STR_SQL = @VP_STR_SQL + 'WHERE K_' + @PP_TABLA_PADRE + '=' + CONVERT(VARCHAR(100),@PP_K_PADRE)

	SET @VP_STR_SQL = @VP_STR_SQL + ' '			
	SET @VP_STR_SQL = @VP_STR_SQL + 'ORDER BY D_'+@PP_NOMBRE_TABLA + ''

	-- ==========================================	
	--SELECT @VP_STR_SQL AS 'SQL'
	EXECUTE sp_executesql @VP_STR_SQL 

	-- ==========================================
GO







-- ///////////////////////////////////////////////////////////////
-- //
-- ///////////////////////////////////////////////////////////////
-- [PG_CB_TABLA_N1_X_ORDEN_Select] 0, 0, 'EMPRESA'
-- [PG_CB_TABLA_N1_X_ORDEN_Select] 0, 0, 'SEMAFORO_ENTREGA'
-- [PG_CB_TABLA_N1_X_ORDEN_Select] 0, 0, 'CATALOGO_T1'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_TABLA_N1_Select]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_TABLA_N1_Select]
GO

CREATE PROCEDURE [dbo].[PG_CB_TABLA_N1_Select]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_NOMBRE_TABLA			VARCHAR(255)
AS

	DECLARE @VP_L_BORRADO	INT

	IF  0=(		SELECT	COUNT(*) 
				FROM	INFORMATION_SCHEMA.COLUMNS AS COLUMNAS
				WHERE	COLUMNAS.TABLE_NAME=@PP_NOMBRE_TABLA
				AND		COLUMNAS.COLUMN_NAME='L_BORRADO'		) 
		SET @VP_L_BORRADO = 0
	ELSE
		SET @VP_L_BORRADO = 1

	-- ==========================================

	DECLARE @VP_L_TABLA		INT = 0

	IF  0=(		SELECT	COUNT(*) 
				FROM	INFORMATION_SCHEMA.COLUMNS AS COLUMNAS
				WHERE	COLUMNAS.TABLE_NAME=@PP_NOMBRE_TABLA
				AND		COLUMNAS.COLUMN_NAME='L_'+@PP_NOMBRE_TABLA		) 
		SET @VP_L_TABLA = 0
	ELSE
		SET @VP_L_TABLA = 1

	-- //////////////////////////////////////////

	DECLARE @PP_L_APLICAR_MAX_ROWS		INT
	
	SET @PP_L_APLICAR_MAX_ROWS = 0
	
	DECLARE @VP_LI_N_REGISTROS		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															@PP_L_APLICAR_MAX_ROWS,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- =========================================	

	DECLARE @VP_STR_SQL					NVARCHAR(MAX)

	IF @PP_L_APLICAR_MAX_ROWS=1 
		SET @VP_STR_SQL = 'SELECT TOP ('+ CONVERT(VARCHAR(100),@VP_LI_N_REGISTROS) +')' 
	ELSE
		SET @VP_STR_SQL = 'SELECT ' 
	
	SET @VP_STR_SQL = @VP_STR_SQL + ' '

	SET @VP_STR_SQL = @VP_STR_SQL +  ' K_'+@PP_NOMBRE_TABLA + ' AS K_CATALOGO'	
	SET @VP_STR_SQL = @VP_STR_SQL + ', D_'+@PP_NOMBRE_TABLA + ' AS D_CATALOGO'

	SET @VP_STR_SQL = @VP_STR_SQL + ', 0 AS O_CATALOGO'	
-- WIWI ORDEN
--	SET @VP_STR_SQL = @VP_STR_SQL + ', 123  AS O_CATALOGO'

	IF @VP_L_BORRADO=1
		SET @VP_STR_SQL = @VP_STR_SQL + ', L_BORRADO AS L_DELETED'
	ELSE
		SET @VP_STR_SQL = @VP_STR_SQL + ', 0 AS L_DELETED'

	IF @VP_L_TABLA=1
		SET @VP_STR_SQL = @VP_STR_SQL + ', L_'+@PP_NOMBRE_TABLA+' AS L_ACTIVO'		
	ELSE
		SET @VP_STR_SQL = @VP_STR_SQL + ', 1 AS L_ACTIVO'		

	SET @VP_STR_SQL = @VP_STR_SQL + ' '		
	SET @VP_STR_SQL = @VP_STR_SQL + 'FROM ' + @PP_NOMBRE_TABLA  	

	-- ==========================================

	EXECUTE sp_executesql @VP_STR_SQL 

	-- ==========================================
GO



-- /////////////////////////////////////////////////////////////////
-- //
-- /////////////////////////////////////////////////////////////////
-- [PG_CB_TABLA_N1_Load] 1, 0, 0, 'CUENTA_BANCO', 1

-- [PG_CB_TABLA_N1_Load] 1, 0, 0, 'AUTORIZACION', 1, 1
-- [PG_CB_TABLA_N1_Load] 1, 0, 0, 'AUTORIZACION', 1, 0

-- [PG_CB_TABLA_N1_Load] 1, 0, 0, 'ZONA_UO', 1, 1
-- [PG_CB_TABLA_N1_Load] 1, 0, 0, 'ZONA_UO', 1, 0

-- [PG_CB_TABLA_N1_Load] 1, 0, 0, 'AUTORIZACION', 1, 0


---- [PG_CB_TABLA_N1_X_ORDEN_Load] 0, 0, 'EMPRESA', 0
-- [PG_CB_TABLA_N1_X_ORDEN_Load] 0, 0, 'ESTATUS_CLIENTE', 0
-- [PG_CB_TABLA_N1_X_ORDEN_Load] 0, 0, 'CONTRATO', 1


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CB_TABLA_N1_Load]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CB_TABLA_N1_Load]
GO


CREATE PROCEDURE [dbo].[PG_CB_TABLA_N1_Load]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	@PP_NOMBRE_TABLA			VARCHAR(255),
	@PP_L_CON_TODOS				INT,
	@PP_L_USAR_ORDEN			INT
AS

	DECLARE @VP_INT_SHOW_K		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_COMBO_SHOW_K_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																@OU_SHOW_K = @VP_INT_SHOW_K			OUTPUT
	-- ==========================================
		
	CREATE TABLE	#VP_TA_CATALOGO	
					(	TA_K_CATALOGO		INT,
						TA_D_CATALOGO		VARCHAR(200),
						TA_O_CATALOGO		INT,
						TA_L_DELETED		INT,	
						TA_L_ACTIVO			INT			 )

	DECLARE @VP_STR_SQL		NVARCHAR(MAX)

	IF @PP_L_USAR_ORDEN=1
		SET @VP_STR_SQL = 'INSERT INTO #VP_TA_CATALOGO EXEC [dbo].[PG_CB_TABLA_N1_X_ORDEN_Select] 0, 0, '+ '''' +@PP_NOMBRE_TABLA+ '''' 
	ELSE
		SET @VP_STR_SQL = 'INSERT INTO #VP_TA_CATALOGO EXEC [dbo].[PG_CB_TABLA_N1_Select] 0, 0, '+ '''' +@PP_NOMBRE_TABLA+ '''' 
	
	-- ==========================================
									
	EXECUTE sp_executesql @VP_STR_SQL 
	
	-- ==========================================

	IF @PP_L_CON_TODOS=1
		INSERT INTO #VP_TA_CATALOGO
				( TA_K_CATALOGO,	TA_D_CATALOGO,	TA_O_CATALOGO, TA_L_DELETED, TA_L_ACTIVO	)
			VALUES
				( -1,				'( TODOS )',	-999,		   0,			 1				)

	-- ==========================================
	
	IF @VP_INT_SHOW_K=1
		SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
			  ( (CASE WHEN (TA_L_ACTIVO=1 AND TA_L_DELETED=0) THEN '' ELSE '<X> ' END ) +
				TA_D_CATALOGO + ' [#' + CONVERT(VARCHAR(100), TA_K_CATALOGO) + ']' ) 
								AS D_COMBOBOX
		FROM	#VP_TA_CATALOGO
		ORDER BY TA_O_CATALOGO, TA_D_CATALOGO 
	ELSE
		SELECT	TA_K_CATALOGO	AS K_COMBOBOX,
				TA_D_CATALOGO	AS D_COMBOBOX
		FROM	#VP_TA_CATALOGO
		ORDER BY TA_O_CATALOGO, TA_D_CATALOGO 

	-- ==========================================

	DROP TABLE #VP_TA_CATALOGO

	-- ==========================================
GO




-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
