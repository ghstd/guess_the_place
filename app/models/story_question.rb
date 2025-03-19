class StoryQuestion < ApplicationRecord
  serialize :options, coder: JSON
  serialize :coordinates, coder: JSON

  belongs_to :story

  validates :coordinates, presence: true
  validates :question, presence: true
  validates :answer, presence: true
  validates :options, presence: true
end
