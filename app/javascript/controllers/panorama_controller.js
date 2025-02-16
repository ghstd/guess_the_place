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

			const targetId = event.target.getAttribute("target")

			if (targetId === 'game_coords') {
				const coordsJson = event.target
					.querySelector('template')
					.content
					.querySelector('meta[data-game-coords]')
					.dataset.gameCoords

				const coords = JSON.parse(coordsJson)
				const position = { lat: coords[0], lng: coords[1] }
				this.pano.setPosition(position)

				const readyButton = this.element.querySelector('#game_ready_button')
				readyButton.classList.remove('active')
				readyButton.textContent = 'Готов'
				this.state.ready = false
				this.state.answer = ''
			}
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
				this.pano = new google.maps.StreetViewPanorama(panoramaEl, {
					position: position,
					clickToGo: false,
					linksControl: false,
					disableDefaultUI: true,
					showRoadLabels: false,
					fullscreenControl: true
				})
			})
			.catch(error => console.log(`Error in connect() ==> loader.load(): ${error}`))

		const readyButton = this.element.querySelector('#game_ready_button')
		readyButton.onclick = async () => {

			if (readyButton.classList.contains('active')) {
				this.state.ready = false
				this.state.answer = ''
				readyButton.classList.remove('active')
				readyButton.textContent = 'Готов'
				await NetworkClient.setPlayerReady(gameId, this.state)
			} else {
				this.state.ready = true
				readyButton.classList.add('active')
				readyButton.textContent = 'Отмена'
				await NetworkClient.setPlayerReady(gameId, this.state)
			}
		}

	}
}



