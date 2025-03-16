require 'rails_helper'

RSpec.describe GameCurrentStepHandler, type: :service do
  let(:game) { |example| create(:game, game_type: example.metadata[:game_type]) }

  subject(:service_call) { described_class.call(game) }

  context "call with different game_types" do
    it "game_type == Lesson runs LessonGameStateUpdater", game_type: 'Lesson' do
      allow(LessonGameStateUpdater).to receive(:call)
      service_call
      expect(LessonGameStateUpdater).to have_received(:call).with(game)
    end

    it "game_type == Story runs StoryGameStateUpdater", game_type: 'Story' do
      allow(StoryGameStateUpdater).to receive(:call)
      service_call
      expect(StoryGameStateUpdater).to have_received(:call).with(game)
    end

    it "game_type == Random runs RandomGameStateUpdater", game_type: 'Random' do
      allow(RandomGameStateUpdater).to receive(:call)
      service_call
      expect(RandomGameStateUpdater).to have_received(:call).with(game)
    end
  end
end
