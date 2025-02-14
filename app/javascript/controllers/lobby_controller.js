import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	connect() {
		this.turboRenderHandler = this.turboRenderHandler.bind(this)
		document.addEventListener('turbo:before-stream-render', this.turboRenderHandler)
	}

	disconnect() {
		document.removeEventListener('turbo:before-stream-render', this.turboRenderHandler)
	}

	turboRenderHandler(event) {
		const targetId = event.target.getAttribute("target")

		if (targetId === 'meta') {
			const url = event.target
				.querySelector('template')
				.content
				.querySelector('meta[url]')
				.getAttribute('url')

			const button = this.element.querySelector('#lobby_start_button')
			if (button) {
				button.style.display = 'none'
			}

			const timer = this.element.querySelector('.lobby__timer')
			timer.textContent = 5
			let counter = 4
			const stopId = setInterval(() => {
				if (counter > 0) {
					timer.textContent = counter
					counter--
				} else {
					clearInterval(stopId)
					console.log(url)
					window.location.href = url
				}
			}, 1000)
		}
	}
}
