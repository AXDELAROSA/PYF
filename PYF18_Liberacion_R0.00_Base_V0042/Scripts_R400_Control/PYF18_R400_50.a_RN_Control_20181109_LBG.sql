-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			CONTROL
-- // OPERACION:		LIBERACION / REGLAS NEGOCIO
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			LAURA BARRAZA GAMEROS 
-- // Fecha creación:	09/NOV/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_GENERAR PRESUPUESTO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_L_01_PPT_GENERAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_L_01_PPT_GENERAR]
GO


CREATE PROCEDURE [dbo].[PG_RN_CONTROL_L_01_PPT_GENERAR]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL				[INT],
	@PP_K_UNIDAD_OPERATIVA			[INT],
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@PP_K_PLAN_GASTO				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''

	-- ===================================================

	DECLARE @VP_K_RAZON_SOCIAL		AS INT = 0
	DECLARE @VP_K_UNIDAD_OPERATIVA	AS INT = 0
	DECLARE @VP_K_YYYY				AS INT = 0

	IF @PP_K_PLAN_GASTO>0
		BEGIN

		SELECT	@VP_K_RAZON_SOCIAL		=	VI_K_RAZON_SOCIAL,
				@VP_K_UNIDAD_OPERATIVA	=	K_UNIDAD_OPERATIVA,
				@VP_K_YYYY				=	K_YYYY
											FROM	PLAN_GASTO, VI_UNIDAD_OPERATIVA_CATALOGOS
											WHERE	PLAN_GASTO.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
											AND		K_PLAN_GASTO=@PP_K_PLAN_GASTO
											AND		PLAN_GASTO.L_BORRADO=0
		END
	ELSE
		BEGIN
		
		SET	@VP_K_RAZON_SOCIAL		=	@PP_K_RAZON_SOCIAL
		SET	@VP_K_UNIDAD_OPERATIVA	=	@PP_K_UNIDAD_OPERATIVA
		SET	@VP_K_YYYY				=	@PP_K_YYYY
		
		END
		
	-- /////////////////////////////////////////////////////

	IF @VP_K_RAZON_SOCIAL IS NULL
		SET @VP_K_RAZON_SOCIAL = 0  

	IF @VP_K_UNIDAD_OPERATIVA IS NULL
		SET @VP_K_UNIDAD_OPERATIVA = 0  

	IF @VP_K_YYYY IS NULL
		SET @VP_K_YYYY = 0  

	-- /////////////////////////////////////////////////////

	DECLARE @VP_L_01_PPT_GENERAR_X_MES		INT
		
	SELECT	@VP_L_01_PPT_GENERAR_X_MES =	L_01_PPT_GENERAR 
											FROM	CONTROL_X_MES 
											WHERE	K_YYYY=@VP_K_YYYY 
											AND		K_MM=@PP_K_MM
	-- ===========================

	DECLARE @VP_L_01_PPT_GENERAR_X_RZS		INT

	SELECT	@VP_L_01_PPT_GENERAR_X_RZS =	L_01_PPT_GENERAR 
											FROM	CONTROL_X_MES_X_RAZON_SOCIAL 
											WHERE	K_RAZON_SOCIAL = @VP_K_RAZON_SOCIAL
											AND		K_YYYY = @VP_K_YYYY 
											AND		K_MM = @PP_K_MM
	-- ===========================

	DECLARE @VP_L_01_PPT_GENERAR_X_UNO		INT

	SELECT	@VP_L_01_PPT_GENERAR_X_UNO =	L_01_PPT_GENERAR 
											FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA 
											WHERE	K_UNIDAD_OPERATIVA = @VP_K_UNIDAD_OPERATIVA
											AND		K_YYYY = @VP_K_YYYY 
											AND		K_MM = @PP_K_MM

	-- /////////////////////////////////////////////////////

	IF @VP_L_01_PPT_GENERAR_X_MES IS NULL
		SET @VP_L_01_PPT_GENERAR_X_MES = 0  

	IF @VP_L_01_PPT_GENERAR_X_RZS IS NULL
		SET @VP_L_01_PPT_GENERAR_X_RZS = 0  

	IF @VP_L_01_PPT_GENERAR_X_UNO IS NULL
		SET @VP_L_01_PPT_GENERAR_X_UNO = 0  

	-- /////////////////////////////////////////////////////

	DECLARE @VP_L_PROCESAR AS INT = 0

	IF @VP_L_01_PPT_GENERAR_X_MES=1
		SET @VP_L_PROCESAR = 1  
	ELSE
		IF @VP_L_01_PPT_GENERAR_X_RZS=1
			SET @VP_L_PROCESAR = 1  
		ELSE
			IF @VP_L_01_PPT_GENERAR_X_UNO=1
				SET @VP_L_PROCESAR = 1  
				
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @VP_RESULTADO =  'El Control de Operación no permite [Generar] el [Presupuesto]'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [RZS#' +CONVERT(VARCHAR(10),@VP_K_RAZON_SOCIAL)+'/'
		SET @VP_RESULTADO =  @VP_RESULTADO + 'UNO#' +CONVERT(VARCHAR(10),@VP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' para el Año '+CONVERT(VARCHAR(5),@VP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO + ' y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'
		
		END
								
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EDITAR PRESUPUESTO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_L_02_PPT_EDITAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_L_02_PPT_EDITAR]
GO

CREATE PROCEDURE [dbo].[PG_RN_CONTROL_L_02_PPT_EDITAR]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL				[INT],
	@PP_K_UNIDAD_OPERATIVA			[INT],
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO			VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////


	DECLARE @VP_K_RAZON_SOCIAL		AS INT=0
	DECLARE @VP_K_UNIDAD_OPERATIVA	AS INT=0
	DECLARE @VP_K_YYYY				AS INT=0
	DECLARE @VP_K_MM				AS INT=0

	IF @PP_K_PRESUPUESTO>0
		BEGIN
			SELECT	@VP_K_UNIDAD_OPERATIVA	=	K_UNIDAD_OPERATIVA,
					@VP_K_YYYY				=	K_YYYY,
					@VP_K_MM				=	K_MM,
					@VP_K_RAZON_SOCIAL		=	VI_K_RAZON_SOCIAL
												FROM	PRESUPUESTO, VI_UNIDAD_OPERATIVA_CATALOGOS
												WHERE	PRESUPUESTO.K_UNIDAD_OPERATIVA = VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
												AND		K_PRESUPUESTO = @PP_K_PRESUPUESTO
												AND		PRESUPUESTO.L_BORRADO = 0
		END
	ELSE
		BEGIN
			SET @VP_K_RAZON_SOCIAL=		@PP_K_RAZON_SOCIAL
			SET @VP_K_UNIDAD_OPERATIVA=	@PP_K_UNIDAD_OPERATIVA
			SET @VP_K_YYYY=				@PP_K_YYYY
			SET @VP_K_MM=				@PP_K_MM
		END
		
	-- /////////////////////////////////////////////////////	

	IF @VP_K_RAZON_SOCIAL IS NULL
		SET @VP_K_RAZON_SOCIAL = 0  

	IF @VP_K_UNIDAD_OPERATIVA IS NULL
		SET @VP_K_UNIDAD_OPERATIVA = 0  

	IF @VP_K_YYYY IS NULL
		SET @VP_K_YYYY = 0  

	IF @VP_K_MM IS NULL
		SET @VP_K_MM = 0  

	-- /////////////////////////////////////////////////////	
		
	DECLARE @VP_L_02_PPT_EDITAR_X_MES		INT

	SELECT	@VP_L_02_PPT_EDITAR_X_MES	=	L_02_PPT_EDITAR 
											FROM	CONTROL_X_MES 
											WHERE	K_YYYY = @VP_K_YYYY 
											AND		K_MM = @VP_K_MM

	-- ===========================

	DECLARE @VP_L_02_PPT_EDITAR_X_RZS		INT	
				
	SELECT	@VP_L_02_PPT_EDITAR_X_RZS	=	L_02_PPT_EDITAR 
											FROM	CONTROL_X_MES_X_RAZON_SOCIAL 
											WHERE	K_RAZON_SOCIAL = @VP_K_RAZON_SOCIAL
											AND		K_YYYY = @VP_K_YYYY 
											AND		K_MM = @VP_K_MM
		

	-- ===========================

	DECLARE @VP_L_02_PPT_EDITAR_X_UNO		INT
		
	SELECT	@VP_L_02_PPT_EDITAR_X_UNO=		L_02_PPT_EDITAR 
											FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA 
											WHERE	K_UNIDAD_OPERATIVA = @VP_K_UNIDAD_OPERATIVA
											AND		K_YYYY = @VP_K_YYYY 
											AND		K_MM = @VP_K_MM
			
	-- /////////////////////////////////////////////////////

	IF @VP_L_02_PPT_EDITAR_X_MES IS NULL
		SET @VP_L_02_PPT_EDITAR_X_MES = 0  

	IF @VP_L_02_PPT_EDITAR_X_RZS IS NULL
		SET @VP_L_02_PPT_EDITAR_X_RZS = 0  

	IF @VP_L_02_PPT_EDITAR_X_UNO IS NULL
		SET @VP_L_02_PPT_EDITAR_X_UNO = 0  

	-- /////////////////////////////////////////////////////

	DECLARE @VP_L_PROCESAR AS INT = 0

	IF @VP_L_02_PPT_EDITAR_X_MES=1
		SET @VP_L_PROCESAR = 1  
	ELSE
		IF @VP_L_02_PPT_EDITAR_X_RZS=1
			SET @VP_L_PROCESAR = 1  
		ELSE
			IF @VP_L_02_PPT_EDITAR_X_UNO=1
				SET @VP_L_PROCESAR = 1  




	IF @VP_L_PROCESAR=0 	
		BEGIN
			SET @VP_RESULTADO =  'El Control de Operación no permite [Editar] el [Presupuesto]'
			SET @VP_RESULTADO =  @VP_RESULTADO + ' de [RZS#' +CONVERT(VARCHAR(10),@VP_K_RAZON_SOCIAL)+'/'
			SET @VP_RESULTADO =  @VP_RESULTADO + 'UNO#' +CONVERT(VARCHAR(10),@VP_K_UNIDAD_OPERATIVA)+']'
			SET @VP_RESULTADO =  @VP_RESULTADO+ ' para el Año '+CONVERT(VARCHAR(5),@VP_K_YYYY)   
			SET @VP_RESULTADO =  @VP_RESULTADO+'  y el Mes '+ CONVERT(VARCHAR(5),@VP_K_MM) 		
		END
								
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_PROGRAMAR PRESUPUESTO
-- //////////////////////////////////////////////////////////////
/*

DECLARE @VP_RESULTADO_VALIDACION		[VARCHAR] (200)		

EXECUTE [PG_RN_CONTROL_L_03_PPT_PROGRAMAR] 0,0,0,	NULL,NULL,NULL,NULL,	1,
											@OU_RESULTADO_VALIDACION = @VP_RESULTADO_VALIDACION			 OUTPUT

PRINT @VP_RESULTADO_VALIDACION		

*/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_L_03_PPT_PROGRAMAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_L_03_PPT_PROGRAMAR]
GO


CREATE PROCEDURE [dbo].[PG_RN_CONTROL_L_03_PPT_PROGRAMAR]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL				[INT],
	@PP_K_UNIDAD_OPERATIVA			[INT],
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO			VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_RAZON_SOCIAL		AS INT=0
	DECLARE @VP_K_UNIDAD_OPERATIVA	AS INT=0
	DECLARE @VP_K_YYYY				AS INT=0
	DECLARE @VP_K_MM				AS INT=0

	-- /////////////////////////////////////////////////////

	IF @PP_K_PRESUPUESTO>0
		BEGIN

		SELECT	@VP_K_UNIDAD_OPERATIVA	=	K_UNIDAD_OPERATIVA,
				@VP_K_YYYY				=	K_YYYY,
				@VP_K_MM				=	K_MM,
				@VP_K_RAZON_SOCIAL		=	VI_K_RAZON_SOCIAL
											FROM	PRESUPUESTO, VI_UNIDAD_OPERATIVA_CATALOGOS
											WHERE	PRESUPUESTO.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
											AND		K_PRESUPUESTO=@PP_K_PRESUPUESTO
											AND		PRESUPUESTO.L_BORRADO=0
		END
	ELSE
		BEGIN

		SET @VP_K_RAZON_SOCIAL =		@PP_K_RAZON_SOCIAL
		SET @VP_K_UNIDAD_OPERATIVA =	@PP_K_UNIDAD_OPERATIVA
		SET @VP_K_YYYY =				@PP_K_YYYY
		SET @VP_K_MM =					@PP_K_MM
		
		END
			
	-- /////////////////////////////////////////////////////	

	IF @VP_K_RAZON_SOCIAL IS NULL
		SET @VP_K_RAZON_SOCIAL = 0  

	IF @VP_K_UNIDAD_OPERATIVA IS NULL
		SET @VP_K_UNIDAD_OPERATIVA = 0  

	IF @VP_K_YYYY IS NULL
		SET @VP_K_YYYY = 0  

	IF @VP_K_MM IS NULL
		SET @VP_K_MM = 0  

	-- /////////////////////////////////////////////////////

	DECLARE @VP_L_03_PPT_PROGRAMAR_X_MES	INT
		
	SELECT	@VP_L_03_PPT_PROGRAMAR_X_MES =	L_03_PPT_PROGRAMAR 
											FROM	CONTROL_X_MES 
											WHERE	K_YYYY=@VP_K_YYYY 
											AND		K_MM=@VP_K_MM

	-- ===========================

	DECLARE @VP_L_03_PPT_PROGRAMAR_X_RZS	INT
		
	SELECT	@VP_L_03_PPT_PROGRAMAR_X_RZS =	L_03_PPT_PROGRAMAR 
											FROM	CONTROL_X_MES_X_RAZON_SOCIAL 
											WHERE	K_RAZON_SOCIAL=@VP_K_RAZON_SOCIAL
											AND		K_YYYY=@VP_K_YYYY 
											AND		K_MM=@VP_K_MM
	
	-- ===========================

	DECLARE @VP_L_03_PPT_PROGRAMAR_X_UNO	INT

	SELECT	@VP_L_03_PPT_PROGRAMAR_X_UNO =	L_03_PPT_PROGRAMAR 
											FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA 
											WHERE	K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA
											AND		K_YYYY=@VP_K_YYYY 
											AND		K_MM=@VP_K_MM
	
	-- /////////////////////////////////////////////////////

	IF @VP_L_03_PPT_PROGRAMAR_X_MES IS NULL
		SET @VP_L_03_PPT_PROGRAMAR_X_MES = 0  

	IF @VP_L_03_PPT_PROGRAMAR_X_RZS IS NULL
		SET @VP_L_03_PPT_PROGRAMAR_X_RZS = 0  

	IF @VP_L_03_PPT_PROGRAMAR_X_UNO IS NULL
		SET @VP_L_03_PPT_PROGRAMAR_X_UNO = 0  

	-- /////////////////////////////////////////////////////

	DECLARE @VP_L_PROCESAR AS INT = 0

	IF @VP_L_03_PPT_PROGRAMAR_X_MES=1
		SET @VP_L_PROCESAR = 1  
	ELSE
		IF @VP_L_03_PPT_PROGRAMAR_X_RZS=1
			SET @VP_L_PROCESAR = 1  
		ELSE
			IF @VP_L_03_PPT_PROGRAMAR_X_UNO=1
				SET @VP_L_PROCESAR = 1  

	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 		
		BEGIN
		SET @VP_RESULTADO =  'El Control de Operación no permite [Programar] el [Presupuesto]'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [RZS#' +CONVERT(VARCHAR(10),@VP_K_RAZON_SOCIAL)+'/'
		SET @VP_RESULTADO =  @VP_RESULTADO + 'UNO#' +CONVERT(VARCHAR(10),@VP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO+ ' para el Año '+CONVERT(VARCHAR(5),@VP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO+'  y el Mes '+ CONVERT(VARCHAR(5),@VP_K_MM) 
		END		
				
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_GENERAR TRASPASOS
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_L_04_PPT_GENERAR_TRASPASOS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_L_04_PPT_GENERAR_TRASPASOS]
GO


CREATE PROCEDURE [dbo].[PG_RN_CONTROL_L_04_PPT_GENERAR_TRASPASOS]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL				[INT],
	@PP_K_UNIDAD_OPERATIVA			[INT],
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@PP_K_PRESUPUESTO				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO			VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_RAZON_SOCIAL		AS INT=0
	DECLARE @VP_K_UNIDAD_OPERATIVA	AS INT=0
	DECLARE @VP_K_YYYY				AS INT=0
	DECLARE @VP_K_MM				AS INT=0

	-- /////////////////////////////////////////////////////

	IF @PP_K_PRESUPUESTO>0
		BEGIN
		SELECT	@VP_K_UNIDAD_OPERATIVA	=	K_UNIDAD_OPERATIVA,
				@VP_K_YYYY				=	K_YYYY,
				@VP_K_MM				=	K_MM,
				@VP_K_RAZON_SOCIAL		=	VI_K_RAZON_SOCIAL
											FROM	PRESUPUESTO, VI_UNIDAD_OPERATIVA_CATALOGOS
											WHERE	PRESUPUESTO.K_UNIDAD_OPERATIVA = VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
											AND		K_PRESUPUESTO = @PP_K_PRESUPUESTO
											AND		PRESUPUESTO.L_BORRADO = 0
		END
	ELSE
		BEGIN
		SET @VP_K_RAZON_SOCIAL=		@PP_K_RAZON_SOCIAL
		SET @VP_K_UNIDAD_OPERATIVA=	@PP_K_UNIDAD_OPERATIVA
		SET @VP_K_YYYY=				@PP_K_YYYY
		SET @VP_K_MM=				@PP_K_MM
		END
			
		
	-- /////////////////////////////////////////////////////	

	IF @VP_K_RAZON_SOCIAL IS NULL
		SET @VP_K_RAZON_SOCIAL = 0  

	IF @VP_K_UNIDAD_OPERATIVA IS NULL
		SET @VP_K_UNIDAD_OPERATIVA = 0  

	IF @VP_K_YYYY IS NULL
		SET @VP_K_YYYY = 0  

	IF @VP_K_MM IS NULL
		SET @VP_K_MM = 0  

	-- /////////////////////////////////////////////////////	

	DECLARE @VP_L_04_PPT_GENERAR_TRASPASOS_X_MES	INT
		
	SELECT	@VP_L_04_PPT_GENERAR_TRASPASOS_X_MES =	L_04_PPT_GENERAR_TRASPASOS 
													FROM	CONTROL_X_MES 
													WHERE	K_YYYY = @VP_K_YYYY 
													AND		K_MM = @VP_K_MM

	-- ===========================

	DECLARE @VP_L_04_PPT_GENERAR_TRASPASO_X_RZS		INT	

	SELECT	@VP_L_04_PPT_GENERAR_TRASPASO_X_RZS=	L_04_PPT_GENERAR_TRASPASOS 
													FROM	CONTROL_X_MES_X_RAZON_SOCIAL 
													WHERE	K_RAZON_SOCIAL = @VP_K_RAZON_SOCIAL
													AND		K_YYYY = @VP_K_YYYY 
													AND		K_MM = @VP_K_MM
		
	-- ===========================
	 
	DECLARE @VP_L_04_PPT_GENERAR_TRASPASO_X_UNO		INT	

	SELECT	@VP_L_04_PPT_GENERAR_TRASPASO_X_UNO=	L_04_PPT_GENERAR_TRASPASOS 
													FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA 
													WHERE	K_UNIDAD_OPERATIVA = @VP_K_UNIDAD_OPERATIVA
													AND		K_YYYY = @VP_K_YYYY 
													AND		K_MM = @VP_K_MM			
			
	-- /////////////////////////////////////////////////////

	IF @VP_L_04_PPT_GENERAR_TRASPASOS_X_MES IS NULL
		SET @VP_L_04_PPT_GENERAR_TRASPASOS_X_MES = 0  

	IF @VP_L_04_PPT_GENERAR_TRASPASO_X_RZS IS NULL
		SET @VP_L_04_PPT_GENERAR_TRASPASO_X_RZS = 0  

	IF @VP_L_04_PPT_GENERAR_TRASPASO_X_UNO IS NULL
		SET @VP_L_04_PPT_GENERAR_TRASPASO_X_UNO = 0  

	-- /////////////////////////////////////////////////////

	DECLARE @VP_L_PROCESAR AS INT = 0

	IF @VP_L_04_PPT_GENERAR_TRASPASOS_X_MES=1
		SET @VP_L_PROCESAR = 1  
	ELSE
		IF @VP_L_04_PPT_GENERAR_TRASPASO_X_RZS=1
			SET @VP_L_PROCESAR = 1  
		ELSE
			IF @VP_L_04_PPT_GENERAR_TRASPASO_X_UNO=1
				SET @VP_L_PROCESAR = 1  

	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 	
		BEGIN
		
		SET @VP_RESULTADO =  'El Control de Operación no permite [Generar] los [Traspasos]'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [RZS#' +CONVERT(VARCHAR(10),@VP_K_RAZON_SOCIAL)+'/'
		SET @VP_RESULTADO =  @VP_RESULTADO + 'UNO#' +CONVERT(VARCHAR(10),@VP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO+ ' para el Año '+CONVERT(VARCHAR(5),@VP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO+'  y el Mes '+ CONVERT(VARCHAR(5),@VP_K_MM) 
		
		END
						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO

-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_EDITAR POLIZA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_L_05_PFD_POLIZA_EDIT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_L_05_PFD_POLIZA_EDIT]
GO


CREATE PROCEDURE [dbo].[PG_RN_CONTROL_L_05_PFD_POLIZA_EDIT]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL				[INT],
	@PP_K_UNIDAD_OPERATIVA			[INT],
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO			VARCHAR(300)	= ''

	DECLARE @VP_K_RAZON_SOCIAL		AS INT=0
	DECLARE @VP_K_UNIDAD_OPERATIVA	AS INT=0
	DECLARE @VP_K_YYYY				AS INT=0
	DECLARE @VP_K_MM				AS INT=0
		
	-- /////////////////////////////////////////////////////
		
	SET @VP_K_RAZON_SOCIAL=		@PP_K_RAZON_SOCIAL
	SET @VP_K_UNIDAD_OPERATIVA=	@PP_K_UNIDAD_OPERATIVA
	SET @VP_K_YYYY=				@PP_K_YYYY
	SET @VP_K_MM=				@PP_K_MM	
			
	-- /////////////////////////////////////////////////////	

	IF @VP_K_RAZON_SOCIAL IS NULL
		SET @VP_K_RAZON_SOCIAL = 0  

	IF @VP_K_UNIDAD_OPERATIVA IS NULL
		SET @VP_K_UNIDAD_OPERATIVA = 0  

	IF @VP_K_YYYY IS NULL
		SET @VP_K_YYYY = 0  

	IF @VP_K_MM IS NULL
		SET @VP_K_MM = 0  

	-- /////////////////////////////////////////////////////	
	
	DECLARE @VP_L_05_PFD_POLIZA_EDIT_X_MES	INT
		
	SELECT	@VP_L_05_PFD_POLIZA_EDIT_X_MES =	L_05_PFD_POLIZA_EDIT 
												FROM	CONTROL_X_MES 
												WHERE	K_YYYY = @PP_K_YYYY 
												AND		K_MM=@PP_K_MM

	-- ===========================

	DECLARE @VP_L_05_PFD_POLIZA_EDIT_X_RZS		INT
	
	SELECT	@VP_L_05_PFD_POLIZA_EDIT_X_RZS =	L_05_PFD_POLIZA_EDIT 
												FROM	CONTROL_X_MES_X_RAZON_SOCIAL 
												WHERE	K_RAZON_SOCIAL = @PP_K_RAZON_SOCIAL
												AND		K_YYYY=@PP_K_YYYY 
												AND		K_MM=@PP_K_MM
		
	-- ===========================

	DECLARE @VP_L_05_PFD_POLIZA_EDIT_X_UNO		INT	

	SELECT	@VP_L_05_PFD_POLIZA_EDIT_X_UNO =	L_05_PFD_POLIZA_EDIT 
												FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA 
												WHERE	K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA
												AND		K_YYYY=@PP_K_YYYY 
												AND		K_MM=@PP_K_MM
		
	-- /////////////////////////////////////////////////////

	IF @VP_L_05_PFD_POLIZA_EDIT_X_MES IS NULL
		SET @VP_L_05_PFD_POLIZA_EDIT_X_MES = 0  

	IF @VP_L_05_PFD_POLIZA_EDIT_X_RZS IS NULL
		SET @VP_L_05_PFD_POLIZA_EDIT_X_RZS = 0  

	IF @VP_L_05_PFD_POLIZA_EDIT_X_UNO IS NULL
		SET @VP_L_05_PFD_POLIZA_EDIT_X_UNO = 0  

	-- /////////////////////////////////////////////////////

	DECLARE @VP_L_PROCESAR AS INT = 0

	IF @VP_L_05_PFD_POLIZA_EDIT_X_MES=1
		SET @VP_L_PROCESAR = 1  
	ELSE
		IF @VP_L_05_PFD_POLIZA_EDIT_X_RZS=1
			SET @VP_L_PROCESAR = 1  
		ELSE
			IF @VP_L_05_PFD_POLIZA_EDIT_X_UNO=1
				SET @VP_L_PROCESAR = 1  

	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 	
		BEGIN
		SET @VP_RESULTADO =  'El Control de Operación no permite [Editar] la póliza'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [RZS#' +CONVERT(VARCHAR(10),@VP_K_RAZON_SOCIAL)+'/'
		SET @VP_RESULTADO =  @VP_RESULTADO + 'UNO#' +CONVERT(VARCHAR(10),@VP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO+ ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO+'  y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		END				
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_INGRESOS_ADD
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_L_06_PFD_INGRESOS_ADD]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_L_06_PFD_INGRESOS_ADD]
GO


CREATE PROCEDURE [dbo].[PG_RN_CONTROL_L_06_PFD_INGRESOS_ADD]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL				[INT],
	@PP_K_UNIDAD_OPERATIVA			[INT],
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO			VARCHAR(300)	= ''

	DECLARE @VP_K_RAZON_SOCIAL		AS INT=0
	DECLARE @VP_K_UNIDAD_OPERATIVA	AS INT=0
	DECLARE @VP_K_YYYY				AS INT=0
	DECLARE @VP_K_MM				AS INT=0
		
	-- /////////////////////////////////////////////////////
		
	SET @VP_K_RAZON_SOCIAL=		@PP_K_RAZON_SOCIAL
	SET @VP_K_UNIDAD_OPERATIVA=	@PP_K_UNIDAD_OPERATIVA
	SET @VP_K_YYYY=				@PP_K_YYYY
	SET @VP_K_MM=				@PP_K_MM	
			
	-- /////////////////////////////////////////////////////	

	IF @VP_K_RAZON_SOCIAL IS NULL
		SET @VP_K_RAZON_SOCIAL = 0  

	IF @VP_K_UNIDAD_OPERATIVA IS NULL
		SET @VP_K_UNIDAD_OPERATIVA = 0  

	IF @VP_K_YYYY IS NULL
		SET @VP_K_YYYY = 0  

	IF @VP_K_MM IS NULL
		SET @VP_K_MM = 0  

	-- /////////////////////////////////////////////////////	
	
	DECLARE @VP_L_06_PFD_INGRESOS_ADD_X_MES		INT
		
	SELECT	@VP_L_06_PFD_INGRESOS_ADD_X_MES =	L_06_PFD_INGRESOS_ADD 
												FROM	CONTROL_X_MES 
												WHERE	K_YYYY = @PP_K_YYYY 
												AND		K_MM=@PP_K_MM

	-- ===========================

	DECLARE @VP_L_06_PFD_INGRESOS_ADD_X_RZS		INT
	
	SELECT	@VP_L_06_PFD_INGRESOS_ADD_X_RZS =	L_06_PFD_INGRESOS_ADD 
												FROM	CONTROL_X_MES_X_RAZON_SOCIAL 
												WHERE	K_RAZON_SOCIAL = @PP_K_RAZON_SOCIAL
												AND		K_YYYY=@PP_K_YYYY 
												AND		K_MM=@PP_K_MM
		
	-- ===========================

	DECLARE @VP_L_06_PFD_INGRESOS_ADD_X_UNO		INT	

	SELECT	@VP_L_06_PFD_INGRESOS_ADD_X_UNO =	L_06_PFD_INGRESOS_ADD 
												FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA 
												WHERE	K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA
												AND		K_YYYY=@PP_K_YYYY 
												AND		K_MM=@PP_K_MM
		
	-- /////////////////////////////////////////////////////

	IF @VP_L_06_PFD_INGRESOS_ADD_X_MES IS NULL
		SET @VP_L_06_PFD_INGRESOS_ADD_X_MES = 0  

	IF @VP_L_06_PFD_INGRESOS_ADD_X_RZS IS NULL
		SET @VP_L_06_PFD_INGRESOS_ADD_X_RZS = 0  

	IF @VP_L_06_PFD_INGRESOS_ADD_X_UNO IS NULL
		SET @VP_L_06_PFD_INGRESOS_ADD_X_UNO = 0  

	-- /////////////////////////////////////////////////////

	DECLARE @VP_L_PROCESAR AS INT = 0

	IF @VP_L_06_PFD_INGRESOS_ADD_X_MES=1
		SET @VP_L_PROCESAR = 1  
	ELSE
		IF @VP_L_06_PFD_INGRESOS_ADD_X_RZS=1
			SET @VP_L_PROCESAR = 1  
		ELSE
			IF @VP_L_06_PFD_INGRESOS_ADD_X_UNO=1
				SET @VP_L_PROCESAR = 1  

	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 	
		BEGIN
		SET @VP_RESULTADO =  'El Control de Operación no permite [Agregar] [Ingresos]'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [RZS#' +CONVERT(VARCHAR(10),@VP_K_RAZON_SOCIAL)+'/'
		SET @VP_RESULTADO =  @VP_RESULTADO + 'UNO#' +CONVERT(VARCHAR(10),@VP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO+ ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO+'  y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		END				
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_AGREGAR TRASPASOS
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_L_07_PFD_TRASPASO_ADD]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_L_07_PFD_TRASPASO_ADD]
GO


CREATE PROCEDURE [dbo].[PG_RN_CONTROL_L_07_PFD_TRASPASO_ADD]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL				[INT],
	@PP_K_UNIDAD_OPERATIVA			[INT],
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@PP_K_TRASPASO					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO			VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_RAZON_SOCIAL		AS INT=0
	DECLARE @VP_K_UNIDAD_OPERATIVA	AS INT=0
	DECLARE @VP_K_YYYY				AS INT=0
	DECLARE @VP_K_MM				AS INT=0

	-- /////////////////////////////////////////////////////

	IF @PP_K_TRASPASO>0
		BEGIN
		SELECT	@VP_K_UNIDAD_OPERATIVA	=	K_UNIDAD_OPERATIVA,
				@VP_K_YYYY				=	YEAR(F_OPERACION),
				@VP_K_MM				=	MONTH(F_OPERACION),
				@VP_K_RAZON_SOCIAL		=	VI_K_RAZON_SOCIAL
											FROM	TRASPASO, VI_UNIDAD_OPERATIVA_CATALOGOS
											WHERE	TRASPASO.K_UNIDAD_OPERATIVA = VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
											AND		K_TRASPASO = @PP_K_TRASPASO
											AND		TRASPASO.L_BORRADO=0
		END
	ELSE
		BEGIN
		SET @VP_K_RAZON_SOCIAL=		@PP_K_RAZON_SOCIAL
		SET @VP_K_UNIDAD_OPERATIVA=	@PP_K_UNIDAD_OPERATIVA
		SET @VP_K_YYYY=				@PP_K_YYYY
		SET @VP_K_MM=				@PP_K_MM
		END
			
		
	-- /////////////////////////////////////////////////////	

	IF @VP_K_RAZON_SOCIAL IS NULL
		SET @VP_K_RAZON_SOCIAL = 0  

	IF @VP_K_UNIDAD_OPERATIVA IS NULL
		SET @VP_K_UNIDAD_OPERATIVA = 0  

	IF @VP_K_YYYY IS NULL
		SET @VP_K_YYYY = 0  

	IF @VP_K_MM IS NULL
		SET @VP_K_MM = 0  

	-- /////////////////////////////////////////////////////	

	DECLARE @VP_L_07_PFD_TRASPASO_ADD_X_MES	INT
		
	SELECT	@VP_L_07_PFD_TRASPASO_ADD_X_MES =	L_07_PFD_TRASPASO_ADD 
													FROM	CONTROL_X_MES 
													WHERE	K_YYYY=@VP_K_YYYY 
													AND		K_MM=@VP_K_MM

	-- ===========================

	DECLARE @VP_L_07_PFD_TRASPASO_ADD_X_RZS		INT	

	SELECT	@VP_L_07_PFD_TRASPASO_ADD_X_RZS=	L_07_PFD_TRASPASO_ADD 
													FROM	CONTROL_X_MES_X_RAZON_SOCIAL 
													WHERE	K_RAZON_SOCIAL=@VP_K_RAZON_SOCIAL
													AND		K_YYYY=@VP_K_YYYY 
													AND		K_MM=@VP_K_MM
		
	-- ===========================
	 
	DECLARE @VP_L_07_PFD_TRASPASO_ADD_X_UNO		INT	

	SELECT	@VP_L_07_PFD_TRASPASO_ADD_X_UNO=	L_07_PFD_TRASPASO_ADD 
													FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA 
													WHERE	K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA
													AND		K_YYYY=@VP_K_YYYY 
													AND		K_MM=@VP_K_MM			
			
	-- /////////////////////////////////////////////////////

	IF @VP_L_07_PFD_TRASPASO_ADD_X_MES IS NULL
		SET @VP_L_07_PFD_TRASPASO_ADD_X_MES = 0  

	IF @VP_L_07_PFD_TRASPASO_ADD_X_RZS IS NULL
		SET @VP_L_07_PFD_TRASPASO_ADD_X_RZS = 0  

	IF @VP_L_07_PFD_TRASPASO_ADD_X_UNO IS NULL
		SET @VP_L_07_PFD_TRASPASO_ADD_X_UNO = 0  

	-- /////////////////////////////////////////////////////

	DECLARE @VP_L_PROCESAR AS INT = 0

	IF @VP_L_07_PFD_TRASPASO_ADD_X_MES=1
		SET @VP_L_PROCESAR = 1  
	ELSE
		IF @VP_L_07_PFD_TRASPASO_ADD_X_RZS=1
			SET @VP_L_PROCESAR = 1  
		ELSE
			IF @VP_L_07_PFD_TRASPASO_ADD_X_UNO=1
				SET @VP_L_PROCESAR = 1  

	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 	
		BEGIN
		
		SET @VP_RESULTADO =  'El Control de Operación no permite [Agregar] [Traspasos]'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [RZS#' +CONVERT(VARCHAR(10),@VP_K_RAZON_SOCIAL)+'/'
		SET @VP_RESULTADO =  @VP_RESULTADO + 'UNO#' +CONVERT(VARCHAR(10),@VP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO+ ' para el Año '+CONVERT(VARCHAR(5),@VP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO+'  y el Mes '+ CONVERT(VARCHAR(5),@VP_K_MM) 
		
		END
						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_FACTURA_AGREGAR
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_L_08_PFD_FACTURA_ADD]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_L_08_PFD_FACTURA_ADD]
GO


CREATE PROCEDURE [dbo].[PG_RN_CONTROL_L_08_PFD_FACTURA_ADD]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL				[INT],
	@PP_K_UNIDAD_OPERATIVA			[INT],
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO			VARCHAR(300)	= ''

	DECLARE @VP_K_RAZON_SOCIAL		AS INT=0
	DECLARE @VP_K_UNIDAD_OPERATIVA	AS INT=0
	DECLARE @VP_K_YYYY				AS INT=0
	DECLARE @VP_K_MM				AS INT=0
		
	-- /////////////////////////////////////////////////////
		
	SET @VP_K_RAZON_SOCIAL=		@PP_K_RAZON_SOCIAL
	SET @VP_K_UNIDAD_OPERATIVA=	@PP_K_UNIDAD_OPERATIVA
	SET @VP_K_YYYY=				@PP_K_YYYY
	SET @VP_K_MM=				@PP_K_MM	
			
	-- /////////////////////////////////////////////////////	

	IF @VP_K_RAZON_SOCIAL IS NULL
		SET @VP_K_RAZON_SOCIAL = 0  

	IF @VP_K_UNIDAD_OPERATIVA IS NULL
		SET @VP_K_UNIDAD_OPERATIVA = 0  

	IF @VP_K_YYYY IS NULL
		SET @VP_K_YYYY = 0  

	IF @VP_K_MM IS NULL
		SET @VP_K_MM = 0  

	-- /////////////////////////////////////////////////////	
	
	DECLARE @VP_L_08_PFD_FACTURA_ADD_X_MES		INT
		
	SELECT	@VP_L_08_PFD_FACTURA_ADD_X_MES =	L_08_PFD_FACTURA_ADD 
												FROM	CONTROL_X_MES 
												WHERE	K_YYYY=@PP_K_YYYY 
												AND		K_MM=@PP_K_MM

	-- ===========================

	DECLARE @VP_L_08_PFD_FACTURA_ADD_X_RZS		INT
	
	SELECT	@VP_L_08_PFD_FACTURA_ADD_X_RZS =	L_08_PFD_FACTURA_ADD 
												FROM	CONTROL_X_MES_X_RAZON_SOCIAL 
												WHERE	K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL
												AND		K_YYYY=@PP_K_YYYY 
												AND		K_MM=@PP_K_MM
		
	-- ===========================

	DECLARE @VP_L_08_PFD_FACTURA_ADD_X_UNO		INT	

	SELECT	@VP_L_08_PFD_FACTURA_ADD_X_UNO =	L_08_PFD_FACTURA_ADD 
												FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA 
												WHERE	K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
												AND		K_YYYY=@PP_K_YYYY 
												AND		K_MM=@PP_K_MM
		
	-- /////////////////////////////////////////////////////

	IF @VP_L_08_PFD_FACTURA_ADD_X_MES IS NULL
		SET @VP_L_08_PFD_FACTURA_ADD_X_MES = 0  

	IF @VP_L_08_PFD_FACTURA_ADD_X_RZS IS NULL
		SET @VP_L_08_PFD_FACTURA_ADD_X_RZS = 0  

	IF @VP_L_08_PFD_FACTURA_ADD_X_UNO IS NULL
		SET @VP_L_08_PFD_FACTURA_ADD_X_UNO = 0  

	-- /////////////////////////////////////////////////////

	DECLARE @VP_L_PROCESAR AS INT = 0

	IF @VP_L_08_PFD_FACTURA_ADD_X_MES=1
		SET @VP_L_PROCESAR = 1  
	ELSE
		IF @VP_L_08_PFD_FACTURA_ADD_X_RZS=1
			SET @VP_L_PROCESAR = 1  
		ELSE
			IF @VP_L_08_PFD_FACTURA_ADD_X_UNO=1
				SET @VP_L_PROCESAR = 1  

	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 	
		BEGIN
		SET @VP_RESULTADO =  'El Control de Operación no permite [Agregar] [Facturas]'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [RZS#' +CONVERT(VARCHAR(10),@VP_K_RAZON_SOCIAL)+'/'
		SET @VP_RESULTADO =  @VP_RESULTADO + 'UNO#' +CONVERT(VARCHAR(10),@VP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO+ ' para el Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO+'  y el Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		END				
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_AGREGAR INSTRUCCION
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_CONTROL_L_09_PFD_INSTRUCCION_NEW]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_CONTROL_L_09_PFD_INSTRUCCION_NEW]
GO


CREATE PROCEDURE [dbo].[PG_RN_CONTROL_L_09_PFD_INSTRUCCION_NEW]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_K_RAZON_SOCIAL				[INT],
	@PP_K_UNIDAD_OPERATIVA			[INT],
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	-- ===========================		
	@PP_K_INSTRUCCION				[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO			VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_K_RAZON_SOCIAL		AS INT=0
	DECLARE @VP_K_UNIDAD_OPERATIVA	AS INT=0
	DECLARE @VP_K_YYYY				AS INT=0
	DECLARE @VP_K_MM				AS INT=0

	-- /////////////////////////////////////////////////////

	IF @PP_K_INSTRUCCION>0
		BEGIN
		SELECT	@VP_K_UNIDAD_OPERATIVA	=	K_UNIDAD_OPERATIVA,
				@VP_K_YYYY				=	YEAR(F_INSTRUCCION),
				@VP_K_MM				=	MONTH(F_INSTRUCCION),
				@VP_K_RAZON_SOCIAL		=	VI_K_RAZON_SOCIAL
											FROM	INSTRUCCION, VI_UNIDAD_OPERATIVA_CATALOGOS
											WHERE	INSTRUCCION.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA
											AND		K_INSTRUCCION=@PP_K_INSTRUCCION
											AND		INSTRUCCION.L_BORRADO=0
		END
	ELSE
		BEGIN
		SET @VP_K_RAZON_SOCIAL=		@PP_K_RAZON_SOCIAL
		SET @VP_K_UNIDAD_OPERATIVA=	@PP_K_UNIDAD_OPERATIVA
		SET @VP_K_YYYY=				@PP_K_YYYY
		SET @VP_K_MM=				@PP_K_MM
		END
			
		
	-- /////////////////////////////////////////////////////	

	IF @VP_K_RAZON_SOCIAL IS NULL
		SET @VP_K_RAZON_SOCIAL = 0  

	IF @VP_K_UNIDAD_OPERATIVA IS NULL
		SET @VP_K_UNIDAD_OPERATIVA = 0  

	IF @VP_K_YYYY IS NULL
		SET @VP_K_YYYY = 0  

	IF @VP_K_MM IS NULL
		SET @VP_K_MM = 0  

	-- /////////////////////////////////////////////////////	

	DECLARE @VP_L_09_PFD_INSTRUCCION_NEW_X_MES	INT
		
	SELECT	@VP_L_09_PFD_INSTRUCCION_NEW_X_MES =	L_09_PFD_INSTRUCCION_NEW 
													FROM	CONTROL_X_MES 
													WHERE	K_YYYY=@VP_K_YYYY 
													AND		K_MM=@VP_K_MM

	-- ===========================

	DECLARE @VP_L_09_PFD_INSTRUCCION_NEW_X_RZS		INT	

	SELECT	@VP_L_09_PFD_INSTRUCCION_NEW_X_RZS =	L_09_PFD_INSTRUCCION_NEW 
													FROM	CONTROL_X_MES_X_RAZON_SOCIAL 
													WHERE	K_RAZON_SOCIAL=@VP_K_RAZON_SOCIAL
													AND		K_YYYY=@VP_K_YYYY 
													AND		K_MM=@VP_K_MM
		
	-- ===========================
	 
	DECLARE @VP_L_09_PFD_INSTRUCCION_NEW_X_UNO		INT	

	SELECT	@VP_L_09_PFD_INSTRUCCION_NEW_X_UNO =	L_09_PFD_INSTRUCCION_NEW 
													FROM	CONTROL_X_MES_X_UNIDAD_OPERATIVA 
													WHERE	K_UNIDAD_OPERATIVA=@VP_K_UNIDAD_OPERATIVA
													AND		K_YYYY=@VP_K_YYYY 
													AND		K_MM=@VP_K_MM			
			
	-- /////////////////////////////////////////////////////

	IF @VP_L_09_PFD_INSTRUCCION_NEW_X_MES IS NULL
		SET @VP_L_09_PFD_INSTRUCCION_NEW_X_MES = 0  

	IF @VP_L_09_PFD_INSTRUCCION_NEW_X_RZS IS NULL
		SET @VP_L_09_PFD_INSTRUCCION_NEW_X_RZS = 0  

	IF @VP_L_09_PFD_INSTRUCCION_NEW_X_UNO IS NULL
		SET @VP_L_09_PFD_INSTRUCCION_NEW_X_UNO = 0  

	-- /////////////////////////////////////////////////////

	DECLARE @VP_L_PROCESAR AS INT = 0

	IF @VP_L_09_PFD_INSTRUCCION_NEW_X_MES=1
		SET @VP_L_PROCESAR = 1  
	ELSE
		IF @VP_L_09_PFD_INSTRUCCION_NEW_X_RZS=1
			SET @VP_L_PROCESAR = 1  
		ELSE
			IF @VP_L_09_PFD_INSTRUCCION_NEW_X_UNO=1
				SET @VP_L_PROCESAR = 1  

	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 	
		BEGIN
		
		SET @VP_RESULTADO =  'El Control de Operación no permite [Agregar] [Instrucciones]'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' de [RZS#' +CONVERT(VARCHAR(10),@VP_K_RAZON_SOCIAL)+'/'
		SET @VP_RESULTADO =  @VP_RESULTADO + 'UNO#' +CONVERT(VARCHAR(10),@VP_K_UNIDAD_OPERATIVA)+']'
		SET @VP_RESULTADO =  @VP_RESULTADO+ ' para el Año '+CONVERT(VARCHAR(5),@VP_K_YYYY)   
		SET @VP_RESULTADO =  @VP_RESULTADO+'  y el Mes '+ CONVERT(VARCHAR(5),@VP_K_MM) 
		
		END
						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
