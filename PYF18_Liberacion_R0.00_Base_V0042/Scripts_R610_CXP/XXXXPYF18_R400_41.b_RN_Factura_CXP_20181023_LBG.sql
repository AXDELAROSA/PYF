-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			FACTURA_CXP
-- // OPERACION:		LIBERACION / REGLAS NEGOCIO
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			Alex de la Rosa
-- // Fecha creación:	15/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EXISTE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_EXISTE]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_FACTURA_CXP			INT
	DECLARE @VP_L_BORRADO			INT
		
	SELECT	@VP_K_FACTURA_CXP =		FACTURA_CXP.K_FACTURA_CXP,
			@VP_L_BORRADO	  =		FACTURA_CXP.L_BORRADO
									FROM	FACTURA_CXP
									WHERE	FACTURA_CXP.K_FACTURA_CXP=@PP_K_FACTURA_CXP										

	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_FACTURA_CXP IS NULL )
			SET @VP_RESULTADO =  'La [FACTURA_CXP] no existe.' 
	
	-- ===========================

	IF @VP_RESULTADO=''
		IF @VP_L_BORRADO=1
			SET @VP_RESULTADO =  'La [FACTURA_CXP] fue dada de baja.' 
					
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CLAVE_EXISTE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_CLAVE_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_CLAVE_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_CLAVE_EXISTE]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_USUARIO_ACCION		[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP			[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO='' 
		BEGIN
			
			DECLARE @VP_EXISTE_CLAVE		INT
			
			SELECT @VP_EXISTE_CLAVE =	COUNT	(K_FACTURA_CXP )
										FROM	FACTURA_CXP  
										WHERE	K_FACTURA_CXP <>@PP_K_FACTURA_CXP

			IF @VP_EXISTE_CLAVE > 0
				SET	@VP_RESULTADO = @VP_RESULTADO +CHAR(13)+CHAR(10) + 'La descripción ya existe'
		END	
		
	-- ///////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //DESC//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO

/* En espera de verificación de Código con HGF, se tenían dudas sobre como validar
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_UNIQUE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_UNIQUE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_UNIQUE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_UNIQUE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================			
	@PP_K_FACTURA_CXP					[INT],	
	@PP_SERIE							[VARCHAR] (100),
	@PP_FOLIO							[VARCHAR] (100),
		-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		BEGIN
	
		DECLARE @VP_N_FACTURA_CXP_X_SERIE			INT = 0

		IF @PP_SERIE=''			-- SOLAMENTE APLICA LA VALIDACION CUANDO LA SERIE NO VIENE VACIA 
			SET		@VP_N_FACTURA_CXP_X_SERIE =		0
		ELSE
			SELECT	@VP_N_FACTURA_CXP_X_SERIE =		COUNT	(FACTURA_CXP.K_FACTURA_CXP)
													FROM	FACTURA_CXP
													WHERE	FACTURA_CXP.K_FACTURA_CXP<>@PP_K_FACTURA_CXP
													AND		FACTURA_CXP.SERIE=@PP_SERIE
													AND		@PP_SERIE<>''
		-- =============================

		IF @VP_RESULTADO=''
			IF @VP_N_FACTURA_CXP_X_SERIE>0
				SET @VP_RESULTADO =  'Ya existen [Facturas] con esa [Serie] Asignada ['+@PP_SERIE+'].' 
		END	
		
	-- ///////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		BEGIN
	
		DECLARE @VP_N_FACTURA_CXP_X_FOLIO		INT = 0

		IF @PP_FOLIO=''			-- SOLAMENTE APLICA LA VALIDACION CUANDO EL FOLIO NO VIENE VACIO 
			SET		@VP_N_FACTURA_CXP_X_FOLIO =		0
		ELSE
			SELECT	@VP_N_FACTURA_CXP_X_FOLIO =		COUNT	(FACTURA_CXP.K_FACTURA_CXP)
													FROM	FACTURA_CXP
													WHERE	FACTURA_CXP.K_FACTURA_CXP<>@PP_K_FACTURA_CXP
													AND		FACTURA_CXP.FOLIO=@PP_FOLIO
													AND		@PP_FOLIO<>''				
		-- =============================

		IF @VP_RESULTADO=''
			IF @VP_N_FACTURA_CXP_X_FOLIO>0
				SET @VP_RESULTADO =  'Ya existen [Facturas] con ese [Folio] ['+@PP_FOLIO+'].' 
		END	
		
	-- ///////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //UNI//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO
*/

-- ===========================================================================================
-- ===========================================================================================
-- == REGLAS DE NEGOCIO BASICAS (DELETE / INSERT / UPDATE)
-- ===========================================================================================
-- ===========================================================================================


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_DELETE]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP				[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_EXISTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_FACTURA_CXP,	 
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////




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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_INSERT]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_INSERT]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP				[INT],	
	@PP_SERIE						[VARCHAR] (100),
	@PP_FOLIO						[VARCHAR] (100),		
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	-- ///////////////////////////////////////////
	/* ADR En espera de verificación con HGF
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_UNIQUE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_FACTURA_CXP, @PP_SERIE,@PP_FOLIO,	 
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
-- // STORED PROCEDURE ---> VALIDACION UPDATE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FACTURA_CXP_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FACTURA_CXP_UPDATE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FACTURA_CXP_UPDATE]
	@PP_L_DEBUG					[INT],
	@PP_K_SISTEMA_EXE			[INT],
	@PP_K_USUARIO_ACCION		[INT],
	-- ===========================		
	@PP_K_FACTURA_CXP			[INT],	
	@PP_SERIE					[VARCHAR] (100),
	@PP_FOLIO					[VARCHAR] (100),	
	-- ===========================		
	@OU_RESULTADO_VALIDACION	[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_EXISTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_FACTURA_CXP,	 
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////
	/* ADR En espera de verificación con HGF
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_UNIQUE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_FACTURA_CXP, @PP_SERIE,@PP_FOLIO,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
														*/
	-- ///////////////////////////////////////////

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
