-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			TRASPASO
-- // OPERACION:		LIBERACION / STORED PROCEDURES
-- //////////////////////////////////////////////////////////////
-- // Autor:			DANIEL PORTILLO	ROMERO
-- // Fecha creación:	18/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////
/*
SELECT * FROM TRASPASO

EXECUTE [PG_LI_TRASPASO]	0,0,0,
							'',
							-1, -1, -1, -1, -1,
							NULL, NULL
*/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_TRASPASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_TRASPASO]
GO


CREATE PROCEDURE [dbo].[PG_LI_TRASPASO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ==============================================	
	@PP_BUSCAR							VARCHAR(200),
	@PP_K_ZONA_UO						INT,
	@PP_K_UNIDAD_OPERATIVA				INT,
	-- ==============================================	
	@PP_K_TIPO_TRASPASO					INT,
	@PP_K_ESTATUS_TRASPASO				INT,
	@PP_K_CONCEPTO_TRASPASO				INT,
	@PP_K_RUBRO_PRESUPUESTO				INT,
	-- ==============================================
	@PP_F_INICIAL						DATE,
	@PP_F_FINAL							DATE
AS

	DECLARE @VP_MENSAJE					VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS		INT = 1
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS	INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_LI_N_REGISTROS		OUTPUT	
	-- =========================================		

	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]		@PP_BUSCAR, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
	
	DECLARE @VP_L_VER_BORRADOS		INT		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	-- =========================================

--	SET @VP_LI_N_REGISTROS = 1000	-- WIWI

	SELECT	TOP (@VP_LI_N_REGISTROS)
			D_TIEMPO_FECHA AS F_OPERACION_DDMMMYYYY,
			TRASPASO.*,
			D_USUARIO AS D_USUARIO_CAMBIO,
			-- =====================			
			D_TIPO_TRASPASO, D_ESTATUS_TRASPASO, D_CONCEPTO_TRASPASO, D_UNIDAD_OPERATIVA, D_RUBRO_PRESUPUESTO, 
			S_TIPO_TRASPASO, S_ESTATUS_TRASPASO, S_CONCEPTO_TRASPASO, S_UNIDAD_OPERATIVA, S_RUBRO_PRESUPUESTO 
			-- =====================
	FROM	TRASPASO, 
			TIPO_TRASPASO, ESTATUS_TRASPASO, 
			CONCEPTO_TRASPASO, UNIDAD_OPERATIVA, 
			RUBRO_PRESUPUESTO, USUARIO, TIEMPO_FECHA					
			-- =====================
	WHERE	TRASPASO.K_TIPO_TRASPASO=TIPO_TRASPASO.K_TIPO_TRASPASO	
	AND		TRASPASO.K_RUBRO_PRESUPUESTO=RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO					
	AND		TRASPASO.K_ESTATUS_TRASPASO=ESTATUS_TRASPASO.K_ESTATUS_TRASPASO
	AND		TRASPASO.K_CONCEPTO_TRASPASO=CONCEPTO_TRASPASO.K_CONCEPTO_TRASPASO
	AND		TRASPASO.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND		TRASPASO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		TRASPASO.F_OPERACION=TIEMPO_FECHA.F_TIEMPO_FECHA
			-- =====================
	AND		(		TRASPASO.K_TRASPASO=@VP_K_FOLIO 
				OR	TRASPASO.D_TRASPASO							LIKE '%'+@PP_BUSCAR+'%' 
				OR	TRASPASO.C_TRASPASO							LIKE '%'+@PP_BUSCAR+'%' 
				OR	CONCEPTO_TRASPASO.D_CONCEPTO_TRASPASO		LIKE '%'+@PP_BUSCAR+'%' 
				OR	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA			LIKE '%'+@PP_BUSCAR+'%' 
			)	
			-- =====================
	AND		( @PP_F_INICIAL IS NULL			OR	@PP_F_INICIAL<=TRASPASO.F_OPERACION )
	AND		( @PP_F_FINAL IS NULL			OR	TRASPASO.F_OPERACION<=@PP_F_FINAL )
			-- =====================
	AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA )
	AND		( @PP_K_ZONA_UO=-1				OR	UNIDAD_OPERATIVA.K_ZONA_UO=@PP_K_ZONA_UO )
			-- =====================
	AND		( @PP_K_TIPO_TRASPASO=-1		OR	TRASPASO.K_TIPO_TRASPASO=@PP_K_TIPO_TRASPASO )
	AND		( @PP_K_RUBRO_PRESUPUESTO=-1	OR	TRASPASO.K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO )
	AND		( @PP_K_ESTATUS_TRASPASO=-1		OR	TRASPASO.K_ESTATUS_TRASPASO=@PP_K_ESTATUS_TRASPASO )
	AND		( @PP_K_CONCEPTO_TRASPASO=-1	OR	TRASPASO.K_CONCEPTO_TRASPASO=@PP_K_CONCEPTO_TRASPASO )
	AND		( TRASPASO.L_BORRADO=0			OR	@VP_L_VER_BORRADOS=1 )	
			-- =====================		
	ORDER BY K_TRASPASO DESC
			
	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_TRASPASO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_BUSCAR, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_BUSCAR', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_TRASPASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_TRASPASO]
GO


CREATE PROCEDURE [dbo].[PG_SK_TRASPASO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_TRASPASO				INT
AS

	DECLARE @VP_MENSAJE			VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_L_VER_BORRADOS		INT		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT = 100

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	-- =========================================
		
	SELECT	TOP (@VP_LI_N_REGISTROS)
			TRASPASO.*, 
			D_USUARIO AS D_USUARIO_CAMBIO,		
			-- =====================			
			D_TIPO_TRASPASO, D_ESTATUS_TRASPASO, D_CONCEPTO_TRASPASO, D_UNIDAD_OPERATIVA, D_RUBRO_PRESUPUESTO, 
			S_TIPO_TRASPASO, S_ESTATUS_TRASPASO, S_CONCEPTO_TRASPASO, S_UNIDAD_OPERATIVA, S_RUBRO_PRESUPUESTO 
			-- =====================
	FROM	TRASPASO, 
			TIPO_TRASPASO, ESTATUS_TRASPASO, 
			CONCEPTO_TRASPASO, UNIDAD_OPERATIVA, 
			RUBRO_PRESUPUESTO, USUARIO, TIEMPO_FECHA					
			-- =====================
	WHERE	TRASPASO.K_TIPO_TRASPASO=TIPO_TRASPASO.K_TIPO_TRASPASO	
	AND		TRASPASO.K_RUBRO_PRESUPUESTO=RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO					
	AND		TRASPASO.K_ESTATUS_TRASPASO=ESTATUS_TRASPASO.K_ESTATUS_TRASPASO
	AND		TRASPASO.K_CONCEPTO_TRASPASO=CONCEPTO_TRASPASO.K_CONCEPTO_TRASPASO
	AND		TRASPASO.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND		TRASPASO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		TRASPASO.F_OPERACION=TIEMPO_FECHA.F_TIEMPO_FECHA
	AND		TRASPASO.K_TRASPASO=@PP_K_TRASPASO
		
	-----////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_TRASPASO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_TRASPASO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_TRASPASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_TRASPASO]
GO



CREATE PROCEDURE [dbo].[PG_IN_TRASPASO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_D_TRASPASO					VARCHAR(255),
	@PP_K_TIPO_TRASPASO				INT,		
	@PP_K_CONCEPTO_TRASPASO			INT,
	@PP_K_RUBRO_PRESUPUESTO			INT,		
	@PP_L_CAPTURA_MANUAL			INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_C_TRASPASO					VARCHAR(255),
	@PP_MONTO_APLICAR				DECIMAL(19,4),
	@PP_F_OPERACION					DATE
	
AS			

	DECLARE @VP_K_ESTATUS_TRASPASO			INT = 1
	DECLARE @VP_O_TRASPASO					INT = 0


	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_TRASPASO				INT = 0
	
	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'TRASPASO', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_TRASPASO			OUTPUT
	-- ==================================
		
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TRASPASO_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@VP_K_TRASPASO,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ==================================
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TRASPASO_RUBRO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_RUBRO_PRESUPUESTO,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT		
	-- ==================================

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TRASPASO_COMENTARIOS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_TIPO_TRASPASO, @PP_C_TRASPASO,	
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ==================================

	IF @VP_MENSAJE=''
		BEGIN
		
		DECLARE @VP_K_YYYY INT
		SET @VP_K_YYYY=YEAR(@PP_F_OPERACION)

		DECLARE @VP_K_MM INT
		SET @VP_K_MM=MONTH(@PP_F_OPERACION)

		DECLARE	@VP_K_PRESUPUESTO	INT

		EXECUTE [dbo].[PG_RN_PRESUPUESTO_K_X_PARAMETROS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_UNIDAD_OPERATIVA,	@VP_K_YYYY,	@VP_K_MM,
															@OU_K_PRESUPUESTO=	@VP_K_PRESUPUESTO	OUTPUT
															
		-- K_TIPO_TRASPASO	1	TRASPASO PROGRAMADO		2	TRASPASO EXTESION	3	TRASPASO NO PROGRAMADO		
		IF @PP_K_TIPO_TRASPASO=1
			EXECUTE [dbo].[PG_RN_PRESUPUESTO_DISPONIBLE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															0,	@VP_K_PRESUPUESTO,	@PP_K_RUBRO_PRESUPUESTO, @VP_K_TRASPASO,
															@PP_K_UNIDAD_OPERATIVA,	@VP_K_YYYY,	@VP_K_MM, @PP_MONTO_APLICAR,
															@OU_RESULTADO_VALIDACION=@VP_MENSAJE		OUTPUT

		END
	-- ===========================	


	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		-- ==================================

		DECLARE @VP_K_CLASE_TRASPASO		INT = 0

		SELECT	@VP_K_CLASE_TRASPASO =		K_CLASE_TRASPASO 
											FROM	TIPO_TRASPASO 
											WHERE	K_TIPO_TRASPASO=@PP_K_TIPO_TRASPASO
		-- ==================================

		DECLARE @VP_MONTO_APLICAR		DECIMAL(19,4)

		SET		@VP_MONTO_APLICAR = ( @PP_MONTO_APLICAR*@VP_K_CLASE_TRASPASO )

		-- ////////////////////////////////////////////////////////////////
		
		INSERT INTO TRASPASO
			(	[K_TRASPASO], 
				[D_TRASPASO], [K_TIPO_TRASPASO], 
				[K_ESTATUS_TRASPASO], [K_CONCEPTO_TRASPASO], 
				[K_RUBRO_PRESUPUESTO], [L_CAPTURA_MANUAL], 
				-- ============================================
				[F_OPERACION], 
				[K_UNIDAD_OPERATIVA], [C_TRASPASO],
				[MONTO_AUTORIZADO], [MONTO_APLICAR],				
				-- ============================================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_TRASPASO,
				@PP_D_TRASPASO, @PP_K_TIPO_TRASPASO, 
				@VP_K_ESTATUS_TRASPASO, @PP_K_CONCEPTO_TRASPASO, 
				@PP_K_RUBRO_PRESUPUESTO, @PP_L_CAPTURA_MANUAL,
				-- ============================================
				@PP_F_OPERACION, 
				@PP_K_UNIDAD_OPERATIVA, @PP_C_TRASPASO,
				@VP_MONTO_APLICAR, @VP_MONTO_APLICAR, 		
				-- ============================================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )

		-- /////////////////////////////////////////////////////////////////

		EXECUTE	[DBO].[PG_UP_PARTIDA_PRESUPUESTO_CALCULO_EJERCICIO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_UNIDAD_OPERATIVA,	@PP_F_OPERACION, @PP_K_RUBRO_PRESUPUESTO																																																																																																	
				
		-- /////////////////////////////////////////////////////////////////
		--															
		IF @PP_K_TIPO_TRASPASO<>1
			EXECUTE [DBO].[PG_AU_TRASPASO_INIT]		@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,
													@VP_K_TRASPASO		

		-- /////////////////////////////////////////////////////////////////
		
		IF @VP_MENSAJE=''
			EXECUTE [dbo].[PG_RN_TRASPASO_COMENTARIOS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_TIPO_TRASPASO, @PP_C_TRASPASO,	
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
		
		-- /////////////////////////////////////////////////////////////////

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [Traspaso]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#TRA.'+CONVERT(VARCHAR(10),@VP_K_TRASPASO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_TRASPASO AS CLAVE
	
	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_TRASPASO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_TRASPASO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_TRASPASO, '', 0.00, 0.00,
													0, 0, @PP_C_TRASPASO, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_TRASPASO', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_TRASPASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_TRASPASO]
GO

CREATE PROCEDURE [dbo].[PG_UP_TRASPASO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_TRASPASO					INT,
	@PP_D_TRASPASO					VARCHAR(255),
	@PP_K_TIPO_TRASPASO				INT,		
--	@PP_K_ESTATUS_TRASPASO			INT,
	@PP_K_CONCEPTO_TRASPASO			INT,
	@PP_K_RUBRO_PRESUPUESTO			INT,		
	@PP_L_CAPTURA_MANUAL			INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_C_TRASPASO					VARCHAR(255),
	@PP_MONTO_APLICAR				DECIMAL(19,4),
	@PP_F_OPERACION					DATE
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TRASPASO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_TRASPASO, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
				-- ==================================

		DECLARE @VP_K_CLASE_TRASPASO		INT = 0

		SELECT	@VP_K_CLASE_TRASPASO =	K_CLASE_TRASPASO 
												FROM	TIPO_TRASPASO 
												WHERE	K_TIPO_TRASPASO=@PP_K_TIPO_TRASPASO
		-- ==================================

		DECLARE @VP_MONTO_APLICAR		DECIMAL(19,4)

		SET		@VP_MONTO_APLICAR = ( @PP_MONTO_APLICAR*@VP_K_CLASE_TRASPASO )

		-- ==================================

		UPDATE	TRASPASO
		SET		
				[D_TRASPASO]				= @PP_D_TRASPASO,
				[K_TIPO_TRASPASO]			= @PP_K_TIPO_TRASPASO, 
		--		[K_ESTATUS_TRASPASO]		= @PP_K_ESTATUS_TRASPASO,
				[K_CONCEPTO_TRASPASO]		= @PP_K_CONCEPTO_TRASPASO,
				[K_RUBRO_PRESUPUESTO]		= @PP_K_RUBRO_PRESUPUESTO, 	
				[L_CAPTURA_MANUAL]			= @PP_L_CAPTURA_MANUAL,
				[F_OPERACION]				= @PP_F_OPERACION,
				[K_UNIDAD_OPERATIVA]		= @PP_K_UNIDAD_OPERATIVA,
				[C_TRASPASO]				= @PP_C_TRASPASO,
				[MONTO_AUTORIZADO]			= @VP_MONTO_APLICAR,
				[MONTO_APLICAR]				= @VP_MONTO_APLICAR,
				-- ===========================
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION, 
				[F_CAMBIO]					= GETDATE() 
		WHERE	K_TRASPASO=@PP_K_TRASPASO
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [TRASPASO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Li.'+CONVERT(VARCHAR(10),@PP_K_TRASPASO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_TRASPASO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_TRASPASO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_TRASPASO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_TRASPASO, '', 0.00, 0.00,
													0, 0, @PP_C_TRASPASO, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_TRASPASO', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_TRASPASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_TRASPASO]
GO


CREATE PROCEDURE [dbo].[PG_DL_TRASPASO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_TRASPASO				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_TRASPASO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_TRASPASO, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	TRASPASO
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_TRASPASO=@PP_K_TRASPASO

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [TRASPASO]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Li.'+CONVERT(VARCHAR(10),@PP_K_TRASPASO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_TRASPASO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_TRASPASO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_TRASPASO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
