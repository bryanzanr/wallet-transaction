require 'httparty'

module LatestStockPrice
  BASE_URL = 'https://latest-stock-price.p.rapidapi.com'

  def self.price_all
    response = HTTParty.get("#{BASE_URL}/price_all", headers: headers)
    parse_response(response)
  end

  def self.headers
    {
      "x-rapidapi-host" => "latest-stock-price.p.rapidapi.com",
      "x-rapidapi-key" => ENV['RAPIDAPI_KEY'],
      "Content-Type" => "application/json"
    }
  end

  def self.parse_response(response)
    JSON.parse(response.body)
  end
end
