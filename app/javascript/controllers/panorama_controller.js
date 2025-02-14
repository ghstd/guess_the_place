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

	connect() {

		const coords = JSON.parse(this.element.querySelector('[data-coords]').dataset.coords)
		let step = 0

		const loader = new Loader({
			apiKey: this.element.dataset.apiKey,
			version: 'weekly'
		})

		loader.load()
			.then(async () => {

				const panoramaEl = this.element.querySelector('.game__panorama')
				const position = { lat: coords[step][0], lng: coords[step][1] }
				const pano = new google.maps.StreetViewPanorama(panoramaEl, {
					position: position,
					clickToGo: false,
					linksControl: false,
					disableDefaultUI: true,
					showRoadLabels: false,
					fullscreenControl: true
				})

				await this.addQuestionOptions(position)
				step++

				const readyButton = this.element.querySelector('#game_ready_button')
				readyButton.onclick = async () => {
					if (step >= coords.length) return

					const position = { lat: coords[step][0], lng: coords[step][1] }
					pano.setPosition(position)

					await this.addQuestionOptions(position)
					step++
				}

			})
			.catch(error => console.log(`Error in connect() ==> loader.load(): ${error}`))
	}
}



