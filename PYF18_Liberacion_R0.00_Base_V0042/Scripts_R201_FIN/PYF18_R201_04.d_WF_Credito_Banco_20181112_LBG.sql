-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			Credito Bancario 
-- // OPERACION:		LIBERACION / WORKFLOWS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			LAURA BARRAZA GAMEROS 
-- // Fecha creación:	10/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A REVISION
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CREDITO_BANCARIO_REVISION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CREDITO_BANCARIO_REVISION]
GO


CREATE PROCEDURE [dbo].[PG_RN_CREDITO_BANCARIO_REVISION]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_CREDITO_BANCARIO			[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_CREDITO_BANCARIO AS INT
	DECLARE @VP_D_ESTATUS_CREDITO_BANCARIO AS VARCHAR(100)

	SELECT @VP_K_ESTATUS_CREDITO_BANCARIO	=	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO,
			@VP_D_ESTATUS_CREDITO_BANCARIO	=	D_ESTATUS_CREDITO_BANCARIO
												FROM	CREDITO_BANCARIO,ESTATUS_CREDITO_BANCARIO
												WHERE	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO=ESTATUS_CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO
												AND		K_CREDITO_BANCARIO	=@PP_K_CREDITO_BANCARIO

	-- /////////////////////////////////////////////////////
	
	
	DECLARE @VP_L_PROCESAR AS INT = 0


	-- K_ESTATUS_CREDITO_BANCARIO	/	1	ABIERTO			/	2	REVISION		/	3	AUTORIZADO	/	4	RECHAZADO	/	5	EN PAGOS	/	
	--									6	LIQUIDADO		/	7	REESTRUCTURADO	/	8	CANCELADO
	

	IF @VP_K_ESTATUS_CREDITO_BANCARIO=1 --1	ABIERTO	
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El [Credito Bancario] no se puede cambiar a [Revisión] '
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_CREDITO_BANCARIO+'] que tiene actualmente'
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CREDITO_BANCARIO_REVISION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CREDITO_BANCARIO_REVISION]
GO

CREATE PROCEDURE [dbo].[PG_TR_CREDITO_BANCARIO_REVISION]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_CREDITO_BANCARIO			[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CREDITO_BANCARIO_REVISION]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_L_CONTESTA,
															@PP_K_CREDITO_BANCARIO,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT																
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_CREDITO_BANCARIO	/	1	ABIERTO			/	2	REVISION		/	3	AUTORIZADO	/	4	RECHAZADO	/	5	EN PAGOS	/	
		--									6	LIQUIDADO		/	7	REESTRUCTURADO	/	8	CANCELADO
		
		UPDATE	CREDITO_BANCARIO
		SET		K_ESTATUS_CREDITO_BANCARIO	= 2,		--2  REVISION
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_CREDITO_BANCARIO		= @PP_K_CREDITO_BANCARIO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el Credito Bancario a [Revisión]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CREDITO_BANCARIO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'REVISION',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CREDITO_BANCARIO_REVISION]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CREDITO_BANCARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A AUTORIZADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CREDITO_BANCARIO_AUTORIZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CREDITO_BANCARIO_AUTORIZADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_CREDITO_BANCARIO_AUTORIZADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_CREDITO_BANCARIO			[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_CREDITO_BANCARIO AS INT
	DECLARE @VP_D_ESTATUS_CREDITO_BANCARIO AS VARCHAR(100)

	SELECT @VP_K_ESTATUS_CREDITO_BANCARIO	=	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO,
			@VP_D_ESTATUS_CREDITO_BANCARIO	=	D_ESTATUS_CREDITO_BANCARIO
												FROM	CREDITO_BANCARIO,ESTATUS_CREDITO_BANCARIO
												WHERE	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO=ESTATUS_CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO
												AND		K_CREDITO_BANCARIO	=@PP_K_CREDITO_BANCARIO

	-- /////////////////////////////////////////////////////
	
	
	DECLARE @VP_L_PROCESAR AS INT = 0


	-- K_ESTATUS_CREDITO_BANCARIO	/	1	ABIERTO			/	2	REVISION		/	3	AUTORIZADO	/	4	RECHAZADO	/	5	EN PAGOS	/	
	--									6	LIQUIDADO		/	7	REESTRUCTURADO	/	8	CANCELADO
	

	IF @VP_K_ESTATUS_CREDITO_BANCARIO=2 --2	REVISION
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El [Credito Bancario] no se puede cambiar a [Autorizado] '
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_CREDITO_BANCARIO+'] que tiene actualmente'
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
-- // STORED PROCEDURE ---> TRANSICION / AUTORIZADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CREDITO_BANCARIO_AUTORIZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CREDITO_BANCARIO_AUTORIZADO]
GO

CREATE PROCEDURE [dbo].[PG_TR_CREDITO_BANCARIO_AUTORIZADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_CREDITO_BANCARIO			[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CREDITO_BANCARIO_AUTORIZADO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_L_CONTESTA,
															@PP_K_CREDITO_BANCARIO,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT																
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_CREDITO_BANCARIO	/	1	ABIERTO			/	2	REVISION		/	3	AUTORIZADO	/	4	RECHAZADO	/	5	EN PAGOS	/	
		--									6	LIQUIDADO		/	7	REESTRUCTURADO	/	8	CANCELADO
		
		UPDATE	CREDITO_BANCARIO
		SET		K_ESTATUS_CREDITO_BANCARIO	= 3,		--3	AUTORIZADO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_CREDITO_BANCARIO		= @PP_K_CREDITO_BANCARIO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el Credito Bancario a [Autorizado]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CREDITO_BANCARIO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'AUTORIZADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CREDITO_BANCARIO_AUTORIZADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CREDITO_BANCARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A EN PAGOS
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CREDITO_BANCARIO_EN_PAGOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CREDITO_BANCARIO_EN_PAGOS]
GO


CREATE PROCEDURE [dbo].[PG_RN_CREDITO_BANCARIO_EN_PAGOS]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_CREDITO_BANCARIO			[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_CREDITO_BANCARIO		AS INT
	DECLARE @VP_D_ESTATUS_CREDITO_BANCARIO		AS VARCHAR(100)

	SELECT @VP_K_ESTATUS_CREDITO_BANCARIO	=	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO,
			@VP_D_ESTATUS_CREDITO_BANCARIO	=	D_ESTATUS_CREDITO_BANCARIO
												FROM	CREDITO_BANCARIO,ESTATUS_CREDITO_BANCARIO
												WHERE	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO=ESTATUS_CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO
												AND		K_CREDITO_BANCARIO	=@PP_K_CREDITO_BANCARIO

	-- /////////////////////////////////////////////////////
	
	
	DECLARE @VP_L_PROCESAR AS INT = 0


	-- K_ESTATUS_CREDITO_BANCARIO	/	1	ABIERTO			/	2	REVISION		/	3	AUTORIZADO	/	4	RECHAZADO	/	5	EN PAGOS	/	
	--									6	LIQUIDADO		/	7	REESTRUCTURADO	/	8	CANCELADO
	

	IF @VP_K_ESTATUS_CREDITO_BANCARIO=3 --3	AUTORIZADO
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El [Credito Bancario] no se puede cambiar a [En Pagos] '
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_CREDITO_BANCARIO+'] que tiene actualmente'
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		
		END
	
	IF @PP_L_CONTESTA=1
		PRINT @VP_RESULTADO						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / EN PAGOS
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CREDITO_BANCARIO_EN_PAGOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CREDITO_BANCARIO_EN_PAGOS]
GO

CREATE PROCEDURE [dbo].[PG_TR_CREDITO_BANCARIO_EN_PAGOS]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_CREDITO_BANCARIO			[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CREDITO_BANCARIO_AUTORIZADO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_L_CONTESTA,
															@PP_K_CREDITO_BANCARIO,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT																
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_CREDITO_BANCARIO	/	1	ABIERTO			/	2	REVISION		/	3	AUTORIZADO	/	4	RECHAZADO	/	5	EN PAGOS	/	
		--									6	LIQUIDADO		/	7	REESTRUCTURADO	/	8	CANCELADO
		
		UPDATE	CREDITO_BANCARIO
		SET		K_ESTATUS_CREDITO_BANCARIO	= 5,		--5	EN PAGOS
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_CREDITO_BANCARIO		= @PP_K_CREDITO_BANCARIO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el Credito Bancario a [En Pagos]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CREDITO_BANCARIO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'EN PAGOS',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CREDITO_BANCARIO_EN_PAGOS]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CREDITO_BANCARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO
--
-- //////////////////////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A LIQUIDADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CREDITO_BANCARIO_LIQUIDADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CREDITO_BANCARIO_LIQUIDADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_CREDITO_BANCARIO_LIQUIDADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_CREDITO_BANCARIO			[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_CREDITO_BANCARIO		AS INT
	DECLARE @VP_D_ESTATUS_CREDITO_BANCARIO		AS VARCHAR(100)

	SELECT @VP_K_ESTATUS_CREDITO_BANCARIO	=	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO,
			@VP_D_ESTATUS_CREDITO_BANCARIO	=	D_ESTATUS_CREDITO_BANCARIO
												FROM	CREDITO_BANCARIO,ESTATUS_CREDITO_BANCARIO
												WHERE	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO=ESTATUS_CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO
												AND		K_CREDITO_BANCARIO	=@PP_K_CREDITO_BANCARIO

	-- /////////////////////////////////////////////////////
	
	
	DECLARE @VP_L_PROCESAR AS INT = 0


	-- K_ESTATUS_CREDITO_BANCARIO	/	1	ABIERTO			/	2	REVISION		/	3	AUTORIZADO	/	4	RECHAZADO	/	5	EN PAGOS	/	
	--									6	LIQUIDADO		/	7	REESTRUCTURADO	/	8	CANCELADO
	

	IF @VP_K_ESTATUS_CREDITO_BANCARIO=5 --5	EN PAGOS
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El [Credito Bancario] no se puede cambiar a [Liquidado]'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_CREDITO_BANCARIO+'] que tiene actualmente'
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		
		END
	
	IF @PP_L_CONTESTA=1
		PRINT @VP_RESULTADO						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / LIQUIDADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CREDITO_BANCARIO_LIQUIDADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CREDITO_BANCARIO_LIQUIDADO]
GO

CREATE PROCEDURE [dbo].[PG_TR_CREDITO_BANCARIO_LIQUIDADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_CREDITO_BANCARIO			[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CREDITO_BANCARIO_LIQUIDADO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_L_CONTESTA,
															@PP_K_CREDITO_BANCARIO,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT																
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_CREDITO_BANCARIO	/	1	ABIERTO			/	2	REVISION		/	3	AUTORIZADO	/	4	RECHAZADO	/	5	EN PAGOS	/	
		--									6	LIQUIDADO		/	7	REESTRUCTURADO	/	8	CANCELADO
		
		UPDATE	CREDITO_BANCARIO
		SET		K_ESTATUS_CREDITO_BANCARIO	= 6,		--6	LIQUIDADO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_CREDITO_BANCARIO		= @PP_K_CREDITO_BANCARIO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el Credito Bancario a [Liquidado]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CREDITO_BANCARIO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'LIQUIDADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CREDITO_BANCARIO_LIQUIDADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CREDITO_BANCARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A RECHAZADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CREDITO_BANCARIO_RECHAZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CREDITO_BANCARIO_RECHAZADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_CREDITO_BANCARIO_RECHAZADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_CREDITO_BANCARIO			[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_CREDITO_BANCARIO		AS INT
	DECLARE @VP_D_ESTATUS_CREDITO_BANCARIO		AS VARCHAR(100)

	SELECT @VP_K_ESTATUS_CREDITO_BANCARIO	=	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO,
			@VP_D_ESTATUS_CREDITO_BANCARIO	=	D_ESTATUS_CREDITO_BANCARIO
												FROM	CREDITO_BANCARIO,ESTATUS_CREDITO_BANCARIO
												WHERE	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO=ESTATUS_CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO
												AND		K_CREDITO_BANCARIO	=@PP_K_CREDITO_BANCARIO

	-- /////////////////////////////////////////////////////
	
	
	DECLARE @VP_L_PROCESAR AS INT = 0


	-- K_ESTATUS_CREDITO_BANCARIO	/	1	ABIERTO			/	2	REVISION		/	3	AUTORIZADO	/	4	RECHAZADO	/	5	EN PAGOS	/	
	--									6	LIQUIDADO		/	7	REESTRUCTURADO	/	8	CANCELADO
	

	IF @VP_K_ESTATUS_CREDITO_BANCARIO=2 --2	REVISION
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El [Credito Bancario] no se puede cambiar a [Rechazado]'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_CREDITO_BANCARIO+'] que tiene actualmente'
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		
		END
	
	IF @PP_L_CONTESTA=1
		PRINT @VP_RESULTADO						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / LIQUIDADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CREDITO_BANCARIO_RECHAZADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CREDITO_BANCARIO_RECHAZADO]
GO

CREATE PROCEDURE [dbo].[PG_TR_CREDITO_BANCARIO_RECHAZADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_CREDITO_BANCARIO			[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CREDITO_BANCARIO_RECHAZADO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_L_CONTESTA,
															@PP_K_CREDITO_BANCARIO,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT																
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_CREDITO_BANCARIO	/	1	ABIERTO			/	2	REVISION		/	3	AUTORIZADO	/	4	RECHAZADO	/	5	EN PAGOS	/	
		--									6	LIQUIDADO		/	7	REESTRUCTURADO	/	8	CANCELADO
		
		UPDATE	CREDITO_BANCARIO
		SET		K_ESTATUS_CREDITO_BANCARIO	= 4,		--4	RECHAZADO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_CREDITO_BANCARIO		= @PP_K_CREDITO_BANCARIO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el Credito Bancario a [Rechazado]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CREDITO_BANCARIO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'RECHAZADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CREDITO_BANCARIO_RECHAZADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CREDITO_BANCARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A REESTRUCTURADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CREDITO_BANCARIO_REESTRUCTURADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CREDITO_BANCARIO_REESTRUCTURADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_CREDITO_BANCARIO_REESTRUCTURADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_CREDITO_BANCARIO			[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_CREDITO_BANCARIO		AS INT
	DECLARE @VP_D_ESTATUS_CREDITO_BANCARIO		AS VARCHAR(100)

	SELECT @VP_K_ESTATUS_CREDITO_BANCARIO	=	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO,
			@VP_D_ESTATUS_CREDITO_BANCARIO	=	D_ESTATUS_CREDITO_BANCARIO
												FROM	CREDITO_BANCARIO,ESTATUS_CREDITO_BANCARIO
												WHERE	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO=ESTATUS_CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO
												AND		K_CREDITO_BANCARIO	=@PP_K_CREDITO_BANCARIO

	-- /////////////////////////////////////////////////////
	
	
	DECLARE @VP_L_PROCESAR AS INT = 0


	-- K_ESTATUS_CREDITO_BANCARIO	/	1	ABIERTO			/	2	REVISION		/	3	AUTORIZADO	/	4	RECHAZADO	/	5	EN PAGOS	/	
	--									6	LIQUIDADO		/	7	REESTRUCTURADO	/	8	CANCELADO
	

	IF @VP_K_ESTATUS_CREDITO_BANCARIO=5 --5	EN PAGOS
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El [Credito Bancario] no se puede cambiar a [Reestructurado]'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_CREDITO_BANCARIO+'] que tiene actualmente'
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		
		END
	
	IF @PP_L_CONTESTA=1
		PRINT @VP_RESULTADO						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / LIQUIDADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CREDITO_BANCARIO_REESTRUCTURADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CREDITO_BANCARIO_REESTRUCTURADO]
GO

CREATE PROCEDURE [dbo].[PG_TR_CREDITO_BANCARIO_REESTRUCTURADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_CREDITO_BANCARIO			[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CREDITO_BANCARIO_REESTRUCTURADO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_L_CONTESTA,
																@PP_K_CREDITO_BANCARIO,
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT																
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_CREDITO_BANCARIO	/	1	ABIERTO			/	2	REVISION		/	3	AUTORIZADO	/	4	RECHAZADO	/	5	EN PAGOS	/	
		--									6	LIQUIDADO		/	7	REESTRUCTURADO	/	8	CANCELADO
		
		UPDATE	CREDITO_BANCARIO
		SET		K_ESTATUS_CREDITO_BANCARIO	= 7,		--7	REESTRUCTURADO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_CREDITO_BANCARIO		= @PP_K_CREDITO_BANCARIO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el Credito Bancario a [Reestructurado]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CREDITO_BANCARIO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'REESTRUCTURADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CREDITO_BANCARIO_REESTRUCTURADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CREDITO_BANCARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A CANCELADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CREDITO_BANCARIO_CANCELADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CREDITO_BANCARIO_CANCELADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_CREDITO_BANCARIO_CANCELADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_CREDITO_BANCARIO			[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_CREDITO_BANCARIO		AS INT
	DECLARE @VP_D_ESTATUS_CREDITO_BANCARIO		AS VARCHAR(100)

	SELECT @VP_K_ESTATUS_CREDITO_BANCARIO	=	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO,
			@VP_D_ESTATUS_CREDITO_BANCARIO	=	D_ESTATUS_CREDITO_BANCARIO
												FROM	CREDITO_BANCARIO,ESTATUS_CREDITO_BANCARIO
												WHERE	CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO=ESTATUS_CREDITO_BANCARIO.K_ESTATUS_CREDITO_BANCARIO
												AND		K_CREDITO_BANCARIO	=@PP_K_CREDITO_BANCARIO

	-- /////////////////////////////////////////////////////
	
	
	DECLARE @VP_L_PROCESAR AS INT = 0


	-- K_ESTATUS_CREDITO_BANCARIO	/	1	ABIERTO			/	2	REVISION		/	3	AUTORIZADO	/	4	RECHAZADO	/	5	EN PAGOS	/	
	--									6	LIQUIDADO		/	7	REESTRUCTURADO	/	8	CANCELADO
	
	------------------------1	ABIERTO		             2	REVISION					 3	AUTORIZADO					5	EN PAGOS
	IF @VP_K_ESTATUS_CREDITO_BANCARIO=1 OR @VP_K_ESTATUS_CREDITO_BANCARIO=2 OR @VP_K_ESTATUS_CREDITO_BANCARIO=3 OR @VP_K_ESTATUS_CREDITO_BANCARIO=5 
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El [Credito Bancario] no se puede cambiar a [Cancelado]'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_CREDITO_BANCARIO+'] que tiene actualmente'
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		
		END
	
	IF @PP_L_CONTESTA=1
		PRINT @VP_RESULTADO						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> TRANSICION / CANCELADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CREDITO_BANCARIO_CANCELADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CREDITO_BANCARIO_CANCELADO]
GO

CREATE PROCEDURE [dbo].[PG_TR_CREDITO_BANCARIO_CANCELADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_CREDITO_BANCARIO			[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CREDITO_BANCARIO_CANCELADO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_L_CONTESTA,
															@PP_K_CREDITO_BANCARIO,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT																
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		-- K_ESTATUS_CREDITO_BANCARIO	/	1	ABIERTO			/	2	REVISION		/	3	AUTORIZADO	/	4	RECHAZADO	/	5	EN PAGOS	/	
		--									6	LIQUIDADO		/	7	REESTRUCTURADO	/	8	CANCELADO
		
		UPDATE	CREDITO_BANCARIO
		SET		K_ESTATUS_CREDITO_BANCARIO	= 8,		--8	CANCELADO
				-- ====================
				[F_CAMBIO]					= GETDATE(), 
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION 
		WHERE	K_CREDITO_BANCARIO		= @PP_K_CREDITO_BANCARIO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN		
		SET		@VP_MENSAJE = 'No es posible [Promover] el Credito Bancario a [Cancelado]  : ' + @VP_MENSAJE 		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CREDITO_BANCARIO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CANCELADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CREDITO_BANCARIO_CANCELADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CREDITO_BANCARIO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////////////////////




-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////