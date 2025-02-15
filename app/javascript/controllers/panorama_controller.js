// @ts-nocheck
import { Controller } from "@hotwired/stimulus"
import { Loader } from "@googlemaps/js-api-loader"

import { shuffleArray } from "../lib/utils"
import NetworkClient from "../lib/network_client"

export default class extends Controller {

	showErrorEl(error) {
		this.element.querySelector('.game__options').innerHTML = `<li>${error}</li>`
	}

	async addQuestionOptions(position) {
		const options = await NetworkClient.getRandomStreets()
		if (options.error) {
			this.showErrorEl(options.error)
			return
		}
		const answer = await NetworkClient.getStreetByCoords(position)
		if (answer.error) {
			this.showErrorEl(answer.error)
			return
		}

		const optionsShuffled = shuffleArray([...options, answer])
		const optionsEl = this.element.querySelector('.game__options')
		optionsEl.innerHTML = optionsShuffled.map(option => `<li>${option}</li>`).join('')
	}

	async connect() {

		const gameId = this.element.querySelector('meta[data-game-id]').dataset.gameId
		const coords = await NetworkClient.getGeodata(gameId)
		if (coords.error) {
			this.showErrorEl(coords.error)
			return
		}

		const loader = new Loader({
			apiKey: this.element.dataset.apiKey,
			version: 'weekly'
		})

		loader.load()
			.then(async () => {

				const panoramaEl = this.element.querySelector('.game__panorama')
				const position = { lat: coords[0], lng: coords[1] }
				const pano = new google.maps.StreetViewPanorama(panoramaEl, {
					position: position,
					clickToGo: false,
					linksControl: false,
					disableDefaultUI: true,
					showRoadLabels: false,
					fullscreenControl: true
				})

				await this.addQuestionOptions(position)

				const readyButton = this.element.querySelector('#game_ready_button')
				readyButton.onclick = async () => {

					const coords = await NetworkClient.getGeodata(gameId)
					if (coords.error) {
						this.showErrorEl(coords.error)
						return
					}

					const position = { lat: coords[0], lng: coords[1] }
					pano.setPosition(position)

					await this.addQuestionOptions(position)
				}

			})
			.catch(error => console.log(`Error in connect() ==> loader.load(): ${error}`))
	}
}



