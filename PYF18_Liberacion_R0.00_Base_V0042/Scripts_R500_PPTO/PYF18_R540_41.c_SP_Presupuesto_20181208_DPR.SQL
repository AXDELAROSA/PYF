-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:		PYF18_Finanzas
-- // MODULO:				PRESUPUESTO
-- // OPERACION:			LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:				HECTOR A. GONZALEZ DE LA FUENTE
-- // Modificador:			DANIEL PORTILLO ROMERO
-- // Fecha creación:		18/SEP/2018
-- // Fecha modificación:	08/DIC/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PRESUPUESTO_L_RECALCULAR_SET_1]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PRESUPUESTO_L_RECALCULAR_SET_1]
GO


CREATE PROCEDURE [dbo].[PG_UP_PRESUPUESTO_L_RECALCULAR_SET_1]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_PRESUPUESTO			INT
AS

	UPDATE	[PRESUPUESTO]
	SET		L_RECALCULAR = 1	
	WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO

	-- //////////////////////////////////////////////////////////////
GO


-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PRESUPUESTO_L_RECALCULAR_RESET_0]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PRESUPUESTO_L_RECALCULAR_RESET_0]
GO


CREATE PROCEDURE [dbo].[PG_UP_PRESUPUESTO_L_RECALCULAR_RESET_0]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_PRESUPUESTO			INT
AS

	UPDATE	[PRESUPUESTO]
	SET		L_RECALCULAR = 0	
	WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  LISTADO
-- //////////////////////////////////////////////////////////////
--	EXECUTE [dbo].[PG_LI_PRESUPUESTO]	0,0,69,		0,'',		-1,-1,-1,	NULL, NULL


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PRESUPUESTO]
GO	


CREATE PROCEDURE [dbo].[PG_LI_PRESUPUESTO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_D_PRESUPUESTO				VARCHAR(255),
	-- ===========================
	@PP_K_TIPO_PRESUPUESTO			INT,
	@PP_K_ESTATUS_PRESUPUESTO		INT,
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
			F_OPE.D_TIEMPO_FECHA	AS F_PRESUPUESTO_DDMMMYYYY,
			F_LIQ.D_TIEMPO_FECHA	AS F_LIQ_DDMMMYYYY,	
			PRESUPUESTO.*,
			D_TIPO_PRESUPUESTO, D_ESTATUS_PRESUPUESTO,
			S_TIPO_PRESUPUESTO, S_ESTATUS_PRESUPUESTO,
			CUENTA_BANCO.CUENTA, D_FORMA_PRESUPUESTO, D_USUARIO AS D_USUARIO_CAMBIO
	FROM	PRESUPUESTO, 
			TIEMPO_FECHA AS F_OPE, TIEMPO_FECHA AS F_LIQ,
			TIPO_PRESUPUESTO, ESTATUS_PRESUPUESTO,
			CUENTA_BANCO, FORMA_PRESUPUESTO, USUARIO
	WHERE	PRESUPUESTO.K_TIPO_PRESUPUESTO=TIPO_PRESUPUESTO.K_TIPO_PRESUPUESTO
	AND		PRESUPUESTO.K_ESTATUS_PRESUPUESTO=ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO
	AND		PRESUPUESTO.K_CUENTA_BANCO=CUENTA_BANCO.K_CUENTA_BANCO
	AND		PRESUPUESTO.K_TIPO_PRESUPUESTO=TIPO_PRESUPUESTO.K_TIPO_PRESUPUESTO
	AND		PRESUPUESTO.K_FORMA_PRESUPUESTO=FORMA_PRESUPUESTO.K_FORMA_PRESUPUESTO
	AND		PRESUPUESTO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- =====================
	AND		PRESUPUESTO.F_PRESUPUESTO=F_OPE.F_TIEMPO_FECHA
	AND		PRESUPUESTO.F_LIQ=F_LIQ.F_TIEMPO_FECHA
			-- =====================
	AND		(	
				S_AUTORIZACION		LIKE '%'+@PP_D_PRESUPUESTO+'%' 
			OR	C_AUTORIZACION			LIKE '%'+@PP_D_PRESUPUESTO+'%' 
			OR	D_AUTORIZACION			LIKE '%'+@PP_D_PRESUPUESTO+'%' 	
			OR	CUENTA				LIKE '%'+@PP_D_PRESUPUESTO+'%'	
			OR	D_FORMA_PRESUPUESTO		LIKE '%'+@PP_D_PRESUPUESTO+'%'	
			)			
			-- =====================
	AND		( @PP_F_INICIO IS NULL						OR	@PP_F_INICIO<=PRESUPUESTO.F_PRESUPUESTO )
	AND		( @PP_F_FIN	IS NULL							OR	@PP_F_FIN>=PRESUPUESTO.F_PRESUPUESTO )
			-- =====================
	AND		( @PP_K_TIPO_PRESUPUESTO=-1			OR	@PP_K_TIPO_PRESUPUESTO=PRESUPUESTO.K_TIPO_PRESUPUESTO )
	AND		( @PP_K_ESTATUS_PRESUPUESTO=-1			OR	@PP_K_ESTATUS_PRESUPUESTO=PRESUPUESTO.K_ESTATUS_PRESUPUESTO )
	AND		( @PP_K_CUENTA_BANCO=-1						OR	@PP_K_CUENTA_BANCO=PRESUPUESTO.K_CUENTA_BANCO )
	AND		PRESUPUESTO.L_BORRADO=0
			-- =====================
--	ORDER BY F_PRESUPUESTO DESC
	ORDER BY K_PRESUPUESTO DESC

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SEEK PRESUPUESTO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_PRESUPUESTO]
GO

CREATE PROCEDURE [dbo].[PG_SK_PRESUPUESTO]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PRESUPUESTO			INT
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
			PRESUPUESTO.*,
			D_ESTATUS_PRESUPUESTO, S_ESTATUS_PRESUPUESTO,
			D_UNIDAD_OPERATIVA, S_UNIDAD_OPERATIVA
	FROM	PRESUPUESTO, 
			ESTATUS_PRESUPUESTO, UNIDAD_OPERATIVA
	WHERE	PRESUPUESTO.K_ESTATUS_PRESUPUESTO=ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO
	AND		PRESUPUESTO.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND		PRESUPUESTO.L_BORRADO=0
	AND		PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
			-- =====================
	ORDER BY K_PRESUPUESTO

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PRESUPUESTO_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PRESUPUESTO_SQL]
GO


CREATE PROCEDURE [dbo].[PG_IN_PRESUPUESTO_SQL] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PRESUPUESTO				INT,
	@PP_D_PRESUPUESTO				VARCHAR(100),
	@PP_C_PRESUPUESTO				VARCHAR(255),
	@PP_S_PRESUPUESTO				VARCHAR(10),
	@PP_O_PRESUPUESTO				INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_YYYY						INT,
	@PP_K_MM						INT,
	@PP_K_ESTATUS_PRESUPUESTO		INT,
	@PP_L_RECALCULAR				INT
	-- =============================
AS			

	INSERT INTO [PRESUPUESTO]	
			(	K_PRESUPUESTO, 
				-- ===========================
				D_PRESUPUESTO, C_PRESUPUESTO, S_PRESUPUESTO, O_PRESUPUESTO,
				K_UNIDAD_OPERATIVA, 
				K_YYYY, K_MM, K_ESTATUS_PRESUPUESTO,
				L_RECALCULAR,
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )	
			VALUES
			(	@PP_K_PRESUPUESTO, 
				-- ===========================
				@PP_D_PRESUPUESTO, @PP_C_PRESUPUESTO, @PP_S_PRESUPUESTO, @PP_O_PRESUPUESTO,
				@PP_K_UNIDAD_OPERATIVA, 
				@PP_K_YYYY, @PP_K_MM, @PP_K_ESTATUS_PRESUPUESTO,
				@PP_L_RECALCULAR,
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_IN_PRESUPUESTO] 
	-- ESTE SP ES PARA LA CAPTURA DE MOVIMIENTOS MANUAL,
	-- PARA LOS DE XML SE USA OTRO.
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_TIPO_PRESUPUESTO		INT,
	@PP_K_FORMA_PRESUPUESTO				INT, 
	@PP_D_AUTORIZACION					VARCHAR(100),
	@PP_K_CUENTA_BANCO				INT,
	-- =============================
	@PP_F_PRESUPUESTO					DATE, 
	@PP_F_LIQ						DATE, 
	@PP_S_AUTORIZACION				VARCHAR(500),
	@PP_C_AUTORIZACION					VARCHAR(500), 
	@PP_LIMITE_INFERIOR			DECIMAL(19,4)
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_CUENTA_BANCO, @PP_K_CUENTA_BANCO,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
														
	-- /////////////////////////////////////////////////////////////////////

	DECLARE @VP_K_PRESUPUESTO			INT = 0

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'PRESUPUESTO', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_PRESUPUESTO			OUTPUT
		-- ================================

		DECLARE @VP_L_CAPTURA_MANUAL	INT
	
		SET		@VP_L_CAPTURA_MANUAL = 1

		-- ================================
												
		DECLARE @VP_K_ESTATUS_PRESUPUESTO	INT
	
		-- K_TIPO_PRESUPUESTO		
		-- AFECTAN PRESTAMOS >>>>	1 DESCUENTO-CONDONACION	// 101 PAGO
		-- 102 DEPOSITO		-- 201 RETIRO // 202 COMISION
		-- K_ESTATUS_PRESUPUESTO	
		-- 1 REPORTADO // 2 PAGO POR APLICAR // 3 APLICADO A COBRANZA // 4 CANCELADO
		IF @PP_K_TIPO_PRESUPUESTO IN ( 1, 101 ) 
			SET	 @VP_K_ESTATUS_PRESUPUESTO = 2		-- K_ESTATUS_PRESUPUESTO = 2 PAGO POR APLICAR
		ELSE
			SET	 @VP_K_ESTATUS_PRESUPUESTO = 1		-- K_ESTATUS_PRESUPUESTO = 1 REPORTADO // 2 PAGO POR APLICAR

		-- =======================================

		DECLARE @VP_LIMITE_SUPERIOR		DECIMAL (19,4)

		SET		@VP_LIMITE_SUPERIOR = 0

		-- =======================================
		
		EXECUTE [dbo].[PG_IN_PRESUPUESTO_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================
													@VP_K_PRESUPUESTO, @PP_K_TIPO_PRESUPUESTO, @VP_K_ESTATUS_PRESUPUESTO,
													@PP_K_FORMA_PRESUPUESTO, @VP_L_CAPTURA_MANUAL, @PP_D_AUTORIZACION, @PP_K_CUENTA_BANCO,
													-- =============================
													@PP_F_PRESUPUESTO, @PP_F_LIQ, @PP_S_AUTORIZACION,
													@PP_C_AUTORIZACION, @PP_LIMITE_INFERIOR, @VP_LIMITE_SUPERIOR
		END

-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [Presupuesto]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PGA.'+CONVERT(VARCHAR(10),@VP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PRESUPUESTO AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PRESUPUESTO_X_K_SOLICITUD]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PRESUPUESTO_X_K_SOLICITUD]
GO


CREATE PROCEDURE [dbo].[PG_IN_PRESUPUESTO_X_K_SOLICITUD] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_SOLICITUD					INT,
	@PP_K_FORMA_PRESUPUESTO				INT, 
	-- =============================
	@PP_F_PRESUPUESTO					DATE, 
	@PP_LIMITE_INFERIOR			DECIMAL(19,4)
AS			

	DECLARE @VP_K_TIPO_PRESUPUESTO		INT = 101		-- 101	PAGO
	DECLARE @VP_F_LIQ						DATE = GETDATE() 	
	DECLARE @VP_S_AUTORIZACION				VARCHAR(500) = 'PAGO MANUAL DESDE [MO-PRE]'
	DECLARE @VP_C_AUTORIZACION					VARCHAR(500) = 'N/A'

	-- =====================

	DECLARE @VP_D_AUTORIZACION			VARCHAR(100)

	SELECT	@VP_D_AUTORIZACION =		D_AUTORIZACION
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

	EXECUTE [dbo].[PG_IN_PRESUPUESTO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
											@VP_K_TIPO_PRESUPUESTO, @PP_K_FORMA_PRESUPUESTO, @VP_D_AUTORIZACION, @VP_K_CUENTA_BANCO,
											@PP_F_PRESUPUESTO, @VP_F_LIQ, @VP_S_AUTORIZACION, @VP_C_AUTORIZACION, @PP_LIMITE_INFERIOR

	-- //////////////////////////////////////////////////////////////
GO






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PRESUPUESTO_NEUTRO_X_K_SOLICITUD]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PRESUPUESTO_NEUTRO_X_K_SOLICITUD]
GO


CREATE PROCEDURE [dbo].[PG_IN_PRESUPUESTO_NEUTRO_X_K_SOLICITUD] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_SOLICITUD					INT,
	-- =============================
	@PP_F_PRESUPUESTO					DATE, 
	@PP_LIMITE_INFERIOR			DECIMAL(19,4),
	@OU_K_PRESUPUESTO			INT			OUTPUT
AS			

	DECLARE @VP_K_TIPO_PRESUPUESTO		INT = 2			-- 2	CONDONACION
	DECLARE @VP_K_ESTATUS_PRESUPUESTO	INT = 2			-- 2	PAGO X APLICAR
	DECLARE @VP_F_LIQ						DATE = GETDATE() 	
	DECLARE @VP_S_AUTORIZACION				VARCHAR(500) = 'CONDONACION MANUAL DESDE [MO-PRE]'
	DECLARE @VP_C_AUTORIZACION					VARCHAR(500) = 'N/A'
	DECLARE @VP_K_FORMA_PRESUPUESTO				INT = 4			-- CONDONACION, 
	DECLARE @VP_L_CAPTURA_MANUAL			INT = 1
	DECLARE @VP_LIMITE_SUPERIOR						DECIMAL(19,4) = 0

	-- =====================

	DECLARE @VP_D_AUTORIZACION			VARCHAR(100)

	SELECT	@VP_D_AUTORIZACION =		D_AUTORIZACION
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
	
	DECLARE @VP_K_PRESUPUESTO			INT = 0

	EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
												'PRESUPUESTO', 
												@OU_K_TABLA_DISPONIBLE = @VP_K_PRESUPUESTO			OUTPUT
	-- ================================

	EXECUTE [dbo].[PG_IN_PRESUPUESTO_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												-- ===========================
												@VP_K_PRESUPUESTO, @VP_K_TIPO_PRESUPUESTO, @VP_K_ESTATUS_PRESUPUESTO,
												@VP_K_FORMA_PRESUPUESTO, @VP_L_CAPTURA_MANUAL, @VP_D_AUTORIZACION, @VP_K_CUENTA_BANCO,
												-- =============================
												@PP_F_PRESUPUESTO, @VP_F_LIQ, @VP_S_AUTORIZACION,
												@VP_C_AUTORIZACION, @PP_LIMITE_INFERIOR, @VP_LIMITE_SUPERIOR
	-- =====================================
	 
	SET @OU_K_PRESUPUESTO = @VP_K_PRESUPUESTO

	-- //////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_UP_PRESUPUESTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_PRESUPUESTO			INT,
	@PP_K_TIPO_PRESUPUESTO		INT,
	@PP_K_FORMA_PRESUPUESTO				INT, 
	@PP_D_AUTORIZACION					VARCHAR(100),
	@PP_K_CUENTA_BANCO				INT,
	-- =============================
	@PP_F_PRESUPUESTO					DATE, 
	@PP_F_LIQ						DATE, 
	@PP_S_AUTORIZACION				VARCHAR(500),
	@PP_C_AUTORIZACION					VARCHAR(500), 
	@PP_LIMITE_INFERIOR			DECIMAL(19,4)
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_PRESUPUESTO, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	PRESUPUESTO
		SET		
				/*
				K_TIPO_PRESUPUESTO = @PP_K_TIPO_PRESUPUESTO,
				K_FORMA_PRESUPUESTO			= @PP_K_FORMA_PRESUPUESTO, 
				D_AUTORIZACION				= @PP_D_AUTORIZACION,
				K_CUENTA_BANCO			= @PP_K_CUENTA_BANCO,
				-- =============================
				F_PRESUPUESTO				= @PP_F_PRESUPUESTO, 
				F_LIQ					= @PP_F_LIQ, 
				S_AUTORIZACION			= @PP_S_AUTORIZACION,
				C_AUTORIZACION				= @PP_C_AUTORIZACION,
				LIMITE_INFERIOR		= @PP_LIMITE_INFERIOR,
				*/
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO
		AND		L_BORRADO=0

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [Presupuesto]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PGA.'+CONVERT(VARCHAR(10),@PP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRESUPUESTO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_DL_PRESUPUESTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_PRESUPUESTO		INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PRESUPUESTO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PRESUPUESTO, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
															
	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		UPDATE	PRESUPUESTO
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO
		AND		L_BORRADO=0

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [Presupuesto]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#PGA.'+CONVERT(VARCHAR(10),@PP_K_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRESUPUESTO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////
GO




-- ////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////
