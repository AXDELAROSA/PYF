-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			
-- // OPERACION:		LIBERACION // STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////





-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_DL_DOCUMENTO_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_DELETE]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, 
															@PP_K_USUARIO_ACCION,
															@PP_K_DOCUMENTO_D0M4, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE	OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
	--	DELETE
	--	FROM	DOCUMENTO_D0M4
	--	WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

		UPDATE	DOCUMENTO_D0M4
		SET		
				[L_BORRADO]		 =	1,
				-- ====================
				[F_BAJA]		 =	GETDATE(), 
				[K_USUARIO_BAJA] =	@PP_K_USUARIO_ACCION
		WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

		-- =============================================

		DELETE 
		FROM	DATA_N1_X_DI_D0M4 
		WHERE	DATA_N1_X_DI_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		
		-- =============================================

		DECLARE @VP_CONTADOR_PARAMETROS AS INT = 0
		
		SELECT	@VP_CONTADOR_PARAMETROS =	COUNT(K_DOCUMENTO_D0M4) 
											FROM	PARAMETRO_DOCUMENTO_D0M4 
											WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		
		IF @VP_CONTADOR_PARAMETROS>0
			EXECUTE [dbo].[PG_DL_PARAMETRO_DOCUMENTO_D0M4] @PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION, @PP_K_DOCUMENTO_D0M4
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [Documento/D0M4]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#DM4.'+CONVERT(VARCHAR(10),@PP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'
		
		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_DOCUMENTO_D0M4 AS CLAVE

	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
