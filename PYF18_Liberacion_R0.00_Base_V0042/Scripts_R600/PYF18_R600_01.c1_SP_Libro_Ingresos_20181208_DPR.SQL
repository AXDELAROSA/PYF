-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:		PYF18_Finanzas
-- // MODULO:				LIBRO_INGRESOS
-- // OPERACION:			LIBERACION / STORED PROCEDURES
-- //////////////////////////////////////////////////////////////
-- // Autor:				DANIEL PORTILLO	ROMERO
-- // Fecha creación:		18/SEP/2018
-- // Fecha modificación:	08/DIC/2018 (Por integración de RNs de Control)
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO


-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_LIBRO_INGRESOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_LIBRO_INGRESOS]
GO


CREATE PROCEDURE [dbo].[PG_LI_LIBRO_INGRESOS]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ==============================================	
	@PP_BUSCAR							VARCHAR(200),
	@PP_K_TIPO_LIBRO_INGRESOS			INT,
	@PP_K_ESTATUS_LIBRO_INGRESOS		INT,
	@PP_K_CONCEPTO_LIBRO_INGRESOS		INT,
	@PP_K_ZONA_UO						INT,
	@PP_K_UNIDAD_OPERATIVA				INT,
	@PP_F_INICIAL						DATE,
	@PP_F_FINAL							DATE
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT = 1
	
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
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	-- =========================================
		
	SELECT	TOP (@VP_LI_N_REGISTROS)
			D_TIEMPO_FECHA AS F_OPERACION_DDMMMYYYY,
			LIBRO_INGRESOS.*,
			D_USUARIO AS D_USUARIO_CAMBIO,		
			-- =====================
			D_TIPO_LIBRO_INGRESOS, D_ESTATUS_LIBRO_INGRESOS, D_CONCEPTO_LIBRO_INGRESOS, D_UNIDAD_OPERATIVA, 
			S_TIPO_LIBRO_INGRESOS, S_ESTATUS_LIBRO_INGRESOS, S_CONCEPTO_LIBRO_INGRESOS, S_UNIDAD_OPERATIVA 
			-- =====================
	FROM	LIBRO_INGRESOS, 
			TIPO_LIBRO_INGRESOS, ESTATUS_LIBRO_INGRESOS, 
			CONCEPTO_LIBRO_INGRESOS, UNIDAD_OPERATIVA, 
			USUARIO, TIEMPO_FECHA					
			-- =====================
	WHERE	LIBRO_INGRESOS.K_TIPO_LIBRO_INGRESOS=TIPO_LIBRO_INGRESOS.K_TIPO_LIBRO_INGRESOS					
	AND		LIBRO_INGRESOS.K_ESTATUS_LIBRO_INGRESOS=ESTATUS_LIBRO_INGRESOS.K_ESTATUS_LIBRO_INGRESOS
	AND		LIBRO_INGRESOS.K_CONCEPTO_LIBRO_INGRESOS=CONCEPTO_LIBRO_INGRESOS.K_CONCEPTO_LIBRO_INGRESOS
	AND		LIBRO_INGRESOS.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND		LIBRO_INGRESOS.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		LIBRO_INGRESOS.F_OPERACION=TIEMPO_FECHA.F_TIEMPO_FECHA
			-- =====================
	AND		(
					LIBRO_INGRESOS.K_LIBRO_INGRESOS=@VP_K_FOLIO 
				OR	LIBRO_INGRESOS.C_LIBRO_INGRESOS						LIKE '%'+@PP_BUSCAR+'%' 
				OR	CONCEPTO_LIBRO_INGRESOS.D_CONCEPTO_LIBRO_INGRESOS	LIKE '%'+@PP_BUSCAR+'%' 
				OR	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA					LIKE '%'+@PP_BUSCAR+'%' 
			)	
			-- =====================
	AND		( @PP_F_INICIAL IS NULL					OR	@PP_F_INICIAL<=F_OPERACION )
	AND		( @PP_F_FINAL IS NULL					OR	F_OPERACION<=@PP_F_FINAL )
			-- =====================
	AND		( @PP_K_TIPO_LIBRO_INGRESOS=-1			OR	LIBRO_INGRESOS.K_TIPO_LIBRO_INGRESOS=@PP_K_TIPO_LIBRO_INGRESOS )
	AND		( @PP_K_ESTATUS_LIBRO_INGRESOS=-1		OR	LIBRO_INGRESOS.K_ESTATUS_LIBRO_INGRESOS=@PP_K_ESTATUS_LIBRO_INGRESOS )
	AND		( @PP_K_CONCEPTO_LIBRO_INGRESOS=-1		OR	LIBRO_INGRESOS.K_CONCEPTO_LIBRO_INGRESOS=@PP_K_CONCEPTO_LIBRO_INGRESOS )
	AND		( @PP_K_ZONA_UO=-1						OR	UNIDAD_OPERATIVA.K_ZONA_UO=@PP_K_ZONA_UO )
	AND		( @PP_K_UNIDAD_OPERATIVA=-1				OR	LIBRO_INGRESOS.K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA )
	AND		( LIBRO_INGRESOS.L_BORRADO=0			OR	@VP_L_VER_BORRADOS=1 )	
			-- =====================		
	ORDER BY K_LIBRO_INGRESOS DESC
			
	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_LIBRO_INGRESOS]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_BUSCAR, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_BUSCAR', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_ACTA_INGRESOS_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_ACTA_INGRESOS_SQL]
GO


CREATE PROCEDURE [dbo].[PG_IN_ACTA_INGRESOS_SQL]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_TIPO_LIBRO_INGRESOS		INT,	
	@PP_K_ESTATUS_LIBRO_INGRESOS	INT,
	@PP_K_CONCEPTO_LIBRO_INGRESOS	INT,
	@PP_L_CAPTURA_MANUAL			INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_C_LIBRO_INGRESOS			[VARCHAR] (255),
	@PP_MONTO						DECIMAL(19,4),
	@PP_F_OPERACION					DATE
--	@OU_K_LIBRO_INGRESOS			INT		OUTPUT
AS			
	
	DECLARE @VP_K_LIBRO_INGRESOS				INT = 0
	
	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'ACTA_INGRESOS', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_LIBRO_INGRESOS			OUTPUT	
	-- ==================================

	DECLARE @VP_K_CLASE_LIBRO_INGRESOS		INT = 0

	SELECT	@VP_K_CLASE_LIBRO_INGRESOS =	K_CLASE_LIBRO_INGRESOS 
											FROM	TIPO_LIBRO_INGRESOS 
											WHERE	K_TIPO_LIBRO_INGRESOS=@PP_K_TIPO_LIBRO_INGRESOS
	-- ==================================

	DECLARE @VP_MONTO_APLICAR		DECIMAL(19,4)

	SET		@VP_MONTO_APLICAR = ( @PP_MONTO*@VP_K_CLASE_LIBRO_INGRESOS )

	-- ==================================

	INSERT INTO ACTA_INGRESOS
		(	[K_ACTA_INGRESOS],
			[K_TIPO_LIBRO_INGRESOS], [K_ESTATUS_LIBRO_INGRESOS],
			[K_CONCEPTO_LIBRO_INGRESOS], [L_CAPTURA_MANUAL], 
			-- ============================================
			[F_OPERACION], 
			[K_UNIDAD_OPERATIVA], [C_ACTA_INGRESOS],
			[MONTO], [MONTO_APLICAR],			
			-- ============================================
			[K_USUARIO_ALTA], [F_ALTA], 
			[K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
	VALUES	
		(	@VP_K_LIBRO_INGRESOS,
			@PP_K_TIPO_LIBRO_INGRESOS, @PP_K_ESTATUS_LIBRO_INGRESOS,
			@PP_K_CONCEPTO_LIBRO_INGRESOS, @PP_L_CAPTURA_MANUAL,
			-- ============================================
			@PP_F_OPERACION, 
			@PP_K_UNIDAD_OPERATIVA, @PP_C_LIBRO_INGRESOS,
			CONVERT(DECIMAL(19,2),@PP_MONTO), CONVERT(DECIMAL(19,2),@VP_MONTO_APLICAR), 		
			-- ============================================
			@PP_K_USUARIO_ACCION, GETDATE(), 
			@PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL )

	-- =============================================================
GO


-- ///////////////////////////////////////////////////
-- // STORED PROCEDURE --->  UP ACTA INGRESOS UPDATE
-- ///////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_ACTA_INGRESOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_ACTA_INGRESOS]
GO

CREATE PROCEDURE [dbo].[PG_UP_ACTA_INGRESOS]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_TIPO_LIBRO_INGRESOS		INT,	
	@PP_K_ESTATUS_LIBRO_INGRESOS	INT,
	@PP_K_CONCEPTO_LIBRO_INGRESOS	INT,
	@PP_L_CAPTURA_MANUAL			INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_C_LIBRO_INGRESOS			[VARCHAR] (255),
	@PP_MONTO						DECIMAL(19,4),
	@PP_F_OPERACION					DATE
--	@OU_K_LIBRO_INGRESOS			INT		OUTPUT
AS		

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	---- /////////////////////////////////////////////////////////////////////////	

	IF @VP_MENSAJE = ''
		EXECUTE [dbo].[PG_RN_ACTA_INGRESOS_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_UNIDAD_OPERATIVA, @PP_F_OPERACION,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	---- /////////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE = ''
		BEGIN

		DECLARE @VP_K_TIPO_LIBRO_INGRESOS_DESTINO	INT

		-- K_TIPO_LIBRO_INGRESOS	
		-- 101	VENTA CONTADO		/// 201	AJUSTE ERROR / VENTA CONTADO
		-- 102	VENTA CREDITO		/// 202	AJUSTE ERROR / VENTA CREDITO
		-- 103	COBRANZA			/// 203	AJUSTE ERROR / COBRANZA
		-- 104	VENTA VALE/GAS		/// 204	AJUSTE ERROR / VENTA VALE/GAS
		-- 105	VENTA ANTICIPADA	/// 205	AJUSTE ERROR / VENTA ANTICIPADA
		-- 106	VENTA CONTADO KG	/// 206	AJUSTE ERROR / VENTA CONTADO KG
		-- 107	VENTA CREDITO KG	/// 207	AJUSTE ERROR / VENTA CREDITO KG

		SET @VP_K_TIPO_LIBRO_INGRESOS_DESTINO = @PP_K_TIPO_LIBRO_INGRESOS

		---- /////////////////////////////////////////////////////////////////////////

		IF @PP_K_TIPO_LIBRO_INGRESOS = 201
			SET @VP_K_TIPO_LIBRO_INGRESOS_DESTINO = 101	

		IF @PP_K_TIPO_LIBRO_INGRESOS = 202
			SET @VP_K_TIPO_LIBRO_INGRESOS_DESTINO = 102

		IF @PP_K_TIPO_LIBRO_INGRESOS = 203
			SET @VP_K_TIPO_LIBRO_INGRESOS_DESTINO = 103	

		IF @PP_K_TIPO_LIBRO_INGRESOS = 204
			SET @VP_K_TIPO_LIBRO_INGRESOS_DESTINO = 104		

		IF @PP_K_TIPO_LIBRO_INGRESOS = 205
			SET @VP_K_TIPO_LIBRO_INGRESOS_DESTINO = 105	

		IF @PP_K_TIPO_LIBRO_INGRESOS = 206
			SET @VP_K_TIPO_LIBRO_INGRESOS_DESTINO = 106		

		IF @PP_K_TIPO_LIBRO_INGRESOS = 207
			SET @VP_K_TIPO_LIBRO_INGRESOS_DESTINO = 107	

		---- /////////////////////////////////////////////////////////////////////////

		DECLARE	@VP_K_EXISTE_ACTA			INT	

		SELECT @VP_K_EXISTE_ACTA =			MAX(K_ACTA_INGRESOS)
											FROM	ACTA_INGRESOS
											WHERE	F_OPERACION=@PP_F_OPERACION	
											AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA	
											AND		K_TIPO_LIBRO_INGRESOS=@VP_K_TIPO_LIBRO_INGRESOS_DESTINO			
		-- ================================
		
		IF @VP_K_EXISTE_ACTA IS NULL
			EXECUTE [dbo].[PG_IN_ACTA_INGRESOS_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_TIPO_LIBRO_INGRESOS_DESTINO, @PP_K_ESTATUS_LIBRO_INGRESOS, @PP_K_CONCEPTO_LIBRO_INGRESOS,
														@PP_L_CAPTURA_MANUAL, @PP_K_UNIDAD_OPERATIVA,
														@PP_C_LIBRO_INGRESOS, 0, @PP_F_OPERACION

		---- /////////////////////////////////////////////////////////////////////////
		
		DECLARE @VP_K_CLASE_LIBRO_INGRESOS		INT = 0

		SELECT	@VP_K_CLASE_LIBRO_INGRESOS =	K_CLASE_LIBRO_INGRESOS 
												FROM	TIPO_LIBRO_INGRESOS 
												WHERE	K_TIPO_LIBRO_INGRESOS=@PP_K_TIPO_LIBRO_INGRESOS
		-- ==================================

		DECLARE @VP_MONTO_SIGNO		DECIMAL(19,4)

		SET		@VP_MONTO_SIGNO = ( @PP_MONTO*@VP_K_CLASE_LIBRO_INGRESOS )

		---- /////////////////////////////////////////////////////////////////////////

		UPDATE	ACTA_INGRESOS
		SET		MONTO =  MONTO + @VP_MONTO_SIGNO
		WHERE	F_OPERACION=@PP_F_OPERACION	
		AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA	
		AND		K_TIPO_LIBRO_INGRESOS=@VP_K_TIPO_LIBRO_INGRESOS_DESTINO				

		-- ============================================================

		UPDATE	ACTA_INGRESOS
		SET		MONTO_APLICAR =  MONTO
		WHERE	F_OPERACION=@PP_F_OPERACION	
		AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA	
		AND		K_TIPO_LIBRO_INGRESOS=@VP_K_TIPO_LIBRO_INGRESOS_DESTINO				
		
		END
	
	---- /////////////////////////////////////////////////////////////////////////
GO






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_LIBRO_INGRESOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_LIBRO_INGRESOS]
GO


CREATE PROCEDURE [dbo].[PG_SK_LIBRO_INGRESOS]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_LIBRO_INGRESOS	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		[INT] = 100

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	-- =========================================
		
	SELECT	TOP (@VP_LI_N_REGISTROS)
			LIBRO_INGRESOS.*, 
			D_USUARIO AS D_USUARIO_CAMBIO,
			-- =====================
			D_TIPO_LIBRO_INGRESOS, D_ESTATUS_LIBRO_INGRESOS, D_CONCEPTO_LIBRO_INGRESOS, D_UNIDAD_OPERATIVA, 
			S_TIPO_LIBRO_INGRESOS, S_ESTATUS_LIBRO_INGRESOS, S_CONCEPTO_LIBRO_INGRESOS, S_UNIDAD_OPERATIVA 
			-- =====================
	FROM	LIBRO_INGRESOS, 
			TIPO_LIBRO_INGRESOS, ESTATUS_LIBRO_INGRESOS, 
			CONCEPTO_LIBRO_INGRESOS, UNIDAD_OPERATIVA, 
			USUARIO					
			-- =====================
	WHERE	LIBRO_INGRESOS.K_TIPO_LIBRO_INGRESOS=TIPO_LIBRO_INGRESOS.K_TIPO_LIBRO_INGRESOS					
	AND		LIBRO_INGRESOS.K_ESTATUS_LIBRO_INGRESOS=ESTATUS_LIBRO_INGRESOS.K_ESTATUS_LIBRO_INGRESOS
	AND		LIBRO_INGRESOS.K_CONCEPTO_LIBRO_INGRESOS=CONCEPTO_LIBRO_INGRESOS.K_CONCEPTO_LIBRO_INGRESOS
	AND		LIBRO_INGRESOS.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND		LIBRO_INGRESOS.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		LIBRO_INGRESOS.K_LIBRO_INGRESOS=@PP_K_LIBRO_INGRESOS
		
	-----////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_LIBRO_INGRESOS]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_LIBRO_INGRESOS, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_LIBRO_INGRESOS_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_LIBRO_INGRESOS_SQL]
GO


CREATE PROCEDURE [dbo].[PG_IN_LIBRO_INGRESOS_SQL]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_TIPO_LIBRO_INGRESOS		INT,	
	@PP_K_ESTATUS_LIBRO_INGRESOS	INT,
	@PP_K_CONCEPTO_LIBRO_INGRESOS	INT,
	@PP_L_CAPTURA_MANUAL			INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_C_LIBRO_INGRESOS			[VARCHAR] (255),
	@PP_MONTO						DECIMAL(19,4),
	@PP_F_OPERACION					DATE,
	@OU_K_LIBRO_INGRESOS			INT		OUTPUT
AS			
	
	DECLARE @VP_K_LIBRO_INGRESOS				INT = 0
	
	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'LIBRO_INGRESOS', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_LIBRO_INGRESOS			OUTPUT	
	-- ==================================

	DECLARE @VP_K_CLASE_LIBRO_INGRESOS		INT = 0

	SELECT	@VP_K_CLASE_LIBRO_INGRESOS =	K_CLASE_LIBRO_INGRESOS 
											FROM	TIPO_LIBRO_INGRESOS 
											WHERE	K_TIPO_LIBRO_INGRESOS=@PP_K_TIPO_LIBRO_INGRESOS
	-- ==================================

	DECLARE @VP_MONTO_APLICAR		DECIMAL(19,4)

	SET		@VP_MONTO_APLICAR = ( @PP_MONTO*@VP_K_CLASE_LIBRO_INGRESOS )

	-- ==================================

	IF @PP_MONTO>0
		BEGIN

		INSERT INTO LIBRO_INGRESOS
			(	[K_LIBRO_INGRESOS],
				[K_TIPO_LIBRO_INGRESOS], [K_ESTATUS_LIBRO_INGRESOS],
				[K_CONCEPTO_LIBRO_INGRESOS], [L_CAPTURA_MANUAL], 
				-- ============================================
				[F_OPERACION], 
				[K_UNIDAD_OPERATIVA], [C_LIBRO_INGRESOS],
				[MONTO], [MONTO_APLICAR],			
				-- ============================================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_LIBRO_INGRESOS,
				@PP_K_TIPO_LIBRO_INGRESOS, @PP_K_ESTATUS_LIBRO_INGRESOS,
				@PP_K_CONCEPTO_LIBRO_INGRESOS, @PP_L_CAPTURA_MANUAL,
				-- ============================================
				@PP_F_OPERACION, 
				@PP_K_UNIDAD_OPERATIVA, @PP_C_LIBRO_INGRESOS,
				CONVERT(DECIMAL(19,2),@PP_MONTO), CONVERT(DECIMAL(19,2),@VP_MONTO_APLICAR), 		
				-- ============================================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )
	
		-- ==================================

		EXECUTE [dbo].[PG_UP_ACTA_INGRESOS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_TIPO_LIBRO_INGRESOS, @PP_K_ESTATUS_LIBRO_INGRESOS, @PP_K_CONCEPTO_LIBRO_INGRESOS,
												@PP_L_CAPTURA_MANUAL, @PP_K_UNIDAD_OPERATIVA, @PP_C_LIBRO_INGRESOS,
												@PP_MONTO, @PP_F_OPERACION		
		END

	-- ==================================

	SET @OU_K_LIBRO_INGRESOS = @VP_K_LIBRO_INGRESOS
		
	-- //////////////////////////////////////////////////////////////
GO




 
-- //////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  IN LIBRO_INGRESOS INSERT
-- //////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_LIBRO_INGRESOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_LIBRO_INGRESOS]
GO

CREATE PROCEDURE [dbo].[PG_IN_LIBRO_INGRESOS]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_TIPO_LIBRO_INGRESOS		INT,	
	@PP_K_ESTATUS_LIBRO_INGRESOS	INT,
	@PP_K_CONCEPTO_LIBRO_INGRESOS	INT,
	@PP_L_CAPTURA_MANUAL			INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_C_LIBRO_INGRESOS			[VARCHAR] (255),
	@PP_MONTO						DECIMAL(19,4),
	@PP_F_OPERACION					DATE
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_LIBRO_INGRESOS				INT = 0
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_LIBRO_INGRESOS_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_LIBRO_INGRESOS,  @PP_K_UNIDAD_OPERATIVA, @PP_F_OPERACION,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
		
		EXECUTE	[dbo].[PG_IN_LIBRO_INGRESOS_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_TIPO_LIBRO_INGRESOS, @PP_K_ESTATUS_LIBRO_INGRESOS, @PP_K_CONCEPTO_LIBRO_INGRESOS,
													@PP_L_CAPTURA_MANUAL,
													@PP_K_UNIDAD_OPERATIVA, @PP_C_LIBRO_INGRESOS,
													@PP_MONTO, @PP_F_OPERACION,
													@OU_K_LIBRO_INGRESOS = @VP_K_LIBRO_INGRESOS		OUTPUT		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible <Crear> el Libro Ingresos: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#LI.'+CONVERT(VARCHAR(10),@VP_K_LIBRO_INGRESOS)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_LIBRO_INGRESOS AS CLAVE
	
	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_LIBRO_INGRESOS]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_LIBRO_INGRESOS, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_LIBRO_INGRESOS', '', '', ''

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  UP LIBRO_INGRESOS UPDATE
-- //////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_LIBRO_INGRESOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_LIBRO_INGRESOS]
GO

CREATE PROCEDURE [dbo].[PG_UP_LIBRO_INGRESOS]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_LIBRO_INGRESOS			INT,
	@PP_K_TIPO_LIBRO_INGRESOS		INT,	
	@PP_K_ESTATUS_LIBRO_INGRESOS	INT,
	@PP_K_CONCEPTO_LIBRO_INGRESOS	INT,
	@PP_L_CAPTURA_MANUAL			INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_C_LIBRO_INGRESOS			VARCHAR(100),
	@PP_MONTO						DECIMAL(19,4),
	@PP_F_OPERACION					DATE	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_LIBRO_INGRESOS_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_LIBRO_INGRESOS, @PP_K_UNIDAD_OPERATIVA, @PP_F_OPERACION,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
		
		DECLARE @VP_K_CLASE_LIBRO_INGRESOS		INT = 0

		SELECT	@VP_K_CLASE_LIBRO_INGRESOS =	K_CLASE_LIBRO_INGRESOS 
												FROM	TIPO_LIBRO_INGRESOS 
												WHERE	K_TIPO_LIBRO_INGRESOS=@PP_K_TIPO_LIBRO_INGRESOS
		-- ==================================

		DECLARE @VP_MONTO_APLICAR		DECIMAL(19,4)

		SET		@VP_MONTO_APLICAR = ( @PP_MONTO*@VP_K_CLASE_LIBRO_INGRESOS )

		-- ==================================

		UPDATE	LIBRO_INGRESOS
		SET		
				[K_TIPO_LIBRO_INGRESOS]		= @PP_K_TIPO_LIBRO_INGRESOS, 
				[K_ESTATUS_LIBRO_INGRESOS]	= @PP_K_ESTATUS_LIBRO_INGRESOS,
				[K_CONCEPTO_LIBRO_INGRESOS]	= @PP_K_CONCEPTO_LIBRO_INGRESOS,	
				[L_CAPTURA_MANUAL]			= @PP_L_CAPTURA_MANUAL,
				[F_OPERACION]				= @PP_F_OPERACION,
				[K_UNIDAD_OPERATIVA]		= @PP_K_UNIDAD_OPERATIVA,
				[C_LIBRO_INGRESOS]			= @PP_C_LIBRO_INGRESOS,
				[MONTO]						= @PP_MONTO,
				[MONTO_APLICAR]				= @VP_MONTO_APLICAR,
				-- ===========================
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION, 
				[F_CAMBIO]					= GETDATE() 
		WHERE	K_LIBRO_INGRESOS=@PP_K_LIBRO_INGRESOS
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible <Actualizar> el Libro Ingresos: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#LI.'+CONVERT(VARCHAR(10),@PP_K_LIBRO_INGRESOS)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_LIBRO_INGRESOS AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_LIBRO_INGRESOS]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_LIBRO_INGRESOS, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_LIBRO_INGRESOS', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_LIBRO_INGRESOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_LIBRO_INGRESOS]
GO


CREATE PROCEDURE [dbo].[PG_DL_LIBRO_INGRESOS]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_LIBRO_INGRESOS				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_LIBRO_INGRESOS_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_LIBRO_INGRESOS, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	LIBRO_INGRESOS
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_LIBRO_INGRESOS=@PP_K_LIBRO_INGRESOS

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [LIBRO_INGRESOS]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#LI.'+CONVERT(VARCHAR(10),@PP_K_LIBRO_INGRESOS)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_LIBRO_INGRESOS AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_LIBRO_INGRESOS]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_LIBRO_INGRESOS, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
