# [
#   [ 48.451200, 35.056527 ],
#   [ 48.458146, 35.075333 ],
#   [ 48.475750, 35.030955 ],
#   [ 48.445819, 35.018469 ],
#   [ 48.438185, 34.997723 ],
#   [ 48.397259, 35.039891 ]
# ].each do |lat, long|
#   RandomCoordinate.create!(lat: lat, long: long)
# end


# file_path = Rails.root.join('my_temp_files', 'lib', 'random.json')
# json_data = JSON.parse(File.read(file_path))
# json_data.each do |lat, long|
#   RandomCoordinate.create!(lat: lat, long: long)
# end


# file = Rails.root.join("lib", "streets.txt")
# File.readlines(file, chomp: true).each do |street|
#   Street.create!(name: street)
# end



# words = Street.pluck(:name) # Получаем все названия улиц в виде массива строк
# words = words.flat_map { |name| name.split(/\s+/) } # Разбиваем на отдельные слова
# words = words.select { |word| word.match?(/\A[а-яіїєґ]+\z/i) && word == word.downcase } # Оставляем только слова с маленькой буквы
# unique_words = words.uniq # Берем только уникальные слова

# p unique_words


# data = [
#   {
#     name: 'Cюжетная игра 1',
#     questions: [
#       {
#         question: 'вопрос 1',
#         answer: 'ответ 1',
#         options: [ 'ответ 1-1', 'ответ 1-1', 'ответ 1-1' ],
#         coordinates: [ 48.451200, 35.056527 ]
#       },
#       {
#         question: 'вопрос 2',
#         answer: 'ответ 2',
#         options: [ 'ответ 2-2', 'ответ 2-2', 'ответ 2-2' ],
#         coordinates: [ 48.462173, 35.032184 ]
#       }
#     ]
#   },
#   {
#     name: 'Cюжетная игра 2',
#     questions: [
#       {
#         question: 'вопрос 3',
#         answer: 'ответ 1',
#         options: [ 'ответ 1-1', 'ответ 1-1', 'ответ 1-1' ],
#         coordinates: [ 48.451200, 35.056527 ]
#       },
#       {
#         question: 'вопрос 4',
#         answer: 'ответ 2',
#         options: [ 'ответ 2-2', 'ответ 2-2', 'ответ 2-2' ],
#         coordinates: [ 48.462173, 35.032184 ]
#       }
#     ]
#   }
# ]

# data.each do |game|
#   story = Story.create!(name: game[:name])

#   game[:questions].each do |question|
#     story.story_questions.create!(
#       question: question[:question],
#       answer: question[:answer],
#       options: question[:options],
#       coordinates: question[:coordinates]
#     )
#   end
# end

file_path = Rails.root.join('my_temp_files', 'lib', 'story_2.json')
json_data = JSON.parse(File.read(file_path))

story = Story.create!(name: json_data["name"], visibility: json_data["visibility"])

json_data["questions"].each do |question|
  story.story_questions.create!(
    question: question["question"],
    answer: question["answer"],
    options: question["options"],
    coordinates: question["coordinates"]
  )
end
