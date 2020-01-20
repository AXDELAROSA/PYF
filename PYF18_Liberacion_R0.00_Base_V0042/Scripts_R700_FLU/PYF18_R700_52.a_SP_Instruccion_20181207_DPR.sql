-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:		PYF18_Finanzas
-- // MODULO:				INSTRUCCION
-- // OPERACION:			LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:				HECTOR A. GONZALEZ DE LA FUENTE
-- // Modificador:			DANIEL PORTILLO ROMERO (Por integración de RNs de Control)
-- // Fecha creación:		18/SEP/2018
-- // Fecha modificación:	07/DIC/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  LISTADO
-- //////////////////////////////////////////////////////////////
--	EXECUTE [dbo].[PG_LI_INSTRUCCION]	0,0,69,		0,'',		-1,-1,-1,	NULL, NULL


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APG_UP_INSTRUCCION_PAGO_APLICADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[APG_UP_INSTRUCCION_PAGO_APLICADO]
GO	


CREATE PROCEDURE [dbo].[APG_UP_INSTRUCCION_PAGO_APLICADO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_SOLICITUD			INT,
	@PP_FECHA_PAGO			DATE,
	@PP_K_INSTRUCCION		INT
AS

	-- K_ESTATUS_INSTRUCCION	
	-- 1 REPORTADO // 2 PAGO POR APLICAR // 3 APLICADO A COBRANZA // 4 CANCELADO
	
	UPDATE	INSTRUCCION
	SET		
			K_ESTATUS_INSTRUCCION = 3
	WHERE	K_INSTRUCCION=@PP_K_INSTRUCCION
	AND		L_BORRADO=0
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  LISTADO
-- //////////////////////////////////////////////////////////////
--	EXECUTE [dbo].[PG_LI_INSTRUCCION]	0,0,69,		0,'',		-1,-1,-1,	NULL, NULL

-- SELECT * FROM INSTRUCCION


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_INSTRUCCION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_INSTRUCCION]
GO	


CREATE PROCEDURE [dbo].[PG_LI_INSTRUCCION]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_D_INSTRUCCION				VARCHAR(255),
	-- ===========================
	@PP_K_TIPO_INSTRUCCION			INT,
	@PP_K_ESTATUS_INSTRUCCION		INT,
	@PP_K_CUENTA_BANCO				INT,
	@PP_F_INICIO					DATE,
	@PP_F_FIN						DATE
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													8, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_LI_N_REGISTROS		INT
	
	SET @VP_LI_N_REGISTROS = 1000
	
	EXECUTE [dbo].[PG_SK_CONFIGURACION_LI_N_REGISTROS_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
															1,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- =========================================	
	
	IF NOT (@VP_MENSAJE='')
		SET @VP_LI_N_REGISTROS = 0

	-- ///////////////////////////////////////////

	SELECT	TOP ( @VP_LI_N_REGISTROS )		
			TIEMPO_FECHA.D_TIEMPO_FECHA	AS F_INSTRUCCION_DDMMMYYYY,
			INSTRUCCION.*,
			PROVEEDOR.RFC_PROVEEDOR,
			D_TIPO_INSTRUCCION, D_ESTATUS_INSTRUCCION,
			S_TIPO_INSTRUCCION, S_ESTATUS_INSTRUCCION,
			CUENTA_BANCO.CUENTA, D_FORMA_INSTRUCCION,
			-- =============================
			D_RAZON_SOCIAL, D_UNIDAD_OPERATIVA, D_PROVEEDOR,
			S_RAZON_SOCIAL, S_UNIDAD_OPERATIVA, S_PROVEEDOR,
			-- =============================
			D_USUARIO AS D_USUARIO_CAMBIO
	FROM	INSTRUCCION, 
			TIEMPO_FECHA,
			TIPO_INSTRUCCION, ESTATUS_INSTRUCCION,
			CUENTA_BANCO, FORMA_INSTRUCCION, 
			-- =============================
			RAZON_SOCIAL, UNIDAD_OPERATIVA, PROVEEDOR,
			-- =============================
			USUARIO
	WHERE	INSTRUCCION.K_TIPO_INSTRUCCION=TIPO_INSTRUCCION.K_TIPO_INSTRUCCION
	AND		INSTRUCCION.K_ESTATUS_INSTRUCCION=ESTATUS_INSTRUCCION.K_ESTATUS_INSTRUCCION
	AND		INSTRUCCION.K_CUENTA_BANCO=CUENTA_BANCO.K_CUENTA_BANCO
	AND		INSTRUCCION.K_TIPO_INSTRUCCION=TIPO_INSTRUCCION.K_TIPO_INSTRUCCION
	AND		INSTRUCCION.K_FORMA_INSTRUCCION=FORMA_INSTRUCCION.K_FORMA_INSTRUCCION
	AND		INSTRUCCION.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- =====================
	AND		INSTRUCCION.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL
	AND		INSTRUCCION.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND		INSTRUCCION.K_PROVEEDOR=PROVEEDOR.K_PROVEEDOR
	AND		INSTRUCCION.F_INSTRUCCION=TIEMPO_FECHA.F_TIEMPO_FECHA
			-- =====================
	AND		(	
				REFERENCIA_1			LIKE '%'+@PP_D_INSTRUCCION+'%' 
			OR	REFERENCIA_2			LIKE '%'+@PP_D_INSTRUCCION+'%' 
			OR	BENEFICIARIO			LIKE '%'+@PP_D_INSTRUCCION+'%' 	
			OR	CUENTA					LIKE '%'+@PP_D_INSTRUCCION+'%'	
			OR	D_FORMA_INSTRUCCION		LIKE '%'+@PP_D_INSTRUCCION+'%'	
			OR	D_RAZON_SOCIAL			LIKE '%'+@PP_D_INSTRUCCION+'%'	
			OR	D_UNIDAD_OPERATIVA		LIKE '%'+@PP_D_INSTRUCCION+'%'	
			OR	D_PROVEEDOR				LIKE '%'+@PP_D_INSTRUCCION+'%'	
			)			
			-- =====================
	AND		( @PP_F_INICIO IS NULL					OR	@PP_F_INICIO<=INSTRUCCION.F_INSTRUCCION )
	AND		( @PP_F_FIN	IS NULL						OR	INSTRUCCION.F_INSTRUCCION<=@PP_F_FIN )
			-- =====================
	AND		( @PP_K_TIPO_INSTRUCCION=-1				OR	@PP_K_TIPO_INSTRUCCION=INSTRUCCION.K_TIPO_INSTRUCCION )
	AND		( @PP_K_ESTATUS_INSTRUCCION=-1			OR	@PP_K_ESTATUS_INSTRUCCION=INSTRUCCION.K_ESTATUS_INSTRUCCION )
	AND		( @PP_K_CUENTA_BANCO=-1					OR	@PP_K_CUENTA_BANCO=INSTRUCCION.K_CUENTA_BANCO )
	AND		INSTRUCCION.L_BORRADO=0
			-- =====================
--	ORDER BY F_INSTRUCCION DESC
	ORDER BY K_INSTRUCCION DESC

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SEEK 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_INSTRUCCION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_INSTRUCCION]
GO	

CREATE PROCEDURE [dbo].[PG_SK_INSTRUCCION]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_INSTRUCCION				INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													8, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_N_LINEAS	INT = 1000
	
	IF NOT (@VP_MENSAJE='')
		SET @VP_N_LINEAS = 0

	-- ///////////////////////////////////////////

	SELECT	TOP ( @VP_N_LINEAS )		
			INSTRUCCION.*,
			TIEMPO_FECHA.D_TIEMPO_FECHA	AS F_INSTRUCCION_DDMMMYYYY,
			D_TIPO_INSTRUCCION, D_ESTATUS_INSTRUCCION,
			S_TIPO_INSTRUCCION, S_ESTATUS_INSTRUCCION,
			CUENTA_BANCO.CUENTA, D_FORMA_INSTRUCCION,
			-- =============================
			D_RAZON_SOCIAL, D_UNIDAD_OPERATIVA, D_PROVEEDOR,
			S_RAZON_SOCIAL, S_UNIDAD_OPERATIVA, S_PROVEEDOR,
			-- =============================
			D_USUARIO AS D_USUARIO_CAMBIO
	FROM	INSTRUCCION, 
			TIEMPO_FECHA,
			TIPO_INSTRUCCION, ESTATUS_INSTRUCCION,
			CUENTA_BANCO, FORMA_INSTRUCCION, 
			-- =============================
			RAZON_SOCIAL, UNIDAD_OPERATIVA, PROVEEDOR,
			-- =============================
			USUARIO
	WHERE	INSTRUCCION.K_TIPO_INSTRUCCION=TIPO_INSTRUCCION.K_TIPO_INSTRUCCION
	AND		INSTRUCCION.K_ESTATUS_INSTRUCCION=ESTATUS_INSTRUCCION.K_ESTATUS_INSTRUCCION
	AND		INSTRUCCION.K_CUENTA_BANCO=CUENTA_BANCO.K_CUENTA_BANCO
	AND		INSTRUCCION.K_TIPO_INSTRUCCION=TIPO_INSTRUCCION.K_TIPO_INSTRUCCION
	AND		INSTRUCCION.K_FORMA_INSTRUCCION=FORMA_INSTRUCCION.K_FORMA_INSTRUCCION
	AND		INSTRUCCION.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- =====================
	AND		INSTRUCCION.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL
	AND		INSTRUCCION.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND		INSTRUCCION.K_PROVEEDOR=PROVEEDOR.K_PROVEEDOR
	AND		INSTRUCCION.F_INSTRUCCION=TIEMPO_FECHA.F_TIEMPO_FECHA
			-- =====================
	AND		INSTRUCCION.L_BORRADO=0
	AND		INSTRUCCION.K_INSTRUCCION=@PP_K_INSTRUCCION

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_INSTRUCCION_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_INSTRUCCION_SQL]
GO


CREATE PROCEDURE [dbo].[PG_IN_INSTRUCCION_SQL] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_INSTRUCCION				INT,
	@PP_K_TIPO_INSTRUCCION			INT,
	@PP_K_ESTATUS_INSTRUCCION		INT,
	@PP_K_FORMA_INSTRUCCION			INT, 
	@PP_L_CAPTURA_MANUAL			INT,
	-- =============================
	@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO	INT,
	@PP_K_CUENTA_BANCO				INT,
	@PP_F_INSTRUCCION				DATE, 
	-- =============================
	@PP_K_RAZON_SOCIAL				INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_PROVEEDOR					INT,
	-- =============================
	@PP_BENEFICIARIO				VARCHAR(100),
	@PP_REFERENCIA_1				VARCHAR(500),
	@PP_REFERENCIA_2				VARCHAR(500), 
	@PP_MONTO_INSTRUCCION			DECIMAL(19,4)
	-- =============================
AS			

	INSERT INTO [INSTRUCCION]	
			(	[K_INSTRUCCION],
				[K_TIPO_INSTRUCCION], [K_ESTATUS_INSTRUCCION], [K_FORMA_INSTRUCCION],
				[L_CAPTURA_MANUAL],
				-- ===========================
				[K_RESUMEN_FLUJO_DIARIO_X_UNO],
				[K_CUENTA_BANCO], [F_INSTRUCCION],
				[K_RAZON_SOCIAL], [K_UNIDAD_OPERATIVA], [K_PROVEEDOR],
				[BENEFICIARIO], [REFERENCIA_1], [REFERENCIA_2],
				[MONTO_INSTRUCCION],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )	
			VALUES
			(	@PP_K_INSTRUCCION,
				@PP_K_TIPO_INSTRUCCION, @PP_K_ESTATUS_INSTRUCCION, @PP_K_FORMA_INSTRUCCION,
				@PP_L_CAPTURA_MANUAL,
				-- ===========================
				@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO,
				@PP_K_CUENTA_BANCO, @PP_F_INSTRUCCION,
				@PP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @PP_K_PROVEEDOR,	
				@PP_BENEFICIARIO, @PP_REFERENCIA_1, @PP_REFERENCIA_2,
				@PP_MONTO_INSTRUCCION,			
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  GENERAR INSTRUCCIÓN
-- //////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_INSTRUCCION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_INSTRUCCION]
GO

CREATE PROCEDURE [dbo].[PG_IN_INSTRUCCION] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_TIPO_INSTRUCCION			INT,
	@PP_K_FORMA_INSTRUCCION			INT, 
	-- =============================
	@PP_K_CUENTA_BANCO				INT,
	@PP_F_INSTRUCCION				DATE, 
	-- =============================
	@PP_K_RAZON_SOCIAL				INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_PROVEEDOR					INT,
	-- =============================
	@PP_BENEFICIARIO				VARCHAR(100),
	@PP_REFERENCIA_1				VARCHAR(500),
	@PP_REFERENCIA_2				VARCHAR(500), 
	@PP_MONTO_INSTRUCCION			DECIMAL(19,4)
	-- =============================
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_CUENTA_BANCO, @PP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, 
														@PP_F_INSTRUCCION,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
														
	-- /////////////////////////////////////////////////////////////////////

	DECLARE @VP_K_INSTRUCCION			INT = 0

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'INSTRUCCION', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_INSTRUCCION			OUTPUT
		-- ================================
		
		DECLARE @PP_K_RESUMEN_FLUJO_DIARIO_X_UNO	INT = 0
		DECLARE @PP_L_CAPTURA_MANUAL				INT = 1
		DECLARE @PP_K_ESTATUS_INSTRUCCION			INT = 1

		EXECUTE [dbo].[PG_IN_INSTRUCCION_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@VP_K_INSTRUCCION,
												@PP_K_TIPO_INSTRUCCION, @PP_K_ESTATUS_INSTRUCCION, @PP_K_FORMA_INSTRUCCION, 
												@PP_L_CAPTURA_MANUAL,
												@PP_K_RESUMEN_FLUJO_DIARIO_X_UNO, @PP_K_CUENTA_BANCO, @PP_F_INSTRUCCION, 
												@PP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @PP_K_PROVEEDOR,
												@PP_BENEFICIARIO, @PP_REFERENCIA_1, @PP_REFERENCIA_2, @PP_MONTO_INSTRUCCION
						
		END

-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible <Crear> la Instrucción: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#INS.'+CONVERT(VARCHAR(10),@VP_K_INSTRUCCION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_INSTRUCCION AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APG_IN_INSTRUCCION_X_K_SOLICITUD]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[APG_IN_INSTRUCCION_X_K_SOLICITUD]
GO


CREATE PROCEDURE [dbo].[APG_IN_INSTRUCCION_X_K_SOLICITUD] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_SOLICITUD					INT,
	@PP_K_FORMA_INSTRUCCION			INT, 
	-- =============================
	@PP_F_INSTRUCCION					DATE, 
	@PP_MONTO_INSTRUCCION			DECIMAL(19,4)
AS			

	DECLARE @VP_K_TIPO_INSTRUCCION		INT = 101		-- 101	PAGO
	DECLARE @VP_F_LIQ						DATE = GETDATE() 	
	DECLARE @VP_REFERENCIA_1				VARCHAR(500) = 'PAGO MANUAL DESDE [MO-PRE]'
	DECLARE @VP_REFERENCIA_2					VARCHAR(500) = 'N/A'

	-- =====================

	DECLARE @VP_BENEFICIARIO			VARCHAR(100)

	SELECT	@VP_BENEFICIARIO =		BENEFICIARIO
									FROM	SOLICITUD, CLIENTE
									WHERE	SOLICITUD.K_CLIENTE=CLIENTE.K_CLIENTE
									AND		SOLICITUD.K_SOLICITUD=@PP_K_SOLICITUD
	-- =====================

	DECLARE @VP_K_CUENTA_BANCO		INT
	
	SELECT	@VP_K_CUENTA_BANCO =	MIN(K_CUENTA_BANCO)
									FROM	SOLICITUD, PLANTA, EMPRESA, CUENTA_BANCO
									WHERE	SOLICITUD.K_SOLICITUD=@PP_K_SOLICITUD
									AND		SOLICITUD.K_PLANTA=PLANTA.K_PLANTA
									AND		PLANTA.K_EMPRESA=EMPRESA.K_EMPRESA
									AND		EMPRESA.K_EMPRESA=CUENTA_BANCO.K_EMPRESA
	-- =====================
/*
	EXECUTE [dbo].[APG_IN_INSTRUCCION]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@VP_K_TIPO_INSTRUCCION, @PP_K_FORMA_INSTRUCCION, @VP_BENEFICIARIO, @VP_K_CUENTA_BANCO,
											@PP_F_INSTRUCCION, @VP_F_LIQ, @VP_REFERENCIA_1, @VP_REFERENCIA_2, @PP_MONTO_INSTRUCCION
*/
	-- //////////////////////////////////////////////////////////////
GO






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APG_IN_INSTRUCCION_NEUTRO_X_K_SOLICITUD]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[APG_IN_INSTRUCCION_NEUTRO_X_K_SOLICITUD]
GO


CREATE PROCEDURE [dbo].[APG_IN_INSTRUCCION_NEUTRO_X_K_SOLICITUD] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_SOLICITUD					INT,
	-- =============================
	@PP_F_INSTRUCCION					DATE, 
	@PP_MONTO_INSTRUCCION			DECIMAL(19,4),
	@OU_K_INSTRUCCION				INT			OUTPUT
AS			

	DECLARE @VP_K_TIPO_INSTRUCCION		INT = 2			-- 2	CONDONACION
	DECLARE @VP_K_ESTATUS_INSTRUCCION	INT = 2			-- 2	PAGO X APLICAR
	DECLARE @VP_F_LIQ						DATE = GETDATE() 	
	DECLARE @VP_REFERENCIA_1				VARCHAR(500) = 'CONDONACION MANUAL DESDE [MO-PRE]'
	DECLARE @VP_REFERENCIA_2					VARCHAR(500) = 'N/A'
	DECLARE @VP_K_FORMA_INSTRUCCION				INT = 4			-- CONDONACION, 
	DECLARE @VP_L_CAPTURA_MANUAL			INT = 1
	DECLARE @VP_SALDO						DECIMAL(19,4) = 0

	-- =====================

	DECLARE @VP_BENEFICIARIO		VARCHAR(100)

	SELECT	@VP_BENEFICIARIO =		BENEFICIARIO
									FROM	SOLICITUD, CLIENTE
									WHERE	SOLICITUD.K_CLIENTE=CLIENTE.K_CLIENTE
									AND		SOLICITUD.K_SOLICITUD=@PP_K_SOLICITUD
	-- =====================

	DECLARE @VP_K_CUENTA_BANCO		INT
	
	SELECT	@VP_K_CUENTA_BANCO =	MIN(K_CUENTA_BANCO)
									FROM	SOLICITUD, PLANTA, EMPRESA, CUENTA_BANCO
									WHERE	SOLICITUD.K_SOLICITUD=@PP_K_SOLICITUD
									AND		SOLICITUD.K_PLANTA=PLANTA.K_PLANTA
									AND		PLANTA.K_EMPRESA=EMPRESA.K_EMPRESA
									AND		EMPRESA.K_EMPRESA=CUENTA_BANCO.K_EMPRESA
	-- =====================
	
	DECLARE @VP_K_INSTRUCCION			INT = 0

	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'INSTRUCCION', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_INSTRUCCION			OUTPUT
	-- ================================

	EXECUTE [dbo].[PG_IN_INSTRUCCION_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												-- ===========================
												@VP_K_INSTRUCCION, @VP_K_TIPO_INSTRUCCION, @VP_K_ESTATUS_INSTRUCCION,
												@VP_K_FORMA_INSTRUCCION, @VP_L_CAPTURA_MANUAL, @VP_BENEFICIARIO, @VP_K_CUENTA_BANCO,
												-- =============================
												@PP_F_INSTRUCCION, @VP_F_LIQ, @VP_REFERENCIA_1,
												@VP_REFERENCIA_2, @PP_MONTO_INSTRUCCION, @VP_SALDO
	-- =====================================
	 
	SET @OU_K_INSTRUCCION = @VP_K_INSTRUCCION

	-- //////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_INSTRUCCION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_INSTRUCCION]
GO


CREATE PROCEDURE [dbo].[PG_UP_INSTRUCCION]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_INSTRUCCION				INT,
	@PP_K_TIPO_INSTRUCCION			INT,
	@PP_K_FORMA_INSTRUCCION			INT, 
	-- =============================
	@PP_K_CUENTA_BANCO				INT,
	@PP_F_INSTRUCCION				DATE, 
	-- =============================
	@PP_K_RAZON_SOCIAL				INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_PROVEEDOR					INT,
	-- =============================
	@PP_BENEFICIARIO				VARCHAR(100),
	@PP_REFERENCIA_1				VARCHAR(500),
	@PP_REFERENCIA_2				VARCHAR(500), 
	@PP_MONTO_INSTRUCCION			DECIMAL(19,4)
	-- =============================
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_INSTRUCCION, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		UPDATE	INSTRUCCION
		SET		
				K_TIPO_INSTRUCCION		= @PP_K_TIPO_INSTRUCCION,
				K_FORMA_INSTRUCCION		= @PP_K_FORMA_INSTRUCCION, 
				-- =============================
				K_CUENTA_BANCO			= @PP_K_CUENTA_BANCO,
				F_INSTRUCCION			= @PP_F_INSTRUCCION, 
				-- =============================
				K_RAZON_SOCIAL			= @PP_K_RAZON_SOCIAL,
				K_UNIDAD_OPERATIVA		= @PP_K_UNIDAD_OPERATIVA,
				K_PROVEEDOR				= @PP_K_PROVEEDOR,
				-- =============================
				BENEFICIARIO			= @PP_BENEFICIARIO,
				REFERENCIA_1			= @PP_REFERENCIA_1,
				REFERENCIA_2			= @PP_REFERENCIA_2,
				MONTO_INSTRUCCION		= @PP_MONTO_INSTRUCCION,
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	K_INSTRUCCION=@PP_K_INSTRUCCION
		AND		L_BORRADO=0

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] la [Instrucción]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#INS.'+CONVERT(VARCHAR(10),@PP_K_INSTRUCCION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_INSTRUCCION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_INSTRUCCION]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_INSTRUCCION]
GO


CREATE PROCEDURE [dbo].[PG_DL_INSTRUCCION]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_INSTRUCCION		INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_INSTRUCCION_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_INSTRUCCION, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		UPDATE	INSTRUCCION
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_INSTRUCCION=@PP_K_INSTRUCCION
		AND		L_BORRADO=0

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la [Instrucción]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#INS.'+CONVERT(VARCHAR(10),@PP_K_INSTRUCCION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_INSTRUCCION AS CLAVE

	-- /////////////////////////////////////////////////////////////////////
GO



-- /////////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////////////////
