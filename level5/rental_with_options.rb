# frozen_string_literal: true

class RentalWithOptions < Rental
  ADDITIONAL_INSURANCE_FEE_PER_DAY = 1000
  BABY_SEAT_FEE_PER_DAY = 200
  GPS_FEE_PER_DAY = 500

  def initialize(car = Car.new, **options)
    super car, options
    @options = options[:options]
  end

  def to_json
    actions_with_options_mapper(id, options, actions_data)
  end

  private

  attr_reader :options

  def drivy_fee
    fee = super
    fee += additional_insurance_fee if options.include?('additional_insurance')
    fee
  end

  def owner_fee
    fee = super
    fee += gps_fee if options.include?('gps')
    fee += baby_seat_fee if options.include?('baby_seat')
    fee
  end

  def driver_debit
    drivy_fee + owner_fee + insurance_fee + assistance_fee
  end

  def actions_data
    m = super
    m[:driver] = driver_debit
    m
  end

  def gps_fee
    GPS_FEE_PER_DAY * days
  end

  def baby_seat_fee
    BABY_SEAT_FEE_PER_DAY * days
  end

  def additional_insurance_fee
    ADDITIONAL_INSURANCE_FEE_PER_DAY * days
  end
end
