# 🎯 Dashboard con Datos Reales - Guía de Implementación

## ✅ Cambios Realizados

### Backend

1. **Nuevo endpoint**: `GET /api/dashboard/:idUsuario`
   - Archivo: [backend/src/routes/dashboard.routes.ts](../backend/src/routes/dashboard.routes.ts)
   - Retorna datos agregados desde la base de datos

2. **Función de query**: Se agregó `query()` en [backend/src/config/db.ts](../backend/src/config/db.ts)
   - Permite ejecutar queries SQL directas
   - Similar a `execSP()` pero para queries ad-hoc

3. **Ruta registrada**: En [backend/src/server.ts](../backend/src/server.ts)
   - `app.use('/api/dashboard', dashboardRouter)`

### Frontend

1. **Función API**: `getDashboardData()` en [frontend/src/services/api.ts](../frontend/src/services/api.ts)
   - Llama al endpoint del backend
   - Tipado completo con TypeScript

2. **Dashboard actualizado**: [frontend/src/pages/Dashboard.tsx](../frontend/src/pages/Dashboard.tsx)
   - ❌ Removidos datos mockeados
   - ✅ Usa datos reales de la API
   - Manejo de estados: loading, error, vacío

## 📊 Datos que Retorna el Dashboard

```typescript
{
  totalPresupuestos: number,        // Suma de montos asignados
  totalTransacciones: number,       // Conteo total
  porcentajeMetasCumplidas: number, // % de metas completadas
  obligacionesProximas: [           // Top 5 obligaciones activas
    {
      id_obligacion: number,
      nombre: string,
      monto: number,
      dia_vencimiento: number,
      activa: boolean,
      categoria: string
    }
  ],
  categoriasUsadas: [                // Top 5 categorías por gasto
    {
      id_categoria: number,
      nombre: string,
      tipo: 'gasto' | 'ingreso',
      color: string,
      monto_usado: number,
      porcentaje: number
    }
  ]
}
```

## 🚀 Cómo Probar

### 1. Iniciar el Backend

```bash
cd backend
npm run dev
```

Deberías ver:
```
✅ Conectado a SQL Server: [nombre_bd]
API escuchando en http://localhost:3000
```

### 2. Iniciar el Frontend

```bash
cd frontend
npm run dev
```

Abre `http://localhost:5173`

### 3. Verificar en el Navegador

1. **Abrir DevTools** (F12)
2. **Ir a la pestaña Network**
3. **Recargar la página**
4. **Buscar la petición**: `dashboard/1`
5. **Ver respuesta** con datos reales de tu BD

## 🔍 Debugging

### Si no aparecen datos:

1. **Verificar que existe el usuario con ID 1**:
   ```sql
   SELECT * FROM usuario WHERE id_usuario = 1
   ```

2. **Verificar que hay datos en las tablas**:
   ```sql
   -- Presupuestos
   SELECT COUNT(*) FROM presupuesto WHERE id_usuario = 1
   
   -- Transacciones
   SELECT COUNT(*) FROM transaccion WHERE id_usuario = 1
   
   -- Categorías
   SELECT * FROM categoria WHERE id_usuario = 1
   
   -- Obligaciones
   SELECT * FROM obligacion_fija WHERE id_usuario = 1
   
   -- Metas
   SELECT * FROM meta_ahorro WHERE id_usuario = 1
   ```

3. **Revisar logs del backend**:
   - Verás los queries ejecutados en la consola
   - Busca errores en rojo (❌)

4. **Si faltan datos, ejecuta los datos de prueba**:
   ```bash
   # Desde la raíz del proyecto
   cd database/datos_prueba
   # Ejecuta datos_prueba.sql en tu SQL Server
   ```

## 📝 Queries del Dashboard Explicados

### Total Presupuestos
```sql
SELECT ISNULL(SUM(pd.monto_asignado), 0) as total_presupuestos
FROM presupuesto_detalle pd
INNER JOIN presupuesto p ON pd.id_presupuesto = p.id_presupuesto
WHERE p.id_usuario = 1
```
Suma todos los montos asignados en los detalles de presupuesto.

### Total Transacciones
```sql
SELECT COUNT(*) as total_transacciones
FROM transaccion
WHERE id_usuario = 1
```
Cuenta todas las transacciones del usuario.

### Metas Cumplidas
```sql
SELECT 
  COUNT(*) as total_metas,
  SUM(CASE WHEN estado = 'completada' THEN 1 ELSE 0 END) as metas_completadas
FROM meta_ahorro
WHERE id_usuario = 1
```
Calcula el porcentaje dividiendo metas completadas / total.

### Obligaciones Próximas
```sql
SELECT TOP 5
  of.id_obligacion,
  s.nombre as nombre,
  of.monto,
  of.fecha_registro as dia_vencimiento,
  c.nombre as categoria
FROM obligacion_fija of
INNER JOIN subcategoria s ON of.id_subcategoria = s.id_subcategoria
INNER JOIN categoria c ON s.id_categoria = c.id_categoria
WHERE of.id_usuario = 1 AND of.estado = 'activa'
ORDER BY of.fecha_registro DESC
```
Trae las 5 obligaciones activas más recientes.

### Categorías Más Usadas
```sql
SELECT TOP 5
  c.id_categoria,
  c.nombre,
  c.tipo,
  c.color,
  SUM(t.monto) as monto_usado,
  -- Porcentaje calculado vs total presupuestado
FROM categoria c
LEFT JOIN subcategoria s ON c.id_categoria = s.id_categoria
LEFT JOIN transaccion t ON s.id_subcategoria = t.id_subcategoria
WHERE c.id_usuario = 1 AND t.tipo = 'gasto'
GROUP BY c.id_categoria, c.nombre, c.tipo, c.color
ORDER BY monto_usado DESC
```
Top 5 categorías ordenadas por gasto.

## 🎨 Personalización

### Cambiar el usuario actual

En [Dashboard.tsx](../frontend/src/pages/Dashboard.tsx#L13):
```typescript
const ID_USUARIO = 1 // 🔒 Cambiar por usuario autenticado
```

### Agregar más métricas

1. Modifica el query en [dashboard.routes.ts](../backend/src/routes/dashboard.routes.ts)
2. Actualiza el tipo `DashboardData` en [services/api.ts](../frontend/src/services/api.ts)
3. Renderiza los nuevos datos en [Dashboard.tsx](../frontend/src/pages/Dashboard.tsx)

### Cambiar el límite de obligaciones/categorías

En [dashboard.routes.ts](../backend/src/routes/dashboard.routes.ts):
```sql
SELECT TOP 10  -- Cambiar de 5 a 10
```

## ⚠️ Consideraciones Importantes

1. **Performance**: Los queries están optimizados para usuarios individuales
2. **Índices**: Asegúrate de tener índices en `id_usuario` en todas las tablas
3. **Caché**: En producción, considera implementar caché para estos datos
4. **Autenticación**: Actualmente usa ID fijo, implementar auth real después

## 🔄 Próximos Pasos

- [ ] Implementar autenticación de usuarios
- [ ] Agregar filtros por fecha (mes/año)
- [ ] Gráficas con Recharts
- [ ] Actualización en tiempo real (WebSockets)
- [ ] Exportar datos del dashboard a PDF
- [ ] Comparación mes a mes

## 📞 Soporte

Si algo no funciona, revisa:
1. ✅ Backend corriendo en :3000
2. ✅ Frontend corriendo en :5173
3. ✅ Base de datos conectada
4. ✅ CORS habilitado en el backend
5. ✅ Datos de prueba cargados en la BD
