require 'rails_helper'

RSpec.describe Chart, type: :model do
  let(:music) { FactoryBot.create(:music) }
  let(:easy) { FactoryBot.build(:easy, music: music) }
  it 'レベル、難易度があれば有効である' do
    expect(easy).to be_valid
  end
  it 'レベルがなければ無効である' do
    easy.level = nil
    easy.valid?
    expect(easy.errors[:level]).to include('は一覧にありません')
  end
  it 'レベル0以下または51以上では無効である' do
    easy.level = 0
    easy.valid?
    expect(easy.errors[:level]).to include('は一覧にありません')
    easy.level = 51
    easy.valid?
    expect(easy.errors[:level]).to include('は一覧にありません')
  end
  describe 'ソートメソッド' do
    let(:etudes) { FactoryBot.create_list(:etude, 5) }
    before do
      charts = []
      etudes.each do |music|
        charts << FactoryBot.create(:easy, music: music)
      end
    end
  end
end
