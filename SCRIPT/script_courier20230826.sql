USE [Courier]
GO
/****** Object:  Table [dbo].[CAMION]    Script Date: 26/8/2023 22:45:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CAMION](
	[PLACA] [varchar](10) NOT NULL,
	[MODELO] [varchar](15) NULL,
	[TIPO] [varchar](15) NULL,
	[POTENCIA] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[PLACA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CONDUCE]    Script Date: 26/8/2023 22:45:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONDUCE](
	[CEDULA_CONDUCTOR] [varchar](10) NOT NULL,
	[PLACA_CAMION] [varchar](10) NOT NULL,
	[FECHA] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CEDULA_CONDUCTOR] ASC,
	[PLACA_CAMION] ASC,
	[FECHA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CONDUCTOR]    Script Date: 26/8/2023 22:45:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONDUCTOR](
	[CEDULA] [varchar](10) NOT NULL,
	[NOMBRE] [varchar](50) NULL,
	[TELEFONO] [varchar](15) NULL,
	[DIRECCION] [varchar](20) NULL,
	[SALARIO] [decimal](8, 2) NULL,
	[CIUDAD] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[CEDULA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAQUETE]    Script Date: 26/8/2023 22:45:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAQUETE](
	[COD_PAQUETE] [varchar](10) NOT NULL,
	[DESCRIPCION] [varchar](30) NULL,
	[DESTINATARIO] [varchar](50) NULL,
	[DIRECCION_DESTINATARIO] [varchar](20) NULL,
	[CEDULA_CONDUCTOR] [varchar](10) NULL,
	[PROVINCIA_DESTINO] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[COD_PAQUETE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PROVINCIA]    Script Date: 26/8/2023 22:45:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PROVINCIA](
	[COD_PROVINCIA] [varchar](10) NOT NULL,
	[NOMBRE] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[COD_PROVINCIA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CONDUCE]  WITH CHECK ADD  CONSTRAINT [FK_CONDUCE_CEDULACONDUCTOR] FOREIGN KEY([CEDULA_CONDUCTOR])
REFERENCES [dbo].[CONDUCTOR] ([CEDULA])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CONDUCE] CHECK CONSTRAINT [FK_CONDUCE_CEDULACONDUCTOR]
GO
ALTER TABLE [dbo].[CONDUCE]  WITH CHECK ADD  CONSTRAINT [FK_CONDUCE_PLACACAMION] FOREIGN KEY([PLACA_CAMION])
REFERENCES [dbo].[CAMION] ([PLACA])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CONDUCE] CHECK CONSTRAINT [FK_CONDUCE_PLACACAMION]
GO
ALTER TABLE [dbo].[PAQUETE]  WITH CHECK ADD  CONSTRAINT [FK_PAQUETE_CEDULACONDUCTOR] FOREIGN KEY([CEDULA_CONDUCTOR])
REFERENCES [dbo].[CONDUCTOR] ([CEDULA])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PAQUETE] CHECK CONSTRAINT [FK_PAQUETE_CEDULACONDUCTOR]
GO
ALTER TABLE [dbo].[PAQUETE]  WITH CHECK ADD  CONSTRAINT [FK_PAQUETE_PROVINCIADESTINO] FOREIGN KEY([PROVINCIA_DESTINO])
REFERENCES [dbo].[PROVINCIA] ([COD_PROVINCIA])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PAQUETE] CHECK CONSTRAINT [FK_PAQUETE_PROVINCIADESTINO]
GO
/****** Object:  StoredProcedure [dbo].[pa_conductor_conduce_camion_por_placa]    Script Date: 26/8/2023 22:45:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_conductor_conduce_camion_por_placa]
  @placacamion NVARCHAR (15) = NULL,-- el tama-no m-aximo es 10, pero, en caso de que el usuario ingrese un
								  -- valor con longitud mayor que el permitido, se define con un tama-no 15. 
 								  -- Por otro lado, "nvarchar" soporta caracteres Unicode.
  @cantidad NUMERIC (4,0) = NULL OUTPUT --cantidad de coincidencias
    AS	  
	  BEGIN
	  -- Se verifica el n-umero de la placa, con un SP anidado.
	    DECLARE @pla INT
	    EXEC @pla= pa_validacionplaca @placa = @placacamion;
		BEGIN
		  IF @pla = 1 
		    BEGIN
			  SELECT 'El campo est-a vac-io. Ingrese una Placa.'
			  PRINT N'Intente otra vez'; --PRINT N'Intente otra vez'; -- Revisar la salida en la pesta-na "Mensajes".
			  RETURN --Esto ayuda a salir inmediatemente del SP.
			END;
								
		  ELSE
		    IF @pla = 2 
			  BEGIN
			    SELECT 'La placa '+@placacamion+ '..., no es correcta.'
								+'Debe tener entre 7 y 10 d-igitos.' 
				RETURN
			  END;
			ELSE
			  IF @pla = 3 
			    BEGIN
				  SELECT 'El veh-iculo ingresado no est-a registrado en el sistema.'
				  RETURN
				END;
			  ELSE
			    IF @pla = 4 
				  BEGIN
				    SELECT 'El cami-on todav-ia no ha sido utilizado.'
					RETURN
				  END;
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
/****** Object:  StoredProcedure [dbo].[pa_validacionplaca]    Script Date: 26/8/2023 22:45:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----modificacion "pa_validacionplaca"
CREATE PROC [dbo].[pa_validacionplaca]
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
