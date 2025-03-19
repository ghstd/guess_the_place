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
end
