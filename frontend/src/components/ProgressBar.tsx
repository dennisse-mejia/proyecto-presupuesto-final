import './ProgressBar.css'

type ProgressBarProps = {
  percentage: number
  color?: string
  height?: number
  showLabel?: boolean
}

export default function ProgressBar({
  percentage,
  color = '#667eea',
  height = 8,
  showLabel = false,
}: ProgressBarProps) {
  const clampedPercentage = Math.min(100, Math.max(0, percentage))

  return (
    <div className="progress-container">
      <div className="progress-bar" style={{ height: `${height}px` }}>
        <div
          className="progress-fill"
          style={{
            width: `${clampedPercentage}%`,
            background: color,
          }}
        />
      </div>
      {showLabel && (
        <span className="progress-label">{clampedPercentage.toFixed(0)}%</span>
      )}
    </div>
  )
}
