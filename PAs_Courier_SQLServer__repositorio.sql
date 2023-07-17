USE COURIER;
--GO
--SELECT * FROM CONDUCTOR;
--GO
--SELECT * FROM CONDUCE;
--GO
--SELECT * FROM CAMION;
--GO
--SELECT * FROM PAQUETE;
--GO
--SELECT *FROM PROVINCIA;

GO
SELECT CEDULA, NOMBRE, ca.PLACA, ca.MODELO, c.FECHA  FROM CONDUCTOR con
	INNER JOIN CONDUCE c
	ON con.CEDULA = c.CEDULA_CONDUCTOR	
	JOIN CAMION ca
	ON c.PLACA_CAMION = ca.PLACA
	WHERE c.PLACA_CAMION = 'FK-1010';

GO

IF (OBJECT_ID('pa_conductor_conduce_camion_por_placa')) IS NOT NULL
DROP PROCEDURE pa_conductor_conduce_camion_por_placa;
GO
CREATE PROC pa_conductor_conduce_camion_por_placa
  @placacamion VARCHAR (10) = NULL
    AS    
		BEGIN
			IF @placacamion IS NOT NULL
			  BEGIN
				SELECT CEDULA, NOMBRE, ca.PLACA, ca.MODELO, c.FECHA  FROM CONDUCTOR con
				INNER JOIN CONDUCE c
				ON con.CEDULA = c.CEDULA_CONDUCTOR	
				JOIN CAMION ca
				ON c.PLACA_CAMION = ca.PLACA
				WHERE c.PLACA_CAMION = @placacamion
				--Retorna la cantidad de registros encontrados:
			 END
			 ELSE
				BEGIN
				  SELECT 'Ingrese un valor de placa v-alido.';
				  PRINT N'Intente otra vez';
				END
		END;

GO
----Modificaci-on del Procedimiento Almacenado "pa_conductor_conduce_camion_por_placa":
USE COURIER;
GO
ALTER PROCEDURE pa_conductor_conduce_camion_por_placa
  @placacamion NVARCHAR (15) = NULL,-- el tama-no m-aximo es 10, pero, en caso de que el usuario ingrese un
								  -- valor con longitud mayor que el permitido, se define con un tama-no 15. 
 								  -- Por otro lado, "nvarchar" soporta caracteres Unicode.
  @cantidad NUMERIC (4,0) = NULL OUTPUT --cantidad de coincidencias
    AS	  
	  BEGIN
	  -- Se verifica el n-umero de la placa
	    DECLARE @pla INT
	    EXEC @pla= pa_validacionplaca @placa = @placacamion;
		BEGIN
		  IF @pla = 1 
		    BEGIN
			  SELECT 'El campo est-a vac-io. Ingrese una Placa.'
			  PRINT N'Intente otra vez'; --PRINT N'Intente otra vez';
			  RETURN
			END;
								
		  ELSE
		    IF @pla = 2 
			  BEGIN
			    SELECT 'La placa '+@placacamion+ '..., no es correcta.'
								+'Debe tener entre 7 y 10 d-igitos.' 
				RETURN
			  END;
			ELSE
			  IF @pla = 3 SELECT 'El veh-iculo ingresado no est-a registrado en el sistema.'
			  ELSE
			    IF @pla = 4 SELECT 'El cami-on todav-ia no ha sido utilizado.'
		END;
	 
		-- IF @pla =0
		BEGIN
			SELECT CEDULA, NOMBRE, ca.PLACA, ca.MODELO, c.FECHA  FROM CONDUCTOR con
			INNER JOIN CONDUCE c
			ON con.CEDULA = c.CEDULA_CONDUCTOR	
			JOIN CAMION ca
			ON c.PLACA_CAMION = ca.PLACA
			WHERE c.PLACA_CAMION = @placacamion;
			--Retorna la cantidad de registros encontrados:				
			SELECT @cantidad = (SELECT COUNT(*) FROM CONDUCE WHERE PLACA_CAMION = @placacamion);
		END;

	  END;

GO
-- VALORES PARA PROBAR: --NULL; 'STD-23'; 'LRS-1122334'; 'EO-998877'; -- 'PCR-0123'; 'FK-1010'; 'GED-1234';
DECLARE @variable_cant_cami NUMERIC(4,0);
EXECUTE pa_conductor_conduce_camion_por_placa @placacamion='PCR-0123', @cantidad = @variable_cant_cami OUTPUT;
SELECT @variable_cant_cami AS CANTIDAD_VECES_CONDUCIDO;
EXECUTE pa_conductor_conduce_camion_por_placa @placacamion=NULL;
EXECUTE pa_conductor_conduce_camion_por_placa;
--EXECUTE pa_conductor_conduce_camion_por_placa @placacamion='FK-7810';

--------
GO
USE COURIER;
GO
IF (OBJECT_ID('pa_validacionplaca')) IS NOT NULL
DROP PROCEDURE pa_validacionplaca;
GO
-- Este procedimiento recibe una placa y retorna distintos valores según:
-- sea nulo (1), no sea v-alido (2), no esté en la tabla "camion" (3),
-- no est-e en la tabla "conduce" (4), y si el cami-on ya ha sido utilizado (0).
-- Este procedimiento recibe par-ametro, emplea "return"
CREATE PROC pa_validacionplaca
  @placa VARCHAR(10) = NULL 
    AS
	  BEGIN
	    IF @placa IS NULL
		  RETURN 1
		    ELSE
			  IF LEN(@placa) <10
			    RETURN 2
				  ELSE
				    IF NOT EXISTS (SELECT * FROM CAMION WHERE @placa=PLACA) RETURN 3
					  ELSE
					    BEGIN
					      IF NOT EXISTS (SELECT *FROM CONDUCE
										  WHERE @placa=PLACA_CAMION) RETURN 4
						  ELSE RETURN 0
						END;

	  END;
GO

----modificacion "pa_validacionplaca"
ALTER PROC pa_validacionplaca
  @placa NVARCHAR(15) = NULL -- el tama-no m-aximo es 10, pero, en caso de que el usuario ingrese un
							-- valor con longitud mayor que el permitido, se define con un tama-no 15.
							-- Por otro lado, "nvarchar" soporta caracteres Unicode.
    AS
	  BEGIN
	    IF @placa IS NULL
		  RETURN 1
		    ELSE
			  IF ( LEN(@placa)<7 OR LEN(@placa)>10) -- ]-inf, 7[ or ]10,+inf[ --LEN(@placa)<7 OR
			    RETURN 2
				  ELSE
				    IF NOT EXISTS (SELECT * FROM CAMION WHERE @placa=PLACA) RETURN 3 --  LEN(@placa)
					  ELSE
					    BEGIN
					      IF NOT EXISTS (SELECT *FROM CONDUCE
										  WHERE @placa=PLACA_CAMION) RETURN 4
						  ELSE RETURN 0
						END;

	  END;
GO

DECLARE @retorno_validacionplaca INT;
EXECUTE @retorno_validacionplaca=  pa_validacionplaca 'GED-1234';--NULL; 'STD-23'; 'LRS-1122334'; 'EO-998877'; -- 'PCR-0123'; 'FK-1010'; 'GED-1234';
SELECT 'Valor de validaci-on' = @retorno_validacionplaca;