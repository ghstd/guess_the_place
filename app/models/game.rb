class Game < ApplicationRecord
  serialize :current_coordinates, coder: JSON
  serialize :current_streets, coder: JSON
  serialize :lesson_state, coder: JSON

  has_many :game_players, dependent: :destroy
  has_many :users, through: :game_players
  has_many :game_coordinates, dependent: :destroy
  has_many :chat_messages, dependent: :destroy

  belongs_to :story, optional: true
  belongs_to :current_question, class_name: "StoryQuestion", optional: true

  belongs_to :lesson, optional: true

  after_create_commit do
    games = Game.where(phase: "lobby")
    broadcast_render_to "games", partial: "games/turbo_stream/add_index_games", locals: { games: games }
  end

  after_update_commit do
    if saved_change_to_attribute?(:phase)
      GamePhaseHandler.call(self)
    end

    if saved_change_to_attribute?(:current_step)
      GameCurrentStepHandler.call(self)
    end
  end
end
