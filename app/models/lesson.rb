class Lesson < ApplicationRecord
  has_many :lesson_questions, dependent: :destroy
end
