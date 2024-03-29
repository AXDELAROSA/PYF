-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			POV -> CEMEC -> FLUP
-- // OPERACION:		LIBERACION / STORED PROCEDURES
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_CEMEC_PARAMETROS_VARIACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_CEMEC_PARAMETROS_VARIACION]
GO


CREATE PROCEDURE [dbo].[PG_UP_CEMEC_PARAMETROS_VARIACION]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================	
	@PP_K_DOCUMENTO_D0M4					INT,
	-- ===========================	
	@PP_P2016_DTO_DESCUENTO_X_KG			DECIMAL (19,4),
	-- ===========================	
	@PP_DESCUENTO_CONTADO_0_100				DECIMAL (19,4),
	-- ===========================	
	@PP_P2023_PCN							DECIMAL (19,4),
	-- ===========================	
	@PP_VENTA_PORCENTAJE_CONTADO_0_100		DECIMAL (19,4),
	-- ===========================	
	@PP_DIV_VENTA_KG_TOTAL					DECIMAL (19,4),
	-- ===========================	
	@PP_P1012_CARTERA_CYC_INICIAL			DECIMAL (19,4),
	@PP_P1013_CARTERA_CYC_FINAL				DECIMAL (19,4),
	-- ===========================	
	@PP_COBRANZA_HOLGURA_0_100				DECIMAL (19,4),
	-- ===========================	
	@PP_PERFIL_VENTA_CONTADO_1_LUNES		DECIMAL (19,4),
	@PP_PERFIL_VENTA_CONTADO_2_MARTES		DECIMAL (19,4),
	@PP_PERFIL_VENTA_CONTADO_3_MIERCOLES	DECIMAL (19,4),
	@PP_PERFIL_VENTA_CONTADO_4_JUEVES		DECIMAL (19,4),
	@PP_PERFIL_VENTA_CONTADO_5_VIERNES		DECIMAL (19,4),
	@PP_PERFIL_VENTA_CONTADO_6_SABADO		DECIMAL (19,4),
	@PP_PERFIL_VENTA_CONTADO_7_DOMINGO		DECIMAL (19,4),
	-- ===========================	
	@PP_PERFIL_VENTA_CREDITO_1_LUNES		DECIMAL (19,4),
	@PP_PERFIL_VENTA_CREDITO_2_MARTES		DECIMAL (19,4),
	@PP_PERFIL_VENTA_CREDITO_3_MIERCOLES	DECIMAL (19,4),
	@PP_PERFIL_VENTA_CREDITO_4_JUEVES		DECIMAL (19,4),
	@PP_PERFIL_VENTA_CREDITO_5_VIERNES		DECIMAL (19,4),
	@PP_PERFIL_VENTA_CREDITO_6_SABADO		DECIMAL (19,4),
	@PP_PERFIL_VENTA_CREDITO_7_DOMINGO		DECIMAL (19,4),
	-- ===========================	
	@PP_PERFIL_COBRANZA_1_LUNES				DECIMAL (19,4),
	@PP_PERFIL_COBRANZA_2_MARTES			DECIMAL (19,4),
	@PP_PERFIL_COBRANZA_3_MIERCOLES			DECIMAL (19,4),
	@PP_PERFIL_COBRANZA_4_JUEVES			DECIMAL (19,4),
	@PP_PERFIL_COBRANZA_5_VIERNES			DECIMAL (19,4),
	@PP_PERFIL_COBRANZA_6_SABADO			DECIMAL (19,4),
	@PP_PERFIL_COBRANZA_7_DOMINGO			DECIMAL (19,4),
	-- ===========================	
	@PP_K_DIVISOR							INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		IF NOT ( @PP_K_DOCUMENTO_D0M4 IS NULL )
			BEGIN
			-- ================================================================
			--    Parametros para busqueda de documento FLUP pareja del CEMEC
			DECLARE @VP_K_DOCUMENTO_D0M4_FLUP	INT=0

			SELECT	@VP_K_DOCUMENTO_D0M4_FLUP =	MAX(DF.K_DOCUMENTO_D0M4)
												FROM DOCUMENTO_D0M4 AS DC, DOCUMENTO_D0M4 AS DF
												WHERE	DC.K_UNIDAD_OPERATIVA=DF.K_UNIDAD_OPERATIVA
												AND		DC.K_YYYY=DF.K_YYYY
												AND		DC.K_MM=DF.K_MM
												--	K_FORMATO_D0M4	101	C3M3 // COMPROMISO	102	PR3C // PRECIOS-COSTOS GAS	103	FLUP // FLUJO PROYECTADO
												AND		DF.K_FORMATO_D0M4=103 
												AND		DC.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

			IF @PP_L_DEBUG>0
				PRINT @VP_K_DOCUMENTO_D0M4_FLUP

			-- ==================================================================
			DECLARE	@VP_VENTA_PORCENTAJE_CONTADO	DECIMAL(19,4)=0
			DECLARE	@VP_VENTA_PORCENTAJE_CREDITO	DECIMAL(19,4)=0

			SET	@VP_VENTA_PORCENTAJE_CONTADO =	(@PP_VENTA_PORCENTAJE_CONTADO_0_100/100)
			SET	@VP_VENTA_PORCENTAJE_CREDITO =	1-(@PP_VENTA_PORCENTAJE_CONTADO_0_100/100)

			IF @PP_L_DEBUG>0
				PRINT @VP_VENTA_PORCENTAJE_CONTADO
			IF @PP_L_DEBUG>0
				PRINT @VP_VENTA_PORCENTAJE_CREDITO


			UPDATE	PARAMETRO_DOCUMENTO_D0M4
			SET		P2016_DTO_DESCUENTO_X_KG =			@PP_P2016_DTO_DESCUENTO_X_KG,
					DESCUENTO_CONTADO =					(@PP_DESCUENTO_CONTADO_0_100/100),
					DESCUENTO_CREDITO =					1-(@PP_DESCUENTO_CONTADO_0_100/100),
					P2023_PCN =							@PP_P2023_PCN,
					VENTA_PORCENTAJE_CONTADO =			@VP_VENTA_PORCENTAJE_CONTADO,
					VENTA_PORCENTAJE_CREDITO =			@VP_VENTA_PORCENTAJE_CREDITO,
					P1003_VENTA_KG_CONTADO =			@VP_VENTA_PORCENTAJE_CONTADO * @PP_DIV_VENTA_KG_TOTAL * @PP_K_DIVISOR,
					P1004_VENTA_KG_CREDITO =			@VP_VENTA_PORCENTAJE_CREDITO * @PP_DIV_VENTA_KG_TOTAL * @PP_K_DIVISOR,
					P1012_CARTERA_CYC_INICIAL =			@PP_P1012_CARTERA_CYC_INICIAL,
					P1013_CARTERA_CYC_FINAL =			@PP_P1013_CARTERA_CYC_FINAL,
					COBRANZA_HOLGURA =					( @PP_COBRANZA_HOLGURA_0_100/100 ),
					PERFIL_VENTA_CONTADO_1_LUNES =		@PP_PERFIL_VENTA_CONTADO_1_LUNES,
					PERFIL_VENTA_CONTADO_2_MARTES =		@PP_PERFIL_VENTA_CONTADO_2_MARTES,		
					PERFIL_VENTA_CONTADO_3_MIERCOLES =	@PP_PERFIL_VENTA_CONTADO_3_MIERCOLES,	
					PERFIL_VENTA_CONTADO_4_JUEVES =		@PP_PERFIL_VENTA_CONTADO_4_JUEVES,		
					PERFIL_VENTA_CONTADO_5_VIERNES =	@PP_PERFIL_VENTA_CONTADO_5_VIERNES,		
					PERFIL_VENTA_CONTADO_6_SABADO =		@PP_PERFIL_VENTA_CONTADO_6_SABADO,		
					PERFIL_VENTA_CONTADO_7_DOMINGO =	@PP_PERFIL_VENTA_CONTADO_7_DOMINGO,
					PERFIL_VENTA_CREDITO_1_LUNES =		@PP_PERFIL_VENTA_CREDITO_1_LUNES,		
					PERFIL_VENTA_CREDITO_2_MARTES =		@PP_PERFIL_VENTA_CREDITO_2_MARTES,		
					PERFIL_VENTA_CREDITO_3_MIERCOLES =	@PP_PERFIL_VENTA_CREDITO_3_MIERCOLES,	
					PERFIL_VENTA_CREDITO_4_JUEVES =		@PP_PERFIL_VENTA_CREDITO_4_JUEVES,		
					PERFIL_VENTA_CREDITO_5_VIERNES =	@PP_PERFIL_VENTA_CREDITO_5_VIERNES,		
					PERFIL_VENTA_CREDITO_6_SABADO =		@PP_PERFIL_VENTA_CREDITO_6_SABADO,		
					PERFIL_VENTA_CREDITO_7_DOMINGO =	@PP_PERFIL_VENTA_CREDITO_7_DOMINGO,
					PERFIL_COBRANZA_1_LUNES =			@PP_PERFIL_COBRANZA_1_LUNES,				
					PERFIL_COBRANZA_2_MARTES =			@PP_PERFIL_COBRANZA_2_MARTES,			
					PERFIL_COBRANZA_3_MIERCOLES =		@PP_PERFIL_COBRANZA_3_MIERCOLES,			
					PERFIL_COBRANZA_4_JUEVES =			@PP_PERFIL_COBRANZA_4_JUEVES,			
					PERFIL_COBRANZA_5_VIERNES =			@PP_PERFIL_COBRANZA_5_VIERNES,			
					PERFIL_COBRANZA_6_SABADO =			@PP_PERFIL_COBRANZA_6_SABADO,			
					PERFIL_COBRANZA_7_DOMINGO =			@PP_PERFIL_COBRANZA_7_DOMINGO			
			WHERE	(	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4	
					OR	K_DOCUMENTO_D0M4=@VP_K_DOCUMENTO_D0M4_FLUP	)	

			-- =============================================

			EXECUTE	[dbo].[PG_DL_DATA_N_X_K_DOCUMENTO_D0M4]					@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_DOCUMENTO_D0M4

			EXECUTE	[dbo].[PG_DL_DATA_N_X_K_DOCUMENTO_D0M4]					@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@VP_K_DOCUMENTO_D0M4_FLUP
			-- =============================================

			EXECUTE	[dbo].[PG_IN_DATA_N1_X_DI_D0M4_X_K_DOCUMENTO_D0M4]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			0, @PP_K_DOCUMENTO_D0M4

			EXECUTE	[dbo].[PG_IN_DATA_N1_X_DI_D0M4_X_K_DOCUMENTO_D0M4]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			0, @VP_K_DOCUMENTO_D0M4_FLUP
			-- =============================================

			EXECUTE	[dbo].[PG_OP_DOCUMENTO_DOM4_RECALCULAR]					@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_K_DOCUMENTO_D0M4

			EXECUTE	[dbo].[PG_OP_DOCUMENTO_DOM4_RECALCULAR]					@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@VP_K_DOCUMENTO_D0M4_FLUP
			-- =============================================
			END
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar/Parametros] del [Documento]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PDD.'+CONVERT(VARCHAR(10),@PP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////
-- // SP // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_CEMEC_FULL_X_K_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_CEMEC_FULL_X_K_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_DL_CEMEC_FULL_X_K_DOCUMENTO_D0M4]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4			INT,
	@PP_L_BORRAR_DOCUMENTO_D0M4		INT
	-- ===========================
AS		

	DELETE 
	FROM	DATA_N3_X_ME_D0M4
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	-- =====================
	DELETE 
	FROM	DATA_N1_X_DI_D0M4
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	-- =====================
	DELETE 
	FROM	PARAMETRO_DOCUMENTO_D0M4
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	-- =====================
	IF @PP_L_BORRAR_DOCUMENTO_D0M4=1
		DELETE 
		FROM	DOCUMENTO_D0M4
		WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	-- ////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////P
/*

EXECUTE [dbo].[PG_UP_PARAMETRO_DOCUMENTO_D0M4_X_PARAMETRO_SUCURSAL]	1,0,0,  1

SELECT * FROM PARAMETRO_DOCUMENTO_D0M4

*/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARAMETRO_DOCUMENTO_D0M4_X_PARAMETRO_SUCURSAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARAMETRO_DOCUMENTO_D0M4_X_PARAMETRO_SUCURSAL]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARAMETRO_DOCUMENTO_D0M4_X_PARAMETRO_SUCURSAL]
	@PP_L_DEBUG					    INT,
	@PP_K_SISTEMA_EXE			    INT,
	@PP_K_USUARIO_ACCION		    INT,
	-- ===========================		
	@PP_K_DOCUMENTO_D0M4			INT
AS			
	
	DECLARE @VP_K_PARAMETRO_SUCURSAL		INT

	SELECT	@VP_K_PARAMETRO_SUCURSAL =		MIN(K_PARAMETRO_SUCURSAL)
											FROM	PARAMETRO_SUCURSAL
											WHERE	K_UNIDAD_OPERATIVA IN (		SELECT	K_UNIDAD_OPERATIVA
																				FROM	DOCUMENTO_D0M4
																				WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4	)
	-- ==============================================

	IF @PP_L_DEBUG>0
		PRINT @VP_K_PARAMETRO_SUCURSAL

	-- ==============================================

	UPDATE	PARAMETRO_DOCUMENTO_D0M4
	SET		
			[P2016_DTO_DESCUENTO_X_KG]			= (	PSU.[P2016_DTO_DESCUENTO_X_KG] ),
			[DESCUENTO_CONTADO]					= (	PSU.[DESCUENTO_CONTADO] ),
			[DESCUENTO_CREDITO]					= (	PSU.[DESCUENTO_CREDITO] ),
			[P2023_PCN]							= (	PSU.[P2023_PCN] ),
			[VENTA_PORCENTAJE_CONTADO]			= (	PSU.[VENTA_PORCENTAJE_CONTADO] ),
			[VENTA_PORCENTAJE_CREDITO]			= (	PSU.[VENTA_PORCENTAJE_CREDITO] ),
			[P1012_CARTERA_CYC_INICIAL]			= (	PSU.[P1012_CARTERA_CYC_INICIAL] ),
			[P1013_CARTERA_CYC_FINAL]			= (	PSU.[P1013_CARTERA_CYC_FINAL] ),
			[COBRANZA_HOLGURA]					= (	PSU.[COBRANZA_HOLGURA] )
	FROM	PARAMETRO_SUCURSAL AS PSU
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	AND		PSU.K_PARAMETRO_SUCURSAL=@VP_K_PARAMETRO_SUCURSAL


	-- ==============================================

	UPDATE	PARAMETRO_DOCUMENTO_D0M4
	SET
			[PERFIL_VENTA_CONTADO_1_LUNES]		= (	PSU.PERFIL_VENTA_CONTADO_1_LUNES ),
			[PERFIL_VENTA_CONTADO_2_MARTES]		= (	PSU.PERFIL_VENTA_CONTADO_2_MARTES ),
			[PERFIL_VENTA_CONTADO_3_MIERCOLES]	= (	PSU.PERFIL_VENTA_CONTADO_3_MIERCOLES ),
			[PERFIL_VENTA_CONTADO_4_JUEVES]		= (	PSU.PERFIL_VENTA_CONTADO_4_JUEVES ),
			[PERFIL_VENTA_CONTADO_5_VIERNES]	= (	PSU.PERFIL_VENTA_CONTADO_5_VIERNES ),
			[PERFIL_VENTA_CONTADO_6_SABADO]		= (	PSU.PERFIL_VENTA_CONTADO_6_SABADO ),
			[PERFIL_VENTA_CONTADO_7_DOMINGO]	= (	PSU.PERFIL_VENTA_CONTADO_7_DOMINGO )
	FROM	PARAMETRO_SUCURSAL AS PSU
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	AND		PSU.K_PARAMETRO_SUCURSAL=@VP_K_PARAMETRO_SUCURSAL

	-- ==============================================

	UPDATE	PARAMETRO_DOCUMENTO_D0M4
	SET
			[PERFIL_VENTA_CREDITO_1_LUNES]		= (	PSU.PERFIL_VENTA_CREDITO_1_LUNES ),
			[PERFIL_VENTA_CREDITO_2_MARTES]		= (	PSU.PERFIL_VENTA_CREDITO_2_MARTES ),
			[PERFIL_VENTA_CREDITO_3_MIERCOLES]	= (	PSU.PERFIL_VENTA_CREDITO_3_MIERCOLES ),
			[PERFIL_VENTA_CREDITO_4_JUEVES]		= (	PSU.PERFIL_VENTA_CREDITO_4_JUEVES ),
			[PERFIL_VENTA_CREDITO_5_VIERNES]	= (	PSU.PERFIL_VENTA_CREDITO_5_VIERNES ),
			[PERFIL_VENTA_CREDITO_6_SABADO]		= (	PSU.PERFIL_VENTA_CREDITO_6_SABADO ),
			[PERFIL_VENTA_CREDITO_7_DOMINGO]	= (	PSU.PERFIL_VENTA_CREDITO_7_DOMINGO )
	FROM	PARAMETRO_SUCURSAL AS PSU
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	AND		PSU.K_PARAMETRO_SUCURSAL=@VP_K_PARAMETRO_SUCURSAL
			
	-- ==============================================

	UPDATE	PARAMETRO_DOCUMENTO_D0M4
	SET
			[PERFIL_COBRANZA_1_LUNES]		= (	PSU.PERFIL_COBRANZA_1_LUNES ),
			[PERFIL_COBRANZA_2_MARTES]		= (	PSU.PERFIL_COBRANZA_2_MARTES ),
			[PERFIL_COBRANZA_3_MIERCOLES]	= (	PSU.PERFIL_COBRANZA_3_MIERCOLES ),
			[PERFIL_COBRANZA_4_JUEVES]		= (	PSU.PERFIL_COBRANZA_4_JUEVES ),
			[PERFIL_COBRANZA_5_VIERNES]		= (	PSU.PERFIL_COBRANZA_5_VIERNES ),
			[PERFIL_COBRANZA_6_SABADO]		= (	PSU.PERFIL_COBRANZA_6_SABADO ),
			[PERFIL_COBRANZA_7_DOMINGO]		= (	PSU.PERFIL_COBRANZA_7_DOMINGO )
	FROM	PARAMETRO_SUCURSAL AS PSU
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	AND		PSU.K_PARAMETRO_SUCURSAL=@VP_K_PARAMETRO_SUCURSAL
		
	-- //////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////
-- // SP // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARAMETRO_DOCUMENTO_D0M4_VENTAS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARAMETRO_DOCUMENTO_D0M4_VENTAS]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARAMETRO_DOCUMENTO_D0M4_VENTAS]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4			INT

AS		
	IF @PP_L_DEBUG>0
		PRINT '[PG_UP_PARAMETRO_DOCUMENTO_D0M4_VENTAS] -------------------------------'
		
	-- ===============================

	DECLARE @VP_K_UNIDAD_OPERATIVA		INT
	DECLARE @VP_K_YYYY					INT
	DECLARE @VP_K_MES					INT

	SELECT	@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA,
			@VP_K_YYYY =				K_YYYY,
			@VP_K_MES =					K_MM
										FROM	DOCUMENTO_D0M4
										WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	-- ===========================

	DECLARE @VP_K_TEMPORADA		INT = 1
	
	IF ( @VP_K_MES<4  OR  9<@VP_K_MES )
		SET @VP_K_TEMPORADA =	2

	-- ===========================

	IF @VP_K_TEMPORADA=2 AND @VP_K_MES<4
		SET @VP_K_YYYY = @VP_K_YYYY - 1

	-- ===========================
	
	DECLARE @VP_K_PLAN_POV				INT

	SELECT	@VP_K_PLAN_POV =			MIN(K_PLAN_POV)
										FROM	PLAN_POV
										WHERE	@VP_K_UNIDAD_OPERATIVA=K_UNIDAD_OPERATIVA
										AND		@VP_K_YYYY=K_YYYY
										AND		@VP_K_TEMPORADA=K_TEMPORADA
	-- ===========================

	IF @PP_L_DEBUG>0
		IF @VP_K_PLAN_POV IS NULL
			PRINT 'ALERTA >>> @VP_K_PLAN_POV ES NULO'
	
	IF @PP_L_DEBUG>0
		PRINT '@VP_K_PLAN_POV = '+CONVERT(VARCHAR(100),@VP_K_PLAN_POV)

	DECLARE	@VP_VENTA_BASE_MES			DECIMAL(19,4) = 50000

	SELECT	@VP_VENTA_BASE_MES =	(	0
									+	CASE  WHEN (@VP_K_MES=04 OR @VP_K_MES=10)	THEN VENTAS_KG_PR_01   
																					ELSE 0		   END   
									+	CASE  WHEN (@VP_K_MES=05 OR @VP_K_MES=11)	THEN VENTAS_KG_PR_02   
																					ELSE 0		   END  										
									+	CASE  WHEN (@VP_K_MES=06 OR @VP_K_MES=12)	THEN VENTAS_KG_PR_03   
																					ELSE 0		   END  	
									+	CASE  WHEN (@VP_K_MES=07 OR @VP_K_MES=01)	THEN VENTAS_KG_PR_04   
																					ELSE 0		   END  
									+	CASE  WHEN (@VP_K_MES=08 OR @VP_K_MES=02)	THEN VENTAS_KG_PR_05   
																					ELSE 0		   END  
									+	CASE  WHEN (@VP_K_MES=09 OR @VP_K_MES=03)	THEN VENTAS_KG_PR_06   
																					ELSE 0		   END  
									)
										FROM	PLAN_POV
										WHERE	K_PLAN_POV=@VP_K_PLAN_POV
	-- ===========================

	UPDATE	PARAMETRO_DOCUMENTO_D0M4
	SET		
			[P1003_VENTA_KG_CONTADO]	=  ( @VP_VENTA_BASE_MES * [VENTA_PORCENTAJE_CONTADO] ),
			[P1004_VENTA_KG_CREDITO]	=  ( @VP_VENTA_BASE_MES * [VENTA_PORCENTAJE_CREDITO] )
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	-- //////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PARAMETRO_DOCUMENTO_D0M4_BASE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PARAMETRO_DOCUMENTO_D0M4_BASE]
GO


CREATE PROCEDURE [dbo].[PG_IN_PARAMETRO_DOCUMENTO_D0M4_BASE]
	@PP_L_DEBUG					    INT,
	@PP_K_SISTEMA_EXE			    INT,
	@PP_K_USUARIO_ACCION		    INT,
	-- ===========================		
	@PP_K_DOCUMENTO_D0M4			INT
AS			

	INSERT INTO PARAMETRO_DOCUMENTO_D0M4
			(	[K_DOCUMENTO_D0M4],
				-- ===========================
				[K_USUARIO_ALTA],[F_ALTA],[K_USUARIO_CAMBIO],[F_CAMBIO],
				[L_BORRADO],[K_USUARIO_BAJA],[F_BAJA]	)
		VALUES	
			(	@PP_K_DOCUMENTO_D0M4,
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )

	-- ================================
GO




-- //////////////////////////////////////////////////////
-- // SP // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_CEMEC_CALCULOS_X_K_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_CEMEC_CALCULOS_X_K_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_PR_CEMEC_CALCULOS_X_K_DOCUMENTO_D0M4]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4			INT
	-- ===========================
AS		

	IF @PP_L_DEBUG>0
		PRINT '[PG_PR_CEMEC_CALCULOS_X_K_DOCUMENTO_D0M4]'
		
	-- ==================================
	
	EXECUTE	[dbo].[PG_DL_CEMEC_FULL_X_K_DOCUMENTO_D0M4]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_DOCUMENTO_D0M4, 0				
	-- ==================================

	-- //////////////////////////////////////////////////////////////

	DECLARE @VP_K_UNIDAD_OPERATIVA		INT

	SELECT	@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA
										FROM	DOCUMENTO_D0M4
										WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	-- ==============================
	IF @PP_L_DEBUG>0
		PRINT '@VP_K_UNIDAD_OPERATIVA = ' + CONVERT(VARCHAR(100),@VP_K_UNIDAD_OPERATIVA)

	UPDATE	DOCUMENTO_D0M4
	SET		K_PRECIO_COSTO_PERFIL = ( @VP_K_UNIDAD_OPERATIVA+1000 )
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	-- //////////////////////////////////////////////////////////////
	
	EXECUTE [dbo].[PG_IN_PARAMETRO_DOCUMENTO_D0M4_BASE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4

	-- //////////////////////////////////////////////////////////////
	-- ACTUALIZAR DOCUMENTO

	-- //////////////////////////////////////////////////////////////
	-- ACTUALIZAR PARAMETROS
	 
	EXECUTE [dbo].[PG_UP_PARAMETRO_DOCUMENTO_D0M4_X_PARAMETRO_SUCURSAL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,    
																		@PP_K_DOCUMENTO_D0M4			
	-- //////////////////////////////////////////////////////////////
	-- DETERMINAR VENTA BASE
	
	EXECUTE [dbo].[PG_UP_PARAMETRO_DOCUMENTO_D0M4_VENTAS]				@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,    
																		@PP_K_DOCUMENTO_D0M4			
	-- //////////////////////////////////////////////////////////////
	-- INSERTAR REGISTROS BASE EN DATA

	EXECUTE [dbo].[PG_IN_DATA_N1_X_DI_D0M4_X_K_DOCUMENTO_D0M4]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, 0,
																		@PP_K_DOCUMENTO_D0M4
	-- //////////////////////////////////////////////////////////////
	-- PROCESAR DOCUMENTO

	EXECUTE [dbo].[PG_OP_DOCUMENTO_DOM4_RECALCULAR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_DOCUMENTO_D0M4

	-- //////////////////////////////////////////////////////////////
GO






-- //////////////////////////////////////////////////////
-- // SP // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_FLUP_FULL_X_PARAMETROS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_FLUP_FULL_X_PARAMETROS]
GO


CREATE PROCEDURE [dbo].[PG_DL_FLUP_FULL_X_PARAMETROS]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_UNIDAD_OPERATIVA			INT,
	-- ===========================
	@PP_K_YYYY						INT,
	@PP_K_MM						INT,
	@PP_L_BORRAR_DOCUMENTO_D0M4		INT
	-- ===========================
AS		

	DECLARE @VP_K_DOCUMENTO_D0M4		INT

	SELECT	@VP_K_DOCUMENTO_D0M4 =		K_DOCUMENTO_D0M4
										FROM	DOCUMENTO_D0M4
										WHERE	K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
										AND		K_YYYY=@PP_K_YYYY
										AND		K_MM=@PP_K_MM
										AND		K_FORMATO_D0M4=103				-- #101 CEMEC / #103 FLUP
	-- =====================

	EXECUTE [dbo].[PG_DL_CEMEC_FULL_X_K_DOCUMENTO_D0M4]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@VP_K_DOCUMENTO_D0M4, 	@PP_L_BORRAR_DOCUMENTO_D0M4		
	-- //////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////
-- // SP // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_FLUP_X_K_UNIDAD_OPERATIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_FLUP_X_K_UNIDAD_OPERATIVA]
GO



CREATE PROCEDURE [dbo].[PG_PR_FLUP_X_K_UNIDAD_OPERATIVA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_UNIDAD_OPERATIVA			INT,
	-- ===========================
	@PP_K_YYYY						INT,
	@PP_K_MES						INT
	-- ===========================
AS	
	
	EXECUTE	[dbo].[PG_DL_FLUP_FULL_X_PARAMETROS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_UNIDAD_OPERATIVA,
													@PP_K_YYYY, @PP_K_MES, 1					
	-- ==================================

	DECLARE @VP_K_DOCUMENTO_D0M4				INT

	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'DOCUMENTO_D0M4', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_DOCUMENTO_D0M4	OUTPUT	
	-- ==================================

	DECLARE @VP_D_DOCUMENTO_D0M4		VARCHAR(100) = ''
	DECLARE @VP_C_DOCUMENTO_D0M4		VARCHAR(255) = ''
	DECLARE @VP_S_DOCUMENTO_D0M4		VARCHAR(10) = ''
	DECLARE @VP_O_DOCUMENTO_D0M4		INT = 123
	DECLARE @VP_K_FORMATO_D0M4			INT = 103			-- #101 CEMEC / #103 FLUP
	DECLARE @VP_S_FORMATO_D0M4			VARCHAR(50) = ''

	SELECT	@VP_S_FORMATO_D0M4 =	S_FORMATO_D0M4 
									FROM FORMATO_D0M4 
									WHERE K_FORMATO_D0M4=@VP_K_FORMATO_D0M4

	SELECT	@VP_D_DOCUMENTO_D0M4 =	CONCAT(@VP_S_FORMATO_D0M4,' - [', S_ZONA_UO, '] ', D_UNIDAD_OPERATIVA, ' ', @PP_K_YYYY, '/', @PP_K_MES) 
									FROM VI_UNIDAD_OPERATIVA_CATALOGOS
									WHERE VI_K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA

	SELECT	@VP_S_DOCUMENTO_D0M4 =	CONCAT('[#DOC-', @VP_K_DOCUMENTO_D0M4, '] ', S_UNIDAD_OPERATIVA, ' ', @PP_K_YYYY, '/', @PP_K_MES) 
									FROM VI_UNIDAD_OPERATIVA_CATALOGOS
									WHERE VI_K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA

	-- ======================================

	EXECUTE [dbo].[PG_IN_DOCUMENTO_D0M4_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@VP_K_DOCUMENTO_D0M4,
												@VP_D_DOCUMENTO_D0M4, @VP_C_DOCUMENTO_D0M4,
												@VP_S_DOCUMENTO_D0M4, @VP_O_DOCUMENTO_D0M4,
												@VP_K_FORMATO_D0M4,
												@PP_K_UNIDAD_OPERATIVA, @PP_K_YYYY, @PP_K_MES

	-- ======================================
	-- WIWI // HGF 20181102 // RENOMBRAR
	EXECUTE [dbo].[PG_PR_CEMEC_CALCULOS_X_K_DOCUMENTO_D0M4]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_DOCUMENTO_D0M4

	-- //////////////////////////////////////////////////////
GO







-- //////////////////////////////////////////////////////
-- // SP // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_CEMEC_FULL_X_PARAMETROS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_CEMEC_FULL_X_PARAMETROS]
GO


CREATE PROCEDURE [dbo].[PG_DL_CEMEC_FULL_X_PARAMETROS]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_UNIDAD_OPERATIVA			INT,
	-- ===========================
	@PP_K_YYYY						INT,
	@PP_K_MM						INT,
	@PP_L_BORRAR_DOCUMENTO_D0M4		INT
	-- ===========================
AS		

	DECLARE @VP_K_DOCUMENTO_D0M4		INT

	SELECT	@VP_K_DOCUMENTO_D0M4 =		K_DOCUMENTO_D0M4
										FROM	DOCUMENTO_D0M4
										WHERE	K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
										AND		K_YYYY=@PP_K_YYYY
										AND		K_MM=@PP_K_MM
										AND		K_FORMATO_D0M4=101				-- #101 CEMEC / #103 FLUP
	-- =====================

	EXECUTE [dbo].[PG_DL_CEMEC_FULL_X_K_DOCUMENTO_D0M4]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@VP_K_DOCUMENTO_D0M4, 	@PP_L_BORRAR_DOCUMENTO_D0M4		
	-- //////////////////////////////////////////////////
GO








-- //////////////////////////////////////////////////////
-- // SP // 
-- //////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_PR_CEMEC_CALCULOS_REPROCESAR]	0,0,0, 53


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_CEMEC_CALCULOS_REPROCESAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_CEMEC_CALCULOS_REPROCESAR]
GO


CREATE PROCEDURE [dbo].[PG_PR_CEMEC_CALCULOS_REPROCESAR]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4			INT
	-- ===========================
AS	

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- ///////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_PR_CEMEC_CALCULOS_X_K_DOCUMENTO_D0M4]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_DOCUMENTO_D0M4
	-- ///////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Re-Generar] el [CemeC-FluP]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#DOC.'+CONVERT(VARCHAR(10),@PP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////
-- // SP // 
-- //////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_CEMEC_X_K_UNIDAD_OPERATIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_CEMEC_X_K_UNIDAD_OPERATIVA]
GO

CREATE PROCEDURE [dbo].[PG_PR_CEMEC_X_K_UNIDAD_OPERATIVA]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_UNIDAD_OPERATIVA			INT,
	-- ===========================
	@PP_K_YYYY						INT,
	@PP_K_MES						INT
	-- ===========================
AS		

	EXECUTE	[dbo].[PG_DL_CEMEC_FULL_X_PARAMETROS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_UNIDAD_OPERATIVA,
													@PP_K_YYYY, @PP_K_MES, 1					
	-- ==================================

	DECLARE @VP_K_DOCUMENTO_D0M4				INT

	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'DOCUMENTO_D0M4', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_DOCUMENTO_D0M4	OUTPUT	
	-- ==================================

	DECLARE @VP_D_DOCUMENTO_D0M4		VARCHAR(100) = ''
	DECLARE @VP_C_DOCUMENTO_D0M4		VARCHAR(255) = ''
	DECLARE @VP_S_DOCUMENTO_D0M4		VARCHAR(10) = ''
	DECLARE @VP_O_DOCUMENTO_D0M4		INT = 123
	DECLARE @VP_K_FORMATO_D0M4			INT = 101			-- #101 CEMEC / #103 FLUP
	DECLARE @VP_S_FORMATO_D0M4			VARCHAR(50) = ''

	SELECT	@VP_S_FORMATO_D0M4 =	S_FORMATO_D0M4 
									FROM FORMATO_D0M4 
									WHERE K_FORMATO_D0M4=@VP_K_FORMATO_D0M4

	SELECT	@VP_D_DOCUMENTO_D0M4 =	CONCAT(@VP_S_FORMATO_D0M4,' - [', S_ZONA_UO, '] ', D_UNIDAD_OPERATIVA, ' ', @PP_K_YYYY, '/', @PP_K_MES) 
									FROM VI_UNIDAD_OPERATIVA_CATALOGOS
									WHERE VI_K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA

	SELECT	@VP_S_DOCUMENTO_D0M4 =	CONCAT('[#DOC-', @VP_K_DOCUMENTO_D0M4, '] ', S_UNIDAD_OPERATIVA, ' ', @PP_K_YYYY, '/', @PP_K_MES) 
									FROM VI_UNIDAD_OPERATIVA_CATALOGOS
									WHERE VI_K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA

	-- ==================================

	EXECUTE [dbo].[PG_IN_DOCUMENTO_D0M4_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@VP_K_DOCUMENTO_D0M4,
												@VP_D_DOCUMENTO_D0M4, @VP_C_DOCUMENTO_D0M4,
												@VP_S_DOCUMENTO_D0M4, @VP_O_DOCUMENTO_D0M4,
												@VP_K_FORMATO_D0M4,
												@PP_K_UNIDAD_OPERATIVA, @PP_K_YYYY, @PP_K_MES
	-- ======================================
	
	EXECUTE [dbo].[PG_PR_CEMEC_CALCULOS_X_K_DOCUMENTO_D0M4]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_DOCUMENTO_D0M4

	-- //////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////
-- // SP // 
-- //////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_CEMEC_FLUP_MASIVO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_CEMEC_FLUP_MASIVO]
GO


CREATE PROCEDURE [dbo].[PG_PR_CEMEC_FLUP_MASIVO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_ZONA_UO					INT,
	@PP_K_RAZON_SOCIAL				INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	-- ===========================
	@PP_K_YYYY						INT,
	@PP_K_MES						INT
	-- ===========================
AS		

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE='' AND NOT (@PP_K_YYYY>0)
		SET @VP_MENSAJE = 'No ha seleccionado un <Año> válido.'

	IF @VP_MENSAJE='' AND NOT (@PP_K_MES>0)
		SET @VP_MENSAJE = 'No ha seleccionado un <Mes> válido.'

	IF @VP_MENSAJE='' AND (@PP_K_ZONA_UO=-1 AND @PP_K_RAZON_SOCIAL=-1 AND @PP_K_UNIDAD_OPERATIVA=-1)
		SET @VP_MENSAJE = 'No ha seleccionado un <Parámetro( Zona / RazónSocial / UnidadOperativa )> válido.'

	-- /////////////////////////////////////////////////////////////////////

	DECLARE @VP_K_DOCUMENTO_D0M4		INT = 0

	IF @VP_MENSAJE=''
		BEGIN
		-- ==============================================

		DECLARE CU_UNIDAD_OPERATIVA	
			CURSOR	LOCAL FOR
					SELECT	K_UNIDAD_OPERATIVA
					FROM	UNIDAD_OPERATIVA
					WHERE	K_TIPO_UO=10
					AND		( @PP_K_ZONA_UO=-1				OR		@PP_K_ZONA_UO=K_ZONA_UO		)
					AND		( @PP_K_RAZON_SOCIAL=-1			OR		@PP_K_RAZON_SOCIAL=K_RAZON_SOCIAL	)
					AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR		@PP_K_UNIDAD_OPERATIVA=K_UNIDAD_OPERATIVA	)
					
			-- ========================================

			DECLARE @VP_CU_K_UNIDAD_OPERATIVA		INT
			
			-- ========================================

			OPEN CU_UNIDAD_OPERATIVA

			FETCH NEXT FROM CU_UNIDAD_OPERATIVA INTO @VP_CU_K_UNIDAD_OPERATIVA
		
			-- ==================================
		
			WHILE @@FETCH_STATUS = 0
				BEGIN		
				
				IF @PP_L_DEBUG>0
					PRINT '************************************* @VP_CU_K_UNIDAD_OPERATIVA = '+CONVERT(VARCHAR(10),@VP_CU_K_UNIDAD_OPERATIVA)
	
				-- ========================================

				EXECUTE [dbo].[PG_PR_CEMEC_X_K_UNIDAD_OPERATIVA]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@VP_CU_K_UNIDAD_OPERATIVA,
																	@PP_K_YYYY, @PP_K_MES
				-- ========================================

				EXECUTE [dbo].[PG_PR_FLUP_X_K_UNIDAD_OPERATIVA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@VP_CU_K_UNIDAD_OPERATIVA,
																	@PP_K_YYYY, @PP_K_MES
				-- ========================================

				FETCH NEXT FROM CU_UNIDAD_OPERATIVA INTO @VP_CU_K_UNIDAD_OPERATIVA
			
				END

			-- ========================================

			CLOSE		CU_UNIDAD_OPERATIVA
			DEALLOCATE	CU_UNIDAD_OPERATIVA

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Generar] el [CemeC-FluP]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#DOC.'+CONVERT(VARCHAR(10),@VP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_DOCUMENTO_D0M4 AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO






-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////


/*


DELETE 
FROM	DATA_N3_X_ME_D0M4
GO

DELETE 
FROM	DATA_N1_X_DI_D0M4
GO

DELETE 
FROM	PARAMETRO_DOCUMENTO_D0M4
GO

DELETE 
FROM	DOCUMENTO_D0M4
GO

UPDATE	PRECIO_COSTO_PERFIL
SET		[K_YYYY]=2018,
      [K_MM]=1



*/

-- //////////////////////////////////////////////////////////////

/*

--EXECUTE	[dbo].[PG_PR_CEMEC_FLUP_MASIVO]	1,0,0,	30,-1,-1,	2017,11

--EXECUTE	[dbo].[PG_PR_CEMEC_FLUP_MASIVO]	1,0,0,	30,-1,-1,	2017,12

EXECUTE	[dbo].[PG_PR_CEMEC_FLUP_MASIVO]	1,0,0,	30,-1,-1,	2018,01


--EXECUTE	[dbo].[PG_PR_CEMEC_FLUP_MASIVO]	1,0,0,	-1,-1,3,	2017,11
GO
*/


/*

SELECT * FROM	DOCUMENTO_D0M4

SELECT * FROM	PARAMETRO_DOCUMENTO_D0M4

SELECT * FROM	DATA_N1_X_DI_D0M4


*/



-- ////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////
