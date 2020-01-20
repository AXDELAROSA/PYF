-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas	
-- // MODULO:			CONFIGURACION - SPs MANEJO DE FECHAS   		
-- // OPERACION:		LIBERACION     
-- //////////////////////////////////////////////////////////////

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


SET DATEFIRST 7; 
GO

-- //////////////////////////////////////////////////////////////
-- SELECT * FROM TIEMPO_FECHA
-- EXECUTE [PG_CF_TIEMPO_FECHA_X_RANGO] '2015-01-01', '2025-01-01'




-- SELECT * FROM	[VI_TIEMPO_MES_SEMANAS] ORDER BY VI_FECHA_YYYY, VI_K_TIEMPO_MES




-- //////////////////////////////////////////////////////////////
-- // DROPs 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TIEMPO_SEMANA]') AND type in (N'U'))
	DROP TABLE [dbo].[TIEMPO_SEMANA] 
GO



-- //////////////////////////////////////////////////////////////
-- // TIEMPO_SEMANAS
-- //////////////////////////////////////////////////////////////

CREATE TABLE [dbo].[TIEMPO_SEMANA] (
	[FECHA_YYYY]			[INT] NOT NULL,
	[N_SEMANA_YYYY]			[INT] NOT NULL,
	[K_TIEMPO_MES]			[INT] NOT NULL,
	[N_SEMANA]				[INT] NOT NULL,
	[F_LUNES]				[DATE] NOT NULL,
	[F_DOMINGO]				[DATE] NOT NULL
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[TIEMPO_SEMANA]
	ADD CONSTRAINT [PK_TIEMPO_SEMANA]
		PRIMARY KEY CLUSTERED ( [FECHA_YYYY], [N_SEMANA_YYYY] )
GO



ALTER TABLE [dbo].[TIEMPO_SEMANA] ADD 
	CONSTRAINT [FK_TIEMPO_SEMANA_01]  
		FOREIGN KEY ( [K_TIEMPO_MES] ) 
		REFERENCES [dbo].[TIEMPO_MES] ( [K_TIEMPO_MES] )
GO




-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VI_TIEMPO_MES_SEMANAS]'))
	DROP VIEW [dbo].[VI_TIEMPO_MES_SEMANAS]
GO


CREATE VIEW [dbo].[VI_TIEMPO_MES_SEMANAS]

AS

	SELECT	[FECHA_YYYY] AS VI_FECHA_YYYY, [K_TIEMPO_MES] AS VI_K_TIEMPO_MES, 
			MIN([N_SEMANA]) AS VI_SEMANA_MIN, 
			MAX([N_SEMANA]) AS VI_SEMANA_MAX
	FROM	[dbo].[TIEMPO_SEMANA]
	GROUP BY	
			[FECHA_YYYY], [K_TIEMPO_MES]
			 
	-- ================================
GO



-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_TIEMPO_SEMANA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_TIEMPO_SEMANA]
GO


CREATE PROCEDURE [dbo].[PG_IN_TIEMPO_SEMANA]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	-- ===========================
	@PP_FECHA_YYYY				INT,
	@PP_N_SEMANA_YYYY			INT,
	@PP_K_TIEMPO_MES			INT,
	@PP_N_SEMANA				INT,
	@PP_F_LUNES					DATE,
	@PP_F_DOMINGO				DATE
AS
	-- ========================================================
	
	INSERT INTO TIEMPO_SEMANA
		(	FECHA_YYYY,			N_SEMANA_YYYY,
			K_TIEMPO_MES,		N_SEMANA,
			F_LUNES,			F_DOMINGO				)
	VALUES	
		(	@PP_FECHA_YYYY,		@PP_N_SEMANA_YYYY,
			@PP_K_TIEMPO_MES,	@PP_N_SEMANA,
			@PP_F_LUNES,		@PP_F_DOMINGO			)

	-- ========================================================
GO



-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_TIEMPO_SEMANA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_TIEMPO_SEMANA]
GO


CREATE PROCEDURE [dbo].[PG_DL_TIEMPO_SEMANA]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_F_TIEMPO_FECHA		DATE
AS

	DELETE
	FROM	TIEMPO_FECHA
	WHERE	F_TIEMPO_FECHA=@PP_F_TIEMPO_FECHA

GO



-- //////////////////////////////////////////////////////////////
-- // PROCESAR 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_TIEMPO_SEMANA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_TIEMPO_SEMANA]
GO


CREATE PROCEDURE [dbo].[PG_CI_TIEMPO_SEMANA]
	@PP_L_DEBUG			INT,
	@PP_K_SISTEMA_EXE	INT,
	@PP_F_INICIO		DATE,
	@PP_F_FIN			DATE
AS

	DECLARE	@VP_FECHA_YYYY		INT
	DECLARE @VP_N_SEMANA_YYYY	INT
	DECLARE @VP_K_TIEMPO_MES	INT
	DECLARE @VP_N_SEMANA		INT
	DECLARE @VP_F_LUNES			DATE
	DECLARE @VP_F_DOMINGO		DATE

	-- ==============================

	SET @VP_FECHA_YYYY		= YEAR(@PP_F_INICIO)
	SET @VP_N_SEMANA_YYYY	= 1
	SET @VP_K_TIEMPO_MES	= MONTH(@PP_F_INICIO)
	SET @VP_N_SEMANA		= 1
	SET	@VP_F_LUNES			= @PP_F_INICIO
	SET	@VP_F_DOMINGO		= DATEADD( day, 6, @PP_F_INICIO )
	
	-- ==============================

	IF @VP_F_LUNES<@PP_F_FIN	
		BEGIN
		-- ==============================
	
		WHILE ( @VP_F_DOMINGO<=@PP_F_FIN )
			BEGIN
			
			IF @PP_L_DEBUG=1
				BEGIN
				PRINT	'----------------------------------------' 
				PRINT	@VP_N_SEMANA_YYYY
				PRINT	@VP_N_SEMANA
				PRINT	@VP_F_LUNES
				PRINT	@VP_F_DOMINGO
				END
	
			-- ==============================	

			IF @VP_N_SEMANA=1
				BEGIN
				SET @VP_FECHA_YYYY		= YEAR(@VP_F_DOMINGO)
				SET @VP_K_TIEMPO_MES	= MONTH(@VP_F_DOMINGO)
				END
			ELSE
				BEGIN
				SET @VP_FECHA_YYYY		= YEAR(@VP_F_LUNES)
				SET @VP_K_TIEMPO_MES	= MONTH(@VP_F_LUNES)
				END

			-- ==============================	
			
			EXECUTE [dbo].[PG_IN_TIEMPO_SEMANA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													@VP_FECHA_YYYY,
													@VP_N_SEMANA_YYYY, @VP_K_TIEMPO_MES,
													@VP_N_SEMANA, @VP_F_LUNES, @VP_F_DOMINGO
			-- ==============================	
			
			SET @VP_F_LUNES   = DATEADD( d, 7, @VP_F_LUNES )
			SET @VP_F_DOMINGO = DATEADD( d, 6, @VP_F_LUNES )

			-- ==============================	

			SET @VP_N_SEMANA_YYYY	= @VP_N_SEMANA_YYYY + 1

			IF @VP_N_SEMANA_YYYY>=53
			--	IF DAY(@VP_F_DOMINGO)>=4
				IF DAY(@VP_F_DOMINGO)>4
					SET @VP_N_SEMANA_YYYY	= 1

			-- ==============================	
			
			IF @VP_N_SEMANA=5
				SET @VP_N_SEMANA = 1
			ELSE
				BEGIN
			
				SET @VP_N_SEMANA = ( @VP_N_SEMANA + 1 )
				
				IF @VP_N_SEMANA=5
				--	IF DAY(@VP_F_DOMINGO)>=4
					IF DAY(@VP_F_DOMINGO)>4
						SET @VP_N_SEMANA = 1
				
				END	
			-- ==============================	
			END
	
		IF @PP_L_DEBUG=1
			PRINT	'/////////////////////////////////////////////////////////////'

		END
	

	-- ==============================	
GO



-- //////////////////////////////////////////////////////////////
-- // 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]
GO


CREATE PROCEDURE [dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_YYYY				INT
AS

	UPDATE	TIEMPO_FECHA
	SET		N_SEMANA =	(
							SELECT	N_SEMANA
							FROM	TIEMPO_SEMANA
							WHERE	F_TIEMPO_FECHA BETWEEN F_LUNES AND F_DOMINGO
						)
	WHERE	FECHA_YYYY=@PP_YYYY

	-- ================================================
GO



-- ////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////


-- ===============================================
SET NOCOUNT ON
-- ===============================================


DELETE 
FROM	[dbo].[TIEMPO_SEMANA]
GO


EXECUTE [dbo].[PG_CI_TIEMPO_SEMANA]	0, 0, '2009-01-05', '2038-04-04'
GO


-- ===============================================
SET NOCOUNT OFF
-- ===============================================



-- ////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////



-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2010
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2011
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2012
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2013
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2014
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2015

EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2016
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2017
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2018
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2019
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2020

EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2021
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2022
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2023
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2024
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2025

EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2026
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2027
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2028
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2029
EXECUTE	[dbo].[PG_UP_TIEMPO_SEMANA_N_SEMANA]	0, 0, 2030
GO


-- ===============================================
SET NOCOUNT OFF
-- ===============================================






-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
