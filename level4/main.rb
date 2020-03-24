#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require_relative 'car'
require_relative 'rental'
require_relative 'rental_json'

RentalJson
  .new('data/input.json')
  .to_file('data/output.json')
