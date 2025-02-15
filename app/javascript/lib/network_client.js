export default class NetworkClient {

	static SERVER_URL = 'http://127.0.0.1:3000'
	static STREETS_URL = 'https://nominatim.openstreetmap.org/reverse'

	static async getRandomStreets() {
		try {
			const response = await fetch(`${this.SERVER_URL}/streets`)
			if (!response.ok) {
				throw new Error(`Ошибка ${response.status}: ${response.statusText}`)
			}
			const result = await response.json()
			return result
		} catch (error) {
			console.error("Ошибка в NetworkClient.getRandomStreets:", error)
			return { error: error.message }
		}
	}

	static async getGeodata(gameId) {
		try {
			const response = await fetch(`${this.SERVER_URL}/games/${gameId}/get_geodata`)
			if (!response.ok) {
				throw new Error(`Ошибка ${response.status}: ${response.statusText}`)
			}
			const result = await response.json()
			return result
		} catch (error) {
			console.error("Ошибка в NetworkClient.getRandomStreets:", error)
			return { error: error.message }
		}
	}

	static async getStreetByCoords(position) {
		try {
			const response = await fetch(`${this.STREETS_URL}?format=json&lat=${position.lat}&lon=${position.lng}&accept-language=uk`)
			if (!response.ok) {
				throw new Error(`Ошибка ${response.status}: ${response.statusText}`)
			}
			const result = await response.json()
			return result.address.road
		} catch (error) {
			console.error("Ошибка в NetworkClient.getStreetByCoords:", error)
			return { error: error.message }
		}
	}

}