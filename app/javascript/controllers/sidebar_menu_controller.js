import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar-menu"
export default class extends Controller {
	connect() {
		this.hideOnClickOutside = this.hideOnClickOutside.bind(this)
		document.addEventListener("click", this.hideOnClickOutside)
	}

	disconnect() {
		document.removeEventListener("click", this.hideOnClickOutside)
	}

	hideOnClickOutside(event) {
		if (!this.element.contains(event.target)) {
			this.element.classList.remove('left_sidebar--active')
			this.element.classList.remove('right_sidebar--active')
		}
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
