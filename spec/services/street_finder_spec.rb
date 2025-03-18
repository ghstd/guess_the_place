require 'rails_helper'

RSpec.describe StreetFinder, type: :service do
  it "finds street name" do
    coords = [ 48.4392066, 35.1221233 ]
    street_name = StreetFinder.call(coords)

    expect(street_name).to eq("Гаванська вулиця")
  end
end
