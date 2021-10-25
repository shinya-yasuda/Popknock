module ApplicationHelper
  def random_level(level)
    ran_levels = { 1 => '○1', 2 => '○2', 3 => '○3', 4 => '○4', 5 => '○5', 6 => '○6',
                   7 => '●1', 8 => '●2', 9 => '●3', 10 => '●4', 11 => '●5', 12 => '●6',
                   13 => '●7', 14 => '●8', 15 => '●9', 16 => '●10', 17 => '●11', 18 => '●12' }
    ran_levels[level.to_i]
  end

  def sort_order(column, title)
    direction = sort_direction == 'asc' && column == params[:column] ? 'desc' : 'asc'
    if direction == 'asc' && column == params[:column]
      link_to "#{title}▼", { column: column, sort: direction, option: @option, level: @level }
    elsif direction == 'desc' && column == params[:column]
      link_to "#{title}▲", { column: column, sort: direction, option: @option, level: @level }
    else
      link_to title, { column: column, sort: direction, option: @option, level: @level }
    end
  end
end
