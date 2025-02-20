import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

	chatSubmitHandler = () => {
		const input = this.element.querySelector('.chat__input')
		input.value = ''
	}

	scrollChatToBottom() {
		this.messagesContainer.scrollTop = this.messagesContainer.scrollHeight
	}

	connect() {
		const form = this.element.querySelector('.chat__form')
		form.addEventListener('turbo:submit-end', this.chatSubmitHandler)

		this.messagesContainer = this.element.querySelector('.chat__messages')
		this.observer = new MutationObserver((mutationsList, _) => {
			mutationsList.forEach(mutation => {
				if (mutation.type === 'childList') {
					this.scrollChatToBottom()
				}
			})
		})
		this.observer.observe(this.messagesContainer, { childList: true })
	}

	disconnect() {
		const chatButton = this.element.querySelector('.chat__button')
		chatButton.removeEventListener('click', this.chatSubmitHandler)
	}
}