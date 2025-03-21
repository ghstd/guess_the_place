require "net/http"

class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [ :show, :update_game_phase ]
  before_action :authorize_player, only: :show
  before_action :redirect_if_lobby, only: :show
  def index
    @games = Game.includes(:users).where(phase: "lobby")
  end

  def stories
    @stories = Story.all
  end

  def lessons
    @lessons = Lesson.all
  end

  def create_random
    @game = GameCreator.call({}, current_user)
    handle_game_creation
  end

  def create_story
    @game = GameCreator.call({ story_id: params[:story_id], game_type: "Story" }, current_user)
    handle_game_creation
  end

  def create_lesson
    @game = GameCreator.call({ lesson_id: params[:lesson_id], game_type: "Lesson" }, current_user)
    handle_game_creation
  end

  def create_video
    @game = GameCreator.call({ name: "Video", game_type: "Video" }, current_user)
    handle_game_creation
  end

  def lobby
    @game = Game.includes(:users, :chat_messages).find_by(id: params[:id])
    @game_player = @game.game_players.find_by(user: current_user)
    unless @game && @game.phase == "lobby" && @game_player
      return redirect_to root_path
    end

    @creator = @game.creator == current_user.short_email
  end

  def show
    case @game.game_type
    when "Video"
      render :show_video
    when "Lesson"
      render :show_lesson
    when "Random"
      @game.with_lock { RandomGameStateUpdater.call(@game).set_state_if_not_exist! }
    end
  end

  def player_ready
    game = Game.find(params[:id])
    game_player = game.game_players.find_by(user: current_user)
    if game.game_type == "Lesson"
      answer = params[:answer].map(&:to_i).sum.to_s
    else
      answer = params[:answer]
    end
    game_player.ready!(params[:ready], answer)
    head :ok
  end

  def add_player
    @game = Game.includes(:game_players).find(params[:id])
    @game.game_players.find_or_create_by(user: current_user) do |player|
      player.color = Utils::ColorGenerator.get_color(@game.game_players.size)
    end

    redirect_to lobby_game_path(@game)
  end

  def update_game_phase
    @game.update(phase: "game") ? head(:ok) : redirect_to(root_path)
  end

  private

  def handle_game_creation
    if @game
      redirect_to lobby_game_path(@game)
    else
      redirect_to root_path
    end
  end

  def set_game
    @game = Game.find_by(id: params[:id])
    redirect_to root_path unless @game
  end

  def authorize_player
    @game_player = @game.game_players.find_by(user: current_user)
    redirect_to root_path unless @game_player
  end

  def redirect_if_lobby
    redirect_to lobby_game_path(@game) if @game.phase == "lobby"
  end
end
