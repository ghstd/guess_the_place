import { Controller } from "@hotwired/stimulus"
import consumer from "../lib/consumer"

export default class extends Controller {
	connect() {
		const gameId = this.element.querySelector('meta[data-game-id]').dataset.gameId
		const playerId = this.element.querySelector('meta[data-player-id]').dataset.playerId
		const channelPrefix = this.element.querySelector('meta[data-channel-prefix]').dataset.channelPrefix

		this.subscription = consumer.subscriptions.create(
			{
				channel: "GameObserverChannel",
				game_id: gameId,
				player_id: playerId,
				channel_prefix: channelPrefix
			}
		)
	}

	disconnect() {
		this.subscription.unsubscribe()
	}
}