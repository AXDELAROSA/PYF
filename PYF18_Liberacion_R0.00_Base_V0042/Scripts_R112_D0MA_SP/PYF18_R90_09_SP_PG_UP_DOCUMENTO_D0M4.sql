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





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> ACTUALIZAR / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APG_UP_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[APG_UP_DOCUMENTO_D0M4]
GO

CREATE PROCEDURE [dbo].[APG_UP_DOCUMENTO_D0M4]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4	    	INT,	
    @PP_O_DOCUMENTO_D0M4			INT,
	-- ===========================	
    @PP_K_FORMATO_D0M4          	INT, 
    @PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_YYYY						INT,
	@PP_K_MM						INT
	-- ===========================		
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
		
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_UPDATE]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_PRECIO_COSTO_PERFIL] 	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, 
																	@PP_K_USUARIO_ACCION,
																	@PP_K_UNIDAD_OPERATIVA,@PP_K_YYYY,@PP_K_MM, 
																	@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- //////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		BEGIN

		DECLARE	@VP_K_PRECIO_COSTO_PERFIL INT	

		SELECT	@VP_K_PRECIO_COSTO_PERFIL = PCP.K_PRECIO_COSTO_PERFIL	FROM PRECIO_COSTO_PERFIL PCP
																		WHERE PCP.K_MM = @PP_K_MM 
																		AND PCP.K_YYYY = @PP_K_YYYY 
																		AND PCP.K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA

		-- ============================================================
		
		DECLARE @VP_D_UNIDAD_OPERATIVA 	VARCHAR	(100)

		SELECT 	@VP_D_UNIDAD_OPERATIVA 	= UPPER(UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA)	FROM	UNIDAD_OPERATIVA 
																						WHERE	K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA		
		-- ============================================================

		DECLARE @VP_D_DOCUMENTO_D0M4 	VARCHAR (100)	
		SET		@VP_D_DOCUMENTO_D0M4	= CONCAT(	@VP_D_UNIDAD_OPERATIVA, '#', 
													@PP_K_DOCUMENTO_D0M4, '#', 
													@PP_K_UNIDAD_OPERATIVA, '#', 
													@PP_K_YYYY, '#', 
													@PP_K_MM)
		
		-- ============================================================
		
		DECLARE @VP_C_DOCUMENTO_D0M4 	VARCHAR (255)
		SET 	@VP_C_DOCUMENTO_D0M4 	= CONCAT (	'[SYS##', @PP_K_DOCUMENTO_D0M4,'] ',
													@VP_D_UNIDAD_OPERATIVA		)

		-- ============================================================

		DECLARE @VP_S_DOCUMENTO_D0M4 	VARCHAR(10)
		SET 	@VP_S_DOCUMENTO_D0M4 	= CONCAT('SYS[D0#',@PP_K_FORMATO_D0M4)
		
		-- ============================================================

		UPDATE	DOCUMENTO_D0M4
		SET		
				[D_DOCUMENTO_D0M4]			=	@VP_D_DOCUMENTO_D0M4,
				[C_DOCUMENTO_D0M4]			=	@VP_C_DOCUMENTO_D0M4,
				[S_DOCUMENTO_D0M4]			=	@VP_S_DOCUMENTO_D0M4,
				[O_DOCUMENTO_D0M4]      	=   @PP_O_DOCUMENTO_D0M4,
				-- ===========================	
				[K_FORMATO_D0M4]        	=   @PP_K_FORMATO_D0M4,	 
				[K_UNIDAD_OPERATIVA]    	=   @PP_K_UNIDAD_OPERATIVA,
				[K_YYYY]                	=   @PP_K_YYYY,
				[K_MM]                  	=   @PP_K_MM,
				[K_PRECIO_COSTO_PERFIL] 	=   @VP_K_PRECIO_COSTO_PERFIL,
				[L_RECALCULAR]          	=   0,
				-- ====================
				[F_CAMBIO]			=	GETDATE(), 
				[K_USUARIO_CAMBIO]	=	@PP_K_USUARIO_ACCION
		WHERE	K_DOCUMENTO_D0M4	=	@PP_K_DOCUMENTO_D0M4			
		EXECUTE [dbo].[PG_IN_DATA_N1_X_DI_D0M4_X_K_DOCUMENTO_D0M4] @PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4
		EXECUTE [dbo].[PG_OP_DOCUMENTO_DOM4_RECALCULAR]@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4	

		end

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [Documento/D0M4]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#DM4.'+CONVERT(VARCHAR(10),@PP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'		

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE
	
	-- //////////////////////////////////////////////////////////////
GO








-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////

