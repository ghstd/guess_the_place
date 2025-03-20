import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	connect() {
		this.hideOnClickOutside = this.hideOnClickOutside.bind(this)
		document.addEventListener("click", this.hideOnClickOutside)
	}

	disconnect() {
		document.removeEventListener("click", this.hideOnClickOutside)
	}

	show() {
		this.element.querySelector(".header__menu").classList.toggle("header__menu--active")
	}

	hideOnClickOutside(event) {
		if (!this.element.contains(event.target)) {
			this.element.querySelector(".header__menu").classList.remove("header__menu--active")
		}
	}
}
