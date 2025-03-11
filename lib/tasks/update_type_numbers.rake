# frozen_string_literal: true

namespace :types do
  desc 'Update existing type numbers to new format'
  task update_numbers: :environment do
    Type.find_each do |type|
      old_number = type.type_number
      category_code = case old_number[0]
                      when '1', '2', '3', '9' then old_number[0]
                      else '9'
                      end
      serial_number = old_number[-3..]
      type.update_columns(
        type_number: "#{category_code}#{serial_number}",
        category: Type::CATEGORY_CODES.key(category_code) || 'Other'
      )
    end
    puts 'All type numbers have been updated.'
  end
end
