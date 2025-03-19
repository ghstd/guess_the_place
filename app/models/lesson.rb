class Lesson < ApplicationRecord
  has_many :lesson_questions, dependent: :destroy

  validates :name, presence: true
end
