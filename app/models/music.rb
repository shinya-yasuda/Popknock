class Music < ApplicationRecord
  has_many :charts, dependent: :destroy
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { scope: :genre }

  def self.import_create(file)
    CSV.foreach(file.path, headers: true) do |row|
      row[1] = row[0] if row[1].blank?
      music = Music.new(genre: row[0], name: row[1])
      if music.save
        2.upto(5) do |i|
          Chart.create(music_id: music.id, level: row[i].to_i, difficulty: i - 2)
        end
      end
    end
  end

  def self.import_edit(file)
    CSV.foreach(file.path, headers: true) do |row|
      row[1] ||= row[0]
      music_id = Music.find_by(genre: row[0], name: row[1])&.id
      if music_id
        2.upto(5) do |i|
          chart = Chart.find_by(music_id: music_id, difficulty: i - 2)
          level = row[i].to_i
          if level > 0
            if chart
              chart.update(level: level)
            else
              Chart.create(music_id: music_id, level: level, difficulty: i - 2)
            end
          else
            chart.destroy if chart
          end
        end
      end
    end
  end
end
