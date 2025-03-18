require 'rails_helper'

RSpec.describe GamePhaseHandler, type: :service do
  let(:game) { |example| create(:game, phase: example.metadata[:phase]) }

  subject(:service_call) { described_class.new(game) }

  context "call with different phases of game" do
    it "phase == game runs start_game", phase: 'game' do
      expect { service_call.call }
        .to have_broadcasted_to("games")
        .and have_broadcasted_to("lobby_#{game.id}")
    end

    it "phase == end runs finish_game", phase: 'end' do
      create_list(:game_player, 3, game: game)

      allow(GamesStatistic).to receive(:create!)
      expect { service_call.call }.to have_broadcasted_to("game_#{game.id}")
      expect(GamesStatistic).to have_received(:create!).exactly(3).times
    end

    it "phase == delete runs delete_game", phase: 'delete' do
      game.reload
      expect { service_call.call }.to change(Game, :count).by(-1)
      expect(game.destroyed?).to be true
    end
  end
end
