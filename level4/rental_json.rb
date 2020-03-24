# frozen_string_literal: true

class RentalJson
  def initialize(input_file_path, rental_klass: Rental, car_klass: Car)
    @input_file_path = input_file_path
    @rental_klass = rental_klass
    @car_klass = car_klass
  end

  def to_file(output_file_path)
    output = generate_output
    File.open(output_file_path, 'w') do |file|
      file.write(JSON.pretty_generate(output))
      file.write "\n"
    end
  end

  private

  attr_reader :json, :input_file_path, :rental_klass, :car_klass

  def parse_file
    input_file = File.read(input_file_path)
    @json = JSON.parse(input_file, symbolize_names: true)
  end

  def generate_output
    parse_file
    rental_json = json[:rentals].map { |rental| generate_rental_json(rental) }
    { rentals: rental_json }
  end

  def generate_rental_json(rental)
    car_json = json[:cars].select { |c| c[:id] == rental[:car_id] }.first
    car = car_klass.new(car_json)
    rental_klass.new(car, rental).to_json
  end
end
