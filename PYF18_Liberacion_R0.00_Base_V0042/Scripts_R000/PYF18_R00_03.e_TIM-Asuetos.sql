-- //////////////////////////////////////////////////////////////
-- // ARCHIVO:			
-- //////////////////////////////////////////////////////////////
-- // BASE DE DATOS:	PYF18_Finanzas	
-- // MODULO:			CONFIGURACION - SPs MANEJO DE FECHAS   		
-- // OPERACION:		CARGA INICIAL // ASUETOS   
-- //////////////////////////////////////////////////////////////

USE [PYF18_Finanzas_V9999_R0]
GO

-- //////////////////////////////////////////////////////////////



-- //////////////////////////////////////////////////////////////
-- SELECT * FROM TIEMPO_FECHA WHERE L_ASUETO=1



-- //////////////////////////////////////////////////////////////
-- // ASUETOS // 2018
-- //////////////////////////////////////////////////////////////

UPDATE	[TIEMPO_FECHA]
SET		L_ASUETO = 0
WHERE	YEAR(F_TIEMPO_FECHA)=2018
GO


UPDATE	[TIEMPO_FECHA]
SET		L_ASUETO = 1
WHERE	F_TIEMPO_FECHA IN ( '01/01/2018', -- I. El 1 de enero.
							'05/FEB/2018', -- II. El 5 de febrero
							'19/MAR/2018', -- III. El tercer lunes de marzo en conmemoración del 21 de marzo, es decir, el 19 de marzo.
							'29/MAR/2018', '30/MAR/2018', -- IV. El 29 y 30 de marzo. 
							'01/MAY/2018', -- V. El 1 de mayo.
							'01/JUL/2018', -- VI. El 1 de julio, con motivo de las elecciones federales./p>
							'16/SEP/2018', -- VII. El 16 de septiembre.
							'02/NOV/2018', '19/NOV/2018', -- VIII. El 2 de noviembre. Adicionalmente, el tercer lunes de dicho mes en conmemoración del 20 de noviembre, es decir, el 19 de noviembre.
							'2018/12/01', '2018/12/12', '2018/12/25' -- IX. El 1, 12 y 25 de diciembre.			
			--				'12/01/2018', '12/12/2018', '12/25/2018' -- IX. El 1, 12 y 25 de diciembre.			
						  )


-- //////////////////////////////////////////////////////////////
-- // ASUETOS // 2019
-- //////////////////////////////////////////////////////////////

UPDATE	[TIEMPO_FECHA]
SET		L_ASUETO = 0
WHERE	YEAR(F_TIEMPO_FECHA)=2019
GO


UPDATE	[TIEMPO_FECHA]
SET		L_ASUETO = 1
WHERE	F_TIEMPO_FECHA IN ( '01/01/2019', -- I. El 1 de enero.
					--		'05/FEB/2019', -- II. El 5 de febrero
					--		'19/MAR/2019', -- III. El tercer lunes de marzo en conmemoración del 21 de marzo, es decir, el 19 de marzo.
					--		'29/MAR/2019', '30/MAR/2019', -- IV. El 29 y 30 de marzo. 
							'01/MAY/2019', -- V. El 1 de mayo.
					--		'01/JUL/2019', -- VI. El 1 de julio, con motivo de las elecciones federales./p>
							'16/SEP/2019', -- VII. El 16 de septiembre.
					--		'02/NOV/2019', '19/NOV/2019', -- VIII. El 2 de noviembre. Adicionalmente, el tercer lunes de dicho mes en conmemoración del 20 de noviembre, es decir, el 19 de noviembre.
					--		'01/DEC/2019', 
							'2019/12/12', '2019/12/25' -- IX. El 1, 12 y 25 de diciembre.
						  )


-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////
