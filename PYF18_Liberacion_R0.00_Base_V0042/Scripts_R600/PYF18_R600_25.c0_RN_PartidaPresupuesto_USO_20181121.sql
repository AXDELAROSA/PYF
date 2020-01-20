-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			TRASPASO
-- // OPERACION:		LIBERACION / REGLAS NEGOCIO
-- //////////////////////////////////////////////////////////////
-- // Autor:			DANIEL PORTILLO	ROMERO
-- // Fecha creación:	18/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO


-- //////////////////////////////////////////////////////////////

-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_PRESUPUESTO DISPONIBLE
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_DISPONIBLE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_DISPONIBLE]
GO

/*
		DECLARE	@VP_RESULTADO_VALIDACION		[VARCHAR] (200)
		EXECUTE	[dbo].[PG_RN_PRESUPUESTO_DISPONIBLE]	0,0,0,0,1,70,31804103,15,2018,1,30100,@OU_RESULTADO_VALIDACION=@VP_RESULTADO_VALIDACION		OUTPUT
		SELECT @VP_RESULTADO_VALIDACION AS LOLA
*/
CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_DISPONIBLE]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_PRESUPUESTO				[INT],
	@PP_K_RUBRO_PRESUPUESTO			[INT],
	@PP_K_TRASPASO					[INT],
	@PP_K_UNIDAD_OPERATIVA			[INT],	
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	@PP_MONTO_APLICAR				[DECIMAL](19,4),
	-- ===========================		
	@OU_RESULTADO_VALIDACION		[VARCHAR] (200)		OUTPUT
AS

	DECLARE @VP_RESULTADO	VARCHAR(300)	= ''
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_MES_MONTO_ESTIMADO  DECIMAL(19,4)

	SELECT @VP_MES_MONTO_ESTIMADO =	MES_MONTO_ESTIMADO
									FROM	PARTIDA_PRESUPUESTO
									WHERE	K_PRESUPUESTO=@PP_K_PRESUPUESTO
									AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO

	IF @PP_L_DEBUG>0
		PRINT 'MONTO ESTIMADO: ' + CONVERT(VARCHAR(10),@VP_MES_MONTO_ESTIMADO) 

	-- /////////////////////////////////////////////////////

	DECLARE @VP_MES_MONTO_EN_PROCESO  DECIMAL(19,4)

	SELECT @VP_MES_MONTO_EN_PROCESO =	SUM(MONTO_APLICAR) 
										FROM	TRASPASO
										WHERE	K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
										AND		MONTH(F_OPERACION)=@PP_K_MM
										AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
										AND		YEAR(F_OPERACION)=@PP_K_YYYY
										--		K_ESTATUS_TRASPASO	1	BASE	2	PROGRAMADO	
										--		3	AUTORIZADO	4	EJECUTADO	5	CONCILIADO	
										--		6	CANCELADO
										AND		(	K_ESTATUS_TRASPASO=1
												OR	K_ESTATUS_TRASPASO=2
												OR	K_ESTATUS_TRASPASO=3	)
										AND		L_BORRADO=0
										AND		K_TRASPASO<>@PP_K_TRASPASO
	-- ===================================================
	IF @VP_MES_MONTO_EN_PROCESO IS NULL
		SET @VP_MES_MONTO_EN_PROCESO=0
												
	IF @PP_L_DEBUG>0		
		PRINT 'MONTO EN PROCESO: ' + CONVERT(VARCHAR(10),@VP_MES_MONTO_EN_PROCESO)  		

	-- /////////////////////////////////////////////////////

	DECLARE @VP_MES_MONTO_EJERCIDO  DECIMAL(19,4)

	SELECT @VP_MES_MONTO_EJERCIDO =	SUM(MONTO_APLICAR) 
									FROM	TRASPASO
									WHERE	K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
									AND		MONTH(F_OPERACION)=@PP_K_MM
									AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
									AND		YEAR(F_OPERACION)=@PP_K_YYYY
									--		K_ESTATUS_TRASPASO	1	BASE	2	PROGRAMADO	
									--		3	AUTORIZADO	4	EJECUTADO	5	CONCILIADO	
									--		6	CANCELADO
									AND		(	K_ESTATUS_TRASPASO=4
											OR	K_ESTATUS_TRASPASO=5	)
									AND		L_BORRADO=0
									AND		K_TRASPASO<>@PP_K_TRASPASO

	-- ===================================================
	IF @VP_MES_MONTO_EJERCIDO IS NULL
		SET @VP_MES_MONTO_EJERCIDO=0

	IF @PP_L_DEBUG>0
		PRINT 'MONTO EJERCIDO: ' + CONVERT(VARCHAR(10),@VP_MES_MONTO_EJERCIDO)  		

	-- /////////////////////////////////////////////////////

	DECLARE @VP_MES_MONTO_REMANENTE  DECIMAL(19,4)

	SELECT @VP_MES_MONTO_REMANENTE =	@VP_MES_MONTO_ESTIMADO-@VP_MES_MONTO_EN_PROCESO-@VP_MES_MONTO_EJERCIDO 

	-- ===================================================
	IF @VP_MES_MONTO_REMANENTE IS NULL
		SET @VP_MES_MONTO_REMANENTE=0

	IF @PP_L_DEBUG>0
		PRINT 'MONTO REMANENTE: ' + CONVERT(VARCHAR(10),@VP_MES_MONTO_REMANENTE)  	 		

	-- /////////////////////////////////////////////////////
	
	DECLARE @VP_L_PROCESAR AS INT = 0

	IF @VP_MES_MONTO_REMANENTE>=@PP_MONTO_APLICAR
		SET @VP_L_PROCESAR = 1  
					
	-- /////////////////////////////////////////////////////

	IF @VP_L_PROCESAR=0 
		BEGIN
		
		SET @PP_MONTO_APLICAR = CONVERT(DECIMAL(19,2),@PP_MONTO_APLICAR)

		SET @VP_RESULTADO =  'El Monto a Aplicar ($'+CONVERT(VARCHAR(10),CONVERT(DECIMAL(19,2),@PP_MONTO_APLICAR))+')'
		SET @VP_RESULTADO =  @VP_RESULTADO + ' es mayor al presupuesto disponible ($'+CONVERT(VARCHAR(10),CONVERT(DECIMAL(19,2),@VP_MES_MONTO_REMANENTE))+') para:'+ CHAR(13) + CHAR(10)  
		SET @VP_RESULTADO =  @VP_RESULTADO + ' - [UNO#' +CONVERT(VARCHAR(10),@PP_K_UNIDAD_OPERATIVA)+']'+ CHAR(13) + CHAR(10) 
		SET @VP_RESULTADO =  @VP_RESULTADO + ' - Año '+CONVERT(VARCHAR(5),@PP_K_YYYY)   + CHAR(13) + CHAR(10) 
		SET @VP_RESULTADO =  @VP_RESULTADO + ' - Mes '+ CONVERT(VARCHAR(5),@PP_K_MM) 
		SET @VP_RESULTADO =  @VP_RESULTADO + '.'  + CHAR(13) + CHAR(10) 
		
		END
	
	IF @PP_L_CONTESTA=1
		PRINT @VP_RESULTADO						
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_PRESUPUESTO_WK_MONTO_EN_PROCESO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EN_PROCESO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EN_PROCESO]
GO

CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EN_PROCESO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_PRESUPUESTO				[INT],
	@PP_K_RUBRO_PRESUPUESTO			[INT],
	@PP_K_UNIDAD_OPERATIVA			[INT],	
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	@PP_N_SEMANA					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		DECIMAL(19,4)		OUTPUT
AS

	DECLARE @VP_RESULTADO	DECIMAL(19,4)
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_MONTO_SEMANAL AS DECIMAL(19,4)
	
	SELECT @VP_MONTO_SEMANAL =	SUM(MONTO_APLICAR) 
									FROM	TRASPASO, TIEMPO_FECHA
									WHERE	TRASPASO.F_OPERACION=TIEMPO_FECHA.F_TIEMPO_FECHA
									AND		MONTH(F_OPERACION)=@PP_K_MM
									AND		YEAR(F_OPERACION)=@PP_K_YYYY
									AND		TIEMPO_FECHA.N_SEMANA=@PP_N_SEMANA
									AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
									AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
									--		K_ESTATUS_TRASPASO	1	BASE	2	PROGRAMADO	
									--		3	AUTORIZADO	4	EJECUTADO	5	CONCILIADO	
									--		6	CANCELADO
									AND		(	K_ESTATUS_TRASPASO=1
											OR	K_ESTATUS_TRASPASO=2
											OR	K_ESTATUS_TRASPASO=3	)
									AND		L_BORRADO=0

	IF @VP_MONTO_SEMANAL IS NULL
		SET @VP_MONTO_SEMANAL=0	
		
	SET @VP_RESULTADO=	@VP_MONTO_SEMANAL				
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> RN_PRESUPUESTO_WK_MONTO_EJERCIDO
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EJERCIDO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EJERCIDO]
GO


CREATE PROCEDURE [dbo].[PG_RN_PRESUPUESTO_WK_MONTO_EJERCIDO]
	@PP_L_DEBUG						[INT],
	@PP_K_SISTEMA_EXE				[INT],
	@PP_K_USUARIO_ACCION			[INT],
	-- ===========================		
	@PP_L_CONTESTA					[INT],
	-- ===========================	
	@PP_K_PRESUPUESTO				[INT],
	@PP_K_RUBRO_PRESUPUESTO			[INT],
	@PP_K_UNIDAD_OPERATIVA			[INT],	
	@PP_K_YYYY						[INT],
	@PP_K_MM						[INT],
	@PP_N_SEMANA					[INT],
	-- ===========================		
	@OU_RESULTADO_VALIDACION		DECIMAL(19,4)		OUTPUT
AS

	DECLARE @VP_RESULTADO	DECIMAL(19,4)
		
	-- /////////////////////////////////////////////////////

	DECLARE @VP_MONTO_SEMANAL AS DECIMAL(19,4)
	
	SELECT @VP_MONTO_SEMANAL =	SUM(MONTO_APLICAR) 
									FROM	TRASPASO, TIEMPO_FECHA
									WHERE	TRASPASO.F_OPERACION=TIEMPO_FECHA.F_TIEMPO_FECHA
									AND		MONTH(F_OPERACION)=@PP_K_MM
									AND		YEAR(F_OPERACION)=@PP_K_YYYY
									AND		TIEMPO_FECHA.N_SEMANA=@PP_N_SEMANA
									AND		K_UNIDAD_OPERATIVA=@PP_K_UNIDAD_OPERATIVA
									AND		K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO
									--		K_ESTATUS_TRASPASO	1	BASE	2	PROGRAMADO	
									--		3	AUTORIZADO	4	EJECUTADO	5	CONCILIADO	
									--		6	CANCELADO
									AND		(	K_ESTATUS_TRASPASO=4
											OR	K_ESTATUS_TRASPASO=5	)
									AND		L_BORRADO=0

	IF @VP_MONTO_SEMANAL IS NULL
		SET @VP_MONTO_SEMANAL=0	
		
	SET @VP_RESULTADO=	@VP_MONTO_SEMANAL				
	-- /////////////////////////////////////////////////////
	
	SET @OU_RESULTADO_VALIDACION = @VP_RESULTADO

	-- /////////////////////////////////////////////////////
GO
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////





-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
