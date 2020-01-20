-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			PYF18_R310_03.a_RN_Factura_CXP
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			FACTURA_CXP
-- // OPERACION:		LIBERACION // STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			Alex de la Rosa
-- // Fecha creación:	15/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE
-- //////////////////////////////////////////////////////////////P

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_FACTURA_CXP_SALDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_FACTURA_CXP_SALDO]
GO


CREATE PROCEDURE [dbo].[PG_UP_FACTURA_CXP_SALDO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_FACTURA_CXP				INT
AS
	
	UPDATE	FACTURA_CXP
	SET		[SALDO] = ( [TOTAL] - [ABONOS] )
	WHERE 	K_FACTURA_CXP=@PP_K_FACTURA_CXP

	-- ============================================
GO		



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE
-- //////////////////////////////////////////////////////////////P

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_FACTURA_CXP_K_RAZON_SOCIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_FACTURA_CXP_K_RAZON_SOCIAL]
GO


CREATE PROCEDURE [dbo].[PG_UP_FACTURA_CXP_K_RAZON_SOCIAL]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_FACTURA_CXP				INT
AS
	
	DECLARE	@VP_RFC_RECEPTOR		VARCHAR(100)

	SELECT	@VP_RFC_RECEPTOR =		RFC_RECEPTOR
									FROM	FACTURA_CXP
									WHERE	K_FACTURA_CXP=@PP_K_FACTURA_CXP

	-- ============================================

	DECLARE	@VP_K_RAZON_SOCIAL		INT

	SELECT	@VP_K_RAZON_SOCIAL	=	MIN(K_RAZON_SOCIAL)
									FROM	RAZON_SOCIAL
									WHERE	RFC_RAZON_SOCIAL=@VP_RFC_RECEPTOR

	-- ============================================

	UPDATE	FACTURA_CXP
	SET		K_RAZON_SOCIAL = @VP_K_RAZON_SOCIAL 
	WHERE 	K_FACTURA_CXP=@PP_K_FACTURA_CXP

	-- ============================================

	DECLARE	@VP_K_UNIDAD_OPERATIVA		INT

	SELECT	@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA
										FROM	UNIDAD_OPERATIVA
										WHERE	K_RAZON_SOCIAL=@VP_K_RAZON_SOCIAL
										AND		K_TIPO_UO=50		-- UNIDAD OPERATIVA DE LA RAZON SOCIAL

	UPDATE	FACTURA_CXP
	SET		K_UNIDAD_OPERATIVA = @VP_K_UNIDAD_OPERATIVA 
	WHERE 	K_FACTURA_CXP=@PP_K_FACTURA_CXP

	-- ============================================
GO		



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE
-- //////////////////////////////////////////////////////////////P

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_FACTURA_CXP_K_PROVEEDOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_FACTURA_CXP_K_PROVEEDOR]
GO


CREATE PROCEDURE [dbo].[PG_UP_FACTURA_CXP_K_PROVEEDOR]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_FACTURA_CXP				INT
AS
	
	DECLARE	@VP_RFC_EMISOR			VARCHAR(100)

	SELECT	@VP_RFC_EMISOR =		RFC_EMISOR
									FROM	FACTURA_CXP
									WHERE	K_FACTURA_CXP=@PP_K_FACTURA_CXP

	-- ============================================

	DECLARE	@VP_K_PROVEEDOR			INT

	SELECT	@VP_K_PROVEEDOR	=		MIN(K_PROVEEDOR)
									FROM	PROVEEDOR
									WHERE	RFC_PROVEEDOR=@VP_RFC_EMISOR

	-- ============================================

	UPDATE	FACTURA_CXP
	SET		K_PROVEEDOR = @VP_K_PROVEEDOR
	WHERE 	K_FACTURA_CXP=@PP_K_FACTURA_CXP

	-- ============================================
GO		



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_FACTURA_CXP]
GO


CREATE PROCEDURE [dbo].[PG_LI_FACTURA_CXP]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================	
	@PP_BUSCAR							VARCHAR(200),
	--@PP_K_PROVEEDOR						INT,
	--@PP_K_RAZON_SOCIAL					INT,
	@PP_K_CAPTURA_FACTURA_CXP			INT,
	@PP_K_ESTATUS_FACTURA_CXP			INT,
	@PP_K_TIPO_COMPROBANTE				INT,
	@PP_F_INICIAL						DATE,
	@PP_F_FINAL							DATE
	-- ===========================
AS

	DECLARE @VP_MENSAJE					VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS		INT=1

	-- =========================================		

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- =========================================		

	DECLARE @VP_INT_NUMERO_REGISTROS	INT
	
	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
	-- =========================================		
	DECLARE @VP_K_FOLIO					INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]		@PP_BUSCAR, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================

	DECLARE @VP_L_VER_BORRADOS			INT		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================
	
	IF @VP_MENSAJE<>''
			SET @VP_INT_NUMERO_REGISTROS = 0

	SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
			D_TIEMPO_FECHA AS F_EMISION_DDMMMYYYY,
			FAC.*,
			-- =============================
			D_TIPO_COMPROBANTE,		S_TIPO_COMPROBANTE,
			D_CAPTURA_FACTURA_CXP,	S_CAPTURA_FACTURA_CXP, 
			D_ESTATUS_FACTURA_CXP,	S_ESTATUS_FACTURA_CXP,
			D_USUARIO AS D_USUARIO_CAMBIO
			-- =============================
	FROM	FACTURA_CXP FAC,
			TIPO_COMPROBANTE TD,
			CAPTURA_FACTURA_CXP CF, ESTATUS_FACTURA_CXP EF, 
			USUARIO USR, TIEMPO_FECHA
			-- =============================
	WHERE	FAC.K_ESTATUS_FACTURA_CXP=EF.K_ESTATUS_FACTURA_CXP
	AND		FAC.K_CAPTURA_FACTURA_CXP=CF.K_CAPTURA_FACTURA_CXP
	AND		FAC.K_TIPO_COMPROBANTE=TD.K_TIPO_COMPROBANTE
	AND		FAC.K_USUARIO_CAMBIO=USR.K_USUARIO
	AND		FAC.F_EMISION=TIEMPO_FECHA.F_TIEMPO_FECHA
--	AND		FAC.K_PROVEEDOR=PR.K_PROVEEDOR
--	AND		FAC.K_RAZON_SOCIAL=RS.K_RAZON_SOCIAL
			-- =============================
	AND			(		FAC.K_FACTURA_CXP=@VP_K_FOLIO
					OR  FAC.RFC_EMISOR			LIKE '%'+@PP_BUSCAR+'%' 
					OR  FAC.RFC_RECEPTOR		LIKE '%'+@PP_BUSCAR+'%' 
					OR  FAC.SERIE				LIKE '%'+@PP_BUSCAR+'%'
					OR  FAC.FOLIO				LIKE '%'+@PP_BUSCAR+'%' 
				)
			-- ============================
	AND		( @PP_F_INICIAL IS NULL				OR	@PP_F_INICIAL<=F_EMISION )
	AND		( @PP_F_FINAL	IS NULL				OR	F_EMISION<=@PP_F_FINAL )
			-- =============================
	AND		( @PP_K_ESTATUS_FACTURA_CXP=-1		OR	FAC.K_ESTATUS_FACTURA_CXP=@PP_K_ESTATUS_FACTURA_CXP)
	AND		( @PP_K_CAPTURA_FACTURA_CXP=-1		OR	FAC.K_CAPTURA_FACTURA_CXP=@PP_K_CAPTURA_FACTURA_CXP)		
	AND		( @PP_K_TIPO_COMPROBANTE=-1			OR	FAC.K_TIPO_COMPROBANTE=@PP_K_TIPO_COMPROBANTE)		
	AND		( FAC.L_BORRADO=0					OR	@VP_L_VER_BORRADOS=1 )	
--	AND		( @PP_K_PROVEEDOR=-1				OR	FAC.K_PROVEEDOR=@PP_K_PROVEEDOR)
--	AND		( @PP_K_RAZON_SOCIAL=-1				OR	FAC.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL)		
	ORDER BY F_EMISION DESC

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_FACTURA_CXP]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_BUSCAR, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_BUSCAR', '', '', ''

	-- ////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_FACTURA_CXP]
GO


CREATE PROCEDURE [dbo].[PG_SK_FACTURA_CXP]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_FACTURA_CXP			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_L_VER_BORRADOS			INT		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	
	-- ///////////////////////////////////////////
	
	DECLARE @VP_LI_N_REGISTROS			INT = 100
	
	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0
	
	SELECT	TOP (@VP_LI_N_REGISTROS)
			D_TIEMPO_FECHA AS F_EMISION_DDMMMYYYY,
			FAC.*,
			-- =============================
			D_TIPO_COMPROBANTE,		S_TIPO_COMPROBANTE,
			D_CAPTURA_FACTURA_CXP,	S_CAPTURA_FACTURA_CXP, 
			D_ESTATUS_FACTURA_CXP,	S_ESTATUS_FACTURA_CXP,
			D_USUARIO AS D_USUARIO_CAMBIO
			-- =============================
	FROM	FACTURA_CXP FAC,
			TIPO_COMPROBANTE TD,
			CAPTURA_FACTURA_CXP CF, ESTATUS_FACTURA_CXP EF, 
			USUARIO USR, TIEMPO_FECHA
			-- =============================
	WHERE	FAC.K_ESTATUS_FACTURA_CXP=EF.K_ESTATUS_FACTURA_CXP
	AND		FAC.K_CAPTURA_FACTURA_CXP=CF.K_CAPTURA_FACTURA_CXP
	AND		FAC.K_TIPO_COMPROBANTE=TD.K_TIPO_COMPROBANTE
	AND		FAC.K_USUARIO_CAMBIO=USR.K_USUARIO
	AND		FAC.F_EMISION=TIEMPO_FECHA.F_TIEMPO_FECHA
--	AND		FAC.K_PROVEEDOR=PR.K_PROVEEDOR
--	AND		FAC.K_RAZON_SOCIAL=RS.K_RAZON_SOCIAL
	AND		( FAC.L_BORRADO=0					OR	@VP_L_VER_BORRADOS=1 )	
--	AND		( @PP_K_PROVEEDOR=-1				OR	FAC.K_PROVEEDOR=@PP_K_PROVEEDOR)
--	AND		( @PP_K_RAZON_SOCIAL=-1				OR	FAC.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL)		
	AND		FAC.K_FACTURA_CXP=@PP_K_FACTURA_CXP
--	ORDER BY F_EMISION DESC
	
	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_FACTURA_CXP]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FACTURA_CXP, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0,@PP_K_FACTURA_CXP, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@', '', '', ''
	-- //////////////////////////////////////////
GO


	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////P

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_FACTURA_CXP]
GO


CREATE PROCEDURE [dbo].[PG_IN_FACTURA_CXP]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_C_FACTURA_CXP				VARCHAR(255),
	@PP_K_TIPO_COMPROBANTE			INT,
	-- =======================
	@PP_RFC_EMISOR					VARCHAR (100),
--	@PP_K_PROVEEDOR					INT,
	@PP_RFC_RECEPTOR				VARCHAR (100), 		
	@PP_F_EMISION					DATE,
	@PP_SERIE						VARCHAR (100),
	@PP_FOLIO						VARCHAR (100),
	-- =======================
	@PP_SUBTOTAL					DECIMAL (19,4),		
	@PP_IVA							DECIMAL (19,4),
	@PP_TOTAL						DECIMAL (19,4),	
	-- =======================
	@PP_K_CAPTURA_FACTURA_CXP		INT,	
	@PP_K_ESTATUS_FACTURA_CXP		INT	
	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''
	
	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_FACTURA_CXP	INT = 0
	
	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'FACTURA_CXP', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_FACTURA_CXP			OUTPUT

		-- //////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@VP_K_FACTURA_CXP,@PP_SERIE, @PP_FOLIO,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		--	@PP_K_RAZON_SOCIAL				INT,


		DECLARE @VP_OTROS_IMPUESTOS		DECIMAL(19,4)

		SET		@VP_OTROS_IMPUESTOS		= ( @PP_TOTAL-@PP_SUBTOTAL-@PP_IVA )
		
		-- ==================================

		INSERT INTO FACTURA_CXP
			(	[K_FACTURA_CXP],[C_FACTURA_CXP],	
				[K_TIPO_COMPROBANTE],			
				-- =========================
				[RFC_EMISOR],	[RFC_RECEPTOR],
				[K_PROVEEDOR],	[K_RAZON_SOCIAL],			
				[F_EMISION],	
				[SERIE], [FOLIO],
				[F_VENCIMIENTO],	
				-- =========================
				[SUBTOTAL],			[IVA],						
				[OTROS_IMPUESTOS],	[TOTAL],	
				-- =========================
				[ABONOS], [SALDO],
				-- =========================
				[K_CAPTURA_FACTURA_CXP], 
				[K_ESTATUS_FACTURA_CXP],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_FACTURA_CXP,		@PP_C_FACTURA_CXP,		
				@PP_K_TIPO_COMPROBANTE,	
				-- =======================
				@PP_RFC_EMISOR,		@PP_RFC_RECEPTOR,
				NULL,				NULL,				--@PP_K_PROVEEDOR,	@PP_K_RAZON_SOCIAL,			
				@PP_F_EMISION,		
				@PP_SERIE, @PP_FOLIO,					
				@PP_F_EMISION,		
				-- =======================
				@PP_SUBTOTAL,			@PP_IVA,
				@VP_OTROS_IMPUESTOS,	@PP_TOTAL,					
				-- =======================
				0, 0,
				-- =======================
				@PP_K_CAPTURA_FACTURA_CXP,
				@PP_K_ESTATUS_FACTURA_CXP,	
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )

		-- ========================================

		EXECUTE [dbo].[PG_UP_FACTURA_CXP_SALDO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@VP_K_FACTURA_CXP
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] la [FACTURA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Fa.'+CONVERT(VARCHAR(10),@VP_K_FACTURA_CXP)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_FACTURA_CXP AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_FACTURA_CXP]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_FACTURA_CXP, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_C_FACTURA_CXP, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_FACTURA_CXP', '', '', ''
	-- //////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> ACTUALIZAR / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_FACTURA_CXP]
GO

CREATE PROCEDURE [dbo].[PG_UP_FACTURA_CXP]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_FACTURA_CXP				INT,
	@PP_C_FACTURA_CXP				VARCHAR(255),
	@PP_K_TIPO_COMPROBANTE			INT,	
	-- =======================
	@PP_RFC_EMISOR					VARCHAR (100),
--	@PP_K_PROVEEDOR					INT,
	@PP_RFC_RECEPTOR				VARCHAR (100), 		
--	@PP_K_RAZON_SOCIAL				INT,
	@PP_F_EMISION					DATE,
	@PP_SERIE						VARCHAR (100),
	@PP_FOLIO						VARCHAR (100),
	-- =======================
	@PP_SUBTOTAL					DECIMAL (19,4),		
	@PP_IVA							DECIMAL (19,4),
	@PP_TOTAL						DECIMAL (19,4),	
	-- =======================
	@PP_K_CAPTURA_FACTURA_CXP		INT,	
	@PP_K_ESTATUS_FACTURA_CXP		INT	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_FACTURA_CXP,@PP_SERIE,@PP_FOLIO,
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
				
		-- ==================================
		
		DECLARE @VP_OTROS_IMPUESTOS		DECIMAL(19,4)

		SET		@VP_OTROS_IMPUESTOS		= ( @PP_TOTAL-@PP_SUBTOTAL-@PP_IVA )
		
		-- ==================================

		UPDATE	FACTURA_CXP
		SET		
				[K_FACTURA_CXP]				=	@PP_K_FACTURA_CXP,						
				[C_FACTURA_CXP]				=	@PP_C_FACTURA_CXP,		
				[K_TIPO_COMPROBANTE]		=	@PP_K_TIPO_COMPROBANTE,
				-- ==========================	-- =======================
				[RFC_EMISOR]				=	@PP_RFC_EMISOR,				
--				[K_PROVEEDOR]				=	@PP_K_PROVEEDOR,				
				[RFC_RECEPTOR]				=	@PP_RFC_RECEPTOR,			
--				[K_RAZON_SOCIAL]			=	@PP_K_RAZON_SOCIAL,			
				[F_EMISION]					=	@PP_F_EMISION,				
				[SERIE]						=	@PP_SERIE,					
				[FOLIO]						=	@PP_FOLIO,		
				[F_VENCIMIENTO]				=	@PP_F_EMISION,
				-- ==========================	-- =======================
				[SUBTOTAL]					=	@PP_SUBTOTAL,				
				[IVA]						=	@PP_IVA,						
				[OTROS_IMPUESTOS]			=	@VP_OTROS_IMPUESTOS,			
				[TOTAL]						=	@PP_TOTAL,					
				-- ==========================	-- =======================
				[K_CAPTURA_FACTURA_CXP]		=	@PP_K_CAPTURA_FACTURA_CXP,	
				[K_ESTATUS_FACTURA_CXP]		=	@PP_K_ESTATUS_FACTURA_CXP,	
				-- ====================
				[F_CAMBIO]					=	GETDATE(), 
				[K_USUARIO_CAMBIO]			=	@PP_K_USUARIO_ACCION
		WHERE	K_FACTURA_CXP=@PP_K_FACTURA_CXP
	
		-- ========================================

		EXECUTE [dbo].[PG_UP_FACTURA_CXP_SALDO]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_FACTURA_CXP
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] la [FACTURA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Fa.'+CONVERT(VARCHAR(10),@PP_K_FACTURA_CXP)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FACTURA_CXP AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_FACTURA_CXP]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FACTURA_CXP, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_C_FACTURA_CXP, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_FACTURA_CXP', '', '', ''

	-- //////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_FACTURA_CXP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_FACTURA_CXP]
GO


CREATE PROCEDURE [dbo].[PG_DL_FACTURA_CXP]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_FACTURA_CXP			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_FACTURA_CXP, 
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		UPDATE	FACTURA_CXP
		SET		
				[L_BORRADO]		 =	1,
				-- ====================
				[F_BAJA]		 =	GETDATE(), 
				[K_USUARIO_BAJA] =	@PP_K_USUARIO_ACCION
		WHERE	K_FACTURA_CXP=@PP_K_FACTURA_CXP
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la [FACTURA]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Fa.'+CONVERT(VARCHAR(10),@PP_K_FACTURA_CXP)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FACTURA_CXP AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_FACTURA_CXP]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FACTURA_CXP, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- //////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
