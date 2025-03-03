class LessonQuestion < ApplicationRecord
  belongs_to :lesson
  has_many :lesson_answers, dependent: :destroy
end
