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

  def score_graphs
    array = [[], [], [], []]
    object.each do |r|
      0.upto(3) do |i|
        a = r.random_option_before_type_cast == i ? [I18n.l(r.played_at), r.score] : [I18n.l(r.played_at), nil]
        array[i] << a
      end
    end
    [{ name: '正規', data: array[0] }, { name: 'ミラー', data: array[1] },
     { name: 'ランダム', data: array[2] }, { name: 'S-ランダム', data: array[3] }]
  end

  def bad_graphs
    array = [[], [], [], []]
    object.each do |r|
      0.upto(3) do |i|
        a = r.random_option_before_type_cast == i ? [I18n.l(r.played_at), r.bad] : [I18n.l(r.played_at), nil]
        array[i] << a
      end
    end
    [{ name: '正規', data: array[0] }, { name: 'ミラー', data: array[1] },
     { name: 'ランダム', data: array[2] }, { name: 'S-ランダム', data: array[3] }]
  end
end
