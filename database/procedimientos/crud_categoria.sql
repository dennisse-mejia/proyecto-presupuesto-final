USE ProyectoBD;
GO

-- CRUD CATEGORIA
-- Tabla Categoria

-- sp_categoria_insert
-- Crea una nueva categoría para un usuario

CREATE OR ALTER PROCEDURE sp_categoria_insert
(
    @id_usuario    INT,
    @nombre        NVARCHAR(100),
    @descripcion   NVARCHAR(255) = NULL,
    @tipo          NVARCHAR(20),
    @icono         NVARCHAR(100) = NULL,
    @color         NVARCHAR(50)  = NULL,
    @orden         INT           = NULL,
    @creado_por    NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO categoria
    (
        id_usuario,
        nombre,
        descripcion,
        tipo,
        icono,
        color,
        orden,
        creado_por,
        creado_en,
        modificado_por,
        modificado_en
    )
    VALUES
    (
        @id_usuario,
        @nombre,
        @descripcion,
        @tipo,
        @icono,
        @color,
        @orden,
        @creado_por,
        SYSDATETIME(),
        NULL,
        NULL
    );

    SELECT SCOPE_IDENTITY() AS id_categoria;
END;
GO

-- sp_categoria_update
-- Actualizar una categoría existente

CREATE OR ALTER PROCEDURE sp_categoria_update
(
    @id_categoria   INT,
    @nombre         NVARCHAR(100),
    @descripcion    NVARCHAR(255) = NULL,
    @tipo           NVARCHAR(20),
    @icono          NVARCHAR(100) = NULL,
    @color          NVARCHAR(50)  = NULL,
    @orden          INT           = NULL,
    @modificado_por NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE categoria
    SET nombre         = @nombre,
        descripcion    = @descripcion,
        tipo           = @tipo,
        icono          = @icono,
        color          = @color,
        orden          = @orden,
        modificado_por = @modificado_por,
        modificado_en  = SYSDATETIME()
    WHERE id_categoria = @id_categoria;
END;
GO

-- sp_categoria_delete
-- Eliminar una categoría

CREATE OR ALTER PROCEDURE sp_categoria_delete
(
    @id_categoria INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM categoria
    WHERE id_categoria = @id_categoria;
END;
GO

-- sp_categoria_get_by_id
-- Obtener una categoría por ID

CREATE OR ALTER PROCEDURE sp_categoria_get_by_id
(
    @id_categoria INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM categoria
    WHERE id_categoria = @id_categoria;
END;
GO

-- sp_categoria_list_by_usuario
-- Listar categorías de un usuario

CREATE OR ALTER PROCEDURE sp_categoria_list_by_usuario
(
    @id_usuario INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM categoria
    WHERE id_usuario = @id_usuario
    ORDER BY orden, nombre;
END;
GO
