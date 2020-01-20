-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


-- SELECT * FROM	sys.sysobjects WHERE	name LIKE 'PG%'



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_4043a_TIEMPO_YYYY]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_4043a_TIEMPO_YYYY]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_4043a_TIEMPO_YYYY]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N3_4043a_TIEMPO_YYYY]'

		-- ////////////////////////////////////////////////

	DECLARE @VP_TEMPORADA INT
	DECLARE @VP_YYYY INT

	SELECT		@VP_TEMPORADA= PARAMETRO_POB.K_TEMPORADA,
				@VP_YYYY=PARAMETRO_POB.K_YYYY			
				FROM	DOCUMENTO_D0M4,PARAMETRO_POB 
				WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=PARAMETRO_POB.K_DOCUMENTO_D0M4
				AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	IF	@VP_TEMPORADA=1
	BEGIN
		UPDATE	DATA_N3_X_ME_D0M4 
				SET	[M01_VALOR]=@VP_YYYY,
					[M02_VALOR]=@VP_YYYY,
					[M03_VALOR]=@VP_YYYY,
					[M04_VALOR]=@VP_YYYY,
					[M05_VALOR]=@VP_YYYY,
					[M06_VALOR]=@VP_YYYY
				WHERE K_DATO_D0M4=4043
				AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	END
	IF	@VP_TEMPORADA=2
	BEGIN
		UPDATE	DATA_N3_X_ME_D0M4 
				SET	[M01_VALOR]=@VP_YYYY,
					[M02_VALOR]=@VP_YYYY,
					[M03_VALOR]=@VP_YYYY,
					[M04_VALOR]=@VP_YYYY+1,
					[M05_VALOR]=@VP_YYYY+1,
					[M06_VALOR]=@VP_YYYY+1
				WHERE K_DATO_D0M4=4043
				AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	END
	
	-- //////////////////////////////////////////////////////////////
GO

-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_4044a_TIEMPO_MM]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_4044a_TIEMPO_MM]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_4044a_TIEMPO_MM]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N3_4044a_TIEMPO_MM]'

		-- ////////////////////////////////////////////////

	DECLARE @VP_TEMPORADA INT
	DECLARE @VP_YYYY INT

	SELECT		@VP_TEMPORADA= PARAMETRO_POB.K_TEMPORADA,
				@VP_YYYY=PARAMETRO_POB.K_YYYY			
				FROM	DOCUMENTO_D0M4,PARAMETRO_POB 
				WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=PARAMETRO_POB.K_DOCUMENTO_D0M4
				AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	IF	@VP_TEMPORADA=1
	BEGIN
		UPDATE	DATA_N3_X_ME_D0M4 
				SET	[M01_VALOR]=4,
					[M02_VALOR]=5,
					[M03_VALOR]=6,
					[M04_VALOR]=7,
					[M05_VALOR]=8,
					[M06_VALOR]=9
				WHERE K_DATO_D0M4=4044
				AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	END
	IF	@VP_TEMPORADA=2
	BEGIN
		UPDATE	DATA_N3_X_ME_D0M4 
				SET	[M01_VALOR]=10,
					[M02_VALOR]=11,
					[M03_VALOR]=12,
					[M04_VALOR]=1,
					[M05_VALOR]=2,
					[M06_VALOR]=3
				WHERE K_DATO_D0M4=4044
				AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	END
	
	-- //////////////////////////////////////////////////////////////
GO


---- ///////////////////////////////////////////////////////////////
---- //					
---- ///////////////////////////////////////////////////////////////


--IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_4045a_TIEMPO]') AND type in (N'P', N'PC'))
--	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_4045a_TIEMPO]
--GO


--CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_4045a_TIEMPO]
--	@PP_L_DEBUG					INT,
--	@PP_K_SISTEMA_EXE			INT,
--	@PP_K_USUARIO_ACCION		INT,
--	-- ==============================
--	@PP_K_DOCUMENTO_D0M4		INT
--AS

--	IF @PP_L_DEBUG>0
--		PRINT '[PG_OP_DATA_N3_4045a_TIEMPO]'

--		-- ////////////////////////////////////////////////
			
--		UPDATE	DATA_N3_X_ME_D0M4  
--				SET	[M01_VALOR]=TM01.D_TIEMPO_MES,
--					[M02_VALOR]=TM02.D_TIEMPO_MES,
--					[M03_VALOR]=TM03.D_TIEMPO_MES,
--					[M04_VALOR]=TM04.D_TIEMPO_MES,
--					[M05_VALOR]=TM05.D_TIEMPO_MES,
--					[M06_VALOR]=TM06.D_TIEMPO_MES
--				FROM	TIEMPO_MES TM01,
--						TIEMPO_MES TM02,
--						TIEMPO_MES TM03,
--						TIEMPO_MES TM04,
--						TIEMPO_MES TM05,
--						TIEMPO_MES TM06,
--						DATA_N3_X_ME_D0M4 DM1,
--						DATA_N3_X_ME_D0M4
--				WHERE TM01.K_TIEMPO_MES=DM1.M01_VALOR
--				AND		TM02.K_TIEMPO_MES=DM1.M02_VALOR
--				AND		TM03.K_TIEMPO_MES=DM1.M03_VALOR
--				AND		TM04.K_TIEMPO_MES=DM1.M04_VALOR
--				AND		TM05.K_TIEMPO_MES=DM1.M05_VALOR
--				AND		TM06.K_TIEMPO_MES=DM1.M06_VALOR
--				AND		DATA_N3_X_ME_D0M4.K_DATO_D0M4=4045
--				AND		DM1.K_DATO_D0M4=4044
--				AND		DM1.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
--				AND		DM1.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	
--	-- //////////////////////////////////////////////////////////////
--GO


-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_4046a_VIERNES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_4046a_VIERNES]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_4046a_VIERNES]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N3_4046a_VIERNES]'

		DECLARE @VP_YYYY INT

		SELECT		@VP_YYYY=DOCUMENTO_D0M4.K_YYYY			
					FROM	DOCUMENTO_D0M4 
					WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

		-- ////////////////////////////////////////////////

		DECLARE @VP_VIERNES_01 INT
		
		SELECT @VP_VIERNES_01 =	COUNT(*) 
								FROM	TIEMPO_FECHA,DATA_N3_X_ME_D0M4 
								WHERE	TIEMPO_FECHA.K_TIEMPO_MES=DATA_N3_X_ME_D0M4.M01_VALOR
								AND		TIEMPO_FECHA.FECHA_YYYY=@VP_YYYY 
								AND		K_TIEMPO_DIA_SEMANA=5	
								AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

		-- ////////////////////////////////////////////////

		DECLARE @VP_VIERNES_02 INT

		SELECT @VP_VIERNES_02 =	COUNT(*) 
								FROM	TIEMPO_FECHA,DATA_N3_X_ME_D0M4 
								WHERE	TIEMPO_FECHA.K_TIEMPO_MES=DATA_N3_X_ME_D0M4.M02_VALOR
								AND		TIEMPO_FECHA.FECHA_YYYY=@VP_YYYY 
								AND		K_TIEMPO_DIA_SEMANA=5	
								AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

		-- ////////////////////////////////////////////////

		DECLARE @VP_VIERNES_03 INT

		SELECT @VP_VIERNES_03 =	COUNT(*) 
								FROM	TIEMPO_FECHA,DATA_N3_X_ME_D0M4 
								WHERE	TIEMPO_FECHA.K_TIEMPO_MES=DATA_N3_X_ME_D0M4.M03_VALOR
								AND		TIEMPO_FECHA.FECHA_YYYY=@VP_YYYY 
								AND		K_TIEMPO_DIA_SEMANA=5	
								AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

		-- ////////////////////////////////////////////////

		DECLARE @VP_VIERNES_04 INT

		SELECT @VP_VIERNES_04 =	COUNT(*) 
								FROM	TIEMPO_FECHA,DATA_N3_X_ME_D0M4 
								WHERE	TIEMPO_FECHA.K_TIEMPO_MES=DATA_N3_X_ME_D0M4.M04_VALOR
								AND		TIEMPO_FECHA.FECHA_YYYY=@VP_YYYY 
								AND		K_TIEMPO_DIA_SEMANA=5	
								AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4


		-- ////////////////////////////////////////////////

		DECLARE @VP_VIERNES_05 INT

		SELECT @VP_VIERNES_05 =	COUNT(*) 
								FROM	TIEMPO_FECHA,DATA_N3_X_ME_D0M4 
								WHERE	TIEMPO_FECHA.K_TIEMPO_MES=DATA_N3_X_ME_D0M4.M05_VALOR
								AND		TIEMPO_FECHA.FECHA_YYYY=@VP_YYYY 
								AND		K_TIEMPO_DIA_SEMANA=5	
								AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

		-- ////////////////////////////////////////////////


		DECLARE @VP_VIERNES_06 INT

		SELECT @VP_VIERNES_06 =	COUNT(*) 
								FROM	TIEMPO_FECHA,DATA_N3_X_ME_D0M4 
								WHERE	TIEMPO_FECHA.K_TIEMPO_MES=DATA_N3_X_ME_D0M4.M06_VALOR
								AND		TIEMPO_FECHA.FECHA_YYYY=@VP_YYYY 
								AND		K_TIEMPO_DIA_SEMANA=5	
								AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4


		-- ////////////////////////////////////////////////
		
				UPDATE	DATA_N3_X_ME_D0M4 
				SET	[M01_VALOR]=@VP_VIERNES_01,
					[M02_VALOR]=@VP_VIERNES_02,
					[M03_VALOR]=@VP_VIERNES_03,
					[M04_VALOR]=@VP_VIERNES_04,
					[M05_VALOR]=@VP_VIERNES_05,
					[M06_VALOR]=@VP_VIERNES_06
				FROM	DATA_N3_X_ME_D0M4
				WHERE 	K_DATO_D0M4=4046
				AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		
	
	-- //////////////////////////////////////////////////////////////
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_4047a_TEMPORADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_4047a_TEMPORADA]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_4047a_TEMPORADA]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N3_4047a_TEMPORADA]'

		-- ////////////////////////////////////////////////
		DECLARE @VP_TEMPORADA INT	

		SELECT	@VP_TEMPORADA= PARAMETRO_POB.K_TEMPORADA
				FROM	PARAMETRO_POB 
				WHERE	PARAMETRO_POB.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4


			
		UPDATE	DATA_N3_X_ME_D0M4 
				SET	[M01_VALOR]=@VP_TEMPORADA,
					[M02_VALOR]=@VP_TEMPORADA,
					[M03_VALOR]=@VP_TEMPORADA,
					[M04_VALOR]=@VP_TEMPORADA,
					[M05_VALOR]=@VP_TEMPORADA,
					[M06_VALOR]=@VP_TEMPORADA
				WHERE 	K_DATO_D0M4=4047
				AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	
	-- //////////////////////////////////////////////////////////////
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_4054a_HISTORICO_CONSIDERABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_4054a_HISTORICO_CONSIDERABLE]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_4054a_HISTORICO_CONSIDERABLE]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N3_4054a_HISTORICO_CONSIDERABLE]'

		-- ////////////////////////////////////////////////

		DECLARE @VP_HISTORICO_CONSIDERABLE	INT
		DECLARE @VP_TEMPORADA				INT
		DECLARE @VP_K_UNIDAD_OPERATIVA		INT
		DECLARE @VP_K_YYYY					INT


		SELECT	@VP_TEMPORADA= K_TEMPORADA,
				@VP_HISTORICO_CONSIDERABLE=HISTORICO_CONSIDERABLE,
				@VP_K_YYYY=K_YYYY,
				@VP_K_UNIDAD_OPERATIVA=K_UNIDAD_OPERATIVA
				FROM	PARAMETRO_POB 
				WHERE	PARAMETRO_POB.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		DECLARE @VP_CONTADOR INT=1
		DECLARE @VP_PERFORMANCE_N INT=1
		SET @VP_PERFORMANCE_N=@VP_HISTORICO_CONSIDERABLE
		IF @VP_TEMPORADA=1
		BEGIN
			
			WHILE (SELECT @VP_CONTADOR)<@VP_HISTORICO_CONSIDERABLE+1
			BEGIN
				
				UPDATE	DATA_N3_X_ME_D0M4 
				SET	[M01_VALOR]=PERFORMANCE_N3_X_ME.M04_VALOR,
					[M02_VALOR]=PERFORMANCE_N3_X_ME.M05_VALOR,
					[M03_VALOR]=PERFORMANCE_N3_X_ME.M06_VALOR,
					[M04_VALOR]=PERFORMANCE_N3_X_ME.M07_VALOR,
					[M05_VALOR]=PERFORMANCE_N3_X_ME.M08_VALOR,
					[M06_VALOR]=PERFORMANCE_N3_X_ME.M09_VALOR
				FROM	PERFORMANCE_N3_X_ME,DATA_N3_X_ME_D0M4
				WHERE 	PERFORMANCE_N3_X_ME.K_YYYY=@VP_K_YYYY-@VP_PERFORMANCE_N
				AND		PERFORMANCE_N3_X_ME.K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA
				AND		PERFORMANCE_N3_X_ME.K_METRICA=1
				AND		K_DATO_D0M4=4053-@VP_CONTADOR
				AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

				SET @VP_PERFORMANCE_N=@VP_PERFORMANCE_N-1
				SET @VP_CONTADOR=@VP_CONTADOR+1
			END

		END
		
		IF @VP_TEMPORADA=2
		BEGIN			
			WHILE (SELECT @VP_CONTADOR)<@VP_HISTORICO_CONSIDERABLE+1
			BEGIN
				UPDATE	DATA_N3_X_ME_D0M4 
					SET	[M01_VALOR]=PERFORMANCE_N3_X_ME.M10_VALOR,
						[M02_VALOR]=PERFORMANCE_N3_X_ME.M11_VALOR,
						[M03_VALOR]=PERFORMANCE_N3_X_ME.M12_VALOR					
					FROM	PERFORMANCE_N3_X_ME,DATA_N3_X_ME_D0M4
					WHERE 	PERFORMANCE_N3_X_ME.K_YYYY=@VP_K_YYYY-@VP_PERFORMANCE_N
					AND		PERFORMANCE_N3_X_ME.K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA
					AND		PERFORMANCE_N3_X_ME.K_METRICA=1
					AND		K_DATO_D0M4=4053-@VP_CONTADOR
					AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
				
				
				UPDATE	DATA_N3_X_ME_D0M4 
					SET	[M04_VALOR]=PERFORMANCE_N3_X_ME.M01_VALOR,
						[M05_VALOR]=PERFORMANCE_N3_X_ME.M02_VALOR,
						[M06_VALOR]=PERFORMANCE_N3_X_ME.M03_VALOR				
					FROM	PERFORMANCE_N3_X_ME,DATA_N3_X_ME_D0M4
					WHERE 	PERFORMANCE_N3_X_ME.K_YYYY=@VP_K_YYYY-@VP_PERFORMANCE_N+1
					AND		PERFORMANCE_N3_X_ME.K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA
					AND		PERFORMANCE_N3_X_ME.K_METRICA=1
					AND		K_DATO_D0M4=4053-@VP_CONTADOR
					AND		K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4			

				DECLARE @VP_K_DATO INT
				SET @VP_K_DATO=4053-@VP_CONTADOR
				EXECUTE [DBO].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO] @PP_K_DOCUMENTO_D0M4, @VP_K_DATO

				SET @VP_PERFORMANCE_N=@VP_PERFORMANCE_N-1
				SET @VP_CONTADOR=@VP_CONTADOR+1
			END
		END
			
	-- //////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					[#4001] PRONOSTICO DE VENTA ESTIMADA
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_4001a_PRONOSTICO_DE_VENTA_ESTIMADA_X_PROMEDIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_4001a_PRONOSTICO_DE_VENTA_ESTIMADA_X_PROMEDIO]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_4001a_PRONOSTICO_DE_VENTA_ESTIMADA_X_PROMEDIO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N3_4001a_PRONOSTICO_DE_VENTA_ESTIMADA_X_PROMEDIO]'

		-- ////////////////////////////////////////////////

		DECLARE @VP_HISTORICO_CONSIDERABLE	INT
		DECLARE @VP_TEMPORADA				INT
		DECLARE @VP_K_UNIDAD_OPERATIVA		INT
		DECLARE @VP_K_YYYY					INT


		SELECT	@VP_TEMPORADA= K_TEMPORADA,
				@VP_HISTORICO_CONSIDERABLE=HISTORICO_CONSIDERABLE,
				@VP_K_YYYY=K_YYYY,
				@VP_K_UNIDAD_OPERATIVA=K_UNIDAD_OPERATIVA
				FROM	PARAMETRO_POB 
				WHERE	PARAMETRO_POB.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

		DECLARE	@VP_VENTAS_01 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_02 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_03 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_04 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_05 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_06 DECIMAL (19,4)=0
		
		SELECT  @VP_VENTAS_01=(SUM(M01_VALOR))/@VP_HISTORICO_CONSIDERABLE, 
			    @VP_VENTAS_02=(SUM(M02_VALOR))/@VP_HISTORICO_CONSIDERABLE,
			    @VP_VENTAS_03=(SUM(M03_VALOR))/@VP_HISTORICO_CONSIDERABLE,
			    @VP_VENTAS_04=(SUM(M04_VALOR))/@VP_HISTORICO_CONSIDERABLE,
			    @VP_VENTAS_05=(SUM(M05_VALOR))/@VP_HISTORICO_CONSIDERABLE,
			    @VP_VENTAS_06=(SUM(M06_VALOR))/@VP_HISTORICO_CONSIDERABLE
		FROM	DATA_N3_X_ME_D0M4
		WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		AND		K_DATO_D0M4 IN (  4048,4049,4050,4051,4052	)
				
		DECLARE @VP_ACUMULADO DECIMAL(19,4)
		SET     @VP_ACUMULADO=		@VP_VENTAS_01 + @VP_VENTAS_02 + @VP_VENTAS_03 
								+	@VP_VENTAS_04 + @VP_VENTAS_05 + @VP_VENTAS_06

		
		-- ACTUALIZACION DE [#4001] PRONOSTICO DE VENTA

		IF @PP_L_DEBUG=1
			SELECT 'ACTUALIZACION DE [#4001] PRONOSTICO DE VENTA'
		UPDATE	DATA_N3_X_ME_D0M4 
			SET	[M01_VALOR]=@VP_VENTAS_01,
				[M02_VALOR]=@VP_VENTAS_02,
				[M03_VALOR]=@VP_VENTAS_03,
				[M04_VALOR]=@VP_VENTAS_04,
				[M05_VALOR]=@VP_VENTAS_05,
				[M06_VALOR]=@VP_VENTAS_06				
			WHERE 	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
			AND		K_DATO_D0M4=4001

		EXECUTE [DBO].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO] @PP_K_DOCUMENTO_D0M4,4001
						
		-- ACTUALIZACION DE [#4053] (P@) PERFIL DE VENTA
		IF @PP_L_DEBUG=1
			SELECT 'ACTUALIZACION DE [#4053] (P@) PERFIL DE VENTA'

		UPDATE	DATA_N3_X_ME_D0M4
			SET	M00_VALOR=1,
				[M01_VALOR]=@VP_VENTAS_01/@VP_ACUMULADO,
				[M02_VALOR]=@VP_VENTAS_02/@VP_ACUMULADO,
				[M03_VALOR]=@VP_VENTAS_03/@VP_ACUMULADO,
				[M04_VALOR]=@VP_VENTAS_04/@VP_ACUMULADO,
				[M05_VALOR]=@VP_VENTAS_05/@VP_ACUMULADO,
				[M06_VALOR]=@VP_VENTAS_06/@VP_ACUMULADO
			WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
			AND		K_DATO_D0M4=4053

		EXECUTE [DBO].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO] @PP_K_DOCUMENTO_D0M4,4053
			
	-- //////////////////////////////////////////////////////////////
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_4001a_PRONOSTICO_DE_VENTA_X_MINIMOS_CUADRADOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_4001a_PRONOSTICO_DE_VENTA_X_MINIMOS_CUADRADOS]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_4001a_PRONOSTICO_DE_VENTA_X_MINIMOS_CUADRADOS]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N3_4001a_PRONOSTICO_DE_VENTA_X_MINIMOS_CUADRADOS]'

		-- ////////////////////////////////////////////////

		DECLARE @VP_HISTORICO_CONSIDERABLE	INT
		DECLARE @VP_TEMPORADA				INT
		DECLARE @VP_K_UNIDAD_OPERATIVA		INT
		DECLARE @VP_K_YYYY					INT


		SELECT	@VP_TEMPORADA= K_TEMPORADA,
				@VP_HISTORICO_CONSIDERABLE=HISTORICO_CONSIDERABLE,
				@VP_K_YYYY=K_YYYY,
				@VP_K_UNIDAD_OPERATIVA=K_UNIDAD_OPERATIVA
				FROM	PARAMETRO_POB 
				WHERE	PARAMETRO_POB.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

		
		-- PERIODO DE VENTA
		DECLARE @VP_X01 INT=0
		DECLARE @VP_X02 INT=0
		DECLARE @VP_X03 INT=0
		DECLARE @VP_X04 INT=0
		DECLARE @VP_X05 INT=0

		DECLARE @VP_PERIODO INT=0
		SET @VP_PERIODO=@VP_HISTORICO_CONSIDERABLE
		
		DECLARE @VP_CONTADOR INT=5
		
		WHILE (SELECT @VP_CONTADOR)>0 AND (SELECT @VP_PERIODO)>0
		BEGIN
			IF @VP_CONTADOR=5
				SET @VP_X05=@VP_PERIODO
			IF @VP_CONTADOR=4
				SET @VP_X04=@VP_PERIODO
			IF @VP_CONTADOR=3
				SET @VP_X03=@VP_PERIODO
			IF @VP_CONTADOR=2
				SET @VP_X02=@VP_PERIODO
			IF @VP_CONTADOR=1
				SET @VP_X01=@VP_PERIODO

			SET @VP_CONTADOR=@VP_CONTADOR-1
			SET @VP_PERIODO=@VP_PERIODO-1
		END

		-- SUMATORIA DE PERIODOS
		DECLARE @VP_ZX INT=0
		SET @VP_ZX=@VP_X01+@VP_X02+ @VP_X03+ @VP_X04+ @VP_X05

		
		-- SUMATORIA DE VENTAS DE 6 MESES
		DECLARE	@VP_VENTAS_01 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_02 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_03 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_04 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_05 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_06 DECIMAL (19,4)=0

		SELECT  @VP_VENTAS_01=(SUM(M01_VALOR)),  
			    @VP_VENTAS_02=(SUM(M02_VALOR)),
			    @VP_VENTAS_03=(SUM(M03_VALOR)),
			    @VP_VENTAS_04=(SUM(M04_VALOR)),
			    @VP_VENTAS_05=(SUM(M05_VALOR)),
			    @VP_VENTAS_06=(SUM(M06_VALOR))
		FROM	DATA_N3_X_ME_D0M4
		WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		AND		K_DATO_D0M4 IN (  4048,4049,4050,4051,4052	)
				

		DECLARE @VP_ACUMULADO DECIMAL(19,4)
		SET     @VP_ACUMULADO=		@VP_VENTAS_01 + @VP_VENTAS_02 + @VP_VENTAS_03 
								+	@VP_VENTAS_04 + @VP_VENTAS_05 + @VP_VENTAS_06

																		
		-- calculo de equis cuadrada de todos los periodos

		DECLARE @VP_X01_2 INT=0
		DECLARE @VP_X02_2 INT=0
		DECLARE @VP_X03_2 INT=0
		DECLARE @VP_X04_2 INT=0
		DECLARE @VP_X05_2 INT=0

		SET @VP_X01_2=@VP_X01*@VP_X01 
		SET @VP_X02_2=@VP_X02*@VP_X02
		SET @VP_X03_2=@VP_X03*@VP_X03
		SET @VP_X04_2=@VP_X04*@VP_X04
		SET @VP_X05_2=@VP_X05*@VP_X05

		--calculo de sumatoria de x por y

		-- SUMATORIA DE VENTAS POR EL PERIODO DE 6 MESES
		DECLARE	@VP_VENTAS_01_PERIODO DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_02_PERIODO DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_03_PERIODO DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_04_PERIODO DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_05_PERIODO DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_06_PERIODO DECIMAL (19,4)=0

		SELECT	@VP_VENTAS_01_PERIODO=(M01_VALOR*@VP_X01),
				@VP_VENTAS_02_PERIODO=(M02_VALOR*@VP_X01),
				@VP_VENTAS_03_PERIODO=(M03_VALOR*@VP_X01),
				@VP_VENTAS_04_PERIODO=(M04_VALOR*@VP_X01),
				@VP_VENTAS_05_PERIODO=(M05_VALOR*@VP_X01),				
				@VP_VENTAS_06_PERIODO=(M06_VALOR*@VP_X01)				
		FROM DATA_N3_X_ME_D0M4 
		WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		AND		K_DATO_D0M4=4048

		SELECT	@VP_VENTAS_01_PERIODO=@VP_VENTAS_01_PERIODO+(M01_VALOR*@VP_X02),
				@VP_VENTAS_02_PERIODO=@VP_VENTAS_02_PERIODO+(M02_VALOR*@VP_X02),
				@VP_VENTAS_03_PERIODO=@VP_VENTAS_03_PERIODO+(M03_VALOR*@VP_X02),
				@VP_VENTAS_04_PERIODO=@VP_VENTAS_04_PERIODO+(M04_VALOR*@VP_X02),
				@VP_VENTAS_05_PERIODO=@VP_VENTAS_05_PERIODO+(M05_VALOR*@VP_X02),				
				@VP_VENTAS_06_PERIODO=@VP_VENTAS_06_PERIODO+(M06_VALOR*@VP_X02)				
		FROM DATA_N3_X_ME_D0M4 
		WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		AND		K_DATO_D0M4=4049

		SELECT	@VP_VENTAS_01_PERIODO=@VP_VENTAS_01_PERIODO+(M01_VALOR*@VP_X03),
				@VP_VENTAS_02_PERIODO=@VP_VENTAS_02_PERIODO+(M02_VALOR*@VP_X03),
				@VP_VENTAS_03_PERIODO=@VP_VENTAS_03_PERIODO+(M03_VALOR*@VP_X03),
				@VP_VENTAS_04_PERIODO=@VP_VENTAS_04_PERIODO+(M04_VALOR*@VP_X03),
				@VP_VENTAS_05_PERIODO=@VP_VENTAS_05_PERIODO+(M05_VALOR*@VP_X03),				
				@VP_VENTAS_06_PERIODO=@VP_VENTAS_06_PERIODO+(M06_VALOR*@VP_X03)				
		FROM DATA_N3_X_ME_D0M4 
		WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		AND		K_DATO_D0M4=4050

		SELECT	@VP_VENTAS_01_PERIODO=@VP_VENTAS_01_PERIODO+(M01_VALOR*@VP_X04),
				@VP_VENTAS_02_PERIODO=@VP_VENTAS_02_PERIODO+(M02_VALOR*@VP_X04),
				@VP_VENTAS_03_PERIODO=@VP_VENTAS_03_PERIODO+(M03_VALOR*@VP_X04),
				@VP_VENTAS_04_PERIODO=@VP_VENTAS_04_PERIODO+(M04_VALOR*@VP_X04),
				@VP_VENTAS_05_PERIODO=@VP_VENTAS_05_PERIODO+(M05_VALOR*@VP_X04),				
				@VP_VENTAS_06_PERIODO=@VP_VENTAS_06_PERIODO+(M06_VALOR*@VP_X04)				
		FROM DATA_N3_X_ME_D0M4 
		WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		AND		K_DATO_D0M4=4051

		SELECT	@VP_VENTAS_01_PERIODO=@VP_VENTAS_01_PERIODO+(M01_VALOR*@VP_X05),
				@VP_VENTAS_02_PERIODO=@VP_VENTAS_02_PERIODO+(M02_VALOR*@VP_X05),
				@VP_VENTAS_03_PERIODO=@VP_VENTAS_03_PERIODO+(M03_VALOR*@VP_X05),
				@VP_VENTAS_04_PERIODO=@VP_VENTAS_04_PERIODO+(M04_VALOR*@VP_X05),
				@VP_VENTAS_05_PERIODO=@VP_VENTAS_05_PERIODO+(M05_VALOR*@VP_X05),				
				@VP_VENTAS_06_PERIODO=@VP_VENTAS_06_PERIODO+(M06_VALOR*@VP_X05)				
		FROM DATA_N3_X_ME_D0M4 
		WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		AND		K_DATO_D0M4=4052
		
		-- SUMATORIA DE EQUIS CUADRADA

		DECLARE @VP_ZX_2 INT=0
		SET @VP_ZX_2=@VP_X01_2+@VP_X02_2+@VP_X03_2+@VP_X04_2+@VP_X05_2


		-- CALCULO DE B
		DECLARE	@VP_B_01 DECIMAL (19,4)=0
		DECLARE	@VP_B_02 DECIMAL (19,4)=0
		DECLARE	@VP_B_03 DECIMAL (19,4)=0
		DECLARE	@VP_B_04 DECIMAL (19,4)=0
		DECLARE	@VP_B_05 DECIMAL (19,4)=0
		DECLARE	@VP_B_06 DECIMAL (19,4)=0
		
		SET @VP_B_01= (@VP_HISTORICO_CONSIDERABLE*@VP_VENTAS_01_PERIODO - @VP_ZX*@VP_VENTAS_01)/(@VP_HISTORICO_CONSIDERABLE*@VP_ZX_2 - @VP_ZX*@VP_ZX)
		SET @VP_B_02= (@VP_HISTORICO_CONSIDERABLE*@VP_VENTAS_02_PERIODO - @VP_ZX*@VP_VENTAS_02)/(@VP_HISTORICO_CONSIDERABLE*@VP_ZX_2 - @VP_ZX*@VP_ZX)
		SET @VP_B_03= (@VP_HISTORICO_CONSIDERABLE*@VP_VENTAS_03_PERIODO - @VP_ZX*@VP_VENTAS_03)/(@VP_HISTORICO_CONSIDERABLE*@VP_ZX_2 - @VP_ZX*@VP_ZX)
		SET @VP_B_04= (@VP_HISTORICO_CONSIDERABLE*@VP_VENTAS_04_PERIODO - @VP_ZX*@VP_VENTAS_04)/(@VP_HISTORICO_CONSIDERABLE*@VP_ZX_2 - @VP_ZX*@VP_ZX)
		SET @VP_B_05= (@VP_HISTORICO_CONSIDERABLE*@VP_VENTAS_05_PERIODO - @VP_ZX*@VP_VENTAS_05)/(@VP_HISTORICO_CONSIDERABLE*@VP_ZX_2 - @VP_ZX*@VP_ZX)
		SET @VP_B_06= (@VP_HISTORICO_CONSIDERABLE*@VP_VENTAS_06_PERIODO - @VP_ZX*@VP_VENTAS_06)/(@VP_HISTORICO_CONSIDERABLE*@VP_ZX_2 - @VP_ZX*@VP_ZX)

		-- CALCULO DE A

		DECLARE	@VP_A_01 DECIMAL (19,4)=0
		DECLARE	@VP_A_02 DECIMAL (19,4)=0
		DECLARE	@VP_A_03 DECIMAL (19,4)=0
		DECLARE	@VP_A_04 DECIMAL (19,4)=0
		DECLARE	@VP_A_05 DECIMAL (19,4)=0
		DECLARE	@VP_A_06 DECIMAL (19,4)=0

		SET @VP_A_01=(@VP_VENTAS_01-@VP_B_01*@VP_ZX)/@VP_HISTORICO_CONSIDERABLE
		SET @VP_A_02=(@VP_VENTAS_02-@VP_B_02*@VP_ZX)/@VP_HISTORICO_CONSIDERABLE
		SET @VP_A_03=(@VP_VENTAS_03-@VP_B_03*@VP_ZX)/@VP_HISTORICO_CONSIDERABLE
		SET @VP_A_04=(@VP_VENTAS_04-@VP_B_04*@VP_ZX)/@VP_HISTORICO_CONSIDERABLE
		SET @VP_A_05=(@VP_VENTAS_05-@VP_B_05*@VP_ZX)/@VP_HISTORICO_CONSIDERABLE
		SET @VP_A_06=(@VP_VENTAS_06-@VP_B_06*@VP_ZX)/@VP_HISTORICO_CONSIDERABLE

		-- 	CALCULO DE Y=ESTIMACION DE VENTA

		DECLARE @VP_Y_01 DECIMAL (19,4)=0
		DECLARE @VP_Y_02 DECIMAL (19,4)=0
		DECLARE @VP_Y_03 DECIMAL (19,4)=0
		DECLARE @VP_Y_04 DECIMAL (19,4)=0
		DECLARE @VP_Y_05 DECIMAL (19,4)=0
		DECLARE @VP_Y_06 DECIMAL (19,4)=0

		SET @VP_Y_01=@VP_A_01+@VP_B_01*@VP_HISTORICO_CONSIDERABLE
		SET @VP_Y_02=@VP_A_02+@VP_B_02*@VP_HISTORICO_CONSIDERABLE
		SET @VP_Y_03=@VP_A_03+@VP_B_03*@VP_HISTORICO_CONSIDERABLE
		SET @VP_Y_04=@VP_A_04+@VP_B_04*@VP_HISTORICO_CONSIDERABLE
		SET @VP_Y_05=@VP_A_05+@VP_B_05*@VP_HISTORICO_CONSIDERABLE
		SET @VP_Y_06=@VP_A_06+@VP_B_06*@VP_HISTORICO_CONSIDERABLE

		-- CALCULO DE ACUMULADO
		
		DECLARE @VP_ACUMULADO_Y DECIMAL (19,4)=0
		SET		@VP_ACUMULADO_Y=@VP_Y_01+@VP_Y_02+@VP_Y_03+@VP_Y_04+@VP_Y_05+@VP_Y_06

		--  ACTUALIZACION DE [#4001] PRONOSTICO DE VENTA ESTIMADA

		UPDATE	DATA_N3_X_ME_D0M4 
			SET	M00_VALOR=@VP_ACUMULADO_Y,
				M01_VALOR=@VP_Y_01,
				M02_VALOR=@VP_Y_02,
				M03_VALOR=@VP_Y_03,
				M04_VALOR=@VP_Y_04,
				M05_VALOR=@VP_Y_05,
				M06_VALOR=@VP_Y_06
			WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
			AND		K_DATO_D0M4=4001
		
		EXECUTE [DBO].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO] @PP_K_DOCUMENTO_D0M4,4001

		-- ACTUALIZACION DE [#4053] (P@) PERFIL DE VENTA

		UPDATE	DATA_N3_X_ME_D0M4
			SET	M00_VALOR=1,
				M01_VALOR=@VP_Y_01/@VP_ACUMULADO_Y,
				M02_VALOR=@VP_Y_02/@VP_ACUMULADO_Y,
				M03_VALOR=@VP_Y_03/@VP_ACUMULADO_Y,
				M04_VALOR=@VP_Y_04/@VP_ACUMULADO_Y,
				M05_VALOR=@VP_Y_05/@VP_ACUMULADO_Y,
				M06_VALOR=@VP_Y_06/@VP_ACUMULADO_Y
			WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
			AND		K_DATO_D0M4=4053

		EXECUTE [DBO].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO] @PP_K_DOCUMENTO_D0M4,4053


			
	-- //////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					[#4001] PRONOSTICO DE VENTA ESTIMADA
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_4001a_PRONOSTICO_DE_VENTA_ESTIMADA_X_PROMEDIO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_4001a_PRONOSTICO_DE_VENTA_ESTIMADA_X_PROMEDIO]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_4001a_PRONOSTICO_DE_VENTA_ESTIMADA_X_PROMEDIO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N3_4001a_PRONOSTICO_DE_VENTA_ESTIMADA_X_PROMEDIO]'

		-- ////////////////////////////////////////////////

		DECLARE @VP_HISTORICO_CONSIDERABLE	INT
		DECLARE @VP_TEMPORADA				INT
		DECLARE @VP_K_UNIDAD_OPERATIVA		INT
		DECLARE @VP_K_YYYY					INT


		SELECT	@VP_TEMPORADA= K_TEMPORADA,
				@VP_HISTORICO_CONSIDERABLE=HISTORICO_CONSIDERABLE,
				@VP_K_YYYY=K_YYYY,
				@VP_K_UNIDAD_OPERATIVA=K_UNIDAD_OPERATIVA
				FROM	PARAMETRO_POB 
				WHERE	PARAMETRO_POB.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

		DECLARE	@VP_VENTAS_01 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_02 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_03 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_04 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_05 DECIMAL (19,4)=0
		DECLARE	@VP_VENTAS_06 DECIMAL (19,4)=0
		
		SELECT  @VP_VENTAS_01=(SUM(M01_VALOR))/@VP_HISTORICO_CONSIDERABLE, 
			    @VP_VENTAS_02=(SUM(M02_VALOR))/@VP_HISTORICO_CONSIDERABLE,
			    @VP_VENTAS_03=(SUM(M03_VALOR))/@VP_HISTORICO_CONSIDERABLE,
			    @VP_VENTAS_04=(SUM(M04_VALOR))/@VP_HISTORICO_CONSIDERABLE,
			    @VP_VENTAS_05=(SUM(M05_VALOR))/@VP_HISTORICO_CONSIDERABLE,
			    @VP_VENTAS_06=(SUM(M06_VALOR))/@VP_HISTORICO_CONSIDERABLE
		FROM	DATA_N3_X_ME_D0M4
		WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		AND		K_DATO_D0M4 IN (  4048,4049,4050,4051,4052	)
				
		DECLARE @VP_ACUMULADO DECIMAL(19,4)
		SET     @VP_ACUMULADO=		@VP_VENTAS_01 + @VP_VENTAS_02 + @VP_VENTAS_03 
								+	@VP_VENTAS_04 + @VP_VENTAS_05 + @VP_VENTAS_06

		
		-- ACTUALIZACION DE [#4001] PRONOSTICO DE VENTA

		IF @PP_L_DEBUG=1
			SELECT 'ACTUALIZACION DE [#4001] PRONOSTICO DE VENTA'
		UPDATE	DATA_N3_X_ME_D0M4 
			SET	[M01_VALOR]=@VP_VENTAS_01,
				[M02_VALOR]=@VP_VENTAS_02,
				[M03_VALOR]=@VP_VENTAS_03,
				[M04_VALOR]=@VP_VENTAS_04,
				[M05_VALOR]=@VP_VENTAS_05,
				[M06_VALOR]=@VP_VENTAS_06				
			WHERE 	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
			AND		K_DATO_D0M4=4001

		EXECUTE [DBO].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO] @PP_K_DOCUMENTO_D0M4,4001
						
		-- ACTUALIZACION DE [#4053] (P@) PERFIL DE VENTA
		IF @PP_L_DEBUG=1
			SELECT 'ACTUALIZACION DE [#4053] (P@) PERFIL DE VENTA'

		UPDATE	DATA_N3_X_ME_D0M4
			SET	M00_VALOR=1,
				[M01_VALOR]=@VP_VENTAS_01/@VP_ACUMULADO,
				[M02_VALOR]=@VP_VENTAS_02/@VP_ACUMULADO,
				[M03_VALOR]=@VP_VENTAS_03/@VP_ACUMULADO,
				[M04_VALOR]=@VP_VENTAS_04/@VP_ACUMULADO,
				[M05_VALOR]=@VP_VENTAS_05/@VP_ACUMULADO,
				[M06_VALOR]=@VP_VENTAS_06/@VP_ACUMULADO
			WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
			AND		K_DATO_D0M4=4053

		EXECUTE [DBO].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO] @PP_K_DOCUMENTO_D0M4,4053
			
	-- //////////////////////////////////////////////////////////////
GO







-- ///////////////////////////////////////////////////////////////
-- //					[#4055] (P@) INCREMENTO_COMPROMISO_KG
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_4055a_INCREMENTO_COMPROMISO_KG]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_4055a_INCREMENTO_COMPROMISO_KG]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_4055a_INCREMENTO_COMPROMISO_KG]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N3_4055a_INCREMENTO_COMPROMISO_KG]'

		-- ////////////////////////////////////////////////

		DECLARE @VP_HISTORICO_CONSIDERABLE		INT
		DECLARE @VP_TEMPORADA					INT
		DECLARE @VP_K_UNIDAD_OPERATIVA			INT
		DECLARE @VP_K_YYYY						INT
		DECLARE	@VP_INCREMENTO_COMPROMISO_KG	DECIMAL (19,0)


		SELECT	@VP_TEMPORADA= K_TEMPORADA,
				@VP_HISTORICO_CONSIDERABLE=HISTORICO_CONSIDERABLE,
				@VP_K_YYYY=K_YYYY,
				@VP_K_UNIDAD_OPERATIVA=K_UNIDAD_OPERATIVA,
				@VP_INCREMENTO_COMPROMISO_KG=INCREMENTO_COMPROMISO_KG
				FROM	PARAMETRO_POB 
				WHERE	PARAMETRO_POB.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

		
		DECLARE @VP_INCREMENTO_01	DECIMAL (19,0)
		DECLARE @VP_INCREMENTO_02	DECIMAL (19,0)
		DECLARE @VP_INCREMENTO_03	DECIMAL (19,0)
		DECLARE @VP_INCREMENTO_04	DECIMAL (19,0)
		DECLARE @VP_INCREMENTO_05	DECIMAL (19,0)
		DECLARE @VP_INCREMENTO_06	DECIMAL (19,0)

		SELECT	@VP_INCREMENTO_01= @VP_INCREMENTO_COMPROMISO_KG*M01_VALOR,
				@VP_INCREMENTO_02= @VP_INCREMENTO_COMPROMISO_KG*M02_VALOR,
				@VP_INCREMENTO_03= @VP_INCREMENTO_COMPROMISO_KG*M03_VALOR,
				@VP_INCREMENTO_04= @VP_INCREMENTO_COMPROMISO_KG*M04_VALOR,
				@VP_INCREMENTO_05= @VP_INCREMENTO_COMPROMISO_KG*M05_VALOR,
				@VP_INCREMENTO_06= @VP_INCREMENTO_COMPROMISO_KG*M06_VALOR				
		FROM DATA_N3_X_ME_D0M4
		WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		AND		K_DATO_D0M4=4053

		EXECUTE [DBO].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO] @PP_K_DOCUMENTO_D0M4,4053


		IF @PP_L_DEBUG=1
			SELECT 'ACTUALIZACION DE 4055a_INCREMENTO_DE_VENTAS'


		UPDATE	DATA_N3_X_ME_D0M4 
		SET	[M00_VALOR]=@VP_INCREMENTO_COMPROMISO_KG,
			[M01_VALOR]=@VP_INCREMENTO_01,
			[M02_VALOR]=@VP_INCREMENTO_02,
			[M03_VALOR]=@VP_INCREMENTO_03,
			[M04_VALOR]=@VP_INCREMENTO_04,
			[M05_VALOR]=@VP_INCREMENTO_05,
			[M06_VALOR]=@VP_INCREMENTO_06				
		WHERE 	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		AND		K_DATO_D0M4=4055
						
		EXECUTE [DBO].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO] @PP_K_DOCUMENTO_D0M4,4055
			
	-- //////////////////////////////////////////////////////////////
GO



-- ///////////////////////////////////////////////////////////////
-- //					4002	VENTA COMPROMISO
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_4002a_VENTA_COMPROMISO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_4002a_VENTA_COMPROMISO]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_4002a_VENTA_COMPROMISO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG=1
		SELECT 'ACTUALIZACION DE 4002a_VENTA_COMPROMISO'

		EXECUTE [dbo].[PG_CA_MATE_N3_10A_ASIGNAR_A]	@PP_K_DOCUMENTO_D0M4, 4002,1,4055
			
	-- //////////////////////////////////////////////////////////////
GO


-- ///////////////////////////////////////////////////////////////
-- //					[#4003] PROYECCION DE VENTAS OBJETIVO
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_4003a_PROYECCION_DE_VENTAS_OBJETIVO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_4003a_PROYECCION_DE_VENTAS_OBJETIVO]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_4003a_PROYECCION_DE_VENTAS_OBJETIVO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG=1
		SELECT 'ACTUALIZACION DE [#4003] PROYECCION DE VENTAS OBJETIVO'

		EXECUTE [dbo].[PG_CA_MATE_N3_01A_SUMAR_A_MAS_B]	@PP_K_DOCUMENTO_D0M4,4003,1,4001,4002
			
	-- //////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					[#4004] INCREMENTO DE VENTAS %
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_4004a_INCREMENTO_DE_VENTAS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_4004a_INCREMENTO_DE_VENTAS]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_4004a_INCREMENTO_DE_VENTAS]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG=1
		SELECT 'CALCULO DE [#4004] INCREMENTO DE VENTAS %'

	DECLARE	@VP_INCREMENTO_01	DECIMAL (19,4)=0
	DECLARE	@VP_INCREMENTO_02	DECIMAL (19,4)=0
	DECLARE	@VP_INCREMENTO_03	DECIMAL (19,4)=0
	DECLARE	@VP_INCREMENTO_04	DECIMAL (19,4)=0
	DECLARE	@VP_INCREMENTO_05	DECIMAL (19,4)=0
	DECLARE	@VP_INCREMENTO_06	DECIMAL (19,4)=0

	SELECT  @VP_INCREMENTO_01= ((100*D1.M01_VALOR) /D2.M01_VALOR)-100, 
			@VP_INCREMENTO_02= ((100*D1.M02_VALOR) /D2.M02_VALOR)-100,
			@VP_INCREMENTO_03= ((100*D1.M03_VALOR) /D2.M03_VALOR)-100,
			@VP_INCREMENTO_04= ((100*D1.M04_VALOR) /D2.M04_VALOR)-100,
			@VP_INCREMENTO_05= ((100*D1.M05_VALOR) /D2.M05_VALOR)-100,
			@VP_INCREMENTO_06= ((100*D1.M06_VALOR) /D2.M06_VALOR)-100
	FROM	DATA_N3_X_ME_D0M4 D1,DATA_N3_X_ME_D0M4 D2
	WHERE	D1.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	AND		D2.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	AND		D1.K_DATO_D0M4=4003
	AND		D2.K_DATO_D0M4=4052

	IF @PP_L_DEBUG=1
		SELECT 'ACTUALIZACION DE [#4004] INCREMENTO DE VENTAS %'

	UPDATE	DATA_N3_X_ME_D0M4 
		SET	[M01_VALOR]=@VP_INCREMENTO_01,
			[M02_VALOR]=@VP_INCREMENTO_02,
			[M03_VALOR]=@VP_INCREMENTO_03,
			[M04_VALOR]=@VP_INCREMENTO_04,
			[M05_VALOR]=@VP_INCREMENTO_05,
			[M06_VALOR]=@VP_INCREMENTO_06				
		WHERE 	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		AND		K_DATO_D0M4=4004

	EXECUTE [DBO].[PG_CA_MATE_N3_XX_VALOR_ACUMULADO] @PP_K_DOCUMENTO_D0M4,4004

	-- //////////////////////////////////////////////////////////////
GO







-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_4000_PROYECCION_DE_VENTAS_RECALCULAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_4000_PROYECCION_DE_VENTAS_RECALCULAR]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_4000_PROYECCION_DE_VENTAS_RECALCULAR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N3_4000_PROYECCION_DE_VENTAS_RECALCULAR]'

	EXECUTE [dbo].[PG_OP_DATA_N3_4043a_TIEMPO_YYYY]				@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@PP_K_DOCUMENTO_D0M4

	EXECUTE [dbo].[PG_OP_DATA_N3_4044a_TIEMPO_MM]				@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@PP_K_DOCUMENTO_D0M4

	EXECUTE [dbo].[PG_OP_DATA_N3_4046a_VIERNES]					@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@PP_K_DOCUMENTO_D0M4

	EXECUTE [dbo].[PG_OP_DATA_N3_4047a_TEMPORADA]				@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@PP_K_DOCUMENTO_D0M4

	EXECUTE [dbo].[PG_OP_DATA_N3_4054a_HISTORICO_CONSIDERABLE]	@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@PP_K_DOCUMENTO_D0M4

	DECLARE @VP_TIPO_CALCULO INT

	SELECT @VP_TIPO_CALCULO=	K_TIPO_CALCULO 
								FROM PARAMETRO_POB 
								WHERE K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	IF @VP_TIPO_CALCULO=1
		EXECUTE [dbo].[PG_OP_DATA_N3_4001a_PRONOSTICO_DE_VENTA_ESTIMADA_X_PROMEDIO]	@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@PP_K_DOCUMENTO_D0M4

	IF @VP_TIPO_CALCULO=2
		EXECUTE [dbo].[PG_OP_DATA_N3_4001a_PRONOSTICO_DE_VENTA_X_MINIMOS_CUADRADOS] @PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@PP_K_DOCUMENTO_D0M4

	EXECUTE [dbo].[PG_OP_DATA_N3_4055a_INCREMENTO_COMPROMISO_KG]					@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@PP_K_DOCUMENTO_D0M4

	EXECUTE [dbo].[PG_OP_DATA_N3_4002a_VENTA_COMPROMISO]							@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@PP_K_DOCUMENTO_D0M4

	EXECUTE [dbo].[PG_OP_DATA_N3_4003a_PROYECCION_DE_VENTAS_OBJETIVO]				@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@PP_K_DOCUMENTO_D0M4
	
	EXECUTE [dbo].[PG_OP_DATA_N3_4004a_INCREMENTO_DE_VENTAS]						@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@PP_K_DOCUMENTO_D0M4

	-- //////////////////////////////////////////////////////////////
GO

--


--EXECUTE [dbo].[PG_OP_DATA_N3_4054a_HISTORICO_CONSIDERABLE]			1,0,69,103084
--EXECUTE [dbo].[PG_IN_DATA_N3_X_ME_D0M4_X_K_DOCUMENTO_D0M4]			1,0,69,103085
----EXECUTE [dbo].[PG_OP_DATA_N3_4000_PROYECCION_DE_VENTAS_RECALCULAR]	1,0,69,103085
--EXECUTE [dbo].[PG_OP_DATA_N3_4000_PROYECCION_DE_VENTAS_RECALCULAR]		1,0,69,103084



--EXECUTE [dbo].[PG_IN_DATA_N3_X_ME_D0M4_X_K_DOCUMENTO_D0M4]			1,0,69,1

-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
