class GameCurrentStepHandler
  def self.call(game)
    new(game).call
  end

  def initialize(game)
    @game = game
  end

  def call
    case @game.game_type
    when "Lesson"
      LessonGameStateUpdater.call(@game)
    when "Story"
      StoryGameStateUpdater.call(@game)
    when "Random"
      RandomGameStateUpdater.call(@game)
    end
  end
end
