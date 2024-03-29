-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / REGLAS NEGOCIO
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_BORRABLE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PERFORMANCE_N3_X_ME_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PERFORMANCE_N3_X_ME_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PERFORMANCE_N3_X_ME_EXISTE]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_USUARIO_ACCION		[INT],
	-- ===========================		
	@PP_K_YYYY	[INT],
    @PP_XLS_UO	[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_PERFORMANCE_N3_X_ME	INT
	DECLARE @VP_L_BORRADO				INT
		
	SELECT	@VP_K_PERFORMANCE_N3_X_ME	=	PERFORMANCE_N3_X_ME.K_YYYY, --WIWI
			@VP_L_BORRADO				=	PERFORMANCE_N3_X_ME.L_BORRADO
											FROM	PERFORMANCE_N3_X_ME
											WHERE	PERFORMANCE_N3_X_ME.K_YYYY=@PP_K_YYYY
											AND		PERFORMANCE_N3_X_ME.XLS_UO=@PP_XLS_UO										

	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_PERFORMANCE_N3_X_ME IS NULL )
			SET @VP_RESULTADO =  'El [PERFORMANCE_N3_X_ME] no existe.' 
	
	-- ===========================

	IF @VP_RESULTADO=''
		IF @VP_L_BORRADO=1
			SET @VP_RESULTADO =  'El [PERFORMANCE_N3_X_ME] fue dado de baja.' 
					
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
