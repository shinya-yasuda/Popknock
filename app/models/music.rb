class Music < ApplicationRecord
  has_many :charts, dependent: :destroy
  validates :name, presence: true, length: { maximum: 255 }

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      music = Music.new
      music.genre = row[0]
      music.name = row[1]
      music.save
      chart_e = Chart.new(music_id: music.id, level: row[2].to_i, difficulty: :e)
      chart_n = Chart.new(music_id: music.id,level: row[3].to_i, difficulty: :N)
      chart_h = Chart.new(music_id: music.id,level: row[4].to_i, difficulty: :H)
      chart_ex = Chart.new(music_id: music.id,level: row[5].to_i, difficulty: :EX)
      chart_e.save
      chart_n.save
      chart_h.save
      chart_ex.save
    end
  end
end
