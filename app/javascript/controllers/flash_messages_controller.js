import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

	connect() {
		if (this.element.id === "error_explanation") return

		setTimeout(this.changeWidth.bind(this, '100%'), 1000)
		setTimeout(() => this.close(), 5000)
	}

	changeWidth(width) {
		this.element.style.setProperty('--time-line-width', width)
	}

	close() {
		this.element.remove()
	}
}
