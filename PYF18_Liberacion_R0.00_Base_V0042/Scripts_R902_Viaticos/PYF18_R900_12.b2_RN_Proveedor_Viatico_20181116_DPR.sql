-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			RN_Proveedor_Viatico_20181116_DPR.sql
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			CONTROL DE VIAJES - PROVEEDOR_VIATICO
-- // OPERACIÓN:		LIBERACIÓN / REGLAS DE NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // Autor:			Daniel Portillo Romero
-- // Fecha creación:	16/NOV/2018
-- //////////////////////////////////////////////////////////////  

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_UNIQUE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_VIATICO_UNIQUE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_VIATICO_UNIQUE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_VIATICO_UNIQUE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR_VIATICO				[INT],	
	@PP_D_PROVEEDOR_VIATICO				[VARCHAR] (100),
	@PP_RFC_PROVEEDOR_VIATICO			[VARCHAR] (100),
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
	
		DECLARE @VP_N_PROVEEDOR_VIATICO_X_D_PROVEEDOR_VIATICO		INT
		
		SELECT	@VP_N_PROVEEDOR_VIATICO_X_D_PROVEEDOR_VIATICO =		COUNT	(PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO)
																	FROM	PROVEEDOR_VIATICO
																	WHERE	PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO<>@PP_K_PROVEEDOR_VIATICO
																	AND		PROVEEDOR_VIATICO.D_PROVEEDOR_VIATICO=@PP_D_PROVEEDOR_VIATICO										
		-- =============================

		IF @VP_RESULTADO=''
			IF @VP_N_PROVEEDOR_VIATICO_X_D_PROVEEDOR_VIATICO>0
				SET @VP_RESULTADO =  'Ya existen [Proveedores de Viáticos] con esa Descripción ['+@PP_D_PROVEEDOR_VIATICO+'].' 
		END	
		
	-- ///////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		BEGIN
	
		DECLARE @VP_N_PROVEEDOR_VIATICO_X_RFC_PROVEEDOR_VIATICO		INT = 0

		IF @PP_RFC_PROVEEDOR_VIATICO=''			-- SOLAMENTE APLICA LA VALIDACIÓN CUANDO EL RFC_PROVEEDOR_VIATICO NO VIENE VACÍO 
			SET		@VP_N_PROVEEDOR_VIATICO_X_RFC_PROVEEDOR_VIATICO =		0
		ELSE
			SELECT	@VP_N_PROVEEDOR_VIATICO_X_RFC_PROVEEDOR_VIATICO =		COUNT	(PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO)
																			FROM	PROVEEDOR_VIATICO
																			WHERE	PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO<>@PP_K_PROVEEDOR_VIATICO
																			AND		PROVEEDOR_VIATICO.RFC_PROVEEDOR_VIATICO=@PP_RFC_PROVEEDOR_VIATICO	
																			AND		@PP_RFC_PROVEEDOR_VIATICO<>''				
		-- =============================

		IF @VP_RESULTADO=''
			IF @VP_N_PROVEEDOR_VIATICO_X_RFC_PROVEEDOR_VIATICO>0
				SET @VP_RESULTADO =  'Ya existen [Proveedores de Viáticos] con ese RFC_PROVEEDOR_VIATICO ['+@PP_RFC_PROVEEDOR_VIATICO+'].' 
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_VIATICO_ES_BORRABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_VIATICO_ES_BORRABLE]
GO

CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_VIATICO_ES_BORRABLE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR_VIATICO				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
-- /////////////////////////////////////////////////////

	DECLARE @VP_N_FACTURA_X_PROVEEDOR_VIATICO		INT = 0
/*
	-- ADR: FALTA AGREGAR EL CODIGO QUE VALIDE ESTE CASO.
	SELECT	@VP_N_FACTURA_X_PROVEEDOR_VIATICO =		COUNT	(PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO)
													FROM	PROVEEDOR_VIATICO,FACTURA
													WHERE	PLANTA.K_PROVEEDOR_VIATICO=PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO	
													AND		PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO=@PP_K_PROVEEDOR_VIATICO										
*/
	-- =============================

	IF @VP_RESULTADO=''
		IF @VP_N_FACTURA_X_PROVEEDOR_VIATICO>0
			SET @VP_RESULTADO =  'Existen [Facturas de Viáticos] asociadas.' 
		
	-- /////////////////////////////////////////////////////

	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EXISTE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_VIATICO_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_VIATICO_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_VIATICO_EXISTE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR_VIATICO				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION			[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO				VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_PROVEEDOR_VIATICO		INT
	DECLARE @VP_L_BORRADO				INT
		
	SELECT	@VP_K_PROVEEDOR_VIATICO =	PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO,
			@VP_L_BORRADO	=			PROVEEDOR_VIATICO.L_BORRADO
										FROM	PROVEEDOR_VIATICO
										WHERE	PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO=@PP_K_PROVEEDOR_VIATICO										
	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_PROVEEDOR_VIATICO IS NULL )
			SET @VP_RESULTADO =  'El [PROVEEDOR_VIATICO] no existe.' 
	
	-- ===========================

	IF @VP_RESULTADO=''
		IF @VP_L_BORRADO=1
			SET @VP_RESULTADO =  'El [PROVEEDOR_VIATICO] fue dado de baja.' 
					
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_VIATICO_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_VIATICO_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_VIATICO_DELETE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR_VIATICO				[INT],	
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
		EXECUTE [dbo].[PG_RN_PROVEEDOR_VIATICO_EXISTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PROVEEDOR_VIATICO,	 
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PROVEEDOR_VIATICO_ES_BORRABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_PROVEEDOR_VIATICO,	 
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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_VIATICO_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_VIATICO_INSERT]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_VIATICO_INSERT]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR_VIATICO				[INT],	
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
		EXECUTE [dbo].[PG_RN_PROVEEDOR_VIATICO_EXISTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PROVEEDOR_VIATICO,	 
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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PROVEEDOR_VIATICO_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PROVEEDOR_VIATICO_UPDATE]
GO


CREATE PROCEDURE [dbo].[PG_RN_PROVEEDOR_VIATICO_UPDATE]
	@PP_L_DEBUG							[INT],
	@PP_K_SISTEMA_EXE					[INT],
	@PP_K_USUARIO_ACCION				[INT],
	-- ===========================		
	@PP_K_PROVEEDOR_VIATICO				[INT],	
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
		EXECUTE [dbo].[PG_RN_PROVEEDOR_VIATICO_EXISTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PROVEEDOR_VIATICO,	 
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
