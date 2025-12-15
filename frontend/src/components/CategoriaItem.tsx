import type { CategoriaConUso } from '../types'
import ProgressBar from './ProgressBar'
import './CategoriaItem.css'

type CategoriaItemProps = {
  categoria: CategoriaConUso
}

export default function CategoriaItem({ categoria }: CategoriaItemProps) {
  return (
    <div className="categoria-item">
      <div className="categoria-header">
        <div className="categoria-info">
          <div
            className="categoria-color"
            style={{ backgroundColor: categoria.color }}
          />
          <span className="categoria-nombre">{categoria.nombre}</span>
        </div>
        <span className="categoria-monto">
          ${categoria.monto_usado.toLocaleString('es-MX', { minimumFractionDigits: 2 })}
        </span>
      </div>
      <ProgressBar
        percentage={categoria.porcentaje}
        color={categoria.color}
        height={6}
      />
    </div>
  )
}
