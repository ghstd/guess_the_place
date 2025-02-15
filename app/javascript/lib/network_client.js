export default class NetworkClient {

	static SERVER_URL = 'http://127.0.0.1:3000'

	static async setPlayerReady(gameId, playerState) {
		try {
			const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
			const response = await fetch(`${this.SERVER_URL}/games/${gameId}/player_ready`, {
				method: 'PATCH',
				headers: {
					'X-CSRF-Token': csrfToken,
					'Content-Type': 'application/json'
				},
				body: JSON.stringify(playerState)
			})
			if (!response.ok) {
				throw new Error(`Ошибка ${response.status}: ${response.statusText}`)
			}
		} catch (error) {
			console.error("Ошибка в NetworkClient.getRandomStreets:", error)
		}
	}
}