class PagesController < ApplicationController
  before_action :authenticate_user!
  def home
  end

  def rating
    @games = GamesStatistic
      .select("user_id,
              CAST(SUM(answers) * 1.0 / NULLIF(SUM(questions), 0) * 100 AS INTEGER) as accuracy,
              COUNT(user_id) as game_count,
              ROUND(SUM(answers) * 1.0 / NULLIF(SUM(questions), 0) * (1 + LN(COUNT(user_id))), 1) as rating")
      .group("user_id")
      .having("COUNT(user_id) > 1")
      .order(Arel.sql("rating DESC"))
  end

  def projects
    @sotries = Story
      .select("stories.id, name, COUNT(*) as steps")
      .where(author: current_user.id)
      .joins(:story_questions)
      .group(:id)

    @sotries.each do |story|
      story.define_singleton_method(:type) { "Сюжет" }
    end

    @lessons = Lesson
      .select("lessons.id, name, COUNT(*) as steps")
      .where(author: current_user.id)
      .joins(:lesson_questions)
      .group(:id)

    @lessons.each do |lesson|
      lesson.define_singleton_method(:type) { "Квиз" }
    end
  end
end
