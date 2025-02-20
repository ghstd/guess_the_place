class StoryQuestion < ApplicationRecord
  serialize :options, coder: JSON
  serialize :coordinates, coder: JSON

  belongs_to :story
end
