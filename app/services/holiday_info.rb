require 'holiday_service.rb'
class HolidayInfo
  
  def initialize
    @holidays = HolidayService.parse_response
  end

  def holiday_names
    @holidays.filter_map.with_index do |holiday, index|
      holiday[:localName]
    end
  end

  def holiday_dates
    @holidays.filter_map.with_index do |holiday, index|
      holiday[:date]
    end
  end
end