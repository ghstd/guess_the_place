class PagesController < ApplicationController
  before_action :authenticate_user!
  def home
  end

  def rating
    @users = User.all
    games = GamesStatistic.all
    @games_1 = games.pluck("user_id").uniq.map do |user_id|
      user_games = games.select { |game| game.user_id == user_id }

      answers = 0
      questions = 0
      user_games.each do |game|
        answers += game.answers
        questions += game.questions
      end
      rating = (answers.to_f / questions.to_f) * (1 + Math.log(user_games.size))
      [
        user_id,
        accuracy = answers.to_f / questions.to_f,
        game_count = user_games.size,
        rating
      ]
    end

    @games_2 = GamesStatistic
    .select("user_id,
            SUM(answers) * 1.0 / NULLIF(SUM(questions), 0) as accuracy,
            COUNT(user_id) as game_count,
            SUM(answers) * 1.0 / NULLIF(SUM(questions), 0) * (1 + LN(COUNT(user_id))) as rating")
    .group("user_id")
    .having("COUNT(user_id) > 1")
    .order(Arel.sql("accuracy * (1 + LN(COUNT(user_id))) DESC"))
  end
end
