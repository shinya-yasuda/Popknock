require 'rails_helper'

RSpec.describe Result, type: :model do
  let(:user) { FactoryBot.create(:tester)}
  let(:music) { FactoryBot.create(:music)}
  let(:chart) { FactoryBot.create(:easy, music: music)}
  let(:result) { FactoryBot.create(:result, chart: chart, user: user) }
  let(:easy) { FactoryBot.create(:result, :easy_gauge, chart: chart, user: user) }
  let(:hard) { FactoryBot.create(:result, :hard_gauge, chart: chart, user: user) }
  let(:danger) { FactoryBot.create(:result, :danger_gauge, chart: chart, user: user) }
  describe 'get_medal' do
    context 'BAD0の場合' do
      it 'GOODが0ならパーフェクト★メダルになる' do
        expect(result.get_medal).to eq :perfect
      end
      it 'GOOD1~5ならフルコンボ★メダルになる' do
        result.good = 1
        expect(result.get_medal).to eq :fc_star
        result.good = 5
        expect(result.get_medal).to eq :fc_star
      end
      it 'GOOD6~20ならフルコンボ◆メダルになる' do
        result.good = 6
        expect(result.get_medal).to eq :fc_square
        result.good = 20
        expect(result.get_medal).to eq :fc_square
      end
      it 'GOOD21以上ならフルコンボ●メダルになる' do
        result.good = 21
        expect(result.get_medal).to eq :fc_circle
      end
    end
    context 'ゲージが17目盛以上の場合' do
      context 'デンジャーゲージの場合' do
        it 'BADが1~5ならデンジャークリア★メダルになる' do
          danger.gauge_amount = 17
          danger.bad = 1
          expect(danger.get_medal).to eq :danger_star
          result.bad = 5
          expect(danger.get_medal).to eq :danger_star
        end
        it 'BADが6~20ならデンジャークリア◆メダルになる' do
          danger.gauge_amount = 17
          danger.bad = 6
          expect(danger.get_medal).to eq :danger_square
          result.bad = 20
          expect(danger.get_medal).to eq :danger_square
        end
        it 'BADが21以上ならデンジャークリア●メダルになる' do
          danger.gauge_amount = 17
          danger.bad = 21
          expect(danger.get_medal).to eq :danger_circle
          result.bad = 1000
          expect(danger.get_medal).to eq :danger_circle
        end
      end
      context 'ハードゲージの場合' do
        it 'BADが1~5ならハードクリア★メダルになる' do
          hard.gauge_amount = 17
          hard.bad = 1
          expect(hard.get_medal).to eq :hard_star
          result.bad = 5
          expect(hard.get_medal).to eq :hard_star
        end
        it 'BADが6~20ならハードクリア◆メダルになる' do
          hard.gauge_amount = 17
          hard.bad = 6
          expect(hard.get_medal).to eq :hard_square
          result.bad = 20
          expect(hard.get_medal).to eq :hard_square
        end
        it 'BADが21以上ならハードクリア●メダルになる' do
          hard.gauge_amount = 17
          hard.bad = 21
          expect(hard.get_medal).to eq :hard_circle
          result.bad = 1000
          expect(hard.get_medal).to eq :hard_circle
        end
      end
      context 'イージーゲージの場合' do
        it 'BAD0ならフルコンボ以上のメダルになる' do
          easy.good = 21
          expect(easy.get_medal).to eq :fc_circle
        end
        it 'BAD1以上、ゲージが17目盛以上ならイージークリアメダルになる' do
          easy.gauge_amount = 17
          easy.bad = 1
          expect(easy.get_medal).to eq :clear_easy
        end
        it 'ゲージが16目盛以下なら未クリア●メダルになる' do
          easy.gauge_amount = 16
          easy.bad = 25
          expect(easy.get_medal).to eq :fail_circle
        end
      end
      context 'ノーマルゲージの場合' do
        it 'ゲージが15~16目盛なら未クリア★メダルになる' do
          result.gauge_amount = 15
          result.bad = 1
          expect(result.get_medal).to eq :fail_star
          result.bad = 5
          expect(result.get_medal).to eq :fail_star
          result.gauge_amount = 16
          result.bad = 1
          expect(result.get_medal).to eq :fail_star
          result.bad = 5
          expect(result.get_medal).to eq :fail_star
        end
        it 'ゲージが12~14目盛なら未クリア◆メダルになる' do
          result.gauge_amount = 12
          result.bad = 1
          expect(result.get_medal).to eq :fail_square
          result.bad = 5
          expect(result.get_medal).to eq :fail_square
          result.gauge_amount = 14
          result.bad = 1
          expect(result.get_medal).to eq :fail_square
          result.bad = 5
          expect(result.get_medal).to eq :fail_square
        end
        it 'ゲージが11目盛以下なら未クリア●メダルになる' do
          result.gauge_amount = 11
          result.bad = 1
          expect(result.get_medal).to eq :fail_circle
          result.bad = 5
          expect(result.get_medal).to eq :fail_circle
          result.gauge_amount = 0
          result.bad = 1
          expect(result.get_medal).to eq :fail_circle
          result.bad = 5
          expect(result.get_medal).to eq :fail_circle
        end
      end
    end
  end
end
