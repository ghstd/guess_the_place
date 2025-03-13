class GameProgress
  def self.call(game)
    new(game).call
  end

  def initialize(game)
    @game = game
  end

  def next_step_if_all_players_ready
    return unless all_players_ready?
    next_step!
  end

  def next_step!
    ActiveRecord::Base.transaction do
      @game.game_players.lock
      return unless all_players_ready?

      @game.game_players.each do |player|
        player.update(ready: false, answers: player.answers + calculate_score(player))
      end

      if @game.current_step + 1 > @game.steps
        @game.update(phase: "end")
      else
        @game.update(current_step: @game.current_step + 1)
      end
    end
  end

  private

  def all_players_ready?
    @game.game_players.where.not(connection: "offline").where(ready: false).none?
  end

  def calculate_score(player)
    if @game.game_type == "Lesson"
      answer = @game.lesson_state["answer"].map(&:to_i).sum.to_s
      player.current_answer == answer ? 1 : 0
    else
      player.current_answer == @game.answer ? 1 : 0
    end
  end
end
