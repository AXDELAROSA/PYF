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



-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
--											DOCUMENTO_PRESUPUESTO			
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_DOCUMENTO_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_DOCUMENTO_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_LI_DOCUMENTO_PRESUPUESTO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================	
	@PP_D_DOCUMENTO_D0M4	    	VARCHAR(255)
	
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

		DECLARE @VP_K_FOLIO		INT

		EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_D_DOCUMENTO_D0M4, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
		-- =========================================

	
			SELECT	
					DATA_N3_X_ME_D0M4.K_DOCUMENTO_D0M4,
					DATA_N3_X_ME_D0M4.K_DATO_D0M4,
					-- =========================
					D_ZONA_UO,
					S_ZONA_UO,
					D_UNIDAD_OPERATIVA,
					S_FORMATO_D0M4,
					DOCUMENTO_D0M4.K_YYYY	AS D_YYYY, 		
					DOCUMENTO_D0M4.K_MM		AS D_MM,
					-- =========================
					L_BOLD,	
					L_ITALICA,	
					N_INDENTAR,
					K_ALIGN,
					-- =========================
					' /// ',
					D_DATO_D0M4, S_UNIDAD_DATO_D0M4, 
					L_VISIBLE, L_EDITABLE,
					' /// ',
					[VALOR_ACUMULADO],
					[M00_VALOR], [M01_VALOR], [M02_VALOR], [M03_VALOR], 
					[M04_VALOR], [M05_VALOR], [M06_VALOR]
			--		======================================
			FROM	DOCUMENTO_D0M4, UNIDAD_OPERATIVA, ZONA_UO,
					DATA_N3_X_ME_D0M4, DATO_D0M4, UNIDAD_DATO_D0M4,
					FORMATO_D0M4, NIVEL_DETALLE, DEFINICION_D0M4
			--		======================================
			WHERE	DOCUMENTO_D0M4.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
			AND		UNIDAD_OPERATIVA.K_ZONA_UO=ZONA_UO.K_ZONA_UO
			AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=DATA_N3_X_ME_D0M4.K_DOCUMENTO_D0M4
			AND		DATA_N3_X_ME_D0M4.K_DATO_D0M4=DATO_D0M4.K_DATO_D0M4
			AND		DATO_D0M4.K_UNIDAD_DATO_D0M4=UNIDAD_DATO_D0M4.K_UNIDAD_DATO_D0M4
			--		======================================
			AND		DOCUMENTO_D0M4.K_FORMATO_D0M4=FORMATO_D0M4.K_FORMATO_D0M4
			AND		FORMATO_D0M4.K_NIVEL_DETALLE=NIVEL_DETALLE.K_NIVEL_DETALLE
			AND		FORMATO_D0M4.K_FORMATO_D0M4=DEFINICION_D0M4.K_FORMATO_D0M4
			AND		DEFINICION_D0M4.K_DATO_D0M4=DATA_N3_X_ME_D0M4.K_DATO_D0M4
			--		======================================
			AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_D_DOCUMENTO_D0M4
			--		======================================
			ORDER BY	O_ZONA_UO,
						D_UNIDAD_OPERATIVA,
						O_FORMATO_D0M4,
						DOCUMENTO_D0M4.K_YYYY, 		
						DOCUMENTO_D0M4.K_MM,
						DOCUMENTO_D0M4.K_DOCUMENTO_D0M4,
						DEFINICION_D0M4.O_DEFINICION_D0M4
				
		END
	ELSE
		BEGIN	-- RESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

			SELECT	
						DATA_N3_X_ME_D0M4.K_DOCUMENTO_D0M4,
						DATA_N3_X_ME_D0M4.K_DATO_D0M4,
						-- =========================
						D_ZONA_UO,
						S_ZONA_UO,
						D_UNIDAD_OPERATIVA,
						S_FORMATO_D0M4,
						DOCUMENTO_D0M4.K_YYYY	AS D_YYYY, 		
						DOCUMENTO_D0M4.K_MM		AS D_MM,
						-- =========================
						L_BOLD,	
						L_ITALICA,	
						N_INDENTAR,
						K_ALIGN,
						-- =========================
						' /// ',
						D_DATO_D0M4, S_UNIDAD_DATO_D0M4, 
						L_VISIBLE, L_EDITABLE,
						' /// ',
						[VALOR_ACUMULADO],
						[M00_VALOR], [M01_VALOR], [M02_VALOR], [M03_VALOR], 
						[M04_VALOR], [M05_VALOR], [M06_VALOR]
				--		======================================
				FROM	DOCUMENTO_D0M4, UNIDAD_OPERATIVA, ZONA_UO,
						DATA_N3_X_ME_D0M4, DATO_D0M4, UNIDAD_DATO_D0M4,
						FORMATO_D0M4, NIVEL_DETALLE, DEFINICION_D0M4
				--		======================================
				WHERE	DOCUMENTO_D0M4.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
				AND		UNIDAD_OPERATIVA.K_ZONA_UO=ZONA_UO.K_ZONA_UO
				AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=DATA_N3_X_ME_D0M4.K_DOCUMENTO_D0M4
				AND		DATA_N3_X_ME_D0M4.K_DATO_D0M4=DATO_D0M4.K_DATO_D0M4
				AND		DATO_D0M4.K_UNIDAD_DATO_D0M4=UNIDAD_DATO_D0M4.K_UNIDAD_DATO_D0M4
				--		======================================
				AND		DOCUMENTO_D0M4.K_FORMATO_D0M4=FORMATO_D0M4.K_FORMATO_D0M4
				AND		FORMATO_D0M4.K_NIVEL_DETALLE=NIVEL_DETALLE.K_NIVEL_DETALLE
				AND		FORMATO_D0M4.K_FORMATO_D0M4=DEFINICION_D0M4.K_FORMATO_D0M4
				AND		DEFINICION_D0M4.K_DATO_D0M4=DATA_N3_X_ME_D0M4.K_DATO_D0M4				
				--		======================================
				AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4<0

		END

	-- ////////////////////////////////////////////////


	-- ////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_DOCUMENTO_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_DOCUMENTO_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_SK_DOCUMENTO_PRESUPUESTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_DOCUMENTO_PRESUPUESTO	INT
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
	
			SELECT [PARAMETRO_POB].[K_PARAMETRO_POB]
				  ,[PARAMETRO_POB].[D_PARAMETRO_POB]
				  ,[PARAMETRO_POB].[O_PARAMETRO_POB]
				  ,[PARAMETRO_POB].[K_DOCUMENTO_D0M4]
				  ,[PARAMETRO_POB].[K_UNIDAD_OPERATIVA]
				  ,[PARAMETRO_POB].[K_YYYY]
				  ,[PARAMETRO_POB].[K_TEMPORADA]
				  ,[PARAMETRO_POB].[HISTORICO_CONSIDERABLE]
				  ,[PARAMETRO_POB].[INCREMENTO_COMPROMISO_KG]
				  ,[PARAMETRO_POB].[K_TIPO_CALCULO]
				  ,[DOCUMENTO_D0M4].[K_DOCUMENTO_D0M4]
				  ,[DOCUMENTO_D0M4].[D_DOCUMENTO_D0M4]
				  ,[DOCUMENTO_D0M4].[C_DOCUMENTO_D0M4]
				  ,[DOCUMENTO_D0M4].[S_DOCUMENTO_D0M4]
				  ,[DOCUMENTO_D0M4].[O_DOCUMENTO_D0M4]
				  ,[DOCUMENTO_D0M4].[K_FORMATO_D0M4]
				  ,[DOCUMENTO_D0M4].[K_UNIDAD_OPERATIVA]
				  ,[DOCUMENTO_D0M4].[K_ESTATUS_DOCUMENTO_D0M4]
				  ,[DOCUMENTO_D0M4].[K_PRECIO_COSTO_PERFIL]
				  ,[DOCUMENTO_D0M4].[L_RECALCULAR]    
			FROM	[PYF18_Finanzas_V9999_R0].[dbo].[PARAMETRO_POB],[DOCUMENTO_D0M4]
			WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=PARAMETRO_POB.K_DOCUMENTO_D0M4
			AND		DOCUMENTO_D0M4.L_BORRADO=0
			AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_PRESUPUESTO
		
		END
	ELSE
		BEGIN
			SELECT [PARAMETRO_POB].[K_PARAMETRO_POB]
				  ,[PARAMETRO_POB].[D_PARAMETRO_POB]
				  ,[PARAMETRO_POB].[O_PARAMETRO_POB]
				  ,[PARAMETRO_POB].[K_DOCUMENTO_D0M4]
				  ,[PARAMETRO_POB].[K_UNIDAD_OPERATIVA]
				  ,[PARAMETRO_POB].[K_YYYY]
				  ,[PARAMETRO_POB].[K_TEMPORADA]
				  ,[PARAMETRO_POB].[HISTORICO_CONSIDERABLE]
				  ,[PARAMETRO_POB].[INCREMENTO_COMPROMISO_KG]
				  ,[PARAMETRO_POB].[K_TIPO_CALCULO]
				  ,[DOCUMENTO_D0M4].[K_DOCUMENTO_D0M4]
				  ,[DOCUMENTO_D0M4].[D_DOCUMENTO_D0M4]
				  ,[DOCUMENTO_D0M4].[C_DOCUMENTO_D0M4]
				  ,[DOCUMENTO_D0M4].[S_DOCUMENTO_D0M4]
				  ,[DOCUMENTO_D0M4].[O_DOCUMENTO_D0M4]
				  ,[DOCUMENTO_D0M4].[K_FORMATO_D0M4]
				  ,[DOCUMENTO_D0M4].[K_UNIDAD_OPERATIVA]
				  ,[DOCUMENTO_D0M4].[K_ESTATUS_DOCUMENTO_D0M4]
				  ,[DOCUMENTO_D0M4].[K_PRECIO_COSTO_PERFIL]
				  ,[DOCUMENTO_D0M4].[L_RECALCULAR]    
			FROM	[PYF18_Finanzas_V9999_R0].[dbo].[PARAMETRO_POB],[DOCUMENTO_D0M4]
			WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=PARAMETRO_POB.K_DOCUMENTO_D0M4
			AND		DOCUMENTO_D0M4.L_BORRADO=0
			AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4<0
		
		END


	-- ////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_GRAFICA_DOCUMENTO_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_GRAFICA_DOCUMENTO_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_GRAFICA_DOCUMENTO_PRESUPUESTO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,

	-- ===========================
	@PP_K_DOCUMENTO_PRESUPUESTO		INT
AS

	DECLARE @VP_MENSAJE			VARCHAR(300)
	
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1

	SET		@VP_MENSAJE= ''
	
	IF @VP_MENSAJE=''
	BEGIN
			DECLARE @VP_ANIO_N1 AS VARCHAR(50)
			DECLARE @VP_ANIO_N2 AS VARCHAR(50)
			DECLARE @VP_ANIO_N3 AS VARCHAR(50)
			DECLARE @VP_ANIO_N4 AS VARCHAR(50)
			DECLARE @VP_ANIO_N5 AS VARCHAR(50)
			DECLARE @VP_ANIO_N AS VARCHAR(50)
			DECLARE @VP_K_PARAMETRO_POB AS INT
			SELECT	@VP_ANIO_N=K_YYYY, @VP_K_PARAMETRO_POB=K_PARAMETRO_POB	
			FROM	PARAMETRO_POB 
			WHERE	PARAMETRO_POB.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_PRESUPUESTO
			
			
			
			
			SET @VP_ANIO_N1= CAST(@VP_ANIO_N-1 AS VARCHAR(50))
			SET @VP_ANIO_N2= CAST(@VP_ANIO_N-2 AS VARCHAR(50))
			SET @VP_ANIO_N3= CAST(@VP_ANIO_N-3 AS VARCHAR(50))
			SET @VP_ANIO_N4= CAST(@VP_ANIO_N-4 AS VARCHAR(50))
			SET @VP_ANIO_N5= CAST(@VP_ANIO_N-5 AS VARCHAR(50))
			
			
			DECLARE @VP_QUERY AS VARCHAR(1000)
			
			SET @VP_QUERY = ' SELECT '+char(39)+'VENTAS'+char(39)+' VENTAS,'+	
						   'N5.VALOR_ACUMULADO	AS '+char(39)+@VP_ANIO_N1+char(39)+','+ 
						   'N4.VALOR_ACUMULADO	AS '+char(39)+@VP_ANIO_N2+char(39)+','+
						   'N3.VALOR_ACUMULADO	AS '+char(39)+@VP_ANIO_N3+char(39)+','+
						   'N2.VALOR_ACUMULADO	AS '+char(39)+@VP_ANIO_N4+char(39)+','+ 
						   'N1.VALOR_ACUMULADO	AS '+char(39)+@VP_ANIO_N5+char(39)+','+
						   'N.VALOR_ACUMULADO 	AS '+char(39)+@VP_ANIO_N +char(39)+' 
							FROM	DATA_N3_X_ME_D0M4 N,DATA_N3_X_ME_D0M4 N1,
									DATA_N3_X_ME_D0M4 N2,DATA_N3_X_ME_D0M4 N3,
									DATA_N3_X_ME_D0M4 N4,DATA_N3_X_ME_D0M4 N5
							WHERE	N.K_DOCUMENTO_D0M4=N1.K_DOCUMENTO_D0M4
							AND		N1.K_DOCUMENTO_D0M4=N2.K_DOCUMENTO_D0M4
							AND		N2.K_DOCUMENTO_D0M4=N3.K_DOCUMENTO_D0M4
							AND		N3.K_DOCUMENTO_D0M4=N4.K_DOCUMENTO_D0M4
							AND		N4.K_DOCUMENTO_D0M4=N5.K_DOCUMENTO_D0M4
							AND		N.K_DOCUMENTO_D0M4='+CAST(@PP_K_DOCUMENTO_PRESUPUESTO AS VARCHAR(50))+'
							AND		N.K_DATO_D0M4=4003
							AND		N1.K_DATO_D0M4=4048
							AND		N2.K_DATO_D0M4=4049
							AND		N3.K_DATO_D0M4=4050
							AND		N4.K_DATO_D0M4=4051
							AND		N5.K_DATO_D0M4=4052'

		IF	@PP_L_DEBUG>0
			PRINT @VP_QUERY
		
		EXEC sp_sqlexec  @VP_QUERY

	END

	
	-- ////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
