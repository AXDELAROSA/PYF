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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRECIO_COSTO_PERFIL_SET_VALOR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRECIO_COSTO_PERFIL_SET_VALOR]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRECIO_COSTO_PERFIL_SET_VALOR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_K_DATO_D0M4				INT,
	@PP_NOMBRE_DATO				VARCHAR(100)
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_RN_PRECIO_COSTO_PERFIL_SET_VALOR]'
	
	-- =============================

	DECLARE @VP_VALOR			DECIMAL(19,4)

	-- ////////////////////////////////////////////////

	DECLARE @VP_K_PRECIO_COSTO_PERFIL			DECIMAL(19,4)

	SELECT @VP_K_PRECIO_COSTO_PERFIL =			K_PRECIO_COSTO_PERFIL
												FROM 	DOCUMENTO_D0M4
												WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4												
	-- =====================================

	DECLARE @VP_SQL		NVARCHAR(MAX)

	SET		@VP_SQL =	           'SELECT' 
	SET		@VP_SQL =	@VP_SQL + ' @OU_VALOR = '+@PP_NOMBRE_DATO+ ''
	SET		@VP_SQL =	@VP_SQL + ' FROM PRECIO_COSTO_PERFIL'  
	SET		@VP_SQL =	@VP_SQL + ' WHERE K_PRECIO_COSTO_PERFIL='+CONVERT(VARCHAR(50),@VP_K_PRECIO_COSTO_PERFIL)+' '

	-- ===============================

	DECLARE @VP_DEFINICION_PARAMETROS		NVARCHAR(500)
	
	SET		@VP_DEFINICION_PARAMETROS =		N'@OU_VALOR DECIMAL(19,4) OUTPUT'

	-- ===============================

	EXECUTE sp_executesql	@VP_SQL, @VP_DEFINICION_PARAMETROS, 
							@OU_VALOR = @VP_VALOR		OUTPUT

	-- ===============================

	IF @VP_VALOR IS NULL
		SET @VP_VALOR = 0.1234		-- WIWI // TEMPORAL PARA INDICAR QUE NO HAY VALOR

	-- ////////////////////////////////////////////////
	
	IF @PP_L_DEBUG>1
		PRINT @PP_NOMBRE_DATO + ' = ' + CONVERT(VARCHAR(100),@VP_VALOR)
	
	-- =============================		

	EXECUTE [dbo].[PG_CA_MATE_N1_10B_ASIGNAR_VALOR]			@PP_K_DOCUMENTO_D0M4,	
															@PP_K_DATO_D0M4, 0, @VP_VALOR
															
	-- /////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N1_DIA_SEMANA_Y_ASUETOS_CALCULAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N1_DIA_SEMANA_Y_ASUETOS_CALCULAR]
GO


CREATE PROCEDURE [dbo].[PG_OP_DATA_N1_DIA_SEMANA_Y_ASUETOS_CALCULAR]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4			INT,
	@PP_K_DATO_D0M4_DIA_SEMANA		INT,
	@PP_K_DATO_D0M4_ASUETO			INT
AS

	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N1_DIA_SEMANA_Y_ASUETOS_CALCULAR]'

	-- ////////////////////////////////////////////////
	
	EXECUTE [dbo].[PG_CA_MATE_N1_10B_ASIGNAR_VALOR]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_DIA_SEMANA, 0, 0.00
	EXECUTE [dbo].[PG_CA_MATE_N1_10B_ASIGNAR_VALOR]	@PP_K_DOCUMENTO_D0M4, @PP_K_DATO_D0M4_ASUETO,	  0, 0.00

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
								ORDER BY FECHA_DD
	-- =====================

	OPEN CU_DIAS_MES
		 FETCH NEXT FROM CU_DIAS_MES INTO @VP_CU_N_DIA, @VP_CU_DIA_SEMANA, @VP_CU_L_ASUETO
     
		 WHILE @@FETCH_STATUS = 0
			BEGIN

			IF @PP_L_DEBUG>2
				PRINT @VP_CU_N_DIA
			
			-- ========================

			IF @VP_DIA_SEMANA_D1<0
				SET @VP_DIA_SEMANA_D1 = @VP_CU_DIA_SEMANA

			-- =============================		
			-- == DETERMINAR ASUETO	 
			IF @VP_CU_L_ASUETO=1
				EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
																		@PP_K_DATO_D0M4_ASUETO,		1,				   @VP_CU_N_DIA
			-- =============================		
			-- == DETERMINAR DIA SEMANA
			EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]		@PP_K_DOCUMENTO_D0M4,
																		@PP_K_DATO_D0M4_DIA_SEMANA,	@VP_CU_DIA_SEMANA, @VP_CU_N_DIA		
			-- =============================		
			
			FETCH NEXT FROM CU_DIAS_MES INTO @VP_CU_N_DIA, @VP_CU_DIA_SEMANA, @VP_CU_L_ASUETO

			END
	
	-- =====================

	CLOSE CU_DIAS_MES
	
	DEALLOCATE CU_DIAS_MES

	-- ////////////////////////////////////////////////
	-- WIWI
	SET @VP_CU_DIA_SEMANA = ( @VP_DIA_SEMANA_D1 -1 )

	IF @VP_CU_DIA_SEMANA=0
		SET @VP_CU_DIA_SEMANA = 7

	EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
															@PP_K_DATO_D0M4_DIA_SEMANA,	@VP_CU_DIA_SEMANA, 00
	-- ==============================================
	SET @VP_CU_DIA_SEMANA = ( @VP_CU_DIA_SEMANA - 1 )

	IF @VP_CU_DIA_SEMANA=0
		SET @VP_CU_DIA_SEMANA = 7

	EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
															@PP_K_DATO_D0M4_DIA_SEMANA,	@VP_CU_DIA_SEMANA, -1
	-- ==============================================

	SET @VP_CU_DIA_SEMANA = ( @VP_CU_DIA_SEMANA - 1 )
	
	IF @VP_CU_DIA_SEMANA=0
		SET @VP_CU_DIA_SEMANA = 7
	
	EXECUTE [dbo].[PG_CA_MATE_N1_10B2_ASIGNAR_VALOR_X_DIA]	@PP_K_DOCUMENTO_D0M4,
															@PP_K_DATO_D0M4_DIA_SEMANA,	@VP_CU_DIA_SEMANA, -2

	-- ////////////////////////////////////////////////
GO



-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
