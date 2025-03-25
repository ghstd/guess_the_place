class RandomGameStateUpdater
  def self.call(game)
    new(game).call
  end

  def initialize(game)
    @game = game
  end

  def call
    set_state!
    @game.broadcast_render_to "game_#{@game.id}", partial: "games/turbo_stream/update_show", locals: { game: @game }
  end

  private

  def set_state!
    coords = @game.game_coordinates.pluck("lat", "long")[@game.current_step - 1]
    street = StreetFinder.call(coords)
    set_of_streets = Street.where.not(name: street).order(Arel.sql("RANDOM()")).limit(3).pluck(:name)
    set_of_streets.push(street).shuffle!
    set_of_streets.map! { |street| Utils::StreetNameNormalizer.normalize(street) }
    @game.update(answer: street, current_coordinates: coords, current_streets: set_of_streets)
  end
end
