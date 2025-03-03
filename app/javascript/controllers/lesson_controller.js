// @ts-nocheck
import { Controller } from "@hotwired/stimulus"
import { Loader } from "@googlemaps/js-api-loader"

import { shuffleArray } from "../lib/utils"
import NetworkClient from "../lib/network_client"

export default class extends Controller {

	updateOptionsHandler(event) {
		const targetId = event.target.getAttribute("target")

		if (targetId === 'game_options') {
			const readyButton = this.element.querySelector('#game_ready_button')
			readyButton.classList.remove('active')
			readyButton.textContent = 'Готов'
			this.state.ready = false
			this.state.answer = []
		}
	}

	clickOptionHandler(event) {
		if (this.state.ready) return

		if (event.target.classList.contains('game__option')) {
			if (event.target.classList.contains('game__option--active')) {
				event.target.classList.remove('game__option--active')
				const index = this.state.answer.findIndex(el => el === event.target.dataset.optionId)
				this.state.answer.splice(index, 1)
			} else {
				event.target.classList.add('game__option--active')
				this.state.answer.push(event.target.dataset.optionId)
			}
		}
	}

	async connect() {

		this.updateOptionsHandler = this.updateOptionsHandler.bind(this)
		this.clickOptionHandler = this.clickOptionHandler.bind(this)

		document.addEventListener('turbo:before-stream-render', this.updateOptionsHandler)
		this.element.addEventListener('click', this.clickOptionHandler)

		this.state = {
			ready: false,
			answer: []
		}

		const gameId = this.element.querySelector('meta[data-game-id]').dataset.gameId
		const playerId = this.element.querySelector('meta[data-player-id]').dataset.playerId

		const readyButton = this.element.querySelector('#game_ready_button')
		readyButton.onclick = async () => {
			if (readyButton.classList.contains('active')) {
				this.state.ready = false
				this.state.answer = []
				readyButton.classList.remove('active')
				readyButton.textContent = 'Готов'
				await NetworkClient.setPlayerReady(this.element.dataset.serverUrl, gameId, this.state)
			} else {
				this.state.ready = true
				readyButton.classList.add('active')
				readyButton.textContent = 'Отмена'
				await NetworkClient.setPlayerReady(this.element.dataset.serverUrl, gameId, this.state)
			}
		}
	}

	disconnect() {
		document.removeEventListener('turbo:before-stream-render', this.updateOptionsHandler)
		this.element.removeEventListener('click', this.clickOptionHandler)
	}
}



