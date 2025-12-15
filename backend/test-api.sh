#!/bin/bash

echo "=== DIAGNÓSTICO COMPLETO API ==="
echo ""

# 1. Verificar servidor
echo "1️⃣ Verificando servidor en puerto 3000..."
if lsof -i :3000 > /dev/null 2>&1; then
    echo "✅ Servidor activo"
else
    echo "❌ Servidor NO está corriendo"
    exit 1
fi

echo ""
echo "2️⃣ Test GET usuarios activos..."
RESPONSE=$(curl -s -w "\nHTTP_CODE:%{http_code}" http://localhost:3000/api/usuarios/activos)
HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_CODE")

echo "Status: $HTTP_CODE"
echo "Respuesta: $BODY"

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ GET usuarios funciona"
    
    # Extraer primer ID de usuario
    PRIMER_ID=$(echo "$BODY" | jq -r '.[0].id_usuario' 2>/dev/null)
    
    if [ -n "$PRIMER_ID" ] && [ "$PRIMER_ID" != "null" ]; then
        echo "Usuario encontrado: ID=$PRIMER_ID"
        
        echo ""
        echo "3️⃣ Test POST categoría con usuario existente..."
        POST_RESPONSE=$(curl -s -w "\nHTTP_CODE:%{http_code}" \
            -X POST http://localhost:3000/api/categorias \
            -H "Content-Type: application/json" \
            -d "{\"id_usuario\": $PRIMER_ID, \"nombre\": \"Test Categoria\", \"tipo\": \"gasto\"}")
        
        POST_CODE=$(echo "$POST_RESPONSE" | grep "HTTP_CODE" | cut -d: -f2)
        POST_BODY=$(echo "$POST_RESPONSE" | grep -v "HTTP_CODE")
        
        echo "Status: $POST_CODE"
        echo "Respuesta: $POST_BODY"
        
        if [ "$POST_CODE" = "201" ]; then
            echo "✅ POST categoría funciona"
        else
            echo "❌ POST categoría falló"
        fi
    else
        echo "⚠️  No hay usuarios, creando uno..."
        
        CREATE_USER=$(curl -s -w "\nHTTP_CODE:%{http_code}" \
            -X POST http://localhost:3000/api/usuarios \
            -H "Content-Type: application/json" \
            -d '{"nombre":"Test","apellido":"User","correo":"test@test.com","salario_mensual":30000}')
        
        USER_CODE=$(echo "$CREATE_USER" | grep "HTTP_CODE" | cut -d: -f2)
        USER_BODY=$(echo "$CREATE_USER" | grep -v "HTTP_CODE")
        
        echo "Status: $USER_CODE"
        echo "Respuesta: $USER_BODY"
    fi
else
    echo "❌ GET usuarios falló"
fi

echo ""
echo "=== FIN DIAGNÓSTICO ==="
