class RomanNumeralService
  attr_reader :success, :errors, :converted_number

  ROMAN_NUMERAL_VALUES = {
    0 => %w[I V],
    1 => %w[X L],
    2 => %w[C D],
    3 => ['M']
  }.freeze

  def convert_to_roman_numeral(number)
    roman_numeral = []
    number_array = number.to_s.chars

    number_array.reverse_each.with_index do |digit, index|
      if digit.to_i < 4
        roman_numeral.push(ROMAN_NUMERAL_VALUES[index][0] * digit.to_i)
      elsif digit.to_i == 4
        roman_numeral.push(ROMAN_NUMERAL_VALUES[index][0] + ROMAN_NUMERAL_VALUES[index][1])
      elsif digit.to_i == 9
        roman_numeral.push(ROMAN_NUMERAL_VALUES[index][0] + ROMAN_NUMERAL_VALUES[index + 1][0])
      else
        roman_numeral.push(ROMAN_NUMERAL_VALUES[index][1] + (ROMAN_NUMERAL_VALUES[index][0] * (digit.to_i - 5)))
      end
    end

    @converted_number = roman_numeral.reverse.join
    @success = true
  rescue StandardError => e
    @success = false
    @errors = [e.message]
  end
end
