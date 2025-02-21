require "net/http"

class GamesController < ApplicationController
  before_action :authenticate_user!
  def index
    @games = Game.includes(:users).where(phase: "lobby")
  end

  def stories
    @stories = Story.all
  end

  def create
    @game = Game.new

    @game.name = "Random"
    @game.game_type = "Random"
    @game.steps = 10
    @game.current_step = 1
    @game.phase = "lobby"
    @game.game_players.build(user: current_user, color: get_random_color(0))
    @game.creator = current_user.short_email

    coords = RandomCoordinate.order(Arel.sql("RANDOM()")).limit(@game.steps).pluck("lat", "long")

    if @game.save
      coords.each do |coord|
        @game.game_coordinates.create(lat: coord[0], long: coord[1])
      end
      redirect_to lobby_game_path(@game)
    else
      redirect_to root_path
    end
  end

  def create_story
    story = Story.find(params[:story_id])

    @game = Game.new
    @game.story = story
    @game.name = story.name
    @game.game_type = "Story"
    @game.steps = story.story_questions.count
    @game.current_step = 1
    @game.phase = "lobby"
    @game.game_players.build(user: current_user, color: get_random_color(0))
    @game.creator = current_user.short_email

    @game.current_question = story.story_questions.first
    @game.answer = @game.current_question.answer
    @game.current_coordinates = @game.current_question.coordinates

    if @game.save
      redirect_to lobby_game_path(@game)
    else
      redirect_to root_path
    end
  end

  def show
    @game = Game.find_by(id: params[:id])
    if @game.nil?
      redirect_to root_path
      return
    end

    @game_player = @game.game_players.find_by(user: current_user)
    if !@game_player
      redirect_to root_path
      return
    end

    if @game.phase == "lobby"
      redirect_to lobby_game_path(@game)
      return
    end

    if @game.game_type == "Random"
      @game.with_lock do
        unless @game.game_state_exists?
          @game.set_game_state!
        end
      end
    end
  end

  def player_ready
    game = Game.find(params[:id])
    game_player = game.game_players.find_by(user: current_user)
    game_player.ready!(params[:ready], params[:answer])

    head :ok
  end

  def add_player
    @game = Game.includes(:game_players).find(params[:id])
    @game.game_players.find_or_create_by(user: current_user) do |player|
      index = @game.game_players.size
      player.color = get_random_color(index)
    end

    redirect_to lobby_game_path(@game)
  end

  def update_game_phase
    @game = Game.find(params[:id])
    if @game.update(phase: "game")
      head :ok
    else
      redirect_to root_path
    end
  end

  def lobby
    @game = Game.includes(:users, :chat_messages).find(params[:id])

    if @game.phase != "lobby"
      redirect_to root_path
      return
    end

    @creator = @game.creator == current_user.short_email
  end

  private

  def get_random_color(index)
    colors = [
      "#1570BF",
      "#2B7F3A",
      "#ABD948",
      "#F2B90F",
      "#D97904",
      "#F23827",
      "#0D8D88"
    ]
    colors[index % colors.count]
  end
end
