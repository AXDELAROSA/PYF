-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas_V9999_R0
-- // MODULO:			PERFORMANCE_TEMPORADA
-- // OPERACION:		LIBERACION // STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////



-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
--											PERFORMANCE_TEMPORADA			
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PERFORMANCE_N3_X_TEMP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PERFORMANCE_N3_X_TEMP]
GO


CREATE PROCEDURE [dbo].[PG_LI_PERFORMANCE_N3_X_TEMP]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================	
	@PP_BUSCAR						VARCHAR(255),
	@PP_K_YYYY				    	VARCHAR(255),	
	@PP_K_ZONA						INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_TEMPORADA					INT
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

	IF @VP_MENSAJE=''
		BEGIN
	
		DECLARE @VP_INT_NUMERO_REGISTROS	INT
	
		EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																			@VP_L_APLICAR_MAX_ROWS,		
																			@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
		-- =========================================		

			
		SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
				PERFORMANCE_N3_X_TEMP.*,
				UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA,TEMPORADA.D_TEMPORADA, 
				'KG' AS D_METRICA
		FROM	PERFORMANCE_N3_X_TEMP,	UNIDAD_OPERATIVA,	
				TEMPORADA
		WHERE	PERFORMANCE_N3_X_TEMP.K_TEMPORADA=TEMPORADA.K_TEMPORADA
		AND		PERFORMANCE_N3_X_TEMP.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA		
		AND		(	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA	LIKE '%'+@PP_BUSCAR+'%' 
					OR	TEMPORADA.K_TEMPORADA	LIKE '%'+@PP_BUSCAR+'%'
					OR	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA	LIKE '%'+@PP_BUSCAR+'%'
					OR	@PP_BUSCAR=''	)	
		AND		(   @PP_K_UNIDAD_OPERATIVA	=   -1 	
					OR  PERFORMANCE_N3_X_TEMP.K_UNIDAD_OPERATIVA	=   @PP_K_UNIDAD_OPERATIVA)
		AND		(   @PP_K_YYYY	=   -1 	OR  PERFORMANCE_N3_X_TEMP.K_YYYY	=   @PP_K_YYYY)
		AND		(	@PP_K_ZONA=-1 OR UNIDAD_OPERATIVA.K_ZONA_UO=@PP_K_ZONA)
		AND		(	@PP_K_TEMPORADA	=	-1	OR	TEMPORADA.K_TEMPORADA		=	@PP_K_TEMPORADA)
		ORDER BY PERFORMANCE_N3_X_TEMP.K_YYYY, PERFORMANCE_N3_X_TEMP.K_TEMPORADA

				
		END
	ELSE
		BEGIN	-- RESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

		SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
				PERFORMANCE_N3_X_TEMP.*,
				UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA,TEMPORADA.D_TEMPORADA, 
				'KG' AS D_METRICA
		FROM	PERFORMANCE_N3_X_TEMP,	UNIDAD_OPERATIVA,	
				TEMPORADA
		WHERE	PERFORMANCE_N3_X_TEMP.K_TEMPORADA=TEMPORADA.K_TEMPORADA
		AND		PERFORMANCE_N3_X_TEMP.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
		AND		PERFORMANCE_N3_X_TEMP.K_TEMPORADA<0

		END

	-- ////////////////////////////////////////////////


	-- ////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_PERFORMANCE_N3_X_TEMP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_PERFORMANCE_N3_X_TEMP]
GO


CREATE PROCEDURE [dbo].[PG_SK_PERFORMANCE_N3_X_TEMP]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_YYYY				    	VARCHAR(255),	
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_TEMPORADA					INT
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
	
		SELECT	PERFORMANCE_N3_X_TEMP.*
		FROM	PERFORMANCE_N3_X_TEMP
		WHERE	PERFORMANCE_N3_X_TEMP.K_TEMPORADA=@PP_K_TEMPORADA
		AND		PERFORMANCE_N3_X_TEMP.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA		
		AND		PERFORMANCE_N3_X_TEMP.K_YYYY	=   @PP_K_YYYY
		AND		PERFORMANCE_N3_X_TEMP.K_METRICA = 1
		
		END

	-- ////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////P

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PERFORMANCE_N3_X_TEMP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PERFORMANCE_N3_X_TEMP]
GO


CREATE PROCEDURE [dbo].[PG_IN_PERFORMANCE_N3_X_TEMP]
	@PP_L_DEBUG					    INT,
	@PP_K_SISTEMA_EXE			    INT,
	@PP_K_USUARIO_ACCION		    INT,
	-- ===========================		   
	@PP_K_YYYY					    INT,
	@PP_XLS_UO						INT,
	@PP_XLS_UNIDAD_OPERATIVA		VARCHAR(100),
	@PP_K_UNIDAD_OPERATIVA		    INT,
	@PP_K_TEMPORADA					INT,
	@PP_K_METRICA					INT,
	@PP_VALOR_ACUMULADO				DECIMAL(19, 4),
	@PP_V00_VALOR					DECIMAL(19, 4),
	@PP_V01_VALOR					DECIMAL(19, 4),
	@PP_V02_VALOR					DECIMAL(19, 4),
	@PP_P01_VALOR					DECIMAL(5, 2),
	@PP_P02_VALOR					DECIMAL(5, 2)

	-- ===========================			
	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_EXISTE INT

	SELECT @VP_EXISTE=		COUNT(*) FROM PERFORMANCE_N3_X_TEMP 
							WHERE	K_YYYY=@PP_K_YYYY
							AND		K_UNIDAD_OPERATIVA=	@PP_K_UNIDAD_OPERATIVA
							AND		K_TEMPORADA=@PP_K_TEMPORADA

	IF	@VP_EXISTE>0
	BEGIN
		BEGIN TRY  
			UPDATE PERFORMANCE_N3_X_TEMP
			SET
			VALOR_ACUMULADO=@PP_VALOR_ACUMULADO,
			V00_VALOR=@PP_V00_VALOR,
			V01_VALOR=@PP_V01_VALOR,
			V02_VALOR=@PP_V02_VALOR,
			P01_VALOR=@PP_P01_VALOR,
			P02_VALOR=@PP_P02_VALOR
			WHERE	K_YYYY=@PP_K_YYYY
			AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
			AND		K_TEMPORADA=@PP_K_TEMPORADA
			AND		K_METRICA=@PP_K_METRICA

		END TRY  
		BEGIN CATCH  
			SELECT @VP_MENSAJE=ERROR_MESSAGE()  
		END CATCH;  
	END
	IF	@VP_EXISTE=0
	BEGIN
		BEGIN TRY  
			INSERT INTO PERFORMANCE_N3_X_TEMP  
			(
				K_YYYY,
				XLS_UO,
				XLS_UNIDAD_OPERATIVA,
				K_UNIDAD_OPERATIVA,
				K_TEMPORADA,
				K_METRICA,
				VALOR_ACUMULADO,
				V00_VALOR, V01_VALOR, V02_VALOR,
				P01_VALOR, P02_VALOR
			)
			VALUES 
			(
				@PP_K_YYYY,				
				@PP_XLS_UO,				
				@PP_XLS_UNIDAD_OPERATIVA,
				@PP_K_UNIDAD_OPERATIVA,	
				@PP_K_TEMPORADA,			
				@PP_K_METRICA,			
				@PP_VALOR_ACUMULADO,		
				@PP_V00_VALOR, @PP_V01_VALOR, @PP_V02_VALOR, 
				@PP_P01_VALOR, @PP_P02_VALOR
			)

		END TRY  
		BEGIN CATCH  
			SELECT @VP_MENSAJE=ERROR_MESSAGE()  
		END CATCH;  
	END

	-- /////////////////////////////////////////////////////////////////////
			
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [PERFORMANCE_N3_X_TEMP]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@PP_K_YYYY)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'


		END
	
	-- SELECT	@VP_MENSAJE AS MENSAJE, 1 AS CLAVE
		
	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
