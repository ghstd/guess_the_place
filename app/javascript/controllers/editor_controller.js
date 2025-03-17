import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["storyFields", "lessonFields", "modeSelect"]

	connect() {
		this.toggleFields()

		this.handlerMap = new WeakMap()

		const plusButtons = this.element.querySelectorAll('.editor__plus_btn')
		plusButtons.forEach((plusButton) => {
			const handler = this.plusButtonHandler.bind(this, plusButton)
			this.handlerMap.set(plusButton, handler)
			plusButton.addEventListener('click', handler)
		})

		const saveButton = this.element.querySelector('.editor__save button')
		saveButton.addEventListener('click', this.saveButtonHandler)
	}

	plusButtonHandler = (plusButton) => {
		const html = this.generateHtml()
		plusButton.insertAdjacentHTML("beforebegin", html);
	}

	saveButtonHandler = () => {
		const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
		const mode = this.modeSelectTarget.value
		const inputs = this.element.querySelectorAll(`[data-editor-target="${mode}Fields"] input`)
		const formData = new FormData()

		inputs.forEach(input => {
			formData.append(input.name, input.value)
		})

		if (mode === "story") {
			const options = Array.from(this.element.querySelectorAll(`[data-editor-target="${mode}Fields"] input[name="option"]`)).map(input => input.value)
			formData.append("option", options.join("|"))
		}

		if (mode === "lesson") {
			const answers = Array.from(this.element.querySelectorAll(`[data-editor-target="${mode}Fields"] input[name="answer"]`)).map(input => input.value)
			formData.append("answer", answers.join("|"))
		}


		fetch(`${this.element.dataset.serverUrl}/editor_create?mode=${mode}&user_id=${this.element.dataset.userId}`, {
			method: "POST",
			headers: {
				'X-CSRF-Token': csrfToken
			},
			body: formData
		})
			.then(response => response.json())
			.then(data => {
				if (data.redirect_url) {
					window.location.href = data.redirect_url
				}
			})
	}

	toggleFields() {
		const mode = this.modeSelectTarget.value

		this.storyFieldsTarget.classList.toggle("editor__show", mode === "story")
		this.lessonFieldsTarget.classList.toggle("editor__show", mode === "lesson")
	}

	generateHtml() {
		const mode = this.modeSelectTarget.value
		if (mode === "story") return '<input type="text" name="option">'
		if (mode === "lesson") return '<input type="text" name="answer">'
	}

	disconnect() {
		const plusButtons = this.element.querySelectorAll('.editor__plus_btn')
		plusButtons.forEach((plusButton) => {
			const handler = handlerMap.get(plusButton)
			if (handler) {
				plusButton.removeEventListener('click', handler)
				handlerMap.delete(plusButton)
			}
		})

		const saveButton = this.element.querySelector('.editor__save button')
		saveButton.removeEventListener('click', this.saveButtonHandler)
	}
}
