require 'rails_helper'

RSpec.describe Music, type: :model do
  let(:music) { FactoryBot.build(:music) }
  it '名前があれば有効である' do
    expect(music).to be_valid
  end
  it '名前がなければ無効である' do
    music.name = nil
    music.valid?
    expect(music.errors[:name]).to include('を入力してください')
  end
  it '名前とジャンル名が重複していれば無効である' do
    music.save
    music2 = Music.new(
      name: 'test_music',
      genre: 'test'
    )
    music2.valid?
    expect(music2.errors[:name]).to include('はすでに存在します')
  end
end
