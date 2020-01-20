-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			SP_Viatico_XML_20181122_ADR.sql
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			CONTROL DE VIAJES - VIATICO_XML 
-- // OPERACIÓN:		LIBERACIÓN / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			Daniel Portillo Romero
-- // Fecha creación:	16/NOV/2018
-- //////////////////////////////////////////////////////////////  

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_VIATICO_XML]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_VIATICO_XML]
GO


CREATE PROCEDURE [dbo].[PG_LI_VIATICO_XML]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_BUSCAR							VARCHAR(200),
	@PP_K_VIAJE							INT,
	@PP_K_PROVEEDOR_VIATICO				INT,
	@PP_F_INICIO						DATE,
	@PP_F_FIN							DATE
AS

	DECLARE @VP_MENSAJE					VARCHAR(300) = ''
	DECLARE @VP_L_APLICAR_MAX_ROWS		INT=1
		
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
															1, -- @PP_K_DATA_SISTEMA,	
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_LI_N_REGISTROS		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															@VP_L_APLICAR_MAX_ROWS,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- ///////////////////////////////////////////	
	
	DECLARE @VP_K_FOLIO				INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]			@PP_BUSCAR, 
															@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_L_VER_BORRADOS		INT		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]					@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- ///////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	SELECT		TOP (@VP_LI_N_REGISTROS)
				FECHA.D_TIEMPO_FECHA	AS F_VIATICO_DDMMMYYYY,
				FECHA_TIMBRADO.D_TIEMPO_FECHA	AS F_TIMBRADO_DDMMMYYYY,
				VIATICO_XML.*,
				PROVEEDOR_VIATICO.D_PROVEEDOR_VIATICO, PROVEEDOR_VIATICO.S_PROVEEDOR_VIATICO,
				D_USUARIO AS D_USUARIO_CAMBIO
				-- =============================	
	FROM		VIATICO_XML, 
				TIEMPO_FECHA AS FECHA,
				TIEMPO_FECHA AS FECHA_TIMBRADO, 
				VIAJE, PROVEEDOR_VIATICO, USUARIO
				-- =============================
	WHERE		VIATICO_XML.K_PROVEEDOR_VIATICO=PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO
	AND			VIATICO_XML.K_VIAJE=VIAJE.K_VIAJE
	AND			VIATICO_XML.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
				-- =============================
	AND			VIATICO_XML.VIATICO_XML_Fecha=FECHA.F_TIEMPO_FECHA
	AND			VIATICO_XML.VIATICO_XML_FechaTimbrado=FECHA_TIMBRADO.F_TIEMPO_FECHA
				-- =============================
	AND			(	VIATICO_XML.C_VIATICO_XML							LIKE '%'+@PP_BUSCAR+'%'
				OR	PROVEEDOR_VIATICO.D_PROVEEDOR_VIATICO				LIKE '%'+@PP_BUSCAR+'%' 
				OR	PROVEEDOR_VIATICO.C_PROVEEDOR_VIATICO				LIKE '%'+@PP_BUSCAR+'%'
				OR	PROVEEDOR_VIATICO.RAZON_SOCIAL_PROVEEDOR_VIATICO	LIKE '%'+@PP_BUSCAR+'%'
				OR	PROVEEDOR_VIATICO.RFC_PROVEEDOR_VIATICO				LIKE '%'+@PP_BUSCAR+'%'
				OR	VIATICO_XML.VIATICO_XML_Folio						LIKE '%'+@PP_BUSCAR+'%'
				OR	VIATICO_XML.VIATICO_XML_LugarExpedicion				LIKE '%'+@PP_BUSCAR+'%'
				OR	VIATICO_XML.VIATICO_XML_Serie						LIKE '%'+@PP_BUSCAR+'%'
				OR	VIATICO_XML.VIATICO_XML_UUID						LIKE '%'+@PP_BUSCAR+'%'
				OR	VIATICO_XML.VIATICO_XML_Version						LIKE '%'+@PP_BUSCAR+'%'
				OR	VIATICO_XML.VIATICO_XML_Total						LIKE '%'+@PP_BUSCAR+'%'
				OR	VIATICO_XML.VIATICO_XML_TipoDeComprobante			LIKE '%'+@PP_BUSCAR+'%'
				OR  VIATICO_XML.K_VIATICO_XML=@VP_K_FOLIO
				OR  PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO=@VP_K_FOLIO							)
				-- =============================
	AND			( @PP_F_INICIO IS NULL				OR	@PP_F_INICIO<=VIATICO_XML.VIATICO_XML_Fecha )
	AND			( @PP_F_FIN	IS NULL					OR	@PP_F_FIN>=VIATICO_XML.VIATICO_XML_Fecha )
				-- =============================
	AND			( @PP_K_VIAJE=-1				OR	VIAJE.K_VIAJE=@PP_K_VIAJE )
	AND			( @PP_K_PROVEEDOR_VIATICO=-1	OR	PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO=@PP_K_PROVEEDOR_VIATICO )
	AND			( @VP_L_VER_BORRADOS=1			OR	VIATICO_XML.L_BORRADO=0 )
				-- =============================
	ORDER BY	K_VIATICO_XML	DESC
	
	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_VIATICO_XML]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_VIATICO_XML]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_VIATICO_XML]
GO


CREATE PROCEDURE [dbo].[PG_SK_VIATICO_XML]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VIATICO_XML				INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_L_VER_BORRADOS		INT		
	
		EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT = 100
	
		IF @VP_MENSAJE<>''
			SET @VP_LI_N_REGISTROS = 0
			
		SELECT	TOP (@VP_LI_N_REGISTROS)
				FECHA.D_TIEMPO_FECHA	AS F_VIATICO_DDMMMYYYY,
				FECHA_TIMBRADO.D_TIEMPO_FECHA	AS F_TIMBRADO_DDMMMYYYY,
				VIATICO_XML.*,
				PROVEEDOR_VIATICO.D_PROVEEDOR_VIATICO, PROVEEDOR_VIATICO.S_PROVEEDOR_VIATICO,
				D_USUARIO AS D_USUARIO_CAMBIO
				-- =====================
		FROM	VIATICO_XML, 
				TIEMPO_FECHA AS FECHA,
				TIEMPO_FECHA AS FECHA_TIMBRADO, 
				VIAJE, PROVEEDOR_VIATICO, USUARIO
				-- =====================
		WHERE	VIATICO_XML.K_PROVEEDOR_VIATICO=PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO
		AND		VIATICO_XML.K_VIAJE=VIAJE.K_VIAJE
		AND		VIATICO_XML.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
		AND		VIATICO_XML.K_VIATICO_XML=@PP_K_VIATICO_XML
		AND		VIATICO_XML.VIATICO_XML_Fecha=FECHA.F_TIEMPO_FECHA
		AND		VIATICO_XML.VIATICO_XML_FechaTimbrado=FECHA_TIMBRADO.F_TIEMPO_FECHA
				-- =============================
		

	-- ////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_VIATICO_XML]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_VIATICO_XML, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_K_VIATICO_XML, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO



	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_VIATICO_XML]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_VIATICO_XML]
GO


CREATE PROCEDURE [dbo].[PG_IN_VIATICO_XML]
	@PP_L_DEBUG									INT,
	@PP_K_SISTEMA_EXE							INT,
	@PP_K_USUARIO_ACCION						INT,
	-- ===========================
	@PP_C_VIATICO_XML							VARCHAR(255),
	@PP_K_VIAJE									INT,
	-- ===========================
	@PP_VIATICO_XML_Fecha						DATETIME,						
	@PP_VIATICO_XML_Folio						VARCHAR(100),
	@PP_VIATICO_XML_FormaPago					VARCHAR(100),	
	@PP_VIATICO_XML_LugarExpedicion				VARCHAR(100),
	@PP_VIATICO_XML_MetodoPago					VARCHAR(100),
	@PP_VIATICO_XML_Moneda						VARCHAR(100),
	@PP_VIATICO_XML_NoCertificado				VARCHAR(100),
	@PP_VIATICO_XML_Serie						VARCHAR(100),
	@PP_VIATICO_XML_SubTotal					DECIMAL(19,4),
	@PP_VIATICO_XML_TipoCambio					VARCHAR(100),
	@PP_VIATICO_XML_TipoDeComprobante			VARCHAR(100),
	@PP_VIATICO_XML_Total						DECIMAL(19,4),	
	@PP_VIATICO_XML_Version						VARCHAR(100),
	-- ===========================
	@PP_VIATICO_XML_EMI_Nombre					VARCHAR(100),
	@PP_VIATICO_XML_EMI_RegimenFiscal			VARCHAR(100),
	@PP_VIATICO_XML_EMI_Rfc						VARCHAR(100),
	-- ===========================
	@PP_VIATICO_XML_REC_Nombre					VARCHAR(100),
	@PP_VIATICO_XML_REC_Rfc						VARCHAR(100),
	@PP_VIATICO_XML_REC_UsoCFDI					VARCHAR(100),
	-- ===========================
	@PP_VIATICO_XML_TotalImpuestosTrasladados	DECIMAL(19,4),
	@PP_VIATICO_XML_Importe						DECIMAL(19,4),
	@PP_VIATICO_XML_Impuesto					VARCHAR(100),
	@PP_VIATICO_XML_TasaOCuota					VARCHAR(100),
	@PP_VIATICO_XML_TipoFactor					VARCHAR(100),
	-- ===========================
	@PP_VIATICO_XML_FechaTimbrado				DATETIME,
	@PP_VIATICO_XML_NoCertificadoSAT			VARCHAR(100),
	@PP_VIATICO_XML_UUID						VARCHAR(100),
	-- ===========================
	@PP_VIATICO_XML_ARCHIVO						NVARCHAR(MAX)

AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- ///////////////////////////////////////////////////
	DECLARE @VP_K_VIATICO_XML				INT = 0
	DECLARE @VP_K_PROVEEDOR_VIATICO			INT = 0
	
	SELECT	@VP_K_PROVEEDOR_VIATICO	=		PROVEEDOR_VIATICO.K_PROVEEDOR_VIATICO
									FROM	PROVEEDOR_VIATICO
									WHERE	PROVEEDOR_VIATICO.RFC_PROVEEDOR_VIATICO=@PP_VIATICO_XML_EMI_Rfc	
									
	-- ///////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_VIATICO_XML_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_VIATICO_XML, @PP_VIATICO_XML_Serie,@PP_VIATICO_XML_Folio,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
			EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															'VIATICO_XML', 
															@OU_K_TABLA_DISPONIBLE = @VP_K_VIATICO_XML	OUTPUT	
	-- ///////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		INSERT INTO VIATICO_XML
			(	[K_VIATICO_XML],							[C_VIATICO_XML],
				[K_VIAJE],									[K_PROVEEDOR_VIATICO],
				-- ===========================
				[VIATICO_XML_Fecha],						[VIATICO_XML_Folio],
				[VIATICO_XML_FormaPago],					[VIATICO_XML_LugarExpedicion],
				[VIATICO_XML_MetodoPago],					[VIATICO_XML_Moneda],
				[VIATICO_XML_NoCertificado],				[VIATICO_XML_Serie],						
				[VIATICO_XML_SubTotal],						[VIATICO_XML_TipoCambio],
				[VIATICO_XML_TipoDeComprobante],			[VIATICO_XML_Total],						
				[VIATICO_XML_Version],
				-- ===========================
				[VIATICO_XML_EMI_Nombre],					[VIATICO_XML_EMI_RegimenFiscal],			
				[VIATICO_XML_EMI_Rfc],					
				-- ===========================
				[VIATICO_XML_REC_Nombre],					[VIATICO_XML_REC_Rfc],					
				[VIATICO_XML_REC_UsoCFDI],				
				-- ===========================				 
				[VIATICO_XML_TotalImpuestosTrasladados],	[VIATICO_XML_Importe],
				[VIATICO_XML_Impuesto],						[VIATICO_XML_TasaOCuota],
				[VIATICO_XML_TipoFactor],					 
				-- ===========================				 
				[VIATICO_XML_FechaTimbrado],				[VIATICO_XML_NoCertificadoSAT],
				[VIATICO_XML_UUID],
				-- ===========================
				[VIATICO_XML_ARCHIVO],
				-- ===========================
				[K_USUARIO_ALTA],							[F_ALTA], 
				[K_USUARIO_CAMBIO],							[F_CAMBIO],
				[L_BORRADO], 
				[K_USUARIO_BAJA],							[F_BAJA]  )
		VALUES	
			(	@VP_K_VIATICO_XML,							@PP_C_VIATICO_XML,	
				@PP_K_VIAJE,								@VP_K_PROVEEDOR_VIATICO,
				-- ===========================
				@PP_VIATICO_XML_Fecha,						@PP_VIATICO_XML_Folio,
				@PP_VIATICO_XML_FormaPago,					@PP_VIATICO_XML_LugarExpedicion,
				@PP_VIATICO_XML_MetodoPago,					@PP_VIATICO_XML_Moneda,
				@PP_VIATICO_XML_NoCertificado,				@PP_VIATICO_XML_Serie,
				@PP_VIATICO_XML_SubTotal,					@PP_VIATICO_XML_TipoCambio,					
				@PP_VIATICO_XML_TipoDeComprobante,			@PP_VIATICO_XML_Total,
				@PP_VIATICO_XML_Version,						
				-- ===========================			
				@PP_VIATICO_XML_EMI_Nombre,					@PP_VIATICO_XML_EMI_RegimenFiscal,			
				@PP_VIATICO_XML_EMI_Rfc,						
				-- ===========================
				@PP_VIATICO_XML_REC_Nombre,					@PP_VIATICO_XML_REC_Rfc,						
				@PP_VIATICO_XML_REC_UsoCFDI,					
				-- ===========================
				@PP_VIATICO_XML_TotalImpuestosTrasladados,	@PP_VIATICO_XML_Importe,
				@PP_VIATICO_XML_Impuesto,					@PP_VIATICO_XML_TasaOCuota,
				@PP_VIATICO_XML_TipoFactor,						
				-- ===========================			
				@PP_VIATICO_XML_FechaTimbrado,				@PP_VIATICO_XML_NoCertificadoSAT,
				@PP_VIATICO_XML_UUID,
				-- ===========================
				@PP_VIATICO_XML_ARCHIVO,			
				-- ===========================
				@PP_K_USUARIO_ACCION,						GETDATE(), 
				@PP_K_USUARIO_ACCION,						GETDATE(),
				0, 
				NULL,										NULL		)
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [XML de Viático]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#XMLV.'+CONVERT(VARCHAR(10),@VP_K_VIATICO_XML)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
	
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_VIATICO_XML AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_VIATICO_XML]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_VIATICO_XML, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, @PP_C_VIATICO_XML, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_VIATICO_XML', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_VIATICO_XML]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_VIATICO_XML]
GO

CREATE PROCEDURE [dbo].[PG_UP_VIATICO_XML]
	@PP_L_DEBUG									INT,
	@PP_K_SISTEMA_EXE							INT,
	@PP_K_USUARIO_ACCION						INT,
	-- ===========================
	@PP_K_VIATICO_XML							INT,
	-- ===========================
	@PP_C_VIATICO_XML							VARCHAR(255),
	@PP_K_VIAJE									INT,
	@PP_K_PROVEEDOR_VIATICO						INT,
	-- ===========================
	@PP_VIATICO_XML_Fecha						DATETIME,						
	@PP_VIATICO_XML_Folio						VARCHAR(100),
	@PP_VIATICO_XML_FormaPago					VARCHAR(100),	
	@PP_VIATICO_XML_LugarExpedicion				VARCHAR(100),
	@PP_VIATICO_XML_MetodoPago					VARCHAR(100),
	@PP_VIATICO_XML_Moneda						VARCHAR(100),
	@PP_VIATICO_XML_NoCertificado				VARCHAR(100),
	@PP_VIATICO_XML_Serie						VARCHAR(100),
	@PP_VIATICO_XML_SubTotal					DECIMAL(19,4),
	@PP_VIATICO_XML_TipoCambio					VARCHAR(100),
	@PP_VIATICO_XML_TipoDeComprobante			VARCHAR(100),
	@PP_VIATICO_XML_Total						DECIMAL(19,4),	
	@PP_VIATICO_XML_Version						VARCHAR(100),
	-- ===========================
	@PP_VIATICO_XML_EMI_Nombre					VARCHAR(100),
	@PP_VIATICO_XML_EMI_RegimenFiscal			VARCHAR(100),
	@PP_VIATICO_XML_EMI_Rfc						VARCHAR(100),
	-- ===========================
	@PP_VIATICO_XML_REC_Nombre					VARCHAR(100),
	@PP_VIATICO_XML_REC_Rfc						VARCHAR(100),
	@PP_VIATICO_XML_REC_UsoCFDI					VARCHAR(100),
	-- ===========================
	@PP_VIATICO_XML_TotalImpuestosTrasladados	DECIMAL(19,4),
	@PP_VIATICO_XML_Importe						DECIMAL(19,4),
	@PP_VIATICO_XML_Impuesto					VARCHAR(100),
	@PP_VIATICO_XML_TasaOCuota					VARCHAR(100),
	@PP_VIATICO_XML_TipoFactor					VARCHAR(100),
	-- ===========================
	@PP_VIATICO_XML_FechaTimbrado				DATETIME,
	@PP_VIATICO_XML_NoCertificadoSAT			VARCHAR(100),
	@PP_VIATICO_XML_UUID						VARCHAR(100),
	-- ===========================
	@PP_VIATICO_XML_ARCHIVO						NVARCHAR(MAX)
AS			

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_VIATICO_XML_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_VIATICO_XML, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	--IF @VP_MENSAJE=''
	--	EXECUTE [dbo].[PG_RN_VIATICO_XML_UNIQUE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
	--														@PP_K_VIATICO_XML, 
	--														@PP_D_VIATICO_XML, @PP_RFC_VIATICO_XML,
	--														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	VIATICO_XML
		SET		[C_VIATICO_XML]							=	@PP_C_VIATICO_XML,
				[K_VIAJE]								=	@PP_K_VIAJE,
				[K_PROVEEDOR_VIATICO]					=	@PP_K_PROVEEDOR_VIATICO,
				-- ========================== 
				[VIATICO_XML_Fecha]						=	@PP_VIATICO_XML_Fecha,			
				[VIATICO_XML_Folio]						=	@PP_VIATICO_XML_Folio,						
				[VIATICO_XML_FormaPago]					=	@PP_VIATICO_XML_FormaPago,
				[VIATICO_XML_LugarExpedicion]			=	@PP_VIATICO_XML_LugarExpedicion,
				[VIATICO_XML_MetodoPago]				=	@PP_VIATICO_XML_MetodoPago,			
				[VIATICO_XML_Moneda]					=	@PP_VIATICO_XML_Moneda,				
				[VIATICO_XML_NoCertificado]				=	@PP_VIATICO_XML_NoCertificado,
				[VIATICO_XML_Serie]						=	@PP_VIATICO_XML_Serie,						
				[VIATICO_XML_SubTotal]					=	@PP_VIATICO_XML_SubTotal,
				[VIATICO_XML_TipoCambio]				=	@PP_VIATICO_XML_TipoCambio,					
				[VIATICO_XML_TipoDeComprobante]			=	@PP_VIATICO_XML_TipoDeComprobante,
				[VIATICO_XML_Total]						=	@PP_VIATICO_XML_Total,		
				[VIATICO_XML_Version]					=	@PP_VIATICO_XML_Version,						
				-- ============================
				[VIATICO_XML_EMI_Nombre]				=	@PP_VIATICO_XML_EMI_Nombre,
				[VIATICO_XML_EMI_RegimenFiscal]			=	@PP_VIATICO_XML_EMI_RegimenFiscal,
				[VIATICO_XML_EMI_Rfc]					=	@PP_VIATICO_XML_EMI_Rfc,
				-- ============================			
				[VIATICO_XML_REC_Nombre]				=	@PP_VIATICO_XML_REC_Nombre,
				[VIATICO_XML_REC_Rfc]					=	@PP_VIATICO_XML_REC_Rfc,
				[VIATICO_XML_REC_UsoCFDI]				=	@PP_VIATICO_XML_REC_UsoCFDI,
				-- ===========================
				
				[VIATICO_XML_TotalImpuestosTrasladados] =	@PP_VIATICO_XML_TotalImpuestosTrasladados,
				[VIATICO_XML_Importe]					=	@PP_VIATICO_XML_Importe,	
				[VIATICO_XML_Impuesto]					=	@PP_VIATICO_XML_Impuesto,
				[VIATICO_XML_TasaOCuota]				=	@PP_VIATICO_XML_TasaOCuota,
				[VIATICO_XML_TipoFactor]				=	@PP_VIATICO_XML_TipoFactor,					
				-- ============================	
				[VIATICO_XML_FechaTimbrado]				=	@PP_VIATICO_XML_FechaTimbrado,
				[VIATICO_XML_NoCertificadoSAT]			=	@PP_VIATICO_XML_NoCertificadoSAT,
				[VIATICO_XML_UUID]						=	@PP_VIATICO_XML_UUID,			
				-- =============================
				[VIATICO_XML_ARCHIVO]					=	@PP_VIATICO_XML_ARCHIVO,
				-- =============================
				[F_CAMBIO]								= GETDATE(), 
				[K_USUARIO_CAMBIO]						= @PP_K_USUARIO_ACCION
		WHERE	K_VIATICO_XML=@PP_K_VIATICO_XML
	
	END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [XML de Viático]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#XMLV.'+CONVERT(VARCHAR(10),@PP_K_VIATICO_XML)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_VIATICO_XML AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_VIATICO_XML]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_VIATICO_XML, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_VIATICO_XML, '', 0.00, 0.00,
													0, 0, @PP_C_VIATICO_XML, '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_VIATICO_XML', '', '', ''

	-- //////////////////////////////////////////////////////////////
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_VIATICO_XML]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_VIATICO_XML]
GO


CREATE PROCEDURE [dbo].[PG_DL_VIATICO_XML]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_VIATICO_XML				INT
AS

	DECLARE @VP_MENSAJE				VARCHAR(300) = ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_VIATICO_XML_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_VIATICO_XML, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
		UPDATE	VIATICO_XML
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_VIATICO_XML=@PP_K_VIATICO_XML
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [XML de Viático]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#XMLV.'+CONVERT(VARCHAR(10),@PP_K_VIATICO_XML)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_VIATICO_XML AS CLAVE

	-- //////////////////////////////////////////////////////////////
	
	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_VIATICO_XML]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_VIATICO_XML, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
	
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
