import { Controller } from "@hotwired/stimulus"
import consumer from "../lib/consumer"

export default class extends Controller {
	connect() {
		const gameId = this.element.querySelector('meta[data-game-id]').dataset.gameId
		const playerId = this.element.querySelector('meta[data-player-id]').dataset.playerId

		this.subscription = consumer.subscriptions.create(
			{
				channel: "GameObserverChannel",
				game_id: gameId,
				player_id: playerId
			}
		)
	}

	disconnect() {
		this.subscription.unsubscribe()
	}
}