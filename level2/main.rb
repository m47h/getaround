#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'date'

# `days` are counted inclusively
def price(rental, car)
  days = (Date.parse(rental[:start_date])..Date.parse(rental[:end_date])).count
  price = sum_price_per_days(days, car[:price_per_day])
  price += car[:price_per_km] * rental[:distance]
  price.to_i
end

def sum_price_per_days(days, price_per_day)
  1.upto(days).inject(0) { |price, day| price + price_per_day * discount(day) }
end

def discount(day)
  return 1.0 if (0..1).include? day
  return 0.9 if (2..4).include? day
  return 0.7 if (5..10).include? day

  0.5
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
