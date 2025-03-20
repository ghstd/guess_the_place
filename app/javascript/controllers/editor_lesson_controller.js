import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	connect() {
		const addOptionBtn = this.element.querySelector('.editor__options button[type="button"]')
		addOptionBtn.onclick = () => {
			addOptionBtn.insertAdjacentHTML("beforebegin", this.getOptionHtml())
		}

		const addQuestionBtn = this.element.querySelector('.editor__controls button[type="button"]')
		addQuestionBtn.onclick = this.addQuestionHandler
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
			this.numerateFeaders()
		}

		ul.appendChild(li)

		this.numerateFeaders()
	}

	getOptionHtml() {
		return `
			<input placeholder="Вариант ответа" type="text" name="data[questions][][answers][]" id="data[questions][][answers][]">
		`.trim()
	}

	getQuestionHtml() {
		return `
			<span>&times;</span>
			<h3>Вопрос 1</h3>

			<label>Ссылка на изображение (только https):</label>
			<input placeholder="Изображение (необязательно)" type="text" name="data[questions][][image]" id="data[questions][][image]">

			<label>Вопрос:</label>
			<input placeholder="Вопрос" type="text" name="data[questions][][question]" id="data[questions][][question]">

			<label>Список только правильных ответов (может быть несколько):</label>
			<div class="editor__options">
				<input placeholder="Вариант ответа" type="text" name="data[questions][][answers][]" id="data[questions][][answers][]">
				<button type="button">Добавить вариант ответа</button>
			</div>
		`.trim()
	}

	numerateFeaders() {
		const headers = this.element.querySelectorAll('.editor__list h3')
		headers.forEach((header, index) => {
			header.textContent = `Вопрос ${index + 1}`
		})
	}
}
