class StoryGameStateUpdater
  def self.call(game)
    new(game).call
  end

  def initialize(game)
    @game = game
  end

  def call
    set_state!
    @game.broadcast_render_to "game_#{@game.id}", partial: "games/turbo_stream/update_show", locals: { game: @game }
  end

  private

  def set_state!
    return unless @game.story.present?
    next_question = @game.story.story_questions[@game.current_step - 1]
    @game.update(
      current_question: next_question,
      answer: next_question.answer,
      current_coordinates: next_question.coordinates
    )
  end
end
