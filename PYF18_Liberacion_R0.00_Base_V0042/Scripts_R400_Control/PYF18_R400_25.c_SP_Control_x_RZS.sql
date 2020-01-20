-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CONTROL OPERACION / <RAZON_SOCIAL>
-- // OPERACION:		LIBERACION / STORED PROCEDURES
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	02/OCT/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////
-- [PG_UP_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL_SQL] 0,0,0,	2015, 5, 1, 4 


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]
GO


CREATE PROCEDURE [dbo].[PG_UP_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_YYYY					INT,	
	@PP_K_MM					INT,
	@PP_K_RAZON_SOCIAL			INT,
	-- ===========================	
	@PP_K_ESTATUS_CONTROL		INT		
AS	

	DECLARE @VP_D_ESTATUS_CONTROL		VARCHAR(100) 

	SELECT	@VP_D_ESTATUS_CONTROL =		D_ESTATUS_CONTROL
										FROM	ESTATUS_CONTROL
										WHERE	K_ESTATUS_CONTROL=@PP_K_ESTATUS_CONTROL
	-- ===============================

	IF @PP_K_MM=01			UPDATE	[dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
							SET		M01_ESTATUS = @VP_D_ESTATUS_CONTROL	 
							WHERE	[K_YYYY]=@PP_K_YYYY
							AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL

	IF @PP_K_MM=02			UPDATE	[dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
							SET		M02_ESTATUS = @VP_D_ESTATUS_CONTROL	 
							WHERE	[K_YYYY]=@PP_K_YYYY
							AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL

	IF @PP_K_MM=03			UPDATE	[dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
							SET		M03_ESTATUS = @VP_D_ESTATUS_CONTROL	 
							WHERE	[K_YYYY]=@PP_K_YYYY
							AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL

	IF @PP_K_MM=04			UPDATE	[dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
							SET		M04_ESTATUS = @VP_D_ESTATUS_CONTROL	 
							WHERE	[K_YYYY]=@PP_K_YYYY
							AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL

	IF @PP_K_MM=05			UPDATE	[dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
							SET		M05_ESTATUS = @VP_D_ESTATUS_CONTROL	 
							WHERE	[K_YYYY]=@PP_K_YYYY
							AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL

	IF @PP_K_MM=06			UPDATE	[dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
							SET		M06_ESTATUS = @VP_D_ESTATUS_CONTROL	 
							WHERE	[K_YYYY]=@PP_K_YYYY
							AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL

	IF @PP_K_MM=07			UPDATE	[dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
							SET		M07_ESTATUS = @VP_D_ESTATUS_CONTROL	 
							WHERE	[K_YYYY]=@PP_K_YYYY
							AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL

	IF @PP_K_MM=08			UPDATE	[dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
							SET		M08_ESTATUS = @VP_D_ESTATUS_CONTROL	 
							WHERE	[K_YYYY]=@PP_K_YYYY
							AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL

	IF @PP_K_MM=09			UPDATE	[dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
							SET		M09_ESTATUS = @VP_D_ESTATUS_CONTROL	 
							WHERE	[K_YYYY]=@PP_K_YYYY	
							AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL
							
	IF @PP_K_MM=10			UPDATE	[dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
							SET		M10_ESTATUS = @VP_D_ESTATUS_CONTROL	 
							WHERE	[K_YYYY]=@PP_K_YYYY							
							AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL

	IF @PP_K_MM=11			UPDATE	[dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
							SET		M11_ESTATUS = @VP_D_ESTATUS_CONTROL	 
							WHERE	[K_YYYY]=@PP_K_YYYY
							AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL
							
	IF @PP_K_MM=12			UPDATE	[dbo].[MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL] 
							SET		M12_ESTATUS = @VP_D_ESTATUS_CONTROL	 
							WHERE	[K_YYYY]=@PP_K_YYYY
							AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL
	
	-- /////////////////////////////////////////////////////////////////////		
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]
GO


CREATE PROCEDURE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_YYYY					INT,	
	@PP_K_MM					INT,	
	@PP_K_RAZON_SOCIAL			INT	
AS			

	DECLARE @VP_EXISTE		INT
	
	SELECT	@VP_EXISTE =	[K_YYYY]	
							FROM	[dbo].[CONTROL_X_MES_X_RAZON_SOCIAL] 
							WHERE	[K_YYYY]=@PP_K_YYYY
							AND		[K_MM]=@PP_K_MM 
							AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL

	-- ==============================

	IF @VP_EXISTE IS NULL
		INSERT INTO  [dbo].[CONTROL_X_MES_X_RAZON_SOCIAL] 
			(	[K_YYYY],		[K_MM],			[K_RAZON_SOCIAL],
				-- ============================================
				[K_USUARIO_ALTA], [F_ALTA], 
				[K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  ) 
		VALUES
			(	@PP_K_YYYY,		@PP_K_MM,		@PP_K_RAZON_SOCIAL,			
				-- ============================================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )
	
	-- ==============================

	EXECUTE [dbo].[PG_UP_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	@PP_K_MM, @PP_K_RAZON_SOCIAL, 0
		
	-- /////////////////////////////////////////////////////////////////////		
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]
GO


CREATE PROCEDURE [dbo].[PG_UP_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_YYYY					INT,	
	@PP_K_MM					INT,
	@PP_K_RAZON_SOCIAL			INT,
	-- ===========================	
	@PP_K_ESTATUS_CONTROL		INT,
	@PP_L_01_PPT_GENERAR			BIT,
	@PP_L_02_PPT_EDITAR				BIT,
	@PP_L_03_PPT_PROGRAMAR			BIT,
	@PP_L_04_PPT_GENERAR_TRASPASOS	BIT,
	@PP_L_05_PFD_POLIZA_EDIT				BIT,
	@PP_L_06_PFD_INGRESOS_ADD				BIT,
	@PP_L_07_PFD_TRASPASO_ADD				BIT,
	@PP_L_08_PFD_FACTURA_ADD				BIT,
	@PP_L_09_PFD_INSTRUCCION_NEW				BIT,
	@PP_L_10_ACCION				BIT		
AS	

	UPDATE	[dbo].[CONTROL_X_MES_X_RAZON_SOCIAL] 
	SET
			K_ESTATUS_CONTROL		= @PP_K_ESTATUS_CONTROL,
			L_01_PPT_GENERAR			= @PP_L_01_PPT_GENERAR,
			L_02_PPT_EDITAR				= @PP_L_02_PPT_EDITAR,
			L_03_PPT_PROGRAMAR			= @PP_L_03_PPT_PROGRAMAR,
			L_04_PPT_GENERAR_TRASPASOS	= @PP_L_04_PPT_GENERAR_TRASPASOS,
			L_05_PFD_POLIZA_EDIT				= @PP_L_05_PFD_POLIZA_EDIT,
			L_06_PFD_INGRESOS_ADD				= @PP_L_06_PFD_INGRESOS_ADD,
			L_07_PFD_TRASPASO_ADD				= @PP_L_07_PFD_TRASPASO_ADD,
			L_08_PFD_FACTURA_ADD				= @PP_L_08_PFD_FACTURA_ADD,
			L_09_PFD_INSTRUCCION_NEW				= @PP_L_09_PFD_INSTRUCCION_NEW,
			L_10_ACCION				= @PP_L_10_ACCION,
			-- ===========================
			[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION, 
			[F_CAMBIO]				= GETDATE() 
	WHERE	[K_YYYY]=@PP_K_YYYY
	AND		[K_MM]=@PP_K_MM
	AND		[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL
	
	-- ==============================

	EXECUTE [dbo].[PG_UP_MATRIZ_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	@PP_K_MM, @PP_K_RAZON_SOCIAL, @PP_K_ESTATUS_CONTROL

	-- /////////////////////////////////////////////////////////////////////		
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL]
GO


CREATE PROCEDURE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_YYYY					INT,	
	@PP_K_MM					INT,
	@PP_K_RAZON_SOCIAL			INT,
	-- =====================================
	@PP_K_ESTATUS_CONTROL		INT,
	@PP_L_01_PPT_GENERAR_PPTO				BIT,
	@PP_L_02_PPT_EDITAR_PPTO				BIT,
	@PP_L_03_PPT_PROGRAMAR_SEMANAS				BIT,
	@PP_L_04_PPT_GENERAR_TRASPASOS				BIT,
	@PP_L_05_PFD_POLIZA_EDIT				BIT,
	@PP_L_06_PFD_INGRESOS_ADD				BIT,
	@PP_L_07_PFD_TRASPASO_ADD				BIT,
	@PP_L_08_PFD_FACTURA_ADD				BIT,
	@PP_L_09_PFD_INSTRUCCION_NEW				BIT,
	@PP_L_10_ACCION				BIT		
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
/*	
	DECLARE @VP_K_LIBRO_INGRESOS				INT = 0
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_LIBRO_INGRESOS_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_LIBRO_INGRESOS,
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
*/
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
		
		EXECUTE	[dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	@PP_K_MM, @PP_K_RAZON_SOCIAL
		-- =====================================

		EXECUTE	[dbo].[PG_UP_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	@PP_K_MM, @PP_K_RAZON_SOCIAL,	
																	@PP_K_ESTATUS_CONTROL,
																	@PP_L_01_PPT_GENERAR_PPTO, @PP_L_02_PPT_EDITAR_PPTO, @PP_L_03_PPT_PROGRAMAR_SEMANAS, @PP_L_04_PPT_GENERAR_TRASPASOS, @PP_L_05_PFD_POLIZA_EDIT,
																	@PP_L_06_PFD_INGRESOS_ADD, @PP_L_07_PFD_TRASPASO_ADD, @PP_L_08_PFD_FACTURA_ADD, @PP_L_09_PFD_INSTRUCCION_NEW, @PP_L_10_ACCION	
		-- =====================================
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN

		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [MatrizControlxMes/RazónSocial]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CxM.'+CONVERT(VARCHAR(10),@PP_K_YYYY)+'/'+CONVERT(VARCHAR(10),@PP_K_MM)+'#'+CONVERT(VARCHAR(10),@PP_K_RAZON_SOCIAL)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MM AS CLAVE
	
	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_YYYY, @PP_K_MM, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, '', '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_LIBRO_INGRESOS', '', '', ''

	-- //////////////////////////////////////////////////////////////	
GO






-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CONTROL_X_MES_X_RAZON_SOCIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CONTROL_X_MES_X_RAZON_SOCIAL]
GO


CREATE PROCEDURE [dbo].[PG_SK_CONTROL_X_MES_X_RAZON_SOCIAL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_YYYY					INT,	
	@PP_K_MM					INT,	
	@PP_K_RAZON_SOCIAL			INT
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

	EXECUTE	[dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_YYYY,	@PP_K_MM, @PP_K_RAZON_SOCIAL
	-- =====================================

	DECLARE @VP_LI_N_REGISTROS		[INT] = 100

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	-- =========================================
		
	SELECT	TOP (@VP_LI_N_REGISTROS)
			[dbo].[CONTROL_X_MES_X_RAZON_SOCIAL].*,
			[D_TIEMPO_MES], [S_TIEMPO_MES],
			[D_RAZON_SOCIAL] ,[S_RAZON_SOCIAL] 
	FROM	[dbo].[CONTROL_X_MES_X_RAZON_SOCIAL], [TIEMPO_MES], [RAZON_SOCIAL] 
	WHERE	[CONTROL_X_MES_X_RAZON_SOCIAL].[K_MM]=[TIEMPO_MES].[K_TIEMPO_MES]
	AND		[CONTROL_X_MES_X_RAZON_SOCIAL].[K_RAZON_SOCIAL]=[RAZON_SOCIAL].[K_RAZON_SOCIAL]	
	AND		[K_YYYY]=@PP_K_YYYY
	AND		[K_MM]=@PP_K_MM 
	AND		[RAZON_SOCIAL].[K_RAZON_SOCIAL]=@PP_K_RAZON_SOCIAL

	-----////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_CONTROL_X_MES_X_RAZON_SOCIAL]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_YYYY, @PP_K_MM, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_CONTROL_X_MES_X_RAZON_SOCIAL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_CONTROL_X_MES_X_RAZON_SOCIAL]
GO

CREATE PROCEDURE [dbo].[PG_UP_CONTROL_X_MES_X_RAZON_SOCIAL]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_YYYY						INT,	
	@PP_K_MM						INT,	
	@PP_K_RAZON_SOCIAL				INT,	
	-- ===========================
	@PP_K_ESTATUS_CONTROL			INT,
	@PP_L_01_PPT_GENERAR_PPTO					BIT,	
	@PP_L_02_PPT_EDITAR_PPTO					BIT,	
	@PP_L_03_PPT_PROGRAMAR_SEMANAS					BIT,	
	@PP_L_04_PPT_GENERAR_TRASPASOS					BIT,	
	@PP_L_05_PFD_POLIZA_EDIT					BIT,	
	@PP_L_06_PFD_INGRESOS_ADD					BIT,	
	@PP_L_07_PFD_TRASPASO_ADD					BIT,	
	@PP_L_08_PFD_FACTURA_ADD					BIT,	
	@PP_L_09_PFD_INSTRUCCION_NEW					BIT,	
	@PP_L_10_ACCION					BIT	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
/*	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_LIBRO_INGRESOS_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_LIBRO_INGRESOS, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
*/
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
		
		EXECUTE [dbo].[PG_IN_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY, @PP_K_MM, @PP_K_RAZON_SOCIAL
		-- =====================================

		EXECUTE	[dbo].[PG_UP_CONTROL_X_MES_X_RAZON_SOCIAL_SQL]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_YYYY,	@PP_K_MM, @PP_K_RAZON_SOCIAL,	
																	@PP_K_ESTATUS_CONTROL,
																	@PP_L_01_PPT_GENERAR_PPTO, @PP_L_02_PPT_EDITAR_PPTO, @PP_L_03_PPT_PROGRAMAR_SEMANAS, @PP_L_04_PPT_GENERAR_TRASPASOS, @PP_L_05_PFD_POLIZA_EDIT,
																	@PP_L_06_PFD_INGRESOS_ADD, @PP_L_07_PFD_TRASPASO_ADD, @PP_L_08_PFD_FACTURA_ADD, @PP_L_09_PFD_INSTRUCCION_NEW, @PP_L_10_ACCION	
		-- =====================================
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [MatrizControlxMes/RazónSocial]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#CxM.'+CONVERT(VARCHAR(10),@PP_K_YYYY)+'/'+CONVERT(VARCHAR(10),@PP_K_MM)+'#'+CONVERT(VARCHAR(10),@PP_K_RAZON_SOCIAL)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_MM AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_CONTROL_X_MES_X_RAZON_SOCIAL]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_YYYY, @PP_K_MM, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													--0, 0, @PP_C_LIBRO_INGRESOS, '', 0.00, 0.00,
													0, 0, '', '', 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_LIBRO_INGRESOS', '', '', ''

	-- //////////////////////////////////////////////////////////////
GO






-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
