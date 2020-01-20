-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			
-- // OPERACION:		LIBERACION / 
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO


-- //////////////////////////////////////////////////////////////
-- //  STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SQ_EXECUTE_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SQ_EXECUTE_SQL]
GO


CREATE PROCEDURE [dbo].[PG_SQ_EXECUTE_SQL]
	@PP_D_SERVIDOR		VARCHAR(100),
	@PP_SENTENCIA_SQL	VARCHAR(1000),
	@OU_EXITO			INT			OUTPUT
AS
	DECLARE @VP_RESULTADO	INT
	-- ===================================

	BEGIN TRY  
	
		EXECUTE ( @PP_SENTENCIA_SQL )
		SET @VP_RESULTADO = 1
	END TRY  
	
	-- ===================================

	BEGIN CATCH  

		SET @VP_RESULTADO	= 0
	END CATCH; 

	SET @OU_EXITO = @VP_RESULTADO
	-- ===================================
GO





-- //////////////////////////////////////////////////////////////
-- //  STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_sp_executesql]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_sp_executesql]
GO



CREATE PROCEDURE [dbo].[PG_sp_executesql]
	@PP_SENTENCIA_SQL		NVARCHAR(1000)
AS


	DECLARE @VP_MENSAJE		VARCHAR(200) = 'sp_executesql / EJECUTADO'

	BEGIN TRY  

		EXEC sp_executesql @PP_SENTENCIA_SQL;		
	
	END TRY  
	
	-- ===================================

	BEGIN CATCH  

		SET @VP_MENSAJE	= 'sp_executesql / ERROR: ' + ERROR_MESSAGE()
	
	END CATCH; 
GO


-- //////////////////////////////////////////////////////////////
-- //  STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_sp_executesql_bool]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_sp_executesql_bool]
GO



CREATE PROCEDURE [dbo].[PG_sp_executesql_bool]
	@PP_SENTENCIA_SQL		NVARCHAR(1000),
	@OU_EXITO			INT			OUTPUT

AS


	DECLARE @VP_MENSAJE		VARCHAR(200) = 'sp_executesql / EJECUTADO'

	BEGIN TRY  

		EXEC sp_executesql @PP_SENTENCIA_SQL;
		SET @OU_EXITO=1				
	
	END TRY  
	
	-- ===================================

	BEGIN CATCH  

		SET @VP_MENSAJE	= 'sp_executesql / ERROR: ' + ERROR_MESSAGE()
		SET @OU_EXITO=0
	
	END CATCH; 
GO





-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

