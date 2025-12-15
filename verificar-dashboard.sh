#!/bin/bash

echo "════════════════════════════════════════════════════════"
echo "  🎯 DASHBOARD CON DATOS REALES - VERIFICACIÓN"
echo "════════════════════════════════════════════════════════"
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar backend
echo "📦 Verificando archivos del backend..."

if [ -f "backend/src/routes/dashboard.routes.ts" ]; then
    echo -e "${GREEN}✅${NC} dashboard.routes.ts creado"
else
    echo -e "${RED}❌${NC} dashboard.routes.ts NO encontrado"
fi

if grep -q "dashboardRouter" "backend/src/server.ts"; then
    echo -e "${GREEN}✅${NC} Ruta dashboard registrada en server.ts"
else
    echo -e "${RED}❌${NC} Ruta dashboard NO registrada"
fi

if grep -q "export async function query" "backend/src/config/db.ts"; then
    echo -e "${GREEN}✅${NC} Función query() agregada a db.ts"
else
    echo -e "${RED}❌${NC} Función query() NO encontrada"
fi

echo ""
echo "🎨 Verificando archivos del frontend..."

if grep -q "getDashboardData" "frontend/src/services/api.ts"; then
    echo -e "${GREEN}✅${NC} getDashboardData() agregada a api.ts"
else
    echo -e "${RED}❌${NC} getDashboardData() NO encontrada"
fi

if grep -q "getDashboardData" "frontend/src/pages/Dashboard.tsx"; then
    echo -e "${GREEN}✅${NC} Dashboard usa datos reales (no mock)"
else
    echo -e "${RED}❌${NC} Dashboard todavía usa datos mockeados"
fi

echo ""
echo "════════════════════════════════════════════════════════"
echo "  📋 RESUMEN DE CAMBIOS"
echo "════════════════════════════════════════════════════════"
echo ""
echo "BACKEND:"
echo "  • dashboard.routes.ts   → Endpoint GET /api/dashboard/:idUsuario"
echo "  • server.ts             → Ruta registrada"
echo "  • db.ts                 → Función query() agregada"
echo ""
echo "FRONTEND:"
echo "  • services/api.ts       → getDashboardData() implementada"
echo "  • pages/Dashboard.tsx   → Usa datos reales de BD"
echo ""
echo "════════════════════════════════════════════════════════"
echo "  🚀 PARA PROBAR"
echo "════════════════════════════════════════════════════════"
echo ""
echo "1. Inicia el backend:"
echo "   cd backend && npm run dev"
echo ""
echo "2. Inicia el frontend (en otra terminal):"
echo "   cd frontend && npm run dev"
echo ""
echo "3. Abre http://localhost:5173"
echo ""
echo "4. Verifica en DevTools (F12) → Network → dashboard/1"
echo ""
echo "════════════════════════════════════════════════════════"
echo ""
