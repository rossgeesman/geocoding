require_relative 'geocoding'

class Address
  attr_accessor :lat, :lng, :full_address, :geocoded, :errors

  def initialize(lat: nil, lng: nil, full_address: nil)
    @lat = lat
    @lng = lng
    @full_address = full_address
    @geocoded = nil
    @errors = []
  end

  def coordinates
    [lat, lng].all? ? [lat, lng] : nil
  end

  def searchable_data
    coordinates || full_address
  end

  def geocode!
    begin
      results = Geocoder.search(searchable_data)
      if results && results.any?
        self.full_address = results[0].address
        self.lat = results[0].latt.to_f
        self.lng = results[0].longt.to_f
        self.geocoded = true
      else
        raise StandardError.new('Address could not be found')
      end
    rescue StandardError => e
      errors << e.message
    end
  end

  def geocoded?
    geocoded
  end

  def miles_to(place)
    Geocoder::Calculations.distance_between(coordinates, place)
  end
end
