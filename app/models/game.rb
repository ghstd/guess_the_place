class Game < ApplicationRecord
  serialize :coords, coder: JSON
  serialize :members, coder: JSON

  has_many :game_players, dependent: :destroy
  has_many :users, through: :game_players
  has_many :game_coordinates, dependent: :destroy

  after_update_commit do
    if saved_change_to_attribute?(:members)
      broadcast_render_to "lobby_#{id}", partial: "games/turbo_stream/update_lobby_members", locals: { game: self }
    end

    if saved_change_to_attribute?(:members)
      broadcast_render_to "games", partial: "games/turbo_stream/update_index_players_quantity", locals: { game: self }
    end

    if saved_change_to_attribute?(:phase)
      case phase
      when "game"
        broadcast_render_to "lobby_#{id}", partial: "games/turbo_stream/add_meta", locals: { game: self }
      when "end"
        broadcast_render_to "game_#{id}", partial: "games/turbo_stream/end_game", locals: { game: self }
      end
    end

    if saved_change_to_attribute?(:current_step)
      coords = game_coordinates.pluck("lat", "long")[current_step - 1]
      street = get_street_by_coords(coords)
      street = normalize_street_name(street)
      update(answer: street)
      set_of_streets = Street.where.not(name: street).order(Arel.sql("RANDOM()")).limit(3).pluck(:name)
      set_of_streets.map! { |street| normalize_street_name(street) }
      set_of_streets.push(street).shuffle!

      broadcast_render_to "game_#{id}", partial: "games/turbo_stream/update_show", locals: {
        game: self,
        coords: coords,
        set_of_streets: set_of_streets
      }
    end
  end

  def all_players_ready?
    game_players.where(ready: false).none?
  end

  def next_step!
    transaction do
      game_players.lock # Блокируем игроков в этой игре
      if all_players_ready?
        if current_step + 1 > steps
          update(phase: "end")
        else
          update(current_step: current_step + 1)
          game_players.each do |game_player|
            count = game_player.current_answer == answer ? 1 : 0
            game_player.update(ready: false, answers: game_player.answers + count)
          end
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
