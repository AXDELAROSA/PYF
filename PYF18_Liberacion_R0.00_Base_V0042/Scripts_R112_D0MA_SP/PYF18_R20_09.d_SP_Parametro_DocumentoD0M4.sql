-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION // STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////

--//////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PARAMETRO_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PARAMETRO_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_LI_PARAMETRO_DOCUMENTO_D0M4]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================	
	@PP_D_DOCUMENTO_D0M4			VARCHAR(200),
	@PP_K_ZONA_UO					INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_YYYY						INT,
	@PP_K_MM						INT
	-- ===========================
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1

	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
		
		DECLARE @VP_INT_NUMERO_REGISTROS	INT
	
		EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																			@VP_L_APLICAR_MAX_ROWS,		
																			@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
		-- =========================================		

		DECLARE @VP_K_FOLIO		INT

		EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_D_DOCUMENTO_D0M4, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
		-- =========================================

		IF @VP_MENSAJE<>''
			SET   @VP_INT_NUMERO_REGISTROS=0
	
		SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
				DOCUMENTO_D0M4.K_DOCUMENTO_D0M4, DOCUMENTO_D0M4.D_DOCUMENTO_D0M4, 
				DOCUMENTO_D0M4.K_YYYY, DOCUMENTO_D0M4.K_MM, 
				PARAMETRO_DOCUMENTO_D0M4.*,
				PARAMETRO_DOCUMENTO_D0M4.DESCUENTO_CONTADO*100 AS DESCUENTO_CONTADO_0_100,
				PARAMETRO_DOCUMENTO_D0M4.DESCUENTO_CREDITO*100 AS DESCUENTO_CREDITO_0_100,
				PARAMETRO_DOCUMENTO_D0M4.COBRANZA_HOLGURA*100 AS COBRANZA_HOLGURA_0_100,
				VI_UNIDAD_OPERATIVA_CATALOGOS.*,
				USUARIO.D_USUARIO AS 'D_USUARIO_CAMBIO'
		FROM	DOCUMENTO_D0M4 --,USUARIO,UNIDAD_OPERATIVA,MES,ZONA_UO
		JOIN	PARAMETRO_DOCUMENTO_D0M4 ON PARAMETRO_DOCUMENTO_D0M4.K_DOCUMENTO_D0M4 = DOCUMENTO_D0M4.K_DOCUMENTO_D0M4
		JOIN	VI_UNIDAD_OPERATIVA_CATALOGOS ON VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA = DOCUMENTO_D0M4.K_UNIDAD_OPERATIVA
		JOIN	USUARIO	ON USUARIO.K_USUARIO = PARAMETRO_DOCUMENTO_D0M4.K_USUARIO_CAMBIO
		
		WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=PARAMETRO_DOCUMENTO_D0M4.K_DOCUMENTO_D0M4
		AND		PARAMETRO_DOCUMENTO_D0M4.L_BORRADO=0
		AND		(	DOCUMENTO_D0M4.D_DOCUMENTO_D0M4	LIKE '%'+@PP_D_DOCUMENTO_D0M4+'%' 
				OR	PARAMETRO_DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@VP_K_FOLIO	)	
		AND		(   @PP_K_UNIDAD_OPERATIVA  		=   -1 	OR  DOCUMENTO_D0M4.K_UNIDAD_OPERATIVA   			=   @PP_K_UNIDAD_OPERATIVA)
		AND		(   @PP_K_YYYY              		=   -1 	OR  DOCUMENTO_D0M4.K_YYYY               			=   @PP_K_YYYY)
		AND		(   @PP_K_MM                		=   -1 	OR  DOCUMENTO_D0M4.K_MM                 			=   @PP_K_MM)
		AND		(   @PP_K_ZONA_UO           		=   -1 	OR  VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_ZONA_UO		=   @PP_K_ZONA_UO )
		
		ORDER BY O_DOCUMENTO_D0M4
	
	-- ////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_PARAMETRO_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_PARAMETRO_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_SK_PARAMETRO_DOCUMENTO_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		SELECT	PARAMETRO_DOCUMENTO_D0M4.*
		FROM	PARAMETRO_DOCUMENTO_D0M4
		WHERE	PARAMETRO_DOCUMENTO_D0M4.L_BORRADO=0
		AND		PARAMETRO_DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		
		END
	ELSE
		BEGIN	-- RESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

		SELECT	PARAMETRO_DOCUMENTO_D0M4.*
		FROM	PARAMETRO_DOCUMENTO_D0M4
		WHERE	PARAMETRO_DOCUMENTO_D0M4.K_DOCUMENTO_D0M4<0

		END

	-- ////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> ACTUALIZAR / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APG_UP_PARAMETRO_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[APG_UP_PARAMETRO_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[APG_UP_PARAMETRO_DOCUMENTO_D0M4]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4					INT,
	@PP_P2016_DTO_DESCUENTO_X_KG			DECIMAL(19, 4),
	@PP_DESCUENTO_CONTADO					DECIMAL(19, 4),
	@PP_DESCUENTO_CREDITO					DECIMAL(19, 4),
	@PP_P2023_PCN							DECIMAL(19, 4),
	@PP_P1003_VENTA_KG_CONTADO				DECIMAL(19, 4),
	@PP_P1004_VENTA_KG_CREDITO				DECIMAL(19, 4),
	@PP_P1012_CARTERA_CYC_INICIAL			DECIMAL(19, 4),
	@PP_P1013_CARTERA_CYC_FINAL				DECIMAL(19, 4),
	@PP_COBRANZA_HOLGURA					DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CONTADO_1_LUNES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CONTADO_2_MARTES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CONTADO_3_MIERCOLES	DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CONTADO_4_JUEVES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CONTADO_5_VIERNES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CONTADO_6_SABADO		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CONTADO_7_DOMINGO		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CREDITO_1_LUNES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CREDITO_2_MARTES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CREDITO_3_MIERCOLES	DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CREDITO_4_JUEVES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CREDITO_5_VIERNES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CREDITO_6_SABADO		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CREDITO_7_DOMINGO		DECIMAL(19, 4),
	@PP_PERFIL_COBRANZA_1_LUNES				DECIMAL(19, 4),
	@PP_PERFIL_COBRANZA_2_MARTES			DECIMAL(19, 4),
	@PP_PERFIL_COBRANZA_3_MIERCOLES			DECIMAL(19, 4),
	@PP_PERFIL_COBRANZA_4_JUEVES			DECIMAL(19, 4),
	@PP_PERFIL_COBRANZA_5_VIERNES			DECIMAL(19, 4),
	@PP_PERFIL_COBRANZA_6_SABADO			DECIMAL(19, 4),
	@PP_PERFIL_COBRANZA_7_DOMINGO			DECIMAL(19, 4)
	-- ===========================		
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
		
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		BEGIN
		UPDATE	PARAMETRO_DOCUMENTO_D0M4
		SET		
				[P2016_DTO_DESCUENTO_X_KG]			=	@PP_P2016_DTO_DESCUENTO_X_KG,		
				[DESCUENTO_CONTADO]					=	@PP_DESCUENTO_CONTADO,				
				[DESCUENTO_CREDITO]					=	@PP_DESCUENTO_CREDITO,				
				[P2023_PCN]							=	@PP_P2023_PCN,						
				[P1003_VENTA_KG_CONTADO]			=	@PP_P1003_VENTA_KG_CONTADO,			
				[P1004_VENTA_KG_CREDITO]			=	@PP_P1004_VENTA_KG_CREDITO,			
				[P1012_CARTERA_CYC_INICIAL]			=	@PP_P1012_CARTERA_CYC_INICIAL,		
				[P1013_CARTERA_CYC_FINAL]			=	@PP_P1013_CARTERA_CYC_FINAL,		
				[COBRANZA_HOLGURA]					=	@PP_COBRANZA_HOLGURA,				
				[PERFIL_VENTA_CONTADO_1_LUNES]		=	@PP_PERFIL_VENTA_CONTADO_1_LUNES,	
				[PERFIL_VENTA_CONTADO_2_MARTES]		=	@PP_PERFIL_VENTA_CONTADO_2_MARTES,	
				[PERFIL_VENTA_CONTADO_3_MIERCOLES]	=	@PP_PERFIL_VENTA_CONTADO_3_MIERCOLES,
				[PERFIL_VENTA_CONTADO_4_JUEVES]		=	@PP_PERFIL_VENTA_CONTADO_4_JUEVES,	
				[PERFIL_VENTA_CONTADO_5_VIERNES]	=	@PP_PERFIL_VENTA_CONTADO_5_VIERNES,	
				[PERFIL_VENTA_CONTADO_6_SABADO]		=	@PP_PERFIL_VENTA_CONTADO_6_SABADO,	
				[PERFIL_VENTA_CONTADO_7_DOMINGO]	=	@PP_PERFIL_VENTA_CONTADO_7_DOMINGO,	
				[PERFIL_VENTA_CREDITO_1_LUNES]		=	@PP_PERFIL_VENTA_CREDITO_1_LUNES,	
				[PERFIL_VENTA_CREDITO_2_MARTES]		=	@PP_PERFIL_VENTA_CREDITO_2_MARTES,	
				[PERFIL_VENTA_CREDITO_3_MIERCOLES]	=	@PP_PERFIL_VENTA_CREDITO_3_MIERCOLES,
				[PERFIL_VENTA_CREDITO_4_JUEVES]		=	@PP_PERFIL_VENTA_CREDITO_4_JUEVES,	
				[PERFIL_VENTA_CREDITO_5_VIERNES]	=	@PP_PERFIL_VENTA_CREDITO_5_VIERNES,	
				[PERFIL_VENTA_CREDITO_6_SABADO]		=	@PP_PERFIL_VENTA_CREDITO_6_SABADO,	
				[PERFIL_VENTA_CREDITO_7_DOMINGO]	=	@PP_PERFIL_VENTA_CREDITO_7_DOMINGO,	
				[PERFIL_COBRANZA_1_LUNES]			=	@PP_PERFIL_COBRANZA_1_LUNES,		
				[PERFIL_COBRANZA_2_MARTES]			=	@PP_PERFIL_COBRANZA_2_MARTES,		
				[PERFIL_COBRANZA_3_MIERCOLES]		=	@PP_PERFIL_COBRANZA_3_MIERCOLES,		
				[PERFIL_COBRANZA_4_JUEVES]			=	@PP_PERFIL_COBRANZA_4_JUEVES,		
				[PERFIL_COBRANZA_5_VIERNES]			=	@PP_PERFIL_COBRANZA_5_VIERNES,		
				[PERFIL_COBRANZA_6_SABADO]			=	@PP_PERFIL_COBRANZA_6_SABADO,		
				[PERFIL_COBRANZA_7_DOMINGO]			=	@PP_PERFIL_COBRANZA_7_DOMINGO,
				[L_BORRADO]							=	0,
                -- ===========================

				-- ====================
				[F_CAMBIO]			=	GETDATE(), 
				[K_USUARIO_CAMBIO]	=	@PP_K_USUARIO_ACCION
		WHERE	PARAMETRO_DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		
	/*	
		-- WIWI /// HGF/20181101 /// AGREGAN ESTO PARA REPROCESAR MAS FACIL :(

		EXECUTE [dbo].[PG_IN_DATA_N1_X_DI_D0M4_X_K_DOCUMENTO_D0M4] @PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4
		EXECUTE [dbo].[PG_OP_DOCUMENTO_DOM4_RECALCULAR] @PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4
		*/

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [PARAMETRO_DOCUMENTO_D0M4]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@PP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO


	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////P

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APG_IN_PARAMETRO_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[APG_IN_PARAMETRO_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[APG_IN_PARAMETRO_DOCUMENTO_D0M4]
	@PP_L_DEBUG					    INT,
	@PP_K_SISTEMA_EXE			    INT,
	@PP_K_USUARIO_ACCION		    INT,
	-- ===========================		
	@PP_K_DOCUMENTO_D0M4					INT,
	@PP_P2016_DTO_DESCUENTO_X_KG			DECIMAL(19, 4),
	@PP_DESCUENTO_CONTADO					DECIMAL(19, 4),
	@PP_DESCUENTO_CREDITO					DECIMAL(19, 4),
	@PP_P2023_PCN							DECIMAL(19, 4),
	@PP_P1003_VENTA_KG_CONTADO				DECIMAL(19, 4),
	@PP_P1004_VENTA_KG_CREDITO				DECIMAL(19, 4),
	@PP_P1012_CARTERA_CYC_INICIAL			DECIMAL(19, 4),
	@PP_P1013_CARTERA_CYC_FINAL				DECIMAL(19, 4),
	@PP_COBRANZA_HOLGURA					DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CONTADO_1_LUNES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CONTADO_2_MARTES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CONTADO_3_MIERCOLES	DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CONTADO_4_JUEVES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CONTADO_5_VIERNES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CONTADO_6_SABADO		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CONTADO_7_DOMINGO		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CREDITO_1_LUNES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CREDITO_2_MARTES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CREDITO_3_MIERCOLES	DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CREDITO_4_JUEVES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CREDITO_5_VIERNES		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CREDITO_6_SABADO		DECIMAL(19, 4),
	@PP_PERFIL_VENTA_CREDITO_7_DOMINGO		DECIMAL(19, 4),
	@PP_PERFIL_COBRANZA_1_LUNES				DECIMAL(19, 4),
	@PP_PERFIL_COBRANZA_2_MARTES			DECIMAL(19, 4),
	@PP_PERFIL_COBRANZA_3_MIERCOLES			DECIMAL(19, 4),
	@PP_PERFIL_COBRANZA_4_JUEVES			DECIMAL(19, 4),
	@PP_PERFIL_COBRANZA_5_VIERNES			DECIMAL(19, 4),
	@PP_PERFIL_COBRANZA_6_SABADO			DECIMAL(19, 4),
	@PP_PERFIL_COBRANZA_7_DOMINGO			DECIMAL(19, 4)
	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PARAMETRO_DOCUMENTO_D0M4_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_DOCUMENTO_D0M4, 
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
			
		INSERT INTO PARAMETRO_DOCUMENTO_D0M4
			(	[K_DOCUMENTO_D0M4],[P2016_DTO_DESCUENTO_X_KG],
				[DESCUENTO_CONTADO],[DESCUENTO_CREDITO],[P2023_PCN],
				[P1003_VENTA_KG_CONTADO],[P1004_VENTA_KG_CREDITO],
				[P1012_CARTERA_CYC_INICIAL],[P1013_CARTERA_CYC_FINAL],
				[COBRANZA_HOLGURA],[PERFIL_VENTA_CONTADO_1_LUNES],
				[PERFIL_VENTA_CONTADO_2_MARTES],[PERFIL_VENTA_CONTADO_3_MIERCOLES],
				[PERFIL_VENTA_CONTADO_4_JUEVES],[PERFIL_VENTA_CONTADO_5_VIERNES],
				[PERFIL_VENTA_CONTADO_6_SABADO],[PERFIL_VENTA_CONTADO_7_DOMINGO],
				[PERFIL_VENTA_CREDITO_1_LUNES],[PERFIL_VENTA_CREDITO_2_MARTES],
				[PERFIL_VENTA_CREDITO_3_MIERCOLES],[PERFIL_VENTA_CREDITO_4_JUEVES],
				[PERFIL_VENTA_CREDITO_5_VIERNES],[PERFIL_VENTA_CREDITO_6_SABADO],
				[PERFIL_VENTA_CREDITO_7_DOMINGO],[PERFIL_COBRANZA_1_LUNES],
				[PERFIL_COBRANZA_2_MARTES],[PERFIL_COBRANZA_3_MIERCOLES],
				[PERFIL_COBRANZA_4_JUEVES],[PERFIL_COBRANZA_5_VIERNES],
				[PERFIL_COBRANZA_6_SABADO],[PERFIL_COBRANZA_7_DOMINGO],
				-- ===========================
				[K_USUARIO_ALTA],[F_ALTA],[K_USUARIO_CAMBIO],[F_CAMBIO],
				[L_BORRADO],[K_USUARIO_BAJA],[F_BAJA]  )
		VALUES	
			(	
				@PP_K_DOCUMENTO_D0M4,@PP_P2016_DTO_DESCUENTO_X_KG,
				@PP_DESCUENTO_CONTADO,@PP_DESCUENTO_CREDITO,@PP_P2023_PCN,
				@PP_P1003_VENTA_KG_CONTADO,@PP_P1004_VENTA_KG_CREDITO,
				@PP_P1012_CARTERA_CYC_INICIAL,@PP_P1013_CARTERA_CYC_FINAL,
				@PP_COBRANZA_HOLGURA,@PP_PERFIL_VENTA_CONTADO_1_LUNES,
				@PP_PERFIL_VENTA_CONTADO_2_MARTES,@PP_PERFIL_VENTA_CONTADO_3_MIERCOLES,
				@PP_PERFIL_VENTA_CONTADO_4_JUEVES,@PP_PERFIL_VENTA_CONTADO_5_VIERNES,
				@PP_PERFIL_VENTA_CONTADO_6_SABADO,@PP_PERFIL_VENTA_CONTADO_7_DOMINGO,
				@PP_PERFIL_VENTA_CREDITO_1_LUNES,@PP_PERFIL_VENTA_CREDITO_2_MARTES,
				@PP_PERFIL_VENTA_CREDITO_3_MIERCOLES,@PP_PERFIL_VENTA_CREDITO_4_JUEVES,
				@PP_PERFIL_VENTA_CREDITO_5_VIERNES,@PP_PERFIL_VENTA_CREDITO_6_SABADO,
				@PP_PERFIL_VENTA_CREDITO_7_DOMINGO,@PP_PERFIL_COBRANZA_1_LUNES,
				@PP_PERFIL_COBRANZA_2_MARTES,@PP_PERFIL_COBRANZA_3_MIERCOLES,
				@PP_PERFIL_COBRANZA_4_JUEVES,@PP_PERFIL_COBRANZA_5_VIERNES,
				@PP_PERFIL_COBRANZA_6_SABADO,@PP_PERFIL_COBRANZA_7_DOMINGO,
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )
		END
	IF @VP_MENSAJE = '1'		
		BEGIN		
			EXECUTE [dbo].[APG_UP_PARAMETRO_DOCUMENTO_D0M4]	
							@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION, 
							--================================================
							@PP_K_DOCUMENTO_D0M4,@PP_P2016_DTO_DESCUENTO_X_KG,
							@PP_DESCUENTO_CONTADO,@PP_DESCUENTO_CREDITO,
							@PP_P2023_PCN,@PP_P1003_VENTA_KG_CONTADO,
							@PP_P1004_VENTA_KG_CREDITO,@PP_P1012_CARTERA_CYC_INICIAL,
							@PP_P1013_CARTERA_CYC_FINAL,@PP_COBRANZA_HOLGURA,
							--================================================
							@PP_PERFIL_VENTA_CONTADO_1_LUNES,@PP_PERFIL_VENTA_CONTADO_2_MARTES,
							@PP_PERFIL_VENTA_CONTADO_3_MIERCOLES,@PP_PERFIL_VENTA_CONTADO_4_JUEVES,
							@PP_PERFIL_VENTA_CONTADO_5_VIERNES,@PP_PERFIL_VENTA_CONTADO_6_SABADO,
							@PP_PERFIL_VENTA_CONTADO_7_DOMINGO,
							--===============================================
							@PP_PERFIL_VENTA_CREDITO_1_LUNES,@PP_PERFIL_VENTA_CREDITO_2_MARTES,	
							@PP_PERFIL_VENTA_CREDITO_3_MIERCOLES,@PP_PERFIL_VENTA_CREDITO_4_JUEVES,	
							@PP_PERFIL_VENTA_CREDITO_5_VIERNES,@PP_PERFIL_VENTA_CREDITO_6_SABADO,	
							@PP_PERFIL_VENTA_CREDITO_7_DOMINGO,
							--==============================================
							@PP_PERFIL_COBRANZA_1_LUNES,@PP_PERFIL_COBRANZA_2_MARTES,
							@PP_PERFIL_COBRANZA_3_MIERCOLES,@PP_PERFIL_COBRANZA_4_JUEVES,
							@PP_PERFIL_COBRANZA_5_VIERNES,@PP_PERFIL_COBRANZA_6_SABADO,
							@PP_PERFIL_COBRANZA_7_DOMINGO				
							-- =============================================
			SET @VP_MENSAJE = ''
		END	
	
	-- /////////////////////////////////////////////////////////////////////
			
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [PARAMETRO_DOCUMENTO_D0M4]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@PP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE
		
		END
	ELSE
	DECLARE @VP_K_UNIDAD_OPERATIVA		INT
	DECLARE @VP_K_YYYY					INT
	DECLARE @VP_K_MM					INT

	SELECT	@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA,
			@VP_K_YYYY =				K_YYYY, 					
			@VP_K_MM =					K_MM
										FROM	DOCUMENTO_D0M4
										WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	-- ============================
	/* 
	-- WIWI /// HGF/20181101 /// AGREGAN ESTO PARA REPROCESAR MAS FACIL :(

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE
		EXECUTE [dbo].[PG_IN_DATA_N1_X_DI_D0M4_X_K_DOCUMENTO_D0M4] @PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4
		EXECUTE [dbo].[PG_OP_DOCUMENTO_DOM4_RECALCULAR]@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4
		EXECUTE [dbo].[PG_IN_DOCUMENTO_D0M4]@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, 10,103,@VP_K_UNIDAD_OPERATIVA,@VP_K_YYYY,@VP_K_MM

		DECLARE @VP_K_DOCUMENTO AS INT=0

		SELECT @VP_K_DOCUMENTO=(K_DOCUMENTO_D0M4) 
		FROM DOCUMENTO_D0M4 
		WHERE	DOCUMENTO_D0M4.F_ALTA=(SELECT MAX(F_ALTA) FROM DOCUMENTO_D0M4 WHERE K_USUARIO_ALTA=@PP_K_USUARIO_ACCION)  
		AND		DOCUMENTO_D0M4.K_FORMATO_D0M4=103
		EXECUTE [dbo].[PG_IN_DATA_N1_X_DI_D0M4_X_K_DOCUMENTO_D0M4] @PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,@VP_K_DOCUMENTO

		EXECUTE [dbo].[PG_OP_DOCUMENTO_DOM4_RECALCULAR]@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @VP_K_DOCUMENTO
			
	*/
	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_PARAMETRO_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_PARAMETRO_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_DL_PARAMETRO_DOCUMENTO_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PARAMETRO_DOCUMENTO_D0M4_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_DOCUMENTO_D0M4, 
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE	OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
	--	DELETE
	--	FROM	DOCUMENTO_D0M4
	--	WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

		UPDATE	PARAMETRO_DOCUMENTO_D0M4
		SET		
				[L_BORRADO]		 =	1,
				-- ====================
				[F_BAJA]		 	=	GETDATE(), 
				[K_USUARIO_BAJA] 	=	@PP_K_USUARIO_ACCION
		WHERE	K_DOCUMENTO_D0M4	=	@PP_K_DOCUMENTO_D0M4
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la [PARAMETRO_DOCUMENTO_D0M4]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@PP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE

	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
