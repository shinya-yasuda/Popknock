require 'rails_helper'

RSpec.describe User, type: :model do
  let(:tester) { FactoryBot.build(:tester)}
  it '名前、メール、パスワードがあれば有効である' do
    expect(tester).to be_valid
  end
  it '名前がないと無効である' do
    tester.name = nil
    tester.valid?
    expect(tester.errors[:name]).to include('を入力してください')
  end
  it 'メールアドレスがなければ無効である' do
    tester.email = nil
    tester.valid?
    expect(tester.errors[:email]).to include('を入力してください')
  end
  it 'パスワードがなければ無効である' do
    tester.password = nil
    tester.valid?
    expect(tester.errors[:password]).to include('を入力してください')
  end
  it '重複したメールアドレスなら無効である' do
    tester.save
    user = User.new(
      name: 'tester2',
      email: 'tester@example.com',
      password: 'testpass',
      password_confirmation: 'testpass')
      user.valid?
      expect(user.errors[:email]).to include('はすでに存在します')
  end
end
