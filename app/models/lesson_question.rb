class LessonQuestion < ApplicationRecord
  belongs_to :lesson
  has_many :lesson_answers, dependent: :destroy

  validates :content, presence: true
  validate :image_url_must_be_valid, if: -> { image.present? }

  private

  def image_url_must_be_valid
    unless ImageUrlValidator.call(image)
      errors.add(:image, "некорректная ссылка")
    end
  end
end
