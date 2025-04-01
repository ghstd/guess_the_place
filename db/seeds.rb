# file_path = Rails.root.join('my_temp_files', 'lib', 'random.json')
# json_data = JSON.parse(File.read(file_path))
# json_data.each do |lat, long|
#   RandomCoordinate.create!(lat: lat, long: long)
# end


# file = Rails.root.join("my_temp_files", "lib", "streets.txt")
# File.readlines(file, chomp: true).each do |street|
#   Street.create!(name: street)
# end


# ?
# words = Street.pluck(:name) # Получаем все названия улиц в виде массива строк
# words = words.flat_map { |name| name.split(/\s+/) } # Разбиваем на отдельные слова
# words = words.select { |word| word.match?(/\A[а-яіїєґ]+\z/i) && word == word.downcase } # Оставляем только слова с маленькой буквы
# unique_words = words.uniq # Берем только уникальные слова
# p unique_words
# ?


# file_path = Rails.root.join('my_temp_files', 'lib', 'story_1.json')
# json_data = JSON.parse(File.read(file_path))

# story = Story.create!(name: json_data["name"], visibility: json_data["visibility"], author: json_data["author"])

# json_data["questions"].each do |question|
#   story.story_questions.create!(
#     question: question["question"],
#     answer: question["answer"],
#     options: question["options"],
#     coordinates: question["coordinates"]
#   )
# end


# file_path = Rails.root.join('my_temp_files', 'lib', 'lessons', 'sql.json')
# json_data = JSON.parse(File.read(file_path))

# lesson = Lesson.create!(name: json_data["name"], author: json_data["author"])

# json_data["questions"].each do |question|
#   created_question = lesson.lesson_questions.create!(
#     content: question["content"],
#     image: question["image"]
#   )

#   question["answers"].each do |answer|
#     created_question.lesson_answers.create!(content: answer)
#   end
# end
