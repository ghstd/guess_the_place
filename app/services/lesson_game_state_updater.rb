class LessonGameStateUpdater
  def self.call(game)
    new(game).call
  end

  def initialize(game)
    @game = game
  end

  def call
    set_state!
    broadcast_render_to "game_#{@game.id}", partial: "games/turbo_stream/update_show_lesson", locals: { game: @game }
  end

  private

  def set_state!
    current_lesson_question = @game.lesson.lesson_questions[@game.current_step - 1]
    answers = current_lesson_question.lesson_answers
    wrong_answers = LessonAnswer
      .where.not(id: answers.pluck(:id))
      .order(Arel.sql("RANDOM()"))
      .limit(rand(3..6))
      .pluck(:id, :content)
    options = (answers.pluck(:id, :content) + wrong_answers).shuffle

    @game.update(lesson_state: {
      question: current_lesson_question.content,
      image: current_lesson_question.image,
      answer: answers.pluck(:id),
      options: options
    })
  end
end
