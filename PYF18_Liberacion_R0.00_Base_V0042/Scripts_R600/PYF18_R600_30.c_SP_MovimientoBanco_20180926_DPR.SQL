-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			MOVIMIENTOS BANCO
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	18/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  LISTADO
-- //////////////////////////////////////////////////////////////
--	EXECUTE [dbo].[PG_LI_MOVIMIENTO_BANCO]	0,0,69,		0,'',		-1,-1,-1,	NULL, NULL


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_MOVIMIENTO_BANCO_PAGO_APLICADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_MOVIMIENTO_BANCO_PAGO_APLICADO]
GO	


CREATE PROCEDURE [dbo].[PG_UP_MOVIMIENTO_BANCO_PAGO_APLICADO]
	@PP_L_DEBUG				INT,
	@PP_K_SISTEMA_EXE		INT,
	@PP_K_USUARIO_ACCION	INT,
	-- ===========================
	@PP_K_SOLICITUD			INT,
	@PP_FECHA_PAGO			DATE,
	@PP_K_MOVIMIENTO_BANCO	INT
AS

	-- K_ESTATUS_MOVIMIENTO_BANCO	
	-- 1 REPORTADO // 2 PAGO POR APLICAR // 3 APLICADO A COBRANZA // 4 CANCELADO
	
	UPDATE	MOVIMIENTO_BANCO
	SET		
			K_ESTATUS_MOVIMIENTO_BANCO = 3
	WHERE	K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
	AND		L_BORRADO=0
	
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  LISTADO
-- //////////////////////////////////////////////////////////////
--	EXECUTE [dbo].[PG_LI_MOVIMIENTO_BANCO]	0,0,69,		0,'',		-1,-1,-1,	NULL, NULL


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_MOVIMIENTO_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_MOVIMIENTO_BANCO]
GO	


CREATE PROCEDURE [dbo].[PG_LI_MOVIMIENTO_BANCO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_D_MOVIMIENTO_BANCO			VARCHAR(255),
	-- ===========================
	@PP_K_TIPO_MOVIMIENTO_BANCO		INT,
	@PP_K_ESTATUS_MOVIMIENTO_BANCO	INT,
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
															1, -- WIWI // @VP_L_APLICAR_MAX_ROWS,
															@OU_LI_N_REGISTROS = @VP_LI_N_REGISTROS		OUTPUT		
	-- =========================================	
	
	IF NOT (@VP_MENSAJE='')
		SET @VP_LI_N_REGISTROS = 0

	-- ///////////////////////////////////////////

	SELECT	TOP ( @VP_LI_N_REGISTROS )		
			F_OPE.D_TIEMPO_FECHA	AS F_MOVIMIENTO_BANCO_DDMMMYYYY,
			F_LIQ.D_TIEMPO_FECHA	AS F_LIQ_DDMMMYYYY,	
			MOVIMIENTO_BANCO.*,
			D_TIPO_MOVIMIENTO_BANCO, D_ESTATUS_MOVIMIENTO_BANCO,
			S_TIPO_MOVIMIENTO_BANCO, S_ESTATUS_MOVIMIENTO_BANCO,
			CUENTA_BANCO.CUENTA, D_FORMA_MOVIMIENTO_BANCO, D_USUARIO AS D_USUARIO_CAMBIO
	FROM	MOVIMIENTO_BANCO, 
			TIEMPO_FECHA AS F_OPE, TIEMPO_FECHA AS F_LIQ,
			TIPO_MOVIMIENTO_BANCO, ESTATUS_MOVIMIENTO_BANCO,
			CUENTA_BANCO, FORMA_MOVIMIENTO_BANCO, USUARIO
	WHERE	MOVIMIENTO_BANCO.K_TIPO_MOVIMIENTO_BANCO=TIPO_MOVIMIENTO_BANCO.K_TIPO_MOVIMIENTO_BANCO
	AND		MOVIMIENTO_BANCO.K_ESTATUS_MOVIMIENTO_BANCO=ESTATUS_MOVIMIENTO_BANCO.K_ESTATUS_MOVIMIENTO_BANCO
	AND		MOVIMIENTO_BANCO.K_CUENTA_BANCO=CUENTA_BANCO.K_CUENTA_BANCO
	AND		MOVIMIENTO_BANCO.K_TIPO_MOVIMIENTO_BANCO=TIPO_MOVIMIENTO_BANCO.K_TIPO_MOVIMIENTO_BANCO
	AND		MOVIMIENTO_BANCO.K_FORMA_MOVIMIENTO_BANCO=FORMA_MOVIMIENTO_BANCO.K_FORMA_MOVIMIENTO_BANCO
	AND		MOVIMIENTO_BANCO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- =====================
	AND		MOVIMIENTO_BANCO.F_MOVIMIENTO_BANCO=F_OPE.F_TIEMPO_FECHA
	AND		MOVIMIENTO_BANCO.F_LIQ=F_LIQ.F_TIEMPO_FECHA
			-- =====================
	AND		(	
				COD_DESCRIPCION		LIKE '%'+@PP_D_MOVIMIENTO_BANCO+'%' 
			OR	REFERENCIA			LIKE '%'+@PP_D_MOVIMIENTO_BANCO+'%' 
			OR	CIE_CLIENTE			LIKE '%'+@PP_D_MOVIMIENTO_BANCO+'%' 	
			OR	CUENTA				LIKE '%'+@PP_D_MOVIMIENTO_BANCO+'%'	
			OR	D_FORMA_MOVIMIENTO_BANCO		LIKE '%'+@PP_D_MOVIMIENTO_BANCO+'%'	
			)			
			-- =====================
	AND		( @PP_F_INICIO IS NULL						OR	@PP_F_INICIO<=MOVIMIENTO_BANCO.F_MOVIMIENTO_BANCO )
	AND		( @PP_F_FIN	IS NULL							OR	@PP_F_FIN>=MOVIMIENTO_BANCO.F_MOVIMIENTO_BANCO )
			-- =====================
	AND		( @PP_K_TIPO_MOVIMIENTO_BANCO=-1			OR	@PP_K_TIPO_MOVIMIENTO_BANCO=MOVIMIENTO_BANCO.K_TIPO_MOVIMIENTO_BANCO )
	AND		( @PP_K_ESTATUS_MOVIMIENTO_BANCO=-1			OR	@PP_K_ESTATUS_MOVIMIENTO_BANCO=MOVIMIENTO_BANCO.K_ESTATUS_MOVIMIENTO_BANCO )
	AND		( @PP_K_CUENTA_BANCO=-1						OR	@PP_K_CUENTA_BANCO=MOVIMIENTO_BANCO.K_CUENTA_BANCO )
	AND		MOVIMIENTO_BANCO.L_BORRADO=0
			-- =====================
--	ORDER BY F_MOVIMIENTO_BANCO DESC
	ORDER BY K_MOVIMIENTO_BANCO DESC

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SEEK 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_MOVIMIENTO_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_MOVIMIENTO_BANCO]
GO	

CREATE PROCEDURE [dbo].[PG_SK_MOVIMIENTO_BANCO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_MOVIMIENTO_BANCO			INT
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
			MOVIMIENTO_BANCO.*,
			D_TIPO_MOVIMIENTO_BANCO, D_ESTATUS_MOVIMIENTO_BANCO,
			S_TIPO_MOVIMIENTO_BANCO, S_ESTATUS_MOVIMIENTO_BANCO,
			CUENTA_BANCO.CUENTA, D_FORMA_MOVIMIENTO_BANCO
	FROM	MOVIMIENTO_BANCO, 
			TIPO_MOVIMIENTO_BANCO, ESTATUS_MOVIMIENTO_BANCO,
			CUENTA_BANCO, FORMA_MOVIMIENTO_BANCO
	WHERE	MOVIMIENTO_BANCO.K_TIPO_MOVIMIENTO_BANCO=TIPO_MOVIMIENTO_BANCO.K_TIPO_MOVIMIENTO_BANCO
	AND		MOVIMIENTO_BANCO.K_ESTATUS_MOVIMIENTO_BANCO=ESTATUS_MOVIMIENTO_BANCO.K_ESTATUS_MOVIMIENTO_BANCO
	AND		MOVIMIENTO_BANCO.K_TIPO_MOVIMIENTO_BANCO=TIPO_MOVIMIENTO_BANCO.K_TIPO_MOVIMIENTO_BANCO
	AND		MOVIMIENTO_BANCO.K_CUENTA_BANCO=CUENTA_BANCO.K_CUENTA_BANCO
	AND		MOVIMIENTO_BANCO.K_FORMA_MOVIMIENTO_BANCO=FORMA_MOVIMIENTO_BANCO.K_FORMA_MOVIMIENTO_BANCO
	AND		MOVIMIENTO_BANCO.K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
	AND		MOVIMIENTO_BANCO.L_BORRADO=0
			-- =====================
	ORDER BY K_MOVIMIENTO_BANCO

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_MOVIMIENTO_BANCO_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_MOVIMIENTO_BANCO_SQL]
GO


CREATE PROCEDURE [dbo].[PG_IN_MOVIMIENTO_BANCO_SQL] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_MOVIMIENTO_BANCO			INT,
	@PP_K_TIPO_MOVIMIENTO_BANCO		INT,
	@VP_K_ESTATUS_MOVIMIENTO_BANCO	INT,
	@PP_K_FORMA_MOVIMIENTO_BANCO	INT, 
	@VP_L_CAPTURA_MANUAL			INT,
	@PP_CIE_CLIENTE					VARCHAR(100),
	@PP_K_CUENTA_BANCO				INT,
	-- =============================
	@PP_F_MOVIMIENTO_BANCO			DATE, 
	@PP_F_LIQ						DATE, 
	@PP_COD_DESCRIPCION				VARCHAR(500),
	@PP_REFERENCIA					VARCHAR(500), 
	@PP_MONTO_MOVIMIENTO			DECIMAL(19,4),
	@PP_SALDO						DECIMAL(19,4)
AS			

	INSERT INTO [MOVIMIENTO_BANCO]	
			(	[K_MOVIMIENTO_BANCO],
				[K_TIPO_MOVIMIENTO_BANCO], [K_ESTATUS_MOVIMIENTO_BANCO],
				[K_FORMA_MOVIMIENTO_BANCO], [L_CAPTURA_MANUAL], 
				[CIE_CLIENTE], [K_CUENTA_BANCO],
				-- =============================
				[F_OPERACION],
				[F_MOVIMIENTO_BANCO], [F_LIQ], [COD_DESCRIPCION],
				[REFERENCIA], [MONTO_MOVIMIENTO],
				[SALDO],			
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )	
			VALUES
			(	@PP_K_MOVIMIENTO_BANCO,
				@PP_K_TIPO_MOVIMIENTO_BANCO, @VP_K_ESTATUS_MOVIMIENTO_BANCO,
				@PP_K_FORMA_MOVIMIENTO_BANCO, @VP_L_CAPTURA_MANUAL,
				@PP_CIE_CLIENTE, @PP_K_CUENTA_BANCO,
				-- =============================
				@PP_F_MOVIMIENTO_BANCO,
				@PP_F_MOVIMIENTO_BANCO, @PP_F_LIQ, @PP_COD_DESCRIPCION,
				@PP_REFERENCIA, @PP_MONTO_MOVIMIENTO,
				@PP_SALDO,				
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_MOVIMIENTO_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_MOVIMIENTO_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_IN_MOVIMIENTO_BANCO] 
	-- ESTE SP ES PARA LA CAPTURA DE MOVIMIENTOS MANUAL,
	-- PARA LOS DE XML SE USA OTRO.
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_TIPO_MOVIMIENTO_BANCO		INT,
	@PP_K_FORMA_MOVIMIENTO_BANCO				INT, 
	@PP_CIE_CLIENTE					VARCHAR(100),
	@PP_K_CUENTA_BANCO				INT,
	-- =============================
	@PP_F_MOVIMIENTO_BANCO					DATE, 
	@PP_F_LIQ						DATE, 
	@PP_COD_DESCRIPCION				VARCHAR(500),
	@PP_REFERENCIA					VARCHAR(500), 
	@PP_MONTO_MOVIMIENTO			DECIMAL(19,4)
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_CUENTA_BANCO, @PP_K_CUENTA_BANCO,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
														
	-- /////////////////////////////////////////////////////////////////////

	DECLARE @VP_K_MOVIMIENTO_BANCO			INT = 0

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'MOVIMIENTO_BANCO', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_MOVIMIENTO_BANCO			OUTPUT
		-- ================================

		DECLARE @VP_L_CAPTURA_MANUAL	INT
	
		SET		@VP_L_CAPTURA_MANUAL = 1

		-- ================================
												
		DECLARE @VP_K_ESTATUS_MOVIMIENTO_BANCO	INT
	
		-- K_TIPO_MOVIMIENTO_BANCO		
		-- AFECTAN PRESTAMOS >>>>	1 DESCUENTO-CONDONACION	// 101 PAGO
		-- 102 DEPOSITO		-- 201 RETIRO // 202 COMISION
		-- K_ESTATUS_MOVIMIENTO_BANCO	
		-- 1 REPORTADO // 2 PAGO POR APLICAR // 3 APLICADO A COBRANZA // 4 CANCELADO
		IF @PP_K_TIPO_MOVIMIENTO_BANCO IN ( 1, 101 ) 
			SET	 @VP_K_ESTATUS_MOVIMIENTO_BANCO = 2		-- K_ESTATUS_MOVIMIENTO_BANCO = 2 PAGO POR APLICAR
		ELSE
			SET	 @VP_K_ESTATUS_MOVIMIENTO_BANCO = 1		-- K_ESTATUS_MOVIMIENTO_BANCO = 1 REPORTADO // 2 PAGO POR APLICAR

		-- =======================================

		DECLARE @VP_SALDO		DECIMAL (19,4)

		SET		@VP_SALDO = 0

		-- =======================================
		
		EXECUTE [dbo].[PG_IN_MOVIMIENTO_BANCO_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================
													@VP_K_MOVIMIENTO_BANCO, @PP_K_TIPO_MOVIMIENTO_BANCO, @VP_K_ESTATUS_MOVIMIENTO_BANCO,
													@PP_K_FORMA_MOVIMIENTO_BANCO, @VP_L_CAPTURA_MANUAL, @PP_CIE_CLIENTE, @PP_K_CUENTA_BANCO,
													-- =============================
													@PP_F_MOVIMIENTO_BANCO, @PP_F_LIQ, @PP_COD_DESCRIPCION,
													@PP_REFERENCIA, @PP_MONTO_MOVIMIENTO, @VP_SALDO
		END

-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [MovimientoBanco]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Mb.'+CONVERT(VARCHAR(10),@VP_K_MOVIMIENTO_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_MOVIMIENTO_BANCO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_MOVIMIENTO_BANCO AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_MOVIMIENTO_BANCO_X_K_SOLICITUD]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_MOVIMIENTO_BANCO_X_K_SOLICITUD]
GO


CREATE PROCEDURE [dbo].[PG_IN_MOVIMIENTO_BANCO_X_K_SOLICITUD] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_SOLICITUD					INT,
	@PP_K_FORMA_MOVIMIENTO_BANCO				INT, 
	-- =============================
	@PP_F_MOVIMIENTO_BANCO					DATE, 
	@PP_MONTO_MOVIMIENTO			DECIMAL(19,4)
AS			

	DECLARE @VP_K_TIPO_MOVIMIENTO_BANCO		INT = 101		-- 101	PAGO
	DECLARE @VP_F_LIQ						DATE = GETDATE() 	
	DECLARE @VP_COD_DESCRIPCION				VARCHAR(500) = 'PAGO MANUAL DESDE [MO-PRE]'
	DECLARE @VP_REFERENCIA					VARCHAR(500) = 'N/A'

	-- =====================

	DECLARE @VP_CIE_CLIENTE			VARCHAR(100)

	SELECT	@VP_CIE_CLIENTE =		CIE_CLIENTE
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

	EXECUTE [dbo].[PG_IN_MOVIMIENTO_BANCO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@VP_K_TIPO_MOVIMIENTO_BANCO, @PP_K_FORMA_MOVIMIENTO_BANCO, @VP_CIE_CLIENTE, @VP_K_CUENTA_BANCO,
											@PP_F_MOVIMIENTO_BANCO, @VP_F_LIQ, @VP_COD_DESCRIPCION, @VP_REFERENCIA, @PP_MONTO_MOVIMIENTO

	-- //////////////////////////////////////////////////////////////
GO






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_MOVIMIENTO_BANCO_NEUTRO_X_K_SOLICITUD]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_MOVIMIENTO_BANCO_NEUTRO_X_K_SOLICITUD]
GO


CREATE PROCEDURE [dbo].[PG_IN_MOVIMIENTO_BANCO_NEUTRO_X_K_SOLICITUD] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_SOLICITUD					INT,
	-- =============================
	@PP_F_MOVIMIENTO_BANCO					DATE, 
	@PP_MONTO_MOVIMIENTO			DECIMAL(19,4),
	@OU_K_MOVIMIENTO_BANCO			INT			OUTPUT
AS			

	DECLARE @VP_K_TIPO_MOVIMIENTO_BANCO		INT = 2			-- 2	CONDONACION
	DECLARE @VP_K_ESTATUS_MOVIMIENTO_BANCO	INT = 2			-- 2	PAGO X APLICAR
	DECLARE @VP_F_LIQ						DATE = GETDATE() 	
	DECLARE @VP_COD_DESCRIPCION				VARCHAR(500) = 'CONDONACION MANUAL DESDE [MO-PRE]'
	DECLARE @VP_REFERENCIA					VARCHAR(500) = 'N/A'
	DECLARE @VP_K_FORMA_MOVIMIENTO_BANCO				INT = 4			-- CONDONACION, 
	DECLARE @VP_L_CAPTURA_MANUAL			INT = 1
	DECLARE @VP_SALDO						DECIMAL(19,4) = 0

	-- =====================

	DECLARE @VP_CIE_CLIENTE			VARCHAR(100)

	SELECT	@VP_CIE_CLIENTE =		CIE_CLIENTE
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
	
	DECLARE @VP_K_MOVIMIENTO_BANCO			INT = 0

	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'MOVIMIENTO_BANCO', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_MOVIMIENTO_BANCO			OUTPUT
	-- ================================

	EXECUTE [dbo].[PG_IN_MOVIMIENTO_BANCO_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												-- ===========================
												@VP_K_MOVIMIENTO_BANCO, @VP_K_TIPO_MOVIMIENTO_BANCO, @VP_K_ESTATUS_MOVIMIENTO_BANCO,
												@VP_K_FORMA_MOVIMIENTO_BANCO, @VP_L_CAPTURA_MANUAL, @VP_CIE_CLIENTE, @VP_K_CUENTA_BANCO,
												-- =============================
												@PP_F_MOVIMIENTO_BANCO, @VP_F_LIQ, @VP_COD_DESCRIPCION,
												@VP_REFERENCIA, @PP_MONTO_MOVIMIENTO, @VP_SALDO
	-- =====================================
	 
	SET @OU_K_MOVIMIENTO_BANCO = @VP_K_MOVIMIENTO_BANCO

	-- //////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_MOVIMIENTO_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_MOVIMIENTO_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_UP_MOVIMIENTO_BANCO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_MOVIMIENTO_BANCO			INT,
	@PP_K_TIPO_MOVIMIENTO_BANCO		INT,
	@PP_K_FORMA_MOVIMIENTO_BANCO				INT, 
	@PP_CIE_CLIENTE					VARCHAR(100),
	@PP_K_CUENTA_BANCO				INT,
	-- =============================
	@PP_F_MOVIMIENTO_BANCO					DATE, 
	@PP_F_LIQ						DATE, 
	@PP_COD_DESCRIPCION				VARCHAR(500),
	@PP_REFERENCIA					VARCHAR(500), 
	@PP_MONTO_MOVIMIENTO			DECIMAL(19,4)
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_MOVIMIENTO_BANCO, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		UPDATE	MOVIMIENTO_BANCO
		SET		
				K_TIPO_MOVIMIENTO_BANCO = @PP_K_TIPO_MOVIMIENTO_BANCO,
				K_FORMA_MOVIMIENTO_BANCO			= @PP_K_FORMA_MOVIMIENTO_BANCO, 
				CIE_CLIENTE				= @PP_CIE_CLIENTE,
				K_CUENTA_BANCO			= @PP_K_CUENTA_BANCO,
				-- =============================
				F_MOVIMIENTO_BANCO				= @PP_F_MOVIMIENTO_BANCO, 
				F_LIQ					= @PP_F_LIQ, 
				COD_DESCRIPCION			= @PP_COD_DESCRIPCION,
				REFERENCIA				= @PP_REFERENCIA,
				MONTO_MOVIMIENTO		= @PP_MONTO_MOVIMIENTO,
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
		AND		L_BORRADO=0

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [Movimiento Banco]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Mb.'+CONVERT(VARCHAR(10),@PP_K_MOVIMIENTO_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MOVIMIENTO_BANCO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MOVIMIENTO_BANCO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_MOVIMIENTO_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_MOVIMIENTO_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_DL_MOVIMIENTO_BANCO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_MOVIMIENTO_BANCO		INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_MOVIMIENTO_BANCO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_MOVIMIENTO_BANCO, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		UPDATE	MOVIMIENTO_BANCO
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO
		AND		L_BORRADO=0

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [Movimiento Banco]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Mb.'+CONVERT(VARCHAR(10),@PP_K_MOVIMIENTO_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MOVIMIENTO_BANCO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MOVIMIENTO_BANCO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////
GO


-- *****************************************************************************	
-- *****************************************************************************	






-- *****************************************************************************	
-- *****************************************************************************	
-- *****************************************************************************	
-- *****************************************************************************	
