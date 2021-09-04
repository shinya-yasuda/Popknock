module ApplicationHelper
  def random_level(level)
    ran_levels = { 1 => '○1', 2 => '○2', 3 => '○3', 4 => '○4', 5 => '○5', 6 => '○6',
                   7 => '●1', 8 => '●2', 9 => '●3', 10 => '●4', 11 => '●5', 12 => '●6',
                   13 => '●7', 14 => '●8', 15 => '●9', 16 => '●10', 17 => '●11', 18 => '●12' }
    ran_levels[level.to_i]
  end
end
