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

--//////////////////////////////////////////////////////////////


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
--											PARAMETRO_POB			
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PARAMETRO_POB]') AND type in (N'P', N'PC'))
	DROP PROCEDURE	[dbo].[PG_LI_PARAMETRO_POB]
GO


CREATE PROCEDURE [dbo].[PG_LI_PARAMETRO_POB]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================	
	@PP_D_PARAMETRO_POB				VARCHAR(200),
	@PP_K_ZONA_UO					INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_YYYY						INT,
	@PP_K_TEMPORADA					INT
	-- ===========================
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT=1

	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
			DECLARE @VP_INT_NUMERO_REGISTROS	INT
	
			EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																				@VP_L_APLICAR_MAX_ROWS,		
																				@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
			-- =========================================		

			DECLARE @VP_K_FOLIO		INT

			EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_D_PARAMETRO_POB, 
															@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
			-- =========================================
			
			SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
					PARAMETRO_POB.*, DOCUMENTO_D0M4.K_DOCUMENTO_D0M4, 
					D_UNIDAD_OPERATIVA, D_ZONA_UO, D_DOCUMENTO_D0M4, D_TEMPORADA, D_TIPO_CALCULO,
					S_UNIDAD_OPERATIVA, S_ZONA_UO, S_DOCUMENTO_D0M4, D_TEMPORADA, D_TIPO_CALCULO,
					USUARIO.D_USUARIO AS 'D_USUARIO_CAMBIO'
			FROM	PARAMETRO_POB, 
					UNIDAD_OPERATIVA, ZONA_UO, USUARIO, DOCUMENTO_D0M4, TEMPORADA, TIPO_CALCULO
			WHERE	PARAMETRO_POB.K_USUARIO_CAMBIO=USUARIO.K_USUARIO 
			AND		PARAMETRO_POB.K_DOCUMENTO_D0M4=DOCUMENTO_D0M4.K_DOCUMENTO_D0M4
			AND		PARAMETRO_POB.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA 	
			AND		UNIDAD_OPERATIVA.K_ZONA_UO =ZONA_UO.K_ZONA_UO
			AND		PARAMETRO_POB.K_TEMPORADA=TEMPORADA.K_TEMPORADA
			AND		PARAMETRO_POB.K_TIPO_CALCULO=TIPO_CALCULO.K_TIPO_CALCULO
			AND		PARAMETRO_POB.L_BORRADO=0
			AND		(	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA	LIKE '%'+@PP_D_PARAMETRO_POB+'%' 
						OR	K_PARAMETRO_POB=@VP_K_FOLIO	)	
			AND		(	@PP_K_UNIDAD_OPERATIVA=-1 
						OR  PARAMETRO_POB.K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA)
			AND		(	@PP_K_YYYY=-1 OR  PARAMETRO_POB.K_YYYY = @PP_K_YYYY)
			AND		(	@PP_K_ZONA_UO=-1 OR UNIDAD_OPERATIVA.K_ZONA_UO= @PP_K_ZONA_UO )
			AND		(	@PP_K_TEMPORADA=-1 OR PARAMETRO_POB.K_TEMPORADA=@PP_K_TEMPORADA)
			ORDER BY O_PARAMETRO_POB
				
		END
	ELSE
		BEGIN	-- RESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

			SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
					PARAMETRO_POB.*,DOCUMENTO_D0M4.K_DOCUMENTO_D0M4,DOCUMENTO_D0M4.D_DOCUMENTO_D0M4, ZONA_UO.D_ZONA_UO,UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA,
					TEMPORADA.D_TEMPORADA,TIPO_CALCULO.D_TIPO_CALCULO,
					USUARIO.D_USUARIO AS 'D_USUARIO_CAMBIO'
			FROM	PARAMETRO_POB,UNIDAD_OPERATIVA,ZONA_UO,USUARIO,DOCUMENTO_D0M4,TEMPORADA,TIPO_CALCULO
			WHERE	PARAMETRO_POB.K_USUARIO_CAMBIO=USUARIO.K_USUARIO 
			AND		PARAMETRO_POB.K_DOCUMENTO_D0M4=DOCUMENTO_D0M4.K_DOCUMENTO_D0M4
			AND		PARAMETRO_POB.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA 	
			AND		UNIDAD_OPERATIVA.K_ZONA_UO =ZONA_UO.K_ZONA_UO
			AND		PARAMETRO_POB.K_TEMPORADA=TEMPORADA.K_TEMPORADA
			AND		PARAMETRO_POB.K_TIPO_CALCULO= TIPO_CALCULO.K_TIPO_CALCULO
			AND		PARAMETRO_POB.K_PARAMETRO_POB<0

		END

	-- ////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_PARAMETRO_POB]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_PARAMETRO_POB]
GO


CREATE PROCEDURE [dbo].[PG_SK_PARAMETRO_POB]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_PARAMETRO_POB	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
		SELECT	PARAMETRO_POB.*, PARAMETRO_POB.K_YYYY AS 'K_TIEMPO_YYYY'
		FROM	PARAMETRO_POB
		WHERE	PARAMETRO_POB.L_BORRADO=0
		AND		PARAMETRO_POB.K_PARAMETRO_POB=@PP_K_PARAMETRO_POB
		
		END
	-- ////////////////////////////////////////////////
GO


	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////P

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PARAMETRO_POB]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PARAMETRO_POB]
GO


CREATE PROCEDURE [dbo].[PG_IN_PARAMETRO_POB]
	@PP_L_DEBUG					    INT,
	@PP_K_SISTEMA_EXE			    INT,
	@PP_K_USUARIO_ACCION		    INT,	
	-- ===========================	 
    @PP_D_PARAMETRO_POB				VARCHAR (200),
	-- ===========================
	@PP_K_DOCUMENTO_D0M4			INT,
	@PP_K_UNIDAD_OPERATIVA		    INT,
	@PP_K_YYYY					    INT,
	@PP_K_TEMPORADA						INT,
	-- ===========================
	@PP_HISTORICO_CONSIDERABLE		INT,
	@PP_INCREMENTO_COMPROMISO_KG	DECIMAL(19,0),
	@PP_K_TIPO_CALCULO				INT
	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
	DECLARE @VP_K_PARAMETRO_POB	INT = 0

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PARAMETRO_POB_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@VP_K_PARAMETRO_POB, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	
	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'PARAMETRO_POB', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_PARAMETRO_POB		OUTPUT
		-- //////////////////////////////////////////////////////////////			
		INSERT INTO PARAMETRO_POB
			(	[K_PARAMETRO_POB],		
				[O_PARAMETRO_POB],
				[D_PARAMETRO_POB],
				-- ===========================
				[K_DOCUMENTO_D0M4],
				[K_UNIDAD_OPERATIVA], 
				[K_YYYY],
				[K_TEMPORADA],
				-- ===========================	
				[HISTORICO_CONSIDERABLE],
				[INCREMENTO_COMPROMISO_KG],
				[K_TIPO_CALCULO],
				-- ===========================		
				[K_USUARIO_ALTA],	[F_ALTA],
				[K_USUARIO_CAMBIO],	[F_CAMBIO],
				[L_BORRADO]		)	
		VALUES	
			(	
				@VP_K_PARAMETRO_POB,
				10,
				@PP_D_PARAMETRO_POB,
				-- ===========================
				@PP_K_DOCUMENTO_D0M4,
				@PP_K_UNIDAD_OPERATIVA,	
				@PP_K_YYYY, 
				@PP_K_TEMPORADA,
				-- ===========================	
				@PP_HISTORICO_CONSIDERABLE,
				@PP_INCREMENTO_COMPROMISO_KG,
				@PP_K_TIPO_CALCULO,
				-- =============================	
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0 )
		END

		EXECUTE [dbo].[PG_IN_DATA_N3_X_ME_D0M4_X_K_DOCUMENTO_D0M4]				@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@VP_K_PARAMETRO_POB
		EXECUTE [dbo].[PG_OP_DATA_N3_4000_PROYECCION_DE_VENTAS_RECALCULAR]		@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@VP_K_PARAMETRO_POB


	-- /////////////////////////////////////////////////////////////////////
			
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [PARAMETRO_POB]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@VP_K_PARAMETRO_POB)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PARAMETRO_POB AS CLAVE
		
	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> ACTUALIZAR / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PARAMETRO_POB]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PARAMETRO_POB]
GO

CREATE PROCEDURE [dbo].[PG_UP_PARAMETRO_POB]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_PARAMETRO_POB	INT,
	@PP_D_PARAMETRO_POB	VARCHAR(200),
	-- ===========================	
	@PP_K_DOCUMENTO_D0M4			INT,
	@PP_K_UNIDAD_OPERATIVA		    INT,
	@PP_K_YYYY					    INT,
	@PP_K_TEMPORADA						INT,
	-- ===========================	
	@PP_HISTORICO_CONSIDERABLE		INT,
	@PP_INCREMENTO_COMPROMISO_KG	DECIMAL(19,0),
	@PP_K_TIPO_CALCULO				INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
		
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PARAMETRO_POB_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PARAMETRO_POB, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		BEGIN
		UPDATE	PARAMETRO_POB
		SET		
				[K_DOCUMENTO_D0M4]			=	@PP_K_DOCUMENTO_D0M4,
				[K_UNIDAD_OPERATIVA]		=	@PP_K_UNIDAD_OPERATIVA,
				[K_YYYY]					=	@PP_K_YYYY,
				[K_TEMPORADA]				=	@PP_K_TEMPORADA,			
				-- ===========================	
                [O_PARAMETRO_POB]			=   10,
                [D_PARAMETRO_POB]			=   @PP_D_PARAMETRO_POB,
               
                -- ===========================
				[HISTORICO_CONSIDERABLE]	=		@PP_HISTORICO_CONSIDERABLE,
				[INCREMENTO_COMPROMISO_KG]	=		@PP_INCREMENTO_COMPROMISO_KG,
				[K_TIPO_CALCULO]			=		@PP_K_TIPO_CALCULO,
				-- ====================
				[F_CAMBIO]			=	GETDATE(), 
				[K_USUARIO_CAMBIO]	=	@PP_K_USUARIO_ACCION
		WHERE	PARAMETRO_POB.K_PARAMETRO_POB=@PP_K_PARAMETRO_POB
		END


		EXECUTE [dbo].[PG_IN_DATA_N3_X_ME_D0M4_X_K_DOCUMENTO_D0M4]				@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@PP_K_PARAMETRO_POB
		EXECUTE [dbo].[PG_OP_DATA_N3_4000_PROYECCION_DE_VENTAS_RECALCULAR]		@PP_L_DEBUG,@PP_K_SISTEMA_EXE,@PP_K_USUARIO_ACCION,@PP_K_PARAMETRO_POB

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [PARAMETRO_POB]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@PP_K_PARAMETRO_POB)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PARAMETRO_POB AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PARAMETRO_POB AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_PARAMETRO_POB]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_PARAMETRO_POB]
GO


CREATE PROCEDURE [dbo].[PG_DL_PARAMETRO_POB]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_PARAMETRO_POB		INT

AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PARAMETRO_POB_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																@PP_K_PARAMETRO_POB, 
																@OU_RESULTADO_VALIDACION = @VP_MENSAJE	OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
	--	DELETE
	--	FROM	DOCUMENTO_D0M4
	--	WHERE	DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

		UPDATE	PARAMETRO_POB
		SET		
				[L_BORRADO]		 =	1,
				-- ====================
				[F_BAJA]		 	=	GETDATE(), 
				[K_USUARIO_BAJA] 	=	@PP_K_USUARIO_ACCION
		WHERE	[K_PARAMETRO_POB]	=	@PP_K_PARAMETRO_POB
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] el [PARAMETRO_POB]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@PP_K_PARAMETRO_POB)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PARAMETRO_POB AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PARAMETRO_POB AS CLAVE

	-- /////////////////////////////////////////////////////////////////////
GO





-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////



