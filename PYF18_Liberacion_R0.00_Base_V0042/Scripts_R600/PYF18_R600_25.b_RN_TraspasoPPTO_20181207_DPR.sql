-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:		PYF18_Finanzas
-- // MODULO:				TRASPASO
-- // OPERACION:			LIBERACION / REGLAS NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // Autor:				DANIEL PORTILLO	ROMERO
-- // Fecha creación:		18/SEP/2018
-- // Fecha modificación:	07/DIC/2018  (Por integración de RNs de Control)
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_TRASPASO RUBRO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_RUBRO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_RUBRO]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_RUBRO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================		
	@PP_K_RUBRO_PRESUPUESTO		INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(200)		OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300) = '' 
	
	-- /////////////////////////////////////////////////////
		
	IF @VP_RESULTADO=''
		IF ( @PP_K_RUBRO_PRESUPUESTO<=0 )
			SET @VP_RESULTADO =  'El <Rubro> no es válido (seleccionó una etiqueta).' 
		
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_TRASPASO COMENTARIOS
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_COMENTARIOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_COMENTARIOS]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_COMENTARIOS]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_TIPO_TRASPASO			INT,		
	@PP_C_TRASPASO				VARCHAR(255),
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(200)		OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300) = '' 
	
	-- /////////////////////////////////////////////////////
		
	IF @VP_RESULTADO=''
		BEGIN
		-- K_TIPO_TRASPASO	1	PROGRAMADO	2	(X)TRASPASO EXTESION	3	EXTRAORDINARIO
		IF ( @PP_K_TIPO_TRASPASO =3 AND LEN(@PP_C_TRASPASO)<3)
			SET @VP_RESULTADO =  'El <Traspaso> del tipo <Extraordinario> requiere una justificación, favor de ingresarla en el campo de [Comentarios] del Traspaso.' 

		END
		
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_TRASPASO EDITAR 
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_EDITAR_X_TIPO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_EDITAR_X_TIPO]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_EDITAR_X_TIPO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_K_TRASPASO				INT,		
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(200)		OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300) = '' 
	
	-- /////////////////////////////////////////////////////
		
	IF @VP_RESULTADO=''
		BEGIN
		DECLARE @VP_K_TIPO_TRASPASO INT
		SELECT @VP_K_TIPO_TRASPASO	=	K_TIPO_TRASPASO 
										FROM TRASPASO
										WHERE K_TRASPASO=@PP_K_TRASPASO

		-- K_TIPO_TRASPASO	1	PROGRAMADO	2	(X)TRASPASO EXTESION	3	EXTRAORDINARIO
		IF ( @VP_K_TIPO_TRASPASO =3 )
			SET @VP_RESULTADO =  'El tipo <Extraordinario>  no permite ediciones.' 

		END
		
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EXISTE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_EXISTE]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================		
	@PP_K_TRASPASO				INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(200)		OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300) = '' 
	
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_TRASPASO		INT
			
	SELECT	@VP_K_TRASPASO =	K_TRASPASO
								FROM	TRASPASO
								WHERE	K_TRASPASO=@PP_K_TRASPASO
	-- ===========================

	IF @VP_RESULTADO=''
		IF ( @VP_K_TRASPASO IS NULL )
			SET @VP_RESULTADO =  'El <Registro> no existe.' 
		
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_CLAVE_EXISTE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_CLAVE_EXISTE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_CLAVE_EXISTE]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_CLAVE_EXISTE]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================		
	@PP_K_TRASPASO				INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(200)		OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO='' 
		BEGIN

		DECLARE @VP_EXISTE_CLAVE	INT

		SELECT	@VP_EXISTE_CLAVE =	COUNT(K_TRASPASO)
									FROM	TRASPASO 
									WHERE	K_TRASPASO=@PP_K_TRASPASO
										
		IF @VP_EXISTE_CLAVE>0
			SET @VP_RESULTADO =  'El <Folio> no está disponible.' 

		END	
		
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- ===========================================================================================
-- ===========================================================================================
-- == REGLAS DE NEGOCIO BASICAS (INSERT / UPDATE / DELETE)
-- ===========================================================================================
-- ===========================================================================================


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN // VALIDACION INSERT
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_INSERT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_INSERT]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_INSERT]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================		
	@PP_K_TRASPASO				INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(200)		OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- //////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //INS//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- /////////////////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN TRASPASO UPDATE
-- /////////////////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_UPDATE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_UPDATE]
GO

CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_UPDATE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================		
	@PP_K_TRASPASO						INT,	
	@PP_K_UNIDAD_OPERATIVA				INT,
	@PP_F_OPERACION						DATE,
	-- ===========================		
	@OU_RESULTADO_VALIDACION			VARCHAR(200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300) = ''
	
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
		
	-- ///////////////////////////////////////////
		
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_TRASPASO_EDITAR_X_TIPO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_TRASPASO,	 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO = ''
		BEGIN

		DECLARE @VP_K_YYYY		INT
		DECLARE @VP_K_MM		INT

		SET	@VP_K_YYYY =		YEAR(@PP_F_OPERACION) 
		SET	@VP_K_MM =			MONTH(@PP_F_OPERACION) 

		-- ===========================	

		DECLARE @VP_K_RAZON_SOCIAL			INT		

		SELECT	@VP_K_RAZON_SOCIAL =		UNIDAD_OPERATIVA.K_RAZON_SOCIAL
											FROM	UNIDAD_OPERATIVA
											WHERE	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA
		-- ===========================	

		EXECUTE [dbo].[PG_RN_CONTROL_L_05_PFD_POLIZA_EDIT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@VP_K_RAZON_SOCIAL, @PP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

		END

	-- ///////////////////////////////////////////
	
	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_TRASPASO_EXISTE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_TRASPASO,	 
													@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT

	-- ///////////////////////////////////////////
	
	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //UPD//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN // VALIDACION DELETE
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_DELETE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_DELETE]
GO


CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_DELETE]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================		
	@PP_K_TRASPASO				INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(200)		OUTPUT
AS

	DECLARE @VP_RESULTADO		VARCHAR(300) = ''
		
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
														1, -- @PP_K_DATA_SISTEMA,	
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_RESULTADO=''
		EXECUTE [dbo].[PG_RN_TRASPASO_EXISTE]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_TRASPASO, 
														@OU_RESULTADO_VALIDACION = @VP_RESULTADO		OUTPUT
	-- ///////////////////////////////////////////




	-- ///////////////////////////////////////////

	IF	@VP_RESULTADO<>''
		SET	@VP_RESULTADO = @VP_RESULTADO + ' //DEL//'
	
	-- ///////////////////////////////////////////
		
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_TRASPASO X K PRESUPUESTO X RUBRO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO]
GO

CREATE PROCEDURE [dbo].[PG_RN_TRASPASO_X_K_PRESUPUESTO_K_RUBRO_PRESUPUESTO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================			
	@PP_K_PRESUPUESTO			INT,
	@PP_K_RUBRO_PRESUPUESTO		INT,
	-- ===========================		
	@OU_RESULTADO_VALIDACION	VARCHAR(300)		OUTPUT
AS
	DECLARE @VP_MENSAJE AS VARCHAR(300) = ''

	 -- ////////////////////////////////////////////////////

	DECLARE @VP_D_UNIDAD_OPERATIVA		VARCHAR(100)	= ''
	DECLARE @VP_D_MES					VARCHAR(10)		= ''
	DECLARE @VP_K_RAZON_SOCIAL			INT = -1
	DECLARE @VP_K_UNIDAD_OPERATIVA		INT = -1
	DECLARE @VP_K_YYYY					INT = -1
	DECLARE @VP_K_MM					INT = -1

	SELECT	@VP_D_UNIDAD_OPERATIVA =	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA,
			@VP_D_MES =					MES.D_MES,
			@VP_K_UNIDAD_OPERATIVA =	UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA,
			@VP_K_RAZON_SOCIAL =		UNIDAD_OPERATIVA.K_RAZON_SOCIAL,
			@VP_K_YYYY =				K_YYYY,
			@VP_K_MM =					K_MM
										FROM	PRESUPUESTO, UNIDAD_OPERATIVA, MES
										WHERE	PRESUPUESTO.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA 
										AND		PRESUPUESTO.K_MM=MES.K_MES 
										AND		PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO

	-- ////////////////////////////////////////////////////

	IF @VP_MENSAJE = ''
		EXECUTE [dbo].[PG_RN_CONTROL_L_04_PPT_GENERAR_TRASPASOS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																	@VP_K_RAZON_SOCIAL, @VP_K_UNIDAD_OPERATIVA, @VP_K_YYYY, @VP_K_MM,
																	@PP_K_PRESUPUESTO,
																	@OU_RESULTADO_VALIDACION = @VP_MENSAJE	OUTPUT
	-- ////////////////////////////////////////////////////

	IF @VP_MENSAJE = ''
		BEGIN

		DECLARE @VP_TRASPASOS_GENERADOS		INT = 0

		IF @PP_L_DEBUG > 0
			PRINT @PP_K_RUBRO_PRESUPUESTO

		SELECT @VP_TRASPASOS_GENERADOS =	COUNT(K_TRASPASO) 
											FROM	PRESUPUESTO,TRASPASO, PARTIDA_PRESUPUESTO
											WHERE	PRESUPUESTO.K_PRESUPUESTO=@PP_K_PRESUPUESTO
											AND		PRESUPUESTO.K_PRESUPUESTO = PARTIDA_PRESUPUESTO.K_PRESUPUESTO
											AND		PARTIDA_PRESUPUESTO.K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
											AND		PARTIDA_PRESUPUESTO.K_RUBRO_PRESUPUESTO=TRASPASO.K_RUBRO_PRESUPUESTO
											AND		PRESUPUESTO.K_UNIDAD_OPERATIVA=TRASPASO.K_UNIDAD_OPERATIVA
											AND		PRESUPUESTO.K_YYYY=YEAR(TRASPASO.F_OPERACION)
											AND		PRESUPUESTO.K_MM=MONTH(TRASPASO.F_OPERACION)		
											AND		TRASPASO.K_ESTATUS_TRASPASO<>6
											-- 1	BASE	2	PROGRAMADO	3	AUTORIZADO	4	EJECUTADO	5	CONCILIADO	6	CANCELADO
		IF @PP_L_DEBUG>0
			SELECT @PP_K_PRESUPUESTO PRESUPUESTO, @VP_TRASPASOS_GENERADOS AS TRASP_GEN
	-- /////////////////////////////////////////////////////	

		IF @VP_TRASPASOS_GENERADOS>0
			BEGIN
					
			SET		@VP_MENSAJE = 'Existen '+CONVERT(VARCHAR(10),@VP_TRASPASOS_GENERADOS)+' [Traspaso(s)] '
			SET		@VP_MENSAJE = @VP_MENSAJE + 'generado(s) para la [UNO#' +CONVERT(VARCHAR(10),@VP_D_UNIDAD_OPERATIVA)
			SET		@VP_MENSAJE = @VP_MENSAJE + ' del Año #'+CONVERT(VARCHAR(10),@VP_K_YYYY)
			SET		@VP_MENSAJE = @VP_MENSAJE + ', Mes '+CONVERT(VARCHAR(10),@VP_D_MES)
			SET		@VP_MENSAJE = @VP_MENSAJE + ' con estatus distinto de [Cancelado]'

			END

		IF @PP_L_DEBUG>0
			SELECT @VP_MENSAJE MENSAJE_RN

		END

	-- /////////////////////////////////////////////////////

	SET @OU_RESULTADO_VALIDACION = @VP_MENSAJE
	
	-- /////////////////////////////////////////////////////
GO




-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
