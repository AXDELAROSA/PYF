-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas
-- // MODULO:			PRESUPUESTO GASTOS/PLANTA
-- // OPERACION:		LIBERACION / CARGA INICIAL
-- ////////////////////////////////////////////////////////////// 
-- // Autor:			HECTOR A. GONZALEZ DE LA FUENTE
-- // Fecha creación:	24/SEP/2018
-- ////////////////////////////////////////////////////////////// 

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////




-- //////////////////////////////////////////////////////////////
--	SELECT * FROM [RUBRO_PRESUPUESTO]


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_CI_RUBRO_PRESUPUESTO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_CI_RUBRO_PRESUPUESTO]
GO


CREATE PROCEDURE [dbo].[PG_CI_RUBRO_PRESUPUESTO]
	@PP_L_DEBUG							INT,
	@PP_K_SISTEMA_EXE					INT,
	@PP_K_USUARIO_ACCION				INT,
	-- ========================================
	@PP_K_RUBRO_PRESUPUESTO				INT,
	@PP_D_RUBRO_PRESUPUESTO				VARCHAR(100),
	@PP_S_RUBRO_PRESUPUESTO				VARCHAR(10),
	@PP_O_RUBRO_PRESUPUESTO				INT,
	@PP_C_RUBRO_PRESUPUESTO				VARCHAR(255),
	@PP_L_RUBRO_PRESUPUESTO				INT,
	@PP_K_NIVEL_RUBRO_PRESUPUESTO		INT,
	@PP_K_RUBRO_PADRE					INT
AS
	-- ===============================

	DECLARE @VP_K_EXISTE	INT

	SELECT	@VP_K_EXISTE =	K_RUBRO_PRESUPUESTO
							FROM	RUBRO_PRESUPUESTO
							WHERE	K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO

	-- ===============================

	IF @VP_K_EXISTE IS NULL
		INSERT INTO RUBRO_PRESUPUESTO
			(	K_RUBRO_PRESUPUESTO,				D_RUBRO_PRESUPUESTO, 
				S_RUBRO_PRESUPUESTO,				O_RUBRO_PRESUPUESTO,
				C_RUBRO_PRESUPUESTO,
				L_RUBRO_PRESUPUESTO,
				K_NIVEL_RUBRO_PRESUPUESTO,			K_RUBRO_PADRE					)
		VALUES		
			(	@PP_K_RUBRO_PRESUPUESTO,			@PP_D_RUBRO_PRESUPUESTO,	
				@PP_S_RUBRO_PRESUPUESTO,			@PP_O_RUBRO_PRESUPUESTO,
				@PP_C_RUBRO_PRESUPUESTO,
				@PP_L_RUBRO_PRESUPUESTO,
				@PP_K_NIVEL_RUBRO_PRESUPUESTO,		@PP_K_RUBRO_PADRE				)
	ELSE
		UPDATE	RUBRO_PRESUPUESTO
		SET		D_RUBRO_PRESUPUESTO	= @PP_D_RUBRO_PRESUPUESTO,	
				S_RUBRO_PRESUPUESTO	= @PP_S_RUBRO_PRESUPUESTO,			
				O_RUBRO_PRESUPUESTO	= @PP_O_RUBRO_PRESUPUESTO,
				C_RUBRO_PRESUPUESTO	= @PP_C_RUBRO_PRESUPUESTO,
				L_RUBRO_PRESUPUESTO	= @PP_L_RUBRO_PRESUPUESTO,
				K_NIVEL_RUBRO_PRESUPUESTO = @PP_K_NIVEL_RUBRO_PRESUPUESTO	
		WHERE	K_RUBRO_PRESUPUESTO=@PP_K_RUBRO_PRESUPUESTO

	-- =========================================================
GO



-- //////////////////////////////////////////////////////////////
--	SELECT * FROM RUBRO_PRESUPUESTO ORDER BY O_RUBRO_PRESUPUESTO


-- ===============================================
SET NOCOUNT ON
-- ===============================================


EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 0, 'Presupuesto Planta' , 'Presupuesto Planta' , 0 , 'Presupuesto Planta' , 1 , 0 , 0
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 10, 'Gastos Totales' , 'Gastos Totales' , 1080 , 'Gastos Totales' , 1 , 0 , 0
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 20, 'Total GTO' , 'Total GTO' , 1090 , 'Total GTO' , 1 , 1 , 0
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 30, 'Sueldos y Salarios' , 'Sueldos y Salarios' , 10 , 'Sueldos y Salarios' , 1 , 0 , 0
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 40, 'Total SYS' , 'Total SYS' , 80 , 'Total SYS' , 1 , 2 , 20
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 50, 'Nómina Operativa' , 'Nómina Operativa' , 40 , 'Nómina Operativa' , 1 , 4 , 40
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 60, 'Nómina Operativa / Fiscal' , 'Nómina Operativa / Fiscal' , 20 , 'Nómina Operativa / Fiscal' , 1 , 5 , 50
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 70, 'Nómina Operativa / No Fiscal' , 'Nómina Operativa / No Fiscal' , 30 , 'Nómina Operativa / No Fiscal' , 1 , 5 , 50
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 80, 'Nómina Administrativa' , 'Nómina Administrativa' , 70 , 'Nómina Administrativa' , 1 , 4 , 40
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 90, 'Nómina Administrativa / Fiscal' , 'Nómina Administrativa / Fiscal' , 50 , 'Nómina Administrativa / Fiscal' , 1 , 5 , 80
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 100, 'Nómina Administrativa / No Fiscal' , 'Nómina Administrativa / No Fiscal' , 60 , 'Nómina Administrativa / No Fiscal' , 1 , 5 , 80
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 110, 'Renta' , 'Renta' , 90 , 'Renta' , 1 , 0 , 0
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 120, 'Total Rentas' , 'Rentas' , 130 , 'Rentas' , 1 , 2 , 20
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 130, 'Renta Oficinas' , 'Renta Oficinas' , 100 , 'Renta Oficinas' , 1 , 5 , 120
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 140, 'Renta Terrenos' , 'Renta Terrenos' , 110 , 'Renta Terrenos' , 1 , 5 , 120
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 150, 'Renta Casas/Deptos' , 'Renta Casas/Deptos' , 120 , 'Renta Casas/Deptos' , 1 , 5 , 120
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 160, 'Servicios Prioritarios' , 'Servicios Prioritarios' , 140 , 'Servicios Prioritarios' , 1 , 0 , 0
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 170, 'Total SER' , 'Total SER' , 350 , 'Total SER' , 1 , 2 , 20
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 180, 'Servicios Primarios ' , 'Servicios Primarios ' , 200 , 'Servicios Primarios ' , 1 , 4 , 170
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 190, 'Energía Eléctrica' , 'Energía Eléctrica' , 150 , 'Energía Eléctrica' , 1 , 5 , 180
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 200, 'Servicio de Agua' , 'Servicio de Agua' , 160 , 'Servicio de Agua' , 1 , 5 , 180
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 210, 'Agua Cisterna' , 'Agua Cisterna' , 170 , 'Agua Cisterna' , 1 , 5 , 180
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 220, 'Drenaje' , 'Drenaje' , 180 , 'Drenaje' , 1 , 5 , 180
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 230, 'Recoleccion de Basura' , 'Recoleccion de Basura' , 190 , 'Recoleccion de Basura' , 1 , 5 , 180
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 240, 'Servicios Comunicación' , 'Servicios Comunicación' , 270 , 'Servicios Comunicación' , 1 , 4 , 170
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 250, 'Teléfono' , 'Teléfono' , 210 , 'Teléfono' , 1 , 5 , 240
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 260, 'Seccion Amarilla' , 'Seccion Amarilla' , 220 , 'Seccion Amarilla' , 1 , 5 , 240
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 270, 'Celulares' , 'Celulares' , 230 , 'Celulares' , 1 , 5 , 240
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 280, 'Radios' , 'Radios' , 240 , 'Radios' , 1 , 5 , 240
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 290, 'Internet' , 'Internet' , 250 , 'Internet' , 1 , 5 , 240
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 300, 'Monitoreo GPS' , 'Monitoreo GPS' , 260 , 'Monitoreo GPS' , 1 , 5 , 240
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 310, 'Servicios Varios' , 'Servicios Varios' , 340 , 'Servicios Varios' , 1 , 4 , 170
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 320, 'Traslado de Valores' , 'Traslado de Valores' , 280 , 'Traslado de Valores' , 1 , 5 , 310
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 330, 'Publicidad (Espacio/Pauta)' , 'Publicidad (Espacio/Pauta)' , 290 , 'Publicidad (Espacio/Pauta)' , 1 , 5 , 310
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 340, 'Seguro de Unidades' , 'Seguro de Unidades' , 300 , 'Seguro de Unidades' , 1 , 5 , 310
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 350, 'Servicio Seguridad' , 'Servicio Seguridad' , 310 , 'Servicio Seguridad' , 1 , 5 , 310
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 360, 'Honorarios' , 'Honorarios' , 320 , 'Honorarios' , 1 , 5 , 310
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 370, 'Otros servicios' , 'Otros servicios' , 330 , 'Otros servicios' , 1 , 5 , 310
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 380, 'Mantenimiento' , 'Mantenimiento' , 360 , 'Mantenimiento' , 1 , 0 , 0
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 390, 'Total MTO' , 'Total MTO' , 550 , 'Total MTO' , 1 , 2 , 20
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 400, 'Mantenimiento Unidades' , 'Mantenimiento Unidades' , 400 , 'Mantenimiento Unidades' , 1 , 4 , 390
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 410, 'Refacciones y Reparaciones' , 'Refacciones y Reparaciones' , 370 , 'Refacciones y Reparaciones' , 1 , 5 , 400
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 420, 'Combustibles y Lubricantes' , 'Combustibles y Lubricantes' , 380 , 'Combustibles y Lubricantes' , 1 , 5 , 400
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 430, 'Carroceria y pintura' , 'Carroceria y pintura' , 390 , 'Carroceria y pintura' , 1 , 5 , 400
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 440, 'Mantenimiento Infraestructura' , 'Mantenimiento Infraestructura' , 480 , 'Mantenimiento Infraestructura' , 1 , 4 , 390
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 450, 'Mantenimiento Oficina' , 'Mantenimiento Oficina' , 410 , 'Mantenimiento Oficina' , 1 , 5 , 440
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 460, 'Mantenimiento Planta' , 'Mantenimiento Planta' , 420 , 'Mantenimiento Planta' , 1 , 5 , 440
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 470, 'Mantenimiento Taller' , 'Mantenimiento Taller' , 430 , 'Mantenimiento Taller' , 1 , 5 , 440
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 480, 'Mantenimiento Islas' , 'Mantenimiento Islas' , 440 , 'Mantenimiento Islas' , 1 , 5 , 440
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 490, 'Mtto Estaciones de Carburación' , 'Mtto Estaciones de Carburación' , 450 , 'Mtto Estaciones de Carburación' , 1 , 5 , 440
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 500, 'Mantenimineto Mayor' , 'Mantenimineto Mayor' , 460 , 'Mantenimineto Mayor' , 1 , 5 , 440
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 510, 'Imagen y presentación 1' , 'Imagen y presentación 1' , 470 , 'Imagen y presentación 1' , 1 , 5 , 440
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 520, 'Mantenimiento Diversos' , 'Mantenimiento Diversos' , 530 , 'Mantenimiento Diversos' , 1 , 4 , 390
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 530, 'Instalacion de Tanques e Isletas' , 'Instalacion de Tanques e Isletas' , 490 , 'Instalacion de Tanques e Isletas' , 1 , 5 , 520
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 540, 'Pintura y Reparacion de Cilindros' , 'Pintura y Reparacion de Cilindros' , 500 , 'Pintura y Reparacion de Cilindros' , 1 , 5 , 520
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 550, 'Guantes y Herramientas' , 'Guantes y Herramientas' , 510 , 'Guantes y Herramientas' , 1 , 5 , 520
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 560, 'Imagen y presentación 2' , 'Imagen y presentación 2' , 520 , 'Imagen y presentación 2' , 1 , 5 , 520
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 570, 'Otros' , 'Otros' , 540 , 'Otros' , 1 , 5 , 520
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 580, 'Gastos Generales' , 'Gastos Generales' , 560 , 'Gastos Generales' , 1 , 0 , 0
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 590, 'Total GGE' , 'Total GGE' , 960 , 'Total GGE' , 1 , 2 , 20
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 600, 'Consumibles y Equipo' , 'Consumibles y Equipo' , 630 , 'Consumibles y Equipo' , 1 , 4 , 590
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 610, 'Papeleria y Articulos de Oficina' , 'Papeleria y Articulos de Oficina' , 570 , 'Papeleria y Articulos de Oficina' , 1 , 5 , 600
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 620, 'Papelería Planta, Estaciones y Módulos' , 'Papelería Planta, Estaciones y Módulos' , 580 , 'Papelería Planta, Estaciones y Módulos' , 1 , 5 , 600
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 630, 'Articulos de Limpieza' , 'Articulos de Limpieza' , 590 , 'Articulos de Limpieza' , 1 , 5 , 600
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 640, 'Equipo de oficina' , 'Equipo de oficina' , 600 , 'Equipo de oficina' , 1 , 5 , 600
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 650, 'Renta de copiadora' , 'Renta de copiadora' , 610 , 'Renta de copiadora' , 1 , 5 , 600
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 660, 'Consumo de oficinas' , 'Consumo de oficinas' , 620 , 'Consumo de oficinas' , 1 , 5 , 600
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 670, 'Servicios Profesionales' , 'Servicios Profesionales' , 700 , 'Servicios Profesionales' , 1 , 4 , 590
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 680, 'Pago de Arbitrajes' , 'Pago de Arbitrajes' , 640 , 'Pago de Arbitrajes' , 1 , 5 , 670
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 690, 'Publicidad  (Servicio)' , 'Publicidad  (Servicio)' , 650 , 'Publicidad  (Servicio)' , 1 , 5 , 670
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 700, 'Asesoria Legal' , 'Asesoria Legal' , 660 , 'Asesoria Legal' , 1 , 5 , 670
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 710, 'Servicio Medico' , 'Servicio Medico' , 670 , 'Servicio Medico' , 1 , 5 , 670
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 720, 'Imprenta' , 'Imprenta' , 680 , 'Imprenta' , 1 , 5 , 670
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 730, 'Gastos Contractuales (varios)' , 'Gastos Contractuales (varios)' , 690 , 'Gastos Contractuales (varios)' , 1 , 5 , 670
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 740, 'Gastos Operativos' , 'Gastos Operativos' , 800 , 'Gastos Operativos' , 1 , 4 , 590
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 750, 'Herramientas' , 'Herramientas' , 710 , 'Herramientas' , 1 , 5 , 740
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 760, 'Guantes y Uniformes' , 'Guantes y Uniformes' , 720 , 'Guantes y Uniformes' , 1 , 5 , 740
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 770, 'Sellos de Garantia' , 'Sellos de Garantia' , 730 , 'Sellos de Garantia' , 1 , 5 , 740
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 780, 'Sellos de Seguridad' , 'Sellos de Seguridad' , 740 , 'Sellos de Seguridad' , 1 , 5 , 740
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 790, 'Equipo contra Incendio' , 'Equipo contra Incendio' , 750 , 'Equipo contra Incendio' , 1 , 5 , 740
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 800, 'Renta de sanitarios' , 'Renta de sanitarios' , 760 , 'Renta de sanitarios' , 1 , 5 , 740
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 810, 'Gruas y maniobras' , 'Gruas y maniobras' , 770 , 'Gruas y maniobras' , 1 , 5 , 740
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 820, 'Recolección de Contaminantes' , 'Recolección de Contaminantes' , 780 , 'Recolección de Contaminantes' , 1 , 5 , 740
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 830, 'Rotulacion de precios' , 'Rotulacion de precios' , 790 , 'Rotulacion de precios' , 1 , 5 , 740
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 840, 'Gastos de Viaje y Representación' , 'Gastos de Viaje y Representación' , 850 , 'Gastos de Viaje y Representación' , 1 , 4 , 590
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 850, 'Viaticos y hospedaje' , 'Viaticos y hospedaje' , 810 , 'Viaticos y hospedaje' , 1 , 5 , 840
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 860, 'Vales de Gasolina' , 'Vales de Gasolina' , 820 , 'Vales de Gasolina' , 1 , 5 , 840
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 870, 'Casetas y estacionamientos' , 'Casetas y estacionamientos' , 830 , 'Casetas y estacionamientos' , 1 , 5 , 840
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 880, 'Atencion a clientes' , 'Atencion a clientes' , 840 , 'Atencion a clientes' , 1 , 5 , 840
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 890, 'Aportaciones Varias' , 'Aportaciones Varias' , 920 , 'Aportaciones Varias' , 1 , 4 , 590
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 900, 'Gratificaciones' , 'Gratificaciones' , 860 , 'Gratificaciones' , 1 , 5 , 890
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 910, 'Apoyos' , 'Apoyos' , 870 , 'Apoyos' , 1 , 5 , 890
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 920, 'Cuota sindical' , 'Cuota sindical' , 880 , 'Cuota sindical' , 1 , 5 , 890
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 930, 'Multas e infracciones' , 'Multas e infracciones' , 890 , 'Multas e infracciones' , 1 , 5 , 890
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 940, 'Captacion de clientes' , 'Captacion de clientes' , 900 , 'Captacion de clientes' , 1 , 5 , 890
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 950, 'Finiquitos' , 'Finiquitos' , 910 , 'Finiquitos' , 1 , 5 , 890
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 960, 'Otros Gastos' , 'Otros Gastos' , 930 , 'Otros Gastos' , 1 , 5 , 890
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 970, 'Manto de oficinas' , 'Manto de oficinas' , 940 , 'Manto de oficinas' , 1 , 5 , 890
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 980, 'Corporativo' , 'Corporativo' , 950 , 'Corporativo' , 1 , 5 , 890
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 990, 'Impuestos' , 'Impuestos' , 970 , 'Impuestos' , 1 , 0 , 0
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 1000, 'Total IMP' , 'Total IMP' , 1070 , 'Total IMP' , 1 , 2 , 20
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 1010, 'Impuestos Federales' , 'Impuestos Federales' , 1020 , 'Impuestos Federales' , 1 , 4 , 1000
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 1020, 'I.M.S.S.' , 'I.M.S.S.' , 980 , 'I.M.S.S.' , 1 , 5 , 1010
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 1030, 'INFONAVIT' , 'INFONAVIT' , 990 , 'INFONAVIT' , 1 , 5 , 1010
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 1040, 'S.A.R.' , 'S.A.R.' , 1000 , 'S.A.R.' , 1 , 5 , 1010
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 1050, 'R.C.V.' , 'R.C.V.' , 1010 , 'R.C.V.' , 1 , 5 , 1010
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 1060, 'Impuestos Estatales' , 'Impuestos Estatales' , 1050 , 'Impuestos Estatales' , 1 , 4 , 1000
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 1070, '2% S/Nomina' , '2% S/Nomina' , 1030 , '2% S/Nomina' , 1 , 5 , 1060
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 1080, 'ESTATAL' , 'ESTATAL' , 1040 , 'ESTATAL' , 1 , 5 , 1060
EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 1090, 'Otro' , 'Otro' , 1060 , 'Otro' , 1 , 5 , 1060


GO

EXECUTE [dbo].[PG_CI_RUBRO_PRESUPUESTO]  0,0,0, 1, 'Semanas Mes' , 'Semanas Mes' , 1 , 'Semanas Mes' , 1 , 3 , 0

GO


-- ===============================================
SET NOCOUNT OFF
-- ===============================================


-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////

