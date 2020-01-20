-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			PRESUPUESTO GASTOS/PLANTA
-- // OPERACIÓN:		LIBERACIÓN / REGLAS DE NEGOCIO
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			DANIEL PORTILLO ROMERO (Por integración de RNs de Control)
-- // Fecha creación:	07/DIC/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////





-- /////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_PARTIDA_PRESUPUESTO EXISTE
-- /////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PARTIDA_PRESUPUESTO_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PARTIDA_PRESUPUESTO_EXISTE]
GO

CREATE PROCEDURE [dbo].[PG_RN_PARTIDA_PRESUPUESTO_EXISTE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================		
	@PP_K_PRESUPUESTO					INT,	
	@PP_K_RUBRO_PRESUPUESTO				INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION			VARCHAR (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
		
-- /////////////////////////////////////////////////////

	DECLARE @VP_EXISTE		INT
	
	SELECT	@VP_EXISTE =	COUNT(K_PRESUPUESTO)
							FROM	PARTIDA_PRESUPUESTO
							WHERE	PARTIDA_PRESUPUESTO.L_BORRADO=0
							AND		PARTIDA_PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
							AND		PARTIDA_PRESUPUESTO.K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
	-- ==========================

	IF @VP_RESULTADO=''
		IF @VP_EXISTE = 0
			SET @VP_RESULTADO =  'No existe la [Partida Presupuesto].' 

	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- /////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_PARTIDA_PRESUPUESTO UPDATE
-- /////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PARTIDA_PRESUPUESTO_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PARTIDA_PRESUPUESTO_UPDATE]
GO

CREATE PROCEDURE [dbo].[PG_RN_PARTIDA_PRESUPUESTO_UPDATE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================		
	@PP_K_PRESUPUESTO					INT,
	@PP_K_RUBRO_PRESUPUESTO				INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION			VARCHAR (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''

	-- ///////////////////////////////////////////

	--IF @VP_RESULTADO=''
	--	EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]				@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
	--															8, -- @PP_K_DATA_SISTEMA,	
	--															@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT		

	-- ///////////////////////////////////////////	

	IF @VP_RESULTADO=''
		BEGIN

		DECLARE @VP_K_UNIDAD_OPERATIVA		INT
		DECLARE @VP_K_RAZON_SOCIAL			INT		
		DECLARE @VP_K_YYYY					INT
		DECLARE @VP_K_MM					INT

		SELECT	@VP_K_UNIDAD_OPERATIVA =	PRESUPUESTO.K_UNIDAD_OPERATIVA, 
				@VP_K_RAZON_SOCIAL =		UNIDAD_OPERATIVA.K_RAZON_SOCIAL, 
				@VP_K_YYYY =				PRESUPUESTO.K_YYYY, 
				@VP_K_MM =					PRESUPUESTO.K_MM 
											FROM	PRESUPUESTO, UNIDAD_OPERATIVA
											WHERE	PRESUPUESTO.K_UNIDAD_OPERATIVA = UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
											AND		PRESUPUESTO.K_PRESUPUESTO = @PP_K_PRESUPUESTO

		EXECUTE [dbo].[PG_RN_CONTROL_L_02_PPT_EDITAR]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_RAZON_SOCIAL, @VP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																@PP_K_PRESUPUESTO,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO	OUTPUT

		END

	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_PARTIDA_PRESUPUESTO_EXISTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
																@PP_K_PRESUPUESTO, @PP_K_RUBRO_PRESUPUESTO,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	-- ///////////////////////////////////////////	

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + '  //UPD//'

	-- ///////////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- ///////////////////////////////////////////////
GO




-- /////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////
