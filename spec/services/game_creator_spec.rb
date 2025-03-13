require 'rails_helper'

RSpec.describe GameCreator, type: :service do
  let(:user) { create(:user) }
  let(:params) { { name: "Test Game", game_type: "Random", steps: 5 } }

  subject(:service_call) { described_class.call(params, user) }

  context "creating a Random game" do
    it "creates a game with the given attributes" do
      game = service_call
      expect(game).to be_persisted
      expect(game.name).to eq("Test Game")
      expect(game.game_type).to eq("Random")
      expect(game.steps).to eq(5)
    end

    it "assigns the user as creator" do
      game = service_call
      expect(game.creator).to eq(user.short_email)
    end

    it "adds one game player" do
      game = service_call
      expect(game.game_players.count).to eq(1)
      expect(game.game_players.first.user).to eq(user)
    end

    it "generates random coordinates" do
      create_list(:random_coordinate, 10)
      game = service_call
      expect(game.game_coordinates.count).to eq(5)
    end
  end

  context "creating a Story game" do
    let(:story) { create(:story) }
    let(:params) { { story_id: story.id } }

    it "sets the story and updates game attributes" do
      game = service_call
      expect(game.story).to eq(story)
      expect(game.name).to eq(story.name)
      expect(game.steps).to eq(3)
      expect(game.current_question).to eq(story.story_questions.first)
    end
  end

  context "creating a game Lesson" do
    let(:lesson) { create(:lesson) }
    let(:params) { { lesson_id: lesson.id } }

    it "sets the lesson and updates game attributes" do
      game = service_call
      expect(game.lesson).to eq(lesson)
      expect(game.name).to eq(lesson.name)
      expect(game.steps).to eq(3)
      expect(game.lesson_state).to be_present
    end
  end

  context "when game fails to save" do
    before { allow_any_instance_of(Game).to receive(:save).and_return(false) }

    it "returns nil" do
      expect(service_call).to be_nil
    end
  end
end
