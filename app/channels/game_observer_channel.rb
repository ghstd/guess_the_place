class GameObserverChannel < ApplicationCable::Channel
  def subscribed
    stream_name = "#{params[:channel_prefix]}_#{params[:game_id]}"
    stream_from stream_name

    player = GamePlayer.find_by(id: params[:player_id])
    return unless player

    ActiveRecord::Base.transaction do
      player.with_lock do
        subscribtions = (player.subscribtions + [ stream_name ]).uniq
        player.update(connection: "online", subscribtions: subscribtions)
      end
    end
  end

  def unsubscribed
    stream_name = "#{params[:channel_prefix]}_#{params[:game_id]}"

    player = GamePlayer.find_by(id: params[:player_id])
    return unless player

    ActiveRecord::Base.transaction do
      player.with_lock do
        subscribtions = player.subscribtions.dup
        index = subscribtions.index(stream_name)
        subscribtions.delete_at(index) if index
        player.update(subscribtions: subscribtions, connection: "pending")
      end
    end

    CheckPlayerSubscribtionsJob.set(wait: 5.seconds).perform_later(player.id)
  end
end
