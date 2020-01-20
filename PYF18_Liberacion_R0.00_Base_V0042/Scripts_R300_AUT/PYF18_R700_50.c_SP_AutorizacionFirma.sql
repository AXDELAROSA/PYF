-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			AUTORIZACIONES
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			ALEX DE LA ROSA // HECTOR A. GONZALEZ 
-- // Fecha creación:	15/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////

-- SELECT * FROM AUTORIZACION_FIRMA

-- SELECT * FROM FLUJO_FIRMA



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_FLUJO_FIRMA_FIRMANTES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_FLUJO_FIRMA_FIRMANTES]
GO


CREATE PROCEDURE [dbo].[PG_UP_FLUJO_FIRMA_FIRMANTES] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================		
	@PP_K_FLUJO_FIRMA				INT
AS		

	DECLARE @VP_K_ROL_AUTORIZACION_A		INT
	DECLARE @VP_K_ROL_AUTORIZACION_B		INT
	DECLARE @VP_K_ROL_AUTORIZACION_C		INT

	SELECT	@VP_K_ROL_AUTORIZACION_A =		K_ROL_AUTORIZACION_A,
			@VP_K_ROL_AUTORIZACION_B =		K_ROL_AUTORIZACION_B,
			@VP_K_ROL_AUTORIZACION_C =		K_ROL_AUTORIZACION_C
											FROM	FLUJO_FIRMA
											WHERE	K_FLUJO_FIRMA=@PP_K_FLUJO_FIRMA
	-- ============================

	DECLARE @VP_K_UNIDAD_OPERATIVA		INT

	SELECT	@VP_K_UNIDAD_OPERATIVA =	K_UNIDAD_OPERATIVA	
										FROM	AUTORIZACION_FIRMA, FLUJO_FIRMA
										WHERE	AUTORIZACION_FIRMA.K_AUTORIZACION_FIRMA=FLUJO_FIRMA.K_AUTORIZACION_FIRMA
										AND		K_FLUJO_FIRMA=@PP_K_FLUJO_FIRMA
	-- ============================

	DECLARE @VP_K_USUARIO_FIRMA_A		INT 

	EXECUTE [dbo].[PG_RN_FIRMANTE_X_UNO_X_ROL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
												@VP_K_UNIDAD_OPERATIVA, @VP_K_ROL_AUTORIZACION_A,
												@OU_K_USUARIO = @VP_K_USUARIO_FIRMA_A		OUTPUT
	-- =======================================

	DECLARE @VP_K_USUARIO_FIRMA_B		INT 

	EXECUTE [dbo].[PG_RN_FIRMANTE_X_UNO_X_ROL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
												@VP_K_UNIDAD_OPERATIVA, @VP_K_ROL_AUTORIZACION_B,
												@OU_K_USUARIO = @VP_K_USUARIO_FIRMA_B		OUTPUT
	-- =======================================

	DECLARE @VP_K_USUARIO_FIRMA_C		INT 

	EXECUTE [dbo].[PG_RN_FIRMANTE_X_UNO_X_ROL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
												@VP_K_UNIDAD_OPERATIVA, @VP_K_ROL_AUTORIZACION_C,
												@OU_K_USUARIO = @VP_K_USUARIO_FIRMA_C		OUTPUT
	-- =======================================

	UPDATE	[FLUJO_FIRMA]
	SET		[K_USUARIO_FIRMA_A] = @VP_K_USUARIO_FIRMA_A, 
			[K_USUARIO_FIRMA_B] = @VP_K_USUARIO_FIRMA_B, 
			[K_USUARIO_FIRMA_C] = @VP_K_USUARIO_FIRMA_C
	WHERE	K_FLUJO_FIRMA=@PP_K_FLUJO_FIRMA

	-- =======================================
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_FLUJO_FIRMA_X_PASO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_FLUJO_FIRMA_X_PASO]
GO


CREATE PROCEDURE [dbo].[PG_IN_FLUJO_FIRMA_X_PASO] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================		
	@PP_K_AUTORIZACION_FIRMA		INT,
	@PP_N_PASO						INT,
	-- ===========================		
	@PP_K_MODO_AUTORIZACION			INT,
	@PP_N_DIAS_FLUJO_FIRMA			INT,
	@PP_K_ROL_AUTORIZACION_A		INT,
	@PP_K_ROL_AUTORIZACION_B		INT,
	@PP_K_ROL_AUTORIZACION_C		INT
AS		

	DECLARE @VP_K_FLUJO_FIRMA	INT

	-- =======================================
	-- K_MODO_AUTORIZACION= #0 NO REQUERIDO / #1 NOTIFICACION / #2 TODOS / #3 UNO

	IF @PP_K_MODO_AUTORIZACION<>0
		BEGIN

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'FLUJO_FIRMA', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_FLUJO_FIRMA		OUTPUT
		-- =======================================

		INSERT INTO [FLUJO_FIRMA]
			(	
				[K_FLUJO_FIRMA],
				[K_AUTORIZACION_FIRMA],
				[N_PASO],
				[K_MODO_AUTORIZACION], [N_DIAS_FLUJO_FIRMA], [K_ESTATUS_FIRMA],
				-- ==========================================
				[K_ROL_AUTORIZACION_A], [K_ROL_AUTORIZACION_B], [K_ROL_AUTORIZACION_C],
				[K_USUARIO_FIRMA_A], [K_USUARIO_FIRMA_B], [K_USUARIO_FIRMA_C],
				[K_ESTATUS_FIRMA_A], [K_ESTATUS_FIRMA_B], [K_ESTATUS_FIRMA_C],
				[OBSERVACIONES_FIRMA_A], [OBSERVACIONES_FIRMA_B], [OBSERVACIONES_FIRMA_C],
				-- ==========================================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]
			)
			VALUES
			(	
				@VP_K_FLUJO_FIRMA,
				@PP_K_AUTORIZACION_FIRMA,
				@PP_N_PASO,
				@PP_K_MODO_AUTORIZACION, @PP_N_DIAS_FLUJO_FIRMA, 1, -- [K_ESTATUS_FIRMA],
				-- ==========================================
				@PP_K_ROL_AUTORIZACION_A, @PP_K_ROL_AUTORIZACION_B, @PP_K_ROL_AUTORIZACION_C,
				 0,  0,  0,		-- [K_USUARIO_FIRMA_A], [K_USUARIO_FIRMA_B], [K_USUARIO_FIRMA_C],
				 1,  1,  1,		-- [K_ESTATUS_FIRMA_A], [K_ESTATUS_FIRMA_B], [K_ESTATUS_FIRMA_C],
				'', '', '',		-- [OBSERVACIONES_FIRMA_A], [OBSERVACIONES_FIRMA_B], [OBSERVACIONES_FIRMA_C]
				-- ==========================================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL 
			)
			
			-- =====================================

			EXECUTE [dbo].[PG_UP_FLUJO_FIRMA_FIRMANTES]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@VP_K_FLUJO_FIRMA
		END	

	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_FLUJO_FIRMA_X_K_AUTORIZACION_FIRMA]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_FLUJO_FIRMA_X_K_AUTORIZACION_FIRMA]
GO


CREATE PROCEDURE [dbo].[PG_IN_FLUJO_FIRMA_X_K_AUTORIZACION_FIRMA] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================		
	@PP_K_AUTORIZACION_FIRMA		INT
AS		

	DECLARE @VP_K_AUTORIZACION		INT

	SELECT	@VP_K_AUTORIZACION =	K_AUTORIZACION
									FROM	AUTORIZACION_FIRMA
									WHERE	K_AUTORIZACION_FIRMA=@PP_K_AUTORIZACION_FIRMA
	-- =========================

	DECLARE @VP_K_MODO_AUTORIZACION_P1		INT
	DECLARE @VP_N_DIAS_AUTORIZACION_P1		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P1A		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P1B		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P1C		INT
	-- ==========================
	DECLARE @VP_K_MODO_AUTORIZACION_P2		INT
	DECLARE @VP_N_DIAS_AUTORIZACION_P2		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P2A		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P2B		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P2C		INT
	-- ==========================
	DECLARE @VP_K_MODO_AUTORIZACION_P3		INT
	DECLARE @VP_N_DIAS_AUTORIZACION_P3		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P3A		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P3B		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P3C		INT
	-- ==========================
	DECLARE @VP_K_MODO_AUTORIZACION_P4		INT
	DECLARE @VP_N_DIAS_AUTORIZACION_P4		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P4A		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P4B		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P4C		INT
	-- ==========================
	DECLARE @VP_K_MODO_AUTORIZACION_P5		INT
	DECLARE @VP_N_DIAS_AUTORIZACION_P5		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P5A		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P5B		INT
	DECLARE @VP_K_ROL_AUTORIZACION_P5C		INT

	-- ===========================================================

	SELECT	@VP_K_MODO_AUTORIZACION_P1 =	K_MODO_AUTORIZACION_P1,
			@VP_N_DIAS_AUTORIZACION_P1 =	N_DIAS_AUTORIZACION_P1,
			@VP_K_ROL_AUTORIZACION_P1A =	K_ROL_AUTORIZACION_P1A,
			@VP_K_ROL_AUTORIZACION_P1B =	K_ROL_AUTORIZACION_P1B,
			@VP_K_ROL_AUTORIZACION_P1C =	K_ROL_AUTORIZACION_P1C,
			-- =====================			
			@VP_K_MODO_AUTORIZACION_P2 =	K_MODO_AUTORIZACION_P2,
			@VP_N_DIAS_AUTORIZACION_P2 =	N_DIAS_AUTORIZACION_P2,
			@VP_K_ROL_AUTORIZACION_P2A =	K_ROL_AUTORIZACION_P2A,
			@VP_K_ROL_AUTORIZACION_P2B =	K_ROL_AUTORIZACION_P2B,
			@VP_K_ROL_AUTORIZACION_P2C =	K_ROL_AUTORIZACION_P2C,
			-- =====================		
			@VP_K_MODO_AUTORIZACION_P3 =	K_MODO_AUTORIZACION_P3,
			@VP_N_DIAS_AUTORIZACION_P3 =	N_DIAS_AUTORIZACION_P3,
			@VP_K_ROL_AUTORIZACION_P3A =	K_ROL_AUTORIZACION_P3A,
			@VP_K_ROL_AUTORIZACION_P3B =	K_ROL_AUTORIZACION_P3B,
			@VP_K_ROL_AUTORIZACION_P3C =	K_ROL_AUTORIZACION_P3C,
			-- =====================		
			@VP_K_MODO_AUTORIZACION_P4 =	K_MODO_AUTORIZACION_P4,
			@VP_N_DIAS_AUTORIZACION_P4 =	N_DIAS_AUTORIZACION_P4,
			@VP_K_ROL_AUTORIZACION_P4A =	K_ROL_AUTORIZACION_P4A,
			@VP_K_ROL_AUTORIZACION_P4B =	K_ROL_AUTORIZACION_P4B,
			@VP_K_ROL_AUTORIZACION_P4C =	K_ROL_AUTORIZACION_P4C,
			-- =====================		
			@VP_K_MODO_AUTORIZACION_P5 =	K_MODO_AUTORIZACION_P5,
			@VP_N_DIAS_AUTORIZACION_P5 =	N_DIAS_AUTORIZACION_P5,
			@VP_K_ROL_AUTORIZACION_P5A =	K_ROL_AUTORIZACION_P5A,
			@VP_K_ROL_AUTORIZACION_P5B =	K_ROL_AUTORIZACION_P5B,
			@VP_K_ROL_AUTORIZACION_P5C =	K_ROL_AUTORIZACION_P5C
											FROM	AUTORIZACION
											WHERE	K_AUTORIZACION=@VP_K_AUTORIZACION
	-- ===========================================================

	EXECUTE [dbo].[PG_IN_FLUJO_FIRMA_X_PASO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_AUTORIZACION_FIRMA, 1,
												@VP_K_MODO_AUTORIZACION_P1, @VP_N_DIAS_AUTORIZACION_P1,
												@VP_K_ROL_AUTORIZACION_P1A, @VP_K_ROL_AUTORIZACION_P1B, @VP_K_ROL_AUTORIZACION_P1C
	-- ========================================
	EXECUTE [dbo].[PG_IN_FLUJO_FIRMA_X_PASO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_AUTORIZACION_FIRMA, 2,
												@VP_K_MODO_AUTORIZACION_P2, @VP_N_DIAS_AUTORIZACION_P2,
												@VP_K_ROL_AUTORIZACION_P2A, @VP_K_ROL_AUTORIZACION_P2B, @VP_K_ROL_AUTORIZACION_P2C
	-- ========================================
	EXECUTE [dbo].[PG_IN_FLUJO_FIRMA_X_PASO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_AUTORIZACION_FIRMA, 3,
												@VP_K_MODO_AUTORIZACION_P3, @VP_N_DIAS_AUTORIZACION_P3,
												@VP_K_ROL_AUTORIZACION_P3A, @VP_K_ROL_AUTORIZACION_P3B, @VP_K_ROL_AUTORIZACION_P3C
	-- ========================================
	EXECUTE [dbo].[PG_IN_FLUJO_FIRMA_X_PASO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_AUTORIZACION_FIRMA, 4,
												@VP_K_MODO_AUTORIZACION_P4, @VP_N_DIAS_AUTORIZACION_P4,
												@VP_K_ROL_AUTORIZACION_P4A, @VP_K_ROL_AUTORIZACION_P4B, @VP_K_ROL_AUTORIZACION_P4C
	-- ========================================
	EXECUTE [dbo].[PG_IN_FLUJO_FIRMA_X_PASO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												@PP_K_AUTORIZACION_FIRMA, 5,
												@VP_K_MODO_AUTORIZACION_P5, @VP_N_DIAS_AUTORIZACION_P5,
												@VP_K_ROL_AUTORIZACION_P5A, @VP_K_ROL_AUTORIZACION_P5B, @VP_K_ROL_AUTORIZACION_P5C
	-- ========================================
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_AUTORIZACION_FIRMA_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_AUTORIZACION_FIRMA_SQL]
GO


CREATE PROCEDURE [dbo].[PG_IN_AUTORIZACION_FIRMA_SQL] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================		
	@PP_K_AUTORIZACION_FIRMA	INT,
	@PP_F_APERTURA				DATE, 
	@PP_K_AUTORIZACION			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_TRANSACCION			INT,
	@PP_MONTO_AUTORIZAR			DECIMAL(19,4)
AS			

	DECLARE @PP_D_AUTORIZACION_FIRMA			VARCHAR(100) = '' 
	DECLARE @PP_S_AUTORIZACION_FIRMA			VARCHAR(10) = '' 
	DECLARE @PP_C_AUTORIZACION_FIRMA			VARCHAR(500) = ''
	DECLARE @PP_K_ESTATUS_FIRMA					INT	= 1		-- K_ESTATUS_FIRMA // 1 PENDIENTE | 2 REVISION | 3 AUTORIZADO | 4 RECHAZADO

	DECLARE @PP_F_CIERRE						DATE = NULL
	DECLARE @PP_L_AUTORIZACION_DIRECTA			INT = 0
	DECLARE @PP_K_USUARIO_AUTORIZACION_DIRECTA	INT = NULL
	DECLARE @PP_MONTO_AUTORIZADO				DECIMAL(19,4) = @PP_MONTO_AUTORIZAR

	-- =======================================================

	INSERT INTO AUTORIZACION_FIRMA
		(	
			[K_AUTORIZACION_FIRMA],
			[D_AUTORIZACION_FIRMA], [S_AUTORIZACION_FIRMA], [C_AUTORIZACION_FIRMA],
			-- =====================
			[K_ESTATUS_FIRMA],
			[F_APERTURA], [F_CIERRE],
			-- =====================
			[L_AUTORIZACION_DIRECTA],
			[K_USUARIO_AUTORIZACION_DIRECTA],
			-- =====================
			[K_AUTORIZACION],
			[K_UNIDAD_OPERATIVA], [K_TRANSACCION],
			[MONTO_AUTORIZAR], [MONTO_AUTORIZADO],     
			-- =====================
			[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]
		)
	VALUES
		(
			@PP_K_AUTORIZACION_FIRMA,
			@PP_D_AUTORIZACION_FIRMA, @PP_S_AUTORIZACION_FIRMA, @PP_C_AUTORIZACION_FIRMA,
			-- =====================
			@PP_K_ESTATUS_FIRMA,
			@PP_F_APERTURA, @PP_F_CIERRE,
			-- =====================
			@PP_L_AUTORIZACION_DIRECTA,
			@PP_K_USUARIO_AUTORIZACION_DIRECTA,
			-- =====================
			@PP_K_AUTORIZACION,
			@PP_K_UNIDAD_OPERATIVA, @PP_K_TRANSACCION,
			@PP_MONTO_AUTORIZAR, @PP_MONTO_AUTORIZADO,     
			-- ===========================
			@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL 
		)

	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_FLUJO_FIRMA_ACTIVAR_PASO_1]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_FLUJO_FIRMA_ACTIVAR_PASO_1]
GO	


CREATE PROCEDURE [dbo].[PG_UP_FLUJO_FIRMA_ACTIVAR_PASO_1]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_AUTORIZACION_FIRMA	INT
AS			
	
	UPDATE	[FLUJO_FIRMA]
	SET		L_PROCESAR = 0
	WHERE	K_AUTORIZACION_FIRMA=@PP_K_AUTORIZACION_FIRMA
	
	-- ==============================

	UPDATE	[FLUJO_FIRMA]
	SET		L_PROCESAR = 1
	WHERE	K_AUTORIZACION_FIRMA=@PP_K_AUTORIZACION_FIRMA
	AND		[N_PASO]=1

	-- //////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT]
GO


CREATE PROCEDURE [dbo].[PG_PR_AUTORIZACION_Y_FLUJO_INIT] 
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================		
	@PP_K_AUTORIZACION				INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_TRANSACCION				INT,
	@PP_MONTO_AUTORIZAR				DECIMAL(19,4)
AS			

	DECLARE @VP_MENSAJE						VARCHAR(300)	= ''
	DECLARE @VP_K_AUTORIZACION_FIRMA		INT = 0

	-- /////////////////////////////////////////////////////////////////////
	IF @PP_L_DEBUG>0
		PRINT '====================================[PG_PR_AUTORIZACION_Y_FLUJO_INIT]'

/*
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_AUTORIZACION_Y_FLUJO_INIT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@VP_K_AUTORIZACION, @PP_D_AUTORIZACION,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
*/
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'AUTORIZACION_FIRMA', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_AUTORIZACION_FIRMA			OUTPUT
		-- =======================================
		
		DECLARE @VP_F_APERTURA	DATE 
		
		SET		@VP_F_APERTURA	= GETDATE()

		EXECUTE	[dbo].[PG_IN_AUTORIZACION_FIRMA_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_AUTORIZACION_FIRMA, @VP_F_APERTURA, 
														@PP_K_AUTORIZACION, @PP_K_UNIDAD_OPERATIVA, @PP_K_TRANSACCION,
														@PP_MONTO_AUTORIZAR

		EXECUTE	[dbo].[PG_IN_FLUJO_FIRMA_X_K_AUTORIZACION_FIRMA]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@VP_K_AUTORIZACION_FIRMA														
		-- =============================================

		EXECUTE [dbo].[PG_UP_FLUJO_FIRMA_ACTIVAR_PASO_1]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@VP_K_AUTORIZACION_FIRMA	
		-- =============================================
		END

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] la [Autorización/Flujo]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#AUT.'+CONVERT(VARCHAR(10),@PP_K_AUTORIZACION)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
				
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_AUTORIZACION AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////
