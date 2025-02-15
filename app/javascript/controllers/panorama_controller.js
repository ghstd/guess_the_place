// @ts-nocheck
import { Controller } from "@hotwired/stimulus"
import { Loader } from "@googlemaps/js-api-loader"

import { shuffleArray } from "../lib/utils"
import NetworkClient from "../lib/network_client"

export default class extends Controller {

	async connect() {

		this.state = {
			ready: false,
			answer: ''
		}

		document.addEventListener('turbo:before-stream-render', (event) => {
			console.log('turbo:before-stream-render')
			console.log(event.target)
		})


		const gameId = this.element.querySelector('meta[data-game-id]').dataset.gameId
		const coordsJson = this.element.querySelector('meta[data-game-coords]').dataset.gameCoords
		const coords = JSON.parse(coordsJson)

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

				const readyButton = this.element.querySelector('#game_ready_button')
				readyButton.onclick = async () => {

					if (readyButton.classList.contains('active')) {
						this.state.ready = false
						readyButton.disabled = true
						await NetworkClient.setPlayerReady(gameId, this.state)
						readyButton.disabled = false
						readyButton.classList.remove('active')
						readyButton.textContent = 'Готов'
					} else {
						this.state.ready = true
						readyButton.disabled = true
						await NetworkClient.setPlayerReady(gameId, this.state)
						readyButton.disabled = false
						readyButton.classList.add('active')
						readyButton.textContent = 'Отмена'
					}





					// const position = { lat: coords[0], lng: coords[1] }
					// pano.setPosition(position)

					// await this.addQuestionOptions(position)
				}

			})
			.catch(error => console.log(`Error in connect() ==> loader.load(): ${error}`))
	}
}



