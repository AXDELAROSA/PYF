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



-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_DOCUMENTO_D0M4_L_RECALCULAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_DOCUMENTO_D0M4_L_RECALCULAR]
GO


CREATE PROCEDURE [dbo].[PG_UP_DOCUMENTO_D0M4_L_RECALCULAR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS
	
	UPDATE	DOCUMENTO_D0M4
	SET		L_RECALCULAR = 1
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	-- //////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_DOCUMENTO_D0M4_L_RECALCULADO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_DOCUMENTO_D0M4_L_RECALCULADO]
GO


CREATE PROCEDURE [dbo].[PG_UP_DOCUMENTO_D0M4_L_RECALCULADO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS
	
	UPDATE	DOCUMENTO_D0M4
	SET		L_RECALCULAR = 0
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4

	-- //////////////////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_TR_DOCUMENTO_D0M4_ESTATUS]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_TR_DOCUMENTO_D0M4_ESTATUS]
GO


CREATE PROCEDURE [dbo].[PG_TR_DOCUMENTO_D0M4_ESTATUS]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4			INT,
	@PP_K_ESTATUS_DOCUMENTO_D0M4	INT
AS
	-- ==============================================
	-- K_ESTATUS_DOCUMENTO_D0M4	
	-- #1 ABIERTO / #2 BORRADOR / #3 PREVIO / #4 CERRADO / #5 AUTORIZADO

	UPDATE	DOCUMENTO_D0M4
	SET		K_ESTATUS_DOCUMENTO_D0M4 = @PP_K_ESTATUS_DOCUMENTO_D0M4
	WHERE	K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
	
	-- ==============================================
	
	EXECUTE [dbo].[PG_UP_DOCUMENTO_D0M4_TRACKING_X_MES_X_K_DOCUMENTO]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
																		@PP_K_DOCUMENTO_D0M4

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_LI_DOCUMENTO_D0M4]
	@PP_L_DEBUG						INT,
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================	
	@PP_D_DOCUMENTO_D0M4	    	VARCHAR(255),	
	@PP_K_ZONA_UO					INT,
	@PP_K_UNIDAD_OPERATIVA			INT,
	@PP_K_YYYY						INT,
	@PP_K_MM						INT,
	@PP_K_FORMATO_D0M4				INT,
	@PP_K_ESTATUS_DOCUMENTO_D0M4 	INT
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

	
	DECLARE @VP_INT_NUMERO_REGISTROS	INT
	
	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_INT_NUMERO_REGISTROS		OUTPUT
	-- =========================================		

	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_D_DOCUMENTO_D0M4, 
													@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================

	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0

	-- =========================================
	
	SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
			DOCUMENTO_D0M4.*,
			UNIDAD_OPERATIVA.K_ZONA_UO, UNIDAD_OPERATIVA.K_RAZON_SOCIAL, 
			
			ZONA_UO.D_ZONA_UO,UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA,
			FORMATO_D0M4.D_FORMATO_D0M4,MES.D_MES,D_ESTATUS_DOCUMENTO_D0M4,
			S_ESTATUS_DOCUMENTO_D0M4,USUARIO.D_USUARIO AS 'D_USUARIO_CAMBIO'
	FROM	DOCUMENTO_D0M4,	ESTATUS_DOCUMENTO_D0M4,
			UNIDAD_OPERATIVA,	MES,	ZONA_UO,	
			USUARIO,	FORMATO_D0M4
	WHERE	DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4=ESTATUS_DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4
	AND		DOCUMENTO_D0M4.K_FORMATO_D0M4=FORMATO_D0M4.K_FORMATO_D0M4
	AND		DOCUMENTO_D0M4.K_USUARIO_CAMBIO=USUARIO.K_USUARIO 
	AND		DOCUMENTO_D0M4.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA 
	AND		DOCUMENTO_D0M4.K_MM=MES.K_MES 
	AND		UNIDAD_OPERATIVA.K_ZONA_UO =ZONA_UO.K_ZONA_UO
	AND		DOCUMENTO_D0M4.L_BORRADO=0
	AND		(	UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA	LIKE '%'+@PP_D_DOCUMENTO_D0M4+'%' 
			OR	K_DOCUMENTO_D0M4=@VP_K_FOLIO	)	
	AND		(   @PP_K_UNIDAD_OPERATIVA	=   -1 	
				OR  DOCUMENTO_D0M4.K_UNIDAD_OPERATIVA	=   @PP_K_UNIDAD_OPERATIVA)
	AND		(   @PP_K_YYYY	=   -1 	OR  DOCUMENTO_D0M4.K_YYYY	=   @PP_K_YYYY)
	AND		(   @PP_K_MM	=   -1 	OR  DOCUMENTO_D0M4.K_MM		=   @PP_K_MM)
	AND		(   @PP_K_ZONA_UO	=	-1	OR  UNIDAD_OPERATIVA.K_ZONA_UO	=   @PP_K_ZONA_UO )
	AND		(	@PP_K_ESTATUS_DOCUMENTO_D0M4	=	-1	
				OR	ESTATUS_DOCUMENTO_D0M4.K_ESTATUS_DOCUMENTO_D0M4	=	@PP_K_ESTATUS_DOCUMENTO_D0M4)
	AND		(	@PP_K_FORMATO_D0M4	=	-1	OR	FORMATO_D0M4.K_FORMATO_D0M4	=	@PP_K_FORMATO_D0M4)
	ORDER BY O_DOCUMENTO_D0M4
			
	-- ////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_SK_DOCUMENTO_D0M4]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_DOCUMENTO_D0M4	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													1, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////

	DECLARE @VP_INT_NUMERO_REGISTROS	INT = 10

	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS = 0

	-- =========================================
	
	SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
			DOCUMENTO_D0M4.K_YYYY AS 'K_TIEMPO_YYYY', 
			DOCUMENTO_D0M4.K_MM AS 'K_MES',
			DOCUMENTO_D0M4.*, 
			UNIDAD_OPERATIVA.K_ZONA_UO, UNIDAD_OPERATIVA.K_RAZON_SOCIAL	
	FROM	DOCUMENTO_D0M4, UNIDAD_OPERATIVA
	WHERE	DOCUMENTO_D0M4.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
	AND		DOCUMENTO_D0M4.L_BORRADO=0
	AND		DOCUMENTO_D0M4.K_DOCUMENTO_D0M4=@PP_K_DOCUMENTO_D0M4
		
	-- ////////////////////////////////////////////////
GO




-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_DOCUMENTO_D0M4_SQL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_DOCUMENTO_D0M4_SQL]
GO


CREATE PROCEDURE [dbo].[PG_IN_DOCUMENTO_D0M4_SQL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT,
	@PP_D_DOCUMENTO_D0M4		VARCHAR(100),
	@PP_C_DOCUMENTO_D0M4		VARCHAR(255),
	@PP_S_DOCUMENTO_D0M4		VARCHAR(10),
	@PP_O_DOCUMENTO_D0M4		INT,
	-- ==============================
	@PP_K_FORMATO_D0M4			INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_YYYY					INT,
	@PP_K_MM					INT
AS

	INSERT INTO DOCUMENTO_D0M4
		(	K_DOCUMENTO_D0M4,			
			D_DOCUMENTO_D0M4,			C_DOCUMENTO_D0M4,
			S_DOCUMENTO_D0M4,			O_DOCUMENTO_D0M4,
			-- ===========================
			K_FORMATO_D0M4,
			K_UNIDAD_OPERATIVA,			K_YYYY,			K_MM,
			K_ESTATUS_DOCUMENTO_D0M4,
			-- ===========================
			[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
	VALUES	
		(	@PP_K_DOCUMENTO_D0M4,
			@PP_D_DOCUMENTO_D0M4,		@PP_C_DOCUMENTO_D0M4,
			@PP_S_DOCUMENTO_D0M4,		@PP_O_DOCUMENTO_D0M4,
			-- ===========================
			@PP_K_FORMATO_D0M4,
			@PP_K_UNIDAD_OPERATIVA,		@PP_K_YYYY,		@PP_K_MM,	
			1,		
			-- ===========================
			@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL )
		
	-- ==============================

	EXECUTE [dbo].[PG_TR_DOCUMENTO_D0M4_ESTATUS]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@PP_K_DOCUMENTO_D0M4, 1		-- K_ESTATUS_DOCUMENTO_D0M4	// #1 ABIERTO

	-- //////////////////////////////////////////////////////////////
GO




	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////P

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_DOCUMENTO_D0M4]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_DOCUMENTO_D0M4]
GO


CREATE PROCEDURE [dbo].[PG_IN_DOCUMENTO_D0M4]
	@PP_L_DEBUG					    INT,
	@PP_K_SISTEMA_EXE			    INT,
	@PP_K_USUARIO_ACCION		    INT,
	-- ===========================	
	@PP_O_DOCUMENTO_D0M4		    INT,
	-- ===========================	
    @PP_K_FORMATO_D0M4              INT,
    @PP_K_UNIDAD_OPERATIVA		    INT,
	@PP_K_YYYY					    INT,
	@PP_K_MM					    INT
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_DOCUMENTO_D0M4	INT = 0
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@VP_K_DOCUMENTO_D0M4, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////


	
	IF @VP_MENSAJE=''	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'DOCUMENTO_D0M4', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_DOCUMENTO_D0M4			OUTPUT
	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DOCUMENTO_D0M4_PRECIO_COSTO_PERFIL] 	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, 
																	@PP_K_USUARIO_ACCION,
																	@PP_K_UNIDAD_OPERATIVA,
																	@PP_K_YYYY,@PP_K_MM, @PP_K_FORMATO_D0M4,
																	@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- //////////////////////////////////////////////////////////////////////
	IF @VP_MENSAJE=''
		BEGIN
		DECLARE	@VP_K_PRECIO_COSTO_PERFIL INT
		IF @PP_K_FORMATO_D0M4<>907
		BEGIN
			SELECT @VP_K_PRECIO_COSTO_PERFIL =	PCP.K_PRECIO_COSTO_PERFIL	
											FROM PRECIO_COSTO_PERFIL PCP
											WHERE PCP.K_MM = @PP_K_MM 
											AND PCP.K_YYYY = @PP_K_YYYY 
											AND PCP.K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA


		END
		ELSE 
		BEGIN
			SET @VP_K_PRECIO_COSTO_PERFIL=0
		END	
		
		
		-- ==========================================

		DECLARE @VP_D_UNIDAD_OPERATIVA 	VARCHAR	(100)

		SELECT 	@VP_D_UNIDAD_OPERATIVA	=	UPPER(UNIDAD_OPERATIVA.D_UNIDAD_OPERATIVA)	
											FROM	UNIDAD_OPERATIVA 
											WHERE	K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA		

		-- =========================================

		DECLARE @VP_D_DOCUMENTO_D0M4 	VARCHAR (100)

		SET		@VP_D_DOCUMENTO_D0M4	= CONCAT(	@VP_D_UNIDAD_OPERATIVA, '#', 
													@VP_K_DOCUMENTO_D0M4, '#', 
													@PP_K_UNIDAD_OPERATIVA, '#', 
													@PP_K_YYYY, '#', @PP_K_MM		)

		-- =========================================

		DECLARE @VP_C_DOCUMENTO_D0M4 	VARCHAR (255)

		SET 	@VP_C_DOCUMENTO_D0M4 	= CONCAT (	'[SYS##', @VP_K_DOCUMENTO_D0M4,'] ',
													@VP_D_UNIDAD_OPERATIVA		)

		-- =========================================

		DECLARE @VP_S_DOCUMENTO_D0M4 	VARCHAR(10)

		SET 	@VP_S_DOCUMENTO_D0M4 	= CONCAT('SYS[D0#',@PP_K_FORMATO_D0M4)

		-- =========================================

		INSERT INTO DOCUMENTO_D0M4
			(	[K_DOCUMENTO_D0M4],[D_DOCUMENTO_D0M4], 
				[C_DOCUMENTO_D0M4],[S_DOCUMENTO_D0M4],
                [O_DOCUMENTO_D0M4],
				-- ===========================
				[K_FORMATO_D0M4], [K_UNIDAD_OPERATIVA],		    
	            [K_YYYY],[K_MM],[K_ESTATUS_DOCUMENTO_D0M4],
				[K_PRECIO_COSTO_PERFIL],[L_RECALCULAR],                
				-- ===========================
				[K_USUARIO_ALTA],[F_ALTA],
				[K_USUARIO_CAMBIO],[F_CAMBIO],
				[L_BORRADO],
				[K_USUARIO_BAJA],[F_BAJA]  )
		VALUES	
			(	@VP_K_DOCUMENTO_D0M4,@VP_D_DOCUMENTO_D0M4,
                @VP_C_DOCUMENTO_D0M4,@VP_S_DOCUMENTO_D0M4,
                @PP_O_DOCUMENTO_D0M4,
				-- ===========================
				@PP_K_FORMATO_D0M4,
				@PP_K_UNIDAD_OPERATIVA,
                @PP_K_YYYY,@PP_K_MM,1,@VP_K_PRECIO_COSTO_PERFIL,
                0,--@PP_L_RECALCULAR, CODEMAJIC
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), 
				@PP_K_USUARIO_ACCION, GETDATE(),
				0, 
				NULL, NULL	)

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [Documento/D0M4]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#DM4.'+CONVERT(VARCHAR(10),@VP_K_DOCUMENTO_D0M4)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		END
	
	SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_DOCUMENTO_D0M4 AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO







-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
