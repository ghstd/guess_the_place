export function shuffleArray(arr) {
	for (let i = arr.length - 1; i > 0; i--) {
		// Генерация случайного индекса
		const j = Math.floor(Math.random() * (i + 1));
		// Обмен элементов
		[arr[i], arr[j]] = [arr[j], arr[i]];
	}
	return arr;
}
