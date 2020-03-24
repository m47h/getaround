#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'date'

# `days` are counted inclusively
def price(rental, car)
  days = (Date.parse(rental[:start_date])..Date.parse(rental[:end_date])).count
  days * car[:price_per_day] + car[:price_per_km] * rental[:distance]
end

input_file = File.read('data/input.json')
json = JSON.parse(input_file, symbolize_names: true)

result = json[:rentals].map do |rental|
  car = json[:cars].select { |c| c[:id] == rental[:car_id] }.first
  { id: rental[:id], price: price(rental, car) }
end

File.open('data/output.json', 'w') do |file|
  file.write(JSON.pretty_generate(rentals: result))
  file.write "\n"
end
