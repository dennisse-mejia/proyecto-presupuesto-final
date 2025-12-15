# 📊 Dashboard - Sistema de Presupuesto

## 📁 Estructura del Proyecto

```
frontend/src/
├── components/          # Componentes reutilizables
│   ├── Card.tsx        # Card de métricas
│   ├── ProgressBar.tsx # Barra de progreso
│   ├── Sidebar.tsx     # Navegación lateral
│   ├── ObligacionItem.tsx
│   └── CategoriaItem.tsx
├── pages/              # Páginas principales
│   └── Dashboard.tsx   # Dashboard principal
├── services/           # Servicios API
│   └── api.ts         # Cliente API
├── types/             # Tipos TypeScript
│   └── index.ts       # Tipos globales
├── App.tsx            # Componente raíz
└── index.css          # Estilos globales
```

## 🎨 Componentes Creados

### 1. **Sidebar** (`components/Sidebar.tsx`)
- Navegación lateral con iconos
- Sección activa destacada
- Preparado para routing futuro

### 2. **Card** (`components/Card.tsx`)
- Muestra métricas clave
- Soporta íconos y trends
- Animaciones hover

### 3. **ProgressBar** (`components/ProgressBar.tsx`)
- Barra de progreso configurable
- Color y altura personalizables
- Etiqueta de porcentaje opcional

### 4. **ObligacionItem** (`components/ObligacionItem.tsx`)
- Muestra obligaciones próximas
- Calcula días restantes automáticamente
- Resalta obligaciones urgentes (≤3 días)

### 5. **CategoriaItem** (`components/CategoriaItem.tsx`)
- Lista categorías con uso
- Barra de progreso con color personalizado
- Muestra monto gastado

## 🔌 Integración con API Real

### Estado Actual
Los datos están **mockeados** en [Dashboard.tsx](pages/Dashboard.tsx#L11-L66)

### Pasos para Conectar con el Backend

#### 1. Crear endpoints en el backend

Necesitas crear estos endpoints en tu API:

```typescript
// GET /api/dashboard/:idUsuario
{
  totalPresupuestos: number,
  totalTransacciones: number,
  porcentajeMetasCumplidas: number,
  obligacionesProximas: ObligacionFija[],
  categoriasUsadas: CategoriaConUso[]
}
```

#### 2. Actualizar `services/api.ts`

Agrega esta función:

```typescript
export async function getDashboardData(idUsuario: number): Promise<DashboardData> {
  const res = await fetch(`${API_URL}/dashboard/${idUsuario}`)
  
  if (!res.ok) {
    const error = await res.text()
    throw new Error(error || 'Error al obtener datos del dashboard')
  }
  
  return res.json()
}
```

#### 3. Actualizar `pages/Dashboard.tsx`

Reemplaza la función `cargarDatos()` (línea ~74):

```typescript
const cargarDatos = async () => {
  try {
    setLoading(true)
    
    // ✅ LLAMADA REAL A LA API
    const data = await getDashboardData(1) // ID de usuario
    setData(data)
  } catch (error) {
    console.error('Error cargando dashboard:', error)
  } finally {
    setLoading(false)
  }
}
```

#### 4. Implementar endpoint en el backend

Ejemplo en Express + PostgreSQL:

```typescript
// backend/src/routes/dashboard.routes.ts
router.get('/dashboard/:idUsuario', async (req, res) => {
  const { idUsuario } = req.params
  
  try {
    // Query para obtener datos agregados
    const result = await db.query(`
      SELECT 
        (SELECT COALESCE(SUM(monto_total), 0) FROM presupuestos WHERE id_usuario = $1) as total_presupuestos,
        (SELECT COUNT(*) FROM transacciones WHERE id_usuario = $1) as total_transacciones,
        -- más queries...
    `, [idUsuario])
    
    res.json(result.rows[0])
  } catch (error) {
    res.status(500).send('Error al obtener dashboard')
  }
})
```

## 🎯 Próximos Pasos

### Funcionalidades a Agregar

1. **Routing** - React Router para navegación
2. **Páginas adicionales**:
   - Presupuestos
   - Transacciones
   - Categorías (CRUD completo)
   - Metas
   - Obligaciones
3. **Formularios** - Crear/editar entidades
4. **Autenticación** - Login y gestión de usuarios
5. **Gráficas** - Recharts o Chart.js
6. **Filtros y búsqueda**
7. **Exportar datos** - PDF/Excel

### Mejoras de UX

- Loading skeletons en lugar de spinner simple
- Toasts para notificaciones
- Confirmaciones para acciones destructivas
- Modo claro/oscuro toggle
- Responsive mobile optimizado

## 🚀 Cómo Ejecutar

```bash
# Instalar dependencias
cd frontend
npm install

# Iniciar desarrollo
npm run dev

# Backend (en otra terminal)
cd backend
npm run dev
```

El frontend estará en `http://localhost:5173`  
El backend debe estar en `http://localhost:3000`

## 🎨 Personalización de Estilos

Los colores principales están en `index.css`:

```css
:root {
  --bg-primary: #111827;
  --bg-secondary: #1f2937;
  --text-primary: #f9fafb;
  --gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
```

Modifica estas variables para cambiar el tema completo.

## 📝 Notas Técnicas

- **TypeScript**: Tipos estrictos en todos los componentes
- **Sin librerías externas**: CSS vanilla para máximo control
- **Componentes funcionales**: Hooks modernos de React
- **Preparado para escalar**: Arquitectura modular y limpia
