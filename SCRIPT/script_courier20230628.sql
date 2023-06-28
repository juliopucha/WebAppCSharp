USE [Courier]
GO
ALTER TABLE [PAQUETE] DROP CONSTRAINT [FK_PAQUETE_PROVINCIADESTINO]
GO
ALTER TABLE [PAQUETE] DROP CONSTRAINT [FK_PAQUETE_CEDULACONDUCTOR]
GO
ALTER TABLE [CONDUCE] DROP CONSTRAINT [FK_CONDUCE_PLACACAMION]
GO
ALTER TABLE [CONDUCE] DROP CONSTRAINT [FK_CONDUCE_CEDULACONDUCTOR]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PROVINCIA]') AND type in (N'U'))
DROP TABLE [PROVINCIA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAQUETE]') AND type in (N'U'))
DROP TABLE [PAQUETE]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CONDUCTOR]') AND type in (N'U'))
DROP TABLE [CONDUCTOR]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CONDUCE]') AND type in (N'U'))
DROP TABLE [CONDUCE]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CAMION]') AND type in (N'U'))
DROP TABLE [CAMION]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CAMION](
	[PLACA] [varchar](10) NOT NULL,
	[MODELO] [varchar](15) NULL,
	[TIPO] [varchar](15) NULL,
	[POTENCIA] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[PLACA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CONDUCE](
	[CEDULA_CONDUCTOR] [varchar](10) NOT NULL,
	[PLACA_CAMION] [varchar](10) NOT NULL,
	[FECHA] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CEDULA_CONDUCTOR] ASC,
	[PLACA_CAMION] ASC,
	[FECHA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CONDUCTOR](
	[CEDULA] [varchar](10) NOT NULL,
	[NOMBRE] [varchar](50) NULL,
	[TELEFONO] [varchar](15) NULL,
	[DIRECCION] [varchar](20) NULL,
	[SALARIO] [decimal](8, 2) NULL,
	[CIUDAD] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[CEDULA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PAQUETE](
	[COD_PAQUETE] [varchar](10) NOT NULL,
	[DESCRIPCION] [varchar](30) NULL,
	[DESTINATARIO] [varchar](50) NULL,
	[DIRECCION_DESTINATARIO] [varchar](20) NULL,
	[CEDULA_CONDUCTOR] [varchar](10) NULL,
	[PROVINCIA_DESTINO] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[COD_PAQUETE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROVINCIA](
	[COD_PROVINCIA] [varchar](10) NOT NULL,
	[NOMBRE] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[COD_PROVINCIA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [CAMION] ([PLACA], [MODELO], [TIPO], [POTENCIA]) VALUES (N'FK-1010', N'HINO FC 1021', N'2DB', N'70,13')
INSERT [CAMION] ([PLACA], [MODELO], [TIPO], [POTENCIA]) VALUES (N'GED-1234', N'HINO GD 1226', N'4-C', N'133,88')
INSERT [CAMION] ([PLACA], [MODELO], [TIPO], [POTENCIA]) VALUES (N'PCR-0123', N'HINO FD 1021', N'S3', N'102,00')
GO
INSERT [CONDUCE] ([CEDULA_CONDUCTOR], [PLACA_CAMION], [FECHA]) VALUES (N'123456787', N'GED-1234', CAST(N'2023-06-20T00:00:00.000' AS DateTime))
INSERT [CONDUCE] ([CEDULA_CONDUCTOR], [PLACA_CAMION], [FECHA]) VALUES (N'123456788', N'FK-1010', CAST(N'2023-06-18T00:00:00.000' AS DateTime))
INSERT [CONDUCE] ([CEDULA_CONDUCTOR], [PLACA_CAMION], [FECHA]) VALUES (N'123456789', N'FK-1010', CAST(N'2023-06-16T00:00:00.000' AS DateTime))
GO
INSERT [CONDUCTOR] ([CEDULA], [NOMBRE], [TELEFONO], [DIRECCION], [SALARIO], [CIUDAD]) VALUES (N'123456787', N'JEAN PERALTA', N'2598498', N'CALLE SE-20', CAST(920000.00 AS Decimal(8, 2)), N'QUITO')
INSERT [CONDUCTOR] ([CEDULA], [NOMBRE], [TELEFONO], [DIRECCION], [SALARIO], [CIUDAD]) VALUES (N'123456788', N'JAIME PERLA', N'3598498', N'CALLE SO-30', CAST(910000.00 AS Decimal(8, 2)), N'QUITO')
INSERT [CONDUCTOR] ([CEDULA], [NOMBRE], [TELEFONO], [DIRECCION], [SALARIO], [CIUDAD]) VALUES (N'123456789', N'JUAN PEREZ', N'4598498', N'CALLE N-20', CAST(900000.00 AS Decimal(8, 2)), N'QUITO')
GO
INSERT [PAQUETE] ([COD_PAQUETE], [DESCRIPCION], [DESTINATARIO], [DIRECCION_DESTINATARIO], [CEDULA_CONDUCTOR], [PROVINCIA_DESTINO]) VALUES (N'53434', N'CARTON CON MEDICINA NATURAL', N'JAVIER SANDOVAL', N'CALLE S/N 9', N'123456789', N'8080')
INSERT [PAQUETE] ([COD_PAQUETE], [DESCRIPCION], [DESTINATARIO], [DIRECCION_DESTINATARIO], [CEDULA_CONDUCTOR], [PROVINCIA_DESTINO]) VALUES (N'53435', N'PCB FUENTE 3-OUT', N'FERNANDO BOILESTAD', N'AV. 9 DE OCTUBRE', N'123456788', N'8080')
INSERT [PAQUETE] ([COD_PAQUETE], [DESCRIPCION], [DESTINATARIO], [DIRECCION_DESTINATARIO], [CEDULA_CONDUCTOR], [PROVINCIA_DESTINO]) VALUES (N'53436', N'1PAR DE ZAPATILLA ADULTO-H', N'PEDRO HINOSTROZA', N'ORIENTE ENTRE43 Y 46', N'123456787', N'6060')
INSERT [PAQUETE] ([COD_PAQUETE], [DESCRIPCION], [DESTINATARIO], [DIRECCION_DESTINATARIO], [CEDULA_CONDUCTOR], [PROVINCIA_DESTINO]) VALUES (N'53437', N'2 CHAQUETA-M', N'JESSENIA ZAMBRANO CORDERO', N'AV. 25 DE JULIO', N'123456789', N'6060')
GO
INSERT [PROVINCIA] ([COD_PROVINCIA], [NOMBRE]) VALUES (N'4040', N'LOJA')
INSERT [PROVINCIA] ([COD_PROVINCIA], [NOMBRE]) VALUES (N'5050', N'IMBABURA')
INSERT [PROVINCIA] ([COD_PROVINCIA], [NOMBRE]) VALUES (N'6060', N'GUAYAS')
INSERT [PROVINCIA] ([COD_PROVINCIA], [NOMBRE]) VALUES (N'7070', N'AZUAY')
INSERT [PROVINCIA] ([COD_PROVINCIA], [NOMBRE]) VALUES (N'8080', N'PICHINCHA')
GO
ALTER TABLE [CONDUCE]  WITH CHECK ADD  CONSTRAINT [FK_CONDUCE_CEDULACONDUCTOR] FOREIGN KEY([CEDULA_CONDUCTOR])
REFERENCES [CONDUCTOR] ([CEDULA])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [CONDUCE] CHECK CONSTRAINT [FK_CONDUCE_CEDULACONDUCTOR]
GO
ALTER TABLE [CONDUCE]  WITH CHECK ADD  CONSTRAINT [FK_CONDUCE_PLACACAMION] FOREIGN KEY([PLACA_CAMION])
REFERENCES [CAMION] ([PLACA])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [CONDUCE] CHECK CONSTRAINT [FK_CONDUCE_PLACACAMION]
GO
ALTER TABLE [PAQUETE]  WITH CHECK ADD  CONSTRAINT [FK_PAQUETE_CEDULACONDUCTOR] FOREIGN KEY([CEDULA_CONDUCTOR])
REFERENCES [CONDUCTOR] ([CEDULA])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [PAQUETE] CHECK CONSTRAINT [FK_PAQUETE_CEDULACONDUCTOR]
GO
ALTER TABLE [PAQUETE]  WITH CHECK ADD  CONSTRAINT [FK_PAQUETE_PROVINCIADESTINO] FOREIGN KEY([PROVINCIA_DESTINO])
REFERENCES [PROVINCIA] ([COD_PROVINCIA])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [PAQUETE] CHECK CONSTRAINT [FK_PAQUETE_PROVINCIADESTINO]
GO
