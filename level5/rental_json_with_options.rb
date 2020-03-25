# frozen_string_literal: true

class RentalJsonWithOptions < RentalJson
  private

  def generate_rental_json(rental)
    rental[:options] = extract_options_type(rental)
    super
  end

  def extract_options_type(rental)
    opt = json[:options].select { |o| o[:rental_id] == rental[:id] }
    opt.map { |o| o[:type] }
  end
end
