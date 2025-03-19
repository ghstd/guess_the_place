class ImageUrlValidator
  def self.call(url)
    new(url).call
  end

  def initialize(url)
    @url = url
  end

  def call
    uri = URI.parse(@url)
    return false unless uri.is_a?(URI::HTTPS)

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.head(uri.request_uri)
    end

    response.code.start_with?("2") && response["content-type"]&.start_with?("image/")
  rescue
    false
  end
end
