-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PLAN_PRESUPUESTO GASTOS/PLANTA
-- // OPERACION:		LIBERACION / TABLAS
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	15/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////


/*

EXECUTE [dbo].[PG_LI_PARTIDA_PLAN_PRESUPUESTO]	0,0,0,	'',	-1,-1,-1,	-1,-1,-1,	-1,0,0

*/



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PARTIDA_PLAN_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PARTIDA_PLAN_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_LI_PARTIDA_PLAN_PRESUPUESTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_BUSCAR					VARCHAR(200),
	-- ==============================
	@PP_K_ZONA_UO				INT,
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	-- ==============================
	@PP_K_YYYY						INT,
	@PP_K_TEMPORADA					INT,
	@PP_K_ESTATUS_PLAN_PRESUPUESTO	INT,
	-- ==============================
	@PP_K_NIVEL_RUBRO_PRESUPUESTO	INT,
	@PP_L_EXCLUIR_CEROS				INT,
	@PP_L_EXCLUIR_ETIQUETAS			INT
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
			PARTIDA_PLAN_PRESUPUESTO.*,
			D_PROGRAMACION_PARTIDA, D_CALCULO_PARTIDA_PRESUPUESTO, D_RUBRO_PRESUPUESTO,
			S_PROGRAMACION_PARTIDA, S_CALCULO_PARTIDA_PRESUPUESTO, S_RUBRO_PRESUPUESTO,
			RUBRO_PRESUPUESTO.K_NIVEL_RUBRO_PRESUPUESTO,
			USUARIO.D_USUARIO AS D_USUARIO_CAMBIO,			
			-- ================================= 
--			PLAN_PRESUPUESTO.*,
			PLAN_PRESUPUESTO.K_TEMPORADA,
			PLAN_PRESUPUESTO.K_YYYY,
			-- ================================= 
			D_UNIDAD_OPERATIVA, 
			D_TIPO_UO, D_ZONA_UO, D_RAZON_SOCIAL, D_REGION,
			D_ESTATUS_PLAN_PRESUPUESTO, D_TEMPORADA, 
			-- ================================= 
			S_UNIDAD_OPERATIVA, 
			S_TIPO_UO, S_ZONA_UO, S_RAZON_SOCIAL, S_REGION,
			S_ESTATUS_PLAN_PRESUPUESTO, S_TEMPORADA
			-- ================================= 
	FROM	PLAN_PRESUPUESTO, VI_UNIDAD_OPERATIVA_CATALOGOS,
			ESTATUS_PLAN_PRESUPUESTO, TEMPORADA, 
			-- =========================================
			PARTIDA_PLAN_PRESUPUESTO, 
			PROGRAMACION_PARTIDA, CALCULO_PARTIDA_PRESUPUESTO, RUBRO_PRESUPUESTO,
			USUARIO
			-- ================================= 
	WHERE	PLAN_PRESUPUESTO.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
	AND		PLAN_PRESUPUESTO.K_ESTATUS_PLAN_PRESUPUESTO=ESTATUS_PLAN_PRESUPUESTO.K_ESTATUS_PLAN_PRESUPUESTO
	AND		PLAN_PRESUPUESTO.K_TEMPORADA=TEMPORADA.K_TEMPORADA
	AND		PLAN_PRESUPUESTO.K_PLAN_PRESUPUESTO=PARTIDA_PLAN_PRESUPUESTO.K_PLAN_PRESUPUESTO
			-- ================================= 
	AND		PARTIDA_PLAN_PRESUPUESTO.K_PROGRAMACION_PARTIDA=PROGRAMACION_PARTIDA.K_PROGRAMACION_PARTIDA
	AND		PARTIDA_PLAN_PRESUPUESTO.K_CALCULO_PARTIDA_PRESUPUESTO=CALCULO_PARTIDA_PRESUPUESTO.K_CALCULO_PARTIDA_PRESUPUESTO	
	AND		PARTIDA_PLAN_PRESUPUESTO.K_RUBRO_PRESUPUESTO=RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO
	AND		PARTIDA_PLAN_PRESUPUESTO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- ================================= 
	AND		(	
				D_RUBRO_PRESUPUESTO		LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_PLAN_PRESUPUESTO		LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_ZONA_UO				LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_RAZON_SOCIAL			LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_UNIDAD_OPERATIVA		LIKE '%'+@PP_BUSCAR+'%' 
			OR	PLAN_PRESUPUESTO.K_PLAN_PRESUPUESTO=@VP_K_FOLIO			)
			-- ================================= 
	AND		( @PP_K_ZONA_UO=-1				OR	@PP_K_ZONA_UO=VI_K_ZONA_UO )
	AND		( @PP_K_RAZON_SOCIAL=-1			OR	@PP_K_RAZON_SOCIAL=VI_K_RAZON_SOCIAL )
	AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR	@PP_K_UNIDAD_OPERATIVA=VI_K_UNIDAD_OPERATIVA )
			-- ==============================
	AND		( @PP_K_YYYY=-1							OR	@PP_K_YYYY=PLAN_PRESUPUESTO.K_YYYY )
	AND		( @PP_K_TEMPORADA=-1					OR	@PP_K_TEMPORADA=PLAN_PRESUPUESTO.K_TEMPORADA )
	AND		( @PP_K_ESTATUS_PLAN_PRESUPUESTO=-1		OR	@PP_K_ESTATUS_PLAN_PRESUPUESTO=PLAN_PRESUPUESTO.K_ESTATUS_PLAN_PRESUPUESTO )
			-- ================================= 
	AND		( @PP_L_EXCLUIR_CEROS=0				OR	(	PARTIDA_PLAN_PRESUPUESTO.MONTO_BASE>0
													OR	RUBRO_PRESUPUESTO.K_NIVEL_RUBRO_PRESUPUESTO<>5
														)	 )
	AND		( @PP_L_EXCLUIR_ETIQUETAS=0			OR		RUBRO_PRESUPUESTO.K_NIVEL_RUBRO_PRESUPUESTO>0	)
			-- ==============================
	ORDER BY PLAN_PRESUPUESTO.K_YYYY DESC, S_ZONA_UO, D_RAZON_SOCIAL, D_UNIDAD_OPERATIVA,
			PLAN_PRESUPUESTO.K_PLAN_PRESUPUESTO, O_RUBRO_PRESUPUESTO 
			
	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_PARTIDA_PLAN_PRESUPUESTO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_BUSCAR, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_BUSCAR', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////
-- EXECUTE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PARAMETROS]	0,0,0,	1, 50,	'','',123


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PARAMETROS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PARAMETROS]
GO


CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PARAMETROS]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_PLAN_PRESUPUESTO		INT,
	@PP_K_RUBRO_PRESUPUESTO		INT,
	-- ==============================
	@PP_D_CALCULO_PARTIDA		VARCHAR(100),
	@PP_D_PROGRAMACION_PARTIDA	VARCHAR(100),
	@PP_MONTO_BASE				DECIMAL(19,4)
AS

	DECLARE @VP_MENSAJE		VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////
/*
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PARTIDA_PRESUPUESTO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PLAN_GASTO, @PP_K_MM, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
*/
	DECLARE @VP_K_NIVEL_RUBRO_PRESUPUESTO		INT

	SELECT	@VP_K_NIVEL_RUBRO_PRESUPUESTO =		K_NIVEL_RUBRO_PRESUPUESTO
												FROM	RUBRO_PRESUPUESTO
												WHERE	K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO

	IF @VP_K_NIVEL_RUBRO_PRESUPUESTO<>5
		SET	@VP_MENSAJE = 'Este renglón no es editable.'

	-- ///////////////////////////////////////////////
	

	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	[PARTIDA_PLAN_PRESUPUESTO]
		SET		MONTO_BASE = @PP_MONTO_BASE,
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
		AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO	
		AND		@PP_MONTO_BASE>0

		-- ===========================		
		
		DECLARE	@VP_K_CALCULO_PARTIDA_PRESUPUESTO	INT	

		EXECUTE	[dbo].[PG_RN_CALCULO_PARTIDA_PRESUPUESTO_K_X_D]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_D_CALCULO_PARTIDA,
																	@OU_K_CALCULO_PARTIDA_PRESUPUESTO = @VP_K_CALCULO_PARTIDA_PRESUPUESTO		OUTPUT
		UPDATE	[PARTIDA_PLAN_PRESUPUESTO]
		SET		K_CALCULO_PARTIDA_PRESUPUESTO = @VP_K_CALCULO_PARTIDA_PRESUPUESTO
		WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
		AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO	
		AND		@VP_K_CALCULO_PARTIDA_PRESUPUESTO>=0

		-- ==============================================

		DECLARE	@VP_K_PROGRAMACION_PARTIDA	INT	

		EXECUTE	[dbo].[PG_RN_PROGRAMACION_PARTIDA_K_X_D]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_D_PROGRAMACION_PARTIDA,
																@OU_K_PROGRAMACION_PARTIDA = @VP_K_PROGRAMACION_PARTIDA		OUTPUT
		UPDATE	[PARTIDA_PLAN_PRESUPUESTO]
		SET		K_PROGRAMACION_PARTIDA = @VP_K_PROGRAMACION_PARTIDA
		WHERE	K_PLAN_PRESUPUESTO=@PP_K_PLAN_PRESUPUESTO
		AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO	
		AND		@VP_K_PROGRAMACION_PARTIDA>=0

		-- ==============================================

		EXECUTE [dbo].[PG_UP_PLAN_PRESUPUESTO_L_RECALCULAR_SET_1]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@PP_K_PLAN_PRESUPUESTO
		-- ==============================================
		END		

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [Rubro/Presupuesto]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#RUB.'+CONVERT(VARCHAR(10),@PP_K_RUBRO_PRESUPUESTO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END

	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_RUBRO_PRESUPUESTO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE		[dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														-- ===========================================
														3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
														'UPDATE',
														@VP_MENSAJE,
														-- ===========================================
														'[PG_UP_PARTIDA_PLAN_PRESUPUESTO_PARAMETROS]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
														@PP_K_PLAN_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
														-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
														0, 0, '', '' , 0.00, 0.00,
														-- === @PP_VALOR_1 al 6_DATO
														'', '', '', '', '', ''
	
	-- //////////////////////////////////////////////////////////////
GO






-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
