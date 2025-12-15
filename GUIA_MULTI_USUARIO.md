# 👤 Sistema Multi-Usuario - Guía de Uso

## ✅ ¿Qué se implementó?

Se agregó un **selector de usuarios** en el frontend que permite:
- Cambiar entre diferentes usuarios registrados
- Cada usuario tiene sus propios datos completamente independientes
- La información de cada usuario se mantiene al cambiar entre ellos

---

## 🎯 Cómo funciona

### 1. **Ubicación del Selector**
El selector de usuarios está en la **parte inferior del sidebar** (barra lateral izquierda).

### 2. **Cambiar de Usuario**
1. Haz clic en el área de usuario (parte inferior del sidebar)
2. Se abrirá un menú con todos los usuarios activos
3. Selecciona el usuario que deseas
4. La aplicación se recargará automáticamente con los datos del nuevo usuario

### 3. **Usuario Actual**
- El usuario actual se muestra con su nombre, apellido y correo
- Tiene un ícono con la primera letra de su nombre
- Se guarda automáticamente en `localStorage`

---

## 📊 Datos Independientes

Cada usuario tiene su propia información:
- ✅ **Categorías** - Cada usuario crea sus propias categorías
- ✅ **Subcategorías** - Vinculadas a las categorías del usuario
- ✅ **Presupuestos** - Presupuestos mensuales únicos por usuario
- ✅ **Transacciones** - Gastos, ingresos y ahorros del usuario
- ✅ **Metas** - Metas de ahorro personales
- ✅ **Dashboard** - Resumen personalizado por usuario

---

## 👥 Usuarios Actuales

Los usuarios creados son:
1. **Test User** (id: 1) - Usuario original
2. **María García** (id: 2) - Salario: L 25,000
3. **María García** (id: 3) - Salario: L 25,000
4. **Carlos Rodríguez** (id: 4) - Salario: L 30,000
5. **Ana Martínez** (id: 5) - Salario: L 22,000
6. **Luis López** (id: 6) - Salario: L 28,000

---

## 🚀 Crear Más Usuarios

### Opción 1: API con cURL
```bash
curl -X POST http://localhost:3000/api/usuarios \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "NuevoNombre",
    "apellido": "NuevoApellido",
    "correo": "email@ejemplo.com",
    "salario_mensual": 25000,
    "estado": "ACTIVO"
  }'
```

### Opción 2: Script automático
```bash
node crear_usuarios.js
```

### Opción 3: SQL directo
Ejecuta el archivo `crear_usuarios.sql` en SQL Server.

---

## 🔧 Código Implementado

### Archivos creados:
- `frontend/src/contexts/UserContext.tsx` - Contexto global de usuario
- `crear_usuarios.js` - Script para crear usuarios de prueba
- `crear_usuarios.sql` - Script SQL para crear usuarios

### Archivos modificados:
- `frontend/src/App.tsx` - Agregado UserProvider
- `frontend/src/layouts/Sidebar.tsx` - Selector de usuarios
- `frontend/src/layouts/Sidebar.css` - Estilos del selector
- `frontend/src/pages/*.tsx` - Todas las páginas usan `currentUserId`

---

## 🎨 Características del Selector

- **Diseño burgundy** - Consistente con el tema de la aplicación
- **Lista scrolleable** - Si hay muchos usuarios, la lista hace scroll
- **Usuario activo marcado** - Muestra un checkmark (✓) en el usuario actual
- **Hover interactivo** - Los usuarios cambian de color al pasar el mouse
- **Auto-cierre** - El selector se cierra al seleccionar un usuario

---

## 💡 Notas Importantes

1. **Recarga automática**: Al cambiar de usuario, la página se recarga para actualizar todos los datos
2. **Persistencia**: El usuario seleccionado se guarda en `localStorage` y se mantiene al recargar
3. **Datos separados**: NUNCA se mezclan datos entre usuarios - cada uno es completamente independiente
4. **Usuario por defecto**: Si no hay usuario guardado, se usa el usuario ID 1 (Test User)

---

## 🐛 Solución de Problemas

### El selector no aparece
- Verifica que el backend esté corriendo: `http://localhost:3000`
- Revisa la consola del navegador (F12) para ver errores

### No hay usuarios en la lista
- Verifica que existan usuarios activos: 
  ```bash
  curl http://localhost:3000/api/usuarios/activos | jq
  ```

### Los datos no cambian al cambiar de usuario
- La página debería recargarse automáticamente
- Si no lo hace, recarga manualmente (F5)

---

## ✨ Demo de Uso

1. **Inicia con el usuario actual** (Test User por defecto)
2. **Crea algunas categorías y transacciones**
3. **Cambia a María García** (haz clic en el área de usuario)
4. **Observa que NO hay categorías ni transacciones** - está vacío
5. **Crea datos para María García**
6. **Cambia de vuelta a Test User**
7. **Todos los datos de Test User siguen ahí** - información independiente ✅

---

**¡Listo! Ahora tienes un sistema multi-usuario completamente funcional** 🎉
