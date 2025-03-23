import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar-menu"
export default class extends Controller {
	connect() {
	}

	toggle() {
		if (this.element.classList.contains('left_sidebar')) {
			this.element.classList.toggle('left_sidebar--active')
			return
		}

		if (this.element.classList.contains('right_sidebar')) {
			this.element.classList.toggle('right_sidebar--active')
			return
		}
	}
}
