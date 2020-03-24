#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'date'

class Car
  attr_reader :id, :price_per_day, :price_per_km

  def initialize(**options)
    @id = options[:id]
    @price_per_day = options[:price_per_day]
    @price_per_km = options[:price_per_km]
  end
end

class Rental
  def initialize(car = Car.new, **options)
    start_date = Date.parse(options[:start_date])
    end_date = Date.parse(options[:end_date])
    # `days` are counted inclusively
    @id = options[:id]
    @days = (start_date..end_date).count
    @distance = options[:distance].to_i
    @car = car
  end

  def as_json
    { id: id, price: gross_payment, commission: count_commission }
  end

  private

  attr_reader :id, :days, :distance, :car

  def gross_payment
    payment = sum_price_per_days + car.price_per_km * distance
    payment.to_i
  end

  def count_commission
    commission = gross_payment * 0.3
    insurance_fee = commission * 0.5
    # README says assistance is 1EUR/day, but output.json count is as 100EUR/day
    assistance_fee = 100 * days
    drivy_fee = commission - insurance_fee - assistance_fee

    {
      insurance_fee: insurance_fee.to_i,
      assistance_fee: assistance_fee.to_i,
      drivy_fee: drivy_fee.to_i
    }
  end

  def sum_price_per_days
    1.upto(days).inject(0) do |payment, day|
      payment + car.price_per_day * discount(day)
    end
  end

  def discount(day)
    return 1.0 if (0..1).include? day
    return 0.9 if (2..4).include? day
    return 0.7 if (5..10).include? day

    0.5
  end
end

class GenerateRentalJsonFromFile
  def initialize(input_file_path)
    input_file = File.read(input_file_path)
    @json = JSON.parse(input_file, symbolize_names: true)
  end

  def to_file(output_file_path)
    File.open(output_file_path, 'w') do |file|
      file.write(JSON.pretty_generate(rentals: output))
      file.write "\n"
    end
  end

  private

  attr_reader :json

  def output
    json[:rentals].map do |rental|
      car_json = json[:cars].select { |c| c[:id] == rental[:car_id] }.first
      car = Car.new(car_json)
      Rental.new(car, rental).as_json
    end
  end
end

GenerateRentalJsonFromFile.new('data/input.json').to_file('data/output.json')
