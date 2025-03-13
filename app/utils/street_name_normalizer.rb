module Utils
  class StreetNameNormalizer
    STREET_TYPES = %w[
      вулиця
      проспект
      шосе
      провулок
      міст
      проїзд
      узвіз
      площа
      обхід
      бульвар
      тупик
      сквер
      алея
      стежка
      вулиц
      провуло
      провул
      каф
    ].freeze

    def self.normalize(street_name)
      match = street_name.match(/\b(#{STREET_TYPES.join("|")})\b/i)
      return street_name unless match

      type = match[0]
      name = street_name.sub(type, "").strip
      "#{type} #{name}"
    end
  end
end
