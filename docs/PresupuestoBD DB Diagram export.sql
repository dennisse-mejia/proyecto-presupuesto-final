CREATE TABLE [usuario] (
  [id_usuario] int PRIMARY KEY,
  [nombre] nvarchar(255),
  [apellido] nvarchar(255),
  [correo] nvarchar(255),
  [fecha_registro] date,
  [salario_mensual] decimal,
  [estado] nvarchar(255),
  [creado_por] nvarchar(255),
  [creado_en] datetime,
  [modificado_por] nvarchar(255),
  [modificado_en] datetime
)
GO

CREATE TABLE [categoria] (
  [id_categoria] int PRIMARY KEY,
  [id_usuario] int,
  [nombre] nvarchar(255),
  [descripcion] nvarchar(255),
  [tipo] nvarchar(255),
  [icono] nvarchar(255),
  [color] nvarchar(255),
  [orden] int,
  [creado_por] nvarchar(255),
  [creado_en] datetime,
  [modificado_por] nvarchar(255),
  [modificado_en] datetime
)
GO

CREATE TABLE [subcategoria] (
  [id_subcategoria] int PRIMARY KEY,
  [id_categoria] int,
  [nombre] nvarchar(255),
  [descripcion] nvarchar(255),
  [tipo] nvarchar(255),
  [estado] nvarchar(255),
  [creado_por] nvarchar(255),
  [creado_en] datetime,
  [modificado_por] nvarchar(255),
  [modificado_en] datetime
)
GO

CREATE TABLE [presupuesto] (
  [id_presupuesto] int PRIMARY KEY,
  [id_usuario] int,
  [nombre] nvarchar(255),
  [anio_inicio] int,
  [mes_inicio] int,
  [anio_fin] int,
  [mes_fin] int,
  [total_ingresos] decimal,
  [total_gastos] decimal,
  [total_ahorro] decimal,
  [fecha_creacion] datetime,
  [estado] nvarchar(255),
  [creado_por] nvarchar(255),
  [creado_en] datetime,
  [modificado_por] nvarchar(255),
  [modificado_en] datetime
)
GO

CREATE TABLE [presupuesto_detalle] (
  [id_detalle] int PRIMARY KEY,
  [id_presupuesto] int,
  [id_subcategoria] int,
  [monto_asignado] decimal,
  [monto_utilizado] decimal,
  [observaciones] nvarchar(255)
)
GO

CREATE TABLE [obligacion_fija] (
  [id_obligacion] int PRIMARY KEY,
  [id_usuario] int,
  [id_subcategoria] int UNIQUE,
  [monto] decimal,
  [fecha_registro] date,
  [estado] nvarchar(255),
  [creado_por] nvarchar(255),
  [creado_en] datetime,
  [modificado_por] nvarchar(255),
  [modificado_en] datetime
)
GO

CREATE TABLE [transaccion] (
  [id_transaccion] int PRIMARY KEY,
  [id_usuario] int,
  [id_presupuesto] int,
  [id_subcategoria] int,
  [id_obligacion] int,
  [tipo] nvarchar(255),
  [descripcion] nvarchar(255),
  [monto] decimal,
  [fecha] date,
  [medio_pago] nvarchar(255),
  [creado_por] nvarchar(255),
  [creado_en] datetime,
  [modificado_por] nvarchar(255),
  [modificado_en] datetime
)
GO

CREATE TABLE [meta_ahorro] (
  [id_meta] int PRIMARY KEY,
  [id_usuario] int,
  [id_subcategoria_ahorro] int,
  [nombre] nvarchar(255),
  [monto_objetivo] decimal,
  [monto_actual] decimal,
  [fecha_inicio] date,
  [fecha_limite] date,
  [estado] nvarchar(255),
  [creado_por] nvarchar(255),
  [creado_en] datetime,
  [modificado_por] nvarchar(255),
  [modificado_en] datetime
)
GO

ALTER TABLE [presupuesto] ADD FOREIGN KEY ([id_usuario]) REFERENCES [usuario] ([id_usuario])
GO

ALTER TABLE [categoria] ADD FOREIGN KEY ([id_usuario]) REFERENCES [usuario] ([id_usuario])
GO

ALTER TABLE [subcategoria] ADD FOREIGN KEY ([id_categoria]) REFERENCES [categoria] ([id_categoria])
GO

ALTER TABLE [presupuesto_detalle] ADD FOREIGN KEY ([id_presupuesto]) REFERENCES [presupuesto] ([id_presupuesto])
GO

ALTER TABLE [presupuesto_detalle] ADD FOREIGN KEY ([id_subcategoria]) REFERENCES [subcategoria] ([id_subcategoria])
GO

ALTER TABLE [obligacion_fija] ADD FOREIGN KEY ([id_usuario]) REFERENCES [usuario] ([id_usuario])
GO

ALTER TABLE [obligacion_fija] ADD FOREIGN KEY ([id_subcategoria]) REFERENCES [subcategoria] ([id_subcategoria])
GO

ALTER TABLE [transaccion] ADD FOREIGN KEY ([id_usuario]) REFERENCES [usuario] ([id_usuario])
GO

ALTER TABLE [transaccion] ADD FOREIGN KEY ([id_presupuesto]) REFERENCES [presupuesto] ([id_presupuesto])
GO

ALTER TABLE [transaccion] ADD FOREIGN KEY ([id_subcategoria]) REFERENCES [subcategoria] ([id_subcategoria])
GO

ALTER TABLE [transaccion] ADD FOREIGN KEY ([id_obligacion]) REFERENCES [obligacion_fija] ([id_obligacion])
GO

ALTER TABLE [meta_ahorro] ADD FOREIGN KEY ([id_usuario]) REFERENCES [usuario] ([id_usuario])
GO

ALTER TABLE [meta_ahorro] ADD FOREIGN KEY ([id_subcategoria_ahorro]) REFERENCES [subcategoria] ([id_subcategoria])
GO
