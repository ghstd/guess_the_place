import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

	connect() {
		const targets = this.element.querySelectorAll('.navigation__nested_menu')
		targets.forEach((target) => {
			target.onclick = () => {
				this.element.querySelectorAll('li').forEach((li) => {
					if (li !== target) {
						li.style.display = 'none'
					} else {
						target.classList.add('navigation__nested_menu--active')
						target.querySelector('span').classList.remove('navigation__link')
						this.element.querySelector('.navigation__close').style.display = 'block'
					}
				})
			}
		})

		this.element.querySelector('.navigation__close').onclick = (e) => {
			if (e.target !== this.element.querySelector('.navigation__close')) return
			this.element.querySelectorAll('li').forEach((li) => {
				li.style.display = 'block'
				if (li.classList.contains('navigation__nested_menu--active')) {
					li.classList.remove('navigation__nested_menu--active')
					li.querySelector('span').classList.add('navigation__link')
				}
			})
			this.element.querySelector('.navigation__close').style.display = 'none'
		}
	}

	disconnect() {
		this.element.querySelectorAll('li').forEach((li) => {
			li.style.display = 'block'
			if (li.classList.contains('navigation__nested_menu--active')) {
				li.classList.remove('navigation__nested_menu--active')
				li.querySelector('span').classList.add('navigation__link')
			}
		})
		this.element.querySelector('.navigation__close').style.display = 'none'
	}
}
