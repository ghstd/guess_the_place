class GamePhaseHandler
  def self.call(game)
    new(game).call
  end

  def initialize(game)
    @game = game
  end

  def call
    case @game.phase
    when "game"
      start_game
    when "end"
      finish_game
    when "delete"
      delete_game
    end
  end

  private

  def start_game
    @game.broadcast_render_to "games", partial: "games/turbo_stream/delete_index_games", locals: { game: @game }
    @game.broadcast_render_to "lobby_#{@game.id}", partial: "games/turbo_stream/lobby_add_meta", locals: { game: @game }
  end

  def finish_game
    @game.broadcast_render_to "game_#{@game.id}", partial: "games/turbo_stream/show_end_game", locals: { game: @game }

    @game.game_players.each do |game_player|
      GamesStatistic.create!(
        user: game_player.user,
        name: @game.name,
        game_type: @game.game_type,
        questions: @game.steps,
        answers: game_player.answers
      )
    end
  end

  def delete_game
    @game.destroy
  end
end
