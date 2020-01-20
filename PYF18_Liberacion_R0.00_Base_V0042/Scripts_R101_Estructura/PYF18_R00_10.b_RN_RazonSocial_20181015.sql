-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			ORGANIZACION / RAZON_SOCIAL 
-- // OPERACION:		LIBERACION / REGLAS NEGOCIO
-- //////////////////////////////////////////////////////////////

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION UNIQUE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RAZON_SOCIAL_UNIQUE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_UNIQUE]
GO


CREATE PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_UNIQUE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL					[INT],	
	@PP_D_RAZON_SOCIAL					VARCHAR(100),
	@PP_RFC_RAZON_SOCIAL				VARCHAR(100),
		-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO='WIWI'
		BEGIN
	
		DECLARE @VP_N_EMPRESA_X_D_EMPRESA		INT
		
		SELECT	@VP_N_EMPRESA_X_D_EMPRESA =		COUNT(RAZON_SOCIAL.K_RAZON_SOCIAL)
												FROM	RAZON_SOCIAL
												WHERE	RAZON_SOCIAL.K_RAZON_SOCIAL<>@PP_K_RAZON_SOCIAL
												AND		RAZON_SOCIAL.D_RAZON_SOCIAL=@PP_D_RAZON_SOCIAL										
		-- =============================

		IF @VP_RESULTADO=''
			IF @VP_N_EMPRESA_X_D_EMPRESA>0
				SET @VP_RESULTADO =  'Ya existen [Razones Sociales] con esa [Descripción('+@PP_D_RAZON_SOCIAL+')].' 
		END	
		
	-- ///////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		BEGIN
	
		DECLARE @VP_N_EMPRESA_X_RFC			INT
		
		SELECT	@VP_N_EMPRESA_X_RFC =		COUNT(RAZON_SOCIAL.K_RAZON_SOCIAL)
											FROM	RAZON_SOCIAL
											WHERE	RAZON_SOCIAL.K_RAZON_SOCIAL<>@PP_K_RAZON_SOCIAL
											AND		RAZON_SOCIAL.RFC_RAZON_SOCIAL=@PP_RFC_RAZON_SOCIAL										
		-- =============================

		IF @VP_RESULTADO=''
			IF @VP_N_EMPRESA_X_RFC>0
				SET @VP_RESULTADO =  'Ya existen [Razones Sociales] con ese [RFC('+@PP_RFC_RAZON_SOCIAL+')].' 
		END	
		
	-- ///////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //UNI//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_BORRABLE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RAZON_SOCIAL_ES_BORRABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_ES_BORRABLE]
GO


CREATE PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_ES_BORRABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_N_UNIDAD_OPERATIVA_X_RAZON_SOCIAL	INT
		
	SELECT	@VP_N_UNIDAD_OPERATIVA_X_RAZON_SOCIAL =		COUNT(UNIDAD_OPERATIVA.K_RAZON_SOCIAL)
														FROM	RAZON_SOCIAL, UNIDAD_OPERATIVA
														WHERE	UNIDAD_OPERATIVA.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL	
														AND		RAZON_SOCIAL.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL										
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_N_UNIDAD_OPERATIVA_X_RAZON_SOCIAL>0
			SET @VP_RESULTADO =  'Existen [Sucursales] asignadas a esta Razón Social.' 
			
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_BORRABLE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RAZON_SOCIAL_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_EXISTE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_RAZON_SOCIAL		INT
	DECLARE @VP_L_BORRADO			INT
		
	SELECT	@VP_K_RAZON_SOCIAL =	RAZON_SOCIAL.K_RAZON_SOCIAL,
			@VP_L_BORRADO =			RAZON_SOCIAL.L_BORRADO
									FROM	RAZON_SOCIAL
									WHERE	RAZON_SOCIAL.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL										
--	SELECT	@VP_N_EMPRESA
	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_RAZON_SOCIAL IS NULL )
			SET @VP_RESULTADO =  'La [Razón Social] no existe.' 
	
	-- ===========================

	IF @VP_RESULTADO=''
		IF @VP_L_BORRADO=1
			SET @VP_RESULTADO =  'La [Razón Social] fue dada de baja.' 
					
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RAZON_SOCIAL_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_DELETE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														1, -- @PP_K_DATA_SISTEMA,	
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_RAZON_SOCIAL_EXISTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_RAZON_SOCIAL,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_RAZON_SOCIAL_ES_BORRABLE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_RAZON_SOCIAL,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //DEL//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RAZON_SOCIAL_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_INSERT]
GO


CREATE PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_INSERT]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////
/*	
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_EMPRESA_]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												@PP_K_EMPRESA,	 
												@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
*/
	-- ///////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //INS//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_RAZON_SOCIAL_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_UPDATE]
GO


CREATE PROCEDURE [dbo].[PG_RN_RAZON_SOCIAL_UPDATE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL					[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)
	
	SET		@VP_RESULTADO	= ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_RAZON_SOCIAL_EXISTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_RAZON_SOCIAL,	 
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //UPD//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
