class ChatMessagesController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    @chat_message = @game.chat_messages.create(
      author: current_user.email,
      author_color: @game.game_players.find_by(user: current_user).color,
      message: params[:chat_message][:message]
    )

    Turbo::StreamsChannel.broadcast_render_to(
      "lobby_#{@game.id}",
      partial: "chat_messages/create",
      locals: { game: @game, chat_message: @chat_message }
    )

    Turbo::StreamsChannel.broadcast_render_to(
      "game_#{@game.id}",
      partial: "chat_messages/create",
      locals: { game: @game, chat_message: @chat_message }
    )

    head :ok

    # respond_to do |format|
    #   format.turbo_stream
    # end
  end
end
