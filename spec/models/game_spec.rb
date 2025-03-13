require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "associations" do
    it { should have_many(:game_players).dependent(:destroy) }
    it { should have_many(:users).through(:game_players) }
    it { should have_many(:game_coordinates).dependent(:destroy) }
    it { should have_many(:chat_messages).dependent(:destroy) }
    it { should belong_to(:story).optional }
    it { should belong_to(:current_question).class_name("StoryQuestion").optional }
    it { should belong_to(:lesson).optional }
  end

  describe "serializing attributes" do
    it "serializes current_coordinates" do
      game = Game.new(current_coordinates: { x: 10, y: 20 })
      expect(game.current_coordinates).to eq({ "x" => 10, "y" => 20 })
    end

    it "serializes current_streets" do
      game = Game.new(current_streets: [ "Street 1", "Street 2" ])
      expect(game.current_streets).to eq([ "Street 1", "Street 2" ])
    end

    it "serializes lesson_state" do
      game = Game.new(lesson_state: { state: "active" })
      expect(game.lesson_state).to eq({ "state" => "active" })
    end
  end

  describe "callbacks" do
    context "after create" do
      it "broadcasts to games" do
        expect { Game.create!(phase: "lobby") }.to have_broadcasted_to("games")
      end
    end

    context "after update" do
      it "calls GamePhaseHandler when phase changes" do
        game = Game.create!(phase: "lobby")
        expect(GamePhaseHandler).to receive(:call).with(game)
        game.update(phase: "active")
      end

      it "calls GameCurrentStepHandler when current_step changes" do
        game = Game.create!(current_step: 1)
        expect(GameCurrentStepHandler).to receive(:call).with(game)
        game.update(current_step: 2)
      end
    end
  end
end
