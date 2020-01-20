-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			SP_Extras_20181124_HGF.sql
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MÓDULO:			CONTROL DE VIAJES - PRESUPUESTO_VIAJE 
-- // OPERACIÓN:		LIBERACIÓN / STORED PROCEDURE
-- //////////////////////////////////////////////////////////////
-- // Autor:			HGF
-- // Fecha creación:	24/NOV/2018
-- //////////////////////////////////////////////////////////////  

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT/UPDATE_PRESUPUESTO_X_K_VIAJE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IU_PRESUPUESTO_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IU_PRESUPUESTO_VIAJE]
GO

CREATE PROCEDURE [dbo].[PG_IU_PRESUPUESTO_VIAJE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_VIAJE							INT,
	@PP_K_PRESUPUESTO_VIAJE				INT,
	@PP_K_RUBRO_VIATICO					INT,
	-- ===========================
	@PP_MONTO_PROPUESTO					DECIMAL(19,4),
	@PP_C_PRESUPUESTO_VIAJE				VARCHAR(500)
AS			


/*	
	DECLARE @VP_K_PRESUPUESTO_VIAJE		INT
	
	SELECT	@VP_K_PRESUPUESTO_VIAJE =	MAX(K_PRESUPUESTO_VIAJE)
										FROM	PRESUPUESTO_VIAJE
										WHERE	K_VIAJE=@PP_K_VIAJE
										AND		K_RUBRO_VIATICO=@PP_K_RUBRO_VIATICO
*/
	-- ///////////////////////////////////////////////////

	IF @PP_MONTO_PROPUESTO=0
		BEGIN
		IF @PP_K_PRESUPUESTO_VIAJE>0
			DELETE
			FROM	PRESUPUESTO_VIAJE
			WHERE	K_PRESUPUESTO_VIAJE=@PP_K_PRESUPUESTO_VIAJE
		END
	ELSE
		IF @PP_K_VIAJE>0
			IF @PP_K_PRESUPUESTO_VIAJE>0
				EXECUTE [dbo].[PG_UP_PRESUPUESTO_VIAJE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_PRESUPUESTO_VIAJE,
															@PP_K_VIAJE, @PP_K_RUBRO_VIATICO,
															@PP_MONTO_PROPUESTO, @PP_C_PRESUPUESTO_VIAJE				
			ELSE
				EXECUTE [dbo].[PG_IN_PRESUPUESTO_VIAJE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
															@PP_K_VIAJE, @PP_K_RUBRO_VIATICO,
															@PP_MONTO_PROPUESTO, @PP_C_PRESUPUESTO_VIAJE				

GO
-- //////////////////////////////////////////////////////////////


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERT/UPDATE_GASTO_X_K_VIAJE / FICHA
-- //////////////////////////////////////////////////////////////

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IU_GASTO_VIAJE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IU_GASTO_VIAJE]
GO

CREATE PROCEDURE [dbo].[PG_IU_GASTO_VIAJE]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ===========================
	@PP_K_VIAJE							INT,
	@PP_K_GASTO_VIAJE					INT,
	@PP_K_RUBRO_VIATICO					INT,
	-- ===========================
	@PP_MONTO							DECIMAL(19,4),
	@PP_C_GASTO_VIAJE					VARCHAR(500)
AS			
	-- ///////////////////////////////////////////////////

	IF @PP_MONTO=0
	BEGIN
		IF @PP_K_GASTO_VIAJE>0
			DELETE
			FROM	GASTO_VIAJE
			WHERE	K_GASTO_VIAJE=@PP_K_GASTO_VIAJE
		END
	ELSE
		IF @PP_K_VIAJE>0
			IF @PP_K_GASTO_VIAJE>0
				EXECUTE [dbo].[PG_UP_GASTO_VIAJE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_GASTO_VIAJE,
														@PP_K_VIAJE, @PP_K_RUBRO_VIATICO,
														@PP_MONTO, @PP_C_GASTO_VIAJE				
			ELSE
				EXECUTE [dbo].[PG_IN_GASTO_VIAJE]		@PP_L_DEBUG, @PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
														@PP_K_VIAJE, @PP_K_RUBRO_VIATICO,
														@PP_MONTO, @PP_C_GASTO_VIAJE				

GO
-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
