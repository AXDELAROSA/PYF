-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CONTROL POR UNIDAD_OPERATIVA
-- // OPERACION:		LIBERACION / WORKFLOWS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			LAURA BARRAZA GAMEROS 
-- // Fecha creación:	10/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A EN REVIISON EL CONTROL MENSUAL
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_REVISION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_REVISION]
GO


CREATE PROCEDURE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_REVISION]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_UNIDAD_OPERATIVA			[INT],	
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	
	DECLARE @VP_K_ESTATUS_CONTROL_X_MES		INT
	DECLARE @VP_D_ESTATUS_CONTROL_X_MES		INT
		
	SELECT	@VP_K_ESTATUS_CONTROL_X_MES =   CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_ESTATUS_CONTROL,
			@VP_D_ESTATUS_CONTROL_X_MES =	D_ESTATUS_CONTROL
											FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA, ESTATUS_CONTROL 
											WHERE	CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_ESTATUS_CONTROL=ESTATUS_CONTROL.K_ESTATUS_CONTROL
											AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
											AND		K_YYYY=@PP_K_YYYY 
											AND		K_MM=@PP_K_MM

	-- /////////////////////////////////////////////////////

	IF @VP_K_ESTATUS_CONTROL_X_MES IS NULL
		BEGIN
		SET @VP_RESULTADO = 'El control no existe ' 
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [UNO#' +CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO + ' y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		END

	-- /////////////////////////////////////////////////////
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	IF @VP_K_ESTATUS_CONTROL_X_MES=0
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El estatus ['+@VP_D_ESTATUS_CONTROL_X_MES+'] actual del control no permite la transición'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [UNO#' +CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO + ' y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		
		END
	
	IF @PP_L_CONTESTA=1
		PRINT @VP_RESULTADO						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / REVISION
-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_REVISION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_REVISION]
GO


CREATE PROCEDURE [dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_REVISION]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_UNIDAD_OPERATIVA			[INT],	
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_REVISION]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_L_CONTESTA,
																			@PP_K_UNIDAD_OPERATIVA,
																			@PP_K_YYYY,@PP_K_MM,
																			@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_CONTROL =	6	AJUSTES /	0	BASE	/	5	CERRADO /	4	EJECUCIÓN /	3	PREPARACIÓN /	1	PROGRAMADO	/	2	REVISION
		
		UPDATE	CONTROL_X_MES_X_RAZON_SOCIAL
		SET		K_ESTATUS_CONTROL			= 2,		-- REVISION
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_RAZON_SOCIAL				= @PP_K_UNIDAD_OPERATIVA
		AND		K_YYYY=@PP_K_YYYY
		AND		K_MM=@PP_K_MM
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el Control a [En Revisión]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MM AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'EN_REVISION',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CONTROL_REVISION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_YYYY, @PP_K_MM, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A EN PROGRAMADO EL CONTROL MENSUAL
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_PROGRAMADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_PROGRAMADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_PROGRAMADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_UNIDAD_OPERATIVA			[INT],		
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	
	DECLARE @VP_K_ESTATUS_CONTROL_X_MES		INT
	DECLARE @VP_D_ESTATUS_CONTROL_X_MES		INT
		
	SELECT	@VP_K_ESTATUS_CONTROL_X_MES =   CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_ESTATUS_CONTROL,
			@VP_D_ESTATUS_CONTROL_X_MES =	D_ESTATUS_CONTROL
											FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA, ESTATUS_CONTROL 
											WHERE	CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_ESTATUS_CONTROL=ESTATUS_CONTROL.K_ESTATUS_CONTROL
											AND		CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
											AND		K_YYYY=@PP_K_YYYY 
											AND		K_MM=@PP_K_MM

	-- /////////////////////////////////////////////////////

	IF @VP_K_ESTATUS_CONTROL_X_MES IS NULL
		BEGIN
		SET @VP_RESULTADO = 'El control no existe ' 
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [UNO#' +CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO + ' y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		END

	-- /////////////////////////////////////////////////////
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	--K_ESTATUS_CONTROL =	6	AJUSTES /	0	BASE	/	5	CERRADO /	4	EJECUCIÓN /	3	PREPARACIÓN /	1	PROGRAMADO	/	2	REVISION		

	IF @VP_K_ESTATUS_CONTROL_X_MES=0 OR @VP_K_ESTATUS_CONTROL_X_MES=2
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El estatus ['+@VP_D_ESTATUS_CONTROL_X_MES+'] actual del control no permite la transición'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [UNO#' +CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO + ' y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		
		END
	
	IF @PP_L_CONTESTA=1
		PRINT @VP_RESULTADO						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / PROGRAMADO
-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_PROGRAMADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_PROGRAMADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_PROGRAMADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================
	@PP_K_UNIDAD_OPERATIVA			[INT],			
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_PROGRAMADO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_L_CONTESTA,
																			@PP_K_UNIDAD_OPERATIVA,
																			@PP_K_YYYY,@PP_K_MM,
																			@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_CONTROL =	6	AJUSTES /	0	BASE	/	5	CERRADO /	4	EJECUCIÓN /	3	PREPARACIÓN /	1	PROGRAMADO	/	2	REVISION
		
		UPDATE	CONTROL_X_MES_X_RAZON_SOCIAL
		SET		K_ESTATUS_CONTROL			= 1,		-- 1	PROGRAMADO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_RAZON_SOCIAL				= @PP_K_UNIDAD_OPERATIVA
		AND		K_YYYY=@PP_K_YYYY
		AND		K_MM=@PP_K_MM
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el Control a [programado]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MM AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'PROGRAMADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CONTROL_PROGRAMADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_YYYY, @PP_K_MM, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A EN PROGRAMADO EL CONTROL MENSUAL
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_PREPARACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_PREPARACION]
GO


CREATE PROCEDURE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_PREPARACION]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_UNIDAD_OPERATIVA			[INT],		
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////
	
	DECLARE @VP_K_ESTATUS_CONTROL_X_MES		INT
	DECLARE @VP_D_ESTATUS_CONTROL_X_MES		INT
		
	SELECT	@VP_K_ESTATUS_CONTROL_X_MES =   CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_ESTATUS_CONTROL,
			@VP_D_ESTATUS_CONTROL_X_MES =	D_ESTATUS_CONTROL
											FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA, ESTATUS_CONTROL 
											WHERE	CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_ESTATUS_CONTROL=ESTATUS_CONTROL.K_ESTATUS_CONTROL
											AND		CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
											AND		K_YYYY=@PP_K_YYYY 
											AND		K_MM=@PP_K_MM

	-- /////////////////////////////////////////////////////

	IF @VP_K_ESTATUS_CONTROL_X_MES IS NULL
		BEGIN
		SET @VP_RESULTADO = 'El control no existe ' 
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [UNO#' +CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO + ' y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		END

	-- /////////////////////////////////////////////////////
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	--K_ESTATUS_CONTROL =	6	AJUSTES /	0	BASE	/	5	CERRADO /	4	EJECUCIÓN /	3	PREPARACIÓN /	1	PROGRAMADO	/	2	REVISION		

	IF @VP_K_ESTATUS_CONTROL_X_MES=1
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El estatus ['+@VP_D_ESTATUS_CONTROL_X_MES+'] actual del control no permite la transición'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [UNO#' +CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO + ' y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		
		END
	
	IF @PP_L_CONTESTA=1
		PRINT @VP_RESULTADO						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / PREPARACIÓN
-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_PREPARACION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_PREPARACION]
GO


CREATE PROCEDURE [dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_PREPARACION]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_UNIDAD_OPERATIVA			[INT],	
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_PREPARACION]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																				@PP_L_CONTESTA,
																				@PP_K_UNIDAD_OPERATIVA,
																				@PP_K_YYYY, @PP_K_MM,
																				@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_CONTROL =	6	AJUSTES /	0	BASE	/	5	CERRADO /	4	EJECUCIÓN /	3	PREPARACIÓN /	1	PROGRAMADO	/	2	REVISION
		
		UPDATE	CONTROL_X_MES_X_RAZON_SOCIAL
		SET		K_ESTATUS_CONTROL			= 3,		-- 	3	PREPARACIÓN
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_RAZON_SOCIAL				= @PP_K_UNIDAD_OPERATIVA
		AND		K_YYYY=@PP_K_YYYY
		AND		K_MM=@PP_K_MM
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el Control a [Preparación]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MM AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'PREPARACION',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CONTROL_PREPARACIÓN]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_YYYY, @PP_K_MM, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A EJECUCION EL CONTROL MENSUAL
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_EJECUCION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_EJECUCION]
GO


CREATE PROCEDURE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_EJECUCION]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_UNIDAD_OPERATIVA			[INT],	
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////
	
	DECLARE @VP_K_ESTATUS_CONTROL_X_MES		INT
	DECLARE @VP_D_ESTATUS_CONTROL_X_MES		INT
		
	SELECT	@VP_K_ESTATUS_CONTROL_X_MES =   CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_ESTATUS_CONTROL,
			@VP_D_ESTATUS_CONTROL_X_MES =	D_ESTATUS_CONTROL
											FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA, ESTATUS_CONTROL 
											WHERE	CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_ESTATUS_CONTROL=ESTATUS_CONTROL.K_ESTATUS_CONTROL
											AND		CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
											AND		K_YYYY=@PP_K_YYYY 
											AND		K_MM=@PP_K_MM

	-- /////////////////////////////////////////////////////

	IF @VP_K_ESTATUS_CONTROL_X_MES IS NULL
		BEGIN
		SET @VP_RESULTADO = 'El control no existe ' 
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [UNO#' +CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO + ' y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		END

	-- /////////////////////////////////////////////////////
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	--K_ESTATUS_CONTROL =	6	AJUSTES /	0	BASE	/	5	CERRADO /	4	EJECUCIÓN /	3	PREPARACIÓN /	1	PROGRAMADO	/	2	REVISION		

	IF @VP_K_ESTATUS_CONTROL_X_MES=3
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El estatus ['+@VP_D_ESTATUS_CONTROL_X_MES+'] actual del control no permite la transición'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [UNO#' +CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO + ' y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		
		END
	
	IF @PP_L_CONTESTA=1
		PRINT @VP_RESULTADO						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / EJECUCION
-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_EJECUCION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_EJECUCION]
GO


CREATE PROCEDURE [dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_EJECUCION]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_UNIDAD_OPERATIVA			[INT],		
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_EJECUCION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_L_CONTESTA,
																			@PP_K_UNIDAD_OPERATIVA,
																			@PP_K_YYYY,@PP_K_MM,
																			@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_CONTROL =	6	AJUSTES /	0	BASE	/	5	CERRADO /	4	EJECUCIÓN /	3	PREPARACIÓN /	1	PROGRAMADO	/	2	REVISION
		
		UPDATE	CONTROL_X_MES_X_RAZON_SOCIAL
		SET		K_ESTATUS_CONTROL			= 4,		-- 	4	EJECUCIÓN 
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_RAZON_SOCIAL				= @PP_K_UNIDAD_OPERATIVA
		AND		K_YYYY=@PP_K_YYYY
		AND		K_MM=@PP_K_MM
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el Control a [Ejecución]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MM AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'EJECUCION',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CONTROL_EJECUCION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_YYYY, @PP_K_MM, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A CERRADO EL CONTROL MENSUAL
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_CERRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_CERRADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_CERRADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_UNIDAD_OPERATIVA			[INT],	
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	
	DECLARE @VP_K_ESTATUS_CONTROL_X_MES		INT
	DECLARE @VP_D_ESTATUS_CONTROL_X_MES		INT
		
	SELECT	@VP_K_ESTATUS_CONTROL_X_MES =   CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_ESTATUS_CONTROL,
			@VP_D_ESTATUS_CONTROL_X_MES =	D_ESTATUS_CONTROL
											FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA, ESTATUS_CONTROL 
											WHERE	CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_ESTATUS_CONTROL=ESTATUS_CONTROL.K_ESTATUS_CONTROL
											AND		CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
											AND		K_YYYY=@PP_K_YYYY 
											AND		K_MM=@PP_K_MM

	-- /////////////////////////////////////////////////////

	IF @VP_K_ESTATUS_CONTROL_X_MES IS NULL
		BEGIN
		SET @VP_RESULTADO = 'El control no existe ' 
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [UNO#' +CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO + ' y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		END

	-- /////////////////////////////////////////////////////
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	--K_ESTATUS_CONTROL =	6	AJUSTES /	0	BASE	/	5	CERRADO /	4	EJECUCIÓN /	3	PREPARACIÓN /	1	PROGRAMADO	/	2	REVISION		

	IF @VP_K_ESTATUS_CONTROL_X_MES=4
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El estatus ['+@VP_D_ESTATUS_CONTROL_X_MES+'] actual del control no permite la transición'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [UNO#' +CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO + ' y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		
		END
	
	IF @PP_L_CONTESTA=1
		PRINT @VP_RESULTADO						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / CERRADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_CERRADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_CERRADO]
GO


CREATE PROCEDURE [dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_CERRADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_UNIDAD_OPERATIVA			[INT],	
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_CERRADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_L_CONTESTA,
																			@PP_K_UNIDAD_OPERATIVA,
																			@PP_K_YYYY,@PP_K_MM,
																			@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_CONTROL =	6	AJUSTES /	0	BASE	/	5	CERRADO /	4	EJECUCIÓN /	3	PREPARACIÓN /	1	PROGRAMADO	/	2	REVISION
		
		UPDATE	CONTROL_X_MES_X_RAZON_SOCIAL
		SET		K_ESTATUS_CONTROL			= 5,		-- 5	CERRADO 
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_RAZON_SOCIAL				= @PP_K_UNIDAD_OPERATIVA
		AND		K_YYYY=@PP_K_YYYY
		AND		K_MM=@PP_K_MM
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el Control a [CERRADO]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MM AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CERRADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CONTROL_CERRADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_YYYY, @PP_K_MM, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A AJUSTES EL CONTROL MENSUAL
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_AJUSTES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_AJUSTES]
GO


CREATE PROCEDURE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_AJUSTES]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_UNIDAD_OPERATIVA			[INT],	
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	
	DECLARE @VP_K_ESTATUS_CONTROL_X_MES		INT
	DECLARE @VP_D_ESTATUS_CONTROL_X_MES		INT
		
	SELECT	@VP_K_ESTATUS_CONTROL_X_MES =   CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_ESTATUS_CONTROL,
			@VP_D_ESTATUS_CONTROL_X_MES =	D_ESTATUS_CONTROL
											FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA, ESTATUS_CONTROL 
											WHERE	CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_ESTATUS_CONTROL=ESTATUS_CONTROL.K_ESTATUS_CONTROL
											AND		CONTROL_X_MES_X_UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
											AND		K_YYYY=@PP_K_YYYY 
											AND		K_MM=@PP_K_MM

	-- /////////////////////////////////////////////////////

	IF @VP_K_ESTATUS_CONTROL_X_MES IS NULL
		BEGIN
		SET @VP_RESULTADO = 'El control no existe ' 
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [UNO#' +CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO + ' y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		END

	-- /////////////////////////////////////////////////////
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	--K_ESTATUS_CONTROL =	6	AJUSTES /	0	BASE	/	5	CERRADO /	4	EJECUCIÓN /	3	PREPARACIÓN /	1	PROGRAMADO	/	2	REVISION		

	IF @VP_K_ESTATUS_CONTROL_X_MES=5
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El estatus ['+@VP_D_ESTATUS_CONTROL_X_MES+'] actual del control no permite la transición'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [UNO#' +CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO + ' y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		
		END
	
	IF @PP_L_CONTESTA=1
		PRINT @VP_RESULTADO						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / AJUSTES
-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_AJUSTES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_AJUSTES]
GO


CREATE PROCEDURE [dbo].[PG_TR_CONTROL_X_MES_X_UNIDAD_OPERATIVA_AJUSTES]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_UNIDAD_OPERATIVA			[INT],	
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CONTROL_X_MES_X_UNIDAD_OPERATIVA_AJUSTES]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																			@PP_L_CONTESTA,
																			@PP_K_UNIDAD_OPERATIVA,
																			@PP_K_YYYY,@PP_K_MM,
																			@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_CONTROL =	6	AJUSTES /	0	BASE	/	5	CERRADO /	4	EJECUCIÓN /	3	PREPARACIÓN /	1	PROGRAMADO	/	2	REVISION
		
		UPDATE	CONTROL_X_MES_X_RAZON_SOCIAL
		SET		K_ESTATUS_CONTROL			= 6,		-- 6	AJUSTES
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_RAZON_SOCIAL				= @PP_K_UNIDAD_OPERATIVA
		AND		K_YYYY=@PP_K_YYYY
		AND		K_MM=@PP_K_MM
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el Control a [AJUSTES]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MM AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'AJUSTES',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CONTROL_AJUSTES]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_YYYY, @PP_K_MM, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO





-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
