USE ProyectoBD;
GO

-- CRUD SUBCATEGORIA
-- Tabla Subcategoria

-- sp_subcategoria_insert
-- Crear subcategoría

CREATE OR ALTER PROCEDURE sp_subcategoria_insert
(
    @id_categoria  INT,
    @nombre        NVARCHAR(100),
    @descripcion   NVARCHAR(255) = NULL,
    @tipo          NVARCHAR(20),
    @estado        NVARCHAR(20),
    @creado_por    NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO subcategoria
    (
        id_categoria,
        nombre,
        descripcion,
        tipo,
        estado,
        creado_por,
        creado_en,
        modificado_por,
        modificado_en
    )
    VALUES
    (
        @id_categoria,
        @nombre,
        @descripcion,
        @tipo,
        @estado,
        @creado_por,
        SYSDATETIME(),
        NULL,
        NULL
    );

    SELECT SCOPE_IDENTITY() AS id_subcategoria;
END;
GO

-- sp_subcategoria_update
-- Actualizar subcategoría

CREATE OR ALTER PROCEDURE sp_subcategoria_update
(
    @id_subcategoria INT,
    @nombre          NVARCHAR(100),
    @descripcion     NVARCHAR(255) = NULL,
    @tipo            NVARCHAR(20),
    @estado          NVARCHAR(20),
    @modificado_por  NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE subcategoria
    SET nombre         = @nombre,
        descripcion    = @descripcion,
        tipo           = @tipo,
        estado         = @estado,
        modificado_por = @modificado_por,
        modificado_en  = SYSDATETIME()
    WHERE id_subcategoria = @id_subcategoria;
END;
GO

-- sp_subcategoria_delete
-- Eliminar subcategoría

CREATE OR ALTER PROCEDURE sp_subcategoria_delete
(
    @id_subcategoria INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM subcategoria
    WHERE id_subcategoria = @id_subcategoria;
END;
GO

-- sp_subcategoria_get_by_id
-- Obtener subcategoría por ID

CREATE OR ALTER PROCEDURE sp_subcategoria_get_by_id
(
    @id_subcategoria INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM subcategoria
    WHERE id_subcategoria = @id_subcategoria;
END;
GO

-- sp_subcategoria_list_by_categoria
-- Listar subcategorías de una categoría

CREATE OR ALTER PROCEDURE sp_subcategoria_list_by_categoria
(
    @id_categoria INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM subcategoria
    WHERE id_categoria = @id_categoria
    ORDER BY nombre;
END;
GO
