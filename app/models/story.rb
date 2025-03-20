class Story < ApplicationRecord
  has_many :story_questions, dependent: :destroy
  has_many :games, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :author, presence: true
end
