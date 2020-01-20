-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			MOVIMIENTOS BANCO
-- // OPERACION:		CARGA INICIAL / QA
-- //////////////////////////////////////////////////////////////
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	18/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////
-- SELECT *  FROM MOVIMIENTO_BANCO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_MOVIMIENTO_BANCO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_MOVIMIENTO_BANCO]
GO


CREATE PROCEDURE [dbo].[PG_CI_MOVIMIENTO_BANCO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- =============================== CONTROL
	@PP_K_MOVIMIENTO_BANCO				INT,
	@PP_K_TIPO_MOVIMIENTO_BANCO			INT,
	@PP_K_ESTATUS_MOVIMIENTO_BANCO		INT,
	@PP_K_FORMA_MOVIMIENTO_BANCO		INT,
	@PP_L_CAPTURA_MANUAL				INT,
	@PP_CIE_CLIENTE						VARCHAR(100),
	-- =============================== CONCILIACION
/*	[K_UNIDAD_OPERATIVA]				INT NOT NULL	DEFAULT 0,
	[K_ESTATUS_CONCILIACION]			INT NOT NULL	DEFAULT 0,
	[K_TIPO_LIBRO_INGRESOS]				INT NOT NULL	DEFAULT 0,
	[K_USUARIO_CONCILIO]				INT NULL,
	[F_CONCILIACION]					DATETIME NULL,	*/
	-- =============================== SEGUN PDF
	@PP_K_CUENTA_BANCO					INT,
	@PP_F_MOVIMIENTO_BANCO						DATE,	
	@PP_F_LIQ							DATE,	
	@PP_COD_DESCRIPCION					VARCHAR(500),
	@PP_REFERENCIA						VARCHAR(500),
	@PP_MONTO_MOVIMIENTO				DECIMAL(19,4),
	@PP_SALDO							DECIMAL(19,4) 
AS

	INSERT INTO MOVIMIENTO_BANCO
		(	K_MOVIMIENTO_BANCO,
			K_TIPO_MOVIMIENTO_BANCO, K_ESTATUS_MOVIMIENTO_BANCO, K_FORMA_MOVIMIENTO_BANCO,
			L_CAPTURA_MANUAL,
			CIE_CLIENTE,
			-- =============================== 
			K_CUENTA_BANCO, F_MOVIMIENTO_BANCO,	
			F_LIQ, COD_DESCRIPCION,
			REFERENCIA,
			MONTO_MOVIMIENTO, SALDO,
			-- =============================== 
			[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )	
	VALUES	
		(	@PP_K_MOVIMIENTO_BANCO,
			@PP_K_TIPO_MOVIMIENTO_BANCO, @PP_K_ESTATUS_MOVIMIENTO_BANCO, @PP_K_FORMA_MOVIMIENTO_BANCO,
			@PP_L_CAPTURA_MANUAL,
			@PP_CIE_CLIENTE,
			-- =============================== 
			@PP_K_CUENTA_BANCO, @PP_F_MOVIMIENTO_BANCO,	
			@PP_F_LIQ, @PP_COD_DESCRIPCION,
			@PP_REFERENCIA,
			@PP_MONTO_MOVIMIENTO, @PP_SALDO,
			-- =============================== 
			@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL )

	-- =======================================
	
	UPDATE	MOVIMIENTO_BANCO
	SET		F_OPERACION = DATEADD(dd,-1,F_MOVIMIENTO_BANCO)
	WHERE	K_MOVIMIENTO_BANCO=@PP_K_MOVIMIENTO_BANCO


	-- ==============================================
GO




DELETE 
FROM	[MOVIMIENTO_BANCO]

-- //////////////////////////////////////////////////////////////

-- ===============================================
SET NOCOUNT ON

-- ===============================================

-- =======================================
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 1, 102, 1, 1, 0, '020016', 38, '30/sep/2018', '01/oct/2018', 'COD', 'DEPO102141', 131628, 102141
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 2, 102, 1, 2, 0, '020024', 47, '30/sep/2018', '01/oct/2018', '', 'CHE102151', 164457, 102151
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 3, 102, 1, 3, 0, '020032', 38, '30/sep/2018', '01/oct/2018', '', 'REF102143', 159066, 102143
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 4, 201, 1, 3, 1, '020040', 47, '30/sep/2018', '01/oct/2018', '', 'DEPO201252', 17825, 201252
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 5, 102, 1, 3, 0, '020057', 47, '30/sep/2018', '01/oct/2018', '', 'CHE102154', 187730, 102154
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 6, 102, 1, 3, 0, '020065', 38, '30/sep/2018', '01/oct/2018', '', 'REF102146', 106000, 102146
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 7, 102, 1, 3, 0, '020073', 47, '30/sep/2018', '01/oct/2018', '', 'DEPO102156', 162985, 102156
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 8, 201, 1, 3, 1, '020099', 38, '30/sep/2018', '01/oct/2018', '', 'CHE201247', 10724, 201247
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 9, 102, 1, 3, 0, '020016', 47, '01/oct/2018', '02/oct/2018', '', 'REF102158', 132783, 102158
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 10, 102, 1, 3, 0, '020024', 47, '01/oct/2018', '02/oct/2018', '', 'DEPO102159', 192064, 102159
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 11, 102, 1, 3, 0, '020032', 38, '01/oct/2018', '02/oct/2018', '', 'CHE102151', 149654, 102151
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 12, 201, 1, 3, 1, '020040', 47, '01/oct/2018', '02/oct/2018', '', 'REF201260', 10600, 201260
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 13, 102, 1, 3, 0, '020057', 38, '01/oct/2018', '02/oct/2018', '', 'DEPO102153', 102366, 102153
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 14, 102, 1, 3, 0, '020065', 47, '01/oct/2018', '02/oct/2018', '', 'CHE102163', 136333, 102163
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 15, 102, 1, 3, 0, '020073', 47, '01/oct/2018', '02/oct/2018', '', 'REF102164', 131675, 102164
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 16, 201, 1, 3, 1, '020099', 38, '01/oct/2018', '02/oct/2018', '', 'DEPO201255', 10720, 201255
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 17, 102, 1, 3, 0, '020016', 47, '01/oct/2018', '02/oct/2018', '', 'CHE102166', 107694, 102166
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 18, 102, 1, 3, 0, '020024', 38, '01/oct/2018', '02/oct/2018', '', 'REF102158', 119376, 102158
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 19, 102, 1, 3, 0, '020032', 47, '01/oct/2018', '02/oct/2018', '', 'DEPO102168', 192575, 102168
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 20, 201, 1, 3, 1, '020040', 47, '01/oct/2018', '02/oct/2018', '', 'CHE201268', 17544, 201268
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 21, 102, 1, 3, 0, '020057', 38, '01/oct/2018', '02/oct/2018', '', 'REF102161', 148127, 102161
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 22, 102, 1, 3, 0, '020065', 47, '02/oct/2018', '03/oct/2018', '', 'DEPO102171', 171741, 102171
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 23, 102, 1, 3, 0, '020073', 38, '02/oct/2018', '03/oct/2018', '', 'CHE102163', 138045, 102163
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 24, 201, 1, 3, 1, '020099', 47, '02/oct/2018', '03/oct/2018', '', 'REF201272', 18475, 201272
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 25, 102, 1, 3, 0, '020016', 47, '02/oct/2018', '03/oct/2018', '', 'DEPO102174', 169216, 102174
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 26, 102, 1, 3, 0, '020024', 38, '02/oct/2018', '03/oct/2018', '', 'CHE102166', 146366, 102166
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 27, 102, 1, 3, 0, '020032', 47, '02/oct/2018', '03/oct/2018', '', 'REF102176', 159682, 102176
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 28, 201, 1, 3, 1, '020040', 38, '02/oct/2018', '03/oct/2018', '', 'DEPO201267', 12588, 201267
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 29, 102, 1, 3, 0, '020057', 47, '02/oct/2018', '03/oct/2018', '', 'CHE102178', 177412, 102178
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 30, 102, 1, 3, 0, '020065', 47, '03/oct/2018', '04/oct/2018', '', 'REF102179', 101824, 102179
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 31, 102, 1, 3, 0, '020073', 38, '03/oct/2018', '04/oct/2018', '', 'DEPO102171', 128337, 102171
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 32, 201, 1, 3, 1, '020099', 47, '03/oct/2018', '04/oct/2018', '', 'CHE201280', 14421, 201280
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 33, 102, 1, 3, 0, '020016', 38, '03/oct/2018', '04/oct/2018', '', 'REF102173', 169855, 102173
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 34, 102, 1, 3, 0, '020024', 47, '03/oct/2018', '04/oct/2018', '', 'DEPO102183', 128106, 102183
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 35, 102, 1, 3, 0, '020032', 47, '03/oct/2018', '04/oct/2018', '', 'CHE102184', 151689, 102184
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 36, 201, 1, 3, 1, '020040', 38, '04/oct/2018', '05/oct/2018', '', 'REF201275', 11898, 201275
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 37, 102, 1, 3, 0, '020057', 47, '04/oct/2018', '05/oct/2018', '', 'DEPO102186', 154320, 102186
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 38, 102, 1, 3, 0, '020065', 38, '04/oct/2018', '05/oct/2018', '', 'CHE102178', 113023, 102178
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 39, 102, 1, 3, 0, '020073', 47, '04/oct/2018', '05/oct/2018', '', 'REF102188', 169616, 102188
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 40, 201, 1, 3, 1, '020099', 47, '04/oct/2018', '05/oct/2018', '', 'DEPO201288', 15295, 201288
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 41, 102, 1, 3, 0, '020016', 38, '04/oct/2018', '05/oct/2018', '', 'CHE102181', 190290, 102181
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 42, 102, 1, 3, 0, '020024', 47, '04/oct/2018', '05/oct/2018', '', 'REF102191', 198316, 102191
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 43, 102, 1, 3, 0, '020032', 38, '04/oct/2018', '05/oct/2018', '', 'DEPO102183', 167753, 102183
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 44, 201, 1, 3, 1, '020040', 47, '05/oct/2018', '06/oct/2018', '', 'CHE201292', 14316, 201292
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 45, 102, 1, 3, 0, '020057', 47, '05/oct/2018', '06/oct/2018', '', 'REF102194', 121706, 102194
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 46, 102, 1, 3, 0, '020065', 38, '05/oct/2018', '06/oct/2018', '', 'DEPO102186', 144829, 102186
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 47, 102, 1, 3, 0, '020073', 47, '05/oct/2018', '06/oct/2018', '', 'CHE102196', 192563, 102196
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 48, 201, 1, 3, 1, '020099', 38, '05/oct/2018', '06/oct/2018', '', 'REF201287', 19024, 201287
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 49, 102, 1, 3, 0, '020016', 47, '06/oct/2018', '07/oct/2018', '', 'DEPO102198', 128978, 102198
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 50, 102, 1, 3, 0, '020024', 47, '06/oct/2018', '07/oct/2018', '', 'CHE102199', 144340, 102199
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 51, 102, 1, 3, 0, '020032', 38, '06/oct/2018', '07/oct/2018', '', 'REF102191', 187126, 102191
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 52, 201, 1, 3, 1, '020040', 47, '06/oct/2018', '07/oct/2018', '', 'DEPO201300', 12705, 201300
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 53, 102, 1, 3, 0, '020057', 38, '06/oct/2018', '07/oct/2018', '', 'CHE102193', 167338, 102193
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 54, 102, 1, 3, 0, '020065', 47, '06/oct/2018', '07/oct/2018', '', 'REF102203', 186282, 102203
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 55, 102, 1, 3, 0, '020073', 47, '06/oct/2018', '07/oct/2018', '', 'DEPO102204', 135045, 102204
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 56, 201, 1, 3, 1, '020099', 38, '06/oct/2018', '07/oct/2018', '', 'CHE201295', 12818, 201295
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 57, 102, 1, 3, 0, '020016', 47, '07/oct/2018', '08/oct/2018', '', 'REF102206', 132607, 102206
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 58, 102, 1, 3, 0, '020024', 38, '07/oct/2018', '08/oct/2018', '', 'DEPO102198', 101034, 102198
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 59, 102, 1, 3, 0, '020032', 47, '07/oct/2018', '08/oct/2018', '', 'CHE102208', 143955, 102208
EXECUTE [dbo].[PG_CI_MOVIMIENTO_BANCO] 0, 0, 0, 60, 201, 1, 3, 1, '020040', 47, '07/oct/2018', '08/oct/2018', '', 'REF201308', 18349, 201308

-- ===============================================
SET NOCOUNT OFF
-- ===============================================





-- //////////////////////////////////////////////////////////////





-- *****************************************************************************	
-- *****************************************************************************	
-- *****************************************************************************	
-- *****************************************************************************	
