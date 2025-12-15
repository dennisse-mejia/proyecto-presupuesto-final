import type { ObligacionFija } from '../types'
import './ObligacionItem.css'

type ObligacionItemProps = {
  obligacion: ObligacionFija
}

function calcularDiasRestantes(diaVencimiento: number): number {
  const hoy = new Date()
  const mesActual = hoy.getMonth()
  const anioActual = hoy.getFullYear()
  
  const fechaVencimiento = new Date(anioActual, mesActual, diaVencimiento)
  
  if (fechaVencimiento < hoy) {
    fechaVencimiento.setMonth(fechaVencimiento.getMonth() + 1)
  }
  
  const diferencia = fechaVencimiento.getTime() - hoy.getTime()
  return Math.ceil(diferencia / (1000 * 60 * 60 * 24))
}

export default function ObligacionItem({ obligacion }: ObligacionItemProps) {
  const diasRestantes = calcularDiasRestantes(obligacion.dia_vencimiento)
  const esUrgente = diasRestantes <= 3

  return (
    <div className={`obligacion-item ${esUrgente ? 'urgente' : ''}`}>
      <div className="obligacion-info">
        <h4 className="obligacion-nombre">{obligacion.nombre}</h4>
        <span className="obligacion-vencimiento">
          Vence en {diasRestantes} {diasRestantes === 1 ? 'día' : 'días'}
        </span>
      </div>
      <div className="obligacion-monto">
        ${obligacion.monto.toLocaleString('es-MX', { minimumFractionDigits: 2 })}
      </div>
    </div>
  )
}
