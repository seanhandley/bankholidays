require 'httparty'
require 'uri'
require 'icalendar'
require 'date'

module BankHolidays
  
  # Get a list of all bank holidays
  def self.all    
    self.get_dates
  end
  
  # Get the next bank holiday
  def self.next
    self.get_dates.reject { |x| x[:date] < Date.today }.first
  end
  
  private
  
    def self.get_dates
      dates = []

      res = HTTParty.get "https://www.gov.uk/bank-holidays/england-and-wales.ics"
      break if res.code == 404
      ics = Icalendar.parse( res )
      cal = ics.first
      cal.events.each do |e|
        dates << { :date => e.dtstart, :name => e.summary }
      end
    
      dates
    end
    
end