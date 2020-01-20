-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			STORED PROCEDURES - BASICOS
-- // OPERACION:		LIBERACION
-- //////////////////////////////////////////////////////////////

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////

-- 


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_BD_MASTER_SQL_BACKUP] 0, 0, 0



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_BD_SISTEMA_D0M4_SQL_BACKUP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_BD_SISTEMA_D0M4_SQL_BACKUP]
GO


CREATE PROCEDURE [dbo].[PG_BD_SISTEMA_D0M4_SQL_BACKUP]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_USUARIO				[INT] 
AS
/*
	EXECUTE	[dbo].[PG_IN_BITACORA_SYS_LINEA_DIVISORIA]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO,
											--			K_CLASE, K_IMPORTANCIA, K_GRUPO
														5, 6, 1		-- #5-BD/SQL | #6-CRITICA | #1-BACKUP
*/
	-- ====================================

	DECLARE @VP_AMBIENTE	INT		
 
--	EXECUTE [dbo].[PG_SK_CONFIGURACION_AMBIENTE_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, 
--														@OU_AMBIENTE = @VP_AMBIENTE			OUTPUT

	IF @VP_AMBIENTE IS NULL
		SET @VP_AMBIENTE = 1

	-- ====================================

	DECLARE @VP_STR_NOMBRE_BD AS VARCHAR(100) = 'PYF18_Finanzas_V9999_R0'
/*	
	-- #4 PRODUCCION
	IF @VP_AMBIENTE=4 OR @VP_AMBIENTE=8
		SET @VP_STR_NOMBRE_BD = 'TUSIP_SIRA_V0900_R9'
	ELSE
		SET @VP_STR_NOMBRE_BD = 'SIRA_V0900_R9'
*/
	-- ====================================

	SET @VP_STR_NOMBRE_BD = 'PYF18_Finanzas_V9999_R0'

	-- ====================================
/*
	EXECUTE	[dbo].[PG_IN_BITACORA_SYS_BASICO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO,												
									--			K_CLASE, K_IMPORTANCIA, K_GRUPO
												5, 6, 1,		-- #5-BD/SQL | #6-CRITICA | #1-BACKUP
												'INICIO - BACKUP', @VP_STR_NOMBRE_BD,
												'PG_PR_SISTEMAXYZ_SQL_BACKUP', 0, 0
*/
	-- ====================================

	DECLARE @VP_FECHA_HOY AS DATETIME
	
	SET @VP_FECHA_HOY = GETDATE()

	-- ====================================

	DECLARE @VP_STR_FECHA_HOY_YYYYMMDD_HHMM AS VARCHAR(100)
	
	SET @VP_STR_FECHA_HOY_YYYYMMDD_HHMM = ''
	SET @VP_STR_FECHA_HOY_YYYYMMDD_HHMM = @VP_STR_FECHA_HOY_YYYYMMDD_HHMM +				CONVERT( VARCHAR(10), YEAR(@VP_FECHA_HOY) )
	SET @VP_STR_FECHA_HOY_YYYYMMDD_HHMM = @VP_STR_FECHA_HOY_YYYYMMDD_HHMM +	RIGHT( ('0'+CONVERT( VARCHAR(10), MONTH(@VP_FECHA_HOY))), 2 )
	SET @VP_STR_FECHA_HOY_YYYYMMDD_HHMM = @VP_STR_FECHA_HOY_YYYYMMDD_HHMM +	RIGHT( ('0'+CONVERT( VARCHAR(10), DAY(@VP_FECHA_HOY))), 2 )
	SET @VP_STR_FECHA_HOY_YYYYMMDD_HHMM = @VP_STR_FECHA_HOY_YYYYMMDD_HHMM +	'_'
	SET @VP_STR_FECHA_HOY_YYYYMMDD_HHMM = @VP_STR_FECHA_HOY_YYYYMMDD_HHMM +'h'+	RIGHT( ('0'+CONVERT( VARCHAR(10), DATEPART(hh,@VP_FECHA_HOY))), 2 )
	SET @VP_STR_FECHA_HOY_YYYYMMDD_HHMM = @VP_STR_FECHA_HOY_YYYYMMDD_HHMM +'m'+	RIGHT( ('0'+CONVERT( VARCHAR(10), DATEPART(mi,@VP_FECHA_HOY))), 2 )
	
	-- ====================================

	DECLARE @VP_STR_RUTA_RESPALDOS		VARCHAR(255)
	DECLARE @VP_STR_DISPOSITIVO			VARCHAR(255)
	DECLARE @VP_STR_RUTA_Y_DISPOSITIVO	VARCHAR(255)

	-- ====================================


	SET @VP_STR_RUTA_RESPALDOS			= 'R:\TTi_SQL_Backup\D0M4_bak\'		-- SERVER PERF / BRUNO
--	SET @VP_STR_RUTA_RESPALDOS			= 'D:\SQL_ServerDBs\D0M4_bak\'		-- DESARROLLO / HGF
	SET @VP_STR_DISPOSITIVO				= 'RESPALDO_' + @VP_STR_NOMBRE_BD + '_' + @VP_STR_FECHA_HOY_YYYYMMDD_HHMM  
	SET @VP_STR_RUTA_Y_DISPOSITIVO		= @VP_STR_RUTA_RESPALDOS + @VP_STR_DISPOSITIVO + '.bak'

	-- ====================================
/*
	EXECUTE	[dbo].[PG_IN_BITACORA_SYS_BASICO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO,												
									--			K_CLASE, K_IMPORTANCIA, K_GRUPO
												5, 6, 1,		-- #5-BD/SQL | #6-CRITICA | #1-BACKUP
												'EXEC sp_addumpdevice', @VP_STR_RUTA_Y_DISPOSITIVO,
												'PG_PR_SISTEMAXYZ_SQL_BACKUP', 0, 0
*/
	-- ====================================
	-- CREA DISPOSITIVO/ARCHIVO DE RESPALDO 
	-- USE master
	EXEC sp_addumpdevice 
		@devtype = 'disk', 
		@logicalname = @VP_STR_DISPOSITIVO, 
		@physicalname = @VP_STR_RUTA_Y_DISPOSITIVO

	-- ====================================
/*
	EXECUTE	[dbo].[PG_IN_BITACORA_SYS_BASICO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO,												
									--			K_CLASE, K_IMPORTANCIA, K_GRUPO
												5, 6, 1,		-- #5-BD/SQL | #6-CRITICA | #1-BACKUP
												'BACKUP DATABASE', @VP_STR_NOMBRE_BD,
												'PG_PR_SISTEMAXYZ_SQL_BACKUP', 0, 0
*/
	-- ====================================
	-- RESPALDA BASE DE DATOS 
	BACKUP 
		DATABASE @VP_STR_NOMBRE_BD
		TO 	@VP_STR_DISPOSITIVO
		WITH 	INIT ,
			NAME = 'D0M4 Respaldo/FLASH ',
			DESCRIPTION = 'D0M4 -> [PG_BD_SISTEMA_D0M4_SQL_BACKUP]'
	
	-- ====================================

	-- ///////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_BD_MASTER_SQL_BACKUP] 0, 0, 0


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_BD_MASTER_SQL_BACKUP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_BD_MASTER_SQL_BACKUP]
GO


CREATE PROCEDURE [dbo].[PG_BD_MASTER_SQL_BACKUP]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_USUARIO				[INT] 
AS
				  
	EXECUTE [dbo].[PG_BD_SISTEMA_D0M4_SQL_BACKUP]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, 
														@PP_K_USUARIO 
	-- ===========================================

GO




-- EXECUTE [dbo].[PG_BD_MASTER_SQL_BACKUP] 0, 0, 0


-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
