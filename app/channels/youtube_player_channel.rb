class YoutubePlayerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "youtube_player_#{params[:game_id]}"
  end

  def receive(data)
    ActionCable.server.broadcast("youtube_player_#{params[:game_id]}", data)
  end

  def unsubscribed
  end
end
