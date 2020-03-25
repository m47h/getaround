#!/usr/bin/env ruby
# frozen_string_literal: true

Dir["./../level4/*.rb"].each { |file| require file }
require_relative './rental_json_with_options'
require_relative './rental_with_options'

RentalJsonWithOptions
  .new('data/input.json', rental_klass: RentalWithOptions)
  .to_file('data/output.json')
