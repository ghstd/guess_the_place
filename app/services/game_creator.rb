class GameCreator
  def self.call(params, current_user)
    new(params, current_user).call
  end

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def call
    game = Game.new(base_attributes)
    game.game_players.build(user: @current_user, color: Utils::ColorGenerator.get_color(0))
    game.creator = @current_user.short_email

    add_additional_data(game)

    if game.save
      if game.game_type == "Random"
        coords = RandomCoordinate.order(Arel.sql("RANDOM()")).limit(game.steps).pluck("lat", "long")
        coords.each do |coord|
          game.game_coordinates.create(lat: coord[0], long: coord[1])
        end
        game
      else
        game
      end
    else
      nil
    end
  end

  private

  def base_attributes
    {
      name: @params[:name] || "Random",
      game_type: @params[:game_type] || "Random",
      steps: @params[:steps] || 10,
      current_step: 1,
      phase: "lobby"
    }
  end

  def add_additional_data(game)
    if @params[:story_id]
      story = Story.find(@params[:story_id])
      game.story = story
      game.name = story.name
      game.steps = story.story_questions.count
      game.current_question = story.story_questions.first
      game.answer = game.current_question.answer
      game.current_coordinates = game.current_question.coordinates
    end

    if @params[:lesson_id]
      lesson = Lesson.includes(:lesson_questions).find(@params[:lesson_id])
      game.lesson = lesson
      game.name = lesson.name
      game.steps = lesson.lesson_questions.count

      game.lesson_state = build_lesson_state(lesson.lesson_questions.first)
    end
  end

  def build_lesson_state(question)
    answers = question.lesson_answers
    wrong_answers = LessonAnswer
      .where.not(id: answers.pluck(:id))
      .order(Arel.sql("RANDOM()"))
      .limit(rand(3..6))
      .pluck(:id, :content)

    {
      question: question.content,
      image: question.image,
      answer: answers.pluck(:id),
      options: (answers.pluck(:id, :content) + wrong_answers).shuffle
    }
  end
end
