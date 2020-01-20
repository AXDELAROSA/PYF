-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:		PYF18_Finanzas
-- // MODULO:				PRESUPUESTO GASTOS/PLANTA
-- // OPERACION:			LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 
-- // Autor:				HECTOR A. GONZALEZ DE LA FUENTE
-- // MOdificador:			DANIEL PORTILLO ROMERO
-- // Fecha creaci�n:		25/SEP/2018
-- // Fecha modificaci�n:	07/DIC/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////





-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PARTIDA_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PARTIDA_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_LI_PARTIDA_PRESUPUESTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_BUSCAR					VARCHAR(200),
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_TIPO_UO				INT,
	@PP_K_ZONA_UO				INT,
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_REGION				INT,
	-- ==============================
	@PP_K_YYYY						INT,
	@PP_K_MM						INT,
	@PP_K_ESTATUS_PRESUPUESTO		INT,
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
			PRESUPUESTO.K_UNIDAD_OPERATIVA, 
			PRESUPUESTO.K_YYYY, PRESUPUESTO.K_MM, MES.S_MES,
			PRESUPUESTO.D_PRESUPUESTO, ESTATUS_PRESUPUESTO.D_ESTATUS_PRESUPUESTO,
			-- ================================= 
			PARTIDA_PRESUPUESTO.*, USUARIO.D_USUARIO AS D_USUARIO_CAMBIO,
			K_NIVEL_RUBRO_PRESUPUESTO, 
			D_RUBRO_PRESUPUESTO,  D_PROGRAMACION_PARTIDA, S_PROGRAMACION_PARTIDA,
			-- ================================= 
			(MES_PORCENTAJE_REMANENTE*100) AS MES_REMANENTE_100, (W01_PORCENTAJE_REMANENTE*100) AS W01_REMANENTE_100, 
			(W02_PORCENTAJE_REMANENTE*100) AS W02_REMANENTE_100, (W03_PORCENTAJE_REMANENTE*100) AS W03_REMANENTE_100, 
			(W04_PORCENTAJE_REMANENTE*100) AS W04_REMANENTE_100, (W05_PORCENTAJE_REMANENTE*100) AS W05_REMANENTE_100, 
			-- ================================= 
			D_UNIDAD_OPERATIVA, 
			D_TIPO_UO, D_ZONA_UO, D_RAZON_SOCIAL, D_REGION,
			D_RUBRO_PRESUPUESTO, D_PROGRAMACION_PARTIDA,
			-- ================================= 
			S_UNIDAD_OPERATIVA, 
			S_TIPO_UO, S_ZONA_UO, S_RAZON_SOCIAL, S_REGION,
			S_RUBRO_PRESUPUESTO, S_PROGRAMACION_PARTIDA
			-- ================================= 
	FROM	PRESUPUESTO, 
			ESTATUS_PRESUPUESTO, 
			VI_UNIDAD_OPERATIVA_CATALOGOS,
			MES, USUARIO,
			PARTIDA_PRESUPUESTO, 
			RUBRO_PRESUPUESTO, PROGRAMACION_PARTIDA
	WHERE	PRESUPUESTO.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
	AND		PRESUPUESTO.K_ESTATUS_PRESUPUESTO=ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO
	AND		PRESUPUESTO.K_MM=MES.K_MES
	AND		PRESUPUESTO.K_PRESUPUESTO=PARTIDA_PRESUPUESTO.K_PRESUPUESTO
			-- ================================= 
	AND		PARTIDA_PRESUPUESTO.K_PROGRAMACION_PARTIDA=PROGRAMACION_PARTIDA.K_PROGRAMACION_PARTIDA
	AND		PARTIDA_PRESUPUESTO.K_RUBRO_PRESUPUESTO=RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO
	AND		PARTIDA_PRESUPUESTO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
			-- ================================= 
	AND		(	
				D_RUBRO_PRESUPUESTO			LIKE '%'+@PP_BUSCAR+'%' 
			OR	C_RUBRO_PRESUPUESTO			LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_PRESUPUESTO				LIKE '%'+@PP_BUSCAR+'%' 
			OR	C_PRESUPUESTO				LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_UNIDAD_OPERATIVA			LIKE '%'+@PP_BUSCAR+'%' 
			OR	PRESUPUESTO.K_PRESUPUESTO=@VP_K_FOLIO			)
			-- ================================= 
	AND		( @PP_K_UNIDAD_OPERATIVA=-1		OR	@PP_K_UNIDAD_OPERATIVA=VI_K_UNIDAD_OPERATIVA )
	AND		( @PP_K_TIPO_UO=-1				OR	@PP_K_TIPO_UO=VI_K_TIPO_UO )
	AND		( @PP_K_ZONA_UO=-1				OR	@PP_K_ZONA_UO=VI_K_ZONA_UO )
	AND		( @PP_K_RAZON_SOCIAL=-1			OR	@PP_K_RAZON_SOCIAL=VI_K_RAZON_SOCIAL )
	AND		( @PP_K_REGION=-1				OR	@PP_K_REGION=VI_K_REGION )
			-- ================================= 
	AND		( @PP_K_YYYY=-1						OR	@PP_K_YYYY=PRESUPUESTO.K_YYYY )
	AND		( @PP_K_MM=-1						OR	@PP_K_MM=PRESUPUESTO.K_MM )
	AND		( @PP_K_ESTATUS_PRESUPUESTO=-1		OR	@PP_K_ESTATUS_PRESUPUESTO=PRESUPUESTO.K_ESTATUS_PRESUPUESTO )
	AND		( @PP_K_NIVEL_RUBRO_PRESUPUESTO=-1	OR	@PP_K_NIVEL_RUBRO_PRESUPUESTO=RUBRO_PRESUPUESTO.K_NIVEL_RUBRO_PRESUPUESTO )
			-- ================================= 
	AND		( @PP_L_EXCLUIR_CEROS=0				OR	(	PARTIDA_PRESUPUESTO.MES_MONTO_ESTIMADO>0
													OR	RUBRO_PRESUPUESTO.K_NIVEL_RUBRO_PRESUPUESTO=0	)	 )
	AND		( @PP_L_EXCLUIR_ETIQUETAS=0			OR		RUBRO_PRESUPUESTO.K_NIVEL_RUBRO_PRESUPUESTO>0	)
	ORDER BY PARTIDA_PRESUPUESTO.K_PRESUPUESTO, 
			 O_RUBRO_PRESUPUESTO 
			
	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_PARTIDA_PRESUPUESTO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
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

/*

SELECT * FROM PARTIDA_PRESUPUESTO WHERE K_PRESUPUESTO=3001

  EXECUTE [dbo].[PG_LI_PARTIDA_PRESUPUESTO_RESUMEN]	0,0,0,	
		'', 3, 2018, 7, -1, 0


*/

	


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PARTIDA_PRESUPUESTO_RESUMEN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PARTIDA_PRESUPUESTO_RESUMEN]
GO


CREATE PROCEDURE [dbo].[PG_LI_PARTIDA_PRESUPUESTO_RESUMEN]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_BUSCAR					VARCHAR(200),
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_YYYY					INT,
	@PP_K_MM					INT,
	@PP_K_ESTATUS_PRESUPUESTO	INT,
	@PP_L_EXCLUIR_CEROS			INT
AS
	-- ==============================================
	
	SELECT	
			PRESUPUESTO.K_PRESUPUESTO,
			PRESUPUESTO.K_UNIDAD_OPERATIVA, D_UNIDAD_OPERATIVA,
			PRESUPUESTO.K_YYYY, PRESUPUESTO.K_MM, MES.S_MES,
			K_NIVEL_RUBRO_PRESUPUESTO, 
			D_RUBRO_PRESUPUESTO, 
			D_PROGRAMACION_PARTIDA, S_PROGRAMACION_PARTIDA,
			PRESUPUESTO.D_PRESUPUESTO, ESTATUS_PRESUPUESTO.D_ESTATUS_PRESUPUESTO,
			(MES_PORCENTAJE_REMANENTE*100) AS MES_REMANENTE_100, (W01_PORCENTAJE_REMANENTE*100) AS W01_REMANENTE_100, 
			(W02_PORCENTAJE_REMANENTE*100) AS W02_REMANENTE_100, (W03_PORCENTAJE_REMANENTE*100) AS W03_REMANENTE_100, 
			(W04_PORCENTAJE_REMANENTE*100) AS W04_REMANENTE_100, (W05_PORCENTAJE_REMANENTE*100) AS W05_REMANENTE_100, 
			PARTIDA_PRESUPUESTO.*, USUARIO.D_USUARIO AS D_USUARIO_CAMBIO
	FROM	PRESUPUESTO, PARTIDA_PRESUPUESTO, 
			RUBRO_PRESUPUESTO, PROGRAMACION_PARTIDA,
			ESTATUS_PRESUPUESTO, UNIDAD_OPERATIVA, MES, USUARIO
	WHERE	PARTIDA_PRESUPUESTO.K_PRESUPUESTO=PRESUPUESTO.K_PRESUPUESTO
	AND		PARTIDA_PRESUPUESTO.K_PROGRAMACION_PARTIDA=PROGRAMACION_PARTIDA.K_PROGRAMACION_PARTIDA
/*	( @PP_K_PRESUPUESTO=-1	OR	PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO ) AND	*/				
	AND		RUBRO_PRESUPUESTO.K_RUBRO_PRESUPUESTO=PARTIDA_PRESUPUESTO.K_RUBRO_PRESUPUESTO
	AND		PRESUPUESTO.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND		PRESUPUESTO.K_ESTATUS_PRESUPUESTO=ESTATUS_PRESUPUESTO.K_ESTATUS_PRESUPUESTO
	AND		PRESUPUESTO.K_MM=MES.K_MES

	AND			K_NIVEL_RUBRO_PRESUPUESTO=3

	AND		PARTIDA_PRESUPUESTO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		(	
				D_RUBRO_PRESUPUESTO			LIKE '%'+@PP_BUSCAR+'%' 
--			OR	K_PRESUPUESTO=@VP_K_FOLIO 
			OR	C_RUBRO_PRESUPUESTO			LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_PRESUPUESTO				LIKE '%'+@PP_BUSCAR+'%' 
			OR	C_PRESUPUESTO				LIKE '%'+@PP_BUSCAR+'%' 
			OR	D_UNIDAD_OPERATIVA			LIKE '%'+@PP_BUSCAR+'%' 
			)
	AND		( @PP_K_UNIDAD_OPERATIVA=-1			OR	@PP_K_UNIDAD_OPERATIVA=PRESUPUESTO.K_UNIDAD_OPERATIVA )
	AND		( @PP_K_YYYY=-1						OR	@PP_K_YYYY=PRESUPUESTO.K_YYYY )
	AND		( @PP_K_MM=-1						OR	@PP_K_MM=PRESUPUESTO.K_MM )
	AND		( @PP_K_ESTATUS_PRESUPUESTO=-1		OR	@PP_K_ESTATUS_PRESUPUESTO=PRESUPUESTO.K_ESTATUS_PRESUPUESTO )
	AND		( @PP_L_EXCLUIR_CEROS=0				OR	PARTIDA_PRESUPUESTO.MES_MONTO_ESTIMADO>0 )
	ORDER BY PARTIDA_PRESUPUESTO.K_PRESUPUESTO, 
			 O_RUBRO_PRESUPUESTO 

	-- //////////////////////////////////////////////////////////////
GO







-- //////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE --->  UPDATE PARTIDA_PRESUPUESTO MES MONTO ESTIMADO
-- //////////////////////////////////////////////////////////////////////////

/*
	EXECUTE [dbo].[PG_PR_PRESUPUESTO_GENERAR]	0,0,0,	1030, 8
*/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARTIDA_PRESUPUESTO_MES_MONTO_ESTIMADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_MES_MONTO_ESTIMADO]
GO

CREATE PROCEDURE [dbo].[PG_UP_PARTIDA_PRESUPUESTO_MES_MONTO_ESTIMADO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_PRESUPUESTO			INT,
	@PP_K_RUBRO_PRESUPUESTO		INT,
	@PP_MES_MONTO_ESTIMADO		DECIMAL(19,4)
AS

	DECLARE @VP_MENSAJE			VARCHAR(300) = ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PARTIDA_PRESUPUESTO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO,
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- ///////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	[PARTIDA_PRESUPUESTO]
		SET		MES_MONTO_ESTIMADO = @PP_MES_MONTO_ESTIMADO,
				-- ====================
				[F_CAMBIO]				= GETDATE(), 
				[K_USUARIO_CAMBIO]		= @PP_K_USUARIO_ACCION
		WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO
		AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO	

		-- ==============================================

		EXECUTE [dbo].[PG_UP_PRESUPUESTO_L_RECALCULAR_SET_1]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_PRESUPUESTO
		-- ==============================================
		END		

	-- ///////////////////////////////////////////////

	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible <Actualizar> el Rubro / Presupuesto: ' + @VP_MENSAJE 
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
														'[PG_UP_PARTIDA_PRESUPUESTO_MES_MONTO_ESTIMADO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
														@PP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
														-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
														0, 0, '', '' , 0.00, 0.00,
														-- === @PP_VALOR_1 al 6_DATO
														'', '', '', '', '', ''
	
	-- //////////////////////////////////////////////////////////////
GO





-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////