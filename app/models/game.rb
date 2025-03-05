class Game < ApplicationRecord
  serialize :current_coordinates, coder: JSON
  serialize :current_streets, coder: JSON
  serialize :lesson_state, coder: JSON

  has_many :game_players, dependent: :destroy
  has_many :users, through: :game_players
  has_many :game_coordinates, dependent: :destroy
  has_many :chat_messages, dependent: :destroy

  belongs_to :story, optional: true
  belongs_to :current_question, class_name: "StoryQuestion", optional: true

  belongs_to :lesson, optional: true

  after_create_commit do
    games = Game.where(phase: "lobby")
    broadcast_render_to "games", partial: "games/turbo_stream/add_index_games", locals: { games: games }
  end

  after_update_commit do
    if saved_change_to_attribute?(:phase)
      case phase
      when "game"
        broadcast_render_to "games", partial: "games/turbo_stream/delete_index_games", locals: { game: self }
        broadcast_render_to "lobby_#{id}", partial: "games/turbo_stream/lobby_add_meta", locals: { game: self }
      when "end"
        broadcast_render_to "game_#{id}", partial: "games/turbo_stream/show_end_game", locals: { game: self }

        game_players.each do |game_player|
          GamesStatistic.create!(
            user: game_player.user,
            name: name,
            game_type: game_type,
            questions: steps,
            answers: game_player.answers
          )
        end

        # self.update!(phase: "delete")
      when "delete"
        self.destroy
      end
    end

    if saved_change_to_attribute?(:current_step)
      case game_type
      when "Lesson"
        set_lesson_game_state!
        broadcast_render_to "game_#{id}", partial: "games/turbo_stream/update_show_lesson", locals: { game: self }
      when "Story"
        set_story_game_state!
        broadcast_render_to "game_#{id}", partial: "games/turbo_stream/update_show", locals: { game: self }
      else
        set_game_state!
        broadcast_render_to "game_#{id}", partial: "games/turbo_stream/update_show", locals: { game: self }
      end
    end
  end

  def game_state_exists?
    current_coordinates.present? && current_streets.present?
  end

  def set_game_state!
    coords = game_coordinates.pluck("lat", "long")[current_step - 1]
    street = get_street_by_coords(coords)
    street = normalize_street_name(street)
    set_of_streets = Street.where.not(name: street).order(Arel.sql("RANDOM()")).limit(3).pluck(:name)
    set_of_streets.map! { |street| normalize_street_name(street) }
    set_of_streets.push(street).shuffle!
    update(answer: street, current_coordinates: coords, current_streets: set_of_streets)
  end

  def set_story_game_state!
    next_question = story.story_questions[current_step - 1]
    update(
      current_question: next_question,
      answer: next_question.answer,
      current_coordinates: next_question.coordinates
    )
  end

  def set_lesson_game_state!
    current_lesson_question = lesson.lesson_questions[current_step - 1]
    answers = current_lesson_question.lesson_answers
    wrong_answers = LessonAnswer
      .where.not(id: answers.pluck(:id))
      .order(Arel.sql("RANDOM()"))
      .limit(rand(3..6))
      .pluck(:id, :content)
    options = (answers.pluck(:id, :content) + wrong_answers).shuffle

    update(lesson_state: {
      question: current_lesson_question.content,
      image: current_lesson_question.image,
      answer: answers.pluck(:id),
      options: options
    })
  end

  def all_players_ready?
    game_players.where.not(connection: "offline").where(ready: false).none?
  end

  def next_step!
    transaction do
      game_players.lock # Блокируем игроков в этой игре
      if all_players_ready?
        game_players.each do |game_player|
          if game_type == "Lesson"
            count = game_player.current_answer == lesson_state["answer"].map(&:to_i).sum.to_s ? 1 : 0
          else
            count = game_player.current_answer == answer ? 1 : 0
          end
          game_player.update(ready: false, answers: game_player.answers + count)
        end

        if current_step + 1 > steps
          update(phase: "end")
        else
          update(current_step: current_step + 1)
        end
      end
    end
  end

  def get_street_by_coords(coords)
    uri = URI("https://nominatim.openstreetmap.org/reverse?format=json&lat=#{coords[0]}&lon=#{coords[1]}&accept-language=uk")
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    data["address"]["road"]
  end

  def normalize_street_name(street)
    match = street.match(/\b(вулиця|проспект|шосе|провулок|міст|проїзд|узвіз|площа|обхід|бульвар|тупик|провуло|вулиц|вузиця|сквер|алея|провул|стежка|каф)\b/i)
    street if !match
    type = match[0]
    name = street.sub(type, "").strip
    "#{type} #{name}"
  end
end
