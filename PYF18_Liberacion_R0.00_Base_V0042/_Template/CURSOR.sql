	-- ///////////////////////////////////////////////////////////////
	
	DECLARE @VP_K_TIPO_LIBRO_INGRESOS	INT

	DECLARE CU_TIEMPO_FECHA	
		CURSOR	LOCAL FOR
				SELECT	F_TIEMPO_FECHA
				FROM	TIEMPO_FECHA
				WHERE	( @PP_F_INICIO<=F_TIEMPO_FECHA	AND	 F_TIEMPO_FECHA<=@PP_F_FIN  )
					
		-- ========================================

		DECLARE @VP_CU_F_TIEMPO_FECHA		DATE
			
		-- ========================================

		OPEN CU_TIEMPO_FECHA

		FETCH NEXT FROM CU_TIEMPO_FECHA INTO @VP_CU_F_TIEMPO_FECHA
		
		WHILE @@FETCH_STATUS = 0
			BEGIN		
			-- =========================================
			-- K_TIPO_LIBRO_INGRESOS	D_TIPO_LIBRO_INGRESOS
			-- 101	VENTA CONTADO
			SET @VP_K_TIPO_LIBRO_INGRESOS = 101
		

			-- ========================================

		    FETCH NEXT FROM CU_TIEMPO_FECHA INTO @VP_CU_F_TIEMPO_FECHA
			
			END

		-- ========================================

	CLOSE		CU_TIEMPO_FECHA
	DEALLOCATE	CU_TIEMPO_FECHA

	-- ///////////////////////////////////////////////////////////////

