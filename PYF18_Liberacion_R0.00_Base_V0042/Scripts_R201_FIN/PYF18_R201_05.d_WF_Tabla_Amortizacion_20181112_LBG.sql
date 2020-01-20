-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			Tabla de Amortización 
-- // OPERACION:		LIBERACION / WORKFLOWS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			LAURA BARRAZA GAMEROS 
-- // Fecha creación:	10/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_dias para pagar amortizacion 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TABLA_AMORTIZACION_DIAS_POR_PAGAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_DIAS_POR_PAGAR]
GO


CREATE PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_DIAS_POR_PAGAR]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[INT] 	OUTPUT
AS

			
	-- /////////////////////////////////////////////////////

	
	DECLARE @VP_N_DIAS			INT
		
	SELECT @VP_N_DIAS=15					
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_N_DIAS

	-- /////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A EN REVIISON EL CONTROL MENSUAL
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TABLA_AMORTIZACION_POR_PAGAR_DIAS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_POR_PAGAR_DIAS]
GO


CREATE PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_POR_PAGAR_DIAS]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_TABLA_AMORTIZACION		[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////


	
	DECLARE @VP_N_DIAS		INT
		
	EXECUTE [dbo].[PG_RN_TABLA_AMORTIZACION_DIAS_POR_PAGAR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@OU_RESULTADO_VALIDACION = @VP_N_DIAS		OUTPUT

	-- /////////////////////////////////////////////////////

	DECLARE @VP_F_PERIODO_FIN AS DATE

	SELECT @VP_F_PERIODO_FIN	=	F_PERIODO_FIN 
									FROM	TABLA_AMORTIZACION
									WHERE	K_TABLA_AMORTIZACION=@PP_K_TABLA_AMORTIZACION

	-- /////////////////////////////////////////////////////

	DECLARE @VP_DIAS_RESTANTES AS INTEGER
		
	SELECT @VP_DIAS_RESTANTES=DATEDIFF(DAY, GETDATE(), @VP_F_PERIODO_FIN) 
	
	-- /////////////////////////////////////////////////////
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	IF @VP_DIAS_RESTANTES<@VP_N_DIAS
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'La [Amortización] no se puede cambiar a [Por Pagar] '
		SET @VP_RESULTADO =  @VP_RESULTADO + 'porque los dias entre la fecha actual y la fecha de pago deben ser menores a '
		SET @VP_RESULTADO =  @VP_RESULTADO + CONVERT(VARCHAR(10),@VP_N_DIAS) 
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
-- // STORED PROCEDURE ---> RN_CAMBIAR A POR PAGAR
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TABLA_AMORTIZACION_POR_PAGAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_POR_PAGAR]
GO


CREATE PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_POR_PAGAR]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_TABLA_AMORTIZACION		[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_TABLA_AMORTIZACION AS INT
	DECLARE @VP_D_ESTATUS_TABLA_AMORTIZACION AS VARCHAR(100)

	SELECT @VP_K_ESTATUS_TABLA_AMORTIZACION	=	TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION,
			@VP_D_ESTATUS_TABLA_AMORTIZACION=	D_ESTATUS_TABLA_AMORTIZACION
												FROM	TABLA_AMORTIZACION,ESTATUS_TABLA_AMORTIZACION
												WHERE	TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION=ESTATUS_TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION
												AND K_TABLA_AMORTIZACION	=@PP_K_TABLA_AMORTIZACION

	-- /////////////////////////////////////////////////////
	
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	--K_ESTATUS_TABLA_AMORTIZACION	/	1	PENDIENTE	/	2	POR PAGAR	/	3	PAGADO	/	4	CANCELADA	

	IF @VP_K_ESTATUS_TABLA_AMORTIZACION=1
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'La [Amortización] no se puede cambiar a [Por Pagar] '
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_TABLA_AMORTIZACION+'] que tiene actualmente'
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
-- // STORED PROCEDURE ---> TRANSICION / POR PAGAR
-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_TABLA_AMORTIZACION_POR_PAGAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_TABLA_AMORTIZACION_POR_PAGAR]
GO


CREATE PROCEDURE [dbo].[PG_TR_TABLA_AMORTIZACION_POR_PAGAR]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_TABLA_AMORTIZACION		[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TABLA_AMORTIZACION_POR_PAGAR]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_L_CONTESTA,
																@PP_K_TABLA_AMORTIZACION,
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT																

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TABLA_AMORTIZACION_POR_PAGAR_DIAS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_L_CONTESTA,
																	@PP_K_TABLA_AMORTIZACION,
																	@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
																

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_TABLA_AMORTIZACION	/	1	PENDIENTE	/	2	POR PAGAR	/	3	PAGADO	/	4	CANCELADA	
		
		UPDATE	TABLA_AMORTIZACION
		SET		K_ESTATUS_TABLA_AMORTIZACION	= 2,		-- REVISION
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_TABLA_AMORTIZACION		= @PP_K_TABLA_AMORTIZACION
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] la Amortización a [En Revisión]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_TABLA_AMORTIZACION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'EN_REVISION',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_TABLA_AMORTIZACION_POR_PAGAR]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_TABLA_AMORTIZACION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A PAGADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TABLA_AMORTIZACION_PAGADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_PAGADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_PAGADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_TABLA_AMORTIZACION		[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_TABLA_AMORTIZACION AS INT
	DECLARE @VP_D_ESTATUS_TABLA_AMORTIZACION AS VARCHAR(100)

	SELECT @VP_K_ESTATUS_TABLA_AMORTIZACION	=	TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION,
			@VP_D_ESTATUS_TABLA_AMORTIZACION=	D_ESTATUS_TABLA_AMORTIZACION
												FROM	TABLA_AMORTIZACION,ESTATUS_TABLA_AMORTIZACION
												WHERE	TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION=ESTATUS_TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION
												AND K_TABLA_AMORTIZACION	=@PP_K_TABLA_AMORTIZACION

	-- /////////////////////////////////////////////////////
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	--K_ESTATUS_TABLA_AMORTIZACION	/	1	PENDIENTE	/	2	POR PAGAR	/	3	PAGADO	/	4	CANCELADA	

	IF @VP_K_ESTATUS_TABLA_AMORTIZACION=1 OR @VP_K_ESTATUS_TABLA_AMORTIZACION=2
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'La [Amortización] no se puede cambiar a [Pagado] '
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_TABLA_AMORTIZACION+'] que tiene actualmente'
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
-- // STORED PROCEDURE ---> TRANSICION / PAGADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_TABLA_AMORTIZACION_PAGADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_TABLA_AMORTIZACION_PAGADO]
GO

CREATE PROCEDURE [dbo].[PG_TR_TABLA_AMORTIZACION_PAGADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_TABLA_AMORTIZACION		[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TABLA_AMORTIZACION_PAGADO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_L_CONTESTA,
															@PP_K_TABLA_AMORTIZACION,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT				

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_TABLA_AMORTIZACION	/	1	PENDIENTE	/	2	POR PAGAR	/	3	PAGADO	/	4	CANCELADA	
		
		UPDATE	TABLA_AMORTIZACION
		SET		K_ESTATUS_TABLA_AMORTIZACION	= 3,		-- REVISION
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_TABLA_AMORTIZACION		= @PP_K_TABLA_AMORTIZACION
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] la Amortización a [Pagado]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_TABLA_AMORTIZACION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'PAGADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_TABLA_AMORTIZACION_PAGADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_TABLA_AMORTIZACION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A CANCELADA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TABLA_AMORTIZACION_CANCELADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_CANCELADA]
GO

CREATE PROCEDURE [dbo].[PG_RN_TABLA_AMORTIZACION_CANCELADA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_TABLA_AMORTIZACION		[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_TABLA_AMORTIZACION AS INT
	DECLARE @VP_D_ESTATUS_TABLA_AMORTIZACION AS VARCHAR(100)

	SELECT @VP_K_ESTATUS_TABLA_AMORTIZACION	=	TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION,
			@VP_D_ESTATUS_TABLA_AMORTIZACION=	D_ESTATUS_TABLA_AMORTIZACION
												FROM	TABLA_AMORTIZACION,ESTATUS_TABLA_AMORTIZACION
												WHERE	TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION=ESTATUS_TABLA_AMORTIZACION.K_ESTATUS_TABLA_AMORTIZACION
												AND K_TABLA_AMORTIZACION	=@PP_K_TABLA_AMORTIZACION

	-- /////////////////////////////////////////////////////
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	--K_ESTATUS_TABLA_AMORTIZACION	/	1	PENDIENTE	/	2	POR PAGAR	/	3	PAGADO	/	4	CANCELADA	

	IF @VP_K_ESTATUS_TABLA_AMORTIZACION<>4 --4	CANCELADA	
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'La [Amortización] no se puede cambiar a [Cancelada] '
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_TABLA_AMORTIZACION+'] que tiene actualmente'
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
-- // STORED PROCEDURE ---> TRANSICION / CANCELADO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_TABLA_AMORTIZACION_CANCELADA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_TABLA_AMORTIZACION_CANCELADA]
GO

CREATE PROCEDURE [dbo].[PG_TR_TABLA_AMORTIZACION_CANCELADA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_TABLA_AMORTIZACION		[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TABLA_AMORTIZACION_CANCELADA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_L_CONTESTA,
																@PP_K_TABLA_AMORTIZACION,
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT				

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_TABLA_AMORTIZACION	/	1	PENDIENTE	/	2	POR PAGAR	/	3	PAGADO	/	4	CANCELADA	
		
		UPDATE	TABLA_AMORTIZACION
		SET		K_ESTATUS_TABLA_AMORTIZACION	= 4,		-- CANCELADA
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_TABLA_AMORTIZACION		= @PP_K_TABLA_AMORTIZACION
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] la amortización a [Cancelada]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_TABLA_AMORTIZACION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CANCELADA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_TABLA_AMORTIZACION_CANCELADA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_TABLA_AMORTIZACION, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
