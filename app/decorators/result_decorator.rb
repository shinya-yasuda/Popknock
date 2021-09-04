class ResultDecorator < Draper::Decorator
  delegate_all

  def best_medal(option)
    @results.where(random_option: option).maximum(:medal).medal
  end

  def best_score(option)
    @results.where(random_option: option).maximum(:score).score
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
