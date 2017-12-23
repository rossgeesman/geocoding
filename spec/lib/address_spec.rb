require 'pry'
RSpec.describe Address do
  let(:full_address) { '1  PENNSYLVANIA AVE,  WASHINGTON, DC 20500, United States' }
  let(:lat) { 40.181306 }
  let(:lng) { -80.265949 }
  let(:payload) {
    [ instance_double(
      'Geocoder::Result::GeocoderCa',
      latt: "#{lat}",
      longt: "#{lng}",
      address: full_address )
    ]
  }

  subject(:address) { described_class.new }

  describe('instantiation') do
    it 'can be created with an address and no lat/long' do
      expect(Address.new(lat: lat, lng: lng)).to be_an_instance_of Address
    end
    it 'can be created with lat/long but no address' do
      expect(Address.new(full_address: full_address)).to be_an_instance_of Address
    end
  end

  describe '#geocode!' do
    before :each do
      allow(Geocoder).to receive(:search).and_return(payload)
    end

    context 'when only lat, lng are present' do
      let!(:address) { Address.new(lat: lat, lng: lng)}
      it 'geocodes with Geocoder API' do
        expect(Geocoder).to receive(:search).with([lat, lng])
        address.geocode!
      end
      it 'should set the address string' do
        expect { address.geocode! }
        .to change { address.full_address }
        .from(nil)
        .to("1  PENNSYLVANIA AVE,  WASHINGTON, DC 20500, United States")
      end
    end

    context 'when only an address is present' do
      let!(:address) { Address.new(full_address: full_address) }
      it 'geocodes with Geocoder API' do
        expect(Geocoder).to receive(:search).with(full_address)
        address.geocode!
      end
      it 'should set the lng and lat' do
        expect { address.geocode! }
        .to change { address.coordinates }
        .from(nil)
        .to([lat, lng])
      end
    end
  end

  describe '#miles_to' do
    let(:detroit) { FactoryGirl.build :address, :as_detroit }
    let(:kansas_city) { FactoryGirl.build :address, :as_kansas_city }
    before :each do
      #allow(Geocoder::Calculations).to receive(:distance_between).and_return(1503)
    end

    it 'calculates distance with the Geocoder API' do
      expect(Geocoder::Calculations).to receive(:distance_between).with(address.coordinates, detroit.coordinates)
      address.miles_to(detroit)
    end

    it 'returns the distance between two addresses' do
      expect(detroit.miles_to(kansas_city)).to be > 0
    end
  end
end
