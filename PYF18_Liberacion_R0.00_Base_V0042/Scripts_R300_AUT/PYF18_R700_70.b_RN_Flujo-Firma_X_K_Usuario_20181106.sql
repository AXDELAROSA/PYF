-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_R700_70.b_RN_Flujo-Firma_X_K_Usuario
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			FLUJO_FIRMA
-- // OPERACION:		LIBERACION / REGLAS DE NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // Autor:			ALEX DE LA ROSA
-- // Fecha creación:	06/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> EXISTE 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FLUJO_FIRMA_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FLUJO_FIRMA_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_FLUJO_FIRMA_EXISTE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================		
	@PP_K_FLUJO_FIRMA					INT,	
	-- ===========================		
	@OU_RESULTADO_VALIDACION			VARCHAR (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
-- /////////////////////////////////////////////////////

	DECLARE @VP_K_FLUJO_FIRMA		INT
	DECLARE @VP_L_BORRADO			INT

	SELECT	@VP_K_FLUJO_FIRMA			=	FLUJO_FIRMA.K_FLUJO_FIRMA,
			@VP_L_BORRADO				=	FLUJO_FIRMA.L_BORRADO
											FROM	FLUJO_FIRMA
											WHERE	FLUJO_FIRMA.L_BORRADO=0
											AND		FLUJO_FIRMA.K_FLUJO_FIRMA=@PP_K_FLUJO_FIRMA
	-- ==========================

	IF @VP_RESULTADO=''
		IF @VP_K_FLUJO_FIRMA IS NULL
			SET @VP_RESULTADO =  'No existe el [Flujo Firma].' 
			-- ===========================

	IF @VP_RESULTADO=''
		IF @VP_L_BORRADO=1
			SET @VP_RESULTADO =  'El [Flujo Firma] fue dado de baja.' 
					

	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VALIDACION UPDATE
-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FLUJO_FIRMA_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FLUJO_FIRMA_UPDATE] 
GO


CREATE PROCEDURE [dbo].[PG_RN_FLUJO_FIRMA_UPDATE]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================		
	@PP_K_FLUJO_FIRMA			INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION		VARCHAR (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''

	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
															8, -- @PP_K_DATA_SISTEMA,	
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT		
	-- ///////////////////////////////////////////
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_FLUJO_FIRMA_EXISTE]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
															@PP_K_FLUJO_FIRMA,
															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////	

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + '  //UPD//'

	-- ///////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- ///////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> VERIFICACION PENDIENTES
-- //////////////////////////////////////////////////////////////
-- [PG_RN_FLUJO_FIRMA_PENDIENTES_AUTORIZAR] 0,0,303


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_FLUJO_FIRMA_PENDIENTES_AUTORIZAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_FLUJO_FIRMA_PENDIENTES_AUTORIZAR]
GO


CREATE PROCEDURE [dbo].[PG_RN_FLUJO_FIRMA_PENDIENTES_AUTORIZAR]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT
	-- ===========================		
AS

	DECLARE @VP_BUSCAR							VARCHAR(100) = ''
	DECLARE @VP_K_MODO_AUTORIZACION				INT = -1
	DECLARE @VP_K_ESTATUS_FIRMA					INT = 1

	-- /////////////////////////////////////////////////////

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_FLUJO_FIRMA_PENDIENTES		INT
	SELECT	@VP_K_FLUJO_FIRMA_PENDIENTES		=
			COUNT(K_FLUJO_FIRMA)
			-- =========================================
	FROM	FLUJO_FIRMA
			-- =========================================
			LEFT JOIN AUTORIZACION_FIRMA ON FLUJO_FIRMA.K_AUTORIZACION_FIRMA=AUTORIZACION_FIRMA.K_AUTORIZACION_FIRMA
			-- =========================================
/*			LEFT JOIN ESTATUS_FIRMA AS ESTATUS_FIRMA_AUTORIZACION ON AUTORIZACION_FIRMA.K_ESTATUS_FIRMA=ESTATUS_FIRMA_AUTORIZACION.K_ESTATUS_FIRMA
			-- =========================================
			LEFT JOIN MODO_AUTORIZACION ON FLUJO_FIRMA.K_MODO_AUTORIZACION=MODO_AUTORIZACION.K_MODO_AUTORIZACION
			-- =========================================
			LEFT JOIN ESTATUS_FIRMA ON FLUJO_FIRMA.K_ESTATUS_FIRMA=ESTATUS_FIRMA.K_ESTATUS_FIRMA
			-- =========================================
			LEFT JOIN ROL_AUTORIZACION AS ROLA ON FLUJO_FIRMA.K_ROL_AUTORIZACION_A=ROLA.K_ROL_AUTORIZACION
			LEFT JOIN ROL_AUTORIZACION AS ROLB ON FLUJO_FIRMA.K_ROL_AUTORIZACION_B=ROLB.K_ROL_AUTORIZACION
			LEFT JOIN ROL_AUTORIZACION AS ROLC ON FLUJO_FIRMA.K_ROL_AUTORIZACION_C=ROLC.K_ROL_AUTORIZACION
			-- =========================================
			LEFT JOIN USUARIO AS USUARIO_FIRMAA ON FLUJO_FIRMA.K_USUARIO_FIRMA_A=USUARIO_FIRMAA.K_USUARIO
			LEFT JOIN USUARIO AS USUARIO_FIRMAB ON FLUJO_FIRMA.K_USUARIO_FIRMA_B=USUARIO_FIRMAB.K_USUARIO
			LEFT JOIN USUARIO AS USUARIO_FIRMAC ON FLUJO_FIRMA.K_USUARIO_FIRMA_C=USUARIO_FIRMAC.K_USUARIO
			-- =========================================
			LEFT JOIN ESTATUS_FIRMA AS ESTATUS_FIRMAA ON FLUJO_FIRMA.K_ESTATUS_FIRMA_A=ESTATUS_FIRMAA.K_ESTATUS_FIRMA
			LEFT JOIN ESTATUS_FIRMA AS ESTATUS_FIRMAB ON FLUJO_FIRMA.K_ESTATUS_FIRMA_B=ESTATUS_FIRMAB.K_ESTATUS_FIRMA
			LEFT JOIN ESTATUS_FIRMA AS ESTATUS_FIRMAC ON FLUJO_FIRMA.K_ESTATUS_FIRMA_C=ESTATUS_FIRMAC.K_ESTATUS_FIRMA
			LEFT JOIN USUARIO ON FLUJO_FIRMA.K_USUARIO_CAMBIO = USUARIO.K_USUARIO
*/
			-- =========================================
	WHERE	FLUJO_FIRMA.L_BORRADO=0
	AND		FLUJO_FIRMA.L_PROCESAR=1
			-- =========================================
			AND	(	@VP_K_MODO_AUTORIZACION=-1		OR	FLUJO_FIRMA.K_MODO_AUTORIZACION=@VP_K_MODO_AUTORIZACION )
			-- =========================================
			AND	(	@VP_K_ESTATUS_FIRMA=-1 		
					OR 	(	FLUJO_FIRMA.K_ESTATUS_FIRMA = @VP_K_ESTATUS_FIRMA
						AND	AUTORIZACION_FIRMA.K_ESTATUS_FIRMA= @VP_K_ESTATUS_FIRMA
						) 
					)
			AND	(	@VP_K_ESTATUS_FIRMA=-1
					OR
					(	FLUJO_FIRMA.K_ESTATUS_FIRMA_A=@VP_K_ESTATUS_FIRMA AND FLUJO_FIRMA.K_USUARIO_FIRMA_A=@PP_K_USUARIO_ACCION)
					OR
					(	FLUJO_FIRMA.K_ESTATUS_FIRMA_B=@VP_K_ESTATUS_FIRMA AND FLUJO_FIRMA.K_USUARIO_FIRMA_B=@PP_K_USUARIO_ACCION)
					OR
					(	FLUJO_FIRMA.K_ESTATUS_FIRMA_C=@VP_K_ESTATUS_FIRMA AND FLUJO_FIRMA.K_USUARIO_FIRMA_C=@PP_K_USUARIO_ACCION)
				)
			-- =========================================
			AND (		FLUJO_FIRMA.K_USUARIO_FIRMA_A=@PP_K_USUARIO_ACCION
					OR	FLUJO_FIRMA.K_USUARIO_FIRMA_B=@PP_K_USUARIO_ACCION
					OR	FLUJO_FIRMA.K_USUARIO_FIRMA_C=@PP_K_USUARIO_ACCION
				)

		IF @VP_K_FLUJO_FIRMA_PENDIENTES=0
			SET @VP_RESULTADO =  ''
		ELSE
			SET @VP_RESULTADO =  'Tiene [ ' +CONVERT(VARCHAR(10),@VP_K_FLUJO_FIRMA_PENDIENTES) + ' ] Firmas Pendientes por [Verificar]. '

		DECLARE @VP_CLAVE INT= 0
		
		SELECT @VP_RESULTADO AS MENSAJE, @VP_CLAVE AS CLAVE

		-- ///////////////////////////////////////////
GO




-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////