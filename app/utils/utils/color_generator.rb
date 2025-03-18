module Utils
  class ColorGenerator
    COLORS = %w[#FF5733 #33FF57 #3357FF #F1C40F #9B59B6 #E74C3C].freeze

    def self.get_color(index)
      COLORS[index % COLORS.count]
    end
  end
end
