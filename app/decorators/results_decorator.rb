class ResultsDecorator < Draper::CollectionDecorator

  def clear_percentage(level)
    clear = object.pickup_level(level).where('medal >= 4').group('charts.id').count.size
    (clear * 100.0 / Chart.where(level: level).count).round(1)
  end

  def average_score_level(level)
    total_score = object.pickup_level(level).group('charts.id').maximum(:score).values.sum
    played_count = object.pickup_level(level).group('charts.id').count.size
    played_count.positive? ? (total_score.to_f / played_count).round(1) : '-'
  end

  def average_bad_level(level)
    total_bad = object.pickup_level(level).group('charts.id').minimum(:bad).values.sum
    played_count = object.pickup_level(level).group('charts.id').count.size
    played_count.positive? ? (total_bad.to_f / played_count).round(1) : '-'
  end
end
