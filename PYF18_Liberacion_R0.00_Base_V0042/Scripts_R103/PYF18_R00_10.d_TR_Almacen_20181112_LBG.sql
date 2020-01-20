-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			Almacen WORKFLOW
-- // OPERACION:		LIBERACION / REGLAS NEGOCIO
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			Lola 
-- // Fecha creación:	12/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A ACTIVO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_ALMACEN_ACTIVO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_ALMACEN_ACTIVO]
GO


CREATE PROCEDURE [dbo].[PG_RN_ALMACEN_ACTIVO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_ALMACEN		[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_ALMACEN AS INT
	DECLARE @VP_D_ESTATUS_ALMACEN AS VARCHAR(100)

	SELECT	@VP_K_ESTATUS_ALMACEN	=	ALMACEN.K_ESTATUS_ALMACEN,
			@VP_D_ESTATUS_ALMACEN	=	D_ESTATUS_ALMACEN
										FROM	ALMACEN,ESTATUS_ALMACEN
										WHERE	ALMACEN.K_ESTATUS_ALMACEN=ESTATUS_ALMACEN.K_ESTATUS_ALMACEN
										AND		K_ALMACEN	=	@PP_K_ALMACEN

	-- /////////////////////////////////////////////////////
	
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	--K_ESTATUS_ALMACEN	/	1	ACTIVO	/	2	MANTENIMIENTO	/	3	SUSPENDIDO	/	4	CLAUSURADO	

	IF @VP_K_ESTATUS_ALMACEN<>1
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El [Almacen] no se puede cambiar a [Activo] '
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_ALMACEN+'] que tiene actualmente'
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
-- // STORED PROCEDURE ---> TRANSICION / ACTIVO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_ALMACEN_ACTIVO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_ALMACEN_ACTIVO]
GO

CREATE PROCEDURE [dbo].[PG_TR_ALMACEN_ACTIVO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_ALMACEN		[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ALMACEN_ACTIVO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_L_CONTESTA,
												@PP_K_ALMACEN,
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT		
	
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_ALMACEN	/	1	ACTIVO	/	2	MANTENIMIENTO	/	3	SUSPENDIDO	/	4	CLAUSURADO		
		
		UPDATE	ALMACEN
		SET		K_ESTATUS_ALMACEN	= 1,		--	1	ACTIVO	
				-- ====================
				[F_CAMBIO]	= GETDATE(), 
				[K_USUARIO_CAMBIO]	= @PP_K_USUARIO_ACCION 
		WHERE	K_ALMACEN	= @PP_K_ALMACEN
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el almacen a [Activo]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ALMACEN AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'ACTIVO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_ALMACEN_ACTIVO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_ALMACEN, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A MANTENIMIENTO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_ALMACEN_MANTENIMIENTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_ALMACEN_MANTENIMIENTO]
GO


CREATE PROCEDURE [dbo].[PG_RN_ALMACEN_MANTENIMIENTO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_ALMACEN		[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO			VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_ALMACEN AS INT
	DECLARE @VP_D_ESTATUS_ALMACEN AS VARCHAR(100)

	SELECT	@VP_K_ESTATUS_ALMACEN	=	ALMACEN.K_ESTATUS_ALMACEN,
			@VP_D_ESTATUS_ALMACEN	=	D_ESTATUS_ALMACEN
										FROM	ALMACEN,ESTATUS_ALMACEN
										WHERE	ALMACEN.K_ESTATUS_ALMACEN=ESTATUS_ALMACEN.K_ESTATUS_ALMACEN
										AND		K_ALMACEN	=	@PP_K_ALMACEN

	-- /////////////////////////////////////////////////////
	
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	--K_ESTATUS_ALMACEN	/	1	ACTIVO	/	2	MANTENIMIENTO	/	3	SUSPENDIDO	/	4	CLAUSURADO	

	IF @VP_K_ESTATUS_ALMACEN<>2
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El [Almacen] no se puede cambiar a [Mantenimiento] '
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_ALMACEN+'] que tiene actualmente'
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
-- // STORED PROCEDURE ---> TRANSICION / MANTENIMIENTO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_ALMACEN_MANTENIMIENTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_ALMACEN_MANTENIMIENTO]
GO

CREATE PROCEDURE [dbo].[PG_TR_ALMACEN_MANTENIMIENTO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_ALMACEN		[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ALMACEN_MANTENIMIENTO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_L_CONTESTA,
														@PP_K_ALMACEN,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT		
	
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_ALMACEN	/	1	ACTIVO	/	2	MANTENIMIENTO	/	3	SUSPENDIDO	/	4	CLAUSURADO		
		
		UPDATE	ALMACEN
		SET		K_ESTATUS_ALMACEN	= 2,		--	2	MANTENIMIENTO
				-- ====================
				[F_CAMBIO]			= GETDATE(), 
				[K_USUARIO_CAMBIO]	= @PP_K_USUARIO_ACCION 
		WHERE	K_ALMACEN			= @PP_K_ALMACEN
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el almacen a [Mantenimiento]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ALMACEN AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'MANTENIMIENTO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_ALMACEN_MANTENIMIENTO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_ALMACEN, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A SUSPENDIDO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_ALMACEN_SUSPENDIDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_ALMACEN_SUSPENDIDO]
GO


CREATE PROCEDURE [dbo].[PG_RN_ALMACEN_SUSPENDIDO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_ALMACEN		[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_ALMACEN AS INT
	DECLARE @VP_D_ESTATUS_ALMACEN AS VARCHAR(100)

	SELECT	@VP_K_ESTATUS_ALMACEN	=	ALMACEN.K_ESTATUS_ALMACEN,
			@VP_D_ESTATUS_ALMACEN	=	D_ESTATUS_ALMACEN
										FROM	ALMACEN,ESTATUS_ALMACEN
										WHERE	ALMACEN.K_ESTATUS_ALMACEN=ESTATUS_ALMACEN.K_ESTATUS_ALMACEN
										AND		K_ALMACEN	=@PP_K_ALMACEN

	-- /////////////////////////////////////////////////////
	
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	--K_ESTATUS_ALMACEN	/	1	ACTIVO	/	2	MANTENIMIENTO	/	3	SUSPENDIDO	/	4	CLAUSURADO	

	IF @VP_K_ESTATUS_ALMACEN<>3
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El [Almacen] no se puede cambiar a [Suspendido] '
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_ALMACEN+'] que tiene actualmente'
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
-- // STORED PROCEDURE ---> TRANSICION / SUSPENDIDO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_ALMACEN_SUSPENDIDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_ALMACEN_SUSPENDIDO]
GO

CREATE PROCEDURE [dbo].[PG_TR_ALMACEN_SUSPENDIDO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_ALMACEN		[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ALMACEN_SUSPENDIDO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_L_CONTESTA,
													@PP_K_ALMACEN,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT		
	
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_ALMACEN	/	1	ACTIVO	/	2	MANTENIMIENTO	/	3	SUSPENDIDO	/	4	CLAUSURADO		
		
		UPDATE	ALMACEN
		SET		K_ESTATUS_ALMACEN			= 3,		--	3	SUSPENDIDO	
				-- ====================
				F_CAMBIO					= GETDATE(), 
				K_USUARIO_CAMBIO			= @PP_K_USUARIO_ACCION 
		WHERE	K_ALMACEN	= @PP_K_ALMACEN
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el almacen a [Suspendido]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ALMACEN AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SUSPENDIDO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_ALMACEN_SUSPENDIDO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_ALMACEN, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A CLAUSURADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_ALMACEN_CLAUSURADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_ALMACEN_CLAUSURADO]
GO


CREATE PROCEDURE [dbo].[PG_RN_ALMACEN_CLAUSURADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_ALMACEN		[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_ALMACEN AS INT
	DECLARE @VP_D_ESTATUS_ALMACEN AS VARCHAR(100)

	SELECT @VP_K_ESTATUS_ALMACEN	=	ALMACEN.K_ESTATUS_ALMACEN,
			@VP_D_ESTATUS_ALMACEN	=	D_ESTATUS_ALMACEN
										FROM	ALMACEN,ESTATUS_ALMACEN
										WHERE	ALMACEN.K_ESTATUS_ALMACEN=ESTATUS_ALMACEN.K_ESTATUS_ALMACEN
										AND		K_ALMACEN	=@PP_K_ALMACEN

	-- /////////////////////////////////////////////////////
	
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	--K_ESTATUS_ALMACEN	/	1	ACTIVO	/	2	MANTENIMIENTO	/	3	SUSPENDIDO	/	4	CLAUSURADO	

	IF @VP_K_ESTATUS_ALMACEN<>4
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El [Almacen] no se puede cambiar a [Clausurado] '
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_ALMACEN+'] que tiene actualmente'
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
-- // STORED PROCEDURE ---> TRANSICION / CLAUSURADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_ALMACEN_CLAUSURADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_ALMACEN_CLAUSURADO]
GO

CREATE PROCEDURE [dbo].[PG_TR_ALMACEN_CLAUSURADO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_ALMACEN		[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ALMACEN_CLAUSURADO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_L_CONTESTA,
													@PP_K_ALMACEN,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT		
	
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_ALMACEN	/	1	ACTIVO	/	2	MANTENIMIENTO	/	3	SUSPENDIDO	/	4	CLAUSURADO		
		
		UPDATE	ALMACEN
		SET		K_ESTATUS_ALMACEN			= 4,		--	4	CLAUSURADO	
				-- ====================
				F_CAMBIO					= GETDATE(), 
				K_USUARIO_CAMBIO			= @PP_K_USUARIO_ACCION 
		WHERE	K_ALMACEN	= @PP_K_ALMACEN
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] el almacen a [Clausurado]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ALMACEN AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'CLAUSURADO',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_ALMACEN_CLAUSURADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_ALMACEN, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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
