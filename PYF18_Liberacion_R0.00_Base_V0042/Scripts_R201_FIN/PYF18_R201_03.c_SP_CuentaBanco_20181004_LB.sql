-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			FINANZAS / BANCOS
-- // OPERACION:		LIBERACION / STORED PROCEDURE
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LISTADO
-- //////////////////////////////////////////////////////////////


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_CUENTA_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_CUENTA_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_LI_CUENTA_BANCO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================	
	@PP_C_CUENTA_BANCO			VARCHAR(255),
	@PP_K_RAZON_SOCIAL			INT,
	@PP_K_BANCO					INT,
	@PP_K_MONEDA				INT,
	@PP_K_ESTATUS_CUENTA_BANCO	INT,
	@PP_K_TIPO_CUENTA_BANCO		INT,
	@PP_K_ESTADO				INT
AS


	DECLARE @VP_MENSAJE		VARCHAR(300)
	DECLARE @VP_L_APLICAR_MAX_ROWS	INT = 1
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SELECT]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_LI_N_REGISTROS		INT

	EXECUTE [dbo].[PG_SK_CONFIGURACION_LISTADO_MAX_ROWS_PESADO_GET]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
																		@VP_L_APLICAR_MAX_ROWS,		
																		@OU_MAXROWS = @VP_LI_N_REGISTROS		OUTPUT		
	-- =========================================		

	IF @VP_MENSAJE<>''
		SET @VP_LI_N_REGISTROS = 0

	-- =========================================		

	DECLARE @VP_K_FOLIO		INT

	EXECUTE [dbo].[PG_RN_OBTENER_ID_X_REFERENCIA]		@PP_C_CUENTA_BANCO, 
														@OU_K_ELEMENTO = @VP_K_FOLIO	OUTPUT
	-- =========================================
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- =========================================

	SELECT	TOP ( @VP_LI_N_REGISTROS )
			CUENTA_BANCO.*,
			-- =====================
			D_ESTATUS_CUENTA_BANCO, D_BANCO, D_TIPO_CUENTA_BANCO, D_RAZON_SOCIAL, D_MONEDA, D_ESTADO,
			S_ESTATUS_CUENTA_BANCO, S_BANCO, S_TIPO_CUENTA_BANCO, S_RAZON_SOCIAL, S_MONEDA, S_ESTADO,
			-- =====================
			D_USUARIO AS D_USUARIO_CAMBIO
			-- =====================
	FROM	CUENTA_BANCO, 
			ESTATUS_CUENTA_BANCO, BANCO, 
			TIPO_CUENTA_BANCO, RAZON_SOCIAL, MONEDA, ESTADO,
			USUARIO 
			-- =====================
	WHERE	(	CUENTA_BANCO.L_BORRADO=0		OR		@VP_L_VER_BORRADOS=1	)
	AND		CUENTA_BANCO.K_ESTATUS_CUENTA_BANCO=ESTATUS_CUENTA_BANCO.K_ESTATUS_CUENTA_BANCO
	AND		CUENTA_BANCO.K_BANCO=BANCO.K_BANCO
	AND		CUENTA_BANCO.K_USUARIO_CAMBIO=USUARIO.K_USUARIO
	AND		CUENTA_BANCO.K_TIPO_CUENTA_BANCO=TIPO_CUENTA_BANCO.K_TIPO_CUENTA_BANCO
	AND		CUENTA_BANCO.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL
	AND		CUENTA_BANCO.K_MONEDA=MONEDA.K_MONEDA
	AND		CUENTA_BANCO.K_ESTADO=ESTADO.K_ESTADO
			-- =====================
	AND		(	
				D_CUENTA_BANCO					LIKE '%'+@PP_C_CUENTA_BANCO+'%' 
			OR	CUENTA_BANCO.K_CUENTA_BANCO=@VP_K_FOLIO 
			OR	BANCO.D_BANCO					LIKE '%'+@PP_C_CUENTA_BANCO+'%' 
			OR	CUENTA							LIKE '%'+@PP_C_CUENTA_BANCO+'%'  
			OR	CLABE							LIKE '%'+@PP_C_CUENTA_BANCO+'%'
	--		OR	F_APERTURA						LIKE '%'+@PP_C_CUENTA_BANCO+'%'
	--		OR	F_CANCELACION					LIKE '%'+@PP_C_CUENTA_BANCO+'%'
			OR	CUENTA_BANCO.K_TIPO_CUENTA_BANCO LIKE '%'+@PP_C_CUENTA_BANCO+'%'
			)	
			-- =====================
	--AND		CUENTA_BANCO.K_ESTATUS_CUENTA_BANCO=1	
	AND		( @PP_K_ESTATUS_CUENTA_BANCO=-1		OR	CUENTA_BANCO.K_ESTATUS_CUENTA_BANCO=@PP_K_ESTATUS_CUENTA_BANCO )
	AND		( @PP_K_TIPO_CUENTA_BANCO=-1		OR	CUENTA_BANCO.K_TIPO_CUENTA_BANCO=@PP_K_TIPO_CUENTA_BANCO )
	AND		( @PP_K_BANCO=-1					OR	CUENTA_BANCO.K_BANCO=@PP_K_BANCO )
	AND		( @PP_K_RAZON_SOCIAL=-1				OR	CUENTA_BANCO.K_RAZON_SOCIAL=@PP_K_RAZON_SOCIAL )
	AND		( @PP_K_MONEDA=-1					OR	CUENTA_BANCO.K_MONEDA=@PP_K_MONEDA )
	AND		( @PP_K_ESTADO=-1					OR	CUENTA_BANCO.K_ESTADO=@PP_K_ESTADO )

			-- =====================		
--	ORDER BY D_CUENTA_BANCO
	ORDER BY D_CUENTA_BANCO ASC

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SELECT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_LI_CUENTA_BANCO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													0, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_C_CUENTA_BANCO, '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_C_CUENTA_BANCO', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_CUENTA_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_CUENTA_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_SK_CUENTA_BANCO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_CUENTA_BANCO			INT
AS

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''
	
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_DATA_ACCESO_SEEK]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,	
													11, -- @PP_K_DATA_SISTEMA,	
													@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- ///////////////////////////////////////////
	
	DECLARE @VP_L_VER_BORRADOS		[INT]		
	
	EXECUTE [dbo].[PG_RN_DATA_VER_BORRADOS]			@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													@OU_L_VER_BORRADOS = @VP_L_VER_BORRADOS			OUTPUT
	-- ///////////////////////////////////////////

	IF @VP_MENSAJE=''
		BEGIN
	
			SELECT	CUENTA_BANCO.*			
					-- =====================
			FROM	CUENTA_BANCO
					-- =====================
			WHERE	(	CUENTA_BANCO.L_BORRADO=0			
						OR		@VP_L_VER_BORRADOS=1	)		
			AND		CUENTA_BANCO.K_CUENTA_BANCO=@PP_K_CUENTA_BANCO		

		END
	ELSE
		BEGIN	-- RESTO ES PARA QUE GENERA LA ENTREGA DE LOS ENCABEZADOS / SIN REGISTROS

			SELECT	CUENTA_BANCO.*			
			FROM	CUENTA_BANCO
			WHERE	CUENTA_BANCO.L_BORRADO=0
			AND		CUENTA_BANCO.K_CUENTA_BANCO<0

		END

	-----////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													2,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'SEEK',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_SK_CUENTA_BANCO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- ////////////////////////////////////////////////////////////////////
GO

	

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_CUENTA_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_CUENTA_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_IN_CUENTA_BANCO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_D_CUENTA_BANCO			VARCHAR(100),	
	@PP_S_CUENTA_BANCO			VARCHAR(10),
	@PP_C_CUENTA_BANCO			VARCHAR(255),
	@PP_K_RAZON_SOCIAL			INT,			
	@PP_K_BANCO					INT,			
	@PP_K_MONEDA				INT,			
	@PP_NUMERO_PLAZA			VARCHAR (10),	
	@PP_NUMERO_SUCURSAL			VARCHAR (10),	
	@PP_CUENTA					VARCHAR (100), 

	@PP_CLABE					VARCHAR (100),			
	@PP_K_TIPO_CUENTA_BANCO		INT,			
	@PP_F_APERTURA				DATE,		
	@PP_EJECUTIVO				VARCHAR (200), 
	@PP_TELEFONO				VARCHAR(100),	
	@PP_CALLE					VARCHAR(100),	
	@PP_NUMERO_EXTERIOR			VARCHAR(100),	
	@PP_NUMERO_INTERIOR			VARCHAR(100),	
	@PP_COLONIA					VARCHAR(100),	
	@PP_CP						VARCHAR(100),	
	@PP_POBLACION				VARCHAR(100),	
	@PP_MUNICIPIO				VARCHAR(100),
    @PP_APODERADO				VARCHAR(100),
	@PP_K_ESTADO				INT			
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_CUENTA_BANCO				INT = 0
	DECLARE @VP_K_ESTATUS_CUENTA_BANCO		INT = 1
	DECLARE @VP_O_CUENTA_BANCO				INT = 0

	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_BANCO_INSERT]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@VP_K_CUENTA_BANCO, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN
	
		EXECUTE [dbo].[PG_SK_CATALOGO_K_MAX_GET]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE,
													'CUENTA_BANCO', 
													@OU_K_TABLA_DISPONIBLE = @VP_K_CUENTA_BANCO			OUTPUT

		-- //////////////////////////////////////////////////////////////
		
		INSERT INTO CUENTA_BANCO
			(	[K_CUENTA_BANCO],
				[D_CUENTA_BANCO], [S_CUENTA_BANCO], 
				[O_CUENTA_BANCO], [C_CUENTA_BANCO],
				-- ===========================
				[K_RAZON_SOCIAL] ,[K_BANCO],[K_MONEDA],
				[NUMERO_PLAZA],[NUMERO_SUCURSAL],[CUENTA],
				[CLABE],[K_ESTATUS_CUENTA_BANCO],[K_TIPO_CUENTA_BANCO],
				[F_APERTURA],
				-- ===========================
				[EJECUTIVO],[TELEFONO],
				[CALLE],[NUMERO_EXTERIOR],
				[NUMERO_INTERIOR],[COLONIA],[CP],
				[POBLACION],[MUNICIPIO],[APODERADO],[K_ESTADO],
				-- ===========================
				[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_CUENTA_BANCO,
				@PP_D_CUENTA_BANCO, @PP_S_CUENTA_BANCO, 
				@VP_O_CUENTA_BANCO, @PP_C_CUENTA_BANCO,
				-- ===========================
				@PP_K_RAZON_SOCIAL ,@PP_K_BANCO,@PP_K_MONEDA,
				@PP_NUMERO_PLAZA,@PP_NUMERO_SUCURSAL,@PP_CUENTA,
				@PP_CLABE,@VP_K_ESTATUS_CUENTA_BANCO,@PP_K_TIPO_CUENTA_BANCO,
				@PP_F_APERTURA,
				-- ===========================
				@PP_EJECUTIVO,@PP_TELEFONO,
				@PP_CALLE,@PP_NUMERO_EXTERIOR,
				@PP_NUMERO_INTERIOR,@PP_COLONIA,@PP_CP,
				@PP_POBLACION,@PP_MUNICIPIO,@PP_APODERADO,@PP_K_ESTADO,
				-- ===========================
				@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL )
		
		-- //////////////////////////////////////////////////////////////

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Crear] la [Cuenta Bancaria]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Cb.'+CONVERT(VARCHAR(10),@VP_K_CUENTA_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_CUENTA_BANCO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @VP_K_CUENTA_BANCO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'INSERT',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_IN_CUENTA_BANCO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@VP_K_CUENTA_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_CUENTA_BANCO, @PP_CLABE, 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_BANCO', '@PP_CLABE', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> UPDATE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_CUENTA_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_CUENTA_BANCO]
GO

CREATE PROCEDURE [dbo].[PG_UP_CUENTA_BANCO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_CUENTA_BANCO			INT,
	@PP_D_CUENTA_BANCO			VARCHAR(100),	
	@PP_S_CUENTA_BANCO			VARCHAR(10),
	@PP_C_CUENTA_BANCO			VARCHAR(255),
	@PP_K_RAZON_SOCIAL			INT,			
	@PP_K_BANCO					INT,			
	@PP_K_MONEDA				INT,			
	@PP_NUMERO_PLAZA			VARCHAR (10),	
	@PP_NUMERO_SUCURSAL			VARCHAR (10),	
	@PP_CUENTA					VARCHAR (100), 
	@PP_CLABE					VARCHAR (100),			
	@PP_K_TIPO_CUENTA_BANCO		INT,			
	@PP_F_APERTURA				DATE,		
	@PP_EJECUTIVO				VARCHAR (200), 
	@PP_TELEFONO				VARCHAR(100),	
	@PP_CALLE					VARCHAR(100),	
	@PP_NUMERO_EXTERIOR			VARCHAR(100),	
	@PP_NUMERO_INTERIOR			VARCHAR(100),	
	@PP_COLONIA					VARCHAR(100),	
	@PP_CP						VARCHAR(100),	
	@PP_POBLACION				VARCHAR(100),	
	@PP_MUNICIPIO				VARCHAR(100),	
	@PP_APODERADO				VARCHAR(100),
	@PP_K_ESTADO				INT			
AS			

	DECLARE @VP_MENSAJE		VARCHAR(300)
	
	SET		@VP_MENSAJE		= ''

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_BANCO_UPDATE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_CUENTA_BANCO, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		UPDATE	CUENTA_BANCO				
		SET		[D_CUENTA_BANCO]			=	@PP_D_CUENTA_BANCO,		
				[S_CUENTA_BANCO]			=	@PP_S_CUENTA_BANCO,		
				[C_CUENTA_BANCO]			=	@PP_C_CUENTA_BANCO,		
				[K_RAZON_SOCIAL]			=	@PP_K_RAZON_SOCIAL,		
				[K_BANCO]					=	@PP_K_BANCO,				
				[K_MONEDA]					=	@PP_K_MONEDA,			
				[NUMERO_PLAZA]				=	@PP_NUMERO_PLAZA,		
				[NUMERO_SUCURSAL]			=	@PP_NUMERO_SUCURSAL,		
				[CUENTA]					=	@PP_CUENTA,				
				[CLABE]						=	@PP_CLABE,				
				[K_TIPO_CUENTA_BANCO]		=	@PP_K_TIPO_CUENTA_BANCO,	
				[F_APERTURA]				=	@PP_F_APERTURA,		
				[EJECUTIVO]					=	@PP_EJECUTIVO,			
				[TELEFONO]					=	@PP_TELEFONO,			
				[CALLE]						=	@PP_CALLE,				
				[NUMERO_EXTERIOR]			=	@PP_NUMERO_EXTERIOR,		
				[NUMERO_INTERIOR]			=	@PP_NUMERO_INTERIOR,		
				[COLONIA]					=	@PP_COLONIA,				
				[CP]						=	@PP_CP,					
				[POBLACION]					=	@PP_POBLACION,			
				[MUNICIPIO]					=	@PP_MUNICIPIO,	
				[APODERADO]					=	@PP_APODERADO,		
				[K_ESTADO]					=	@PP_K_ESTADO,
				-- ===========================
				[K_USUARIO_CAMBIO]			= @PP_K_USUARIO_ACCION, 
				[F_CAMBIO]					= GETDATE() 
		WHERE	K_CUENTA_BANCO=@PP_K_CUENTA_BANCO
	
		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Actualizar] la [Cuenta Bancaria]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Cb.'+CONVERT(VARCHAR(10),@PP_K_CUENTA_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_BANCO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_BANCO AS CLAVE

	-- //////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													3,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'UPDATE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_UP_CUENTA_BANCO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, @PP_D_CUENTA_BANCO, @PP_CLABE, 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '@PP_D_CUENTA_BANCO', '@PP_CLABE', '', ''

	-- //////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> DELETE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_DL_CUENTA_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_DL_CUENTA_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_DL_CUENTA_BANCO]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ===========================
	@PP_K_CUENTA_BANCO			INT
AS

	DECLARE @VP_MENSAJE			VARCHAR(300)
	
	SET		@VP_MENSAJE		=	''

	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		EXECUTE [dbo].[PG_RN_CUENTA_BANCO_DELETE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_CUENTA_BANCO, 
														@OU_RESULTADO_VALIDACION = @VP_MENSAJE		OUTPUT
	-- //////////////////////////////////////////////
	
	IF @VP_MENSAJE=''
		BEGIN

		--DELETE
		--FROM	CUENTA_BANCO
		--WHERE	CUENTA_BANCO.K_CUENTA_BANCO=@PP_K_CUENTA_BANCO

		UPDATE	CUENTA_BANCO
		SET		
				[L_BORRADO]				= 1,
				-- ====================
				[F_BAJA]				= GETDATE(), 
				[K_USUARIO_BAJA]		= @PP_K_USUARIO_ACCION
		WHERE	K_CUENTA_BANCO=@PP_K_CUENTA_BANCO

		END

	-- /////////////////////////////////////////////////////////////////////
	
	IF @VP_MENSAJE<>''
		BEGIN
		
		SET		@VP_MENSAJE = 'No es posible [Borrar] la [Cuenta Bancaria]: ' + @VP_MENSAJE 
		SET		@VP_MENSAJE = @VP_MENSAJE + ' ( '
		SET		@VP_MENSAJE = @VP_MENSAJE + '[#Cb.'+CONVERT(VARCHAR(10),@PP_K_CUENTA_BANCO)+']'
		SET		@VP_MENSAJE = @VP_MENSAJE + ' )'

		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_BANCO AS CLAVE
		
		END
	ELSE
		SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_CUENTA_BANCO AS CLAVE

	-- /////////////////////////////////////////////////////////////////////

	EXECUTE [dbo].[PG_IN_BITACORA_SYS_OPERACION]	@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
													-- ===========================================
													5,		-- 0 al 6 // @PP_K_IMPORTANCIA_BITACORA_SYS	[INT],	
													'DELETE',
													@VP_MENSAJE,
													-- ===========================================
													'[PG_DL_CUENTA_BANCO]', -- @PP_STORED_PROCEDURE			[VARCHAR] (100),
													@PP_K_CUENTA_BANCO, 0, 		-- @PP_K_FOLIO_1, @PP_K_FOLIO_2,
													-- === [INT], [INT], [VARCHAR](100), [VARCHAR](100), DECIMAL(19,4), DECIMAL(19,4),
													0, 0, '', '' , 0.00, 0.00,
													-- === @PP_VALOR_1 al 6_DATO
													'', '', '', '', '', ''

	-- /////////////////////////////////////////////////////////////////////
GO



-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////

