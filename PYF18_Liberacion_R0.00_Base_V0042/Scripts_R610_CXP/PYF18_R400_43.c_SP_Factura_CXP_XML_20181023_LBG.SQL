-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			FACTURA_CXP_XML
-- // OPERACION:		LIBERACION / STORED PROCEDDURES
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			AX de la Rosa 
-- // Fecha creación:	19/SEP/2018 / 03/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_FACTURA_CXP_XML]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_FACTURA_CXP_XML]
GO


CREATE PROCEDURE [dbo].[PG_LI_FACTURA_CXP_XML]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================	
	@PP_C_FACTURA_CXP_XML				VARCHAR(255),
	@PP_K_PROVEEDOR						INT,
	@PP_K_RAZON_SOCIAL					INT,
	@PP_F_INICIAL						DATE,
	@PP_F_FINAL							DATE
	-- ===========================
AS

	DECLARE @VP_MENSAJE					VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS		INT = 1
	
		
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
															11, -- @PP_K_DATA_SISTEMA,	
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_INT_NUMERO_REGISTROS	INT

		EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																			@VP_L_APLICAR_MAX_ROWS,		
																			@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT	
	-- =========================================		

	DECLARE @VP_K_FOLIO					INT

		EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]		@PP_C_FACTURA_CXP_XML, 
															@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
	
	DECLARE @VP_L_VER_BORRADOS			INT		
	
		EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]				@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	IF @VP_MENSAJE<>''
			SET @VP_INT_NUMERO_REGISTROS = 0
	
	SELECT	TOP ( @VP_INT_NUMERO_REGISTROS )
			D_TIEMPO_FECHA AS F_EMISION_DDMMMYYYY,
			FACTURA_CXP_XML.*,
			PROVEEDOR.D_PROVEEDOR, RAZON_SOCIAL.RAZON_SOCIAL, 
			D_USUARIO AS D_USUARIO_CAMBIO			
			-- =====================
	FROM	FACTURA_CXP_XML, PROVEEDOR, RAZON_SOCIAL, 
			USUARIO, TIEMPO_FECHA
			-- =====================
	WHERE	FACTURA_CXP_XML.K_USUARIO_CAMBIO = USUARIO.K_USUARIO
	AND		FACTURA_CXP_XML.XML_Fecha = TIEMPO_FECHA.F_TIEMPO_FECHA
			-- =====================
	AND		(	
					XML_EMI_Nombre					LIKE '%'+@PP_C_FACTURA_CXP_XML+'%'
				OR	XML_EMI_Rfc						LIKE '%'+@PP_C_FACTURA_CXP_XML+'%'
				OR	XML_Folio						LIKE '%'+@PP_C_FACTURA_CXP_XML+'%'
				OR	XML_LugarExpedicion				LIKE '%'+@PP_C_FACTURA_CXP_XML+'%'
				OR	XML_REC_Nombre					LIKE '%'+@PP_C_FACTURA_CXP_XML+'%' 
				OR	XML_REC_Rfc						LIKE '%'+@PP_C_FACTURA_CXP_XML+'%'
				OR	XML_Serie						LIKE '%'+@PP_C_FACTURA_CXP_XML+'%'
				OR	XML_UUID						LIKE '%'+@PP_C_FACTURA_CXP_XML+'%'
				OR	XML_Version						LIKE '%'+@PP_C_FACTURA_CXP_XML+'%'
				OR	XML_Total						LIKE '%'+@PP_C_FACTURA_CXP_XML+'%'
				OR	XML_TipoDeComprobante			LIKE '%'+@PP_C_FACTURA_CXP_XML+'%'
				OR	FACTURA_CXP_XML.K_FACTURA_CXP_XML=@VP_K_FOLIO 
			)
				-- ============================
		AND		( @PP_F_INICIAL IS NULL				OR	@PP_F_INICIAL<=XML_Fecha )
		AND		( @PP_F_FINAL	IS NULL				OR	XML_Fecha<=@PP_F_FINAL )
				-- =============================
		AND		( @PP_K_PROVEEDOR=-1				OR	FACTURA_CXP_XML.K_PROVEEDOR=@PP_K_PROVEEDOR)
		AND		( @PP_K_RAZON_SOCIAL=-1				OR	FACTURA_CXP_XML.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL)
		AND		( FACTURA_CXP_XML.L_BORRADO=0		OR	@VP_L_VER_BORRADOS=1 )	
	
	ORDER BY XML_Fecha DESC

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_FACTURA_CXP_XML]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, -- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
														  -- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_C_FACTURA_CXP_XML, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_FACTURA_CXP_XML', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_FACTURA_CXP_XML]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_FACTURA_CXP_XML]
GO


CREATE PROCEDURE [dbo].[PG_SK_FACTURA_CXP_XML]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_FACTURA_CXP_XML				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														11, -- @PP_K_DATA_SISTEMA,	
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_L_VER_BORRADOS			INT		
	
		EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		SELECT	FACTURA_CXP_XML.*			
				-- =====================
		FROM	FACTURA_CXP_XML
				-- =====================
		WHERE	FACTURA_CXP_XML.L_BORRADO=0
		AND		FACTURA_CXP_XML.K_FACTURA_CXP_XML=@PP_K_FACTURA_CXP_XML		

		END
	ELSE
		BEGIN	-- RESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

		SELECT	FACTURA_CXP_XML.*			
				-- =====================
		FROM	FACTURA_CXP_XML
				-- =====================
		WHERE	FACTURA_CXP_XML.K_FACTURA_CXP_XML<0

		END

	-----////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_FACTURA_CXP_XML]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FACTURA_CXP_XML, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_FACTURA_CXP_XML]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_FACTURA_CXP_XML]
GO


CREATE PROCEDURE [dbo].[PG_IN_FACTURA_CXP_XML]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_C_FACTURA_CXP_XML				VARCHAR(255),
	-- ===========================
	@PP_XML_Fecha						DATETIME,						
	@PP_XML_Folio						VARCHAR(100),
	@PP_XML_FormaPago					VARCHAR(100),	
	@PP_XML_LugarExpedicion				VARCHAR(100),
	@PP_XML_MetodoPago					VARCHAR(100),
	@PP_XML_Moneda						VARCHAR(100),
	@PP_XML_NoCertificado				VARCHAR(100),
	--@PP_XML_Sello						VARCHAR(100),	
	@PP_XML_Serie						VARCHAR(100),
	@PP_XML_SubTotal					DECIMAL(19,4),
	@PP_XML_TipoCambio					VARCHAR(100),
	@PP_XML_TipoDeComprobante			VARCHAR(100),
	@PP_XML_Total						DECIMAL(19,4),	
	@PP_XML_Version						VARCHAR(100),
	-- ===========================
	@PP_XML_EMI_Nombre					VARCHAR(100),
	@PP_XML_EMI_RegimenFiscal			VARCHAR(100),
	@PP_XML_EMI_Rfc						VARCHAR(100),
	-- ===========================
	@PP_XML_REC_Nombre					VARCHAR(100),
	@PP_XML_REC_Rfc						VARCHAR(100),
	@PP_XML_REC_UsoCFDI					VARCHAR(100),
	-- ===========================
	@PP_XML_TotalImpuestosTrasladados	DECIMAL(19,4),
	@PP_XML_Importe						DECIMAL(19,4),
	@PP_XML_Impuesto					VARCHAR(100),
	@PP_XML_TasaOCuota					VARCHAR(100),
	@PP_XML_TipoFactor					VARCHAR(100),
	-- ===========================
	@PP_XML_FechaTimbrado				VARCHAR(100),
	@PP_XML_NoCertificadoSAT			VARCHAR(100),
	@PP_XML_UUID						VARCHAR(100),
	-- ===========================
	@PP_XML_ARCHIVO						NVARCHAR(MAX)
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_FACTURA_CXP_XML				INT = 0
	DECLARE @VP_K_PROVEEDOR						INT = 0
	DECLARE @VP_K_RAZON_SOCIAL					INT = 0

	SELECT	@VP_K_PROVEEDOR	=		PROVEEDOR.K_PROVEEDOR
									FROM	PROVEEDOR
									WHERE	PROVEEDOR.RFC_PROVEEDOR=@PP_XML_EMI_Rfc	
									
	SELECT	@VP_K_RAZON_SOCIAL	=	RAZON_SOCIAL.K_RAZON_SOCIAL
									FROM	RAZON_SOCIAL
									WHERE	RAZON_SOCIAL.RFC_RAZON_SOCIAL=@PP_XML_REC_Rfc			
	

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_XML_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@VP_K_FACTURA_CXP_XML, @PP_XML_Serie,@PP_XML_Folio,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'FACTURA_CXP', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_FACTURA_CXP_XML			OUTPUT

		-- //////////////////////////////////////////////////////////////
		
		INSERT INTO FACTURA_CXP_XML
			(	[K_FACTURA_CXP_XML],				[C_FACTURA_CXP_XML],
				-- ===========================
				[XML_Fecha],						[XML_Folio],
				[XML_FormaPago],					[XML_LugarExpedicion],
				[XML_MetodoPago],					[XML_Moneda],
				[XML_NoCertificado],				[XML_Serie],						
				[XML_SubTotal],						[XML_TipoCambio],
				[XML_TipoDeComprobante],			[XML_Total],						
				[XML_Version],			
				-- ===========================
				[K_PROVEEDOR],						[XML_EMI_Nombre],
				[XML_EMI_RegimenFiscal],			[XML_EMI_Rfc],
				-- ===========================
				[K_RAZON_SOCIAL],					[XML_REC_Nombre],
				[XML_REC_Rfc],						[XML_REC_UsoCFDI],
				-- ===========================
				[XML_TotalImpuestosTrasladados],	[XML_Importe],
				[XML_Impuesto],						[XML_TasaOCuota],
				[XML_TipoFactor],
				-- ===========================
				[XML_FechaTimbrado],				[XML_NoCertificadoSAT],
				[XML_UUID],
				-- ===========================
				[XML_ARCHIVO],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_FACTURA_CXP_XML,				@PP_C_FACTURA_CXP_XML,
				-- ===========================
				@PP_XML_Fecha,						@PP_XML_Folio,
				@PP_XML_FormaPago,					@PP_XML_LugarExpedicion,
				@PP_XML_MetodoPago,					@PP_XML_Moneda,
				@PP_XML_NoCertificado,				@PP_XML_Serie,
				@PP_XML_SubTotal,					@PP_XML_TipoCambio,					
				@PP_XML_TipoDeComprobante,			@PP_XML_Total,
				@PP_XML_Version,
				-- ===========================
				@VP_K_PROVEEDOR,					@PP_XML_EMI_Nombre,
				@PP_XML_EMI_RegimenFiscal,			@PP_XML_EMI_Rfc,
				-- ===========================
				@VP_K_RAZON_SOCIAL,					@PP_XML_REC_Nombre,					
				@PP_XML_REC_Rfc,					@PP_XML_REC_UsoCFDI,
				-- ===========================
				@PP_XML_TotalImpuestosTrasladados,	@PP_XML_Importe,
				@PP_XML_Impuesto,					@PP_XML_TasaOCuota,
				@PP_XML_TipoFactor,
				-- ===========================
				@PP_XML_FechaTimbrado,				@PP_XML_NoCertificadoSAT,
				@PP_XML_UUID,
				-- ===========================
				@PP_XML_ARCHIVO,			
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )
		
		-- //////////////////////////////////////////////////////////////

		DECLARE @VP_C_FACTURA_CXP AS VARCHAR(100)=''
		SET @VP_C_FACTURA_CXP='EMISOR:'+@PP_XML_EMI_Rfc+'-RECEPTOR:'+@PP_XML_REC_Rfc+'   ['+@PP_XML_Serie+' '+@PP_XML_Folio+']'

		
		EXECUTE	[dbo].[PG_IN_FACTURA_CXP]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@VP_C_FACTURA_CXP,2,@PP_XML_EMI_Rfc,@PP_XML_REC_Rfc,
											@PP_XML_Fecha,	@PP_XML_Serie,@PP_XML_Folio,
											@PP_XML_SubTotal,@PP_XML_Importe,@PP_XML_Total,	
											2,	1	

		-- //////////////////////////////////////////////////////////////

		EXECUTE	[dbo].[PG_UP_FACTURA_CXP_SALDO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@VP_K_FACTURA_CXP_XML

		-- //////////////////////////////////////////////////////////////

		EXECUTE	[dbo].[PG_UP_FACTURA_CXP_K_RAZON_SOCIAL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@VP_K_FACTURA_CXP_XML

		-- //////////////////////////////////////////////////////////////

		EXECUTE	[dbo].[PG_UP_FACTURA_CXP_K_PROVEEDOR]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_FACTURA_CXP_XML

		-- //////////////////////////////////////////////////////////////

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] la [FACTURA_CXP_XML]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Fc.'+CONVERT(VARCHAR(10),@VP_K_FACTURA_CXP_XML)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_FACTURA_CXP_XML AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_FACTURA_CXP_XML AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_FACTURA_CXP_XML]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_FACTURA_CXP_XML, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_C_FACTURA_CXP_XML, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_FACTURA_CXP_XML', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_FACTURA_CXP_XML]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_FACTURA_CXP_XML]
GO

CREATE PROCEDURE [dbo].[PG_UP_FACTURA_CXP_XML]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_FACTURA_CXP_XML				INT,
	@PP_C_FACTURA_CXP_XML				VARCHAR(255),
	-- ===========================
	@PP_XML_Fecha						DATETIME,						
	@PP_XML_Folio						VARCHAR(100),
	@PP_XML_FormaPago					VARCHAR(100),	
	@PP_XML_LugarExpedicion				VARCHAR(100),                                                                            
	@PP_XML_MetodoPago					VARCHAR(100),
	@PP_XML_Moneda						VARCHAR(100),
	@PP_XML_NoCertificado				VARCHAR(100),
	--@PP_XML_Sello						VARCHAR(100),	
	@PP_XML_Serie						VARCHAR(100),
	@PP_XML_SubTotal					DECIMAL(19,4),
	@PP_XML_TipoCambio					VARCHAR(100),
	@PP_XML_TipoDeComprobante			VARCHAR(100),
	@PP_XML_Total						DECIMAL(19,4),	
	@PP_XML_Version						VARCHAR(100),
	-- ===========================
	@PP_XML_EMI_Nombre					VARCHAR(100),
	@PP_XML_EMI_RegimenFiscal			VARCHAR(100),
	@PP_XML_EMI_Rfc						VARCHAR(100),
	-- ===========================
	@PP_XML_REC_Nombre					VARCHAR(100),
	@PP_XML_REC_Rfc						VARCHAR(100),
	@PP_XML_REC_UsoCFDI					VARCHAR(100),
	-- ===========================
	@PP_XML_TotalImpuestosTrasladados	DECIMAL(19,4),
	@PP_XML_Importe						DECIMAL(19,4),
	@PP_XML_Impuesto					VARCHAR(100),
	@PP_XML_TasaOCuota					VARCHAR(100),
	@PP_XML_TipoFactor					VARCHAR(100),
	-- ===========================
	@PP_XML_FechaTimbrado				VARCHAR(100),
	@PP_XML_NoCertificadoSAT			VARCHAR(100),
	@PP_XML_UUID						VARCHAR(100),
	-- ===========================
	@PP_XML_ARCHIVO						NVARCHAR(MAX)
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_XML_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_FACTURA_CXP_XML, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		DECLARE @VP_K_PROVEEDOR						INT = 0
		DECLARE @VP_K_RAZON_SOCIAL					INT = 0

		SELECT	@VP_K_PROVEEDOR	=		PROVEEDOR.K_PROVEEDOR
										FROM	PROVEEDOR
										WHERE	PROVEEDOR.RFC_PROVEEDOR=@PP_XML_EMI_Rfc	
										
		SELECT	@VP_K_RAZON_SOCIAL	=	RAZON_SOCIAL.K_RAZON_SOCIAL
										FROM	RAZON_SOCIAL
										WHERE	RAZON_SOCIAL.RFC_RAZON_SOCIAL=@PP_XML_REC_Rfc	
		
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	FACTURA_CXP_XML
		SET		
				[K_FACTURA_CXP_XML]				=	@PP_K_FACTURA_CXP_XML,			
				[C_FACTURA_CXP_XML]				=	@PP_C_FACTURA_CXP_XML,				
				-- ============================	=	-- ===========================
				[XML_Fecha]						=	@PP_XML_Fecha,			
				[XML_Folio]						=	@PP_XML_Folio,						
				[XML_FormaPago]					=	@PP_XML_FormaPago,
				[XML_LugarExpedicion]			=	@PP_XML_LugarExpedicion,
				[XML_MetodoPago]				=	@PP_XML_MetodoPago,			
				[XML_Moneda]					=	@PP_XML_Moneda,				
				[XML_NoCertificado]				=	@PP_XML_NoCertificado,
				[XML_Serie]						=	@PP_XML_Serie,						
				[XML_SubTotal]					=	@PP_XML_SubTotal,
				[XML_TipoCambio]				=	@PP_XML_TipoCambio,					
				[XML_TipoDeComprobante]			=	@PP_XML_TipoDeComprobante,
				[XML_Total]						=	@PP_XML_Total,		
				[XML_Version]					=	@PP_XML_Version,						
				-- ============================	=	-- ===========================
				[K_PROVEEDOR]					=	@VP_K_PROVEEDOR,
				[XML_EMI_Nombre]				=	@PP_XML_EMI_Nombre,
				[XML_EMI_RegimenFiscal]			=	@PP_XML_EMI_RegimenFiscal,
				[XML_EMI_Rfc]					=	@PP_XML_EMI_Rfc,		
				-- ============================	=	-- ===========================
				[K_RAZON_SOCIAL]				=	@VP_K_RAZON_SOCIAL,
				[XML_REC_Nombre]				=	@PP_XML_REC_Nombre,
				[XML_REC_Rfc]					=	@PP_XML_REC_Rfc,				
				[XML_REC_UsoCFDI]				=	@PP_XML_REC_UsoCFDI,
				-- ============================	=	-- ===========================
				[XML_TotalImpuestosTrasladados] =	@PP_XML_TotalImpuestosTrasladados,
				[XML_Importe]					=	@PP_XML_Importe,	
				[XML_Impuesto]					=	@PP_XML_Impuesto,
				[XML_TasaOCuota]				=	@PP_XML_TasaOCuota,
				[XML_TipoFactor]				=	@PP_XML_TipoFactor,					
				-- ============================	=	-- ===========================
				[XML_FechaTimbrado]				=	@PP_XML_FechaTimbrado,
				[XML_NoCertificadoSAT]			=	@PP_XML_NoCertificadoSAT,
				[XML_UUID]						=	@PP_XML_UUID,			
				-- ==============================	-- ===========================
				[XML_ARCHIVO]					=	@PP_XML_ARCHIVO,					
				-- ===========================
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION, 
				[F_CAMBIO]					= GETDATE() 
		WHERE	K_FACTURA_CXP_XML=@PP_K_FACTURA_CXP_XML
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] la [FACTURA_CXP_XML]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Fc.'+CONVERT(VARCHAR(10),@PP_K_FACTURA_CXP_XML)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FACTURA_CXP_XML AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FACTURA_CXP_XML AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_FACTURA_CXP_XML]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FACTURA_CXP_XML, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_C_FACTURA_CXP_XML, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_FACTURA_CXP_XML', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_FACTURA_CXP_XML]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_FACTURA_CXP_XML]
GO


CREATE PROCEDURE [dbo].[PG_DL_FACTURA_CXP_XML]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_FACTURA_CXP_XML				INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE	=	''

	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_FACTURA_CXP_XML_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_FACTURA_CXP_XML, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN


		UPDATE	FACTURA_CXP_XML
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_FACTURA_CXP_XML=@PP_K_FACTURA_CXP_XML

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la [FACTURA_CXP_XML]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Fc.'+CONVERT(VARCHAR(10),@PP_K_FACTURA_CXP_XML)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FACTURA_CXP_XML AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_FACTURA_CXP_XML AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_FACTURA_CXP_XML]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_FACTURA_CXP_XML, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
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

