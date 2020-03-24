# frozen_string_literal: true

require 'date'
require_relative './actions_mapper'

class Rental
  include ActionsMapper

  ASSISTANCE_FEE_PER_DAY = 100
  COMMISSION_RATE = 0.3
  INSURANCE_RATE = 0.5

  def initialize(car = Car.new, **options)
    @start_date = options[:start_date]
    @end_date = options[:end_date]
    @id = options[:id]
    @distance = options[:distance]&.to_i
    @car = car
  end

  def to_json
    actions_mapper(id, actions_data)
  end

  private

  attr_reader :id,
              :car,
              :distance,
              :start_date,
              :end_date

  def days
    # `days` are counted inclusively
    @days ||= (Date.parse(start_date)..Date.parse(end_date)).count
  end

  def gross_payment
    (sum_price_per_days + car.price_per_km * distance).to_i
  end

  def count_commission
    {
      insurance_fee: insurance_fee,
      assistance_fee: assistance_fee,
      drivy_fee: drivy_fee
    }
  end

  def commission
    gross_payment * COMMISSION_RATE
  end

  def insurance_fee
    (commission * INSURANCE_RATE).to_i
  end

  def assistance_fee
    ASSISTANCE_FEE_PER_DAY * days
  end

  def drivy_fee
    (commission - insurance_fee - assistance_fee).to_i
  end

  def owner_fee
    (gross_payment - commission).to_i
  end

  def sum_price_per_days
    1.upto(days).inject(0) do |payment, day|
      payment + car.price_per_day * rate(day)
    end
  end

  def rate(day)
    case day
    when 0..1  then 1.0
    when 2..4  then 0.9
    when 5..10 then 0.7
    else 0.5
    end
  end

  def actions_data
    {
      driver: gross_payment,
      owner: owner_fee,
      insurance: insurance_fee,
      assistance: assistance_fee,
      drivy: drivy_fee
    }
  end
end
