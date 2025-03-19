import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	connect() {
		const addOptionBtn = this.element.querySelector('.editor__options button[type="button"]')
		addOptionBtn.onclick = () => {
			addOptionBtn.insertAdjacentHTML("beforebegin", this.getOptionHtml())
		}

		const addQuestionBtn = this.element.querySelector('.editor__controls button[type="button"]')
		addQuestionBtn.onclick = this.addQuestionHandler

		this.formSubmitHandler = this.formSubmitHandler.bind(this)
		document.addEventListener("turbo:submit-end", this.formSubmitHandler)
	}

	addQuestionHandler = () => {
		const ul = this.element.querySelector('.editor__list')
		const li = document.createElement('li')
		li.innerHTML = this.getQuestionHtml()

		const button = li.querySelector('button')
		button.onclick = () => {
			button.insertAdjacentHTML("beforebegin", this.getOptionHtml())
		}

		const close = li.querySelector('span')
		close.onclick = () => {
			li.remove()
		}

		ul.appendChild(li)

		const headers = this.element.querySelectorAll('.editor__list h3')
		headers.forEach((header, index) => {
			header.textContent = `Вопрос ${index + 1}`
		})
	}

	getOptionHtml() {
		return `
			<input placeholder="Вариант ответа" type="text" name="data[questions][][options][]" id="data[questions][][options][]">
		`.trim()
	}

	getQuestionHtml() {
		return `
			<span>&times;</span>
			<h3>Вопрос #1</h3>
			
			<label>Координаты:</label>
			<div>
				<input placeholder="Lat" type="text" name="data[questions][][coordinates][]" id="data[questions][][coordinates][]">
				<input placeholder="Long" type="text" name="data[questions][][coordinates][]" id="data[questions][][coordinates][]">
			</div>

			<label>Вопрос:</label>
			<input placeholder="Вопрос" type="text" name="data[questions][][question]" id="data[questions][][question]">

			<label>Ответ:</label>
			<input placeholder="Ответ" type="text" name="data[questions][][answer]" id="data[questions][][answer]">

			<label>Список всех вариантов ответа (обязательно включая правильный):</label>
			<div class="editor__options">
				<input placeholder="Вариант ответа" type="text" name="data[questions][][options][]" id="data[questions][][options][]">
				<button type="button">Добавить вариант ответа</button>
			</div>
		`.trim()
	}

	formSubmitHandler(event) {
		const { success } = event.detail
		if (success) {
			console.log("Форма отправлена успешно", success)
		} else {
			console.log("Ошибка при отправке формы", success)
		}
	}

	disconnect() {
		document.removeEventListener("turbo:submit-end", this.formSubmitHandler)
	}
}
