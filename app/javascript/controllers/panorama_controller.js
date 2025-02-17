// @ts-nocheck
import { Controller } from "@hotwired/stimulus"
import { Loader } from "@googlemaps/js-api-loader"

import { shuffleArray } from "../lib/utils"
import NetworkClient from "../lib/network_client"

export default class extends Controller {

	updatePanoramaHandler(event) {
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
	}

	clickOptionHandler(event) {
		if (event.target.classList.contains('game__option')) {

			if (this.state.ready) return

			if (!event.target.classList.contains('game__option--active')) {
				const options = this.element.querySelectorAll('.game__option')

				options.forEach((option) => {
					option.classList.remove('game__option--active')
				})

				event.target.classList.add('game__option--active')
				this.state.answer = event.target.textContent
			}
		}
	}

	async connect() {

		this.updatePanoramaHandler = this.updatePanoramaHandler.bind(this)
		this.clickOptionHandler = this.clickOptionHandler.bind(this)

		document.addEventListener('turbo:before-stream-render', this.updatePanoramaHandler)
		this.element.addEventListener('click', this.clickOptionHandler)

		this.state = {
			ready: false,
			answer: ''
		}

		const gameId = this.element.querySelector('meta[data-game-id]').dataset.gameId
		const playerId = this.element.querySelector('meta[data-player-id]').dataset.playerId

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

	disconnect() {
		document.removeEventListener('turbo:before-stream-render', this.updatePanoramaHandler)
		this.element.removeEventListener('click', this.clickOptionHandler)
	}
}



