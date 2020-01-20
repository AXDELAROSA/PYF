-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO 

-- //////////////////////////////////////////////////////////////






-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_DOCUMENTO_D0M4_SET_PRECIO_COSTO_PERFIL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_SET_PRECIO_COSTO_PERFIL]
GO


CREATE PROCEDURE [dbo].[PG_RN_DOCUMENTO_D0M4_SET_PRECIO_COSTO_PERFIL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_RN_DOCUMENTO_D0M4_SET_PRECIO_COSTO_PERFIL]'
	
	-- ////////////////////////////////////////////////

	DECLARE @VP_K_MM_DOCUMENTO					INT

	SELECT	@VP_K_MM_DOCUMENTO =				K_MM		
												FROM 	DOCUMENTO_D0M4
												WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	-- ===================================
															
	DECLARE @VP_K_MM_MAS_RECIENTE				INT

	SELECT	@VP_K_MM_MAS_RECIENTE =				MAX(PRECIO_COSTO_PERFIL.K_MM)		-- WIWI // HGF // ROBUSTECER // 20180322
												FROM 	PRECIO_COSTO_PERFIL, DOCUMENTO_D0M4
												WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
												AND		PRECIO_COSTO_PERFIL.K_UNIDAD_OPERATIVA=DOCUMENTO_D0M4.K_UNIDAD_OPERATIVA
												AND		PRECIO_COSTO_PERFIL.K_YYYY=DOCUMENTO_D0M4.K_YYYY
												AND		PRECIO_COSTO_PERFIL.K_MM<=@VP_K_MM_DOCUMENTO
												
	-- =====================================

	DECLARE @VP_K_PRECIO_COSTO_PERFIL			INT

	SELECT	@VP_K_PRECIO_COSTO_PERFIL =			PRECIO_COSTO_PERFIL.K_PRECIO_COSTO_PERFIL
												FROM 	PRECIO_COSTO_PERFIL, DOCUMENTO_D0M4
												WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
												AND		PRECIO_COSTO_PERFIL.K_UNIDAD_OPERATIVA=DOCUMENTO_D0M4.K_UNIDAD_OPERATIVA
												AND		PRECIO_COSTO_PERFIL.K_YYYY=DOCUMENTO_D0M4.K_YYYY
												AND		PRECIO_COSTO_PERFIL.K_MM=@VP_K_MM_MAS_RECIENTE
	-- =====================================

	IF @VP_K_PRECIO_COSTO_PERFIL IS NULL
		SET @VP_K_PRECIO_COSTO_PERFIL = 0
	
	-- =====================================

	UPDATE	DOCUMENTO_D0M4
	SET		K_PRECIO_COSTO_PERFIL = @VP_K_PRECIO_COSTO_PERFIL 	
	WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	-- =====================================
	
	IF @PP_L_DEBUG>1
		PRINT '@VP_K_PRECIO_COSTO_PERFIL = ' + CONVERT(VARCHAR(100),@VP_K_PRECIO_COSTO_PERFIL)
																
	-- /////////////////////////////////////////////////////////////
GO







-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_VIERNES_HABILES_EN_MES]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_VIERNES_HABILES_EN_MES]
GO


CREATE PROCEDURE [dbo].[PG_RN_VIERNES_HABILES_EN_MES]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT,
	@OU_N_VIERNES_HABILES		INT		OUTPUT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_RN_VIERNES_HABILES_EN_MES]'
	
	-- =============================

	DECLARE @VP_N_VIERNES_HABILES INT = 0

	-- ////////////////////////////////////////////////

	DECLARE @VP_DIA_SEMANA_D1	INT = -1

	DECLARE @VP_CU_N_DIA		INT
	DECLARE @VP_CU_DIA_SEMANA	INT
	DECLARE @VP_CU_L_ASUETO		INT

	-- =====================

	DECLARE CU_DIAS_MES
			CURSOR FOR   SELECT FECHA_DD, K_TIEMPO_DIA_SEMANA, L_ASUETO
								FROM	TIEMPO_FECHA, DOCUMENTO_D0M4	
								WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4 
								AND		TIEMPO_FECHA.FECHA_YYYY=DOCUMENTO_D0M4.K_YYYY
								AND		TIEMPO_FECHA.K_TIEMPO_MES=DOCUMENTO_D0M4.K_MM
								ORDER BY F_TIEMPO_FECHA
	-- =====================

	OPEN CU_DIAS_MES
		 FETCH NEXT FROM CU_DIAS_MES INTO @VP_CU_N_DIA, @VP_CU_DIA_SEMANA, @VP_CU_L_ASUETO
     
		 WHILE @@FETCH_STATUS = 0
			BEGIN
	
			IF @PP_L_DEBUG>2
				PRINT 'CICLO ' + CONVERT(VARCHAR(10),@VP_CU_N_DIA)

			IF @VP_CU_DIA_SEMANA=5
				SET @VP_N_VIERNES_HABILES = @VP_N_VIERNES_HABILES + 1
			
			IF @VP_CU_DIA_SEMANA=5
				IF @VP_CU_L_ASUETO=1
					IF @VP_CU_N_DIA = 1
						SET @VP_N_VIERNES_HABILES = @VP_N_VIERNES_HABILES - 1
		
			-- =============================		
			
			FETCH NEXT FROM CU_DIAS_MES INTO @VP_CU_N_DIA, @VP_CU_DIA_SEMANA, @VP_CU_L_ASUETO

			END
	
	-- =====================

	CLOSE CU_DIAS_MES
	
	DEALLOCATE CU_DIAS_MES

	-- ////////////////////////////////////////////////

	IF @PP_L_DEBUG>1
		PRINT '@OU_N_VIERNES_HABILES = ' + CONVERT(VARCHAR(10),@OU_N_VIERNES_HABILES)

	-- =============================		

	SET @OU_N_VIERNES_HABILES = @OU_N_VIERNES_HABILES

	-- /////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRIMER_HABIL_ANTES_24]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRIMER_HABIL_ANTES_24]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRIMER_HABIL_ANTES_24]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT,
	@OU_N_DIA					INT		OUTPUT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_RN_PRIMER_HABIL_ANTES_24]'
	
	-- =============================

	DECLARE @VP_N_DIA_HABIL_ANTES_DEL_24 INT = 1

	-- ////////////////////////////////////////////////

	
	DECLARE @VP_DIA_SEMANA_D1	INT = -1

	DECLARE @VP_CU_N_DIA		INT
	DECLARE @VP_CU_DIA_SEMANA	INT
	DECLARE @VP_CU_L_ASUETO		INT

	-- =====================

	DECLARE CU_DIAS_MES
			CURSOR FOR   SELECT FECHA_DD, K_TIEMPO_DIA_SEMANA, L_ASUETO
								FROM	TIEMPO_FECHA, DOCUMENTO_D0M4	
								WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4 
								AND		TIEMPO_FECHA.FECHA_YYYY=DOCUMENTO_D0M4.K_YYYY
								AND		TIEMPO_FECHA.K_TIEMPO_MES=DOCUMENTO_D0M4.K_MM
								AND		( 17<=FECHA_DD AND FECHA_DD<=24 )
								ORDER BY F_TIEMPO_FECHA
	-- =====================

	OPEN CU_DIAS_MES
		 FETCH NEXT FROM CU_DIAS_MES INTO @VP_CU_N_DIA, @VP_CU_DIA_SEMANA, @VP_CU_L_ASUETO
     
		 WHILE @@FETCH_STATUS = 0
			BEGIN
	
			IF @PP_L_DEBUG>2
				PRINT 'CICLO ' + CONVERT(VARCHAR(10),@VP_CU_N_DIA)

			IF @VP_CU_L_ASUETO=0
				IF @VP_CU_DIA_SEMANA<>6 AND @VP_CU_DIA_SEMANA<>7
					SET @VP_N_DIA_HABIL_ANTES_DEL_24 = @VP_CU_N_DIA

			-- =============================		
			
			FETCH NEXT FROM CU_DIAS_MES INTO @VP_CU_N_DIA, @VP_CU_DIA_SEMANA, @VP_CU_L_ASUETO

			END
	
	-- =====================

	CLOSE CU_DIAS_MES
	
	DEALLOCATE CU_DIAS_MES

	-- ////////////////////////////////////////////////

	IF @PP_L_DEBUG>1
		PRINT '@VP_N_DIA_HABIL_ANTES_DEL_24 = ' + CONVERT(VARCHAR(10),@VP_N_DIA_HABIL_ANTES_DEL_24)

	-- =============================		

	SET @OU_N_DIA = @VP_N_DIA_HABIL_ANTES_DEL_24

	-- /////////////////////////////////////////////////////////////
GO





-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PV_PRECIO_VENTA_KG_X_K_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PV_PRECIO_VENTA_KG_X_K_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_RN_PV_PRECIO_VENTA_KG_X_K_DOCUMENTO_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT,
	@OU_PV_PRECIO_VENTA_X_KG	DECIMAL(19,4)		OUTPUT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_RN_PV_PRECIO_VENTA_KG_X_K_DOCUMENTO_D0M4]'

	-- ====================================

	DECLARE @VP_PV_PRECIO_VENTA_X_KG			DECIMAL(19,4) = 0

	SELECT	@VP_PV_PRECIO_VENTA_X_KG =			PV_PRECIO_VENTA	-- WIWI // HGF // ROBUSTECER // 20180322
												FROM 	PRECIO_COSTO_PERFIL, DOCUMENTO_D0M4
												WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
												AND		DOCUMENTO_D0M4.K_PRECIO_COSTO_PERFIL=PRECIO_COSTO_PERFIL.K_PRECIO_COSTO_PERFIL
	-- ====================================
	
	IF @VP_PV_PRECIO_VENTA_X_KG IS NULL
		SET @VP_PV_PRECIO_VENTA_X_KG = 0
	
	-- ====================================
	
	SET @OU_PV_PRECIO_VENTA_X_KG = @VP_PV_PRECIO_VENTA_X_KG

	-- //////////////////////////////////////////////////////////////
GO



-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
