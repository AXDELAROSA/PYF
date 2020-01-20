-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			RESUMEN FLUJO DIARIO / UNIDAD OPERATIVA
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- //////////////////////////////////////////////////////////////
-- // Autor:			HGF
-- // Fecha creación:	18/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


/*

DELETE FROM RESUMEN_FLUJO_DIARIO_X_UNO

SELECT * FROM RESUMEN_FLUJO_DIARIO_X_UNO

EXECUTE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO_GENERADOR] 0,0,0, '01/JUL/2018','01/SEP/2018'


EXECUTE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO_GENERADOR] 0,0,0, '01/JUL/2018','01/ENE/2019'

*/




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO_DECIMALES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO_DECIMALES]
GO


CREATE PROCEDURE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO_DECIMALES]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO	INT
AS			

	UPDATE	RESUMEN_FLUJO_DIARIO_X_UNO
	SET		[INGRESO_BANCO]			= CONVERT( DECIMAL(19,2), [INGRESO_BANCO] ),
			[INGRESO_LIBRO]			= CONVERT( DECIMAL(19,2), [INGRESO_LIBRO]  ),
			[INGRESO_CONCILIADO]	= CONVERT( DECIMAL(19,2), [INGRESO_CONCILIADO] ),
			[GAS]					= CONVERT( DECIMAL(19,2), [GAS] ),
			[FLETE]					= CONVERT( DECIMAL(19,2), [FLETE] ),
			[OBLIGACIONES]			= CONVERT( DECIMAL(19,2), [OBLIGACIONES]  ),
			[NOMINA]				= CONVERT( DECIMAL(19,2), [NOMINA]  ),
			[CXP]					= CONVERT( DECIMAL(19,2), [CXP] ),
			[TRASPASOS]				= CONVERT( DECIMAL(19,2), [TRASPASOS]),
			[GASTO_CORPORATIVO]		= CONVERT( DECIMAL(19,2), [GASTO_CORPORATIVO]  )
	WHERE	K_RESUMEN_FLUJO_DIARIO_X_UNO=@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO

	-- //////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO_ALEATORIZAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO_ALEATORIZAR]
GO


CREATE PROCEDURE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO_ALEATORIZAR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO	INT
AS			
	-- ===================================================
	
	DECLARE @VP_K_UNIDAD_OPERATIVA		INT

	SELECT	@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA
										FROM	RESUMEN_FLUJO_DIARIO_X_UNO
										WHERE	K_RESUMEN_FLUJO_DIARIO_X_UNO=@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO

	DECLARE @VP_FACTOR					DECIMAL(19,4)

	SELECT	@VP_FACTOR =				FACTOR
										FROM	QA_DATA_UNIDAD_OPERATIVA
										WHERE	K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA
	
	-- ===================================================
	
	DECLARE @VP_BASE_DIARIA DECIMAL(19,4) = 200		-- MILES DE PESOS X DIA
	
	SET		@VP_BASE_DIARIA = ( @VP_BASE_DIARIA * 1000 )

	SET		@VP_BASE_DIARIA = ( @VP_BASE_DIARIA * @VP_FACTOR )

	-- ===================================================

	DECLARE @VP_F1 DECIMAL(19,4) = 0.20
	DECLARE @VP_F2 DECIMAL(19,4) = 0.10
	DECLARE @VP_F3 DECIMAL(19,4) = 0.15
	DECLARE @VP_F4 DECIMAL(19,4) = 0.10
	DECLARE @VP_F5 DECIMAL(19,4) = 0.15
	DECLARE @VP_F6 DECIMAL(19,4) = 0.40
	DECLARE @VP_F7 DECIMAL(19,4) = 0.25
	DECLARE @VP_F8 DECIMAL(19,4) = 0.35

	-- ===================================================

	UPDATE	RESUMEN_FLUJO_DIARIO_X_UNO
	SET		[INGRESO_BANCO]     =        @VP_BASE_DIARIA * ( 1 + ( ( RAND(convert(varbinary, newid())) * @VP_F1 ) - ( @VP_F1/2.1 )	) ),
			[INGRESO_LIBRO]			= 11.22,
			[INGRESO_CONCILIADO]	= 22.33,
			[GAS]				= 0.5895 * @VP_BASE_DIARIA * ( 1 + ( ( RAND(convert(varbinary, newid())) * @VP_F2 ) - ( @VP_F2/2.1 )	) ),
			[FLETE]				= 0.0463 * @VP_BASE_DIARIA * ( 1 + ( ( RAND(convert(varbinary, newid())) * @VP_F3 ) - ( @VP_F3/2.1 )	) ),
			[OBLIGACIONES]		= 0.0421 * @VP_BASE_DIARIA * ( 1 + ( ( RAND(convert(varbinary, newid())) * @VP_F4 ) - ( @VP_F4/2.1 )	) ),
			[NOMINA]			= 0.0263 * @VP_BASE_DIARIA * ( 1 + ( ( RAND(convert(varbinary, newid())) * @VP_F5 ) - ( @VP_F5/2.1 )	) ),
			[CXP]				= 0.0530 * @VP_BASE_DIARIA * ( 1 + ( ( RAND(convert(varbinary, newid())) * @VP_F6 ) - ( @VP_F6/2.1 )	) ),
			[TRASPASOS]			= 0.0347 * @VP_BASE_DIARIA * ( 1 + ( ( RAND(convert(varbinary, newid())) * @VP_F7 ) - ( @VP_F7/2.1 )	) ),
			[GASTO_CORPORATIVO] = 0.1580 * @VP_BASE_DIARIA * ( 1 + ( ( RAND(convert(varbinary, newid())) * @VP_F8 ) - ( @VP_F8/2.1 )	) )
	WHERE	K_RESUMEN_FLUJO_DIARIO_X_UNO=@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO

	-- ======================================================

	EXECUTE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO_DECIMALES]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO

	-- //////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO]
GO


CREATE PROCEDURE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_F_INICIO				DATE,
	@PP_F_FIN					DATE,
	@PP_K_UNIDAD_OPERATIVA		INT
AS			

	DECLARE @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO		INT	

	-- ==================================

	DECLARE @VP_F_PIVOTE		DATE

	SET		@VP_F_PIVOTE = @PP_F_INICIO

	WHILE	@VP_F_PIVOTE<=@PP_F_FIN
		BEGIN

		-- ==================================
		
		DELETE 
		FROM	RESUMEN_FLUJO_DIARIO_X_UNO
		WHERE	K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
		AND		F_OPERACION=@VP_F_PIVOTE

		-- ========================================

		EXECUTE [dbo].[PG_IN_RESUMEN_FLUJO_DIARIO_X_UNO_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_F_PIVOTE, @PP_K_UNIDAD_OPERATIVA	,
																@OU_K_RESUMEN_FLUJO_DIARIO_X_UNO = @VP_K_RESUMEN_FLUJO_DIARIO_X_UNO			OUTPUT
		-- ========================================

		EXECUTE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO_ALEATORIZAR]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@VP_K_RESUMEN_FLUJO_DIARIO_X_UNO	
		-- ========================================

		SET @VP_F_PIVOTE = DATEADD( day, 1, @VP_F_PIVOTE )

		END

	-- //////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO_GENERADOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO_GENERADOR]
GO



CREATE PROCEDURE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO_GENERADOR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_F_INICIO				DATE,
	@PP_F_FIN					DATE
AS			

	DECLARE CU_UNIDAD_OPERATIVA
		CURSOR FOR 
			SELECT	[K_UNIDAD_OPERATIVA]
			FROM	[QA_DATA_UNIDAD_OPERATIVA] ;
	
	-- ========================================
	
	DECLARE @VP_CU_K_UNIDAD_OPERATIVA		INT

	OPEN CU_UNIDAD_OPERATIVA  
		FETCH NEXT FROM CU_UNIDAD_OPERATIVA INTO @VP_CU_K_UNIDAD_OPERATIVA  

	-- ========================================

	WHILE @@FETCH_STATUS = 0  
		BEGIN  
		
		EXECUTE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_F_INICIO, @PP_F_FIN, @VP_CU_K_UNIDAD_OPERATIVA	
		-- ========================================

		FETCH NEXT FROM CU_UNIDAD_OPERATIVA INTO @VP_CU_K_UNIDAD_OPERATIVA 
		END 

	-- ========================================

	CLOSE CU_UNIDAD_OPERATIVA  

	DEALLOCATE CU_UNIDAD_OPERATIVA 

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////




-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_RESUMEN_FLUJO_DIARIO_X_UNO_GENERADOR] 0,0,0, '01/JUL/2018','01/FEB/2019'

-- ===============================================
SET NOCOUNT OFF
-- ===============================================






-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
