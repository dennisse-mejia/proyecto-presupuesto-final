-- 1. CREAR BD --

IF DB_ID('ProyectoBD') IS NULL
BEGIN
    CREATE DATABASE ProyectoBD;
END;
GO

USE ProyectoBD;
GO

-- 2. TABLA USUARIO --

IF OBJECT_ID('usuario', 'U') IS NOT NULL
    DROP TABLE usuario;
GO

CREATE TABLE [usuario] (
  [id_usuario]      int IDENTITY(1,1) PRIMARY KEY,
  [nombre]          nvarchar(255) NOT NULL,
  [apellido]        nvarchar(255) NOT NULL,
  [correo]          nvarchar(255) NOT NULL,
  [fecha_registro]  date NOT NULL,
  [salario_mensual] decimal(12,2) NOT NULL,
  [estado]          nvarchar(50) NOT NULL,
  [creado_por]      nvarchar(255) NOT NULL,
  [creado_en]       datetime NOT NULL,
  [modificado_por]  nvarchar(255) NULL,
  [modificado_en]   datetime NULL
);
GO

-- 3. TABLA CATEGORIA

IF OBJECT_ID('categoria', 'U') IS NOT NULL
    DROP TABLE categoria;
GO

CREATE TABLE [categoria] (
  [id_categoria] int IDENTITY(1,1) PRIMARY KEY,
  [id_usuario] int NOT NULL,
  [nombre]       nvarchar(255) NOT NULL,
  [descripcion]  nvarchar(255) NULL,
  -- ingreso/gasto/ahorro
  [tipo]         nvarchar(50) NOT NULL, 
  [icono]        nvarchar(255) NULL,
  [color]        nvarchar(50) NULL,
  [orden]        int NULL,
  [creado_por]   nvarchar(255) NOT NULL,
  [creado_en]    datetime NOT NULL,
  [modificado_por] nvarchar(255) NULL,
  [modificado_en]  datetime NULL
);
GO

ALTER TABLE [categoria]
ADD CONSTRAINT FK_categoria_usuario
FOREIGN KEY ([id_usuario]) REFERENCES [usuario]([id_usuario]);
GO

CREATE INDEX IX_categoria_id_usuario ON categoria(id_usuario);
GO

-- 4. TABLA SUBCATEGORIA --

IF OBJECT_ID('subcategoria', 'U') IS NOT NULL
    DROP TABLE subcategoria;
GO

CREATE TABLE [subcategoria] (
  [id_subcategoria] int IDENTITY(1,1) PRIMARY KEY,
  [id_categoria]    int NOT NULL,
  [nombre]          nvarchar(255) NOT NULL,
  [descripcion]     nvarchar(255) NULL,
  -- ingreso/gasto/ahorro
  [tipo]            nvarchar(50) NOT NULL, 
  [estado]          nvarchar(50) NOT NULL,
  [creado_por]      nvarchar(255) NOT NULL,
  [creado_en]       datetime NOT NULL,
  [modificado_por]  nvarchar(255) NULL,
  [modificado_en]   datetime NULL
);
GO

ALTER TABLE [subcategoria]
ADD CONSTRAINT FK_subcategoria_categoria
FOREIGN KEY ([id_categoria]) REFERENCES [categoria]([id_categoria]);
GO

CREATE INDEX IX_subcategoria_id_categoria ON subcategoria(id_categoria);
GO

-- 5. TABLA PRESUPUESTO --

IF OBJECT_ID('presupuesto', 'U') IS NOT NULL
    DROP TABLE presupuesto;
GO

CREATE TABLE [presupuesto] (
  [id_presupuesto] int IDENTITY(1,1) PRIMARY KEY,
  [id_usuario]     int NOT NULL,
  [nombre]         nvarchar(255) NOT NULL,
  [anio_inicio]    int NOT NULL,
  [mes_inicio]     int NOT NULL,
  [anio_fin]       int NOT NULL,
  [mes_fin]        int NOT NULL,
  [total_ingresos] decimal(12,2) NOT NULL,
  [total_gastos]   decimal(12,2) NOT NULL,
  [total_ahorro]   decimal(12,2) NOT NULL,
  [fecha_creacion] datetime NOT NULL,
  [estado]         nvarchar(50) NOT NULL,
  [creado_por]     nvarchar(255) NOT NULL,
  [creado_en]      datetime NOT NULL,
  [modificado_por] nvarchar(255) NULL,
  [modificado_en]  datetime NULL
);
GO

ALTER TABLE [presupuesto]
ADD CONSTRAINT FK_presupuesto_usuario
FOREIGN KEY ([id_usuario]) REFERENCES [usuario]([id_usuario]);
GO

CREATE INDEX IX_presupuesto_id_usuario ON presupuesto(id_usuario);
GO

-- 6. TABLA PRESUPUESTO_DETALLE --

IF OBJECT_ID('presupuesto_detalle', 'U') IS NOT NULL
    DROP TABLE presupuesto_detalle;
GO

CREATE TABLE [presupuesto_detalle] (
  [id_detalle]      int IDENTITY(1,1) PRIMARY KEY,
  [id_presupuesto]  int NOT NULL,
  [id_subcategoria] int NOT NULL,
  [monto_asignado]  decimal(12,2) NOT NULL,
  [monto_utilizado] decimal(12,2) NULL,
  [observaciones]   nvarchar(255) NULL,
  [creado_por]      nvarchar(255) NOT NULL,
  [creado_en]       datetime NOT NULL,
  [modificado_por]  nvarchar(255) NULL,
  [modificado_en]   datetime NULL
);
GO

ALTER TABLE [presupuesto_detalle]
ADD CONSTRAINT FK_detalle_presupuesto
FOREIGN KEY ([id_presupuesto]) REFERENCES [presupuesto]([id_presupuesto]);
GO

ALTER TABLE [presupuesto_detalle]
ADD CONSTRAINT FK_detalle_subcategoria
FOREIGN KEY ([id_subcategoria]) REFERENCES [subcategoria]([id_subcategoria]);
GO

CREATE INDEX IX_detalle_id_presupuesto ON presupuesto_detalle(id_presupuesto);
CREATE INDEX IX_detalle_id_subcategoria ON presupuesto_detalle(id_subcategoria);
GO

-- 7. TABLA OBLIGACION_FIJA --

IF OBJECT_ID('obligacion_fija', 'U') IS NOT NULL
    DROP TABLE obligacion_fija;
GO

CREATE TABLE [obligacion_fija] (
  [id_obligacion]   int IDENTITY(1,1) PRIMARY KEY,
  [id_usuario]      int NOT NULL,
  [id_subcategoria] int NOT NULL UNIQUE, 
  [monto]           decimal(12,2) NOT NULL,
  [fecha_registro]  date NOT NULL,
  [estado]          nvarchar(50) NOT NULL,
  [creado_por]      nvarchar(255) NOT NULL,
  [creado_en]       datetime NOT NULL,
  [modificado_por]  nvarchar(255) NULL,
  [modificado_en]   datetime NULL
);
GO

ALTER TABLE [obligacion_fija]
ADD CONSTRAINT FK_obligacion_usuario
FOREIGN KEY ([id_usuario]) REFERENCES [usuario]([id_usuario]);
GO

ALTER TABLE [obligacion_fija]
ADD CONSTRAINT FK_obligacion_subcategoria
FOREIGN KEY ([id_subcategoria]) REFERENCES [subcategoria]([id_subcategoria]);
GO

CREATE INDEX IX_obligacion_id_usuario ON obligacion_fija(id_usuario);
GO

-- 8. TABLA TRANSACCION --

IF OBJECT_ID('transaccion', 'U') IS NOT NULL
    DROP TABLE transaccion;
GO

CREATE TABLE [transaccion] (
  [id_transaccion] int IDENTITY(1,1) PRIMARY KEY,
  [id_usuario]     int NOT NULL,
  [id_presupuesto] int NOT NULL,
  [id_subcategoria] int NOT NULL,
  [id_obligacion]  int NULL,
  [tipo]           nvarchar(50) NOT NULL,
  [descripcion]    nvarchar(255) NULL,
  [monto]          decimal(12,2) NOT NULL,
  [fecha]          date NOT NULL,
  [medio_pago]     nvarchar(255) NULL,
  [creado_por]     nvarchar(255) NOT NULL,
  [creado_en]      datetime NOT NULL,
  [modificado_por] nvarchar(255) NULL,
  [modificado_en]  datetime NULL
);
GO

ALTER TABLE [transaccion]
ADD CONSTRAINT FK_transaccion_usuario
FOREIGN KEY ([id_usuario]) REFERENCES [usuario]([id_usuario]);
GO

ALTER TABLE [transaccion]
ADD CONSTRAINT FK_transaccion_presupuesto
FOREIGN KEY ([id_presupuesto]) REFERENCES [presupuesto]([id_presupuesto]);
GO

ALTER TABLE [transaccion]
ADD CONSTRAINT FK_transaccion_subcategoria
FOREIGN KEY ([id_subcategoria]) REFERENCES [subcategoria]([id_subcategoria]);
GO

ALTER TABLE [transaccion]
ADD CONSTRAINT FK_transaccion_obligacion
FOREIGN KEY ([id_obligacion]) REFERENCES [obligacion_fija]([id_obligacion]);
GO

CREATE INDEX IX_transaccion_id_usuario      ON transaccion(id_usuario);
CREATE INDEX IX_transaccion_id_presupuesto  ON transaccion(id_presupuesto);
CREATE INDEX IX_transaccion_id_subcategoria ON transaccion(id_subcategoria);
CREATE INDEX IX_transaccion_id_obligacion   ON transaccion(id_obligacion);
GO

-- 9. TABLA META_AHORRO --

IF OBJECT_ID('meta_ahorro', 'U') IS NOT NULL
    DROP TABLE meta_ahorro;
GO

CREATE TABLE [meta_ahorro] (
  [id_meta]               int IDENTITY(1,1) PRIMARY KEY,
  [id_usuario]            int NOT NULL,
  [id_subcategoria_ahorro] int NOT NULL,
  [nombre]                nvarchar(255) NOT NULL,
  [monto_objetivo]        decimal(12,2) NOT NULL,
  [monto_actual]          decimal(12,2) NULL,
  [fecha_inicio]          date NOT NULL,
  [fecha_limite]          date NULL,
  [estado]                nvarchar(50) NOT NULL,
  [creado_por]            nvarchar(255) NOT NULL,
  [creado_en]             datetime NOT NULL,
  [modificado_por]        nvarchar(255) NULL,
  [modificado_en]         datetime NULL
);
GO

ALTER TABLE [meta_ahorro]
ADD CONSTRAINT FK_meta_usuario
FOREIGN KEY ([id_usuario]) REFERENCES [usuario]([id_usuario]);
GO

ALTER TABLE [meta_ahorro]
ADD CONSTRAINT FK_meta_subcategoria
FOREIGN KEY ([id_subcategoria_ahorro]) REFERENCES [subcategoria]([id_subcategoria]);
GO

CREATE INDEX IX_meta_id_usuario      ON meta_ahorro(id_usuario);
CREATE INDEX IX_meta_id_subcategoria ON meta_ahorro(id_subcategoria_ahorro);
GO
