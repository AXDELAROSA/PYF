-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			ORGANIZACION / UNIDAD OPERATIVA
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_ZONA_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_ZONA_UO]
GO


CREATE PROCEDURE [dbo].[PG_LI_ZONA_UO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================	
	@PP_D_ZONA_UO			VARCHAR(255),
	@PP_K_ESTATUS_ACTIVO	INT
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

	IF @VP_MENSAJE=''
		BEGIN
	
		DECLARE @VP_INT_NUMERO_REGISTROS	INT
	
		EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																			@VP_L_APLICAR_MAX_ROWS,		
																			@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
		-- =========================================		

		DECLARE @VP_K_FOLIO		INT

		EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_D_ZONA_UO, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
		-- =========================================

	
		SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
				ZONA_UO.*,
				D_ESTATUS_ACTIVO, S_ESTATUS_ACTIVO, D_USUARIO AS D_USUARIO_CAMBIO
		FROM	ZONA_UO, ESTATUS_ACTIVO, USUARIO
		WHERE	ZONA_UO.L_ZONA_UO=ESTATUS_ACTIVO.K_ESTATUS_ACTIVO
		AND		ZONA_UO.L_BORRADO=0
		AND		ZONA_UO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
		AND		(	
					D_ZONA_UO		LIKE '%'+@PP_D_ZONA_UO+'%' 
				OR	K_ZONA_UO=@VP_K_FOLIO 
				)	
		AND		( @PP_K_ESTATUS_ACTIVO=-1	OR		ZONA_UO.L_ZONA_UO=@PP_K_ESTATUS_ACTIVO )
		ORDER BY D_ZONA_UO

				
		END
	ELSE
		BEGIN	-- RESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

		SELECT	ZONA_UO.*,
				D_ESTATUS_ACTIVO, S_ESTATUS_ACTIVO
		FROM	ZONA_UO, ESTATUS_ACTIVO
		WHERE	ZONA_UO.L_ZONA_UO=ESTATUS_ACTIVO.K_ESTATUS_ACTIVO
		AND		ZONA_UO.K_ZONA_UO<0

		END

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_ZONA_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_ZONA_UO, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_ZONA_UO', '', '', ''

	-- ////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_ZONA_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_ZONA_UO]
GO


CREATE PROCEDURE [dbo].[PG_SK_ZONA_UO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_ZONA_UO			INT
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
	
		SELECT	ZONA_UO.*
		FROM	ZONA_UO
		WHERE	L_BORRADO=0
		AND		ZONA_UO.K_ZONA_UO=@PP_K_ZONA_UO
		
		END
	ELSE
		BEGIN	-- RESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

		SELECT	ZONA_UO.*
		FROM	ZONA_UO
		WHERE	ZONA_UO.K_ZONA_UO<0

		END

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_ZONA_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_ZONA_UO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@', '', '', ''
	-- //////////////////////////////////////////
GO


	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////P

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_ZONA_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_ZONA_UO]
GO


CREATE PROCEDURE [dbo].[PG_IN_ZONA_UO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_D_ZONA_UO			VARCHAR(100),
	@PP_C_ZONA_UO			VARCHAR(500),
	@PP_S_ZONA_UO			VARCHAR(10),
	@PP_O_ZONA_UO			INT,
	@PP_L_ZONA_UO			INT
	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_ZONA_UO	INT = 0
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ZONA_UO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@VP_K_ZONA_UO, @PP_D_ZONA_UO,
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////


	
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'ZONA_UO', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_ZONA_UO			OUTPUT

		-- //////////////////////////////////////////////////////////////
		

		INSERT INTO ZONA_UO
			(	[K_ZONA_UO],	[D_ZONA_UO],
				[C_ZONA_UO],	[S_ZONA_UO], 
				[O_ZONA_UO],	[L_ZONA_UO],
				-- ===========================

				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_ZONA_UO,	@PP_D_ZONA_UO,
				@PP_C_ZONA_UO,	@PP_S_ZONA_UO,
				@PP_O_ZONA_UO,	@PP_L_ZONA_UO,
				-- ===========================

				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [ZONA_UO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@VP_K_ZONA_UO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_ZONA_UO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_ZONA_UO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_ZONA_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_ZONA_UO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_ZONA_UO, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_ZONA_UO', '', '', ''
	-- //////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> ACTUALIZAR / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ZONA_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_ZONA_UO]
GO

CREATE PROCEDURE [dbo].[PG_UP_ZONA_UO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_ZONA_UO			INT,
	@PP_D_ZONA_UO			VARCHAR(100),
	@PP_C_ZONA_UO			VARCHAR(500),
	@PP_S_ZONA_UO			VARCHAR(100),
	@PP_O_ZONA_UO			INT,
	@PP_L_ZONA_UO			INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ZONA_UO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_ZONA_UO, @PP_D_ZONA_UO,
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	ZONA_UO
		SET		
				
				[D_ZONA_UO] =	@PP_D_ZONA_UO,
				[C_ZONA_UO] =	@PP_C_ZONA_UO, 
				[S_ZONA_UO] =	@PP_S_ZONA_UO, 
				[O_ZONA_UO] =	@PP_O_ZONA_UO, 
				[L_ZONA_UO] =	@PP_L_ZONA_UO,
				-- ===========================

				-- ====================
				[F_CAMBIO]			=	GETDATE(), 
				[K_USUARIO_CAMBIO]	=	@PP_K_USUARIO_ACCION
		WHERE	K_ZONA_UO=@PP_K_ZONA_UO
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [ZONA_UO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@PP_K_ZONA_UO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ZONA_UO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ZONA_UO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_ZONA_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_ZONA_UO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_ZONA_UO, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_ZONA_UO', '', '', ''

	-- //////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_ZONA_UO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_ZONA_UO]
GO


CREATE PROCEDURE [dbo].[PG_DL_ZONA_UO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_ZONA_UO			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_ZONA_UO_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_ZONA_UO, 
												@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
	--	DELETE
	--	FROM	ZONA_UO
	--	WHERE	ZONA_UO.K_ZONA_UO=@PP_K_ZONA_UO

		UPDATE	ZONA_UO
		SET		
				[L_BORRADO]		 =	1,
				-- ====================
				[F_BAJA]		 =	GETDATE(), 
				[K_USUARIO_BAJA] =	@PP_K_USUARIO_ACCION
		WHERE	K_ZONA_UO=@PP_K_ZONA_UO
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la [ZONA_UO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@PP_K_ZONA_UO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ZONA_UO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_ZONA_UO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_ZONA_UO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_ZONA_UO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- //////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
