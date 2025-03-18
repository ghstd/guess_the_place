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

  def editor_new_story
  end

  def editor_new_lesson
  end

  def editor_create_story
    pp JSON.parse(params["data"].to_json)
  end

  def editor_create_lesson
  end

  def editor_create
    # permitted_params = editor_params
    render json: { redirect_url: editor_path }
  end

  private

  def editor_params
    params.permit(:name, :coordinates, :question, :answer, :option, :mode, :user_id)
  end
end
