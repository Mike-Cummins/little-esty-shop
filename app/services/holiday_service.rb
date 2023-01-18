require 'json'
require 'httparty'
class HolidayService 

  def self.get_url
    HTTParty.get("https://date.nager.at/api/v3/NextPublicHolidays/US")
  end

  def self.parse_response
    JSON.parse(get_url.body, symbolize_names: true)
  end
end