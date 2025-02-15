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



# file = Rails.root.join("lib", "streets.txt")
# File.readlines(file, chomp: true).each do |street|
#   Street.create!(name: street)
# end



# words = Street.pluck(:name) # Получаем все названия улиц в виде массива строк
# words = words.flat_map { |name| name.split(/\s+/) } # Разбиваем на отдельные слова
# words = words.select { |word| word.match?(/\A[а-яіїєґ]+\z/i) && word == word.downcase } # Оставляем только слова с маленькой буквы
# unique_words = words.uniq # Берем только уникальные слова

# p unique_words
