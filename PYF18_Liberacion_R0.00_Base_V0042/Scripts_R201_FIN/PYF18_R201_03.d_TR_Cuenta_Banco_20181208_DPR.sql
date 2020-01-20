-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:		PYF18_Finanzas
-- // MODULO:				Cuenta Banco WORKFLOW
-- // OPERACION:			LIBERACION / REGLAS NEGOCIO
-- ////////////////////////////////////////////////////////////// 
-- // Autor:				Laura Barraza Gameros 
-- // Modificador:			Daniel Portillo Romero
-- // Fecha creación:		12/NOV/2018
-- // Fecha modificación:	08/DIC/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN VALIDACION ACTIVABLE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CUENTA_BANCO_ES_ACTIVABLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CUENTA_BANCO_ES_ACTIVABLE]
GO

CREATE PROCEDURE [dbo].[PG_RN_CUENTA_BANCO_ES_ACTIVABLE]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_CUENTA_BANCO				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_CUENTA_BANCO AS INT
	DECLARE @VP_D_ESTATUS_CUENTA_BANCO AS VARCHAR(100)

	SELECT	@VP_K_ESTATUS_CUENTA_BANCO	=	CUENTA_BANCO.K_ESTATUS_CUENTA_BANCO,
			@VP_D_ESTATUS_CUENTA_BANCO	=	D_ESTATUS_CUENTA_BANCO
											FROM	CUENTA_BANCO,ESTATUS_CUENTA_BANCO
											WHERE	CUENTA_BANCO.K_ESTATUS_CUENTA_BANCO=ESTATUS_CUENTA_BANCO.K_ESTATUS_CUENTA_BANCO
											AND		K_CUENTA_BANCO	=	@PP_K_CUENTA_BANCO

	-- /////////////////////////////////////////////////////
	
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	--K_ESTATUS_CUENTA_BANCO	0	SIN DEFINIR		1	ACTIVA		2	INACTIVA	
	IF @VP_K_ESTATUS_CUENTA_BANCO<>1
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'La [Cuenta Bancaria] no se puede cambiar a [Activa] '
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_CUENTA_BANCO+'] que tiene actualmente'
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
-- // STORED PROCEDURE ---> TR VALIDACION
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CUENTA_BANCO_ACTIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CUENTA_BANCO_ACTIVA]
GO

CREATE PROCEDURE [dbo].[PG_TR_CUENTA_BANCO_ACTIVA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_CUENTA_BANCO				[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_BANCO_ES_ACTIVABLE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_L_CONTESTA,
															@PP_K_CUENTA_BANCO,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT		
	
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_CUENTA_BANCO	0	SIN DEFINIR		1	ACTIVA		2	INACTIVA		
		
		UPDATE	CUENTA_BANCO
		SET		K_ESTATUS_CUENTA_BANCO	= 1,		--	1	ACTIVO	
				-- ====================
				[F_CAMBIO]	= GETDATE(), 
				[K_USUARIO_CAMBIO]	= @PP_K_USUARIO_ACCION 
		WHERE	K_CUENTA_BANCO	= @PP_K_CUENTA_BANCO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] la Cuenta Banco a [Activa]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_BANCO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'ACTIVA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CUENTA_BANCO_ACTIVA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CAMBIAR A INACTIVA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CUENTA_BANCO_INACTIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CUENTA_BANCO_INACTIVA]
GO


CREATE PROCEDURE [dbo].[PG_RN_CUENTA_BANCO_INACTIVA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_CUENTA_BANCO				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_ESTATUS_CUENTA_BANCO AS INT
	DECLARE @VP_D_ESTATUS_CUENTA_BANCO AS VARCHAR(100)

	SELECT	@VP_K_ESTATUS_CUENTA_BANCO	=	CUENTA_BANCO.K_ESTATUS_CUENTA_BANCO,
			@VP_D_ESTATUS_CUENTA_BANCO	=	D_ESTATUS_CUENTA_BANCO
											FROM	CUENTA_BANCO,ESTATUS_CUENTA_BANCO
											WHERE	CUENTA_BANCO.K_ESTATUS_CUENTA_BANCO=ESTATUS_CUENTA_BANCO.K_ESTATUS_CUENTA_BANCO
											AND		K_CUENTA_BANCO	=	@PP_K_CUENTA_BANCO

	-- /////////////////////////////////////////////////////
	
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	--K_ESTATUS_CUENTA_BANCO	0	SIN DEFINIR		1	ACTIVA		2	INACTIVA	
	IF @VP_K_ESTATUS_CUENTA_BANCO<>2
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'La [Cuenta Bancaria] no se puede cambiar a [Inactiva] '
		SET @VP_RESULTADO =  @VP_RESULTADO + ' debido al estatus ['+ @VP_D_ESTATUS_CUENTA_BANCO+'] que tiene actualmente'
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
-- // STORED PROCEDURE ---> TRANSICION / INACTIVA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_CUENTA_BANCO_INACTIVA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_CUENTA_BANCO_INACTIVA]
GO

CREATE PROCEDURE [dbo].[PG_TR_CUENTA_BANCO_INACTIVA]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================
	@PP_L_CONTESTA					[INT],
	-- ===========================		
	@PP_K_CUENTA_BANCO				[INT]
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_BANCO_INACTIVA]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_L_CONTESTA,
														@PP_K_CUENTA_BANCO,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT		
	
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--K_ESTATUS_CUENTA_BANCO	0	SIN DEFINIR		1	ACTIVA		2	INACTIVA		
		
		UPDATE	CUENTA_BANCO
		SET		K_ESTATUS_CUENTA_BANCO	= 2,		--	1	ACTIVO	
				-- ====================
				[F_CAMBIO]	= GETDATE(), 
				[K_USUARIO_CAMBIO]	= @PP_K_USUARIO_ACCION 
		WHERE	K_CUENTA_BANCO	= @PP_K_CUENTA_BANCO
		
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Promover] la Cuenta Banco a [Inactiva]  : ' + @VP_MENSAJE 
		
		END
	
	IF @PP_L_CONTESTA=1
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_BANCO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INACTIVA',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_TR_CUENTA_BANCO_INACTIVA]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
