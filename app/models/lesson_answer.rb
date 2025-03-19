class LessonAnswer < ApplicationRecord
  belongs_to :lesson_question

  validates :content, presence: true
end
