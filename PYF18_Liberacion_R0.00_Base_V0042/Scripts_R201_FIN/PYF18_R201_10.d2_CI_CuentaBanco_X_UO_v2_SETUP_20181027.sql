-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Planeacion
-- // MODULO:			CUENTA_BANCO_UO
-- // OPERACION:		LIBERACION / TABLA+CARGA 
-- // Autor:			Alex de la Rosa
-- // Fecha creación:	04/09/18
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0] 
GO

-- //////////////////////////////////////////////////////////////
-- SELECT * FROM [CUENTA_BANCO_UO]


/*


SELECT	S_ZONA_UO, D_UNIDAD_OPERATIVA, D_CUENTA_BANCO, S_TIPO_CUENTA_BANCO, 
		S_CUENTA_BANCO, 
		[CUENTA_BANCO_UO].* 
FROM	[CUENTA_BANCO_UO], [CUENTA_BANCO], [TIPO_CUENTA_BANCO], 
		UNIDAD_OPERATIVA, ZONA_UO
WHERE	CUENTA_BANCO_UO.K_CUENTA_BANCO=CUENTA_BANCO.K_CUENTA_BANCO 
AND		CUENTA_BANCO_UO.K_TIPO_CUENTA_BANCO=TIPO_CUENTA_BANCO.K_TIPO_CUENTA_BANCO 
AND		CUENTA_BANCO_UO.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
AND		UNIDAD_OPERATIVA.K_ZONA_UO=ZONA_UO.K_ZONA_UO

ORDER BY K_TIPO_CUENTA_BANCO, S_ZONA_UO, D_UNIDAD_OPERATIVA

*/


-- //////////////////////////////////////////////////////////////


UPDATE	[dbo].[CUENTA_BANCO_UO]
SET		[K_CUENTA_BANCO] = 0,
		[L_PRINCIPAL] = 0
GO


-- //////////////////////////////////////////////////////////////

UPDATE	[dbo].[CUENTA_BANCO_UO] 
SET		[K_CUENTA_BANCO]		=	(
										SELECT	MIN([K_CUENTA_BANCO])
										FROM	[CUENTA_BANCO], [RAZON_SOCIAL], [UNIDAD_OPERATIVA]
										WHERE	CUENTA_BANCO.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL
										AND		RAZON_SOCIAL.K_RAZON_SOCIAL=UNIDAD_OPERATIVA.K_RAZON_SOCIAL
										AND		CUENTA_BANCO.K_ESTATUS_CUENTA_BANCO=1	-- 1	ACTIVA
										AND		CUO.K_TIPO_CUENTA_BANCO=CUENTA_BANCO.K_TIPO_CUENTA_BANCO
										AND		CUO.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
									)
/*		[D_CUENTA_BANCO_UO]		=	(
										SELECT	MIN([K_CUENTA_BANCO])
										FROM	[CUENTA_BANCO], [RAZON_SOCIAL], [UNIDAD_OPERATIVA]
										WHERE	CUENTA_BANCO.K_RAZON_SOCIAL=RAZON_SOCIAL.K_RAZON_SOCIAL
										AND		RAZON_SOCIAL.K_RAZON_SOCIAL=UNIDAD_OPERATIVA.K_RAZON_SOCIAL
										AND		CUO.K_TIPO_CUENTA_BANCO=CUENTA_BANCO.K_TIPO_CUENTA_BANCO
										AND		CUO.K_UNIDAD_OPERATIVA=UNIDAD_OPERATIVA.K_UNIDAD_OPERATIVA
									),	*/
FROM	[dbo].[CUENTA_BANCO_UO] AS CUO
GO

-- //////////////////////////////////////////////////////////////

UPDATE	[dbo].[CUENTA_BANCO_UO]
SET		[L_PRINCIPAL] = 1
WHERE	[K_CUENTA_BANCO]<>0
GO


UPDATE	[dbo].[CUENTA_BANCO_UO] 
SET		[K_CUENTA_BANCO] = 0	 
WHERE	[K_CUENTA_BANCO] IS NULL
GO


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////

-- SELECT * FROM [CUENTA_BANCO_UO]


-- ===============================================
SET NOCOUNT ON
-- ===============================================

-- ===============================================
SET NOCOUNT OFF
-- ===============================================



-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////
