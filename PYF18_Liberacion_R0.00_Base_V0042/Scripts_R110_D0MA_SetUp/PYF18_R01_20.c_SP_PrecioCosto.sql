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
--											PRECIO_COSTO_PERFIL			
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PRECIO_COSTO_PERFIL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PRECIO_COSTO_PERFIL]
GO

CREATE PROCEDURE [dbo].[PG_LI_PRECIO_COSTO_PERFIL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_D_PRECIO_COSTO_PERFIL	VARCHAR(255),
	@PP_K_ZONA_UO				INT,
	@PP_K_UNIDAD_OPERATIVA		INT,
	@PP_K_YYYY					INT,
	@PP_K_MM					INT
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

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]	@PP_D_PRECIO_COSTO_PERFIL, 
													@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================

	IF @VP_MENSAJE<>''
		SET @VP_INT_NUMERO_REGISTROS=0			
	
	SELECT	TOP (@VP_INT_NUMERO_REGISTROS)
			PRECIO_COSTO_PERFIL.*,
			VI_UNIDAD_OPERATIVA_CATALOGOS.*,
			MES.D_MES,
			D_ESTATUS_ACTIVO, S_ESTATUS_ACTIVO,
			USUARIO.D_USUARIO AS 'D_USUARIO_CAMBIO'
	FROM	PRECIO_COSTO_PERFIL,ESTATUS_ACTIVO,VI_UNIDAD_OPERATIVA_CATALOGOS,MES,USUARIO
	WHERE	PRECIO_COSTO_PERFIL.L_PRECIO_COSTO_PERFIL=ESTATUS_ACTIVO.K_ESTATUS_ACTIVO
	AND		PRECIO_COSTO_PERFIL.K_USUARIO_CAMBIO=USUARIO.K_USUARIO 
	AND		PRECIO_COSTO_PERFIL.K_UNIDAD_OPERATIVA=VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_UNIDAD_OPERATIVA 
	AND		PRECIO_COSTO_PERFIL.K_MM=MES.K_MES
	AND		PRECIO_COSTO_PERFIL.L_BORRADO=0
	AND		(	VI_UNIDAD_OPERATIVA_CATALOGOS.D_UNIDAD_OPERATIVA	LIKE '%'+@PP_D_PRECIO_COSTO_PERFIL+'%' 
				OR	K_PRECIO_COSTO_PERFIL=@VP_K_FOLIO	)	
	AND		(	@PP_K_UNIDAD_OPERATIVA=-1 
				OR  PRECIO_COSTO_PERFIL.K_UNIDAD_OPERATIVA = @PP_K_UNIDAD_OPERATIVA)
	AND		(	@PP_K_YYYY=-1 OR  PRECIO_COSTO_PERFIL.K_YYYY = @PP_K_YYYY)
	AND		(	@PP_K_MM=-1 OR  PRECIO_COSTO_PERFIL.K_MM = @PP_K_MM)
	AND		(	@PP_K_ZONA_UO=-1 OR VI_UNIDAD_OPERATIVA_CATALOGOS.VI_K_ZONA_UO= @PP_K_ZONA_UO )
	ORDER BY O_PRECIO_COSTO_PERFIL


	-- ////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_PRECIO_COSTO_PERFIL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_PRECIO_COSTO_PERFIL]
GO


CREATE PROCEDURE [dbo].[PG_SK_PRECIO_COSTO_PERFIL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_PRECIO_COSTO_PERFIL	INT
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
	
		SELECT	PRECIO_COSTO_PERFIL.*, PRECIO_COSTO_PERFIL.K_YYYY AS 'K_TIEMPO_YYYY', 
				PRECIO_COSTO_PERFIL.K_MM AS 'K_MES'
		FROM	PRECIO_COSTO_PERFIL
		WHERE	L_BORRADO=0
		AND		PRECIO_COSTO_PERFIL.K_PRECIO_COSTO_PERFIL=@PP_K_PRECIO_COSTO_PERFIL
		
		END
	--ELSE
		--BEGIN	-- RESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

		--SELECT	PRECIO_COSTO_PERFIL.*
		--FROM	PRECIO_COSTO_PERFIL
		--WHERE	PRECIO_COSTO_PERFIL.K_PRECIO_COSTO_PERFIL<0

		--END

	-- ////////////////////////////////////////////////
GO


	
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT
-- //////////////////////////////////////////////////////////////P

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PRECIO_COSTO_PERFIL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PRECIO_COSTO_PERFIL]
GO


CREATE PROCEDURE [dbo].[PG_IN_PRECIO_COSTO_PERFIL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_O_PRECIO_COSTO_PERFIL	INT,
	@PP_L_PRECIO_COSTO_PERFIL	INT,
	-- ===========================
	@PP_K_UNIDAD_OPERTIVA		INT,
	@PP_K_YYYY					INT,
	@PP_K_MM					INT,
	-- ===========================	
	@PP_PV_PRECIO_VENTA			DECIMAL(19,4),
	
	@PP_MC						DECIMAL(19,4),
	@PP_FLETE					DECIMAL(19,4),
	@PP_CA						DECIMAL(19,4),
	@PP_APG						DECIMAL(19,4),
	@PP_MP_INB					DECIMAL(19,4),
	@PP_FG						DECIMAL(19,4),
	@PP_SMD						DECIMAL(19,4),
	@PP_SMP						DECIMAL(19,4),
	@PP_SMRU					DECIMAL(19,4),
	@PP_SMPT					DECIMAL(19,4),

	@PP_ASPTA					DECIMAL(19,4),
	@PP_OG						DECIMAL(19,4),
	@PP_COOP					DECIMAL(19,4),
	@PP_SMCNP					DECIMAL(19,4),
	@PP_SMRI					DECIMAL(19,4),
	@PP_PQ_D					DECIMAL(19,4),
	@PP_P_IND					DECIMAL(19,4),
	@PP_APG2					DECIMAL(19,4)
	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_PRECIO_COSTO_PERFIL	INT = 0
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PRECIO_COSTO_PERFIL_INSERT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@VP_K_PRECIO_COSTO_PERFIL, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE			OUTPUT

	-- /////////////////////////////////////////////////////////////////////


	
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'PRECIO_COSTO_PERFIL', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_PRECIO_COSTO_PERFIL		OUTPUT

		-- //////////////////////////////////////////////////////////////
		

		INSERT INTO PRECIO_COSTO_PERFIL
			(	[K_PRECIO_COSTO_PERFIL],[O_PRECIO_COSTO_PERFIL],
				[L_PRECIO_COSTO_PERFIL],[K_UNIDAD_OPERATIVA],
				[K_YYYY],[K_MM],
				-- ===========================
				[PV_PRECIO_VENTA],
				[MC],[FLETE],[CA],[APG],
				[MP_INB],[FG],[SMD],[SMP],
				[SMRU],	[SMPT],
				-- ===========================
				[ASPTA],[OG],
				[COOP],[SMCNP],[SMRI],[PQ_D],
				[P_IND],[APG2],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_PRECIO_COSTO_PERFIL, @PP_O_PRECIO_COSTO_PERFIL,	
				@PP_L_PRECIO_COSTO_PERFIL, @PP_K_UNIDAD_OPERTIVA,
				@PP_K_YYYY,@PP_K_MM ,
				-- ===========================
				@PP_PV_PRECIO_VENTA,				
				@PP_MC,	@PP_FLETE,@PP_CA,@PP_APG,
				@PP_MP_INB,	@PP_FG,	@PP_SMD,@PP_SMP,
				@PP_SMRU,@PP_SMPT,
				-- ===========================
				@PP_ASPTA,@PP_OG,		
				@PP_COOP,@PP_SMCNP,@PP_SMRI,@PP_PQ_D,	
				@PP_P_IND,@PP_APG2,	
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )

		UPDATE	PRECIO_COSTO_PERFIL
		SET		[PC_PRECIO_COMPRA] = (		[PV_PRECIO_VENTA]
										-	[MC]	- [FLETE]	- [CA] 
										-	[APG]	- [MP_INB]	- [FG] 
										-	[SMD]	- [SMP]		- [SMRU]	- [SMPT]	
										-	[ASPTA]	- [OG]		- [COOP]	- [SMCNP]
										-	[SMRI]	- [PQ_D]	- [P_IND]	- [APG2]	 )

		WHERE	K_PRECIO_COSTO_PERFIL=@VP_K_PRECIO_COSTO_PERFIL
		
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] el [PRECIO_COSTO_PERFIL]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@VP_K_PRECIO_COSTO_PERFIL)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PRECIO_COSTO_PERFIL AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_PRECIO_COSTO_PERFIL AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> ACTUALIZAR / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PRECIO_COSTO_PERFIL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PRECIO_COSTO_PERFIL]
GO

CREATE PROCEDURE [dbo].[PG_UP_PRECIO_COSTO_PERFIL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_PRECIO_COSTO_PERFIL	INT,
	@PP_O_PRECIO_COSTO_PERFIL	INT,
	@PP_L_PRECIO_COSTO_PERFIL	INT,
	-- ===========================
	@PP_K_UNIDAD_OPERTIVA		INT,
	@PP_K_YYYY					INT,
	@PP_K_MM					INT,
	-- ===========================		
	@PP_PV_PRECIO_VENTA			DECIMAL(19,4),
	@PP_MC						DECIMAL(19,4),
	@PP_FLETE					DECIMAL(19,4),
	@PP_CA						DECIMAL(19,4),
	@PP_APG						DECIMAL(19,4),
	@PP_MP_INB					DECIMAL(19,4),
	@PP_FG						DECIMAL(19,4),
	@PP_SMD						DECIMAL(19,4),
	@PP_SMP						DECIMAL(19,4),
	@PP_SMRU					DECIMAL(19,4),
	@PP_SMPT					DECIMAL(19,4),
	-- ===========================
	@PP_ASPTA					DECIMAL(19,4),
	@PP_OG						DECIMAL(19,4),
	@PP_COOP					DECIMAL(19,4),
	@PP_SMCNP					DECIMAL(19,4),
	@PP_SMRI					DECIMAL(19,4),
	@PP_PQ_D					DECIMAL(19,4),
	@PP_P_IND					DECIMAL(19,4),
	@PP_APG2					DECIMAL(19,4)
	
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
		
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PRECIO_COSTO_PERFIL_UPDATE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PRECIO_COSTO_PERFIL, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	PRECIO_COSTO_PERFIL
		SET		
								 
				[O_PRECIO_COSTO_PERFIL] =	@PP_O_PRECIO_COSTO_PERFIL, 
				[L_PRECIO_COSTO_PERFIL] =	@PP_L_PRECIO_COSTO_PERFIL,
				-- ===========================
				[K_UNIDAD_OPERATIVA]	=	@PP_K_UNIDAD_OPERTIVA,
				[K_YYYY]				=	@PP_K_YYYY,
				[K_MM]					=	@PP_K_MM,
				-- ===========================
				[PV_PRECIO_VENTA]		=	@PP_PV_PRECIO_VENTA,
				-- ===========================
				[MC]					=	@PP_MC,
				[FLETE]					=	@PP_FLETE,
				[CA]					=	@PP_CA,
				[APG]					=	@PP_APG,
				[MP_INB]				=	@PP_MP_INB,
				[FG]					=	@PP_FG,
				[SMD]					=	@PP_SMD,
				[SMP]					=	@PP_SMP,
				[SMRU]					=	@PP_SMRU,
				[SMPT]					=	@PP_SMPT,
				-- ============================
				[ASPTA]					=	@PP_ASPTA,	
				[OG]					=	@PP_OG,
				[COOP]					=	@PP_COOP,	
				[SMCNP]					=	@PP_SMCNP,	
				[SMRI]					=	@PP_SMRI,	
				[PQ_D]					=	@PP_PQ_D,	
				[P_IND]					=	@PP_P_IND,	
				[APG2]					=	@PP_APG2,	
				-- ============================
				[F_CAMBIO]				=	GETDATE(), 
				[K_USUARIO_CAMBIO]		=	@PP_K_USUARIO_ACCION
		WHERE	K_PRECIO_COSTO_PERFIL	=	@PP_K_PRECIO_COSTO_PERFIL

		
		UPDATE	PRECIO_COSTO_PERFIL
		SET		[PC_PRECIO_COMPRA] = (		[PV_PRECIO_VENTA]
										-	[MC]	- [FLETE]	- [CA] 
										-	[APG]	- [MP_INB]	- [FG] 
										-	[SMD]	- [SMP]		- [SMRU]	- [SMPT]	
										-	[ASPTA]	- [OG]		- [COOP]	- [SMCNP]
										-	[SMRI]	- [PQ_D]	- [P_IND]	- [APG2]	 )

		WHERE	K_PRECIO_COSTO_PERFIL=@PP_K_PRECIO_COSTO_PERFIL
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] el [PRECIO_COSTO_PERFIL]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@PP_K_PRECIO_COSTO_PERFIL)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRECIO_COSTO_PERFIL AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRECIO_COSTO_PERFIL AS CLAVE

	-- //////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_PRECIO_COSTO_PERFIL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_PRECIO_COSTO_PERFIL]
GO


CREATE PROCEDURE [dbo].[PG_DL_PRECIO_COSTO_PERFIL]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_PRECIO_COSTO_PERFIL	INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	--/////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_PRECIO_COSTO_PERFIL_DELETE]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PRECIO_COSTO_PERFIL, 
															@OU_RESULTADO_VALIDACION = @VP_MENSAJE	OUTPUT

	--////////////////////////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
		
	--	DELETE
	--	FROM	PRECIO_COSTO_PERFIL
	--	WHERE	PRECIO_COSTO_PERFIL.K_PRECIO_COSTO_PERFIL=@PP_K_PRECIO_COSTO_PERFIL

		UPDATE	PRECIO_COSTO_PERFIL
		SET		
				[L_BORRADO]		 =	1,
				-- ====================
				[F_BAJA]		 =	GETDATE(), 
				[K_USUARIO_BAJA] =	@PP_K_USUARIO_ACCION
		WHERE	K_PRECIO_COSTO_PERFIL=@PP_K_PRECIO_COSTO_PERFIL
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la [PRECIO_COSTO_PERFIL]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Em.'+CONVERT(VARCHAR(10),@PP_K_PRECIO_COSTO_PERFIL)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRECIO_COSTO_PERFIL AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_PRECIO_COSTO_PERFIL AS CLAVE

	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
