#!/usr/bin/env node

/**
 * Script para crear usuarios de prueba
 * Uso: node crear_usuarios.js
 */

const usuarios = [
  {
    nombre: 'María',
    apellido: 'García',
    correo: 'maria.garcia@ejemplo.com',
    salario_mensual: 25000,
    estado: 'ACTIVO'
  },
  {
    nombre: 'Carlos',
    apellido: 'Rodríguez',
    correo: 'carlos.rodriguez@ejemplo.com',
    salario_mensual: 30000,
    estado: 'ACTIVO'
  },
  {
    nombre: 'Ana',
    apellido: 'Martínez',
    correo: 'ana.martinez@ejemplo.com',
    salario_mensual: 22000,
    estado: 'ACTIVO'
  },
  {
    nombre: 'Luis',
    apellido: 'López',
    correo: 'luis.lopez@ejemplo.com',
    salario_mensual: 28000,
    estado: 'ACTIVO'
  }
];

async function crearUsuarios() {
  console.log('🚀 Creando usuarios de prueba...\n');

  for (const usuario of usuarios) {
    try {
      const response = await fetch('http://localhost:3000/api/usuarios', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(usuario),
      });

      const data = await response.json();

      if (response.ok) {
        console.log(`✅ Usuario creado: ${usuario.nombre} ${usuario.apellido} (ID: ${data.id_usuario})`);
      } else {
        console.error(`❌ Error creando ${usuario.nombre}: ${data.mensaje || JSON.stringify(data)}`);
      }
    } catch (error) {
      console.error(`❌ Error de red creando ${usuario.nombre}:`, error.message);
    }
  }

  console.log('\n✅ Proceso completado!');
  
  // Listar todos los usuarios
  try {
    const response = await fetch('http://localhost:3000/api/usuarios/activos');
    const usuarios = await response.json();
    
    console.log('\n📋 Usuarios activos:');
    console.table(usuarios.map(u => ({
      ID: u.id_usuario,
      Nombre: `${u.nombre} ${u.apellido}`,
      Correo: u.correo,
      Salario: `L ${u.salario_mensual?.toLocaleString() || 0}`
    })));
  } catch (error) {
    console.error('Error listando usuarios:', error.message);
  }
}

// Ejecutar
crearUsuarios();
