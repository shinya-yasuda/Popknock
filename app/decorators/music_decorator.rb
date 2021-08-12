class MusicDecorator < Draper::Decorator
  delegate_all
  def remake_charts
    charts = []
    0.upto(3) do |i|
      chart = music.charts.find_by(difficulty: i)
      charts << chart
    end
    charts
  end
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
