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





-- ///////////////////////////////////////////////////////////////
-- //					
-- ///////////////////////////////////////////////////////////////



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_OP_DATA_N3_102_PRECIO_COSTO_RECALCULAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_OP_DATA_N3_102_PRECIO_COSTO_RECALCULAR]
GO

CREATE PROCEDURE [dbo].[PG_OP_DATA_N3_102_PRECIO_COSTO_RECALCULAR]
	@PP_L_DEBUG					INT,
	@PP_K_SISTEMA_EXE			INT,
	@PP_K_USUARIO_ACCION		INT,
	-- ==============================
	@PP_K_DOCUMENTO_D0M4		INT
AS
	IF @PP_L_DEBUG>0
		PRINT '[PG_OP_DATA_N3_102_PRECIO_COSTO_RECALCULAR]'

	-- //////////////////////////////////////////
	-- S#2 - MG			2003
	EXECUTE [dbo].[PG_CA_MATE_N3_02A_RESTAR_A_MENOS_B]	@PP_K_DOCUMENTO_D0M4,	
														2003,	0,	2001, 2002
	-- S#2 - MGD		2005
	EXECUTE [dbo].[PG_CA_MATE_N3_02A_RESTAR_A_MENOS_B]	@PP_K_DOCUMENTO_D0M4,	
														2005,	0,	2003, 2004
	-- //////////////////////////////////////////
	-- S#3 - TOT		2014
	EXECUTE [dbo].[PG_CA_MATE_N1_01A_SUMAR_A_MAS_B]		@PP_K_DOCUMENTO_D0M4,	
														2014,	0,	2006, 2007
	EXECUTE [dbo].[PG_CA_MATE_N3_05A_ACUMULAR_MAS_A]	@PP_K_DOCUMENTO_D0M4,
														2014,	0,	2008	
	EXECUTE [dbo].[PG_CA_MATE_N3_05A_ACUMULAR_MAS_A]	@PP_K_DOCUMENTO_D0M4,
														2014,	0,	2009	
	EXECUTE [dbo].[PG_CA_MATE_N3_05A_ACUMULAR_MAS_A]	@PP_K_DOCUMENTO_D0M4,
														2014,	0,	2010
	EXECUTE [dbo].[PG_CA_MATE_N3_05A_ACUMULAR_MAS_A]	@PP_K_DOCUMENTO_D0M4,
														2014,	0,	2011
	EXECUTE [dbo].[PG_CA_MATE_N3_05A_ACUMULAR_MAS_A]	@PP_K_DOCUMENTO_D0M4,
														2014,	0,	2012
	EXECUTE [dbo].[PG_CA_MATE_N3_05A_ACUMULAR_MAS_A]	@PP_K_DOCUMENTO_D0M4,
														2014,	0,	2013
	-- //////////////////////////////////////////
	-- S#4 - PV			2015
	EXECUTE [dbo].[PG_CA_MATE_N3_10A_ASIGNAR_A]			@PP_K_DOCUMENTO_D0M4,	
														2015,	0,	2001
	-- S#4 - PVN		2018
	EXECUTE [dbo].[PG_CA_MATE_N3_02A_RESTAR_A_MENOS_B]	@PP_K_DOCUMENTO_D0M4,	
														2018,	0,	2015, 2016
	EXECUTE [dbo].[PG_CA_MATE_N3_05B_ACUMULAR_MENOS_A]	@PP_K_DOCUMENTO_D0M4,	
														2018,	0,	2017			
	-- //////////////////////////////////////////
	-- S#5 - PC			2019
	EXECUTE [dbo].[PG_CA_MATE_N3_10A_ASIGNAR_A]			@PP_K_DOCUMENTO_D0M4,	
														2019,	0,	2002					
	-- S#5 - PCN		2021
	EXECUTE [dbo].[PG_CA_MATE_N3_02A_RESTAR_A_MENOS_B]	@PP_K_DOCUMENTO_D0M4,	
														2021,	0,	2019, 2020						
	-- //////////////////////////////////////////
	-- S#6 - PVN		2022
	EXECUTE [dbo].[PG_CA_MATE_N3_10A_ASIGNAR_A]			@PP_K_DOCUMENTO_D0M4,	
														2022,	0,	2018
	-- S#6 - PCN		2023
	EXECUTE [dbo].[PG_CA_MATE_N3_10A_ASIGNAR_A]			@PP_K_DOCUMENTO_D0M4,	
														2023,	0,	2021	
	-- S#6 - MGN		2024
	EXECUTE [dbo].[PG_CA_MATE_N3_02A_RESTAR_A_MENOS_B]	@PP_K_DOCUMENTO_D0M4,	
														2024,	0,	2022, 2023														
	-- S#6 - FLETE		2025
	EXECUTE [dbo].[PG_CA_MATE_N3_10A_ASIGNAR_A]			@PP_K_DOCUMENTO_D0M4,	
														2025,	0,	2004	
	-- S#6 - MDN		2026
	EXECUTE [dbo].[PG_CA_MATE_N3_02A_RESTAR_A_MENOS_B]	@PP_K_DOCUMENTO_D0M4,	
														2026,	0,	2024, 2025

	-- //////////////////////////////////////////////////////////////
GO





-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
-- ************************************************************************************
-- ////////////////////////////////////////////////////////////////////////////////////
