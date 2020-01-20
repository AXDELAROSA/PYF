-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PROVEEDOR / CXP
-- // OPERACION:		LIBERACION / REGLAS DE NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // Autor:			Alex de la Rosa
-- // Fecha creación:	24/SEP/2018
-- //////////////////////////////////////////////////////////////  

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_UNIQUE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_UNIQUE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_UNIQUE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_UNIQUE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR						[INT],	
	@PP_D_PROVEEDOR						[VARCHAR] (100),
	@PP_RFC_PROVEEDOR					[VARCHAR] (100),
		-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		BEGIN
	
		DECLARE @VP_N_PROVEEDOR_X_D_PROVEEDOR		INT
		
		SELECT	@VP_N_PROVEEDOR_X_D_PROVEEDOR =		COUNT	(PROVEEDOR.K_PROVEEDOR)
													FROM	PROVEEDOR
													WHERE	PROVEEDOR.K_PROVEEDOR<>@PP_K_PROVEEDOR
													AND		PROVEEDOR.D_PROVEEDOR=@PP_D_PROVEEDOR										
		-- =============================

		IF @VP_RESULTADO=''
			IF @VP_N_PROVEEDOR_X_D_PROVEEDOR>0
				SET @VP_RESULTADO =  'Ya existen [Proveedores] con esa Descripción ['+@PP_D_PROVEEDOR+'].' 
		END	
		
	-- ///////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		BEGIN
	
		DECLARE @VP_N_PROVEEDOR_X_RFC_PROVEEDOR		INT = 0

		IF @PP_RFC_PROVEEDOR=''			-- SOLAMENTE APLICA LA VALIDACION CUANDO EL RFC_PROVEEDOR NO VIENE VACIO 
			SET		@VP_N_PROVEEDOR_X_RFC_PROVEEDOR =		0
		ELSE
			SELECT	@VP_N_PROVEEDOR_X_RFC_PROVEEDOR =		COUNT	(PROVEEDOR.K_PROVEEDOR)
												FROM	PROVEEDOR
												WHERE	PROVEEDOR.K_PROVEEDOR<>@PP_K_PROVEEDOR
												AND		PROVEEDOR.RFC_PROVEEDOR=@PP_RFC_PROVEEDOR	
												AND		@PP_RFC_PROVEEDOR<>''				
		-- =============================

		IF @VP_RESULTADO=''
			IF @VP_N_PROVEEDOR_X_RFC_PROVEEDOR>0
				SET @VP_RESULTADO =  'Ya existen [Proveedores] con ese RFC_PROVEEDOR ['+@PP_RFC_PROVEEDOR+'].' 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_ES_BORRABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_ES_BORRABLE]
GO

CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_ES_BORRABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
-- /////////////////////////////////////////////////////

	DECLARE @VP_N_FACTURA_X_PROVEEDOR		INT = 0
/*
	-- ADR: FALTA AGREGAR EL CODIGO QUE VALIDE ESTE CASO.
	SELECT	@VP_N_FACTURA_X_PROVEEDOR =		COUNT	(PROVEEDOR.K_PROVEEDOR)
											FROM	PROVEEDOR,FACTURA
											WHERE	PLANTA.K_PROVEEDOR=PROVEEDOR.K_PROVEEDOR	
											AND		PROVEEDOR.K_PROVEEDOR=@PP_K_PROVEEDOR										
*/
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_N_FACTURA_X_PROVEEDOR>0
			SET @VP_RESULTADO =  'Existen [FACTURAS] asignadas.' 
		
	-- /////////////////////////////////////////////////////

	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EXISTE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_EXISTE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_PROVEEDOR			INT
	DECLARE @VP_L_BORRADO			INT
		
	SELECT	@VP_K_PROVEEDOR =		PROVEEDOR.K_PROVEEDOR,
			@VP_L_BORRADO	=		PROVEEDOR.L_BORRADO
									FROM	PROVEEDOR
									WHERE	PROVEEDOR.K_PROVEEDOR=@PP_K_PROVEEDOR										
	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_PROVEEDOR IS NULL )
			SET @VP_RESULTADO =  'El [Proveedor] no existe.' 
	
	-- ===========================

	IF @VP_RESULTADO=''
		IF @VP_L_BORRADO=1
			SET @VP_RESULTADO =  'El [Proveedor] fue dado de baja.' 
					
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_DELETE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR						[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														1, -- @PP_K_DATA_SISTEMA,	
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_EXISTE]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PROVEEDOR,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_ES_BORRABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PROVEEDOR,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //DEL//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_INSERT]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_INSERT]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR						[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////
	
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_EXISTE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_PROVEEDOR,	 
												@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	-- ///////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //INS//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_UPDATE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_UPDATE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_UPDATE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR						[INT],	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_EXISTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_PROVEEDOR,	 
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
