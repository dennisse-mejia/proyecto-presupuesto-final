# Sistema de Presupuesto Personal

App full-stack para gestionar presupuestos, transacciones, obligaciones fijas y metas de ahorro por usuario. Incluye un dashboard con datos reales desde la base de datos y soporte multi‑usuario (cada usuario ve solo su data).

---

## Tabla de contenidos

- [Stack tecnológico](#stack-tecnológico)
- [Arquitectura](#arquitectura)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Requisitos](#requisitos)
- [Instalación y ejecución](#instalación-y-ejecución)
  - [1) Base de datos (SQL Server)](#1-base-de-datos-sql-server)
  - [2) Backend (API)](#2-backend-api)
  - [3) Frontend (UI)](#3-frontend-ui)
- [Multi‑usuario](#multiusuario)
- [Endpoints principales](#endpoints-principales)
- [Scripts de verificación](#scripts-de-verificación)
- [Scripts SQL incluidos](#scripts-sql-incluidos)
- [Troubleshooting](#troubleshooting)

---

## Stack tecnológico

### Frontend
- **React + TypeScript** (Vite)
- `npm run dev / build / preview / lint` (ver `package.json`)  
- Entrada web: `index.html` apunta a `/src/main.tsx`

### Backend
- **Node.js + TypeScript + Express**
- CORS habilitado (origen local del frontend)
- Rutas REST bajo `/api/...`

### Base de datos
- **Microsoft SQL Server**
- Lógica de negocio principalmente en SQL: procedimientos, funciones y triggers
- Scripts para DDL, CRUD, triggers, lógica de negocio y datos de prueba

---

## Arquitectura

**Frontend (React)** → consume **API REST (Express)** → que consulta/invoca lógica en **SQL Server** (procedimientos + triggers).

Puntos clave:
- La API actúa como “puente”: valida/request/response.
- El dashboard trae agregaciones “tipo BI” (TOP categorías usadas, obligaciones próximas, % metas, etc.).
- El selector multi‑usuario cambia `currentUserId` y recarga data del sistema.

---

## Estructura del repositorio

> Puede variar según el repositorio, pero estos archivos son los más importantes:

### Raíz
- `start.sh` → instala dependencias (frontend/backend) y te recuerda comandos para levantar ambos servicios
- `test-api.sh` → diagnóstico rápido de la API (GET usuarios + POST categoría con un usuario existente)
- `verificar-dashboard.sh` → valida que el dashboard use data real (no mock) y que existan los archivos/funciones clave
- `README.md` / `SISTEMA_FUNCIONAL.md` / `GUIA_MULTI_USUARIO.md` → documentación

### Frontend (carpeta `frontend/`)
- `package.json` + `package-lock.json` → scripts y dependencias
- `vite.config.ts`, `tsconfig*.json`, `eslint.config.js`
- `index.html` → monta React en `<div id="root"></div>` y carga `/src/main.tsx`

### Backend (carpeta `backend/`)
- `src/server.ts` → configuración de Express, CORS, y registro de routers `/api/...`
- `src/config/db.ts` → conexión a SQL Server y helper `query()` para ejecutar SQL con parámetros
- `src/routes/*.routes.ts` → rutas por entidad (usuarios, categorías, subcategorías, presupuestos, transacciones, obligaciones, metas, dashboard…)

### SQL (scripts)
- `Script-DDL.sql` → creación de tablas
- `crud_*.sql` → procedimientos CRUD por entidad
- `funciones.sql` → funciones auxiliares
- `triggers.sql` → triggers de reglas/auditoría
- `logica_negocio.sql` → procedimientos de negocio (validaciones, cálculos, reportes)
- `datos_prueba.sql` → datos realistas para probar

---

## Requisitos

- **Node.js** instalado (el proyecto lo valida en `start.sh`)
- **npm**
- **SQL Server** corriendo (local o VM, ej. Azure)
- (Opcional) `jq` si usarás los scripts `.sh` de diagnóstico que parsean JSON

---

## Instalación y ejecución

### 0) Setup rápido con `start.sh` (instala deps)

```bash
chmod +x start.sh
./start.sh
```

> Nota: `start.sh` instala dependencias si no existen, y luego indica cómo levantar backend y frontend.

---

### 1) Base de datos (SQL Server)

1. Crea una base de datos (ej: `ProyectoBD`).
2. Ejecuta los scripts en un orden recomendado:

**Orden sugerido**
1) `Script-DDL.sql`  
2) `funciones.sql`  
3) `triggers.sql`  
4) `crud_usuario.sql`, `crud_categoria.sql`, `crud_subcategoria.sql`, `crud_presupuesto.sql`, `crud_presupuesto_detalle.sql`, `crud_transaccion.sql`, `crud_obligacion_fija.sql`, `crud_meta_ahorro.sql`  
5) `logica_negocio.sql`  
6) `datos_prueba.sql` 

Reglas/nota del modelo (importante para defensa):
- Las entidades y reglas están pensadas para que **la lógica “pesada” viva en la base de datos** (procedimientos/funciones/triggers).
- Hay reglas como: **toda categoría debe tener al menos 1 subcategoría**, y se sugiere hacerlo con trigger (“General/Otros”).  
- Campos de auditoría (creado_por, modificado_por, creado_en, modificado_en) deben actualizarse automáticamente (triggers/defaults).

---

### 2) Backend (API)

1. Entra a `backend/` e instala:
```bash
cd backend
npm install
```

2. Crea un archivo `.env` (en `backend/`) con credenciales de SQL Server. Ejemplo:

```env
DB_SERVER=localhost
DB_DATABASE=ProyectoBD
DB_USER=sa
DB_PASSWORD=TuPassword
DB_PORT=1433
PORT=3000
```

3. Levanta el servidor:
```bash
npm run dev
```

Por defecto la API corre en:
- `http://localhost:3000`

---

### 3) Frontend (UI)

1. Entra a `frontend/` e instala:
```bash
cd frontend
npm install
```

2. Levanta Vite:
```bash
npm run dev
```

Frontend por defecto:
- `http://localhost:5173`

---

## Multiusuario

El sistema incluye un **selector de usuarios** (en el Sidebar) y un **UserContext** global.

Características:
- Guarda el usuario seleccionado en `localStorage`
- Recarga al cambiar usuario para refrescar toda la data
- No mezcla datos entre usuarios: cada usuario es independiente

Guía completa: ver `GUIA_MULTI_USUARIO.md`.

---

## Endpoints principales

La API expone rutas REST (mínimo esperado por el proyecto):

- `/api/usuarios` → CRUD usuarios
- `/api/categorias` → CRUD categorías
- `/api/subcategorias` → CRUD subcategorías
- `/api/presupuestos` → CRUD presupuestos
- `/api/presupuesto-detalle` → gestión de detalles del presupuesto
- `/api/transacciones` → CRUD transacciones
- `/api/obligaciones` → CRUD obligaciones fijas
- `/api/metas` → CRUD metas de ahorro
- `/api/dashboard/:idUsuario` → agregados del dashboard (totales, top categorías, obligaciones próximas, % metas, etc.)

> Ejemplos y colecciones de prueba: usa `test-api.sh`.

---

## Scripts de verificación

### Diagnóstico general API
```bash
chmod +x test-api.sh
./test-api.sh
```

Hace:
- Valida si el backend está levantado en `:3000`
- GET `/api/usuarios/activos`
- POST `/api/categorias` con un usuario existente (si hay)

### Verificar dashboard con datos reales
```bash
chmod +x verificar-dashboard.sh
./verificar-dashboard.sh
```

Valida:
- Que exista `dashboard.routes.ts`
- Que esté registrado el router en `server.ts`
- Que `db.ts` tenga `query()`
- Que el frontend use `getDashboardData()` y no datos mockeados

---

## Scripts SQL incluidos

- **DDL**
  - `Script-DDL.sql` → tablas y constraints

- **CRUD por entidad**
  - `crud_usuario.sql`
  - `crud_categoria.sql`
  - `crud_subcategoria.sql`
  - `crud_presupuesto.sql`
  - `crud_presupuesto_detalle.sql`
  - `crud_transaccion.sql`
  - `crud_obligacion_fija.sql`
  - `crud_meta_ahorro.sql`

- **Lógica y automatización**
  - `funciones.sql`
  - `logica_negocio.sql`
  - `triggers.sql`

- **Datos**
  - `datos_prueba.sql` → dataset para 2 meses aprox (según requisitos del proyecto)

---

## Troubleshooting

### CORS / Frontend no conecta con backend
- Confirma que el backend permita el origin del frontend (ej. `http://localhost:5173`).
- Si cambias el puerto de Vite, actualiza CORS en `server.ts`.

### “No active connection” / SQL Server en VM
- Verifica firewall/puerto 1433 abierto
- Revisa `DB_SERVER`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_DATABASE`
- Si usas Azure/SSL, puede requerir `encrypt` / `trustServerCertificate` (ya contemplado en la config)

### Dashboard vacío
- Confirma que existan datos (correr `datos_prueba.sql`)
- Confirma que estás consultando el `idUsuario` correcto (multi-usuario)

---

## Créditos / notas
Proyecto diseñado para aplicar **Base de Datos + API + UI + Reportería**.


