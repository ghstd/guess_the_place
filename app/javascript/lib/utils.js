export function shuffleArray(arr) {
	for (let i = arr.length - 1; i > 0; i--) {
		// Генерация случайного индекса
		const j = Math.floor(Math.random() * (i + 1));
		// Обмен элементов
		[arr[i], arr[j]] = [arr[j], arr[i]];
	}
	return arr;
}

export function getYouTubeVideoId(input) {
	// Регулярное выражение для извлечения video_id
	const regex = /(?:https?:\/\/)?(?:www\.|m\.)?(?:youtube\.com\/(?:watch\?v=|embed\/|v\/)|youtu\.be\/|youtube:\/\/)([a-zA-Z0-9_-]{11})/;
	// Если строка — это сразу ID (11 символов)
	if (/^[a-zA-Z0-9_-]{11}$/.test(input)) {
		return input;
	}
	// Если это ссылка на видео
	const match = input.match(regex);
	return match ? match[1] : null;
}