class Music < ApplicationRecord
  has_many :charts, dependent: :destroy
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { scope: :genre }

  def self.import(file)
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
end
