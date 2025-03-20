class Lesson < ApplicationRecord
  has_many :lesson_questions, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :author, presence: true
end
