USE ProyectoBD;
GO

SET NOCOUNT ON;

-- USUARIO

INSERT INTO usuario
(
    nombre, apellido, correo,
    fecha_registro, salario_mensual, estado,
    creado_por, creado_en, modificado_por, modificado_en
)
VALUES
(
    N'Ana', N'Lopez', N'ana.lopez@gmail.com',
    '2025-01-01', 25000.00, N'ACTIVO',
    N'sistema', '2025-01-01', NULL, NULL
);


-- CATEGORIAS PARA EL USUARIO 1
-- 1: Ingresos
-- 2: Gastos fijos
-- 3: Gastos variables
-- 4: Ahorro

INSERT INTO categoria
(
    id_usuario, nombre, descripcion, tipo, icono, color, orden,
    creado_por, creado_en, modificado_por, modificado_en
)
VALUES
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    N'Ingresos',
    N'Entradas de dinero recurrentes u ocasionales',
    N'INGRESO',
    N'bi-cash', N'#4CAF50', 1,
    N'sistema', '2025-01-01', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    N'Gastos fijos',
    N'Pagos mensuales obligatorios',
    N'GASTO',
    N'bi-house', N'#F44336', 2,
    N'sistema', '2025-01-01', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    N'Gastos variables',
    N'Gastos del dia a dia',
    N'GASTO',
    N'bi-cart', N'#FF9800', 3,
    N'sistema', '2025-01-01', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    N'Ahorro',
    N'Metas y reservas de dinero',
    N'AHORRO',
    N'bi-piggy-bank', N'#2196F3', 4,
    N'sistema', '2025-01-01', NULL, NULL
);


-- SUBCATEGORIAS
-- (id_categoria)
-- 1  Salario mensual        (Ingresos)
-- 2  Ingresos freelance     (Ingresos)
-- 3  Renta apartamento      (Gastos fijos)
-- 4  Servicios publicos     (Gastos fijos)
-- 5  Internet y streaming   (Gastos fijos)
-- 6  Supermercado           (Gastos variables)
-- 7  Transporte             (Gastos variables)
-- 8  Restaurantes           (Gastos variables)
-- 9  Fondo de emergencia    (Ahorro)
-- 10 Viaje de vacaciones    (Ahorro)

INSERT INTO subcategoria
(
    id_categoria, nombre, descripcion, tipo, estado,
    creado_por, creado_en, modificado_por, modificado_en
)
VALUES
(1, N'Salario mensual',      N'Sueldo base de la empresa',        N'INGRESO', N'ACTIVO', N'sistema', '2025-01-01', NULL, NULL),
(1, N'Ingresos freelance',   N'Trabajos adicionales ocasionales', N'INGRESO', N'ACTIVO', N'sistema', '2025-01-01', NULL, NULL),

(2, N'Renta apartamento',    N'Alquiler mensual de vivienda',     N'GASTO',   N'ACTIVO', N'sistema', '2025-01-01', NULL, NULL),
(2, N'Servicios públicos',   N'Agua y energía eléctrica',        N'GASTO',   N'ACTIVO', N'sistema', '2025-01-01', NULL, NULL),
(2, N'Internet y streaming', N'Internet, Netflix, etc.',         N'GASTO',   N'ACTIVO', N'sistema', '2025-01-01', NULL, NULL),

(3, N'Supermercado',         N'Compras de comida y hogar',       N'GASTO',   N'ACTIVO', N'sistema', '2025-01-01', NULL, NULL),
(3, N'Transporte',           N'Gasolina, Uber, bus',             N'GASTO',   N'ACTIVO', N'sistema', '2025-01-01', NULL, NULL),
(3, N'Restaurantes',         N'Comidas fuera de casa',           N'GASTO',   N'ACTIVO', N'sistema', '2025-01-01', NULL, NULL),

(4, N'Fondo de emergencia',  N'Ahorro para imprevistos',         N'AHORRO',  N'ACTIVO', N'sistema', '2025-01-01', NULL, NULL),
(4, N'Viaje de vacaciones',  N'Ahorro para viaje de playa',      N'AHORRO',  N'ACTIVO', N'sistema', '2025-01-01', NULL, NULL);


-- PRESUPUESTOS (ENERO Y FEBRERO 2025)
-- id_presupuesto: 1= Enero, 2= Febrero

INSERT INTO presupuesto
(
    id_usuario, nombre,
    anio_inicio, mes_inicio, anio_fin, mes_fin,
    total_ingresos, total_gastos, total_ahorro,
    fecha_creacion, estado,
    creado_por, creado_en, modificado_por, modificado_en
)
VALUES
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    N'Presupuesto Enero 2025',
    2025, 1, 2025, 1,
    0.00, 0.00, 0.00,
    '2025-01-01', N'ACTIVO',
    N'sistema', '2025-01-01', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    N'Presupuesto Febrero 2025',
    2025, 2, 2025, 2,
    0.00, 0.00, 0.00,
    '2025-02-01', N'ACTIVO',
    N'sistema', '2025-02-01', NULL, NULL
);


 -- PRESUPUESTO_DETALLE
-- Montos asignados por subcategoria en cada mes

 -- Enero 2025 (id_presupuesto= 1)
INSERT INTO presupuesto_detalle
(
    id_presupuesto, id_subcategoria,
    monto_asignado, monto_utilizado, observaciones,
    creado_por, creado_en, modificado_por, modificado_en
)
VALUES
(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    1, 25000.00, 25000.00, N'Salario esperado enero',
    N'sistema', '2025-01-01', NULL, NULL
),
(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    2, 5000.00, 3000.00, N'Ingresos adicionales estimados',
    N'sistema', '2025-01-01', NULL, NULL
),

(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    3, 8000.00, 8000.00, N'Renta apartamento enero',
    N'sistema', '2025-01-01', NULL, NULL
),
(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    4, 1500.00, 1400.00, N'Servicios públicos enero',
    N'sistema', '2025-01-01', NULL, NULL
),
(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    5, 800.00, 800.00, N'Internet y streaming enero',
    N'sistema', '2025-01-01', NULL, NULL
),

(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    6, 4000.00, 3800.00, N'Supermercado enero',
    N'sistema', '2025-01-01', NULL, NULL
),
(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    7, 1200.00, 1100.00, N'Transporte enero',
    N'sistema', '2025-01-01', NULL, NULL
),
(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    8, 1500.00, 1600.00, N'Restaurantes enero',
    N'sistema', '2025-01-01', NULL, NULL
),

(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    9, 2000.00, 2000.00, N'Ahorro fondo emergencia enero',
    N'sistema', '2025-01-01', NULL, NULL
),
(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    10, 1500.00, 500.00, N'Ahorro viaje enero',
    N'sistema', '2025-01-01', NULL, NULL
);


-- Febrero 2025 (id_presupuesto= 2)
INSERT INTO presupuesto_detalle
(
    id_presupuesto, id_subcategoria,
    monto_asignado, monto_utilizado, observaciones,
    creado_por, creado_en, modificado_por, modificado_en
)
VALUES
(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    1, 25000.00, 25000.00, N'Salario esperado febrero',
    N'sistema', '2025-02-01', NULL, NULL
),
(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    2, 4000.00, 2500.00, N'Ingresos freelance febrero',
    N'sistema', '2025-02-01', NULL, NULL
),

(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    3, 8000.00, 8000.00, N'Renta apartamento febrero',
    N'sistema', '2025-02-01', NULL, NULL
),
(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    4, 1500.00, 1450.00, N'Servicios públicos febrero',
    N'sistema', '2025-02-01', NULL, NULL
),
(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    5, 800.00, 800.00, N'Internet y streaming febrero',
    N'sistema', '2025-02-01', NULL, NULL
),

(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    6, 4200.00, 3900.00, N'Supermercado febrero',
    N'sistema', '2025-02-01', NULL, NULL
),
(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    7, 1300.00, 1200.00, N'Transporte febrero',
    N'sistema', '2025-02-01', NULL, NULL
),
(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    8, 1600.00, 1500.00, N'Restaurantes febrero',
    N'sistema', '2025-02-01', NULL, NULL
),

(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    9, 2500.00, 2300.00, N'Ahorro fondo emergencia febrero',
    N'sistema', '2025-02-01', NULL, NULL
),
(
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    10, 2000.00, 1200.00, N'Ahorro viaje febrero',
    N'sistema', '2025-02-01', NULL, NULL
);


-- OBLIGACIONES FIJAS
-- Cada subcategoria es unica en esta tabla
-- id_obligacion: 1= Renta, 2= Servicios, 3= Internet

INSERT INTO obligacion_fija
(
    id_usuario, id_subcategoria,
    monto, fecha_registro, estado,
    creado_por, creado_en, modificado_por, modificado_en
)
VALUES
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    3, 8000.00, '2025-01-01', N'ACTIVA',
    N'sistema', '2025-01-01', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    4, 1500.00, '2025-01-01', N'ACTIVA',
    N'sistema', '2025-01-01', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    5, 800.00, '2025-01-01', N'ACTIVA',
    N'sistema', '2025-01-01', NULL, NULL
);


-- METAS DE AHORRO
-- id_subcategoria_ahorro: 9= Fondo emerg, 10= Viaje

INSERT INTO meta_ahorro
(
    id_usuario, id_subcategoria_ahorro,
    nombre, monto_objetivo, monto_actual,
    fecha_inicio, fecha_limite, estado,
    creado_por, creado_en, modificado_por, modificado_en
)
VALUES
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    9, N'Fondo de emergencia',
    20000.00, 5000.00,
    '2025-01-01', '2025-12-31', N'EN_PROGRESO',
    N'sistema', '2025-01-01', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    10, N'Viaje a la playa',
    15000.00, 3000.00,
    '2025-01-01', '2025-08-31', N'EN_PROGRESO',
    N'sistema', '2025-01-01', NULL, NULL
);


-- TRANSACCIONES
-- Dos meses: Enero y Febrero 2025
-- tipo: 'INGRESO', 'GASTO', 'AHORRO'

-- ENERO 2025 (id_presupuesto= 1)
INSERT INTO transaccion
(
    id_usuario, id_presupuesto, id_subcategoria, id_obligacion,
    tipo, descripcion, monto, fecha, medio_pago,
    creado_por, creado_en, modificado_por, modificado_en
)
VALUES

-- INGRESOS
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    1, NULL, N'INGRESO', N'Salario enero', 25000.00,
    '2025-01-01', N'Transferencia',
    N'sistema', '2025-01-01', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    2, NULL, N'INGRESO', N'Proyecto freelance A', 2000.00,
    '2025-01-10', N'Transferencia',
    N'sistema', '2025-01-10', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    2, NULL, N'INGRESO', N'Proyecto freelance B', 1000.00,
    '2025-01-20', N'Transferencia',
    N'sistema', '2025-01-20', NULL, NULL
),

-- GASTOS FIJOS (con obligaciones)
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    3, 1, N'GASTO', N'Renta enero', 8000.00,
    '2025-01-05', N'Transferencia',
    N'sistema', '2025-01-05', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    4, 2, N'GASTO', N'Recibo luz y agua enero', 1500.00,
    '2025-01-06', N'Tarjeta débito',
    N'sistema', '2025-01-06', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    5, 3, N'GASTO', N'Internet y streaming ene', 800.00,
    '2025-01-07', N'Tarjeta crédito',
    N'sistema', '2025-01-07', NULL, NULL
),

-- GASTOS VARIABLES
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    6, NULL, N'GASTO', N'Compra supermercado 1', 1200.00,
    '2025-01-04', N'Tarjeta débito',
    N'sistema', '2025-01-04', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    6, NULL, N'GASTO', N'Compra supermercado 2', 1400.00,
    '2025-01-12', N'Tarjeta débito',
    N'sistema', '2025-01-12', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    6, NULL, N'GASTO', N'Compra supermercado 3', 1200.00,
    '2025-01-22', N'Tarjeta débito',
    N'sistema', '2025-01-22', NULL, NULL
),

(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    7, NULL, N'GASTO', N'Uber y transporte 1', 500.00,
    '2025-01-03', N'Efectivo',
    N'sistema', '2025-01-03', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    7, NULL, N'GASTO', N'Gasolina', 600.00,
    '2025-01-15', N'Tarjeta débito',
    N'sistema', '2025-01-15', NULL, NULL
),

(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    8, NULL, N'GASTO', N'Cena con amigos', 900.00,
    '2025-01-08', N'Tarjeta crédito',
    N'sistema', '2025-01-08', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    8, NULL, N'GASTO', N'Almuerzo fin de semana', 700.00,
    '2025-01-19', N'Tarjeta débito',
    N'sistema', '2025-01-19', NULL, NULL
),

-- AHORRO
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    9, NULL, N'AHORRO', N'Aporte fondo emergencia', 1000.00,
    '2025-01-03', N'Transferencia',
    N'sistema', '2025-01-03', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    9, NULL, N'AHORRO', N'Aporte fondo emergencia', 1000.00,
    '2025-01-18', N'Transferencia',
    N'sistema', '2025-01-18', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Enero 2025' ORDER BY id_presupuesto),
    10, NULL, N'AHORRO', N'Ahorro viaje playa', 500.00,
    '2025-01-20', N'Transferencia',
    N'sistema', '2025-01-20', NULL, NULL
);


-- FEBRERO 2025 (id_presupuesto= 2)
INSERT INTO transaccion
(
    id_usuario, id_presupuesto, id_subcategoria, id_obligacion,
    tipo, descripcion, monto, fecha, medio_pago,
    creado_por, creado_en, modificado_por, modificado_en
)
VALUES

-- INGRESOS
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    1, NULL, N'INGRESO', N'Salario febrero', 25000.00,
    '2025-02-01', N'Transferencia',
    N'sistema', '2025-02-01', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    2, NULL, N'INGRESO', N'Proyecto freelance C', 1500.00,
    '2025-02-05', N'Transferencia',
    N'sistema', '2025-02-05', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    2, NULL, N'INGRESO', N'Proyecto freelance D', 1000.00,
    '2025-02-18', N'Transferencia',
    N'sistema', '2025-02-18', NULL, NULL
),

-- GASTOS FIJOS
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    3, 1, N'GASTO', N'Renta febrero', 8000.00,
    '2025-02-05', N'Transferencia',
    N'sistema', '2025-02-05', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    4, 2, N'GASTO', N'Recibo luz y agua febrero', 1450.00,
    '2025-02-06', N'Tarjeta débito',
    N'sistema', '2025-02-06', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    5, 3, N'GASTO', N'Internet y streaming feb', 800.00,
    '2025-02-07', N'Tarjeta crédito',
    N'sistema', '2025-02-07', NULL, NULL
),

-- GASTOS VARIABLES
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    6, NULL, N'GASTO', N'Compra supermercado 1', 1400.00,
    '2025-02-03', N'Tarjeta débito',
    N'sistema', '2025-02-03', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    6, NULL, N'GASTO', N'Compra supermercado 2', 1300.00,
    '2025-02-14', N'Tarjeta débito',
    N'sistema', '2025-02-14', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    6, NULL, N'GASTO', N'Compra supermercado 3', 1200.00,
    '2025-02-24', N'Tarjeta débito',
    N'sistema', '2025-02-24', NULL, NULL
),

(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    7, NULL, N'GASTO', N'Uber y transporte 1', 550.00,
    '2025-02-04', N'Efectivo',
    N'sistema', '2025-02-04', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    7, NULL, N'GASTO', N'Gasolina febrero', 650.00,
    '2025-02-16', N'Tarjeta débito',
    N'sistema', '2025-02-16', NULL, NULL
),

(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    8, NULL, N'GASTO', N'Cena de San Valentín', 950.00,
    '2025-02-14', N'Tarjeta crédito',
    N'sistema', '2025-02-14', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    8, NULL, N'GASTO', N'Brunch fin de semana', 550.00,
    '2025-02-23', N'Tarjeta débito',
    N'sistema', '2025-02-23', NULL, NULL
),

-- AHORRO
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    9, NULL, N'AHORRO', N'Aporte fondo emergencia', 1200.00,
    '2025-02-02', N'Transferencia',
    N'sistema', '2025-02-02', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    9, NULL, N'AHORRO', N'Aporte fondo emergencia', 1100.00,
    '2025-02-20', N'Transferencia',
    N'sistema', '2025-02-20', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    10, NULL, N'AHORRO', N'Ahorro viaje playa', 700.00,
    '2025-02-10', N'Transferencia',
    N'sistema', '2025-02-10', NULL, NULL
),
(
    (SELECT TOP (1) id_usuario FROM usuario WHERE correo = N'ana.lopez@gmail.com' ORDER BY id_usuario),
    (SELECT TOP (1) id_presupuesto FROM presupuesto WHERE nombre = N'Presupuesto Febrero 2025' ORDER BY id_presupuesto),
    10, NULL, N'AHORRO', N'Ahorro viaje playa', 500.00,
    '2025-02-25', N'Transferencia',
    N'sistema', '2025-02-25', NULL, NULL
);
