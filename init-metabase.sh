#!/bin/bash

# =====================================================
# Script de Inicialización de Metabase
# Sistema de Gestión de Presupuesto Personal
# =====================================================

set -e

echo "=========================================="
echo "  CONFIGURACIÓN DE METABASE"
echo "=========================================="
echo ""

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_message() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Verificar si Docker está instalado
print_message "Verificando Docker..."
if ! command -v docker &> /dev/null; then
    print_error "Docker no está instalado. Por favor instala Docker primero."
    echo "Visita: https://docs.docker.com/get-docker/"
    exit 1
fi
print_success "Docker está instalado"

# Verificar si Docker Compose está instalado
print_message "Verificando Docker Compose..."
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    print_error "Docker Compose no está instalado."
    exit 1
fi
print_success "Docker Compose está instalado"

# Verificar si el archivo docker-compose.metabase.yml existe
if [ ! -f "docker-compose.metabase.yml" ]; then
    print_error "Archivo docker-compose.metabase.yml no encontrado"
    exit 1
fi

echo ""
print_message "Iniciando Metabase..."
echo ""

# Iniciar Metabase con Docker Compose
docker-compose -f docker-compose.metabase.yml up -d

echo ""
print_success "Metabase ha sido iniciado exitosamente"
echo ""

# Esperar a que Metabase esté listo
print_message "Esperando a que Metabase esté listo (esto puede tomar 1-2 minutos)..."
sleep 10

MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -f http://localhost:3000/api/health &> /dev/null; then
        print_success "Metabase está listo"
        break
    fi
    
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo -n "."
    sleep 5
done

echo ""
echo ""

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    print_warning "Metabase está tardando más de lo esperado. Verifica los logs:"
    echo "docker-compose -f docker-compose.metabase.yml logs -f metabase"
else
    echo "=========================================="
    echo "  ¡METABASE ESTÁ LISTO!"
    echo "=========================================="
    echo ""
    print_success "Accede a Metabase en: ${GREEN}http://localhost:3000${NC}"
    echo ""
    echo "📋 PASOS PARA CONFIGURAR METABASE:"
    echo ""
    echo "1. Abre tu navegador en http://localhost:3000"
    echo "2. Completa el formulario de configuración inicial:"
    echo "   - Crea tu cuenta de administrador"
    echo "   - Configura las preferencias de idioma (Español)"
    echo ""
    echo "3. Conecta la base de datos SQL Server:"
    echo "   - Tipo: Microsoft SQL Server"
    echo "   - Host: tu_host_sql_server"
    echo "   - Puerto: 1433"
    echo "   - Nombre de BD: ProyectoBD"
    echo "   - Usuario: tu_usuario"
    echo "   - Contraseña: tu_contraseña"
    echo ""
    echo "4. Las vistas analíticas ya están disponibles:"
    echo "   ✓ v_resumen_financiero_usuario"
    echo "   ✓ v_analisis_transacciones"
    echo "   ✓ v_desempeno_presupuestos"
    echo "   ✓ v_analisis_categorias"
    echo "   ✓ v_seguimiento_metas"
    echo "   ✓ v_analisis_obligaciones"
    echo "   ✓ v_tendencias_mensuales"
    echo "   ✓ v_top_gastos_categoria"
    echo "   ✓ v_flujo_caja"
    echo "   ✓ v_kpis_principales"
    echo ""
    echo "=========================================="
    echo ""
    print_message "Comandos útiles:"
    echo ""
    echo "  Ver logs:        docker-compose -f docker-compose.metabase.yml logs -f"
    echo "  Detener:         docker-compose -f docker-compose.metabase.yml stop"
    echo "  Reiniciar:       docker-compose -f docker-compose.metabase.yml restart"
    echo "  Eliminar:        docker-compose -f docker-compose.metabase.yml down"
    echo "  Eliminar todo:   docker-compose -f docker-compose.metabase.yml down -v"
    echo ""
    echo "=========================================="
fi
