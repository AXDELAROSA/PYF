-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			GRAFICA LIQUIDACION
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- // Autor:			Oscar Romero Mendiola
-- // Fecha creaci�n:	29/05/18
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_GRAFICA_PERFORMANCE_N3_X_TEMP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_GRAFICA_PERFORMANCE_N3_X_TEMP]
GO


CREATE PROCEDURE [dbo].[PG_GRAFICA_PERFORMANCE_N3_X_TEMP]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,

	-- ===========================
	@PP_K_YYYY					INT,	
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_TEMPORADA				INT
AS

	DECLARE @VP_MENSAJE			VARCHAR(300)
	
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1

	SET		@VP_MENSAJE= ''
	
	IF @VP_MENSAJE=''
IF @VP_MENSAJE=''
		BEGIN
			IF @PP_K_TEMPORADA=1								
				SELECT	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA 'SUCURSAL', P01_VALOR VERANO,P02_VALOR INVIERNO				 
				FROM	PERFORMANCE_N3_X_TEMP,TEMPORADA,UNIDAD_OPERATIVA
				WHERE	PERFORMANCE_N3_X_TEMP.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
				AND		PERFORMANCE_N3_X_TEMP.K_TEMPORADA=TEMPORADA.K_TEMPORADA
				AND		PERFORMANCE_N3_X_TEMP.K_YYYY=@PP_K_YYYY 
				AND		PERFORMANCE_N3_X_TEMP.K_TEMPORADA=@PP_K_TEMPORADA
				AND     PERFORMANCE_N3_X_TEMP.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
			IF @PP_K_TEMPORADA=2
				SELECT	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA 'SUCURSAL',P01_VALOR INVIERNO,P02_VALOR VERANO				 
				FROM	PERFORMANCE_N3_X_TEMP,TEMPORADA,UNIDAD_OPERATIVA
				WHERE	PERFORMANCE_N3_X_TEMP.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
				AND		PERFORMANCE_N3_X_TEMP.K_TEMPORADA=TEMPORADA.K_TEMPORADA
				AND		PERFORMANCE_N3_X_TEMP.K_YYYY=@PP_K_YYYY 
				AND		PERFORMANCE_N3_X_TEMP.K_TEMPORADA=@PP_K_TEMPORADA
				AND     PERFORMANCE_N3_X_TEMP.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA

		END

	-- ////////////////////////////////////////////////
GO
		--SELECT TOP(10)	CONVERT(DATE, F_LIQUIDACION, 112) AS Fecha, SUM(totalLiq) AS TotalLiq, 
		--				SUM(totalEfe) AS totalEfe,  SUM(totalLiq)+200 AS Dato3,SUM(totalLiq)-100 AS Dato4

		--FROM			DAT_LIQUIDACION

		--WHERE			(F_LIQUIDACION BETWEEN @PP_FECHA1 AND @PP_FECHA2)
		--	AND			(@PP_FECHA1 IS NULL OR  F_LIQUIDACION >= @PP_FECHA1)  AND  (@PP_FECHA2 IS NULL OR F_LIQUIDACION <= @PP_FECHA2)
	
		--GROUP BY		CONVERT(DATE, F_LIQUIDACION, 112)
		--ORDER BY		CONVERT(DATE, F_LIQUIDACION, 112)
		 


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////