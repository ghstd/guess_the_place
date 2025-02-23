import { Controller } from "@hotwired/stimulus"
import consumer from "../lib/consumer"

import { getYouTubeVideoId } from "../lib/utils"

export default class extends Controller {

	initPlayer() {
		if (window.YT) {
			const playerEl = this.element.querySelector('.youtube_player__container')
			this.player = new YT.Player(playerEl, {
				width: '100%',
				height: '100%',
				videoId: '',
				playerVars: {
					autoplay: 0,
					rel: 0
				},
				events: {
					onStateChange: this.onPlayerStateChange.bind(this)
				}
			})
		}
	}

	onPlayerStateChange(event) {
		switch (event.data) {
			case YT.PlayerState.PLAYING:
				if (this.isUserClickOnPlayer) {
					this.subscription.send({
						event: 'play',
						time: this.player.getCurrentTime()
					})
				}
				break;
			case YT.PlayerState.PAUSED:
				if (this.isUserClickOnPlayer) {
					this.subscription.send({
						event: 'stop',
						time: this.player.getCurrentTime()
					})
				}
				break;
			case YT.PlayerState.BUFFERING:
				break;
		}
	}

	playerEventHandler(data) {
		switch (data.event) {
			case 'play':
				this.runPlayer(data.time)
				break
			case 'stop':
				this.stopPlayer(data.time)
				break
			case 'set_video':
				this.setVideo(data.videoId, data.url)
				break
		}
	}

	runPlayer(time) {
		this.isUserClickOnPlayer = false
		this.player.playVideo()
		this.player.seekTo(time)
		setTimeout(() => this.isUserClickOnPlayer = true, 1000)
	}

	stopPlayer(time) {
		const latency = 5
		const currentTime = this.player.getCurrentTime()
		const timeDiff = Math.abs(currentTime - time)

		this.isUserClickOnPlayer = false

		if (timeDiff > latency) {
			this.player.playVideo()
			this.player.seekTo(time)
		} else {
			this.player.pauseVideo()
		}

		setTimeout(() => this.isUserClickOnPlayer = true, 1000)
	}

	setVideo(videoId, url) {
		this.player.cueVideoById(videoId)
		const input = this.element.querySelector('.youtube_player__input')
		input.value = url
	}

	setVideoButtonHandler = () => {
		const input = this.element.querySelector('.youtube_player__input')
		if (!input) return
		const inputValue = input.value.trim()
		input.value = ''
		const videoId = getYouTubeVideoId(inputValue)
		if (!videoId) return

		this.subscription.send({
			event: 'set_video',
			videoId: videoId,
			url: inputValue
		})
	}

	clearButtonHandler = () => {
		const input = this.element.querySelector('.youtube_player__input')
		if (!input) return
		input.value = ''
	}

	connect() {

		this.isUserClickOnPlayer = true

		window.onYouTubeIframeAPIReady = this.initPlayer.bind(this)

		if (!window.YT) {
			const script = document.createElement("script")
			script.src = "https://www.youtube.com/iframe_api"
			document.body.appendChild(script);
		} else {
			this.initPlayer()
		}

		const gameId = document.querySelector('meta[data-game-id]').dataset.gameId
		const playerId = document.querySelector('meta[data-player-id]').dataset.playerId

		this.subscription = consumer.subscriptions.create(
			{
				channel: "YoutubePlayerChannel",
				game_id: gameId,
				player_id: playerId
			},
			{
				received: (data) => this.playerEventHandler(data),
			}
		)

		const sendButton = this.element.querySelector('.player_button__send')
		const clearButton = this.element.querySelector('.player_button__clear')
		sendButton.addEventListener('click', this.setVideoButtonHandler)
		clearButton.addEventListener('click', this.clearButtonHandler)

	}

	disconnect() {
		this.subscription.unsubscribe()
		const sendButton = this.element.querySelector('.player_button__send')
		const clearButton = this.element.querySelector('.player_button__clear')
		sendButton.removeEventListener('click', this.setVideoButtonHandler)
		clearButton.removeEventListener('click', this.clearButtonHandler)
	}
}