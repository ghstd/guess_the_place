# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

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
