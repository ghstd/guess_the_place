class StreetFinder
  def self.call(coords)
    uri = URI("https://nominatim.openstreetmap.org/reverse?format=json&lat=#{coords[0]}&lon=#{coords[1]}&accept-language=uk")
    response = Net::HTTP.get(uri)
    JSON.parse(response).dig("address", "road")
  rescue => e
    Rails.logger.error("StreetFinder error: #{e.message}")
    nil
  end
end
