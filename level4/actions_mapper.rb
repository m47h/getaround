# frozen_string_literal: true

module ActionsMapper
  DEBIT_TYPES = %w[driver]

  def actions_mapper(id, actions)
    { id: id, actions: map_data(actions) }
  end

  def actions_with_options_mapper(id, options, actions)
    { id: id, options: options, actions: map_data(actions) }
  end

  def map_data(actions)
    actions.map do |key, value|
      {
        who: key.to_s,
        type: DEBIT_TYPES.include?(key.to_s) ? 'debit' : 'credit',
        amount: value
      }
    end
  end
end
